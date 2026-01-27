import Foundation

enum KhmerNumeralService {
    /// Convert an integer to Khmer numerals
    static func toKhmer(_ number: Int) -> String {
        let str = String(number)
        return String(str.map { char in
            CalendarConstants.khmerNumeralMap[char] ?? char
        })
    }

    /// Convert Khmer numeral string back to integer
    static func toArabic(_ khmer: String) -> Int? {
        let reversed = Dictionary(
            uniqueKeysWithValues: CalendarConstants.khmerNumeralMap.map { ($1, $0) }
        )
        let arabic = String(khmer.map { char in
            reversed[char] ?? char
        })
        return Int(arabic)
    }
}
