import Foundation
import CoreLocation

// MARK: - City Model

/// Represents a city with geographical information used in the Worldle game
struct City: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let country: String
    let continent: String
    let coordinate: CLLocationCoordinate2D
    
    // MARK: - Equatable Conformance
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name &&
               lhs.country == rhs.country &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

// MARK: - City Data

extension City {
    /// Collection of cities used in the game
    static let sampleCities: [City] = [
        City(name: "Paris", country: "France", continent: "Europe", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)),
        City(name: "Tokyo", country: "Japan", continent: "Asia", coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)),
        City(name: "New York", country: "United States", continent: "North America", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
        City(name: "London", country: "United Kingdom", continent: "Europe", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)),
        City(name: "Sydney", country: "Australia", continent: "Oceania", coordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)),
        City(name: "Rio de Janeiro", country: "Brazil", continent: "South America", coordinate: CLLocationCoordinate2D(latitude: -22.9068, longitude: -43.1729)),
        City(name: "Cairo", country: "Egypt", continent: "Africa", coordinate: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357)),
        City(name: "Mumbai", country: "India", continent: "Asia", coordinate: CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777)),
        City(name: "Moscow", country: "Russia", continent: "Europe", coordinate: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)),
        City(name: "Cape Town", country: "South Africa", continent: "Africa", coordinate: CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.4241)),
        City(name: "Bangkok", country: "Thailand", continent: "Asia", coordinate: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018)),
        City(name: "Mexico City", country: "Mexico", continent: "North America", coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332)),
        City(name: "Istanbul", country: "Turkey", continent: "Asia", coordinate: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784)),
        City(name: "Beijing", country: "China", continent: "Asia", coordinate: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)),
        City(name: "Lagos", country: "Nigeria", continent: "Africa", coordinate: CLLocationCoordinate2D(latitude: 6.5244, longitude: 3.3792)),
        City(name: "São Paulo", country: "Brazil", continent: "South America", coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)),
        City(name: "Singapore", country: "Singapore", continent: "Asia", coordinate: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198)),
        City(name: "Dubai", country: "United Arab Emirates", continent: "Asia", coordinate: CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708)),
        City(name: "Toronto", country: "Canada", continent: "North America", coordinate: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)),
        City(name: "Buenos Aires", country: "Argentina", continent: "South America", coordinate: CLLocationCoordinate2D(latitude: -34.6118, longitude: -58.3960)),
        City(name: "Reykjavik", country: "Iceland", continent: "Europe", coordinate: CLLocationCoordinate2D(latitude: 64.1466, longitude: -21.9426)),
        City(name: "Perth", country: "Australia", continent: "Oceania", coordinate: CLLocationCoordinate2D(latitude: -31.9505, longitude: 115.8605)),
        City(name: "Anchorage", country: "United States", continent: "North America", coordinate: CLLocationCoordinate2D(latitude: 61.2181, longitude: -149.9003)),
        City(name: "Ushuaia", country: "Argentina", continent: "South America", coordinate: CLLocationCoordinate2D(latitude: -54.8019, longitude: -68.3030))
    ]
}