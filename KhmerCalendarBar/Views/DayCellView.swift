import SwiftUI

struct DayCellView: View {
    let dayInfo: DayInfo
    let isSelected: Bool
    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 2) {
            Text("\(dayInfo.gregorianDay)")
                .font(.system(size: 12, weight: dayInfo.isToday ? .bold : .regular, design: .rounded))
                .foregroundStyle(dayColor)

            Text(dayInfo.khmerDate.formattedDay)
                .font(.system(size: 9, weight: dayInfo.isToday ? .medium : .regular))
                .foregroundStyle(khmerDayColor)
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(borderColor, lineWidth: borderWidth)
        )
        .overlay(alignment: .bottom) {
            if dayInfo.isPublicHoliday && dayInfo.isCurrentMonth {
                HStack(spacing: 2) {
                    ForEach(0..<min(dayInfo.holidays.count, 3), id: \.self) { _ in
                        Circle()
                            .fill(CalendarTheme.coral)
                            .frame(width: 4, height: 4)
                    }
                }
                .offset(y: -3)
            }
        }
        .opacity(dayInfo.isCurrentMonth ? 1.0 : 0.4)
        .scaleEffect(isHovered && dayInfo.isCurrentMonth ? 1.06 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isHovered)
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
        .onHover { hovering in
            isHovered = hovering
        }
        .help(tooltipText)
    }

    private var tooltipText: String {
        let dowIndex = dayInfo.dayOfWeek - 1
        let weekday = CalendarConstants.weekdayNames[dowIndex]
        var text = "ថ្ងៃ\(weekday)\n"
        text += dayInfo.khmerDate.formattedFull
        let fmt = DateFormatter()
        fmt.dateStyle = .long
        text += "\n" + fmt.string(from: dayInfo.gregorianDate)
        for holiday in dayInfo.holidays {
            text += "\n\(holiday.khmerName)"
            if !holiday.englishName.isEmpty {
                text += " — \(holiday.englishName)"
            }
        }
        return text
    }

    private var dayColor: Color {
        if dayInfo.isToday { return .white }
        if dayInfo.isPublicHoliday || dayInfo.isSunday { return CalendarTheme.sunday }
        if dayInfo.isSaturday { return CalendarTheme.saturday }
        return .primary
    }

    private var khmerDayColor: Color {
        if dayInfo.isToday { return .white.opacity(0.85) }
        if dayInfo.isCurrentMonth { return .secondary }
        return Color.gray.opacity(0.4)
    }

    private var backgroundColor: Color {
        if dayInfo.isToday { return CalendarTheme.accent }
        if isSelected { return CalendarTheme.selectedBg }
        if isHovered && dayInfo.isCurrentMonth { return CalendarTheme.hoverBg }
        return .clear
    }

    private var borderColor: Color {
        if isSelected && !dayInfo.isToday { return CalendarTheme.selectedBorder }
        if isHovered && dayInfo.isCurrentMonth && !dayInfo.isToday { return CalendarTheme.accent.opacity(0.15) }
        return .clear
    }

    private var borderWidth: CGFloat {
        if isSelected && !dayInfo.isToday { return 1.5 }
        if isHovered && dayInfo.isCurrentMonth { return 0.5 }
        return 0
    }
}
