import Foundation

enum DateFormatterService {
    /// Format a Gregorian date in Khmer solar month style
    /// e.g. "២៧ មករា ២០២៦"
    static func khmerSolarDate(year: Int, month: Int, day: Int) -> String {
        let khmerDay = KhmerNumeralService.toKhmer(day)
        let monthName = CalendarConstants.solarMonthNames[month - 1]
        let khmerYear = KhmerNumeralService.toKhmer(year)
        return "\(khmerDay) \(monthName) \(khmerYear)"
    }

    /// Format for menu bar: compact Khmer date
    /// e.g. "១៥កើត ពិសាខ"
    static func menuBarText(khmerDate: KhmerDate) -> String {
        return khmerDate.formattedShort
    }

    /// Format Khmer weekday name
    static func khmerWeekday(dayOfWeek: Int) -> String {
        // dayOfWeek: 0=Sun, 6=Sat
        guard dayOfWeek >= 0, dayOfWeek < 7 else { return "" }
        return CalendarConstants.weekdayNames[dayOfWeek]
    }

    /// Format month header for navigation
    /// e.g. "មករា ២០២៦ / January 2026"
    static func monthHeader(year: Int, month: Int) -> String {
        let khmerMonth = CalendarConstants.solarMonthNames[month - 1]
        let khmerYear = KhmerNumeralService.toKhmer(year)

        let gregorianFormatter = DateFormatter()
        gregorianFormatter.dateFormat = "MMMM yyyy"
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let date = Calendar.current.date(from: components) ?? Date()
        let gregorian = gregorianFormatter.string(from: date)

        return "\(khmerMonth) \(khmerYear) / \(gregorian)"
    }
}
