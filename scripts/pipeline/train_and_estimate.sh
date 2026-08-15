#!/usr/bin/env bash
# Full pipeline: measure train → measure estimate → preprocess both → train → estimate → compare
# Usage: ./scripts/pipeline/train_and_estimate.sh [options]
# Requires: bash 4.0+ (for mapfile)

# Setup script directory before sourcing common
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities and configuration
source "$SCRIPT_DIR/common.sh"

# Default values (using common defaults where applicable)
VOLTAGE="${VOLTAGE_DEFAULT}"
MAX_CURRENT="${MAX_CURRENT_DEFAULT}"
TEMP_DIR="${TEMP_DIR:-${TEMP_DIR_DEFAULT}}"
REPORT_DIR="${REPORT_DIR:-${REPORT_DIR_DEFAULT}}"
SKIP_FLASH=""
MAX_STEPS=""
N_SAMPLES=""
MODEL="gamma_per_instruction"
INFERENCE="importance-sampling"
KEEP_INTERMEDIATES=0
TAG=""
TRAIN_DEFINES=""  # Space-separated list of compiler macros for training files
ESTIMATE_DEFINES=""  # Space-separated list of compiler macros for estimation file
INTERCEPT_SPECIAL_CALLS=0

# Required parameters (to be set via command line)
TRAIN_FILES=""  # Semicolon-separated list of training files
ESTIMATE_FILE=""
TRAINING_SEGMENTS_CSV=""  # Semicolon-separated list (optional, for resuming)
PARAMS_FILE=""
ESTIMATED_STATS_JSON=""
TEST_SEGMENTS_CSV=""

# Optional intermediate files
USE_TEMP_PARAMS=0
USE_TEMP_TEST_SEGMENTS=0

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Full pipeline: measure train → measure estimate → preprocess both → train → estimate → compare

Required arguments:
  --train-files PATTERN     C file(s) to train the model from (supports glob patterns and brace expansion)
  --estimate-file FILE      C file to estimate energy for

Optional arguments:
  --training-segments-csv PATTERN  Preprocessed segments CSV file(s) for training (glob pattern, semicolon-separated, or matched by basename)
  --test-segments-csv FILE       Preprocessed segments CSV file for estimation (default: temp file)
  --params FILE             Model parameters JSON file (default: temp file)
  --tag TAG                 Tag for naming output files (default: process ID)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --max-steps N             Maximum execution steps for train/estimate
  --n-samples N             Number of samples for inference (default: 100)
  --model MODEL             Energy model: gamma_per_instruction, gamma_per_addressing_mode, mean_per_instruction, mean_per_addressing_mode (default: gamma_per_instruction)
  --inference ALG           Inference algorithm: importance-sampling, mcmc-blocked, dominant-key, map, upper-bound-lp, or least-squares variants (default: importance-sampling)
  --train-defines "MACROS"  Space-separated compiler macros for training files (e.g., "FOO=1 BAR")
  --estimate-defines "MACROS"  Space-separated compiler macros for estimation file (e.g., "FOO=1 BAR")
  --intercept-special-calls  Model __mspabi_* helper calls as single composite instructions
  --report-dir DIR          Directory for comparison report (default: ./report)
  --skip-flash              Measure the program already on the target
  --keep-intermediates      Keep intermediate files and suggest resume commands
  --help                    Show this help message

Examples:
  # Single training file
  $0 --train-files examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c

  # All .c files in a directory
  $0 --train-files "examples/c_programs/*.c" \\
     --estimate-file examples/c_programs/test.c

  # Recursive glob (all .c files in subdirectories)
  $0 --train-files "examples/**/*.c" \\
     --estimate-file examples/c_programs/test.c

  # Brace expansion (specific files)
  $0 --train-files "examples/c_programs/{file1,file2,file3}.c" \\
     --estimate-file examples/c_programs/test.c

  # Brace expansion with directories
  $0 --train-files "examples/{crypto,math}/*.c" \\
     --estimate-file examples/c_programs/test.c \\
     --tag multi_dir

  # Resume with existing segments (matched by basename)
  $0 --train-files "training_data/*.c" \\
     --estimate-file examples/c_programs/test.c \\
     --training-segments-csv "./tmp/*_segments.csv" \\
     --num-repeat 100
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --train-files)
            TRAIN_FILES="$2"
            shift 2
            ;;
        --estimate-file)
            ESTIMATE_FILE="$2"
            shift 2
            ;;
        --training-segments-csv)
            TRAINING_SEGMENTS_CSV="$2"
            shift 2
            ;;
        --test-segments-csv)
            TEST_SEGMENTS_CSV="$2"
            shift 2
            ;;
        --params)
            PARAMS_FILE="$2"
            shift 2
            ;;
        --tag)
            TAG="$2"
            shift 2
            ;;
        --voltage)
            VOLTAGE="$2"
            shift 2
            ;;
        --max-current)
            MAX_CURRENT="$2"
            shift 2
            ;;
        --max-steps)
            MAX_STEPS="$2"
            shift 2
            ;;
        --n-samples)
            N_SAMPLES="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --inference)
            INFERENCE="$2"
            shift 2
            ;;
        --train-defines)
            TRAIN_DEFINES="$2"
            shift 2
            ;;
        --estimate-defines)
            ESTIMATE_DEFINES="$2"
            shift 2
            ;;
        --intercept-special-calls)
            INTERCEPT_SPECIAL_CALLS=1
            shift
            ;;
        --report-dir)
            REPORT_DIR="$2"
            shift 2
            ;;
        --skip-flash)
            SKIP_FLASH="--skip-flash"
            shift
            ;;
        --keep-intermediates)
            KEEP_INTERMEDIATES=1
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$TRAIN_FILES" ]]; then
    log_error "Missing required argument: --train-files"
    usage
    exit 1
fi

if [[ -z "$ESTIMATE_FILE" ]]; then
    log_error "Missing required argument: --estimate-file"
    usage
    exit 1
fi

# Parse training files into array using pattern expansion
mapfile -t TRAIN_FILE_ARRAY < <(expand_file_input "$TRAIN_FILES")

# Check if any files were found
if [[ ${#TRAIN_FILE_ARRAY[@]} -eq 0 ]]; then
    log_error "No training files found matching pattern: $TRAIN_FILES"
    exit 1
fi

log_info "Found ${#TRAIN_FILE_ARRAY[@]} training file(s) from pattern: $TRAIN_FILES"

# Check if training files exist (should always pass after expand_file_input)
for train_file in "${TRAIN_FILE_ARRAY[@]}"; do
    if [[ ! -f "$train_file" ]]; then
        log_error "Training file not found: $train_file"
        exit 1
    fi
done

# Check if estimation file exists
if [[ ! -f "$ESTIMATE_FILE" ]]; then
    log_error "Estimation file not found: $ESTIMATE_FILE"
    exit 1
fi

# Setup temporary files if not provided
mkdir -p "$TEMP_DIR"

# Create timestamp
TIMESTAMP=$(create_timestamp)

# Determine file suffix (TAG_TIMESTAMP if TAG provided, otherwise just TIMESTAMP)
if [[ -n "$TAG" ]]; then
    FILE_SUFFIX="${TAG}_${TIMESTAMP}"
    REPORT_DIR_FULL="${REPORT_DIR}/${TAG}"
else
    FILE_SUFFIX="${TIMESTAMP}"
    REPORT_DIR_FULL="${REPORT_DIR}/${TIMESTAMP}"
fi

# Note: Training segments CSV matching is handled by train.sh
# We only need to validate training files here for early error detection

log_info "Training files: ${#TRAIN_FILE_ARRAY[@]}"
for i in "${!TRAIN_FILE_ARRAY[@]}"; do
    log_info "  [$((i+1))] ${TRAIN_FILE_ARRAY[$i]}"
done

if [[ -z "$PARAMS_FILE" ]]; then
    PARAMS_FILE="$TEMP_DIR/params_${FILE_SUFFIX}.json"
    USE_TEMP_PARAMS=1
    log_info "Using temporary params file: $PARAMS_FILE"
fi

# Setup temporary file for estimated stats (always temp)
ESTIMATED_STATS_JSON="$TEMP_DIR/estimated_stats_${FILE_SUFFIX}.json"

# Setup temporary file for test segments if not provided
if [[ -z "$TEST_SEGMENTS_CSV" ]]; then
    TEST_SEGMENTS_CSV="$TEMP_DIR/measured_segments_${FILE_SUFFIX}.csv"
    USE_TEMP_TEST_SEGMENTS=1
    log_info "Using temporary test segments CSV: $TEST_SEGMENTS_CSV"
fi

# Expand patterns for test segments CSV (if provided as patterns)
if [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ $USE_TEMP_TEST_SEGMENTS -eq 0 ]]; then
    # Check if pattern contains wildcards
    if [[ "$TEST_SEGMENTS_CSV" == *"*"* ]] || [[ "$TEST_SEGMENTS_CSV" == *"?"* ]] || [[ "$TEST_SEGMENTS_CSV" == *"{"* ]]; then
        log_info "Expanding test segments CSV pattern: $TEST_SEGMENTS_CSV"
        TEST_SEGMENTS_CSV=$(match_single_file "$TEST_SEGMENTS_CSV" "test segments CSV")
        log_info "Matched test segments CSV: $TEST_SEGMENTS_CSV"
    fi
    # Verify file exists after expansion
    if [[ -f "$TEST_SEGMENTS_CSV" ]]; then
        log_info "✓ Test segments CSV exists: $TEST_SEGMENTS_CSV"
    else
        log_info "✗ Test segments CSV does not exist: $TEST_SEGMENTS_CSV"
        log_info "Will proceed with measurement and preprocessing instead of skipping"
    fi
fi

log_info "Report will be saved to: $REPORT_DIR_FULL"

# Extract basename for estimation file
ESTIMATE_BASENAME=$(get_basename "$ESTIMATE_FILE")

# ============================================================
# EXTRACT EVENT LABELS (for estimation file only - train.sh handles training files)
# ============================================================

ESTIMATE_EVENT_LABELS_JSON="$TEMP_DIR/labels_${ESTIMATE_BASENAME}_${TIMESTAMP}.json"
log_info "Extracting event labels from $ESTIMATE_FILE..."
extract_event_labels "$ESTIMATE_FILE" "$ESTIMATE_EVENT_LABELS_JSON"

# Build MAX_STEPS_FLAG (used in estimation Julia call)
MAX_STEPS_FLAG=""
if [[ -n "$MAX_STEPS" ]]; then
    MAX_STEPS_FLAG="--max-steps $MAX_STEPS"
fi

# Process estimation defines

ESTIMATE_DEFINE_FLAGS=$(process_defines "$ESTIMATE_DEFINES")
if [[ -n "$ESTIMATE_DEFINES" ]]; then
    log_info "Using estimation compiler defines: $ESTIMATE_DEFINES"
fi

# Determine which steps to skip based on provided intermediate files
SKIP_TRAINING=0
SKIP_ESTIMATION_MEASUREMENT=0

# If PARAMS provided and exists, skip training
if [[ -n "$PARAMS_FILE" ]] && [[ -f "$PARAMS_FILE" ]] && [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    SKIP_TRAINING=1
    log_info "Using existing params: $PARAMS_FILE (training skipped)"
fi

# Check test segments - if provided, skip test measurement and preprocessing
if [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]] && [[ $USE_TEMP_TEST_SEGMENTS -eq 0 ]]; then
    SKIP_ESTIMATION_MEASUREMENT=1
    log_info "Using existing test segments CSV: $TEST_SEGMENTS_CSV - skipping test measurement and preprocessing"
fi

# Cleanup function
# Note: Training cleanup (segments CSV, event labels) is handled by train.sh
cleanup() {
    if [[ $KEEP_INTERMEDIATES -eq 1 ]]; then
        return
    fi

    if [[ $USE_TEMP_PARAMS -eq 1 ]] && [[ -f "$PARAMS_FILE" ]]; then
        log_info "Cleaning up temporary params file: $PARAMS_FILE"
        rm -f "$PARAMS_FILE"
    fi
    if [[ $USE_TEMP_TEST_SEGMENTS -eq 1 ]] && [[ -f "$TEST_SEGMENTS_CSV" ]]; then
        log_info "Cleaning up temporary test segments CSV: $TEST_SEGMENTS_CSV"
        rm -f "$TEST_SEGMENTS_CSV"
    fi
}

# Register cleanup on exit
trap cleanup EXIT

# ============================================================
# MAIN PIPELINE
# ============================================================

log_step "PIPELINE START"
log_info "Training files: ${#TRAIN_FILE_ARRAY[@]}"
for train_file in "${TRAIN_FILE_ARRAY[@]}"; do
    log_info "  - $train_file"
done
log_info "Estimate file: $ESTIMATE_FILE"
log_info "Report directory: $REPORT_DIR_FULL"

mkdir -p "$BUILD_DIR" "$ASM_DIR"
cd "$PROJECT_ROOT"

# Training pipeline (measurement, preprocessing, training)
# Delegate to train.sh script
if [[ $SKIP_TRAINING -eq 0 ]]; then
    log_step "Training pipeline (via train.sh)"

    # Build arguments for train.sh
    TRAIN_ARGS=("--train-files" "$TRAIN_FILES")
    [[ -n "$TRAINING_SEGMENTS_CSV" ]] && TRAIN_ARGS+=("--training-segments-csv" "$TRAINING_SEGMENTS_CSV")
    [[ -n "$PARAMS_FILE" ]] && TRAIN_ARGS+=("--params" "$PARAMS_FILE")
    [[ -n "$TAG" ]] && TRAIN_ARGS+=("--tag" "$TAG")
    [[ -n "$TIMESTAMP" ]] && TRAIN_ARGS+=("--timestamp" "$TIMESTAMP")
    [[ -n "$VOLTAGE" ]] && TRAIN_ARGS+=("--voltage" "$VOLTAGE")
    [[ -n "$MAX_CURRENT" ]] && TRAIN_ARGS+=("--max-current" "$MAX_CURRENT")
    [[ -n "$MAX_STEPS" ]] && TRAIN_ARGS+=("--max-steps" "$MAX_STEPS")
    [[ -n "$N_SAMPLES" ]] && TRAIN_ARGS+=("--n-samples" "$N_SAMPLES")
    [[ -n "$MODEL" ]] && TRAIN_ARGS+=("--model" "$MODEL")
    [[ -n "$INFERENCE" ]] && TRAIN_ARGS+=("--inference" "$INFERENCE")
    [[ -n "$TRAIN_DEFINES" ]] && TRAIN_ARGS+=("--defines" "$TRAIN_DEFINES")
    [[ -n "$SKIP_FLASH" ]] && TRAIN_ARGS+=("--skip-flash")
    [[ $KEEP_INTERMEDIATES -eq 1 ]] && TRAIN_ARGS+=("--keep-intermediates")
    [[ $INTERCEPT_SPECIAL_CALLS -eq 1 ]] && TRAIN_ARGS+=("--intercept-special-calls")

    # Call train.sh
    "$SCRIPT_DIR/train.sh" "${TRAIN_ARGS[@]}"
    log_success "Training pipeline completed"
else
    log_step "Training pipeline SKIPPED (using existing params: $PARAMS_FILE)"
fi

# Estimation measurement and preprocessing (measure → preprocess → remove raw data)
if [[ $SKIP_ESTIMATION_MEASUREMENT -eq 0 ]]; then
    # Run measurement pipeline: compile → flash → measure → preprocess → cleanup raw
    measure_and_preprocess "$ESTIMATE_FILE" "$TEST_SEGMENTS_CSV" "$ESTIMATE_EVENT_LABELS_JSON" "$ESTIMATE_DEFINE_FLAGS"
else
    log_step "Estimation measurement and preprocessing SKIPPED (using existing test segments CSV: $TEST_SEGMENTS_CSV)"
fi

echo ""
log_info "==> Hardware no longer required - remaining steps can run offline"
echo ""

# Compile estimation file for estimation (with NUM_REPEAT=1)
log_step "Compiling estimation file for estimation"
log_info "Compiling for estimation (with NUM_REPEAT=1)"

# Override NUM_REPEAT to 1 for estimation compilation
ESTIMATE_DEFINES_FOR_ESTIMATION=$(override_define "$ESTIMATE_DEFINES" "NUM_REPEAT" "1")
ESTIMATE_DEFINE_FLAGS_FOR_ESTIMATION=$(process_defines "$ESTIMATE_DEFINES_FOR_ESTIMATION")

compile_and_disasm "$ESTIMATE_FILE" "$ESTIMATE_DEFINE_FLAGS_FOR_ESTIMATION"

# Estimate energy consumption
log_step "Estimating energy consumption"
julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" estimate \
    --asm "$ASM_DIR/${ESTIMATE_BASENAME}.asm" \
    --params "$PARAMS_FILE" \
    --output "$ESTIMATED_STATS_JSON" \
    --data-dump "$ASM_DIR/${ESTIMATE_BASENAME}.data" \
    $([[ $INTERCEPT_SPECIAL_CALLS -eq 1 ]] && printf '%s' "--intercept-special-calls") \
    $MAX_STEPS_FLAG
log_success "Estimation complete: $ESTIMATED_STATS_JSON"

# Generate comparison report
log_step "Generating comparison report"

# Extract NUM_REPEAT from ESTIMATE_DEFINES
NUM_REPEAT=$(extract_define "$ESTIMATE_DEFINES" "NUM_REPEAT")

if [[ -z "$NUM_REPEAT" ]]; then
    log_error "NUM_REPEAT not found in ESTIMATE_DEFINES. Please add NUM_REPEAT=<value> to --estimate-defines"
    exit 1
fi

log_info "Using NUM_REPEAT=$NUM_REPEAT from estimation defines"

uv run python -m reports.generate_comparison_report \
    --estimated-stats "$ESTIMATED_STATS_JSON" \
    --measured-data "$TEST_SEGMENTS_CSV" \
    --report-dir "$REPORT_DIR_FULL" \
    --num-repeat "$NUM_REPEAT"
log_success "Comparison report generated: $REPORT_DIR_FULL"

# Cleanup temp files
rm -f "$ESTIMATED_STATS_JSON"
rm -f "$ESTIMATE_EVENT_LABELS_JSON"

# Done
log_step "PIPELINE COMPLETE"
log_success "All steps completed successfully!"
echo ""
log_info "Output files:"
echo "  - Comparison Report: $REPORT_DIR_FULL/"
echo "    - comparison.md (detailed markdown report with all events)"
echo "    - event_N_estimated.png (per-event estimated distributions)"
echo "    - event_N_measured.png (per-event measured distributions)"
echo "    - event_N_comparison.png (per-event comparisons)"
# Note: Training outputs (segments CSVs, params) are reported by train.sh
if [[ $USE_TEMP_TEST_SEGMENTS -eq 0 ]]; then
    echo "  - Test Segments CSV: $TEST_SEGMENTS_CSV"
fi
if [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    echo "  - Parameters: $PARAMS_FILE"
fi
