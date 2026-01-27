import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)

    var body: some View {
        VStack(spacing: 4) {
            // Weekday headers
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Array(CalendarConstants.weekdayNamesShort.enumerated()), id: \.offset) { _, name in
                    Text(name)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Day grid
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(viewModel.gridDays) { dayInfo in
                    DayCellView(
                        dayInfo: dayInfo,
                        isSelected: viewModel.selectedDayInfo?.id == dayInfo.id
                    )
                    .onTapGesture {
                        viewModel.selectedDayInfo = dayInfo
                    }
                }
            }
        }
    }
}
