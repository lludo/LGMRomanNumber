#!/usr/bin/env bash
# Runs the original Objective-C library and the Swift port on the same inputs and diffs the outputs.
# Linux: needs clang, GNUstep base (gnustep-base dev), libBlocksRuntime and a Swift toolchain.
# macOS: needs only Xcode command line tools.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=Harness/out; mkdir -p "$OUT"

python3 Harness/gen_inputs.py > "$OUT/inputs.txt"

if [[ "$(uname)" == Darwin ]]; then
  clang -fobjc-arc -framework Foundation -ILGMRomanNumber LGMRomanNumber/LGMRomanNumber.m Harness/objc_driver.m -o "$OUT/objc_driver"
else
  # Debian/Ubuntu GNUstep is built on the GCC runtime; blocks come from libBlocksRuntime, dispatch from the Swift toolchain.
  SHIM=$(mktemp -d); mkdir -p "$SHIM/objc"; echo '#include <Block.h>' > "$SHIM/objc/blocks_runtime.h"
  SWIFT_LIB=$(dirname "$(dirname "$(readlink -f "$(command -v swift)")")")/lib/swift
  GCC_INC=$(dirname "$(gcc -print-file-name=include/objc/objc.h)")/..
  clang -w -I"$SHIM" -I"$SWIFT_LIB" -isystem "$GCC_INC" $(gnustep-config --objc-flags) -fobjc-runtime=gcc -fblocks \
    -ILGMRomanNumber LGMRomanNumber/LGMRomanNumber.m Harness/objc_driver.m -o "$OUT/objc_driver" \
    $(gnustep-config --base-libs) -lBlocksRuntime -L"$SWIFT_LIB/linux" -ldispatch -Wl,-rpath,"$SWIFT_LIB/linux"
fi

swift build -c release --product roman-cli >/dev/null
"$OUT/objc_driver" < "$OUT/inputs.txt" > "$OUT/legacy.txt"
"$(swift build -c release --show-bin-path)/roman-cli" < "$OUT/inputs.txt" > "$OUT/new.txt"

total=$(wc -l < "$OUT/inputs.txt")
[[ $(wc -l < "$OUT/legacy.txt") -eq $total && $(wc -l < "$OUT/new.txt") -eq $total ]] || { echo "NOT PROVEN: output line count mismatch"; exit 1; }
paste -d '\t' "$OUT/inputs.txt" "$OUT/legacy.txt" "$OUT/new.txt" | awk -F'\t' '$2 != $3' > "$OUT/mismatches.tsv" || true
mism=$(wc -l < "$OUT/mismatches.tsv")
echo "inputs=$total mismatches=$mism legacy_sha256=$(sha256sum < "$OUT/legacy.txt" | cut -c1-16) new_sha256=$(sha256sum < "$OUT/new.txt" | cut -c1-16)"
if [[ $mism -eq 0 ]] && cmp -s "$OUT/legacy.txt" "$OUT/new.txt"; then echo "PROVEN (byte-identical over the input set)"; else echo "NOT PROVEN"; head "$OUT/mismatches.tsv"; exit 1; fi
