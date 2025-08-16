import Foundation
import CoreLocation
import Combine

// MARK: - Game View Model

/// Main view model for the Worldle game following MVVM architecture
@MainActor
final class GameViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var gameState: GameState
    
    // MARK: - Computed Properties
    
    var currentCity: City { gameState.currentCity }
    var selectedCoordinate: CLLocationCoordinate2D? { gameState.selectedCoordinate }
    var isPinPlaced: Bool { gameState.isPinPlaced }
    var showResult: Bool { 
        get { gameState.showResult }
        set { gameState.showResult = newValue }
    }
    var distance: Double { gameState.distance }
    var score: Int { gameState.score }
    var scoreCategory: ScoreCategory { gameState.scoreCategory }
    var hasPlayedToday: Bool { gameState.hasPlayedToday }
    var isTestingMode: Bool { gameState.isTestingMode }
    
    // MARK: - Dependencies
    
    private let dailyCityService: DailyCityServiceProtocol
    private let locationService: LocationServiceProtocol
    private let userDefaults: UserDefaults
    
    // MARK: - Initialization
    
    init(
        dailyCityService: DailyCityServiceProtocol = DailyCityService.shared,
        locationService: LocationServiceProtocol = LocationService.shared,
        userDefaults: UserDefaults = .standard
    ) {
        self.dailyCityService = dailyCityService
        self.locationService = locationService
        self.userDefaults = userDefaults
        
        let initialCity = dailyCityService.getCityForToday()
        self.gameState = GameState.initial(with: initialCity)
        
        checkIfPlayedToday()
    }
    
    // MARK: - Public Methods
    
    /// Updates the selected coordinate and pin placement status
    func updateSelectedCoordinate(_ coordinate: CLLocationCoordinate2D) {
        gameState.selectedCoordinate = coordinate
        gameState.isPinPlaced = true
    }
    
    /// Calculates the distance between the selected coordinate and target city
    func calculateDistance() -> Double {
        guard let selected = gameState.selectedCoordinate else { return 0 }
        
        let targetLocation = CLLocation(
            latitude: gameState.currentCity.coordinate.latitude,
            longitude: gameState.currentCity.coordinate.longitude
        )
        let selectedLocation = CLLocation(latitude: selected.latitude, longitude: selected.longitude)
        
        let distanceInMeters = targetLocation.distance(from: selectedLocation)
        return distanceInMeters / 1000
    }
    
    /// Submits the current guess and calculates the score
    func submitGuess() {
        guard !gameState.hasPlayedToday, let selectedCoordinate = gameState.selectedCoordinate else { return }
        
        let distance = calculateDistance()
        
        Task {
            // Determine score category using location service
            let scoreCategory = await locationService.determineScoreCategory(
                distance: distance,
                guessCoordinate: selectedCoordinate,
                targetCity: gameState.currentCity
            )
            
            // Update game state with results
            gameState.updateAfterGuess(distance: distance, scoreCategory: scoreCategory)
            
            // Mark as played if not in testing mode
            if !gameState.isTestingMode {
                markAsPlayedToday()
            }
            
            logGameResult(distance: distance, scoreCategory: scoreCategory, selectedCoordinate: selectedCoordinate)
        }
    }
    
    /// Toggles testing mode
    func toggleTestingMode() {
        gameState.isTestingMode.toggle()
        
        let status = gameState.isTestingMode ? "enabled" : "disabled"
        let emoji = gameState.isTestingMode ? Constants.Debug.testingEmoji : Constants.Debug.lockEmoji
        let restrictions = gameState.isTestingMode ? "disabled" : "enabled"
        
        #if DEBUG
        if Constants.Debug.loggingEnabled {
            print("\(emoji) Testing mode \(status) - daily restrictions \(restrictions)")
        }
        #endif
        
        checkIfPlayedToday()
    }
    
    /// Resets the game for testing purposes
    func resetGame() {
        guard gameState.isTestingMode else { return }
        
        let newCity = dailyCityService.getRandomCity()
        gameState.reset(with: newCity)
        
        #if DEBUG
        if Constants.Debug.loggingEnabled {
            print("\(Constants.Debug.gameEmoji) Game reset - new city: \(newCity.name), \(newCity.country)")
        }
        #endif
    }
    
    // MARK: - Private Methods
    
    private func checkIfPlayedToday() {
        if gameState.isTestingMode {
            gameState.hasPlayedToday = false
            return
        }
        
        let today = todayKey()
        gameState.hasPlayedToday = userDefaults.bool(forKey: "played_\(today)")
    }
    
    private func markAsPlayedToday() {
        guard !gameState.isTestingMode else { return }
        
        let today = todayKey()
        userDefaults.set(true, forKey: "played_\(today)")
        gameState.hasPlayedToday = true
    }
    
    private func todayKey() -> String {
        return DateFormatter.todayKey.string(from: Date())
    }
    
    private func logGameResult(distance: Double, scoreCategory: ScoreCategory, selectedCoordinate: CLLocationCoordinate2D) {
        #if DEBUG
        if Constants.Debug.loggingEnabled {
            print("\(Constants.Debug.targetEmoji) Target: \(gameState.currentCity.name) at \(String.formatCoordinate(gameState.currentCity.coordinate))")
            print("\(Constants.Debug.guessEmoji) Guess: \(String.formatCoordinate(selectedCoordinate))")
            print("\(Constants.Debug.distanceEmoji) Distance: \(String.formatDistance(distance))")
            print("\(Constants.Debug.categoryEmoji) Category: \(scoreCategory.title)")
            print("\(Constants.Debug.scoreEmoji) Score: \(gameState.score)")
        }
        #endif
    }
    
    /// Gets the next city (for tomorrow) - useful for previewing
    func getNextCity() -> City {
        return dailyCityService.getTomorrowsCity()
    }
    
    /// Resets the game for a new day
    func resetForNewDay() {
        let newCity = dailyCityService.getCityForToday()
        gameState.reset(with: newCity)
        checkIfPlayedToday()
        
        #if DEBUG
        if Constants.Debug.loggingEnabled {
            print("\(Constants.Debug.newDayEmoji) New day! Today's city: \(newCity.name), \(newCity.country)")
        }
        #endif
    }
}