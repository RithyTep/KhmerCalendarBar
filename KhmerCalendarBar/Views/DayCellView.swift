import SwiftUI

struct DayCellView: View {
    let dayInfo: DayInfo
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 1) {
            Text("\(dayInfo.gregorianDay)")
                .font(.system(size: 12, weight: dayInfo.isToday ? .bold : .regular))
                .foregroundStyle(dayColor)

            Text(dayInfo.khmerDate.formattedDay)
                .font(.system(size: 7))
                .foregroundStyle(dayInfo.isCurrentMonth ? .secondary : .quaternary)
        }
        .frame(maxWidth: .infinity, minHeight: 34)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(alignment: .topTrailing) {
            if dayInfo.isPublicHoliday {
                Circle()
                    .fill(.red)
                    .frame(width: 4, height: 4)
                    .offset(x: -2, y: 2)
            }
        }
        .opacity(dayInfo.isCurrentMonth ? 1.0 : 0.35)
    }

    private var dayColor: Color {
        if dayInfo.isToday { return .white }
        if dayInfo.isPublicHoliday || dayInfo.isSunday { return .red }
        if dayInfo.isSaturday { return .orange }
        return .primary
    }

    private var backgroundColor: Color {
        if dayInfo.isToday { return .accentColor }
        if isSelected { return .accentColor.opacity(0.15) }
        return .clear
    }
}
