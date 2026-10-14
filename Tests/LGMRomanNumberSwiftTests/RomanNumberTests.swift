// Characterization tests: each expectation is what the Objective-C original returns
// (ported from LGMRomanNumberTests/LGMRomanNumberTests.m, plus the quirks found while reading it).
import XCTest
@testable import LGMRomanNumberSwift

final class RomanNumberTests: XCTestCase {
    // RULE-001: greedy subtractive notation.
    func testRule001RomanFromArabic() throws {
        let expected: [UInt: String] = [1: "I", 4: "IV", 9: "IX", 14: "XIV", 40: "XL", 90: "XC", 400: "CD",
                                        900: "CM", 1986: "MCMLXXXVI", 2013: "MMXIII", 3999: "MMMCMXCIX"]
        for (n, roman) in expected { XCTAssertEqual(try RomanNumber.roman(fromArabic: n), roman) }
    }

    // RULE-003: 4000 is accepted and becomes MMMM.
    func testRule003UpperBound() throws {
        XCTAssertEqual(try RomanNumber.roman(fromArabic: 4000), "MMMM")
    }

    // RULE-002: 0 and anything above 4000 raise "Invalid decimal value".
    func testRule002OutOfRange() {
        for n: UInt in [0, 4001, .max] {
            XCTAssertThrowsError(try RomanNumber.roman(fromArabic: n)) {
                XCTAssertEqual("\($0)", "Invalid decimal value")
            }
        }
    }

    // RULE-006: parsing, including subtractive pairs.
    func testRule006ArabicFromRoman() throws {
        let expected: [String: UInt] = ["I": 1, "IV": 4, "XLII": 42, "MCMLXXXVI": 1986, "MMXIII": 2013, "MMMM": 4000]
        for (roman, n) in expected { XCTAssertEqual(try RomanNumber.arabic(fromRoman: roman), n) }
    }

    // RULE-005 quirk: the original pattern accepts MMMM followed by CM..IX (up to 4999).
    func testRule005AcceptsUpTo4999() throws {
        XCTAssertEqual(try RomanNumber.arabic(fromRoman: "MMMMCMXCIX"), 4999)
    }

    // RULE-004/005: empty, malformed, lowercase and padded strings raise "Invalid roman number".
    func testRule004And005Invalid() {
        for s in ["", "IIII", "VV", "IL", "MMMMM", "xiv", " X", "X\n", "Ⅻ"] {
            XCTAssertThrowsError(try RomanNumber.arabic(fromRoman: s)) {
                XCTAssertEqual("\($0)", "Invalid roman number")
            }
        }
    }

    // Round trip over the whole domain.
    func testRoundTrip() throws {
        for n: UInt in 1...4000 { XCTAssertEqual(try RomanNumber.arabic(fromRoman: RomanNumber.roman(fromArabic: n)), n) }
    }
}
