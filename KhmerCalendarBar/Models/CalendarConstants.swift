import Foundation

enum CalendarConstants {
    static let weekdayNamesShort: [String] = [
        "អា", "ច", "អ", "ព", "ព្រ", "សុ", "ស"
    ]

    static let weekdayNames: [String] = [
        "អាទិត្យ", "ចន្ទ", "អង្គារ", "ពុធ",
        "ព្រហស្បតិ៍", "សុក្រ", "សៅរ៍"
    ]

    static let solarMonthNames: [String] = [
        "មករា", "កុម្ភៈ", "មីនា", "មេសា", "ឧសភា", "មិថុនា",
        "កក្កដា", "សីហា", "កញ្ញា", "តុលា", "វិច្ឆិកា", "ធ្នូ"
    ]

    static let khmerNumeralMap: [Character: Character] = [
        "0": "០", "1": "១", "2": "២", "3": "៣", "4": "៤",
        "5": "៥", "6": "៦", "7": "៧", "8": "៨", "9": "៩"
    ]

    // Normal Khmer year: 354 days
    // Leap day year: 355 days
    // Leap month year: 384 days
    static let normalYearDays = 354
    static let leapDayYearDays = 355
    static let leapMonthYearDays = 384

    // Month order for a normal year (12 months)
    static let normalMonthOrder: [KhmerMonth] = [
        .migasir, .boss, .meak, .phalkun, .cheit, .pisakh,
        .jesth, .asadh, .srap, .phatrabot, .assoch, .kadeuk
    ]

    // Month order for a leap month year (13 months)
    static let leapMonthOrder: [KhmerMonth] = [
        .migasir, .boss, .meak, .phalkun, .cheit, .pisakh,
        .jesth, .bontomAsadh, .totoeyAsadh,
        .srap, .phatrabot, .assoch, .kadeuk
    ]
}
