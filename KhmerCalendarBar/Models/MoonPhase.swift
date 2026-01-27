import Foundation

enum MoonPhase: Int, CaseIterable, Identifiable {
    case waxing = 0
    case waning = 1

    var id: Int { rawValue }

    var khmerName: String {
        switch self {
        case .waxing: return "កើត"
        case .waning: return "រោច"
        }
    }

    var khmerAbbreviation: String {
        switch self {
        case .waxing: return "ក"
        case .waning: return "រ"
        }
    }
}
