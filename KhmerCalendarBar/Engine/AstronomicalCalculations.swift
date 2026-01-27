import Foundation

enum AstronomicalCalculations {
    /// Aharkun: total days from epoch for a BE year
    static func aharkun(beYear: Int) -> Int {
        let t = beYear * 292207 + 499
        return t / 800 + 4
    }

    /// Aharkun modulus
    static func aharkunMod(beYear: Int) -> Int {
        return (beYear * 292207 + 499) % 800
    }

    /// Kromthupul: solar remainder
    static func kromthupul(beYear: Int) -> Int {
        return 800 - aharkunMod(beYear: beYear)
    }

    /// Avoman: lunar excess
    static func avoman(beYear: Int) -> Int {
        let a = aharkun(beYear: beYear)
        return (a * 11 + 25) % 692
    }

    /// Bodethey: determines leap month
    static func bodethey(beYear: Int) -> Int {
        let a = aharkun(beYear: beYear)
        let numerator = a * 11 + 25
        return (numerator / 692 + a + 29) % 30
    }

    /// Check if solar leap year
    static func isKhmerSolarLeap(beYear: Int) -> Bool {
        return kromthupul(beYear: beYear) <= 207
    }

    // MARK: - Jollak Sakaraj based

    /// Aharkun from JS year
    static func aharkunFromJs(jsYear: Int) -> Int {
        return aharkun(beYear: jsYear + 544)
    }

    /// Avoman from JS year
    static func avomanFromJs(jsYear: Int) -> Int {
        return avoman(beYear: jsYear + 544)
    }

    /// Bodethey from JS year
    static func bodetheyFromJs(jsYear: Int) -> Int {
        return bodethey(beYear: jsYear + 544)
    }

    /// Kromthupul from JS year
    static func kromthupulFromJs(jsYear: Int) -> Int {
        return kromthupul(beYear: jsYear + 544)
    }
}
