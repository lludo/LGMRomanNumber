// Equivalence driver: reads "A <decimal>" or "R <hex of UTF-8>" lines on stdin,
// prints one result line per input, in the same format as Harness/objc_driver.m.
import LGMRomanNumberSwift

func unhex(_ s: Substring) -> String {
    var bytes: [UInt8] = []
    var i = s.startIndex
    while i < s.endIndex {
        let j = s.index(i, offsetBy: 2)
        bytes.append(UInt8(s[i..<j], radix: 16)!)
        i = j
    }
    return String(decoding: bytes, as: UTF8.self)
}

while let line = readLine(strippingNewline: true) {
    let kind = line.prefix(1)
    let arg = line.dropFirst(2)
    do {
        if kind == "A" {
            print(try RomanNumber.roman(fromArabic: UInt(arg)!))
        } else {
            print(try RomanNumber.arabic(fromRoman: unhex(arg)))
        }
    } catch let error as RomanNumberError {
        print("EXC \(error)")
    }
}
