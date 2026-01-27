import SwiftUI

struct MonthNavigationView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        HStack {
            Button(action: { viewModel.navigateMonth(offset: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.caption)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(viewModel.monthHeaderText)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(1)

            Spacer()

            Button(action: { viewModel.navigateMonth(offset: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
