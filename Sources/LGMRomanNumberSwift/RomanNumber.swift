// Swift port of LGMRomanNumber (Objective-C, 2013). Behavior is pinned to the
// original by Harness/ (see MODERNIZATION.md); rule ids refer to that file.

/// Errors mirror the two NSException names the Objective-C library raises.
public enum RomanNumberError: Error, Equatable, CustomStringConvertible {
    /// RULE-002: arabic value is 0 or greater than 4000.
    case invalidDecimalValue(UInt)
    /// RULE-004/005: roman string is empty or not in the accepted format.
    case invalidRomanNumber(String)

    /// The exact NSException name the Objective-C version raised.
    public var description: String {
        switch self {
        case .invalidDecimalValue: return "Invalid decimal value"
        case .invalidRomanNumber: return "Invalid roman number"
        }
    }
}

public enum RomanNumber {
    private static let numerals: [(value: UInt, symbol: String)] = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"),
        (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I"),
    ]

    /// RULE-001/002/003: greedy conversion for 1...4000 (4000 is "MMMM").
    public static func roman(fromArabic arabic: UInt) throws -> String {
        guard (1...4000).contains(arabic) else { throw RomanNumberError.invalidDecimalValue(arabic) }
        var rest = arabic
        var result = ""
        for (value, symbol) in numerals {
            while rest >= value {
                result += symbol
                rest -= value
            }
        }
        return result
    }

    /// RULE-004/005/006: the same pattern the original fed to NSPredicate MATCHES
    /// (whole-string, case-sensitive). It also accepts MMMM followed by CM..IX, i.e. up to 4999.
    public static func arabic(fromRoman roman: String) throws -> UInt {
        guard !roman.isEmpty,
              (try? #/M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})/#.wholeMatch(in: roman)) != nil
        else { throw RomanNumberError.invalidRomanNumber(roman) }

        let value: [Character: UInt] = ["I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000]
        var sum: UInt = 0
        var previous: UInt = 1000
        for character in roman {
            let current = value[character]!  // the pattern only lets these seven letters through
            sum += current
            if previous < current { sum -= 2 * previous }  // subtractive pair, e.g. IV
            previous = current
        }
        return sum
    }
}
