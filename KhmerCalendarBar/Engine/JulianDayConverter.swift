import Foundation

enum JulianDayConverter {
    /// Convert Gregorian date to Julian Day Number
    static func toJulianDay(year: Int, month: Int, day: Int) -> Int {
        let a = (14 - month) / 12
        let y = year + 4800 - a
        let m = month + 12 * a - 3
        return day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045
    }

    /// Convert Julian Day Number to Gregorian (year, month, day)
    static func toGregorian(jdn: Int) -> (year: Int, month: Int, day: Int) {
        let a = jdn + 32044
        let b = (4 * a + 3) / 146097
        let c = a - (146097 * b) / 4
        let d = (4 * c + 3) / 1461
        let e = c - (1461 * d) / 4
        let m = (5 * e + 2) / 153

        let day = e - (153 * m + 2) / 5 + 1
        let month = m + 3 - 12 * (m / 10)
        let year = 100 * b + d - 4800 + m / 10

        return (year, month, day)
    }

    /// Day of week: 0 = Sunday, 6 = Saturday
    static func dayOfWeek(year: Int, month: Int, day: Int) -> Int {
        let jdn = toJulianDay(year: year, month: month, day: day)
        return (jdn + 1) % 7
    }
}
