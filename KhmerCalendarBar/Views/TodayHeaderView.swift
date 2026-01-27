import SwiftUI

struct TodayHeaderView: View {
    let khmerDate: KhmerDate

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(khmerDate.formattedDay) ខែ\(khmerDate.month.khmerName)")
                .font(.title2)
                .fontWeight(.semibold)

            Text(khmerDate.formattedAnimalAndSak)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(Date(), style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
