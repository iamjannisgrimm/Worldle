import SwiftUI

// MARK: - Score Category

/// Represents the different scoring categories based on guess accuracy
enum ScoreCategory: CaseIterable {
    case perfect        // Within 15km
    case excellent      // Within 100km
    case sameCountry    // Within country
    case sameContinent  // Within continent
    case miss           // None of the above
}

// MARK: - ScoreCategory Properties

extension ScoreCategory {
    /// Display title for the score category
    var title: String {
        switch self {
        case .perfect:
            return "Perfect!"
        case .excellent:
            return "Excellent!"
        case .sameCountry:
            return "Same Country"
        case .sameContinent:
            return "Same Continent"
        case .miss:
            return "Miss"
        }
    }
    
    /// Detailed description of the score category
    var description: String {
        switch self {
        case .perfect:
            return "Within 15km"
        case .excellent:
            return "Within 100km"
        case .sameCountry:
            return "Correct Country"
        case .sameContinent:
            return "Correct Continent"
        case .miss:
            return "Wrong Continent"
        }
    }
    
    /// Color associated with the score category
    var color: Color {
        switch self {
        case .perfect:
            return .green
        case .excellent:
            return .blue
        case .sameCountry:
            return .orange
        case .sameContinent:
            return .yellow
        case .miss:
            return .red
        }
    }
    
    /// Ring position for target visualization (0.0 = center, 1.0 = outermost)
    var ringPosition: CGFloat {
        switch self {
        case .perfect:
            return 0.2
        case .excellent:
            return 0.4
        case .sameCountry:
            return 0.6
        case .sameContinent:
            return 0.8
        case .miss:
            return 1.0
        }
    }
    
    /// Points awarded for this score category
    var points: Int {
        switch self {
        case .perfect:
            return 5000
        case .excellent:
            return 3000
        case .sameCountry:
            return 1500
        case .sameContinent:
            return 500
        case .miss:
            return 100
        }
    }
    
    /// Emoji representation for sharing
    var emoji: String {
        switch self {
        case .perfect:
            return "🟢"
        case .excellent:
            return "🔵"
        case .sameCountry:
            return "🟠"
        case .sameContinent:
            return "🟡"
        case .miss:
            return "🔴"
        }
    }
    
    /// Percentage representation for sharing
    var percentage: String {
        switch self {
        case .perfect:
            return "100%"
        case .excellent:
            return "80%"
        case .sameCountry:
            return "60%"
        case .sameContinent:
            return "40%"
        case .miss:
            return "20%"
        }
    }
}