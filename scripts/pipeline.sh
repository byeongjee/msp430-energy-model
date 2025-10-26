#!/bin/bash
# Full pipeline: measure → preprocess → train → estimate
# Usage: ./scripts/pipeline.sh [options]

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
TEMP_DIR="./tmp"

# Required parameters (to be set via command line)
TRAIN_FILE=""
ESTIMATE_FILE=""
PLOT_FILE=""
RAW_CSV=""
SEGMENTS_CSV=""
PARAMS_FILE=""

# Optional intermediate files
USE_TEMP_RAW=0
USE_TEMP_SEGMENTS=0
USE_TEMP_PARAMS=0

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MEASURE_PY="$PROJECT_ROOT/measurement/measure.py"
PREPROCESS_PY="$PROJECT_ROOT/measurement/preprocess.py"

# Load Makefile variables
MSPGCC_PATH="$PROJECT_ROOT/../msp430-gcc/bin"
MSP430_INC_PATH="$HOME/ti/msp430-gcc/include"
MSP430_LD_PATH="$HOME/ti/msp430-gcc/include"
CC="$MSPGCC_PATH/msp430-elf-gcc"
OBJDUMP="$MSPGCC_PATH/msp430-elf-objdump"
DEVICE="MSP430FR5994"
CFLAGS="-mmcu=$DEVICE -O0 -g -Wall"
INCLUDES="-I$MSP430_INC_PATH -I$PROJECT_ROOT/include"
LDFLAGS="-L$MSP430_LD_PATH"
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

Full pipeline: measure → preprocess → train → estimate

Required arguments:
  --train-file FILE         C file to train the model from
  --estimate-file FILE      C file to estimate energy for
  --plot FILE               Output plot filename

Optional arguments:
  --raw-csv FILE            Raw measurement CSV file (default: temp file)
  --segments-csv FILE       Preprocessed segments CSV file (default: temp file)
  --params FILE             Model parameters JSON file (default: temp file)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --max-steps N             Maximum execution steps for train/estimate
  --n-samples N             Number of samples for importance sampling (default: 100)
  --skip-reset              Skip device reset during measurement
  --help                    Show this help message

Examples:
  # Basic usage (all intermediate files temporary)
  $0 --train-file examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c \\
     --plot result.png

  # Keep intermediate files
  $0 --train-file examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c \\
     --plot result.png \\
     --raw-csv measurement.csv \\
     --segments-csv segments.csv \\
     --params energy_params.json

  # Custom measurement settings
  $0 --train-file examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c \\
     --plot result.png \\
     --voltage 3.0 \\
     --max-current 0.02 \\
     --max-steps 1000
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --train-file)
            TRAIN_FILE="$2"
            shift 2
            ;;
        --estimate-file)
            ESTIMATE_FILE="$2"
            shift 2
            ;;
        --plot)
            PLOT_FILE="$2"
            shift 2
            ;;
        --raw-csv)
            RAW_CSV="$2"
            shift 2
            ;;
        --segments-csv)
            SEGMENTS_CSV="$2"
            shift 2
            ;;
        --params)
            PARAMS_FILE="$2"
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
        --skip-reset)
            SKIP_RESET="--skip_reset"
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
if [[ -z "$TRAIN_FILE" ]]; then
    log_error "Missing required argument: --train-file"
    usage
    exit 1
fi

if [[ -z "$ESTIMATE_FILE" ]]; then
    log_error "Missing required argument: --estimate-file"
    usage
    exit 1
fi

if [[ -z "$PLOT_FILE" ]]; then
    log_error "Missing required argument: --plot"
    usage
    exit 1
fi

# Check if files exist
if [[ ! -f "$TRAIN_FILE" ]]; then
    log_error "Training file not found: $TRAIN_FILE"
    exit 1
fi

if [[ ! -f "$ESTIMATE_FILE" ]]; then
    log_error "Estimation file not found: $ESTIMATE_FILE"
    exit 1
fi

# Setup temporary files if not provided
mkdir -p "$TEMP_DIR"

if [[ -z "$RAW_CSV" ]]; then
    RAW_CSV="$TEMP_DIR/measurement_$$.csv"
    USE_TEMP_RAW=1
    log_info "Using temporary raw CSV: $RAW_CSV"
fi

if [[ -z "$SEGMENTS_CSV" ]]; then
    SEGMENTS_CSV="$TEMP_DIR/segments_$$.csv"
    USE_TEMP_SEGMENTS=1
    log_info "Using temporary segments CSV: $SEGMENTS_CSV"
fi

if [[ -z "$PARAMS_FILE" ]]; then
    PARAMS_FILE="$TEMP_DIR/params_$$.json"
    USE_TEMP_PARAMS=1
    log_info "Using temporary params file: $PARAMS_FILE"
fi

# Extract basenames
TRAIN_BASENAME="$(basename "$TRAIN_FILE" .c)"
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

# Cleanup function
cleanup() {
    if [[ $USE_TEMP_RAW -eq 1 ]] && [[ -f "$RAW_CSV" ]]; then
        log_info "Cleaning up temporary raw CSV: $RAW_CSV"
        rm -f "$RAW_CSV"
    fi
    if [[ $USE_TEMP_SEGMENTS -eq 1 ]] && [[ -f "$SEGMENTS_CSV" ]]; then
        log_info "Cleaning up temporary segments CSV: $SEGMENTS_CSV"
        rm -f "$SEGMENTS_CSV"
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

log_step "PIPELINE START"
log_info "Train file: $TRAIN_FILE"
log_info "Estimate file: $ESTIMATE_FILE"
log_info "Plot output: $PLOT_FILE"

# Step 1: Compile training file
log_step "Step 1/7: Compiling training file"
mkdir -p "$BUILD_DIR" "$ASM_DIR"
cd "$PROJECT_ROOT"
log_info "Compiling with TRAIN_MODE flag"
$CC $CFLAGS -DTRAIN_MODE $INCLUDES $LDFLAGS -o "$BUILD_DIR/${TRAIN_BASENAME}.elf" "$TRAIN_FILE"
log_success "Compiled: $BUILD_DIR/${TRAIN_BASENAME}.elf"

# Step 2: Flash training file to device
log_step "Step 2/7: Flashing training file to device"
log_info "Flashing $BUILD_DIR/${TRAIN_BASENAME}.elf..."
mspdebug tilib "prog $BUILD_DIR/${TRAIN_BASENAME}.elf" "exit"
log_success "Flashed to device"

# Step 3: Measure energy
log_step "Step 3/7: Measuring energy consumption"
log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
python3 "$MEASURE_PY" \
    --voltage "$VOLTAGE" \
    --max_current "$MAX_CURRENT" \
    --outfile "$RAW_CSV" \
    $SKIP_RESET
log_success "Raw measurement saved: $RAW_CSV"

# Step 4: Preprocess measurements
log_step "Step 4/7: Preprocessing measurements"
python3 "$PREPROCESS_PY" \
    --input "$RAW_CSV" \
    --output "$SEGMENTS_CSV"
log_success "Segments saved: $SEGMENTS_CSV"

# Step 5: Disassemble training file and train model
log_step "Step 5/7: Training energy model"
$OBJDUMP -d "$BUILD_DIR/${TRAIN_BASENAME}.elf" > "$ASM_DIR/${TRAIN_BASENAME}.asm"
log_info "Disassembled: $ASM_DIR/${TRAIN_BASENAME}.asm"
julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" train \
    --asm "$ASM_DIR/${TRAIN_BASENAME}.asm" \
    --data "$SEGMENTS_CSV" \
    --output "$PARAMS_FILE" \
    $MAX_STEPS_FLAG \
    $N_SAMPLES_FLAG
log_success "Model trained: $PARAMS_FILE"

# Step 6: Compile and disassemble estimation file
log_step "Step 6/7: Compiling estimation file"
log_info "Compiling with ESTIMATE_MODE flag"
$CC $CFLAGS -DESTIMATE_MODE $INCLUDES $LDFLAGS -o "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" "$ESTIMATE_FILE"
log_success "Compiled: $BUILD_DIR/${ESTIMATE_BASENAME}.elf"
$OBJDUMP -d "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" > "$ASM_DIR/${ESTIMATE_BASENAME}.asm"
log_success "Disassembled: $ASM_DIR/${ESTIMATE_BASENAME}.asm"

# Step 7: Estimate energy consumption
log_step "Step 7/7: Estimating energy consumption"
julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" estimate \
    --asm "$ASM_DIR/${ESTIMATE_BASENAME}.asm" \
    --params "$PARAMS_FILE" \
    --plot "$PLOT_FILE" \
    $MAX_STEPS_FLAG
log_success "Estimation complete: $PLOT_FILE"

# Done
log_step "PIPELINE COMPLETE"
log_success "All steps completed successfully!"
echo ""
log_info "Output files:"
echo "  - Plot: $PLOT_FILE"
if [[ $USE_TEMP_RAW -eq 0 ]]; then
    echo "  - Raw CSV: $RAW_CSV"
fi
if [[ $USE_TEMP_SEGMENTS -eq 0 ]]; then
    echo "  - Segments CSV: $SEGMENTS_CSV"
fi
if [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    echo "  - Parameters: $PARAMS_FILE"
fi
