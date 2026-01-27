import Foundation

enum KhmerSak: Int, CaseIterable, Identifiable {
    case samridthiSak = 0
    case aekSak = 1
    case toSak = 2
    case treiSak = 3
    case chattvaSak = 4
    case panchaSak = 5
    case chhaSak = 6
    case sappaSak = 7
    case atthaSak = 8
    case nappaSak = 9

    var id: Int { rawValue }

    var khmerName: String {
        KhmerSak.khmerNames[rawValue]
    }

    static let khmerNames: [String] = [
        "សំរឹទ្ធិស័ក", "ឯកស័ក", "ទោស័ក", "ត្រីស័ក", "ចត្វាស័ក",
        "បញ្ចស័ក", "ឆស័ក", "សប្តស័ក", "អដ្ឋស័ក", "នព្វស័ក"
    ]

    static func from(jsYear: Int) -> KhmerSak {
        let index = ((jsYear % 10) + 10) % 10
        return KhmerSak(rawValue: index)!
    }
}
