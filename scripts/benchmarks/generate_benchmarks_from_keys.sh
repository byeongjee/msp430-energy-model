#!/usr/bin/env bash
# Generate benchmarks from a keys file (newline- or comma-separated key names).
#
# Usage:
#   ./scripts/benchmarks/generate_benchmarks_from_keys.sh \
#       --keys all_keys.txt \
#       --granularity addressing_mode \
#       --output-dir training_data/checkpoint_insertion \
#       --batch 10

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Python packages under scripts/ are invoked as `python -m <package>.<module>`
export PYTHONPATH="$REPO_ROOT/scripts${PYTHONPATH:+:$PYTHONPATH}"

usage() {
    cat <<'EOF'
Usage: generate_benchmarks_from_keys.sh --keys FILE --granularity GRAN
       [--output-dir DIR] [--batch N] [--defines "MACROS"]

Arguments:
  --keys FILE          File containing newline- or comma-separated key names
  --granularity GRAN   Model granularity (e.g., addressing_mode, addressing_mode_constant)
  --output-dir DIR     Output directory for generated benchmarks (default: tmp/)
  --batch N            Number of instructions per batch file
  --defines "MACROS"   Space-separated compiler macros to bake into generated
                       hardcoded .S benchmarks (e.g., "NUM_REPEAT=30")
EOF
}

# Defaults
KEYS_FILE="$REPO_ROOT/all_keys.txt"
GRANULARITY="addressing_mode"
OUTPUT_DIR="$REPO_ROOT/training_data/checkpoint_insertion"
BATCH="10"
DEFINES=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --keys)       KEYS_FILE="$2"; shift 2 ;;
        --granularity) GRANULARITY="$2"; shift 2 ;;
        --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
        --batch)      BATCH="$2"; shift 2 ;;
        --defines)    DEFINES="$2"; shift 2 ;;
        -h|--help)    usage; exit 0 ;;
        *)            echo "Unknown option: $1" >&2; usage; exit 1 ;;
    esac
done

if [[ -z "$KEYS_FILE" ]]; then
    echo "ERROR: --keys is required" >&2
    usage
    exit 1
fi

if [[ ! -f "$KEYS_FILE" ]]; then
    echo "ERROR: Keys file not found: $KEYS_FILE" >&2
    exit 1
fi

# Read keys and normalize common separators to spaces
KEYS=$(tr ',\n\r\t' '    ' < "$KEYS_FILE")

# Build gen_benchmarks args
GEN_ARGS=(--granularity "$GRANULARITY" --output-dir "$OUTPUT_DIR")
if [[ -n "$BATCH" ]]; then
    GEN_ARGS+=(--batch "$BATCH")
fi
if [[ -n "$DEFINES" ]]; then
    GEN_ARGS+=(--defines "$DEFINES")
fi

# Determine the payload field name based on granularity
PAYLOAD_NAME="instructions"
case "$GRANULARITY" in
    *_pair*) PAYLOAD_NAME="instruction_pairs" ;;
esac

echo "=== Generating benchmarks from keys ==="
echo "Keys file:    $KEYS_FILE"
echo "Granularity:  $GRANULARITY"
echo "Output dir:   $OUTPUT_DIR"
echo "Key count:    $(echo $KEYS | wc -w | tr -d ' ')"
if [[ -n "$DEFINES" ]]; then
    echo "Defines:      $DEFINES"
fi
echo ""

uv run python -m benchmarks.list_benchmarks --granularity "$GRANULARITY" \
    | jq --arg keys "$KEYS" --arg payload "$PAYLOAD_NAME" \
        '($keys | split(" ") | map(select(length>0))) as $wanted
         | .[$payload] as $all
         | ($all | map(select(.name as $n | $wanted | index($n)))) as $filtered
         | ((.hardcoded_benchmarks // []) | map(select(.name as $n | $wanted | index($n)))) as $filtered_hardcoded
         | (.model_benchmarks // []) as $model_benchmarks
         | {($payload): $filtered, hardcoded_benchmarks: $filtered_hardcoded, model_benchmarks: $model_benchmarks}' \
    | CC="$MSP430GCC_TOOLCHAIN_PATH/bin/msp430-elf-gcc" \
      INCLUDES="-I$MSP430GCC_SUPPORT_PATH/include -I include" \
      PATH="$MSP430GCC_TOOLCHAIN_PATH/bin:$PATH" \
      uv run python -m benchmarks.gen_benchmarks "${GEN_ARGS[@]}"
