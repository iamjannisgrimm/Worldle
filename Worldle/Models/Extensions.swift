import Foundation
import CoreLocation
import SwiftUI

// MARK: - Foundation Extensions

extension DateFormatter {
    /// Formatter for today's date key
    static let todayKey: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    /// Formatter for sharing date display
    static let shareDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Sharing.dateFormat
        return formatter
    }()
}

// MARK: - CoreLocation Extensions

extension CLLocationCoordinate2D: @retroactive Equatable {
    /// Equatable conformance for coordinate comparison
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocation {
    /// Convenience initializer from coordinate
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

// MARK: - UserDefaults Extensions

extension UserDefaults {
    /// Gets the played status for a specific date
    func hasPlayed(on date: Date) -> Bool {
        let dateKey = DateFormatter.todayKey.string(from: date)
        let key = String(format: Constants.UserDefaults.playedKeyFormat, dateKey)
        return bool(forKey: key)
    }
    
    /// Sets the played status for a specific date
    func setPlayed(_ played: Bool, on date: Date) {
        let dateKey = DateFormatter.todayKey.string(from: date)
        let key = String(format: Constants.UserDefaults.playedKeyFormat, dateKey)
        set(played, forKey: key)
    }
}

// MARK: - SwiftUI Extensions

extension Binding {
    /// Creates a read-only binding
    static func readonly<T>(_ value: T) -> Binding<T> {
        return Binding<T>(
            get: { value },
            set: { _ in }
        )
    }
}

// MARK: - String Extensions

extension String {
    /// Formats a distance value for display
    static func formatDistance(_ distance: Double) -> String {
        return String(format: "%.1f km", distance)
    }
    
    /// Formats coordinates for debug display
    static func formatCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        return String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
}

// MARK: - Debug Logging

#if DEBUG
extension String {
    /// Adds emoji prefix for debug logging
    func debugLog(with emoji: String) {
        if Constants.Debug.loggingEnabled {
            print("\(emoji) \(self)")
        }
    }
}
#endif