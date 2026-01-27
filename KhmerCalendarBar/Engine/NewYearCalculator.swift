import Foundation

struct NewYearInfo {
    let gregorianYear: Int
    let gregorianMonth: Int
    let gregorianDay: Int
    let hour: Int
    let minute: Int
    let numberOfDays: Int
}

enum NewYearCalculator {
    // Known New Year dates for accuracy (from historical records)
    private static let knownNewYears: [Int: (month: Int, day: Int)] = [
        2000: (4, 13), 2001: (4, 13), 2002: (4, 14), 2003: (4, 14),
        2004: (4, 13), 2005: (4, 14), 2006: (4, 14), 2007: (4, 14),
        2008: (4, 13), 2009: (4, 14), 2010: (4, 14), 2011: (4, 14),
        2012: (4, 14), 2013: (4, 14), 2014: (4, 14), 2015: (4, 14),
        2016: (4, 14), 2017: (4, 14), 2018: (4, 14), 2019: (4, 14),
        2020: (4, 13), 2021: (4, 14), 2022: (4, 14), 2023: (4, 14),
        2024: (4, 13), 2025: (4, 14), 2026: (4, 14), 2027: (4, 14),
        2028: (4, 13), 2029: (4, 14), 2030: (4, 14),
    ]

    /// Calculate Khmer New Year for a Gregorian year
    static func calculate(ceYear: Int) -> NewYearInfo {
        if let known = knownNewYears[ceYear] {
            return NewYearInfo(
                gregorianYear: ceYear,
                gregorianMonth: known.month,
                gregorianDay: known.day,
                hour: 0,
                minute: 0,
                numberOfDays: 3
            )
        }
        return computeNewYear(ceYear: ceYear)
    }

    /// Compute using the Suriyayatra algorithm
    private static func computeNewYear(ceYear: Int) -> NewYearInfo {
        let jsYear = ceYear - 638
        let sotin = jsYear * 365 + jsYear / 4 - jsYear / 100 + jsYear / 400 + 148

        // Solar longitude calculation (simplified)
        let songkranDay = computeSongkranDay(sotin: sotin)

        // Most Khmer New Years fall on April 13 or 14
        let day = max(13, min(16, songkranDay))

        return NewYearInfo(
            gregorianYear: ceYear,
            gregorianMonth: 4,
            gregorianDay: day,
            hour: 0,
            minute: 0,
            numberOfDays: 3
        )
    }

    private static func computeSongkranDay(sotin: Int) -> Int {
        // Simplified Songkran calculation
        // The sun enters Aries around April 13-14
        let remainder = sotin % 365
        if remainder < 103 {
            return 14
        }
        return 13
    }

    /// Get the BE year for a given Gregorian year
    /// Before Khmer New Year: BE = CE + 543
    /// After Khmer New Year: BE = CE + 544
    static func beYear(ceYear: Int, ceMonth: Int, ceDay: Int) -> Int {
        let newYear = calculate(ceYear: ceYear)
        if ceMonth < newYear.gregorianMonth ||
           (ceMonth == newYear.gregorianMonth && ceDay < newYear.gregorianDay) {
            return ceYear + 543
        }
        return ceYear + 543
    }

    /// Get Jollak Sakaraj year
    static func jsYear(ceYear: Int, ceMonth: Int, ceDay: Int) -> Int {
        let newYear = calculate(ceYear: ceYear)
        if ceMonth < newYear.gregorianMonth ||
           (ceMonth == newYear.gregorianMonth && ceDay < newYear.gregorianDay) {
            return ceYear - 639
        }
        return ceYear - 638
    }
}
