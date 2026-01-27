import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 7)

    var body: some View {
        VStack(spacing: 4) {
            // Weekday headers
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(Array(CalendarConstants.weekdayNamesShort.enumerated()), id: \.offset) { index, name in
                    Text(name)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(weekdayHeaderColor(index: index))
                        .frame(maxWidth: .infinity)
                }
            }

            Divider()
                .opacity(0.4)

            // Day grid with slide transition
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(viewModel.gridDays) { dayInfo in
                    DayCellView(
                        dayInfo: dayInfo,
                        isSelected: viewModel.selectedDayInfo?.id == dayInfo.id
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            if viewModel.selectedDayInfo?.id == dayInfo.id {
                                viewModel.selectedDayInfo = nil
                            } else {
                                viewModel.selectedDayInfo = dayInfo
                            }
                        }
                    }
                }
            }
            .id(viewModel.monthKey)
            .transition(monthTransition)
        }
    }

    private var monthTransition: AnyTransition {
        switch viewModel.navigationDirection {
        case .forward:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .backward:
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        case .none:
            return .opacity
        }
    }

    private func weekdayHeaderColor(index: Int) -> Color {
        if index == 0 { return CalendarTheme.sunday.opacity(0.75) }
        if index == 6 { return CalendarTheme.saturday.opacity(0.65) }
        return CalendarTheme.accent.opacity(0.5)
    }
}
