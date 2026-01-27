import SwiftUI

struct PopoverContentView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Today's Khmer date header
            TodayHeaderView(khmerDate: viewModel.todayKhmerDate)
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .padding(.bottom, 8)

            Divider()

            // Month navigation
            MonthNavigationView(viewModel: viewModel)
                .padding(.horizontal, 12)

            // Calendar grid
            CalendarGridView(viewModel: viewModel)
                .padding(.horizontal, 8)
                .padding(.bottom, 4)

            // Selected day detail
            if let selected = viewModel.selectedDayInfo {
                Divider()
                SelectedDayDetailView(dayInfo: selected) {
                    viewModel.goToToday()
                    viewModel.selectedDayInfo = nil
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }

            Divider()

            // Holidays for this month
            HolidayListView(holidays: viewModel.monthHolidays)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)

            Divider()

            // Footer
            FooterView()
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
    }
}

struct SelectedDayDetailView: View {
    let dayInfo: DayInfo
    var onGoToToday: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(dayInfo.khmerDate.formattedFull)
                    .font(.system(size: 11, weight: .medium))

                Spacer()

                if !dayInfo.isToday {
                    Button("Today") {
                        onGoToToday()
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.accentColor)
                }
            }

            if !dayInfo.holidays.isEmpty {
                ForEach(dayInfo.holidays) { holiday in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(holiday.isPublicHoliday ? .red : .orange)
                            .frame(width: 5, height: 5)
                        Text(holiday.khmerName)
                            .font(.system(size: 10))
                            .foregroundStyle(holiday.isPublicHoliday ? .red : .secondary)
                    }
                }
            }
        }
    }
}
