#!/usr/bin/env bash
# Training pipeline: measure → preprocess → train
# Usage: ./scripts/train.sh [options]
# Requires: bash 4.0+ (for mapfile)

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
MODEL="gamma_per_instruction"
INFERENCE="importance-sampling"
TEMP_DIR="./tmp"
KEEP_INTERMEDIATES=0
TAG=""

# Required parameters (to be set via command line)
TRAIN_FILES=""  # Semicolon-separated list of training files
TRAINING_RAW_CSV=""  # Semicolon-separated list (optional, for resuming)
TRAINING_SEGMENTS_CSV=""  # Semicolon-separated list (optional, for resuming)
PARAMS_FILE=""

# Optional intermediate files
USE_TEMP_TRAINING_RAW=0
USE_TEMP_TRAINING_SEGMENTS=0
USE_TEMP_PARAMS=0

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MEASURE_PY="$SCRIPT_DIR/measure.py"
PREPROCESS_PY="$SCRIPT_DIR/preprocess.py"
EXTRACT_BENCH_LABELS_PY="$SCRIPT_DIR/extract_bench_labels.py"

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

# Source file expansion utilities
source "$SCRIPT_DIR/file_expansion_utils.sh"

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Training pipeline: measure → preprocess → train

Required arguments:
  --train-files PATTERN     C file(s) to train the model from (supports glob patterns and brace expansion)

Optional arguments:
  --training-raw-csv PATTERN     Raw measurement CSV file(s) for training (glob pattern, semicolon-separated, or matched by basename)
  --training-segments-csv PATTERN  Preprocessed segments CSV file(s) for training (glob pattern, semicolon-separated, or matched by basename)
  --params FILE             Model parameters JSON file (default: temp file)
  --tag TAG                 Tag for naming output files (default: process ID)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --max-steps N             Maximum execution steps for training
  --n-samples N             Number of samples for inference (default: 100)
  --num-repeat N            NUM_REPEAT value for training compilation (default: 10)
  --model MODEL             Energy model: gamma_per_instruction, gamma_per_addressing_mode, mean_per_instruction, mean_per_addressing_mode (default: gamma_per_instruction)
  --inference ALG           Inference algorithm: importance-sampling, or mcmc-blocked (default: importance-sampling)
  --skip-reset              Skip device reset during measurement
  --keep-intermediates      Keep intermediate files and suggest resume commands
  --help                    Show this help message

Examples:
  # Single training file
  $0 --train-files examples/c_programs/simple.c

  # All .c files in a directory
  $0 --train-files "examples/c_programs/*.c"

  # Recursive glob (all .c files in subdirectories)
  $0 --train-files "examples/**/*.c"

  # Brace expansion (specific files)
  $0 --train-files "examples/c_programs/{file1,file2,file3}.c"

  # Resume with existing segments (matched by basename)
  $0 --train-files "training_data/*.c" \\
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
        --training-raw-csv)
            TRAINING_RAW_CSV="$2"
            shift 2
            ;;
        --training-segments-csv)
            TRAINING_SEGMENTS_CSV="$2"
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
        --model)
            MODEL="$2"
            shift 2
            ;;
        --inference)
            INFERENCE="$2"
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

# Setup temporary files if not provided
mkdir -p "$TEMP_DIR"

# Create timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Determine file suffix (TAG_TIMESTAMP if TAG provided, otherwise just TIMESTAMP)
if [[ -n "$TAG" ]]; then
    FILE_SUFFIX="${TAG}_${TIMESTAMP}"
else
    FILE_SUFFIX="${TIMESTAMP}"
fi

# Setup training file arrays for raw and segment CSVs
TRAINING_RAW_CSV_ARRAY=()
TRAINING_SEGMENTS_CSV_ARRAY=()

# Match training files to CSVs by basename (supports glob patterns)
if [[ -n "$TRAINING_RAW_CSV" ]]; then
    log_info "Matching training raw CSVs by basename..."
    mapfile -t TRAINING_RAW_CSV_ARRAY < <(match_files_by_basename TRAIN_FILE_ARRAY "$TRAINING_RAW_CSV")
fi

if [[ -n "$TRAINING_SEGMENTS_CSV" ]]; then
    log_info "Matching training segments CSVs by basename..."
    mapfile -t TRAINING_SEGMENTS_CSV_ARRAY < <(match_files_by_basename TRAIN_FILE_ARRAY "$TRAINING_SEGMENTS_CSV")
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
        TRAINING_SEGMENTS_CSV_ARRAY[$i]="$TEMP_DIR/${basename}_${TIMESTAMP}_segments.csv"
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

# Determine which steps to skip based on provided intermediate files
SKIP_MEASUREMENT=0
SKIP_PREPROCESSING=0
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

# If PARAMS provided and exists, skip all steps
if [[ -n "$PARAMS_FILE" ]] && [[ -f "$PARAMS_FILE" ]] && [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    SKIP_MEASUREMENT=1
    SKIP_PREPROCESSING=1
    SKIP_TRAINING=1
    log_info "Using existing params: $PARAMS_FILE (all steps skipped)"
fi

# Check training segments - if provided, skip measurement and preprocessing
if [[ $ALL_TRAINING_SEGMENTS_EXIST -eq 1 ]]; then
    SKIP_MEASUREMENT=1
    SKIP_PREPROCESSING=1
    log_info "Using existing training segments (${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files) - skipping measurement and preprocessing"
# Else if all TRAINING_RAW_CSV provided and exist, skip measurement only
elif [[ $ALL_TRAINING_RAW_EXIST -eq 1 ]]; then
    SKIP_MEASUREMENT=1
    log_info "Using existing training raw CSVs (${#TRAINING_RAW_CSV_ARRAY[@]} files) - skipping measurement"
fi

# Cleanup function
cleanup() {
    # Cleanup event label files
    for label_file in "${TRAINING_EVENT_LABELS_ARRAY[@]}"; do
        rm -f "$label_file"
    done

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
}

# Register cleanup on exit
trap cleanup EXIT

# ============================================================
# MAIN PIPELINE
# ============================================================

log_step "TRAINING PIPELINE START"
log_info "Training files: ${#TRAIN_FILE_ARRAY[@]}"
for train_file in "${TRAIN_FILE_ARRAY[@]}"; do
    log_info "  - $train_file"
done
log_info "Output params file: $PARAMS_FILE"

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
        log_step "Step 1.$((i+1)): Compiling training file ($train_basename)"
        log_info "Compiling with NUM_REPEAT=$NUM_REPEAT"
        $CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${train_basename}.elf" "$train_file"
        log_success "Compiled: $BUILD_DIR/${train_basename}.elf"

        # Step 2: Flash training file to device
        log_step "Step 2.$((i+1)): Flashing training file to device ($train_basename)"
        log_info "Flashing $BUILD_DIR/${train_basename}.elf..."
        mspdebug tilib "prog $BUILD_DIR/${train_basename}.elf" "exit"
        log_success "Flashed to device"

        # Step 3: Measure training file energy
        log_step "Step 3.$((i+1)): Measuring training file energy consumption ($train_basename)"
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

echo ""
log_info "==> Hardware no longer required - remaining steps can run offline"
echo ""

# Step 4: Preprocess training measurements
if [[ $SKIP_PREPROCESSING -eq 0 ]]; then
    for i in "${!TRAINING_RAW_CSV_ARRAY[@]}"; do
        training_raw_csv="${TRAINING_RAW_CSV_ARRAY[$i]}"
        training_segments_csv="${TRAINING_SEGMENTS_CSV_ARRAY[$i]}"
        train_file="${TRAIN_FILE_ARRAY[$i]}"
        train_basename=$(basename "$train_file" .c)
        event_labels_json="${TRAINING_EVENT_LABELS_ARRAY[$i]}"

        log_step "Step 4.$((i+1)): Preprocessing training measurements ($train_basename)"
        python3 "$PREPROCESS_PY" \
            --input "$training_raw_csv" \
            --output "$training_segments_csv" \
            --event-labels "$event_labels_json"
        log_success "Training segments saved: $training_segments_csv"
    done
else
    log_step "Step 4: SKIPPED (using existing training segments CSVs: ${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files)"
fi

# Step 5: Train energy model
if [[ $SKIP_TRAINING -eq 0 ]]; then
    log_step "Step 5: Training energy model from ${#TRAIN_FILE_ARRAY[@]} file(s)"

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
        $MODEL_FLAG \
        $INFERENCE_FLAG
    log_success "Model trained: $PARAMS_FILE"
else
    log_step "Step 5: SKIPPED (using existing params: $PARAMS_FILE)"
fi

# Done
log_step "TRAINING PIPELINE COMPLETE"
log_success "Training completed successfully!"
echo ""
log_info "Output files:"
if [[ $USE_TEMP_TRAINING_RAW -eq 0 ]]; then
    echo "  - Training Raw CSVs (${#TRAINING_RAW_CSV_ARRAY[@]} files):"
    for csv in "${TRAINING_RAW_CSV_ARRAY[@]}"; do
        echo "      $csv"
    done
fi
if [[ $USE_TEMP_TRAINING_SEGMENTS -eq 0 ]]; then
    echo "  - Training Segments CSVs (${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files):"
    for csv in "${TRAINING_SEGMENTS_CSV_ARRAY[@]}"; do
        echo "      $csv"
    done
fi
if [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    echo "  - Parameters: $PARAMS_FILE"
fi

# Suggest resume command if keeping intermediates
if [[ $KEEP_INTERMEDIATES -eq 1 ]]; then
    echo ""
    log_info "To reuse these outputs, run:"
    echo "  $0 \\"
    echo "    --train-files \"$TRAIN_FILES\" \\"
    if [[ $USE_TEMP_TRAINING_RAW -eq 0 ]]; then
        echo "    --training-raw-csv \"${TRAINING_RAW_CSV_ARRAY[0]}\" \\"
    fi
    if [[ $USE_TEMP_TRAINING_SEGMENTS -eq 0 ]]; then
        echo "    --training-segments-csv \"${TRAINING_SEGMENTS_CSV_ARRAY[0]}\" \\"
    fi
    if [[ $USE_TEMP_PARAMS -eq 0 ]]; then
        echo "    --params \"$PARAMS_FILE\""
    fi
fi
