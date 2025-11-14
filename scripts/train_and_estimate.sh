#!/usr/bin/env bash
# Full pipeline: measure train → measure estimate → preprocess both → train → estimate → compare
# Usage: ./scripts/train_and_estimate.sh [options]
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
SKIP_RESET=""
MAX_STEPS=""
N_SAMPLES=""
MODEL="gamma_per_instruction"
INFERENCE="importance-sampling"
KEEP_INTERMEDIATES=0
TAG=""
TRAIN_DEFINES=""  # Space-separated list of compiler macros for training files
ESTIMATE_DEFINES=""  # Space-separated list of compiler macros for estimation file

# Required parameters (to be set via command line)
TRAIN_FILES=""  # Semicolon-separated list of training files
ESTIMATE_FILE=""
TRAINING_RAW_CSV=""  # Semicolon-separated list (optional, for resuming)
TRAINING_SEGMENTS_CSV=""  # Semicolon-separated list (optional, for resuming)
PARAMS_FILE=""
ESTIMATED_STATS_JSON=""
TEST_RAW_CSV=""
TEST_SEGMENTS_CSV=""

# Optional intermediate files
USE_TEMP_TRAINING_RAW=0
USE_TEMP_TRAINING_SEGMENTS=0
USE_TEMP_PARAMS=0
USE_TEMP_TEST_RAW=0
USE_TEMP_TEST_SEGMENTS=0

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Full pipeline: measure train → measure estimate → preprocess both → train → estimate → compare

Required arguments:
  --train-files PATTERN     C file(s) to train the model from (supports glob patterns and brace expansion)
  --estimate-file FILE      C file to estimate energy for

Optional arguments:
  --training-raw-csv PATTERN     Raw measurement CSV file(s) for training (glob pattern, semicolon-separated, or matched by basename)
  --test-raw-csv FILE            Raw measurement CSV file for estimation (default: temp file)
  --training-segments-csv PATTERN  Preprocessed segments CSV file(s) for training (glob pattern, semicolon-separated, or matched by basename)
  --test-segments-csv FILE       Preprocessed segments CSV file for estimation (default: temp file)
  --params FILE             Model parameters JSON file (default: temp file)
  --tag TAG                 Tag for naming output files (default: process ID)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --max-steps N             Maximum execution steps for train/estimate
  --n-samples N             Number of samples for inference (default: 100)
  --model MODEL             Energy model: gamma_per_instruction, gamma_per_addressing_mode, mean_per_instruction, mean_per_addressing_mode (default: gamma_per_instruction)
  --inference ALG           Inference algorithm: importance-sampling, or mcmc-blocked (default: importance-sampling)
  --train-defines "MACROS"  Space-separated compiler macros for training files (e.g., "FOO=1 BAR")
  --estimate-defines "MACROS"  Space-separated compiler macros for estimation file (e.g., "FOO=1 BAR")
  --report-dir DIR          Directory for comparison report (default: ./report)
  --skip-reset              Skip device reset during measurement
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
        --training-raw-csv)
            TRAINING_RAW_CSV="$2"
            shift 2
            ;;
        --test-raw-csv)
            TEST_RAW_CSV="$2"
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
        --report-dir)
            REPORT_DIR="$2"
            shift 2
            ;;
        --skip-reset)
            SKIP_RESET="--skip_reset"
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

# Setup training file arrays for raw and segment CSVs
TRAINING_RAW_CSV_ARRAY=()
TRAINING_SEGMENTS_CSV_ARRAY=()

# Match training files to CSVs by basename (supports glob patterns)
if [[ -n "$TRAINING_RAW_CSV" ]]; then
    log_info "Matching training raw CSVs by basename..."
    csv_matches=$(match_files_by_basename "TRAIN_FILE_ARRAY" "$TRAINING_RAW_CSV" "training raw CSV")
    match_exit_code=$?
    if [[ $match_exit_code -ne 0 ]]; then
        exit 1
    fi
    mapfile -t TRAINING_RAW_CSV_ARRAY <<< "$csv_matches"
fi

if [[ -n "$TRAINING_SEGMENTS_CSV" ]]; then
    log_info "Matching training segments CSVs by basename..."
    csv_matches=$(match_files_by_basename "TRAIN_FILE_ARRAY" "$TRAINING_SEGMENTS_CSV" "training segments CSV")
    match_exit_code=$?
    if [[ $match_exit_code -ne 0 ]]; then
        exit 1
    fi
    mapfile -t TRAINING_SEGMENTS_CSV_ARRAY <<< "$csv_matches"
fi

# Create temp file paths for training files without matched CSVs
for i in "${!TRAIN_FILE_ARRAY[@]}"; do
    train_file="${TRAIN_FILE_ARRAY[$i]}"
    basename=$(basename "$train_file" .c)

    # Raw CSV - use temp file if no match found
    if [[ -z "${TRAINING_RAW_CSV_ARRAY[$i]:-}" ]]; then
        TRAINING_RAW_CSV_ARRAY[$i]="$TEMP_DIR/${basename}_${TIMESTAMP}.csv"
        USE_TEMP_TRAINING_RAW=1
    else
        log_info "  Matched raw CSV for $basename: ${TRAINING_RAW_CSV_ARRAY[$i]}"
    fi

    # Segments CSV - use temp file if no match found
    if [[ -z "${TRAINING_SEGMENTS_CSV_ARRAY[$i]:-}" ]]; then
        TRAINING_SEGMENTS_CSV_ARRAY[$i]="$TEMP_DIR/${basename}_segments_${TIMESTAMP}.csv"
        USE_TEMP_TRAINING_SEGMENTS=1
    else
        log_info "  Matched segments CSV for $basename: ${TRAINING_SEGMENTS_CSV_ARRAY[$i]}"
    fi
done

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

# Setup temporary file for test raw CSV if not provided
if [[ -z "$TEST_RAW_CSV" ]]; then
    TEST_RAW_CSV="$TEMP_DIR/measured_${FILE_SUFFIX}.csv"
    USE_TEMP_TEST_RAW=1
    log_info "Using temporary test raw CSV: $TEST_RAW_CSV"
fi

# Setup temporary file for test segments if not provided
if [[ -z "$TEST_SEGMENTS_CSV" ]]; then
    TEST_SEGMENTS_CSV="$TEMP_DIR/measured_segments_${FILE_SUFFIX}.csv"
    USE_TEMP_TEST_SEGMENTS=1
    log_info "Using temporary test segments CSV: $TEST_SEGMENTS_CSV"
fi

# Expand patterns for test CSV files (if provided as patterns)
if [[ -n "$TEST_RAW_CSV" ]] && [[ $USE_TEMP_TEST_RAW -eq 0 ]]; then
    # Check if pattern contains wildcards
    if [[ "$TEST_RAW_CSV" == *"*"* ]] || [[ "$TEST_RAW_CSV" == *"?"* ]] || [[ "$TEST_RAW_CSV" == *"{"* ]]; then
        log_info "Expanding test raw CSV pattern: $TEST_RAW_CSV"
        TEST_RAW_CSV=$(match_single_file "$TEST_RAW_CSV" "test raw CSV")
        log_info "Matched test raw CSV: $TEST_RAW_CSV"
    fi
    # Verify file exists after expansion
    if [[ -f "$TEST_RAW_CSV" ]]; then
        log_info "✓ Test raw CSV exists: $TEST_RAW_CSV"
    else
        log_info "✗ Test raw CSV does not exist: $TEST_RAW_CSV"
        log_info "Will proceed with measurement instead of skipping"
    fi
fi

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

# Extract basenames
ESTIMATE_BASENAME="$(basename "$ESTIMATE_FILE" .c)"

# ============================================================
# EXTRACT EVENT LABELS
# ============================================================

# Extract event labels for all training files
TRAINING_EVENT_LABELS_ARRAY=()
for i in "${!TRAIN_FILE_ARRAY[@]}"; do
    train_file="${TRAIN_FILE_ARRAY[$i]}"
    basename=$(basename "$train_file" .c)
    event_labels_json="$TEMP_DIR/labels_${basename}_${TIMESTAMP}.json"

    log_info "Extracting event labels from $train_file..."
    python3 "$EXTRACT_BENCH_LABELS_PY" \
        --input "$train_file" \
        --output "$event_labels_json" \
        --format json

    TRAINING_EVENT_LABELS_ARRAY+=("$event_labels_json")
done

# Extract event labels for estimation file
ESTIMATE_EVENT_LABELS_JSON="$TEMP_DIR/labels_${ESTIMATE_BASENAME}_${TIMESTAMP}.json"
log_info "Extracting event labels from $ESTIMATE_FILE..."
python3 "$EXTRACT_BENCH_LABELS_PY" \
    --input "$ESTIMATE_FILE" \
    --output "$ESTIMATE_EVENT_LABELS_JSON" \
    --format json

# Build MAX_STEPS_FLAG
MAX_STEPS_FLAG=""
if [[ -n "$MAX_STEPS" ]]; then
    MAX_STEPS_FLAG="--max-steps $MAX_STEPS"
fi

# Build N_SAMPLES_FLAG
N_SAMPLES_FLAG=""
if [[ -n "$N_SAMPLES" ]]; then
    N_SAMPLES_FLAG="--n-samples $N_SAMPLES"
fi

# Build MODEL_FLAG
MODEL_FLAG="--model $MODEL"

# Build INFERENCE_FLAG
INFERENCE_FLAG="--inference $INFERENCE"

# Process TRAIN_DEFINES and ESTIMATE_DEFINES separately
TRAIN_DEFINE_FLAGS=$(process_defines "$TRAIN_DEFINES")
if [[ -n "$TRAIN_DEFINES" ]]; then
    log_info "Using training compiler defines: $TRAIN_DEFINES"
fi

ESTIMATE_DEFINE_FLAGS=$(process_defines "$ESTIMATE_DEFINES")
if [[ -n "$ESTIMATE_DEFINES" ]]; then
    log_info "Using estimation compiler defines: $ESTIMATE_DEFINES"
fi

# Determine which steps to skip based on provided intermediate files
SKIP_MEASUREMENT=0
SKIP_ESTIMATION_MEASUREMENT=0
SKIP_PREPROCESSING=0
SKIP_MEASURED_PREPROCESSING=0
SKIP_TRAINING=0

# Check if all training segment CSVs exist
ALL_TRAINING_SEGMENTS_EXIST=1
if [[ -n "$TRAINING_SEGMENTS_CSV" ]] && [[ $USE_TEMP_TRAINING_SEGMENTS -eq 0 ]]; then
    for csv in "${TRAINING_SEGMENTS_CSV_ARRAY[@]}"; do
        if [[ ! -f "$csv" ]]; then
            ALL_TRAINING_SEGMENTS_EXIST=0
            break
        fi
    done
else
    ALL_TRAINING_SEGMENTS_EXIST=0
fi

# Check if all training raw CSVs exist
ALL_TRAINING_RAW_EXIST=1
if [[ -n "$TRAINING_RAW_CSV" ]] && [[ $USE_TEMP_TRAINING_RAW -eq 0 ]]; then
    for csv in "${TRAINING_RAW_CSV_ARRAY[@]}"; do
        if [[ ! -f "$csv" ]]; then
            ALL_TRAINING_RAW_EXIST=0
            break
        fi
    done
else
    ALL_TRAINING_RAW_EXIST=0
fi

# If PARAMS provided and exists, skip training-related steps only
if [[ -n "$PARAMS_FILE" ]] && [[ -f "$PARAMS_FILE" ]] && [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    SKIP_MEASUREMENT=1
    SKIP_PREPROCESSING=1
    SKIP_TRAINING=1
    log_info "Resuming from existing params: $PARAMS_FILE (skipping training steps only)"
fi

# Check training segments - if provided, skip training measurement and preprocessing
if [[ $ALL_TRAINING_SEGMENTS_EXIST -eq 1 ]]; then
    SKIP_MEASUREMENT=1
    SKIP_PREPROCESSING=1
    log_info "Using existing training segments (${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files) - skipping training measurement and preprocessing"
# Else if all TRAINING_RAW_CSV provided and exist, skip training measurement only
elif [[ $ALL_TRAINING_RAW_EXIST -eq 1 ]]; then
    SKIP_MEASUREMENT=1
    log_info "Using existing training raw CSVs (${#TRAINING_RAW_CSV_ARRAY[@]} files) - skipping training measurement"
fi

# Check test segments - if provided, skip test measurement and preprocessing
if [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]] && [[ $USE_TEMP_TEST_SEGMENTS -eq 0 ]]; then
    SKIP_ESTIMATION_MEASUREMENT=1
    SKIP_MEASURED_PREPROCESSING=1
    log_info "Using existing test segments CSV: $TEST_SEGMENTS_CSV - skipping test measurement and preprocessing"
# Else if TEST_RAW_CSV is provided, skip test measurement only
elif [[ -n "$TEST_RAW_CSV" ]] && [[ -f "$TEST_RAW_CSV" ]] && [[ $USE_TEMP_TEST_RAW -eq 0 ]]; then
    SKIP_ESTIMATION_MEASUREMENT=1
    log_info "Using existing test raw CSV: $TEST_RAW_CSV - skipping test measurement"
fi

# Cleanup function
cleanup() {
    if [[ $KEEP_INTERMEDIATES -eq 1 ]]; then
        return
    fi

    if [[ $USE_TEMP_TRAINING_RAW -eq 1 ]]; then
        for csv in "${TRAINING_RAW_CSV_ARRAY[@]}"; do
            if [[ -f "$csv" ]]; then
                log_info "Cleaning up temporary training raw CSV: $csv"
                rm -f "$csv"
            fi
        done
    fi

    if [[ $USE_TEMP_TRAINING_SEGMENTS -eq 1 ]]; then
        for csv in "${TRAINING_SEGMENTS_CSV_ARRAY[@]}"; do
            if [[ -f "$csv" ]]; then
                log_info "Cleaning up temporary training segments CSV: $csv"
                rm -f "$csv"
            fi
        done
    fi

    if [[ $USE_TEMP_PARAMS -eq 1 ]] && [[ -f "$PARAMS_FILE" ]]; then
        log_info "Cleaning up temporary params file: $PARAMS_FILE"
        rm -f "$PARAMS_FILE"
    fi
    if [[ $USE_TEMP_TEST_RAW -eq 1 ]] && [[ -f "$TEST_RAW_CSV" ]]; then
        log_info "Cleaning up temporary test raw CSV: $TEST_RAW_CSV"
        rm -f "$TEST_RAW_CSV"
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
if [[ $SKIP_TRAINING -eq 0 ]] || [[ $SKIP_MEASUREMENT -eq 0 ]] || [[ $SKIP_PREPROCESSING -eq 0 ]]; then
    log_step "Training pipeline (via train.sh)"

    # Build arguments for train.sh
    TRAIN_ARGS=("--train-files" "$TRAIN_FILES")
    [[ -n "$TRAINING_RAW_CSV" ]] && TRAIN_ARGS+=("--training-raw-csv" "$TRAINING_RAW_CSV")
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
    [[ -n "$SKIP_RESET" ]] && TRAIN_ARGS+=("--skip-reset")
    [[ $KEEP_INTERMEDIATES -eq 1 ]] && TRAIN_ARGS+=("--keep-intermediates")

    # Call train.sh
    "$SCRIPT_DIR/train.sh" "${TRAIN_ARGS[@]}"
    log_success "Training pipeline completed"
else
    log_step "Training pipeline SKIPPED (using existing params: $PARAMS_FILE)"
fi

# Estimation measurement (compile estimation file, flash, measure)
if [[ $SKIP_ESTIMATION_MEASUREMENT -eq 0 ]]; then
    # Compile estimation file for measurement
    log_step "Compiling estimation file for measurement"
    log_info "Compiling for measurement"
    $CC $CFLAGS $ESTIMATE_DEFINE_FLAGS $INCLUDES $LDFLAGS -o "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" "$ESTIMATE_FILE"
    log_success "Compiled: $BUILD_DIR/${ESTIMATE_BASENAME}.elf"

    # Flash estimation file to device
    log_step "Flashing estimation file to device"
    log_info "Flashing $BUILD_DIR/${ESTIMATE_BASENAME}.elf..."
    mspdebug tilib "prog $BUILD_DIR/${ESTIMATE_BASENAME}.elf" "exit"
    log_success "Flashed to device"

    # Measure estimation file energy
    log_step "Measuring estimation file energy consumption"
    log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
    python3 "$MEASURE_PY" \
        --voltage "$VOLTAGE" \
        --max_current "$MAX_CURRENT" \
        --outfile "$TEST_RAW_CSV" \
        $SKIP_RESET
    log_success "Estimation raw measurement saved: $TEST_RAW_CSV"
else
    log_step "Estimation measurement SKIPPED (using existing estimation raw CSV: $TEST_RAW_CSV)"
fi

echo ""
log_info "==> Hardware no longer required - remaining steps can run offline"
echo ""

# Preprocess measured estimation data
if [[ $SKIP_MEASURED_PREPROCESSING -eq 0 ]]; then
    log_step "Preprocessing measured estimation data"
    python3 "$PREPROCESS_PY" \
        --input "$TEST_RAW_CSV" \
        --output "$TEST_SEGMENTS_CSV" \
        --event-labels "$ESTIMATE_EVENT_LABELS_JSON"
    log_success "Measured estimation segments saved: $TEST_SEGMENTS_CSV"
else
    log_step "Preprocessing SKIPPED (using existing test segments CSV: $TEST_SEGMENTS_CSV)"
fi

# Compile estimation file for estimation
log_step "Compiling estimation file for estimation"
log_info "Compiling for estimation (with NUM_REPEAT=1)"

# Override NUM_REPEAT to 1 for estimation compilation
ESTIMATE_DEFINES_FOR_ESTIMATION=$(override_define "$ESTIMATE_DEFINES" "NUM_REPEAT" "1")
ESTIMATE_DEFINE_FLAGS_FOR_ESTIMATION=$(process_defines "$ESTIMATE_DEFINES_FOR_ESTIMATION")

$CC $CFLAGS $ESTIMATE_DEFINE_FLAGS_FOR_ESTIMATION $INCLUDES $LDFLAGS -o "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" "$ESTIMATE_FILE"
log_success "Compiled: $BUILD_DIR/${ESTIMATE_BASENAME}.elf"
$OBJDUMP -d "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" > "$ASM_DIR/${ESTIMATE_BASENAME}.asm"
log_success "Disassembled: $ASM_DIR/${ESTIMATE_BASENAME}.asm"

# Estimate energy consumption
log_step "Estimating energy consumption"
julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" estimate \
    --asm "$ASM_DIR/${ESTIMATE_BASENAME}.asm" \
    --params "$PARAMS_FILE" \
    --output "$ESTIMATED_STATS_JSON" \
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

python3 "$PROJECT_ROOT/scripts/generate_comparison_report.py" \
    --estimated-stats "$ESTIMATED_STATS_JSON" \
    --measured-data "$TEST_SEGMENTS_CSV" \
    --report-dir "$REPORT_DIR_FULL" \
    --num-repeat "$NUM_REPEAT"
log_success "Comparison report generated: $REPORT_DIR_FULL"

# Cleanup estimated stats temp file
rm -f "$ESTIMATED_STATS_JSON"

# Cleanup event label files
for label_file in "${TRAINING_EVENT_LABELS_ARRAY[@]}"; do
    rm -f "$label_file"
done
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
if [[ $USE_TEMP_TRAINING_RAW -eq 0 ]]; then
    echo "  - Training Raw CSVs (${#TRAINING_RAW_CSV_ARRAY[@]} files):"
    for csv in "${TRAINING_RAW_CSV_ARRAY[@]}"; do
        echo "      $csv"
    done
fi
if [[ $USE_TEMP_TEST_RAW -eq 0 ]]; then
    echo "  - Test Raw CSV: $TEST_RAW_CSV"
fi
if [[ $USE_TEMP_TRAINING_SEGMENTS -eq 0 ]]; then
    echo "  - Training Segments CSVs (${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files):"
    for csv in "${TRAINING_SEGMENTS_CSV_ARRAY[@]}"; do
        echo "      $csv"
    done
fi
if [[ $USE_TEMP_TEST_SEGMENTS -eq 0 ]]; then
    echo "  - Test Segments CSV: $TEST_SEGMENTS_CSV"
fi
if [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    echo "  - Parameters: $PARAMS_FILE"
fi

