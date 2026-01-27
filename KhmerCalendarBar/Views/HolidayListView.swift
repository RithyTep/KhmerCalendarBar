import SwiftUI

struct HolidayListView: View {
    let holidays: [KhmerHoliday]

    var body: some View {
        if holidays.isEmpty {
            Text("គ្មានថ្ងៃបុណ្យ")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 4)
        } else {
            VStack(alignment: .leading, spacing: 6) {
                // Section header with count
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(CalendarTheme.amber)
                    Text("បុណ្យក្នុងខែនេះ")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text("\(uniqueHolidays.count)")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundStyle(CalendarTheme.amber)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(CalendarTheme.amberMuted))
                    Spacer()
                }

                // Holiday list (scrollable if many)
                let maxVisible = 5
                if uniqueHolidays.count > maxVisible {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(uniqueHolidays, id: \.id) { holiday in
                                HolidayRow(holiday: holiday, isPassed: isHolidayPassed(holiday))
                            }
                        }
                    }
                    .frame(maxHeight: CGFloat(maxVisible) * 24)
                } else {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(uniqueHolidays, id: \.id) { holiday in
                            HolidayRow(holiday: holiday, isPassed: isHolidayPassed(holiday))
                        }
                    }
                }
            }
        }
    }

    private var uniqueHolidays: [KhmerHoliday] {
        var seen = Set<String>()
        return holidays.filter { h in
            let key = "\(h.month)-\(h.day)-\(h.khmerName)"
            if seen.contains(key) { return false }
            seen.insert(key)
            return true
        }
    }

    private func isHolidayPassed(_ holiday: KhmerHoliday) -> Bool {
        guard let date = holiday.gregorianDate else { return false }
        return Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: Date())
    }
}

// MARK: - Holiday Row

private struct HolidayRow: View {
    let holiday: KhmerHoliday
    let isPassed: Bool

    var body: some View {
        HStack(spacing: 6) {
            // Date badge
            Text(holiday.formattedDate)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundStyle(isPassed ? Color.secondary.opacity(0.4) : CalendarTheme.accent)
                .frame(width: 38, alignment: .leading)

            Circle()
                .fill(dotColor)
                .frame(width: 4, height: 4)

            Text(holiday.khmerName)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(isPassed ? .tertiary : .primary)
                .lineLimit(1)

            Spacer()

            if !holiday.englishName.isEmpty {
                Text(holiday.englishName)
                    .font(.system(size: 9))
                    .foregroundStyle(isPassed ? Color.secondary.opacity(0.3) : Color.secondary.opacity(0.6))
                    .lineLimit(1)
            }
        }
        .opacity(isPassed ? 0.65 : 1.0)
    }

    private var dotColor: Color {
        if isPassed { return .gray.opacity(0.5) }
        return holiday.isPublicHoliday ? CalendarTheme.coral : CalendarTheme.amber
    }
}
