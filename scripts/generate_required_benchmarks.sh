#!/usr/bin/env bash
# Generate only the benchmarks required to estimate energy for a given C file.
# Uses: make interpret (with granularity → model mapping) to list required keys,
# then filters list_benchmarks.py output and calls gen_benchmarks.py.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/common.sh"

usage() {
    cat <<'EOF'
Usage: generate_required_benchmarks.sh --file FILE --granularity GRAN
       [--output FILE | --output-dir DIR --batch N]
       [--temp-dir DIR] [--max-steps N] [--defines "MACROS"]

Examples:
  # Single output file (default)
  ./scripts/generate_required_benchmarks.sh \
      --file examples/c_programs/simple.c \
      --granularity addressing_mode_constant \
      --output tmp/simple_required.c

  # Batched output
  ./scripts/generate_required_benchmarks.sh \
      --file examples/c_programs/simple.c \
      --granularity addressing_mode_constant_pair \
      --output-dir training_data/simple_pairs \
      --batch 50
EOF
}

# Defaults
GRANULARITY="addressing_mode_constant"
OUTPUT="$REPO_ROOT/tmp/required_benchmarks.c"
OUTPUT_DIR=""
BATCH=""
TEMP_DIR="${TEMP_DIR:-$REPO_ROOT/tmp}"
MAX_STEPS=""
DEFINES=""
FILE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --file)
            FILE="$2"; shift 2 ;;
        --granularity)
            GRANULARITY="$2"; shift 2 ;;
        --output)
            OUTPUT="$2"; shift 2 ;;
        --output-dir)
            OUTPUT_DIR="$2"; shift 2 ;;
        --batch)
            BATCH="$2"; shift 2 ;;
        --temp-dir)
            TEMP_DIR="$2"; shift 2 ;;
        --max-steps)
            MAX_STEPS="$2"; shift 2 ;;
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

if [[ -n "$OUTPUT_DIR" && -z "$BATCH" ]]; then
    echo "ERROR: --batch is required when --output-dir is set" >&2
    exit 1
fi

mkdir -p "$TEMP_DIR"

# Map granularity -> model understood by interpret
case "$GRANULARITY" in
    opcode) MODEL="mean_per_instruction" ;;
    addressing_mode) MODEL="mean_per_addressing_mode" ;;
    addressing_mode_constant) MODEL="mean_per_addressing_mode_constant" ;;
    opcode_pair|addressing_mode_pair|addressing_mode_constant_pair) MODEL="mean_per_pair_addressing_mode_constant" ;;
    *)
        echo "Unknown granularity: $GRANULARITY" >&2
        echo "Expected one of: opcode, addressing_mode, addressing_mode_constant, opcode_pair, addressing_mode_pair, addressing_mode_constant_pair" >&2
        exit 1 ;;
esac

TIMESTAMP="$(create_timestamp)"
LOG_FILE="$TEMP_DIR/interpret_keys_${TIMESTAMP}.log"
MAKE_ARGS=(interpret FILE="$FILE" GRANULARITY="$GRANULARITY")
[[ -n "$MAX_STEPS" ]] && MAKE_ARGS+=(MAX_STEPS="$MAX_STEPS")
[[ -n "$DEFINES" ]] && MAKE_ARGS+=(DEFINES="$DEFINES")

echo "Running interpret to extract required keys (granularity=$GRANULARITY, model=$MODEL)..."
(
  cd "$REPO_ROOT"
  make -s "${MAKE_ARGS[@]}"
) > "$LOG_FILE" 2>&1

ENTRY="$(grep -E 'All events param_(keys|pairs):' "$LOG_FILE" | tail -n1 || true)"
if [[ -z "$ENTRY" ]]; then
    echo "ERROR: No parameter keys found. Check log: $LOG_FILE" >&2
    exit 1
fi

if echo "$ENTRY" | grep -q "param_pairs:"; then
    KEYS_RAW="${ENTRY##*: }"
    KEYS="$(printf "%s\n" "$KEYS_RAW" | tr ' ' '\n' | sed 's/ -> /__/g' | tr '\n' ' ')"
    PAYLOAD_KEY="pairs"
else
    KEYS="${ENTRY##*: }"
    PAYLOAD_KEY="instructions"
fi

FILTERED_JSON="$TEMP_DIR/required_keys_${TIMESTAMP}.json"
echo "Filtering benchmark list for keys: $KEYS"
python "$REPO_ROOT/scripts/list_benchmarks.py" --granularity "$GRANULARITY" \
  | jq --arg keys "$KEYS" --arg payload "$PAYLOAD_KEY" \
      '($keys | split(" ") | map(select(length>0))) as $wanted
       | ($payload) as $payload_key
       | ($payload_key // "instructions") as $payload_name
       | .[$payload_name] as $all
       | ($all // []) as $list
       | ($list | map(select(.name as $n | $wanted | index($n)))) as $filtered
       | ($list | map(.name)) as $available
       | ($wanted - $available) as $missing
       | {($payload_name): $filtered, missing: $missing}' \
  > "$FILTERED_JSON"

MISSING_COUNT=$(jq '.missing | length' "$FILTERED_JSON")
if [[ "$MISSING_COUNT" -gt 0 ]]; then
    MISSING_KEYS="$(jq -r '.missing | join(" ")' "$FILTERED_JSON")"
    log_warn "Missing benchmarks in list_benchmarks.py for: $MISSING_KEYS"
fi

if [[ -n "$OUTPUT_DIR" ]]; then
    mkdir -p "$OUTPUT_DIR"
    echo "Generating benchmarks to directory $OUTPUT_DIR (batch=$BATCH)..."
    python "$REPO_ROOT/scripts/gen_benchmarks.py" \
        --granularity "$GRANULARITY" \
        --input "$FILTERED_JSON" \
        --output-dir "$OUTPUT_DIR" \
        --batch "$BATCH"
    echo "✓ Benchmarks written to $OUTPUT_DIR (log: $LOG_FILE)"
else
    echo "Generating benchmarks to $OUTPUT..."
    python "$REPO_ROOT/scripts/gen_benchmarks.py" \
        --granularity "$GRANULARITY" \
        --input "$FILTERED_JSON" \
        --output "$OUTPUT"
    echo "✓ Benchmarks written to $OUTPUT (log: $LOG_FILE)"
fi
