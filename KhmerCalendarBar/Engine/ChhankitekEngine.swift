import Foundation

final class ChhankitekEngine {
    static let shared = ChhankitekEngine()

    // Epoch: January 1, 1900
    // On this date: Khmer date = 1 Kert (waxing day 1), month Boss (index 1)
    // BE year = 2443
    private let epochYear = 1900
    private let epochMonth = 1
    private let epochDay = 1
    private let epochKhmerMonth = KhmerMonth.boss
    private let epochKhmerDayOfMonth = 0 // 0-based: 1 Kert = index 0
    private let epochBEYear = 2443

    private init() {}

    // MARK: - Public API

    /// Convert a Gregorian date to a Khmer date
    func toKhmer(year: Int, month: Int, day: Int) -> KhmerDate {
        let targetJDN = JulianDayConverter.toJulianDay(year: year, month: month, day: day)
        let epochJDN = JulianDayConverter.toJulianDay(year: epochYear, month: epochMonth, day: epochDay)

        var diffDays = targetJDN - epochJDN
        var currentBEYear = epochBEYear
        var currentMonthIndex = epochKhmerMonth
        var currentDayOfMonth = epochKhmerDayOfMonth

        // Handle dates before epoch
        if diffDays < 0 {
            return fallbackKhmerDate(year: year, month: month, day: day)
        }

        // Skip full Khmer years
        while diffDays > 0 {
            let remainingInYear = daysLeftInYear(
                beYear: currentBEYear,
                month: currentMonthIndex,
                dayOfMonth: currentDayOfMonth
            )

            if diffDays >= remainingInYear {
                diffDays -= remainingInYear
                currentBEYear += 1
                currentMonthIndex = .migasir
                currentDayOfMonth = 0

                // Skip complete years
                let nextYearDays = LeapYearCalculator.daysInYear(beYear: currentBEYear)
                while diffDays >= nextYearDays {
                    diffDays -= nextYearDays
                    currentBEYear += 1
                }
            } else {
                break
            }
        }

        // Skip full months
        while diffDays > 0 {
            let monthDays = LeapYearCalculator.daysInMonth(currentMonthIndex, beYear: currentBEYear)
            let remainingInMonth = monthDays - currentDayOfMonth

            if diffDays >= remainingInMonth {
                diffDays -= remainingInMonth
                currentMonthIndex = MonthNavigator.nextMonth(after: currentMonthIndex, beYear: currentBEYear)
                currentDayOfMonth = 0

                // Wrap year if needed
                if currentMonthIndex == .migasir {
                    currentBEYear += 1
                }
            } else {
                break
            }
        }

        // Remaining days
        currentDayOfMonth += diffDays

        // Overflow check
        let maxDays = LeapYearCalculator.daysInMonth(currentMonthIndex, beYear: currentBEYear)
        if currentDayOfMonth >= maxDays {
            currentDayOfMonth -= maxDays
            currentMonthIndex = MonthNavigator.nextMonth(after: currentMonthIndex, beYear: currentBEYear)
            if currentMonthIndex == .migasir {
                currentBEYear += 1
            }
        }

        // Determine lunar day and phase
        let lunarDay = KhmerDate.lunarDayFromDayOfMonth(currentDayOfMonth)

        // Determine BE year based on Visak Bochea transition
        let adjustedBE = adjustBEYear(
            beYear: currentBEYear,
            month: currentMonthIndex,
            ceYear: year,
            ceMonth: month,
            ceDay: day
        )

        let jsYear = adjustedBE - 544
        let animalYear = KhmerAnimalYear.from(beYear: adjustedBE)
        let sak = KhmerSak.from(jsYear: jsYear)

        return KhmerDate(
            day: lunarDay.day,
            moonPhase: lunarDay.phase,
            month: currentMonthIndex,
            beYear: adjustedBE,
            jsYear: jsYear,
            animalYear: animalYear,
            sak: sak
        )
    }

    /// Convert today's date to Khmer
    func today() -> KhmerDate {
        let cal = Calendar.current
        let now = Date()
        let year = cal.component(.year, from: now)
        let month = cal.component(.month, from: now)
        let day = cal.component(.day, from: now)
        return toKhmer(year: year, month: month, day: day)
    }

    // MARK: - Private Helpers

    private func daysLeftInYear(beYear: Int, month: KhmerMonth, dayOfMonth: Int) -> Int {
        let order = LeapYearCalculator.monthOrder(beYear: beYear)
        guard let monthIdx = order.firstIndex(of: month) else {
            return 0
        }

        // Days remaining in current month
        let monthDays = LeapYearCalculator.daysInMonth(month, beYear: beYear)
        var total = monthDays - dayOfMonth

        // Add remaining months
        for i in (monthIdx + 1)..<order.count {
            total += LeapYearCalculator.daysInMonth(order[i], beYear: beYear)
        }

        return total
    }

    private func adjustBEYear(beYear: Int, month: KhmerMonth, ceYear: Int, ceMonth: Int, ceDay: Int) -> Int {
        // BE year changes at Visak Bochea (1 Roch Pisakh)
        // Before April: use ceYear + 543
        // After New Year: use ceYear + 543 or + 544 depending on lunar position
        if ceMonth < 4 {
            return ceYear + 543
        }
        if ceMonth >= 4 {
            // After approximately mid-April, we're in the new BE year
            if month.rawValue >= KhmerMonth.cheit.rawValue && month.rawValue <= KhmerMonth.kadeuk.rawValue {
                return ceYear + 544
            }
        }
        return ceYear + 543
    }

    private func fallbackKhmerDate(year: Int, month: Int, day: Int) -> KhmerDate {
        let beYear = year + 543
        let jsYear = beYear - 544
        return KhmerDate(
            day: 1,
            moonPhase: .waxing,
            month: .migasir,
            beYear: beYear,
            jsYear: jsYear,
            animalYear: KhmerAnimalYear.from(beYear: beYear),
            sak: KhmerSak.from(jsYear: jsYear)
        )
    }
}
