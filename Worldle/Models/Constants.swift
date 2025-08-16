import Foundation

// MARK: - App Constants

/// Application-wide constants and configuration values
enum Constants {
    
    // MARK: - Game Configuration
    
    enum Game {
        /// Distance threshold for perfect score (in kilometers)
        static let perfectDistanceThreshold: Double = 15
        
        /// Distance threshold for excellent score (in kilometers)
        static let excellentDistanceThreshold: Double = 100
        
        /// Base date for deterministic city calculation
        static let baseDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        
        /// Prime numbers used in city selection algorithm
        static let prime1 = 31
        static let prime2 = 17
        static let offset = 7
    }
    
    // MARK: - User Defaults Keys
    
    enum UserDefaults {
        /// Key format for tracking daily play status
        static let playedKeyFormat = "played_%@"
        
        /// Key for testing mode preference
        static let testingModeKey = "testing_mode_enabled"
    }
    
    // MARK: - UI Configuration
    
    enum UI {
        /// Default map coordinate span for maximum zoom out
        static let maxCoordinateSpan = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
        
        /// Default map center coordinate
        static let defaultMapCenter = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        /// Animation duration for UI transitions
        static let animationDuration: Double = 0.3
        
        /// Target view size for result display
        static let targetViewSize: CGFloat = 300
    }
    
    // MARK: - Sharing
    
    enum Sharing {
        /// App name for sharing
        static let appName = "Worldle"
        
        /// Date format for sharing
        static let dateFormat = "MMM d, yyyy"
        
        /// Attribution text for shares
        static let attribution = "🌍 Generated with Worldle"
    }
    
    // MARK: - Debug
    
    enum Debug {
        /// Enable debug logging
        static let loggingEnabled = true
        
        /// Debug emoji prefixes
        static let targetEmoji = "🎯"
        static let guessEmoji = "📍"
        static let distanceEmoji = "📏"
        static let categoryEmoji = "🎖️"
        static let scoreEmoji = "🏆"
        static let testingEmoji = "🧪"
        static let lockEmoji = "🔒"
        static let gameEmoji = "🎮"
        static let newDayEmoji = "🌅"
    }
}

// MARK: - MapKit Extensions

import MapKit
import CoreLocation

extension Constants.UI {
    /// Creates the default map region for maximum zoom out
    static var defaultMapRegion: MKCoordinateRegion {
        return MKCoordinateRegion(
            center: defaultMapCenter,
            span: maxCoordinateSpan
        )
    }
}