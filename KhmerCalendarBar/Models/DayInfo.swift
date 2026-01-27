import Foundation

struct DayInfo: Identifiable, Equatable {
    let id: String
    let gregorianDate: Date
    let gregorianDay: Int
    let gregorianMonth: Int
    let gregorianYear: Int
    let khmerDate: KhmerDate
    let dayOfWeek: Int
    let isCurrentMonth: Bool
    let isToday: Bool
    let holidays: [KhmerHoliday]

    var isPublicHoliday: Bool {
        holidays.contains(where: \.isPublicHoliday)
    }

    var isSunday: Bool {
        dayOfWeek == 1
    }

    var isSaturday: Bool {
        dayOfWeek == 7
    }

    static func == (lhs: DayInfo, rhs: DayInfo) -> Bool {
        lhs.id == rhs.id
    }
}
