import Foundation

enum KhmerAnimalYear: Int, CaseIterable, Identifiable {
    case chhut = 0
    case chlov = 1
    case khal = 2
    case thos = 3
    case rong = 4
    case masagn = 5
    case momee = 6
    case momae = 7
    case vok = 8
    case roka = 9
    case cho = 10
    case kor = 11

    var id: Int { rawValue }

    var khmerName: String {
        KhmerAnimalYear.khmerNames[rawValue]
    }

    static let khmerNames: [String] = [
        "ជូត", "ឆ្លូវ", "ខាល", "ថោះ",
        "រោង", "ម្សាញ់", "មមី", "មមែ",
        "វក", "រកា", "ច", "កុរ"
    ]

    static func from(beYear: Int) -> KhmerAnimalYear {
        let index = ((beYear + 4) % 12 + 12) % 12
        return KhmerAnimalYear(rawValue: index)!
    }
}
