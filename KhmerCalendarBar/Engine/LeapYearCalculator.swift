import Foundation

enum LeapType: Int {
    case normal = 0
    case leapMonth = 1
    case leapDay = 2
}

enum LeapYearCalculator {
    /// Check if a BE year has a leap day (Adhikavar)
    static func isLeapDay(beYear: Int) -> Bool {
        let avoman = AstronomicalCalculations.avoman(beYear: beYear)
        return avoman < 11
    }

    /// Check if a BE year has a leap month (Adhikameas)
    static func isLeapMonth(beYear: Int) -> Bool {
        let bodethey = AstronomicalCalculations.bodethey(beYear: beYear)
        let prevBodethey = AstronomicalCalculations.bodethey(beYear: beYear - 1)

        if bodethey >= 25 && prevBodethey <= 5 {
            return true
        }
        if bodethey == 24 {
            return true
        }
        return false
    }

    /// Determine the leap type for a year
    /// A year cannot have both leap month and leap day
    static func leapType(beYear: Int) -> LeapType {
        let hasLeapMonth = isLeapMonth(beYear: beYear)
        let hasLeapDay = isLeapDay(beYear: beYear)

        if hasLeapMonth {
            return .leapMonth
        }
        if hasLeapDay && !isLeapMonth(beYear: beYear + 1) {
            return .leapDay
        }
        return .normal
    }

    /// Total days in a Khmer year
    static func daysInYear(beYear: Int) -> Int {
        switch leapType(beYear: beYear) {
        case .normal:    return CalendarConstants.normalYearDays
        case .leapDay:   return CalendarConstants.leapDayYearDays
        case .leapMonth: return CalendarConstants.leapMonthYearDays
        }
    }

    /// Days in a specific month for a given BE year
    static func daysInMonth(_ month: KhmerMonth, beYear: Int) -> Int {
        // Jesth gets an extra day in leap day years
        if month == .jesth && leapType(beYear: beYear) == .leapDay {
            return 30
        }
        return month.baseDayCount
    }

    /// Get the ordered months for a BE year
    static func monthOrder(beYear: Int) -> [KhmerMonth] {
        if leapType(beYear: beYear) == .leapMonth {
            return CalendarConstants.leapMonthOrder
        }
        return CalendarConstants.normalMonthOrder
    }
}
