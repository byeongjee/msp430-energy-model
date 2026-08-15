#!/usr/bin/env bash
# Generate only the benchmarks required to estimate energy for a given C file.
# Uses: make interpret (with granularity → model mapping) to list required keys,
# then filters benchmarks.list_benchmarks output and calls benchmarks.gen_benchmarks.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$REPO_ROOT/scripts/pipeline/common.sh"

usage() {
    cat <<'EOF'
Usage: generate_required_benchmarks.sh --file FILE --granularity GRAN
       [--output-dir DIR] [--batch N]
       [--temp-dir DIR] [--max-steps N] [--defines "MACROS"]

Examples:
  # Single file output (all_benchmarks.c)
  ./scripts/benchmarks/generate_required_benchmarks.sh \
      --file examples/c_programs/simple.c \
      --granularity addressing_mode_constant \
      --output-dir tmp/simple_benchmarks

  # Batched output
  ./scripts/benchmarks/generate_required_benchmarks.sh \
      --file examples/c_programs/simple.c \
      --granularity addressing_mode_constant_pair \
      --output-dir training_data/simple_pairs \
      --batch 50
EOF
}

# Defaults
GRANULARITY="addressing_mode_constant"
OUTPUT_DIR="$REPO_ROOT/tmp"
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

mkdir -p "$TEMP_DIR"

# Map granularity -> model understood by interpret (using shared function)
MODEL=$(granularity_to_model "$GRANULARITY") || exit 1

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
uv run python -m benchmarks.list_benchmarks --granularity "$GRANULARITY" \
  | jq --arg keys "$KEYS" --arg payload "$PAYLOAD_KEY" \
      '($keys | split(" ") | map(select(length>0))) as $wanted
       | ($payload) as $payload_key
       | ($payload_key // "instructions") as $payload_name
       | .[$payload_name] as $all
       | ($all // []) as $list
       | ($list | map(select(.name as $n | $wanted | index($n)))) as $filtered_instructions
       | ($list | map(.name)) as $available_instructions
       | ((.hardcoded_benchmarks // []) | map(select(.name as $n | $wanted | index($n)))) as $filtered_hardcoded
       | ((.hardcoded_benchmarks // []) | map(.name)) as $available_hardcoded
       | (.model_benchmarks // []) as $model_benchmarks
       | ($available_instructions + $available_hardcoded) as $all_available
       | ($wanted - $all_available) as $truly_missing
       | {($payload_name): $filtered_instructions, hardcoded_benchmarks: $filtered_hardcoded, model_benchmarks: $model_benchmarks, missing: $truly_missing}' \
  > "$FILTERED_JSON"

MISSING_COUNT=$(jq '.missing | length' "$FILTERED_JSON")
if [[ "$MISSING_COUNT" -gt 0 ]]; then
    MISSING_KEYS="$(jq -r '.missing | join(" ")' "$FILTERED_JSON")"
    log_warn "Missing benchmarks in benchmarks.list_benchmarks for: $MISSING_KEYS"
fi

mkdir -p "$OUTPUT_DIR"
echo "Generating benchmarks to directory $OUTPUT_DIR..."

GEN_ARGS=(--granularity "$GRANULARITY" --input "$FILTERED_JSON" --output-dir "$OUTPUT_DIR")
if [[ -n "$BATCH" ]]; then
    GEN_ARGS+=(--batch "$BATCH")
fi

uv run python -m benchmarks.gen_benchmarks "${GEN_ARGS[@]}"
echo "✓ Benchmarks written to $OUTPUT_DIR (log: $LOG_FILE)"
