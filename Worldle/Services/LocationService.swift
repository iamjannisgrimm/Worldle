import Foundation
import CoreLocation
import MapKit

// MARK: - Location Service Error

enum LocationServiceError: Error, LocalizedError {
    case reverseGeocodingFailed
    case invalidCoordinate
    
    var errorDescription: String? {
        switch self {
        case .reverseGeocodingFailed:
            return "Failed to determine location information"
        case .invalidCoordinate:
            return "Invalid coordinate provided"
        }
    }
}

// MARK: - Location Service Protocol

protocol LocationServiceProtocol {
    func determineScoreCategory(distance: Double, guessCoordinate: CLLocationCoordinate2D, targetCity: City) async -> ScoreCategory
}

// MARK: - Location Service

final class LocationService: LocationServiceProtocol {
    static let shared = LocationService()
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Determines the score category based on distance and location
    func determineScoreCategory(distance: Double, guessCoordinate: CLLocationCoordinate2D, targetCity: City) async -> ScoreCategory {
        // Validate input
        guard CLLocationCoordinate2DIsValid(guessCoordinate) else {
            return .miss
        }
        
        // Check distance-based categories first (most accurate)
        if distance <= Constants.Game.perfectDistanceThreshold {
            return .perfect
        } else if distance <= Constants.Game.excellentDistanceThreshold {
            return .excellent
        }
        
        // Check location-based categories using reverse geocoding
        do {
            let guessLocation = try await reverseGeocode(coordinate: guessCoordinate)
            
            #if DEBUG
            if Constants.Debug.loggingEnabled {
                print("🌍 Reverse geocoding result:")
                print("  📍 Coordinates: \(String.formatCoordinate(guessCoordinate))")
                print("  🏠 Country: \(guessLocation?.country ?? "unknown")")
                print("  🌎 Detected continent: \(getContinent(for: guessLocation) ?? "unknown")")
                print("  🎯 Target city: \(targetCity.name), \(targetCity.country) (\(targetCity.continent))")
            }
            #endif
            
            if let guessCountry = guessLocation?.country,
               guessCountry.lowercased() == targetCity.country.lowercased() {
                return .sameCountry
            }
            
            if let guessContinent = getContinent(for: guessLocation),
               guessContinent.lowercased() == targetCity.continent.lowercased() {
                return .sameContinent
            }
        } catch {
            // If reverse geocoding fails, fall back to miss
            print("⚠️ Reverse geocoding failed: \(error.localizedDescription)")
        }
        
        return .miss
    }
    
    // MARK: - Private Methods
    
    /// Reverse geocode a coordinate to get location information
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) async throws -> CLPlacemark? {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            return placemarks.first
        } catch {
            throw LocationServiceError.reverseGeocodingFailed
        }
    }
    
    /// Map country to continent using comprehensive mapping and geographic bounds
    private func getContinent(for placemark: CLPlacemark?) -> String? {
        guard let country = placemark?.country else { return nil }
        
        // First, try exact country name matching with comprehensive continent mapping
        let continentMap: [String: String] = [
            // Europe
            "Albania": "Europe", "Andorra": "Europe", "Austria": "Europe", "Belarus": "Europe", 
            "Belgium": "Europe", "Bosnia and Herzegovina": "Europe", "Bulgaria": "Europe", "Croatia": "Europe",
            "Czech Republic": "Europe", "Denmark": "Europe", "Estonia": "Europe", "Finland": "Europe",
            "France": "Europe", "Germany": "Europe", "Greece": "Europe", "Hungary": "Europe",
            "Iceland": "Europe", "Ireland": "Europe", "Italy": "Europe", "Latvia": "Europe",
            "Lithuania": "Europe", "Luxembourg": "Europe", "Malta": "Europe", "Moldova": "Europe",
            "Monaco": "Europe", "Montenegro": "Europe", "Netherlands": "Europe", "North Macedonia": "Europe",
            "Norway": "Europe", "Poland": "Europe", "Portugal": "Europe", "Romania": "Europe",
            "Russia": "Europe", "San Marino": "Europe", "Serbia": "Europe", "Slovakia": "Europe",
            "Slovenia": "Europe", "Spain": "Europe", "Sweden": "Europe", "Switzerland": "Europe",
            "Ukraine": "Europe", "United Kingdom": "Europe", "Vatican City": "Europe",
            
            // Asia
            "Afghanistan": "Asia", "Armenia": "Asia", "Azerbaijan": "Asia", "Bahrain": "Asia",
            "Bangladesh": "Asia", "Bhutan": "Asia", "Brunei": "Asia", "Cambodia": "Asia",
            "China": "Asia", "Cyprus": "Asia", "Georgia": "Asia", "India": "Asia",
            "Indonesia": "Asia", "Iran": "Asia", "Iraq": "Asia", "Israel": "Asia",
            "Japan": "Asia", "Jordan": "Asia", "Kazakhstan": "Asia", "Kuwait": "Asia",
            "Kyrgyzstan": "Asia", "Laos": "Asia", "Lebanon": "Asia", "Malaysia": "Asia",
            "Maldives": "Asia", "Mongolia": "Asia", "Myanmar": "Asia", "Nepal": "Asia",
            "North Korea": "Asia", "Oman": "Asia", "Pakistan": "Asia", "Palestine": "Asia",
            "Philippines": "Asia", "Qatar": "Asia", "Saudi Arabia": "Asia", "Singapore": "Asia",
            "South Korea": "Asia", "Sri Lanka": "Asia", "Syria": "Asia", "Taiwan": "Asia",
            "Tajikistan": "Asia", "Thailand": "Asia", "Timor-Leste": "Asia", "Turkey": "Asia",
            "Turkmenistan": "Asia", "United Arab Emirates": "Asia", "Uzbekistan": "Asia", "Vietnam": "Asia", "Yemen": "Asia",
            
            // Africa
            "Algeria": "Africa", "Angola": "Africa", "Benin": "Africa", "Botswana": "Africa",
            "Burkina Faso": "Africa", "Burundi": "Africa", "Cameroon": "Africa", "Cape Verde": "Africa",
            "Central African Republic": "Africa", "Chad": "Africa", "Comoros": "Africa", "Congo": "Africa",
            "Democratic Republic of the Congo": "Africa", "Djibouti": "Africa", "Egypt": "Africa", "Equatorial Guinea": "Africa",
            "Eritrea": "Africa", "Eswatini": "Africa", "Ethiopia": "Africa", "Gabon": "Africa",
            "Gambia": "Africa", "Ghana": "Africa", "Guinea": "Africa", "Guinea-Bissau": "Africa",
            "Ivory Coast": "Africa", "Kenya": "Africa", "Lesotho": "Africa", "Liberia": "Africa",
            "Libya": "Africa", "Madagascar": "Africa", "Malawi": "Africa", "Mali": "Africa",
            "Mauritania": "Africa", "Mauritius": "Africa", "Morocco": "Africa", "Mozambique": "Africa",
            "Namibia": "Africa", "Niger": "Africa", "Nigeria": "Africa", "Rwanda": "Africa",
            "São Tomé and Príncipe": "Africa", "Senegal": "Africa", "Seychelles": "Africa", "Sierra Leone": "Africa",
            "Somalia": "Africa", "South Africa": "Africa", "South Sudan": "Africa", "Sudan": "Africa",
            "Tanzania": "Africa", "Togo": "Africa", "Tunisia": "Africa", "Uganda": "Africa", "Zambia": "Africa", "Zimbabwe": "Africa",
            
            // North America
            "Antigua and Barbuda": "North America", "Bahamas": "North America", "Barbados": "North America", "Belize": "North America",
            "Canada": "North America", "Costa Rica": "North America", "Cuba": "North America", "Dominica": "North America",
            "Dominican Republic": "North America", "El Salvador": "North America", "Grenada": "North America", "Guatemala": "North America",
            "Haiti": "North America", "Honduras": "North America", "Jamaica": "North America", "Mexico": "North America",
            "Nicaragua": "North America", "Panama": "North America", "Saint Kitts and Nevis": "North America", "Saint Lucia": "North America",
            "Saint Vincent and the Grenadines": "North America", "Trinidad and Tobago": "North America", "United States": "North America",
            
            // South America
            "Argentina": "South America", "Bolivia": "South America", "Brazil": "South America", "Chile": "South America",
            "Colombia": "South America", "Ecuador": "South America", "Guyana": "South America", "Paraguay": "South America",
            "Peru": "South America", "Suriname": "South America", "Uruguay": "South America", "Venezuela": "South America",
            
            // Oceania
            "Australia": "Oceania", "Fiji": "Oceania", "Kiribati": "Oceania", "Marshall Islands": "Oceania",
            "Micronesia": "Oceania", "Nauru": "Oceania", "New Zealand": "Oceania", "Palau": "Oceania",
            "Papua New Guinea": "Oceania", "Samoa": "Oceania", "Solomon Islands": "Oceania", "Tonga": "Oceania",
            "Tuvalu": "Oceania", "Vanuatu": "Oceania"
        ]
        
        // Try exact match first
        if let continent = continentMap[country] {
            return continent
        }
        
        // If exact match fails, try alternative country name formats and fallback to geographic bounds
        return getContinentByGeographicBounds(for: placemark) ?? continentMap[country.lowercased()]
    }
    
    /// Fallback method to determine continent by geographic coordinates
    private func getContinentByGeographicBounds(for placemark: CLPlacemark?) -> String? {
        guard let location = placemark?.location else { return nil }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Geographic bounds for continents (approximate)
        switch (latitude, longitude) {
        case let (lat, lon) where lat >= 35 && lat <= 71 && lon >= -25 && lon <= 40:
            return "Europe"
        case let (lat, lon) where lat >= -35 && lat <= 81 && lon >= 25 && lon <= 180:
            return "Asia"
        case let (lat, lon) where lat >= -35 && lat <= 37 && lon >= -20 && lon <= 52:
            return "Africa"
        case let (lat, lon) where lat >= 5 && lat <= 83 && lon >= -180 && lon <= -30:
            return "North America"
        case let (lat, lon) where lat >= -60 && lat <= 15 && lon >= -85 && lon <= -30:
            return "South America"
        case let (lat, lon) where lat >= -50 && lat <= -5 && lon >= 110 && lon <= 180:
            return "Oceania"
        default:
            return nil
        }
    }
}