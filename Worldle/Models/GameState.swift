import Foundation
import CoreLocation

// MARK: - Game State

/// Represents the current state of the game
struct GameState: Equatable {
    var currentCity: City
    var selectedCoordinate: CLLocationCoordinate2D?
    var isPinPlaced: Bool = false
    var showResult: Bool = false
    var distance: Double = 0
    var score: Int = 0
    var scoreCategory: ScoreCategory = .miss
    var hasPlayedToday: Bool = false
    var isTestingMode: Bool = false
    
    // MARK: - Equatable Conformance
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        return lhs.currentCity == rhs.currentCity &&
               lhs.isPinPlaced == rhs.isPinPlaced &&
               lhs.showResult == rhs.showResult &&
               lhs.distance == rhs.distance &&
               lhs.score == rhs.score &&
               lhs.scoreCategory == rhs.scoreCategory &&
               lhs.hasPlayedToday == rhs.hasPlayedToday &&
               lhs.isTestingMode == rhs.isTestingMode &&
               coordinatesEqual(lhs.selectedCoordinate, rhs.selectedCoordinate)
    }
    
    private static func coordinatesEqual(_ lhs: CLLocationCoordinate2D?, _ rhs: CLLocationCoordinate2D?) -> Bool {
        switch (lhs, rhs) {
        case (nil, nil):
            return true
        case let (lhs?, rhs?):
            return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
        default:
            return false
        }
    }
}

// MARK: - Game State Extensions

extension GameState {
    /// Creates a new game state with the given city
    static func initial(with city: City) -> GameState {
        return GameState(currentCity: city)
    }
    
    /// Resets the game state for a new game
    mutating func reset(with city: City) {
        self.currentCity = city
        self.selectedCoordinate = nil
        self.isPinPlaced = false
        self.showResult = false
        self.distance = 0
        self.score = 0
        self.scoreCategory = .miss
        if !isTestingMode {
            self.hasPlayedToday = false
        }
    }
    
    /// Updates the game state after submitting a guess
    mutating func updateAfterGuess(distance: Double, scoreCategory: ScoreCategory) {
        self.distance = distance
        self.scoreCategory = scoreCategory
        self.score = scoreCategory.points
        self.showResult = true
        if !isTestingMode {
            self.hasPlayedToday = true
        }
    }
}