import Foundation

enum MonthNavigator {
    /// Get the next Khmer month, accounting for leap months
    static func nextMonth(after month: KhmerMonth, beYear: Int) -> KhmerMonth {
        let order = LeapYearCalculator.monthOrder(beYear: beYear)
        guard let index = order.firstIndex(of: month) else {
            return .migasir
        }
        let nextIndex = index + 1
        if nextIndex >= order.count {
            return .migasir
        }
        return order[nextIndex]
    }

    /// Get the previous Khmer month
    static func previousMonth(before month: KhmerMonth, beYear: Int) -> KhmerMonth {
        let order = LeapYearCalculator.monthOrder(beYear: beYear)
        guard let index = order.firstIndex(of: month) else {
            return .kadeuk
        }
        if index == 0 {
            return .kadeuk
        }
        return order[index - 1]
    }

    /// Check if a month exists in a given year
    static func monthExists(_ month: KhmerMonth, beYear: Int) -> Bool {
        let order = LeapYearCalculator.monthOrder(beYear: beYear)
        return order.contains(month)
    }
}
