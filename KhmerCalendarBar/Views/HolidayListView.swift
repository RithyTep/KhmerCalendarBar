import SwiftUI

struct HolidayListView: View {
    let holidays: [KhmerHoliday]

    var body: some View {
        if holidays.isEmpty {
            Text("គ្មានថ្ងៃបុណ្យ")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
        } else {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(holidays) { holiday in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(holiday.isPublicHoliday ? .red : .orange)
                            .frame(width: 6, height: 6)
                            .padding(.top, 5)

                        VStack(alignment: .leading, spacing: 1) {
                            Text(holiday.khmerName)
                                .font(.system(size: 11, weight: .medium))

                            HStack(spacing: 4) {
                                Text(holiday.formattedDate)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.secondary)

                                if !holiday.englishName.isEmpty {
                                    Text("·")
                                        .foregroundStyle(.quaternary)
                                    Text(holiday.englishName)
                                        .font(.system(size: 10))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        Spacer()

                        if holiday.isPublicHoliday {
                            Text("ឈប់សម្រាក")
                                .font(.system(size: 9))
                                .foregroundStyle(.red)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}
