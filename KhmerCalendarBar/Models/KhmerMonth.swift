import Foundation

enum KhmerMonth: Int, CaseIterable, Identifiable {
    case migasir = 0
    case boss = 1
    case meak = 2
    case phalkun = 3
    case cheit = 4
    case pisakh = 5
    case jesth = 6
    case asadh = 7
    case srap = 8
    case phatrabot = 9
    case assoch = 10
    case kadeuk = 11
    case bontomAsadh = 12
    case totoeyAsadh = 13

    var id: Int { rawValue }

    var khmerName: String {
        KhmerMonth.khmerNames[rawValue]
    }

    static let khmerNames: [String] = [
        "មិគសិរ", "បុស្ស", "មាឃ", "ផល្គុន",
        "ចេត្រ", "ពិសាខ", "ជេស្ឋ", "អាសាឍ",
        "ស្រាពណ៍", "ភទ្របទ", "អស្សុជ", "កត្តិក",
        "បឋមាសាឍ", "ទុតិយាសាឍ"
    ]

    var baseDayCount: Int {
        switch self {
        case .migasir, .meak, .cheit, .jesth, .srap, .assoch:
            return 29
        case .boss, .phalkun, .pisakh, .asadh, .phatrabot, .kadeuk:
            return 30
        case .bontomAsadh:
            return 30
        case .totoeyAsadh:
            return 30
        }
    }
}
