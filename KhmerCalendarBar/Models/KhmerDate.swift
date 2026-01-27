import Foundation

struct KhmerDate: Equatable, Hashable {
    let day: Int
    let moonPhase: MoonPhase
    let month: KhmerMonth
    let beYear: Int
    let jsYear: Int
    let animalYear: KhmerAnimalYear
    let sak: KhmerSak

    var dayOfMonth: Int {
        if moonPhase == .waxing {
            return day - 1
        } else {
            return 15 + (day - 1)
        }
    }

    static func lunarDayFromDayOfMonth(_ dayOfMonth: Int) -> (day: Int, phase: MoonPhase) {
        if dayOfMonth < 15 {
            return (day: dayOfMonth + 1, phase: .waxing)
        } else {
            return (day: dayOfMonth - 15 + 1, phase: .waning)
        }
    }

    var formattedDay: String {
        "\(KhmerNumeralService.toKhmer(day))\(moonPhase.khmerName)"
    }

    var formattedShort: String {
        "\(formattedDay) \(month.khmerName)"
    }

    var formattedFull: String {
        "ថ្ងៃ\(formattedDay) ខែ\(month.khmerName) ឆ្នាំ\(animalYear.khmerName) \(sak.khmerName) ពុទ្ធសករាជ \(KhmerNumeralService.toKhmer(beYear))"
    }

    var formattedAnimalAndSak: String {
        "ឆ្នាំ\(animalYear.khmerName) \(sak.khmerName) ព.ស. \(KhmerNumeralService.toKhmer(beYear))"
    }
}
