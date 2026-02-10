#!/usr/bin/env bash
# Pipeline utility functions for MSP430 measurement scripts
#
# This file provides shared functions used across train.sh, train_and_estimate.sh,
# analyze_distribution.sh, and generate_required_benchmarks.sh.
#
# Usage: source this file after sourcing common.sh
#   source "$SCRIPT_DIR/common.sh"
#   source "$SCRIPT_DIR/pipeline_utils.sh"

# ============================================================
# FILE UTILITIES
# ============================================================

# get_basename FILE
#
# Extract basename from a file path, handling both .c and .S extensions.
#
# Arguments:
#   FILE - Path to the file (e.g., "path/to/file.c" or "path/to/file.S")
#
# Returns:
#   Outputs basename without extension to stdout (e.g., "file")
#
# Example:
#   basename=$(get_basename "examples/c_programs/simple.c")
#   # Result: "simple"
get_basename() {
    local file="$1"
    local base
    base=$(basename "$file")
    base="${base%.c}"
    base="${base%.S}"
    echo "$base"
}

# ============================================================
# GRANULARITY/MODEL MAPPING
# ============================================================

# granularity_to_model GRANULARITY
#
# Map user-friendly granularity name to internal model name.
#
# Arguments:
#   GRANULARITY - One of: opcode, addressing_mode, addressing_mode_constant,
#                 addressing_mode_with_mem_access, addressing_mode_constant_with_mem_access,
#                 opcode_pair, addressing_mode_pair, addressing_mode_constant_pair
#
# Returns:
#   0 on success (outputs model name to stdout)
#   1 on error (invalid granularity)
#
# Example:
#   model=$(granularity_to_model "addressing_mode")
#   # Result: "mean_per_addressing_mode"
granularity_to_model() {
    local granularity="$1"
    case "$granularity" in
        opcode)
            echo "mean_per_instruction"
            ;;
        addressing_mode)
            echo "mean_per_addressing_mode"
            ;;
        addressing_mode_constant)
            echo "mean_per_addressing_mode_constant"
            ;;
        addressing_mode_with_mem_access)
            echo "mean_per_addressing_mode_with_mem_access"
            ;;
        addressing_mode_constant_with_mem_access)
            echo "mean_per_addressing_mode_constant_with_mem_access"
            ;;
        opcode_pair|addressing_mode_pair|addressing_mode_constant_pair)
            echo "mean_per_pair_addressing_mode_constant"
            ;;
        *)
            log_error "Unknown granularity: $granularity"
            log_error "Expected one of: opcode, addressing_mode, addressing_mode_constant, addressing_mode_with_mem_access, addressing_mode_constant_with_mem_access, opcode_pair, addressing_mode_pair, addressing_mode_constant_pair"
            return 1
            ;;
    esac
}

# ============================================================
# EVENT LABELS
# ============================================================

# extract_event_labels FILE OUTPUT_JSON
#
# Extract event labels from a C/S source file using extract_bench_labels.py.
#
# Arguments:
#   FILE        - Path to the C or S source file
#   OUTPUT_JSON - Path where the JSON output should be written
#
# Returns:
#   0 on success
#   Non-zero on error
#
# Example:
#   extract_event_labels "examples/simple.c" "/tmp/labels.json"
extract_event_labels() {
    local file="$1"
    local output_json="$2"

    python3 "$EXTRACT_BENCH_LABELS_PY" \
        --input "$file" \
        --output "$output_json" \
        --format json
}

# ============================================================
# FLAG BUILDING
# ============================================================

# build_julia_flags MAX_STEPS N_SAMPLES MODEL INFERENCE
#
# Build common Julia command line flags for train/estimate commands.
# Empty parameters are skipped.
#
# Arguments:
#   MAX_STEPS  - Maximum execution steps (or empty)
#   N_SAMPLES  - Number of samples for inference (or empty)
#   MODEL      - Model name (or empty)
#   INFERENCE  - Inference algorithm (or empty)
#
# Returns:
#   Outputs space-separated flags to stdout
#
# Example:
#   flags=$(build_julia_flags "1000" "100" "mean_per_addressing_mode" "importance-sampling")
#   # Result: "--max-steps 1000 --n-samples 100 --model mean_per_addressing_mode --inference importance-sampling"
build_julia_flags() {
    local max_steps="$1"
    local n_samples="$2"
    local model="$3"
    local inference="$4"
    local flags=""

    if [[ -n "$max_steps" ]]; then
        flags="$flags --max-steps $max_steps"
    fi
    if [[ -n "$n_samples" ]]; then
        flags="$flags --n-samples $n_samples"
    fi
    if [[ -n "$model" ]]; then
        flags="$flags --model $model"
    fi
    if [[ -n "$inference" ]]; then
        flags="$flags --inference $inference"
    fi

    # Trim leading space
    echo "${flags# }"
}

# ============================================================
# MEASUREMENT PIPELINE
# ============================================================

# measure_and_preprocess FILE SEGMENTS_CSV EVENT_LABELS_JSON DEFINE_FLAGS [RAW_CSV]
#
# Execute the measurement pipeline for a single file:
#   Compile → Flash → Measure → Preprocess → Cleanup raw data
#
# Arguments:
#   FILE              - Path to the C or S source file
#   SEGMENTS_CSV      - Path where preprocessed segments should be saved
#   EVENT_LABELS_JSON - Path to the event labels JSON file
#   DEFINE_FLAGS      - Compiler define flags (e.g., "-DFOO=1 -DBAR")
#   RAW_CSV           - (Optional) Path for raw measurement CSV. If not provided,
#                       a temp file is used and deleted after preprocessing.
#
# Environment variables used:
#   CC, CFLAGS, INCLUDES, LDFLAGS - Compiler settings
#   BUILD_DIR - Build output directory
#   VOLTAGE, MAX_CURRENT - Measurement settings
#   SKIP_RESET - If set, passed to measure.py
#   MEASURE_PY, PREPROCESS_PY - Python script paths
#
# Returns:
#   0 on success
#   Non-zero on error
#
# Example:
#   measure_and_preprocess "simple.c" "segments.csv" "labels.json" "-DNUM_REPEAT=100"
measure_and_preprocess() {
    local file="$1"
    local segments_csv="$2"
    local event_labels_json="$3"
    local define_flags="$4"
    local raw_csv="${5:-}"

    local base
    base=$(get_basename "$file")

    local cleanup_raw=0
    if [[ -z "$raw_csv" ]]; then
        raw_csv="$TEMP_DIR/${base}_raw_$(create_timestamp).csv"
        cleanup_raw=1
    fi

    # Compile
    log_step "Compiling $base"
    $CC $CFLAGS $define_flags $INCLUDES $LDFLAGS -o "$BUILD_DIR/${base}.elf" "$file"
    log_success "Compiled: $BUILD_DIR/${base}.elf"

    # Measure (flash is done inside measure.py via --reset_cmd with GPO2 control)
    log_step "Flashing and measuring energy consumption for $base"
    log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
    python3 "$MEASURE_PY" \
        --voltage "$VOLTAGE" \
        --max_current "$MAX_CURRENT" \
        --outfile "$raw_csv" \
        --reset_cmd "mspdebug tilib 'prog $BUILD_DIR/${base}.elf' 'exit'" \
        ${SKIP_RESET:-}
    log_success "Raw measurement saved: $raw_csv"

    # Preprocess
    log_step "Preprocessing measurements for $base"
    python3 "$PREPROCESS_PY" \
        --input "$raw_csv" \
        --output "$segments_csv" \
        --event-labels "$event_labels_json"
    log_success "Segments saved: $segments_csv"

    # Cleanup raw data if using temp file
    if [[ $cleanup_raw -eq 1 ]]; then
        rm -f "$raw_csv"
        log_info "Removed raw data: $raw_csv"
    fi
}

# compile_and_disasm FILE DEFINE_FLAGS
#
# Compile a file and generate disassembly.
#
# Arguments:
#   FILE         - Path to the C or S source file
#   DEFINE_FLAGS - Compiler define flags (e.g., "-DFOO=1 -DBAR")
#
# Environment variables used:
#   CC, CFLAGS, INCLUDES, LDFLAGS - Compiler settings
#   BUILD_DIR, ASM_DIR - Output directories
#
# Returns:
#   0 on success
#   Non-zero on error
compile_and_disasm() {
    local file="$1"
    local define_flags="${2:-}"

    local base
    base=$(get_basename "$file")

    # Compile
    $CC $CFLAGS $define_flags $INCLUDES $LDFLAGS -o "$BUILD_DIR/${base}.elf" "$file"
    log_info "Compiled: $BUILD_DIR/${base}.elf"

    # Disassemble
    disasm "$BUILD_DIR/${base}.elf" "$ASM_DIR/${base}.asm" "$ASM_DIR/${base}.data"
    log_info "Disassembled: $ASM_DIR/${base}.asm"
    log_info "Data dump: $ASM_DIR/${base}.data"
}
