import Foundation

struct KhmerHoliday: Identifiable, Equatable, Hashable {
    let id: String
    let khmerName: String
    let englishName: String
    let isPublicHoliday: Bool
    let month: Int
    let day: Int
    let year: Int

    var gregorianDate: Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components)
    }

    var formattedDate: String {
        let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        guard month >= 1, month <= 12 else { return "\(day)/\(month)" }
        return "\(monthNames[month - 1]) \(day)"
    }
}
