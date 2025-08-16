import Foundation

// MARK: - Daily City Service Protocol

protocol DailyCityServiceProtocol {
    func getCityForToday() -> City
    func getCityFor(date: Date) -> City
    func getTomorrowsCity() -> City
    func getYesterdaysCity() -> City
    func getRandomCity() -> City
    func getCitySequence(days: Int) -> [(date: String, city: String)]
}

// MARK: - Daily City Service

final class DailyCityService: DailyCityServiceProtocol {
    static let shared = DailyCityService()
    
    // MARK: - Private Properties
    
    private let baseDate = Constants.Game.baseDate
    private let calendar = Calendar.current
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Returns the city for today - same city for all users on the same date
    func getCityForToday() -> City {
        return getCityFor(date: Date())
    }
    
    /// Returns the city for a specific date - useful for testing
    func getCityFor(date: Date) -> City {
        // Calculate days since base date
        let daysSinceBase = calendar.dateComponents([.day], from: baseDate, to: date).day ?? 0
        
        // Use a deterministic algorithm to select city index
        let cityIndex = deterministicCityIndex(for: daysSinceBase)
        
        let cities = City.sampleCities
        return cities[cityIndex % cities.count]
    }
    
    /// Get the next city (for tomorrow) - useful for previewing
    func getTomorrowsCity() -> City {
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) else {
            return getCityForToday()
        }
        return getCityFor(date: tomorrow)
    }
    
    /// Get yesterday's city - useful for checking previous day
    func getYesterdaysCity() -> City {
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) else {
            return getCityForToday()
        }
        return getCityFor(date: yesterday)
    }
    
    /// Get a random city for testing purposes
    func getRandomCity() -> City {
        let cities = City.sampleCities
        return cities.randomElement() ?? cities[0]
    }
    
    // MARK: - Private Methods
    
    /// Deterministic algorithm to convert day number to city index
    /// This ensures the same city for the same date across all devices
    private func deterministicCityIndex(for dayNumber: Int) -> Int {
        // Use a simple but effective algorithm with prime numbers for better distribution
        let hash = (dayNumber * Constants.Game.prime1 + Constants.Game.offset) * Constants.Game.prime2
        return abs(hash) % City.sampleCities.count
    }
    
    /// Debug method to see the city sequence for testing
    func getCitySequence(days: Int) -> [(date: String, city: String)] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        var sequence: [(date: String, city: String)] = []
        
        for i in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: i, to: Date()) else { continue }
            let city = getCityFor(date: date)
            sequence.append((date: formatter.string(from: date), city: city.name))
        }
        
        return sequence
    }
}