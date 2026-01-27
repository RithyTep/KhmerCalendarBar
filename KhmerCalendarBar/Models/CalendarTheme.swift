import SwiftUI

/// Modern Dark Teal theme for KhmerCalendarBar
enum CalendarTheme {
    // MARK: - Primary Accent (Teal)
    static let accent = Color(red: 0.18, green: 0.58, blue: 0.58)        // #2E9494
    static let accentLight = Color(red: 0.22, green: 0.68, blue: 0.68)   // #38ADAD
    static let accentMuted = Color(red: 0.18, green: 0.58, blue: 0.58).opacity(0.15)

    // MARK: - Warm Amber (highlights, countdowns)
    static let amber = Color(red: 0.85, green: 0.62, blue: 0.24)         // #D99E3D
    static let amberMuted = Color(red: 0.85, green: 0.62, blue: 0.24).opacity(0.12)

    // MARK: - Holiday / Day Off (warm coral)
    static let coral = Color(red: 0.87, green: 0.38, blue: 0.32)         // #DE6152
    static let coralMuted = Color(red: 0.87, green: 0.38, blue: 0.32).opacity(0.12)

    // MARK: - Working day (soft teal-green)
    static let working = Color(red: 0.22, green: 0.68, blue: 0.56)       // #38AD8F
    static let workingMuted = Color(red: 0.22, green: 0.68, blue: 0.56).opacity(0.12)

    // MARK: - Weekend (muted indigo-blue)
    static let weekend = Color(red: 0.42, green: 0.52, blue: 0.78)       // #6B85C7
    static let weekendMuted = Color(red: 0.42, green: 0.52, blue: 0.78).opacity(0.12)

    // MARK: - Sunday (warmer red than coral)
    static let sunday = Color(red: 0.82, green: 0.30, blue: 0.30)        // #D14D4D

    // MARK: - Saturday
    static let saturday = Color(red: 0.42, green: 0.55, blue: 0.82)      // #6B8CD1

    // MARK: - Surfaces
    static let cardBorder = Color.white.opacity(0.08)
    static let hoverBg = Color.white.opacity(0.06)
    static let selectedBg = Color(red: 0.18, green: 0.58, blue: 0.58).opacity(0.12)
    static let selectedBorder = Color(red: 0.18, green: 0.58, blue: 0.58).opacity(0.45)
}
