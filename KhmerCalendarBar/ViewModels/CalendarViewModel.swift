import Foundation
import SwiftUI

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var todayKhmerDate: KhmerDate
    @Published var menuBarText: String = ""
    @Published var displayedYear: Int
    @Published var displayedMonth: Int
    @Published var gridDays: [DayInfo] = []
    @Published var monthHolidays: [KhmerHoliday] = []
    @Published var selectedDayInfo: DayInfo?

    private let engine = ChhankitekEngine.shared
    private let calendar = Calendar.current
    private var midnightTimer: Timer?

    init() {
        let now = Date()
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)

        self.displayedYear = year
        self.displayedMonth = month
        self.todayKhmerDate = ChhankitekEngine.shared.today()
        self.menuBarText = ""

        updateMenuBarText()
        buildGrid()
        scheduleMidnightRefresh()
    }

    func navigateMonth(offset: Int) {
        var newMonth = displayedMonth + offset
        var newYear = displayedYear

        if newMonth > 12 {
            newMonth = 1
            newYear += 1
        } else if newMonth < 1 {
            newMonth = 12
            newYear -= 1
        }

        displayedYear = newYear
        displayedMonth = newMonth
        buildGrid()
    }

    func goToToday() {
        let now = Date()
        displayedYear = calendar.component(.year, from: now)
        displayedMonth = calendar.component(.month, from: now)
        buildGrid()
    }

    var monthHeaderText: String {
        DateFormatterService.monthHeader(year: displayedYear, month: displayedMonth)
    }

    // MARK: - Private

    private func updateMenuBarText() {
        todayKhmerDate = engine.today()
        menuBarText = DateFormatterService.menuBarText(khmerDate: todayKhmerDate)
    }

    private func buildGrid() {
        let firstOfMonth = calendar.date(from: DateComponents(
            year: displayedYear, month: displayedMonth, day: 1
        ))!

        let daysInMonth = calendar.range(of: .day, in: .month, for: firstOfMonth)!.count
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        // weekday: 1=Sun, 7=Sat. We want 0-based offset.
        let startOffset = firstWeekday - 1

        let holidays = HolidayService.holidays(forYear: displayedYear)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        var days: [DayInfo] = []

        // Previous month padding
        if startOffset > 0 {
            let prevDate = calendar.date(byAdding: .month, value: -1, to: firstOfMonth)!
            let prevDaysInMonth = calendar.range(of: .day, in: .month, for: prevDate)!.count
            let prevYear = calendar.component(.year, from: prevDate)
            let prevMonth = calendar.component(.month, from: prevDate)

            for i in 0..<startOffset {
                let d = prevDaysInMonth - startOffset + 1 + i
                let dayInfo = makeDayInfo(
                    year: prevYear, month: prevMonth, day: d,
                    isCurrentMonth: false, todayComponents: todayComponents,
                    holidays: holidays
                )
                days.append(dayInfo)
            }
        }

        // Current month days
        for d in 1...daysInMonth {
            let dayInfo = makeDayInfo(
                year: displayedYear, month: displayedMonth, day: d,
                isCurrentMonth: true, todayComponents: todayComponents,
                holidays: holidays
            )
            days.append(dayInfo)
        }

        // Next month padding (fill to 42 cells = 6 rows)
        let remaining = 42 - days.count
        if remaining > 0 {
            let nextMonth = displayedMonth == 12 ? 1 : displayedMonth + 1
            let nextYear = displayedMonth == 12 ? displayedYear + 1 : displayedYear
            for d in 1...remaining {
                let dayInfo = makeDayInfo(
                    year: nextYear, month: nextMonth, day: d,
                    isCurrentMonth: false, todayComponents: todayComponents,
                    holidays: holidays
                )
                days.append(dayInfo)
            }
        }

        gridDays = days
        monthHolidays = holidays.filter { $0.month == displayedMonth }
    }

    private func makeDayInfo(
        year: Int, month: Int, day: Int,
        isCurrentMonth: Bool,
        todayComponents: DateComponents,
        holidays: [KhmerHoliday]
    ) -> DayInfo {
        let khmerDate = engine.toKhmer(year: year, month: month, day: day)
        let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
        let dow = calendar.component(.weekday, from: date) // 1=Sun
        let isToday = todayComponents.year == year &&
                      todayComponents.month == month &&
                      todayComponents.day == day
        let dayHolidays = holidays.filter { $0.month == month && $0.day == day && $0.year == year }

        return DayInfo(
            id: "\(year)-\(month)-\(day)",
            gregorianDate: date,
            gregorianDay: day,
            gregorianMonth: month,
            gregorianYear: year,
            khmerDate: khmerDate,
            dayOfWeek: dow,
            isCurrentMonth: isCurrentMonth,
            isToday: isToday,
            holidays: dayHolidays
        )
    }

    private func scheduleMidnightRefresh() {
        let now = Date()
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) else {
            return
        }
        let interval = tomorrow.timeIntervalSince(now) + 1

        midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.updateMenuBarText()
                self?.buildGrid()
                self?.scheduleMidnightRefresh()
            }
        }
    }
}
