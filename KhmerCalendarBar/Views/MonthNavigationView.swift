import SwiftUI

struct MonthNavigationView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        HStack(spacing: 6) {
            NavButton(systemName: "chevron.left") {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.navigateMonth(offset: -1)
                }
            }

            Spacer()

            // Two-line month header
            VStack(spacing: 2) {
                Text(khmerMonthYear)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(CalendarTheme.accent)
                    .lineLimit(1)
                Text(gregorianMonthYear)
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
            .contentTransition(.numericText())

            Spacer()

            // Today button
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.goToToday()
                    viewModel.selectedDayInfo = nil
                }
            }) {
                Image(systemName: viewModel.isCurrentMonthDisplayed ? "calendar" : "calendar.circle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(viewModel.isCurrentMonthDisplayed ? Color.secondary.opacity(0.4) : CalendarTheme.accent)
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(viewModel.isCurrentMonthDisplayed)
            .help("ទៅថ្ងៃនេះ (T)")

            NavButton(systemName: "chevron.right") {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.navigateMonth(offset: 1)
                }
            }
        }
    }

    private var khmerMonthYear: String {
        let monthName = CalendarConstants.solarMonthNames[viewModel.displayedMonth - 1]
        let year = KhmerNumeralService.toKhmer(viewModel.displayedYear)
        return "\(monthName) \(year)"
    }

    private var gregorianMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        var components = DateComponents()
        components.year = viewModel.displayedYear
        components.month = viewModel.displayedMonth
        components.day = 1
        let date = Calendar.current.date(from: components) ?? Date()
        return formatter.string(from: date)
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Nav Button

private struct NavButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(CalendarTheme.accent)
                .frame(width: 28, height: 28)
                .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
