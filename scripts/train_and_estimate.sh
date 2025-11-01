#!/bin/bash
# Full pipeline: measure train → measure estimate → preprocess both → train → estimate → compare
# Usage: ./scripts/train_and_estimate.sh [options]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
VOLTAGE=3.3
MAX_CURRENT=0.01
SKIP_RESET=""
MAX_STEPS=""
N_SAMPLES=""
NUM_REPEAT=10
GRANULARITY="opcode"
INFERENCE="importance-sampling"
REPORT_DIR="./report"
TEMP_DIR="./tmp"
KEEP_INTERMEDIATES=0
TAG=""

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

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MEASURE_PY="$SCRIPT_DIR/measure.py"
PREPROCESS_PY="$SCRIPT_DIR/preprocess.py"

# Check required environment variables
if [[ -z "${MSP430GCC_TOOLCHAIN_PATH}" ]]; then
    log_error "MSP430GCC_TOOLCHAIN_PATH is not set. Please set it in your environment or .env file"
    exit 1
fi
if [[ -z "${MSP430GCC_SUPPORT_PATH}" ]]; then
    log_error "MSP430GCC_SUPPORT_PATH is not set. Please set it in your environment or .env file"
    exit 1
fi

# Load Makefile variables
CC="$MSP430GCC_TOOLCHAIN_PATH/bin/msp430-elf-gcc"
OBJDUMP="$MSP430GCC_TOOLCHAIN_PATH/bin/msp430-elf-objdump"
DEVICE="MSP430FR5994"
CFLAGS="-mmcu=$DEVICE -O0 -g -Wall"
INCLUDES="-I$MSP430GCC_SUPPORT_PATH/include -I$PROJECT_ROOT/include"
LDFLAGS="-L$MSP430GCC_SUPPORT_PATH/include"
BUILD_DIR="$PROJECT_ROOT/build"
ASM_DIR="$BUILD_DIR/asm"

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_step() {
    echo ""
    echo -e "${YELLOW}======================================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${YELLOW}======================================${NC}"
}

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Full pipeline: measure train → measure estimate → preprocess both → train → estimate → compare

Required arguments:
  --train-files FILES       C file(s) to train the model from (semicolon-separated for multiple)
  --estimate-file FILE      C file to estimate energy for

Optional arguments:
  --training-raw-csv FILES  Raw measurement CSV file(s) for training (semicolon-separated, default: temp files)
  --test-raw-csv FILE       Raw measurement CSV file for estimation (default: temp file)
  --training-segments-csv FILES  Preprocessed segments CSV file(s) for training (semicolon-separated, default: temp files)
  --test-segments-csv FILE  Preprocessed segments CSV file for estimation (default: temp file)
  --params FILE             Model parameters JSON file (default: temp file)
  --tag TAG                 Tag for naming output files (default: process ID)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --max-steps N             Maximum execution steps for train/estimate
  --n-samples N             Number of samples for inference (default: 100)
  --num-repeat N            NUM_REPEAT value for training compilation (default: 10)
  --granularity MODE        Model granularity: opcode or addressing_mode (default: opcode)
  --inference ALG           Inference algorithm: importance-sampling, mcmc-hmc, or mcmc-blocked (default: importance-sampling)
  --report-dir DIR          Directory for comparison report (default: ./report)
  --skip-reset              Skip device reset during measurement
  --keep-intermediates      Keep intermediate files and suggest resume commands
  --help                    Show this help message

Examples:
  # Single training file (backward compatible)
  $0 --train-files examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c

  # Multiple training files
  $0 --train-files "file1.c;file2.c;file3.c" \\
     --estimate-file examples/c_programs/test.c \\
     --tag multi_train

  # Resume with existing segment CSVs
  $0 --train-files "file1.c;file2.c" \\
     --estimate-file test.c \\
     --training-segments-csv "file1_segments.csv;file2_segments.csv"
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
        --num-repeat)
            NUM_REPEAT="$2"
            shift 2
            ;;
        --granularity)
            GRANULARITY="$2"
            shift 2
            ;;
        --inference)
            INFERENCE="$2"
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

# Parse training files into array
IFS=';' read -ra TRAIN_FILE_ARRAY <<< "$TRAIN_FILES"

# Check if training files exist
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
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

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

# If user provided training CSVs, parse them
if [[ -n "$TRAINING_RAW_CSV" ]]; then
    IFS=';' read -ra TRAINING_RAW_CSV_ARRAY <<< "$TRAINING_RAW_CSV"
fi

if [[ -n "$TRAINING_SEGMENTS_CSV" ]]; then
    IFS=';' read -ra TRAINING_SEGMENTS_CSV_ARRAY <<< "$TRAINING_SEGMENTS_CSV"
fi

# Create temp file paths for each training file if not provided
for i in "${!TRAIN_FILE_ARRAY[@]}"; do
    train_file="${TRAIN_FILE_ARRAY[$i]}"
    basename=$(basename "$train_file" .c)

    # Raw CSV
    if [[ -z "${TRAINING_RAW_CSV_ARRAY[$i]}" ]]; then
        TRAINING_RAW_CSV_ARRAY[$i]="$TEMP_DIR/${basename}_${TIMESTAMP}.csv"
        USE_TEMP_TRAINING_RAW=1
    fi

    # Segments CSV
    if [[ -z "${TRAINING_SEGMENTS_CSV_ARRAY[$i]}" ]]; then
        TRAINING_SEGMENTS_CSV_ARRAY[$i]="$TEMP_DIR/${basename}_${TIMESTAMP}_segments.csv"
        USE_TEMP_TRAINING_SEGMENTS=1
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

log_info "Report will be saved to: $REPORT_DIR_FULL"

# Extract basenames
ESTIMATE_BASENAME="$(basename "$ESTIMATE_FILE" .c)"

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

# Build GRANULARITY_FLAG
GRANULARITY_FLAG="--granularity $GRANULARITY"

# Build INFERENCE_FLAG
INFERENCE_FLAG="--inference $INFERENCE"

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

# If PARAMS provided and exists, skip everything up to training
if [[ -n "$PARAMS_FILE" ]] && [[ -f "$PARAMS_FILE" ]] && [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    SKIP_MEASUREMENT=1
    SKIP_ESTIMATION_MEASUREMENT=1
    SKIP_PREPROCESSING=1
    SKIP_MEASURED_PREPROCESSING=1
    SKIP_TRAINING=1
    log_info "Resuming from existing params: $PARAMS_FILE"
# Else if all TRAINING_SEGMENTS_CSV provided and exist, skip measurement and preprocessing
elif [[ $ALL_TRAINING_SEGMENTS_EXIST -eq 1 ]]; then
    SKIP_MEASUREMENT=1
    SKIP_ESTIMATION_MEASUREMENT=1
    SKIP_PREPROCESSING=1
    log_info "Resuming from existing training segments (${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files)"
# Else if all TRAINING_RAW_CSV and TEST_RAW_CSV provided and exist, skip both measurements
elif [[ $ALL_TRAINING_RAW_EXIST -eq 1 ]] && \
     [[ -n "$TEST_RAW_CSV" ]] && [[ -f "$TEST_RAW_CSV" ]] && [[ $USE_TEMP_TEST_RAW -eq 0 ]]; then
    SKIP_MEASUREMENT=1
    SKIP_ESTIMATION_MEASUREMENT=1
    log_info "Resuming from existing raw CSVs (training: ${#TRAINING_RAW_CSV_ARRAY[@]} files, test: 1 file)"
# Else if only all TRAINING_RAW_CSV provided and exist, skip training measurement only
elif [[ $ALL_TRAINING_RAW_EXIST -eq 1 ]]; then
    SKIP_MEASUREMENT=1
    log_info "Resuming from existing training raw CSVs (${#TRAINING_RAW_CSV_ARRAY[@]} files)"
fi

# Check if TEST_RAW_CSV is provided separately
if [[ -n "$TEST_RAW_CSV" ]] && [[ -f "$TEST_RAW_CSV" ]] && [[ $USE_TEMP_TEST_RAW -eq 0 ]]; then
    SKIP_ESTIMATION_MEASUREMENT=1
    log_info "Using existing test raw CSV: $TEST_RAW_CSV"
fi

# Check if TEST_SEGMENTS_CSV is provided separately
if [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]] && [[ $USE_TEMP_TEST_SEGMENTS -eq 0 ]]; then
    SKIP_MEASURED_PREPROCESSING=1
    log_info "Using existing test segments CSV: $TEST_SEGMENTS_CSV"
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

# Steps 1-3: Training measurement (compile, flash, measure each training file)
if [[ $SKIP_MEASUREMENT -eq 0 ]]; then
    for i in "${!TRAIN_FILE_ARRAY[@]}"; do
        train_file="${TRAIN_FILE_ARRAY[$i]}"
        train_basename=$(basename "$train_file" .c)
        training_raw_csv="${TRAINING_RAW_CSV_ARRAY[$i]}"

        log_info ""
        log_info "Training file $((i+1))/${#TRAIN_FILE_ARRAY[@]}: $train_file"

        # Step 1: Compile training file
        log_step "Step 1.$((i+1))/12: Compiling training file ($train_basename)"
        log_info "Compiling with NUM_REPEAT=$NUM_REPEAT"
        $CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${train_basename}.elf" "$train_file"
        log_success "Compiled: $BUILD_DIR/${train_basename}.elf"

        # Step 2: Flash training file to device
        log_step "Step 2.$((i+1))/12: Flashing training file to device ($train_basename)"
        log_info "Flashing $BUILD_DIR/${train_basename}.elf..."
        mspdebug tilib "prog $BUILD_DIR/${train_basename}.elf" "exit"
        log_success "Flashed to device"

        # Step 3: Measure training file energy
        log_step "Step 3.$((i+1))/12: Measuring training file energy consumption ($train_basename)"
        log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
        python3 "$MEASURE_PY" \
            --voltage "$VOLTAGE" \
            --max_current "$MAX_CURRENT" \
            --outfile "$training_raw_csv" \
            $SKIP_RESET
        log_success "Training raw measurement saved: $training_raw_csv"
    done
else
    log_step "Steps 1-3: SKIPPED (using existing training raw CSVs: ${#TRAINING_RAW_CSV_ARRAY[@]} files)"
fi

# Steps 4-6: Estimation measurement (compile estimation file, flash, measure)
if [[ $SKIP_ESTIMATION_MEASUREMENT -eq 0 ]]; then
    # Step 4: Compile estimation file for measurement
    log_step "Step 4/12: Compiling estimation file for measurement"
    log_info "Compiling with NUM_REPEAT=$NUM_REPEAT (for measurement)"
    $CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" "$ESTIMATE_FILE"
    log_success "Compiled: $BUILD_DIR/${ESTIMATE_BASENAME}.elf"

    # Step 5: Flash estimation file to device
    log_step "Step 5/12: Flashing estimation file to device"
    log_info "Flashing $BUILD_DIR/${ESTIMATE_BASENAME}.elf..."
    mspdebug tilib "prog $BUILD_DIR/${ESTIMATE_BASENAME}.elf" "exit"
    log_success "Flashed to device"

    # Step 6: Measure estimation file energy
    log_step "Step 6/12: Measuring estimation file energy consumption"
    log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
    python3 "$MEASURE_PY" \
        --voltage "$VOLTAGE" \
        --max_current "$MAX_CURRENT" \
        --outfile "$TEST_RAW_CSV" \
        $SKIP_RESET
    log_success "Estimation raw measurement saved: $TEST_RAW_CSV"
else
    log_step "Steps 4-6: SKIPPED (using existing estimation raw CSV: $TEST_RAW_CSV)"
fi

echo ""
log_info "==> Hardware no longer required - remaining steps can run offline"
echo ""

# Step 7: Preprocess training measurements
if [[ $SKIP_PREPROCESSING -eq 0 ]]; then
    for i in "${!TRAINING_RAW_CSV_ARRAY[@]}"; do
        training_raw_csv="${TRAINING_RAW_CSV_ARRAY[$i]}"
        training_segments_csv="${TRAINING_SEGMENTS_CSV_ARRAY[$i]}"
        train_file="${TRAIN_FILE_ARRAY[$i]}"
        train_basename=$(basename "$train_file" .c)

        log_step "Step 7.$((i+1))/12: Preprocessing training measurements ($train_basename)"
        python3 "$PREPROCESS_PY" \
            --input "$training_raw_csv" \
            --output "$training_segments_csv"
        log_success "Training segments saved: $training_segments_csv"
    done
else
    log_step "Step 7: SKIPPED (using existing training segments CSVs: ${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files)"
fi

# Step 8: Preprocess measured estimation data
if [[ $SKIP_MEASURED_PREPROCESSING -eq 0 ]]; then
    log_step "Step 8/12: Preprocessing measured estimation data"
    python3 "$PREPROCESS_PY" \
        --input "$TEST_RAW_CSV" \
        --output "$TEST_SEGMENTS_CSV"
    log_success "Measured estimation segments saved: $TEST_SEGMENTS_CSV"
else
    log_step "Step 8: SKIPPED (using existing test segments CSV: $TEST_SEGMENTS_CSV)"
fi

# Step 9: Train energy model
if [[ $SKIP_TRAINING -eq 0 ]]; then
    log_step "Step 9/12: Training energy model from ${#TRAIN_FILE_ARRAY[@]} file(s)"

    # Compile and disassemble all training files
    ASM_FILES=()
    for i in "${!TRAIN_FILE_ARRAY[@]}"; do
        train_file="${TRAIN_FILE_ARRAY[$i]}"
        train_basename=$(basename "$train_file" .c)

        # Need to compile if we skipped measurement
        if [[ $SKIP_MEASUREMENT -eq 1 ]]; then
            log_info "Compiling $train_basename with NUM_REPEAT=$NUM_REPEAT"
            $CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${train_basename}.elf" "$train_file"
        fi

        $OBJDUMP -d "$BUILD_DIR/${train_basename}.elf" > "$ASM_DIR/${train_basename}.asm"
        log_info "Disassembled: $ASM_DIR/${train_basename}.asm"
        ASM_FILES+=("$ASM_DIR/${train_basename}.asm")
    done

    # Train with all ASM files and segment CSVs
    julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" train \
        --asm "${ASM_FILES[@]}" \
        --data "${TRAINING_SEGMENTS_CSV_ARRAY[@]}" \
        --output "$PARAMS_FILE" \
        $MAX_STEPS_FLAG \
        $N_SAMPLES_FLAG \
        $GRANULARITY_FLAG \
        $INFERENCE_FLAG
    log_success "Model trained: $PARAMS_FILE"
else
    log_step "Step 9: SKIPPED (using existing params: $PARAMS_FILE)"
fi

# Step 10: Compile estimation file for estimation (NUM_REPEAT=1)
log_step "Step 10/12: Compiling estimation file for estimation"
log_info "Compiling with NUM_REPEAT=1 (estimation mode)"
$CC $CFLAGS -DNUM_REPEAT=1 $INCLUDES $LDFLAGS -o "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" "$ESTIMATE_FILE"
log_success "Compiled: $BUILD_DIR/${ESTIMATE_BASENAME}.elf"
$OBJDUMP -d "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" > "$ASM_DIR/${ESTIMATE_BASENAME}.asm"
log_success "Disassembled: $ASM_DIR/${ESTIMATE_BASENAME}.asm"

# Step 11: Estimate energy consumption
log_step "Step 11/12: Estimating energy consumption"
julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" estimate \
    --asm "$ASM_DIR/${ESTIMATE_BASENAME}.asm" \
    --params "$PARAMS_FILE" \
    --output "$ESTIMATED_STATS_JSON" \
    $MAX_STEPS_FLAG
log_success "Estimation complete: $ESTIMATED_STATS_JSON"

# Step 12: Generate comparison report
log_step "Step 12/12: Generating comparison report"
python3 "$PROJECT_ROOT/scripts/generate_comparison_report.py" \
    --estimated-stats "$ESTIMATED_STATS_JSON" \
    --measured-data "$TEST_SEGMENTS_CSV" \
    --report-dir "$REPORT_DIR_FULL" \
    --num-repeat "$NUM_REPEAT"
log_success "Comparison report generated: $REPORT_DIR_FULL"

# Cleanup estimated stats temp file
rm -f "$ESTIMATED_STATS_JSON"

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

# Suggest resume commands if keeping intermediates
if [[ $KEEP_INTERMEDIATES -eq 1 ]]; then
    echo ""
    log_step "RESUME COMMANDS"
    log_info "You can resume the pipeline from intermediate files using these commands:"
    echo ""

    # Construct semicolon-separated training CSV lists for resume commands
    TRAINING_RAW_CSV_STR=$(IFS=';'; echo "${TRAINING_RAW_CSV_ARRAY[*]}")
    TRAINING_SEGMENTS_CSV_STR=$(IFS=';'; echo "${TRAINING_SEGMENTS_CSV_ARRAY[*]}")

    # Option 1: Have PARAMS and TEST_SEGMENTS - skip to estimation compilation (steps 1-9)
    if [[ -n "$PARAMS_FILE" ]] && [[ -f "$PARAMS_FILE" ]] && \
       [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]]; then
        echo "Resume from estimation compilation (skip all preprocessing and training - steps 1-9):"
        echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --params $PARAMS_FILE --test-segments-csv $TEST_SEGMENTS_CSV"
        echo ""
    fi

    # Option 2: Have PARAMS but not TEST_SEGMENTS - skip to test data preprocessing (steps 1-7, still need step 8)
    if [[ -n "$PARAMS_FILE" ]] && [[ -f "$PARAMS_FILE" ]]; then
        echo "Resume from test data preprocessing (skip measurements and training - steps 1-7):"
        if [[ -n "$TEST_RAW_CSV" ]] && [[ -f "$TEST_RAW_CSV" ]]; then
            echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --params $PARAMS_FILE --test-raw-csv $TEST_RAW_CSV"
        else
            echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --params $PARAMS_FILE"
        fi
        echo ""
    fi

    # Option 3: Have TRAINING_SEGMENTS and TEST_SEGMENTS - skip all preprocessing (steps 1-8)
    if [[ $ALL_TRAINING_SEGMENTS_EXIST -eq 1 ]] && \
       [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]]; then
        echo "Retrain model (skip all measurements and preprocessing - steps 1-8):"
        echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --training-segments-csv \"$TRAINING_SEGMENTS_CSV_STR\" --test-segments-csv $TEST_SEGMENTS_CSV"
        echo ""
    fi

    # Option 4: Have TRAINING_SEGMENTS but not TEST_SEGMENTS - skip to test preprocessing (steps 1-7)
    if [[ $ALL_TRAINING_SEGMENTS_EXIST -eq 1 ]]; then
        echo "Retrain model from training segments (skip measurements and training preprocessing - steps 1-7):"
        if [[ -n "$TEST_RAW_CSV" ]] && [[ -f "$TEST_RAW_CSV" ]]; then
            echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --training-segments-csv \"$TRAINING_SEGMENTS_CSV_STR\" --test-raw-csv $TEST_RAW_CSV"
        else
            echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --training-segments-csv \"$TRAINING_SEGMENTS_CSV_STR\""
        fi
        echo ""
    fi

    # Option 5: Have both raw CSVs - skip all measurements (steps 1-6)
    if [[ $ALL_TRAINING_RAW_EXIST -eq 1 ]] && \
       [[ -n "$TEST_RAW_CSV" ]] && [[ -f "$TEST_RAW_CSV" ]]; then
        echo "Reprocess and retrain (skip all measurements - steps 1-6):"
        CMD="  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --training-raw-csv \"$TRAINING_RAW_CSV_STR\" --test-raw-csv $TEST_RAW_CSV"
        if [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]]; then
            CMD="$CMD --test-segments-csv $TEST_SEGMENTS_CSV"
        fi
        echo "$CMD"
        echo ""
    fi

    # Option 6: Have only training raw CSV - skip training measurement (steps 1-3)
    if [[ $ALL_TRAINING_RAW_EXIST -eq 1 ]]; then
        echo "Remeasure estimation only (skip training measurement - steps 1-3):"
        echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --training-raw-csv \"$TRAINING_RAW_CSV_STR\""
        echo ""
    fi

    # Option 7: Have only test raw CSV - skip test measurement (steps 4-6)
    if [[ -n "$TEST_RAW_CSV" ]] && [[ -f "$TEST_RAW_CSV" ]]; then
        echo "Remeasure training and retrain (skip test measurement - steps 4-6):"
        CMD="  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --test-raw-csv $TEST_RAW_CSV"
        if [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]]; then
            CMD="$CMD --test-segments-csv $TEST_SEGMENTS_CSV"
        fi
        echo "$CMD"
        echo ""
    fi

    # Option 8: Have TEST_SEGMENTS only - skip test measurement and preprocessing (steps 4-8)
    if [[ -n "$TEST_SEGMENTS_CSV" ]] && [[ -f "$TEST_SEGMENTS_CSV" ]]; then
        echo "Remeasure and retrain (skip test preprocessing - step 8):"
        echo "  ./scripts/train_and_estimate.sh --train-files \"$TRAIN_FILES\" --estimate-file $ESTIMATE_FILE --test-segments-csv $TEST_SEGMENTS_CSV"
        echo ""
    fi

    log_info "Intermediate files kept:"
    if [[ $USE_TEMP_TRAINING_RAW -eq 1 ]]; then
        for csv in "${TRAINING_RAW_CSV_ARRAY[@]}"; do
            if [[ -f "$csv" ]]; then
                echo "  - Training Raw CSV: $csv"
            fi
        done
    fi
    if [[ $USE_TEMP_TEST_RAW -eq 1 ]] && [[ -f "$TEST_RAW_CSV" ]]; then
        echo "  - Test Raw CSV: $TEST_RAW_CSV"
    fi
    if [[ $USE_TEMP_TRAINING_SEGMENTS -eq 1 ]]; then
        for csv in "${TRAINING_SEGMENTS_CSV_ARRAY[@]}"; do
            if [[ -f "$csv" ]]; then
                echo "  - Training Segments CSV: $csv"
            fi
        done
    fi
    if [[ $USE_TEMP_PARAMS -eq 1 ]] && [[ -f "$PARAMS_FILE" ]]; then
        echo "  - Parameters: $PARAMS_FILE"
    fi
    if [[ $USE_TEMP_TEST_SEGMENTS -eq 1 ]] && [[ -f "$TEST_SEGMENTS_CSV" ]]; then
        echo "  - Test Segments CSV: $TEST_SEGMENTS_CSV"
    fi
fi
