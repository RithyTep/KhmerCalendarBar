import SwiftUI

enum MenuBarDisplayFormat: String, CaseIterable, Identifiable {
    case khmerNumeralOnly = "khmerNumeral"
    case khmerAndGregorian = "khmerGregorian"
    case lunarDate = "lunar"
    case khmerFull = "khmerFull"
    case iconOnly = "iconOnly"
    case englishFull = "englishFull"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .khmerNumeralOnly: return "ថ្ងៃទី២៧"
        case .khmerAndGregorian: return "ថ្ងៃទី២៧ / 27"
        case .lunarDate: return "១កើត ពិសាខ"
        case .khmerFull: return "ថ្ងៃទី២៧ មករា"
        case .iconOnly: return "រូបតំណាងតែប៉ុណ្ណោះ"
        case .englishFull: return "Jan 27  21:35"
        }
    }

    var description: String {
        switch self {
        case .khmerNumeralOnly: return "Khmer numeral only"
        case .khmerAndGregorian: return "Khmer + Gregorian"
        case .lunarDate: return "Lunar date"
        case .khmerFull: return "Khmer day + month"
        case .iconOnly: return "Icon only"
        case .englishFull: return "English date + time"
        }
    }
}

final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @AppStorage("menuBarFormat") var menuBarFormat: MenuBarDisplayFormat = .khmerNumeralOnly
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    @AppStorage("holidayNotificationsEnabled") var holidayNotificationsEnabled: Bool = true
    @AppStorage("defaultReminderHour") var defaultReminderHour: Int = 8
    @AppStorage("defaultReminderMinute") var defaultReminderMinute: Int = 0

    var launchAtLogin: Bool {
        get { LaunchAtLoginHelper.isEnabled }
        set { LaunchAtLoginHelper.setEnabled(newValue) }
    }

    private init() {}
}
