# Objective-C → Swift modernization pilot

**Verdict: PROVEN** for the input space below. The original Objective-C library and the Swift port were run on the same 84,480 inputs, and their outputs were byte-identical (0 mismatches). The harness actually ran on Linux on 2026-10-14.

The Objective-C code in `LGMRomanNumber/` is unchanged. The Swift port sits next to it as a Swift package (`Package.swift`, `Sources/`, `Tests/`).

## Method

This pilot follows the method of Anthropic's [code-modernization plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-modernization) (Apache-2.0): preflight, then inventory, then characterization tests, then translation, then dual-run equivalence with canaries. Claude Code was not available on the build machine, so each step in the plugin's `commands/` and `agents/` markdown was followed by hand. The plugin's own `scripts/compare.py` judged equivalence.

1. **Preflight.** The stack is Objective-C, Foundation and an Xcode 5 project, with ARC on (`CLANG_ENABLE_OBJC_ARC = YES`). There is 1 source file (`LGMRomanNumber.m`, 2 public methods) and an XCTest file. This is a standalone repository with no inbound consumers. Legacy toolchain: clang 19 with GNUstep base 1.31 (Debian). Target: Swift 6.0.3.
2. **Inventory and rules** (pinned by `Tests/` and the harness):
   - RULE-001: `romanFromArabic` is greedy over M CM D CD C XC L XL X IX V IV I.
   - RULE-002: input 0 or above 4000 raises `Invalid decimal value`.
   - RULE-003: 4000 is accepted and returns `MMMM`.
   - RULE-004: an empty string raises `Invalid roman number`.
   - RULE-005: the input must fully match `M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})` (case-sensitive), else `Invalid roman number`. **Quirk kept:** this also accepts `MMMMCM…`, up to 4999 (`MMMMCMXCIX` returns 4999), although the README says the range is [I, MMMM].
   - RULE-006: parsing is subtractive (a smaller numeral before a larger one subtracts).
3. **Characterization tests.** `Tests/LGMRomanNumberSwiftTests` has 7 XCTest cases, including a 1…4000 round trip.
4. **Translation.** The port is an idiomatic Swift `enum RomanNumber` with methods that throw `RomanNumberError` instead of raising NSException. A Swift `Regex` replaces `NSPredicate`. It has no Foundation dependency.
5. **Equivalence.** `Harness/run_equivalence.sh` builds the **unmodified** `LGMRomanNumber.m` with a small C driver (`Harness/objc_driver.m`) and the Swift `roman-cli` driver. It feeds both the same input file and compares the outputs byte for byte.

## Input space (`Harness/gen_inputs.py`)

| Group | Count |
|---|---|
| Integers 0…10000, every one | 10,001 |
| Large and boundary NSUInteger values (2^31, 2^32±1, 2^63, 2^64−1, …) | 9 |
| Every string the format pattern accepts, including the empty string | 5,000 |
| Every string of length 1–5 over I V X L C D M | 19,607 |
| Every string of length 1–2 over printable ASCII | 9,120 |
| Malformed variants of each valid string (lowercase, leading or trailing space/tab/newline, NUL, trailing digit, extra I) | ~45k |
| Hand-picked cases (`M`×1000, `I`×10000, Unicode numerals Ⅻ, full-width Ｍ, Cyrillic look-alikes, combining marks, zero-width space, emoji, CR/LF) | 35 |
| **Total after removing duplicates** | **84,480** (10,010 integers, 74,470 strings) |

## Evidence

- `inputs=84480 mismatches=0`. Every output was identical, with SHA-256 `f7cf6c7b719f1cf8a3ff4292684ce3bd35324ec8f01ba6d3cc375190c609cdfa` for both. The inputs file has SHA-256 `2c260202…bc178da`.
- Output mix: 4,999 successful parses, 4,000 roman strings, 69,471 `Invalid roman number`, 6,010 `Invalid decimal value`.
- The plugin's `compare.py` returned `PROVEN: 1 case(s) executed, none differ`, and its one-byte self-check passed (`Harness/evidence/EQUIVALENCE.json`).
- Canaries (each run on a scratch copy, then reverted):
  - Accepting only 1…3999 gave 1 harness mismatch and 2 test failures.
  - Changing `sum -= 2 * previous` to `sum -= previous` gave 2,440 harness mismatches and 1,956 assertion failures.
  - Changing one byte of the output made `compare.py` exit 1.
- `swift test` ran 7 tests with 0 failures.

## What this does not prove

- **Exception messages are masked.** Only the exception *name* is compared. The original's reason text formats an `NSUInteger` with `%d`, so it is unreliable on 64-bit. The Swift errors carry the offending value instead.
- **The legacy code ran on GNUstep, not Apple Foundation.** Debian's GNUstep uses the GCC runtime, which has no ARC. The library was therefore built without ARC, and the driver keeps a single autorelease pool so the library's lazily created static arrays stay alive. Per-call pools crash under non-ARC; that is a harness artifact, not a library bug. `NSPredicate MATCHES` came from GNUstep, which uses ICU. Run the harness again on a Mac (below) to confirm against Apple Foundation.
- **Invalid UTF-8 byte strings were left out.** A Swift `String` cannot hold them.
- The original ObjC XCTest target was not run here (it needs Xcode). The Swift tests port its cases.
- The API shape is new: the methods throw instead of raising, and use `UInt`/`String` instead of `NSUInteger`/`NSString`. Swift callers need `try`.

## Rerun on a Mac

```sh
swift test
Harness/run_equivalence.sh   # uses clang -fobjc-arc -framework Foundation on Darwin
```

On Linux you also need `clang`, `libgnustep-base-dev`, `libblocksruntime-dev` and a Swift 5.9+ toolchain; the script handles the include and runtime flags.

## Credits

Method, verify rules and `compare.py` come from Anthropic's **code-modernization** plugin, part of [claude-plugins-official](https://github.com/anthropics/claude-plugins-official), Apache-2.0. Swift port and harness © Ludovic Landry, MIT (same license as this repository).
