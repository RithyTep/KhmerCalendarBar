import Foundation
import AppKit
import SwiftUI

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var todayKhmerDate: KhmerDate
    @Published var menuBarText: String = ""
    @Published var menuBarIcon: NSImage?
    @Published var displayedYear: Int
    @Published var displayedMonth: Int
    @Published var gridDays: [DayInfo] = []
    @Published var monthHolidays: [KhmerHoliday] = []
    @Published var selectedDayInfo: DayInfo?
    @Published var navigationDirection: NavigationDirection = .none
    @Published var viewMode: ViewMode = .month
    @Published var showAddReminder = false
    @Published var reminderTargetDay: DayInfo?
    @Published var reminders: [Reminder] = []

    enum ViewMode { case month, year }

    private let engine = ChhankitekEngine.shared
    private let calendar = Calendar.current
    private var midnightTimer: Timer?
    private var minuteTimer: Timer?
    private var lastNotificationYear: Int?
    private var settingsObserver: Any?

    enum NavigationDirection {
        case forward, backward, none
    }

    init() {
        let now = Date()
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)

        self.displayedYear = year
        self.displayedMonth = month
        self.todayKhmerDate = ChhankitekEngine.shared.today()
        self.menuBarText = ""

        updateMenuBarText()
        updateMenuBarIcon()
        buildGrid()
        scheduleMidnightRefresh()
        scheduleMinuteRefresh()
        setupNotifications(year: year)
        observeSettingsChanges()
        loadReminders()
    }

    func navigateMonth(offset: Int) {
        navigationDirection = offset > 0 ? .forward : .backward

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
        selectedDayInfo = nil
        buildGrid()
    }

    func goToToday() {
        let now = Date()
        let targetYear = calendar.component(.year, from: now)
        let targetMonth = calendar.component(.month, from: now)

        if targetYear == displayedYear && targetMonth == displayedMonth {
            return
        }

        let currentKey = displayedYear * 12 + displayedMonth
        let targetKey = targetYear * 12 + targetMonth
        navigationDirection = targetKey > currentKey ? .forward : .backward

        displayedYear = targetYear
        displayedMonth = targetMonth
        buildGrid()
    }

    var monthHeaderText: String {
        DateFormatterService.monthHeader(year: displayedYear, month: displayedMonth)
    }

    var isCurrentMonthDisplayed: Bool {
        let now = Date()
        return displayedYear == calendar.component(.year, from: now)
            && displayedMonth == calendar.component(.month, from: now)
    }

    /// A unique key that changes when month changes, used for animation identity
    var monthKey: String {
        "\(displayedYear)-\(displayedMonth)"
    }

    var workingDaysCount: Int {
        let totalDays = gridDays.filter { $0.isCurrentMonth }.count
        let weekendCount = weekendDaysCount
        // Only count holidays that fall on weekdays (Mon-Fri)
        let weekdayHolidayKeys = Set(
            monthHolidays
                .filter { h in
                    guard h.isPublicHoliday, let date = h.gregorianDate else { return false }
                    let dow = calendar.component(.weekday, from: date)
                    return dow != 1 && dow != 7
                }
                .map { "\($0.month)-\($0.day)" }
        )
        return totalDays - weekendCount - weekdayHolidayKeys.count
    }

    var publicHolidayDaysCount: Int {
        Set(monthHolidays.filter(\.isPublicHoliday).map { "\($0.month)-\($0.day)" }).count
    }

    var weekendDaysCount: Int {
        gridDays.filter { $0.isCurrentMonth && $0.isWeekend }.count
    }

    var nextUpcomingHoliday: KhmerHoliday? {
        let now = Date()
        let year = calendar.component(.year, from: now)
        let allHolidays = HolidayService.holidays(forYear: year)
        let today = calendar.startOfDay(for: now)

        return allHolidays
            .filter { h in
                guard let date = h.gregorianDate else { return false }
                return calendar.startOfDay(for: date) > today
            }
            .sorted { ($0.month * 100 + $0.day) < ($1.month * 100 + $1.day) }
            .first
    }

    var daysUntilNextHoliday: Int? {
        guard let holiday = nextUpcomingHoliday,
              let holidayDate = holiday.gregorianDate else { return nil }
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: holidayDate)
        return calendar.dateComponents([.day], from: today, to: target).day
    }

    var todayStatusText: String {
        let now = Date()
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        let dow = calendar.component(.weekday, from: now)

        let todayHolidays = HolidayService.holidays(forYear: year, month: month, day: day)
        if todayHolidays.contains(where: \.isPublicHoliday) {
            return "ថ្ងៃឈប់សម្រាក"
        }
        if dow == 1 || dow == 7 {
            return "ចុងសប្តាហ៍"
        }
        return "ថ្ងៃធ្វើការ"
    }

    var isTodayWorkingDay: Bool {
        todayStatusText == "ថ្ងៃធ្វើការ"
    }

    var todayWeekdayName: String {
        let dow = calendar.component(.weekday, from: Date()) - 1
        return "ថ្ងៃ" + CalendarConstants.weekdayNames[dow]
    }

    // MARK: - Reminders

    func loadReminders() {
        reminders = ReminderStorage.shared.loadAll()
    }

    func addReminder(_ reminder: Reminder) {
        ReminderStorage.shared.add(reminder)
        reminders = ReminderStorage.shared.loadAll()
        Task {
            await NotificationService.shared.scheduleReminderNotification(reminder)
        }
    }

    func deleteReminder(id: UUID) {
        NotificationService.shared.cancelReminderNotification(id: id)
        ReminderStorage.shared.remove(id: id)
        reminders = ReminderStorage.shared.loadAll()
    }

    func toggleReminder(_ reminder: Reminder) {
        var updated = reminder
        updated.isEnabled.toggle()
        ReminderStorage.shared.update(updated)
        reminders = ReminderStorage.shared.loadAll()

        if updated.isEnabled {
            Task {
                await NotificationService.shared.scheduleReminderNotification(updated)
            }
        } else {
            NotificationService.shared.cancelReminderNotification(id: updated.id)
        }
    }

    func openAddReminder(for dayInfo: DayInfo) {
        reminderTargetDay = dayInfo
        showAddReminder = true
    }

    // MARK: - Year Overview

    struct MiniMonthData: Identifiable {
        let id: Int
        let name: String
        let year: Int
        let firstWeekday: Int
        let totalDays: Int
        let todayDay: Int?
        let holidayDays: Set<Int>
    }

    func buildYearOverview() -> [MiniMonthData] {
        let year = displayedYear
        let holidays = HolidayService.holidays(forYear: year)
        let now = Date()
        let todayYear = calendar.component(.year, from: now)
        let todayMonth = calendar.component(.month, from: now)
        let todayDay = calendar.component(.day, from: now)

        return (1...12).map { month in
            let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            let daysInMonth = calendar.range(of: .day, in: .month, for: firstOfMonth)!.count
            let firstWeekday = calendar.component(.weekday, from: firstOfMonth)

            let holidayDaysInMonth = Set(
                holidays
                    .filter { $0.month == month && $0.isPublicHoliday }
                    .map(\.day)
            )

            let isThisMonth = todayYear == year && todayMonth == month

            return MiniMonthData(
                id: month,
                name: CalendarConstants.solarMonthNames[month - 1],
                year: year,
                firstWeekday: firstWeekday,
                totalDays: daysInMonth,
                todayDay: isThisMonth ? todayDay : nil,
                holidayDays: holidayDaysInMonth
            )
        }
    }

    // MARK: - Private

    private func updateMenuBarText() {
        todayKhmerDate = engine.today()
        let now = Date()
        let day = calendar.component(.day, from: now)
        let month = calendar.component(.month, from: now)
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let format = AppSettings.shared.menuBarFormat

        let timeStr = padKhmer(hour) + ":" + padKhmer(minute)

        let englishTimeStr = String(format: "%02d:%02d", hour, minute)

        switch format {
        case .khmerNumeralOnly:
            menuBarText = "ថ្ងៃទី" + KhmerNumeralService.toKhmer(day) + "  " + timeStr
        case .khmerAndGregorian:
            menuBarText = KhmerNumeralService.toKhmer(day) + " / \(day)" + "  " + timeStr
        case .lunarDate:
            menuBarText = todayKhmerDate.formattedShort + "  " + timeStr
        case .khmerFull:
            let monthName = CalendarConstants.solarMonthNames[month - 1]
            menuBarText = KhmerNumeralService.toKhmer(day) + " " + monthName + "  " + timeStr
        case .iconOnly:
            menuBarText = timeStr
        case .englishFull:
            let fmt = DateFormatter()
            fmt.dateFormat = "MMM d"
            menuBarText = fmt.string(from: now) + "  " + englishTimeStr
        }
    }

    private func padKhmer(_ n: Int) -> String {
        let padded = String(format: "%02d", n)
        return String(padded.map { char in
            CalendarConstants.khmerNumeralMap[char] ?? char
        })
    }

    private func scheduleMinuteRefresh() {
        // Fire every 30s to stay accurate within a minute
        minuteTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateMenuBarText()
            }
        }
    }

    private func observeSettingsChanges() {
        settingsObserver = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateMenuBarText()
                self?.updateMenuBarIcon()
            }
        }
    }

    private func updateMenuBarIcon() {
        let now = Date()
        let day = calendar.component(.day, from: now)
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        let todayHolidays = HolidayService.holidays(forYear: year)
            .filter { $0.month == month && $0.day == day && $0.isPublicHoliday }
        menuBarIcon = MenuBarIconGenerator.generate(day: day, isHoliday: !todayHolidays.isEmpty)
    }

    private func setupNotifications(year: Int) {
        lastNotificationYear = year
        Task {
            let granted = await NotificationService.shared.requestAuthorization()
            if granted {
                await NotificationService.shared.scheduleHolidayNotifications(year: year)
            }
        }
    }

    func buildGrid() {
        let firstOfMonth = calendar.date(from: DateComponents(
            year: displayedYear, month: displayedMonth, day: 1
        ))!

        let daysInMonth = calendar.range(of: .day, in: .month, for: firstOfMonth)!.count
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let startOffset = firstWeekday - 1

        let holidays = HolidayService.holidays(forYear: displayedYear)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        var days: [DayInfo] = []

        if startOffset > 0 {
            let prevDate = calendar.date(byAdding: .month, value: -1, to: firstOfMonth)!
            let prevDaysInMonth = calendar.range(of: .day, in: .month, for: prevDate)!.count
            let prevYear = calendar.component(.year, from: prevDate)
            let prevMonth = calendar.component(.month, from: prevDate)
            let prevHolidays = prevYear != displayedYear
                ? HolidayService.holidays(forYear: prevYear)
                : holidays

            for i in 0..<startOffset {
                let d = prevDaysInMonth - startOffset + 1 + i
                let dayInfo = makeDayInfo(
                    year: prevYear, month: prevMonth, day: d,
                    isCurrentMonth: false, todayComponents: todayComponents,
                    holidays: prevHolidays
                )
                days.append(dayInfo)
            }
        }

        for d in 1...daysInMonth {
            let dayInfo = makeDayInfo(
                year: displayedYear, month: displayedMonth, day: d,
                isCurrentMonth: true, todayComponents: todayComponents,
                holidays: holidays
            )
            days.append(dayInfo)
        }

        let remaining = 42 - days.count
        if remaining > 0 {
            let nextMonth = displayedMonth == 12 ? 1 : displayedMonth + 1
            let nextYear = displayedMonth == 12 ? displayedYear + 1 : displayedYear
            let nextHolidays = nextYear != displayedYear
                ? HolidayService.holidays(forYear: nextYear)
                : holidays

            for d in 1...remaining {
                let dayInfo = makeDayInfo(
                    year: nextYear, month: nextMonth, day: d,
                    isCurrentMonth: false, todayComponents: todayComponents,
                    holidays: nextHolidays
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
        let dow = calendar.component(.weekday, from: date)
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
                self?.updateMenuBarIcon()
                self?.buildGrid()

                let newYear = Calendar.current.component(.year, from: Date())
                if self?.lastNotificationYear != newYear {
                    self?.lastNotificationYear = newYear
                    await NotificationService.shared.scheduleHolidayNotifications(year: newYear)
                }

                self?.scheduleMidnightRefresh()
            }
        }
    }
}
