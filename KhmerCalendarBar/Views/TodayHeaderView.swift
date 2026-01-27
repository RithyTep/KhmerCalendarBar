import SwiftUI

struct TodayHeaderView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top row: Weekday + Status badge
            HStack(alignment: .center) {
                Text(viewModel.todayWeekdayName)
                    .font(.system(size: 16, weight: .bold))

                Spacer()

                StatusBadge(
                    text: viewModel.todayStatusText,
                    isWorking: viewModel.isTodayWorkingDay
                )
            }

            // Khmer lunar date
            Text("\(viewModel.todayKhmerDate.formattedDay) ខែ\(viewModel.todayKhmerDate.month.khmerName)")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(CalendarTheme.accentLight)

            // Animal year + Buddhist era / Gregorian date
            HStack(spacing: 0) {
                Text(viewModel.todayKhmerDate.formattedAnimalAndSak)
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)

                Spacer()

                Text(Date(), style: .date)
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }

            // Next holiday countdown
            if let holiday = viewModel.nextUpcomingHoliday,
               let days = viewModel.daysUntilNextHoliday {
                Divider()
                    .opacity(0.3)
                HStack(spacing: 5) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 10))
                        .foregroundStyle(CalendarTheme.amber)
                    Text("បុណ្យបន្ទាប់:")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Text(holiday.khmerName)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Spacer()
                    Text("\(KhmerNumeralService.toKhmer(days)) ថ្ងៃទៀត")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(CalendarTheme.amber)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(CalendarTheme.accent.opacity(0.15), lineWidth: 0.5)
        )
    }
}

// MARK: - Status Badge

private struct StatusBadge: View {
    let text: String
    let isWorking: Bool

    private var color: Color {
        isWorking ? CalendarTheme.working : CalendarTheme.coral
    }

    private var bgColor: Color {
        isWorking ? CalendarTheme.workingMuted : CalendarTheme.coralMuted
    }

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(bgColor))
    }
}
