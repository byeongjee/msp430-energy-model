#!/usr/bin/env bash
# Generate reassemblable .S files for hardcoded branch benchmarks.
#
# The branch chains keep their full control flow inside inline asm so the
# generated assembly stays stable under optimization.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    cat <<'EOF'
Usage: compile_br_immediate_benchmark.sh --file FILE [--defines "MACROS"]

Examples:
  ./scripts/compile_br_immediate_benchmark.sh \
      --file scripts/hardcoded_benchmarks/br_immediate_benchmark.c

  ./scripts/compile_br_immediate_benchmark.sh \
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

if [[ "$BASENAME" == "br_immediate_benchmark" || "$BASENAME" == "br_indexed_benchmark" ]]; then
    OUTPUT_S="$ASM_DIR/$BASENAME.S"
    mkdir -p "$ASM_DIR"

    echo "Generating assembly source for: $FILE"
    echo "=================================================="

    # Use make to generate assembly with the repository's default CFLAGS unless
    # the caller overrides them.
    (
      cd "$REPO_ROOT"
      make compile FILE="$FILE" DEFINES="$DEFINES" CFLAGS="${CFLAGS:--mmcu=MSP430FR5994 -mcpu=msp430 -msmall -mno-warn-mcu -O3 -Wall} -S" > /dev/null
    )

    # Move the generated file to .S extension
    TEMP_ELF="$BUILD_DIR/$BASENAME.elf"
    if [[ -f "$TEMP_ELF" ]]; then
        mv "$TEMP_ELF" "$OUTPUT_S"
    else
        echo "ERROR: Expected output file not found: $TEMP_ELF" >&2
        exit 1
    fi

    # The generated .S contains only base-ISA instructions, but we want it to
    # be reassemblable via the default .S path, which targets the MCU's native
    # ISA. Normalize the emitted ISA attribute so the assembler accepts it.
    perl -0pi -e 's/\.mspabi_attribute 4, 1/.mspabi_attribute 4, 2/' "$OUTPUT_S"

    echo ""
    echo "✓ Assembly generation completed!"
    echo "  Assembly source: $OUTPUT_S"
    echo ""
    echo "You can now compile this .S file normally:"
    echo "  make compile FILE=$OUTPUT_S"
    echo "  make disasm FILE=$OUTPUT_S"
    echo "  make interpret FILE=$OUTPUT_S"
else
    echo "WARNING: Unknown hardcoded benchmark: $BASENAME" >&2
    echo "Only br_immediate_benchmark and br_indexed_benchmark are currently supported" >&2
    exit 1
fi
