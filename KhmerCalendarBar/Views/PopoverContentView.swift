import SwiftUI

struct PopoverContentView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Today Header
            TodayHeaderView(viewModel: viewModel)
                .padding(.horizontal, 8)
                .padding(.bottom, 10)

            Divider()
                .padding(.horizontal, 8)

            // Month Navigation
            MonthNavigationView(viewModel: viewModel)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)

            // Calendar Grid
            CalendarGridView(viewModel: viewModel)
                .padding(.horizontal, 8)

            // Selected Day Detail
            if let selected = viewModel.selectedDayInfo {
                SelectedDayDetailView(dayInfo: selected)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .scale(scale: 0.95).combined(with: .opacity)
                        )
                    )
            }

            Divider()
                .padding(.horizontal, 8)
                .padding(.top, 8)

            // Holiday List
            HolidayListView(holidays: viewModel.monthHolidays)
                .padding(.horizontal, 8)
                .padding(.top, 8)

            Divider()
                .padding(.horizontal, 8)
                .padding(.top, 8)

            // Footer
            FooterView()
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
        }
        .padding(8)
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: viewModel.selectedDayInfo?.id)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.monthKey)
        .onAppear {
            viewModel.goToToday()
        }
        .onKeyPress(.leftArrow) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.navigateMonth(offset: -1)
            }
            return .handled
        }
        .onKeyPress(.rightArrow) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.navigateMonth(offset: 1)
            }
            return .handled
        }
        .onKeyPress(characters: CharacterSet(charactersIn: "tT")) { _ in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.goToToday()
                viewModel.selectedDayInfo = nil
            }
            return .handled
        }
        .onKeyPress(.escape) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                viewModel.selectedDayInfo = nil
            }
            return .handled
        }
    }
}

// MARK: - Selected Day Detail

struct SelectedDayDetailView: View {
    let dayInfo: DayInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Weekday + status
            HStack(spacing: 6) {
                let dowIndex = dayInfo.dayOfWeek - 1
                Text("ថ្ងៃ\(CalendarConstants.weekdayNames[dowIndex])")
                    .font(.system(size: 11, weight: .semibold))

                Spacer()

                if dayInfo.isPublicHoliday {
                    DayStatusPill(text: "ថ្ងៃឈប់សម្រាក", color: CalendarTheme.coral, bgColor: CalendarTheme.coralMuted)
                } else if dayInfo.isWeekend {
                    DayStatusPill(text: "ចុងសប្តាហ៍", color: CalendarTheme.weekend, bgColor: CalendarTheme.weekendMuted)
                } else {
                    DayStatusPill(text: "ថ្ងៃធ្វើការ", color: CalendarTheme.working, bgColor: CalendarTheme.workingMuted)
                }
            }

            Text(dayInfo.khmerDate.formattedFull)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            Text(formattedGregorian)
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)

            if !dayInfo.holidays.isEmpty {
                ForEach(dayInfo.holidays) { holiday in
                    HStack(spacing: 5) {
                        Circle()
                            .fill(holiday.isPublicHoliday ? CalendarTheme.coral : CalendarTheme.amber)
                            .frame(width: 5, height: 5)
                        Text(holiday.khmerName)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(holiday.isPublicHoliday ? CalendarTheme.coral : .primary)
                        if !holiday.englishName.isEmpty {
                            Text("(\(holiday.englishName))")
                                .font(.system(size: 9))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(CalendarTheme.accent.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(CalendarTheme.accent.opacity(0.12), lineWidth: 0.5)
        )
    }

    private var formattedGregorian: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .long
        return fmt.string(from: dayInfo.gregorianDate)
    }
}

// MARK: - Day Status Pill

private struct DayStatusPill: View {
    let text: String
    let color: Color
    let bgColor: Color

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .medium))
            .foregroundStyle(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Capsule().fill(bgColor))
    }
}

// MARK: - Monthly Summary

struct MonthlySummaryView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        HStack(spacing: 8) {
            SummaryBadge(
                icon: "briefcase.fill",
                label: "ថ្ងៃធ្វើការ",
                value: KhmerNumeralService.toKhmer(viewModel.workingDaysCount),
                color: CalendarTheme.working,
                bgColor: CalendarTheme.workingMuted
            )

            SummaryBadge(
                icon: "star.fill",
                label: "ថ្ងៃបុណ្យ",
                value: KhmerNumeralService.toKhmer(viewModel.publicHolidayDaysCount),
                color: CalendarTheme.coral,
                bgColor: CalendarTheme.coralMuted
            )

            SummaryBadge(
                icon: "sun.max.fill",
                label: "ចុងសប្តាហ៍",
                value: KhmerNumeralService.toKhmer(viewModel.weekendDaysCount),
                color: CalendarTheme.amber,
                bgColor: CalendarTheme.amberMuted
            )
        }
    }
}

private struct SummaryBadge: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let bgColor: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 9))
                    .foregroundStyle(color)
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                    .contentTransition(.numericText())
            }
            Text(label)
                .font(.system(size: 9))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(bgColor)
        )
    }
}
