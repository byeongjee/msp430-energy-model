#!/usr/bin/env bash
# Two-pass compilation for hardcoded benchmarks that require absolute addresses.
#
# Pass 1: Compile with placeholder addresses
# Pass 2: Extract actual addresses from disassembly and recompile with -D flags

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    cat <<'EOF'
Usage: compile_hardcoded_benchmarks.sh --file FILE [--defines "MACROS"]

Examples:
  ./scripts/compile_hardcoded_benchmarks.sh \
      --file scripts/hardcoded_benchmarks/br_immediate_benchmark.c

  ./scripts/compile_hardcoded_benchmarks.sh \
      --file scripts/hardcoded_benchmarks/br_immediate_benchmark.c \
      --defines "TEXTUAL_REPT=50 INNER_ITERS=200"
EOF
}

FILE=""
DEFINES=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --file)
            FILE="$2"; shift 2 ;;
        --defines)
            DEFINES="$2"; shift 2 ;;
        --help|-h)
            usage; exit 0 ;;
        *)
            echo "Unknown option: $1" >&2
            usage; exit 1 ;;
    esac
done

if [[ -z "$FILE" ]]; then
    echo "ERROR: --file is required" >&2
    usage; exit 1
fi

BASENAME=$(basename "$FILE" .c)
BUILD_DIR="$REPO_ROOT/build"
ASM_DIR="$BUILD_DIR/asm"

echo "Two-pass compilation for: $FILE"
echo "=================================================="

# Pass 1: Compile with placeholder addresses
echo ""
echo "Pass 1: Compiling with placeholder addresses..."
make -C "$REPO_ROOT" compile FILE="$FILE" DEFINES="$DEFINES" > /dev/null

# Disassemble
echo "Disassembling..."
make -C "$REPO_ROOT" disasm FILE="$FILE" > /dev/null

ASM_FILE="$ASM_DIR/$BASENAME.asm"

# Extract addresses for br_immediate benchmark
if [[ "$BASENAME" == "br_immediate_benchmark" ]]; then
    echo "Extracting addresses for br_immediate benchmark..."

    # Find loop_header address (first address in the loop_header section)
    BR_INITIAL_ADDR=$(grep -A 1 "^[0-9a-f]\+ <loop_header>:" "$ASM_FILE" | tail -n 1 | awk '{print "0x" $1}' | sed 's/:$//')

    # Find loop decrement address (the "add #-1, r12" instruction after all br instructions)
    LOOP_HEADER_ADDR=$(grep "add.*#-1.*r12" "$ASM_FILE" | head -n 1 | awk '{print "0x" $1}' | sed 's/:$//')

    if [[ -z "$BR_INITIAL_ADDR" || -z "$LOOP_HEADER_ADDR" ]]; then
        echo "ERROR: Failed to extract addresses from disassembly" >&2
        echo "BR_INITIAL_ADDR=$BR_INITIAL_ADDR" >&2
        echo "LOOP_HEADER_ADDR=$LOOP_HEADER_ADDR" >&2
        exit 1
    fi

    echo "  BR_INITIAL_ADDR:   $BR_INITIAL_ADDR"
    echo "  LOOP_HEADER_ADDR:  $LOOP_HEADER_ADDR"

    # Pass 2: Recompile with actual addresses
    echo ""
    echo "Pass 2: Recompiling with actual addresses..."

    PASS2_DEFINES="BR_INITIAL_ADDR=$BR_INITIAL_ADDR LOOP_HEADER_ADDR=$LOOP_HEADER_ADDR"
    if [[ -n "$DEFINES" ]]; then
        PASS2_DEFINES="$DEFINES $PASS2_DEFINES"
    fi

    make -C "$REPO_ROOT" disasm FILE="$FILE" DEFINES="$PASS2_DEFINES" > /dev/null

    echo ""
    echo "✓ Two-pass compilation completed!"
    echo "  ELF:  $BUILD_DIR/$BASENAME.elf"
    echo "  ASM:  $ASM_DIR/$BASENAME.asm"
    echo "  DATA: $ASM_DIR/$BASENAME.data"
else
    echo "WARNING: Unknown hardcoded benchmark: $BASENAME" >&2
    echo "Only br_immediate_benchmark is currently supported" >&2
    exit 1
fi
