#!/usr/bin/env python3
"""Writes the equivalence input set (one case per line) to stdout.
A <n>   -> romanFromArabic(n)
R <hex> -> arabicFromRoman(UTF-8 string given as hex)
Groups are listed in MODERNIZATION.md."""
import itertools, string, sys

cases = []
def A(n): cases.append(f"A {n}")
def R(s): cases.append("R " + s.encode("utf-8").hex())

# 1. Integers: 0..10000 exhaustively, plus large / boundary NSUInteger values.
for n in range(0, 10001): A(n)
for n in [2**16, 2**31 - 1, 2**31, 2**32 - 1, 2**32, 2**32 + 1, 2**32 + 3999, 2**63, 2**64 - 1]: A(n)

# 2. Every string the format regex accepts (5 x 10 x 10 x 10 = 5000, incl. the empty string).
th = ["", "M", "MM", "MMM", "MMMM"]
def digit(one, five, ten):
    return [ten and one + ten, one + five] + [p + one * k for p in ["", five] for k in range(4)]
hu, te, on = digit("C", "D", "M"), digit("X", "L", "C"), digit("I", "V", "X")
valid = ["".join(t) for t in itertools.product(th, hu, te, on)]
assert len(valid) == 5000 and len(set(valid)) == 5000
strings = list(valid)

# 3. Every string of length 1..5 over the seven roman letters (19,607).
for k in range(1, 6):
    strings += ["".join(p) for p in itertools.product("IVXLCDM", repeat=k)]
# 4. Every string of length 1..2 over printable ASCII (9,120).
pa = [chr(c) for c in range(32, 127)]
strings += pa + [a + b for a in pa for b in pa]
# 5. Malformed variants of every valid string: lowercase, surrounding whitespace, trailing junk.
for v in valid[1:]:
    strings += [v.lower(), " " + v, v + " ", v + "\n", "\t" + v, v + "0", v + "\0", v + "I", "I" + v]
# 6. Hand-picked edge cases.
strings += ["MMMM", "MMMMM", "MMMMCMXCIX", "IIII", "VV", "IL", "IC", "XM", "VX", "MCMLXXXVI", "MMXIII",
            "M" * 1000, "I" * 10000, "Ⅻ", "Ⅰ", "Ｍ", "МСМ", "I\u0301", "X\u200bI", "é", "😀", "\0", "\r\n",
            "IV\r", "-I", "+I", "0", "1", "1986", "N", "nulla", " ", "\t", "\n", ""]

seen = set()
for s in strings:
    if s not in seen:
        seen.add(s); R(s)
sys.stdout.write("\n".join(cases) + "\n")
print(f"cases={len(cases)} integers={sum(c[0]=='A' for c in cases)} strings={len(seen)} valid_format={len(valid)}", file=sys.stderr)
