#!/usr/bin/env bash
# Training pipeline: measure → preprocess → train
# Usage: ./scripts/train.sh [options]
# Requires: bash 4.0+ (for mapfile)

# Setup script directory before sourcing common
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities and configuration
source "$SCRIPT_DIR/common.sh"

# Default values (using common defaults where applicable)
VOLTAGE="${VOLTAGE_DEFAULT}"
MAX_CURRENT="${MAX_CURRENT_DEFAULT}"
TEMP_DIR="${TEMP_DIR:-${TEMP_DIR_DEFAULT}}"
SKIP_RESET=""
MAX_STEPS=""
N_SAMPLES=""
MODEL="gamma_per_instruction"
INFERENCE="importance-sampling"
KEEP_INTERMEDIATES=0
TAG=""
TIMESTAMP=""  # Optional timestamp (if not provided, will be auto-generated)
DEFINES=""  # Space-separated list of compiler macros

# Required parameters (to be set via command line)
TRAIN_FILES=""  # Pattern for training files (supports glob patterns and brace expansion)
TRAINING_SEGMENTS_CSV=""  # Semicolon-separated list (optional, for resuming)
PARAMS_FILE=""

# Optional intermediate files
USE_TEMP_TRAINING_SEGMENTS=0
USE_TEMP_PARAMS=0

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Training pipeline: measure → preprocess → train

Required arguments:
  --train-files PATTERN     C file(s) to train the model from (supports glob patterns and brace expansion)

Optional arguments:
  --training-segments-csv PATTERN  Preprocessed segments CSV file(s) for training (semicolon-separated list or glob pattern; automatically matched to training files by basename)
  --params FILE             Model parameters JSON file (default: temp file)
  --tag TAG                 Tag for naming output files (default: process ID)
  --timestamp TIMESTAMP     Timestamp to use for file naming (default: auto-generated)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --max-steps N             Maximum execution steps for training
  --n-samples N             Number of samples for inference (default: 100)
  --model MODEL             Energy model: gamma_per_instruction, gamma_per_addressing_mode, mean_per_instruction, mean_per_addressing_mode (default: gamma_per_instruction)
  --inference ALG           Inference algorithm: importance-sampling, or mcmc-blocked (default: importance-sampling)
  --defines "MACROS"        Space-separated compiler macros (e.g., "FOO=1 BAR ENABLE_FEATURE=value")
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
        --timestamp)
            TIMESTAMP="$2"
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
        --defines)
            DEFINES="$2"
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

# Create timestamp if not provided
if [[ -z "$TIMESTAMP" ]]; then
    TIMESTAMP=$(create_timestamp)
fi

# Determine file suffix (TAG_TIMESTAMP if TAG provided, otherwise just TIMESTAMP)
if [[ -n "$TAG" ]]; then
    FILE_SUFFIX="${TAG}_${TIMESTAMP}"
else
    FILE_SUFFIX="${TIMESTAMP}"
fi

# Setup training file array for segment CSVs
TRAINING_SEGMENTS_CSV_ARRAY=()

# Match training files to segment CSVs by basename (supports glob patterns)
if [[ -n "$TRAINING_SEGMENTS_CSV" ]]; then
    log_info "Matching training segments CSVs by basename..."
    csv_matches=$(match_files_by_basename "TRAIN_FILE_ARRAY" "$TRAINING_SEGMENTS_CSV" "training segments CSV")
    mapfile -t TRAINING_SEGMENTS_CSV_ARRAY <<< "$csv_matches"
fi

# Create temp file paths for training files without matched CSVs
for i in "${!TRAIN_FILE_ARRAY[@]}"; do
    train_file="${TRAIN_FILE_ARRAY[$i]}"
    basename=$(basename "$train_file" .c)

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

# Process DEFINES variable
DEFINE_FLAGS=$(process_defines "$DEFINES")
if [[ -n "$DEFINES" ]]; then
    log_info "Using compiler defines: $DEFINES"
fi

# Determine which steps to skip based on provided intermediate files
SKIP_TRAINING=0

# If PARAMS provided and exists, skip training
if [[ -n "$PARAMS_FILE" ]] && [[ -f "$PARAMS_FILE" ]] && [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    SKIP_TRAINING=1
    log_info "Using existing params: $PARAMS_FILE (training skipped)"
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

# Process each training file individually: measure → preprocess → remove raw data
PROCESSED_COUNT=0
SKIPPED_COUNT=0

for i in "${!TRAIN_FILE_ARRAY[@]}"; do
    train_file="${TRAIN_FILE_ARRAY[$i]}"
    train_basename=$(basename "$train_file" .c)
    training_segments_csv="${TRAINING_SEGMENTS_CSV_ARRAY[$i]}"
    event_labels_json="${TRAINING_EVENT_LABELS_ARRAY[$i]}"
    training_raw_csv="$TEMP_DIR/${train_basename}_${TIMESTAMP}.csv"

    log_info ""
    log_info "Processing training file $((i+1))/${#TRAIN_FILE_ARRAY[@]}: $train_file"

    # Check if segments CSV already exists for this file
    if [[ -f "$training_segments_csv" ]]; then
        log_info "✓ Segments CSV already exists: $training_segments_csv - SKIPPING measurement and preprocessing"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi

    # Compile training file
    log_step "Compiling training file ($train_basename)"
    $CC $CFLAGS $DEFINE_FLAGS $INCLUDES $LDFLAGS -o "$BUILD_DIR/${train_basename}.elf" "$train_file"
    log_success "Compiled: $BUILD_DIR/${train_basename}.elf"

    # Flash training file to device
    log_step "Flashing training file to device ($train_basename)"
    log_info "Flashing $BUILD_DIR/${train_basename}.elf..."
    mspdebug tilib "prog $BUILD_DIR/${train_basename}.elf" "exit"
    log_success "Flashed to device"

    # Measure training file energy
    log_step "Measuring training file energy consumption ($train_basename)"
    log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
    python3 "$MEASURE_PY" \
        --voltage "$VOLTAGE" \
        --max_current "$MAX_CURRENT" \
        --outfile "$training_raw_csv" \
        $SKIP_RESET
    log_success "Training raw measurement saved: $training_raw_csv"

    # Preprocess immediately after measurement
    log_step "Preprocessing training measurements ($train_basename)"
    python3 "$PREPROCESS_PY" \
        --input "$training_raw_csv" \
        --output "$training_segments_csv" \
        --event-labels "$event_labels_json"
    log_success "Training segments saved: $training_segments_csv"

    # Remove raw data immediately after preprocessing
    rm -f "$training_raw_csv"
    log_info "Removed raw data: $training_raw_csv"

    PROCESSED_COUNT=$((PROCESSED_COUNT + 1))
done

log_info ""
log_info "Processing summary: $PROCESSED_COUNT processed, $SKIPPED_COUNT skipped (already have segments CSV)"

echo ""
log_info "==> Hardware no longer required - remaining steps can run offline"
echo ""

# Train energy model
if [[ $SKIP_TRAINING -eq 0 ]]; then
    log_step "Training energy model from ${#TRAIN_FILE_ARRAY[@]} file(s)"

    # Compile and disassemble all training files
    ASM_FILES=()
    for i in "${!TRAIN_FILE_ARRAY[@]}"; do
        train_file="${TRAIN_FILE_ARRAY[$i]}"
        train_basename=$(basename "$train_file" .c)

        # Compile if .elf doesn't exist (e.g., when resuming from segments)
        if [[ ! -f "$BUILD_DIR/${train_basename}.elf" ]]; then
            log_info "Compiling $train_basename"
            $CC $CFLAGS $DEFINE_FLAGS $INCLUDES $LDFLAGS -o "$BUILD_DIR/${train_basename}.elf" "$train_file"
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
    log_step "Training SKIPPED (using existing params: $PARAMS_FILE)"
fi

# Done
log_step "TRAINING PIPELINE COMPLETE"
log_success "Training completed successfully!"
echo ""
log_info "Output files:"
if [[ $USE_TEMP_TRAINING_SEGMENTS -eq 0 ]]; then
    echo "  - Training Segments CSVs (${#TRAINING_SEGMENTS_CSV_ARRAY[@]} files):"
    for csv in "${TRAINING_SEGMENTS_CSV_ARRAY[@]}"; do
        echo "      $csv"
    done
fi
if [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    echo "  - Parameters: $PARAMS_FILE"
fi
