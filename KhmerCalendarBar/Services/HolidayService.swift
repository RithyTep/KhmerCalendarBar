import Foundation

enum HolidayService {
    /// All holidays for a given Gregorian year
    static func holidays(forYear year: Int) -> [KhmerHoliday] {
        var result: [KhmerHoliday] = []
        result.append(contentsOf: fixedHolidays(year: year))
        result.append(contentsOf: lunarHolidays(year: year))
        return result.sorted { ($0.month * 100 + $0.day) < ($1.month * 100 + $1.day) }
    }

    /// Holidays for a specific date
    static func holidays(forYear year: Int, month: Int, day: Int) -> [KhmerHoliday] {
        holidays(forYear: year).filter { $0.month == month && $0.day == day }
    }

    // MARK: - Fixed Gregorian Holidays

    private static func fixedHolidays(year: Int) -> [KhmerHoliday] {
        let fixed: [(m: Int, d: Int, kh: String, en: String)] = [
            (1, 1, "ទិវាចូលឆ្នាំសកល", "International New Year"),
            (1, 7, "ទិវាជ័យជម្នះលើរបបប្រល័យពូជសាសន៍", "Victory over Genocide Day"),
            (3, 8, "ទិវានារីអន្តរជាតិ", "International Women's Day"),
            (5, 1, "ទិវាពលកម្មអន្តរជាតិ", "International Workers' Day"),
            (5, 13, "ព្រះរាជពិធីបុណ្យចម្រើនព្រះជន្ម", "King's Birthday"),
            (5, 14, "ព្រះរាជពិធីបុណ្យចម្រើនព្រះជន្ម", "King's Birthday"),
            (5, 15, "ព្រះរាជពិធីបុណ្យចម្រើនព្រះជន្ម", "King's Birthday"),
            (6, 18, "ទិវាកូនអន្តរជាតិ", "International Children's Day"),
            (9, 24, "ទិវាប្រកាសរដ្ឋធម្មនុញ្ញ", "Constitution Day"),
            (10, 15, "ទិវាប្រារព្វខួបទិវាកំណត់ព្រះមហាវីរក្សត្រ", "Commemoration Day"),
            (10, 29, "ទិវាប្រារព្វខួបព្រះរាជពិធីគ្រងរាជ្យ", "Coronation Day"),
            (11, 9, "ទិវាឯករាជ្យជាតិ", "Independence Day"),
            (12, 10, "ទិវាសិទ្ធិមនុស្សអន្តរជាតិ", "International Human Rights Day"),
        ]

        return fixed.map { item in
            KhmerHoliday(
                id: "\(year)-\(item.m)-\(item.d)-\(item.en)",
                khmerName: item.kh,
                englishName: item.en,
                isPublicHoliday: true,
                month: item.m,
                day: item.d,
                year: year
            )
        }
    }

    // MARK: - Lunar-Based Holidays

    private static func lunarHolidays(year: Int) -> [KhmerHoliday] {
        var result: [KhmerHoliday] = []

        // Khmer New Year (April 13-16)
        let newYear = NewYearCalculator.calculate(ceYear: year)
        for i in 0..<newYear.numberOfDays {
            let day = newYear.gregorianDay + i
            result.append(KhmerHoliday(
                id: "\(year)-4-\(day)-newyear",
                khmerName: "ចូលឆ្នាំថ្មីប្រពៃណីខ្មែរ",
                englishName: "Khmer New Year",
                isPublicHoliday: true,
                month: 4,
                day: day,
                year: year
            ))
        }

        // Visak Bochea (full moon of Pisakh ~ May)
        if let visak = lunarToGregorian(month: .pisakh, day: 15, phase: .waxing, ceYear: year) {
            result.append(KhmerHoliday(
                id: "\(year)-\(visak.month)-\(visak.day)-visak",
                khmerName: "ពិធីបុណ្យវិសាខបូជា",
                englishName: "Visak Bochea",
                isPublicHoliday: true,
                month: visak.month,
                day: visak.day,
                year: year
            ))
        }

        // Meak Bochea (full moon of Meak ~ Feb/Mar)
        if let meak = lunarToGregorian(month: .meak, day: 15, phase: .waxing, ceYear: year) {
            result.append(KhmerHoliday(
                id: "\(year)-\(meak.month)-\(meak.day)-meak",
                khmerName: "ពិធីបុណ្យមាឃបូជា",
                englishName: "Meak Bochea",
                isPublicHoliday: true,
                month: meak.month,
                day: meak.day,
                year: year
            ))
        }

        // Pchum Ben (15 days ending on waning 15 of Phatrabot ~ Sep/Oct)
        if let pchumEnd = lunarToGregorian(month: .phatrabot, day: 15, phase: .waning, ceYear: year) {
            // Main day (Pchum Ben)
            result.append(KhmerHoliday(
                id: "\(year)-\(pchumEnd.month)-\(pchumEnd.day)-pchumben",
                khmerName: "ពិធីបុណ្យភ្ជុំបិណ្ឌ",
                englishName: "Pchum Ben",
                isPublicHoliday: true,
                month: pchumEnd.month,
                day: pchumEnd.day,
                year: year
            ))
            // Day before and after also public holidays
            let cal = Calendar.current
            if let endDate = cal.date(from: DateComponents(year: year, month: pchumEnd.month, day: pchumEnd.day)) {
                for offset in [-1, -2] {
                    if let d = cal.date(byAdding: .day, value: offset, to: endDate) {
                        let m = cal.component(.month, from: d)
                        let dd = cal.component(.day, from: d)
                        result.append(KhmerHoliday(
                            id: "\(year)-\(m)-\(dd)-pchumben-\(offset)",
                            khmerName: "ពិធីបុណ្យភ្ជុំបិណ្ឌ",
                            englishName: "Pchum Ben",
                            isPublicHoliday: true,
                            month: m,
                            day: dd,
                            year: year
                        ))
                    }
                }
            }
        }

        // Water Festival (full moon of Kadeuk ~ Nov)
        if let waterFest = lunarToGregorian(month: .kadeuk, day: 15, phase: .waxing, ceYear: year) {
            for offset in -1...1 {
                let cal = Calendar.current
                if let date = cal.date(from: DateComponents(year: year, month: waterFest.month, day: waterFest.day)),
                   let d = cal.date(byAdding: .day, value: offset, to: date) {
                    let m = cal.component(.month, from: d)
                    let dd = cal.component(.day, from: d)
                    result.append(KhmerHoliday(
                        id: "\(year)-\(m)-\(dd)-waterfest",
                        khmerName: "ពិធីបុណ្យអុំទូក",
                        englishName: "Water Festival",
                        isPublicHoliday: true,
                        month: m,
                        day: dd,
                        year: year
                    ))
                }
            }
        }

        return result
    }

    /// Convert a Khmer lunar date to Gregorian by scanning
    private static func lunarToGregorian(
        month: KhmerMonth,
        day: Int,
        phase: MoonPhase,
        ceYear: Int
    ) -> (month: Int, day: Int)? {
        let engine = ChhankitekEngine.shared
        let cal = Calendar.current

        // Scan months likely to contain this lunar date
        let searchRanges: [(Int, Int)] = [
            (1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1),
            (7, 1), (8, 1), (9, 1), (10, 1), (11, 1), (12, 1)
        ]

        for (m, _) in searchRanges {
            let daysInMonth = cal.range(of: .day, in: .month,
                for: cal.date(from: DateComponents(year: ceYear, month: m))!)!.count

            for d in 1...daysInMonth {
                let khmer = engine.toKhmer(year: ceYear, month: m, day: d)
                if khmer.month == month && khmer.day == day && khmer.moonPhase == phase {
                    return (m, d)
                }
            }
        }

        return nil
    }
}
