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
NUM_REPEAT=10
REPORT_DIR="./report"
TEMP_DIR="./tmp"

# Required parameters (to be set via command line)
TRAIN_FILE=""
ESTIMATE_FILE=""
RAW_CSV=""
SEGMENTS_CSV=""
PARAMS_FILE=""
ESTIMATED_STATS_JSON=""
MEASURED_RAW_CSV=""
MEASURED_SEGMENTS_CSV=""

# Optional intermediate files
USE_TEMP_RAW=0
USE_TEMP_SEGMENTS=0
USE_TEMP_PARAMS=0
USE_TEMP_MEASURED_RAW=0
USE_TEMP_MEASURED_SEGMENTS=0

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

Optional arguments:
  --raw-csv FILE            Raw measurement CSV file (default: temp file)
  --segments-csv FILE       Preprocessed segments CSV file (default: temp file)
  --params FILE             Model parameters JSON file (default: temp file)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --max-steps N             Maximum execution steps for train/estimate
  --n-samples N             Number of samples for importance sampling (default: 100)
  --num-repeat N            NUM_REPEAT value for training compilation (default: 10)
  --report-dir DIR          Directory for comparison report (default: ./report)
  --skip-reset              Skip device reset during measurement
  --help                    Show this help message

Examples:
  # Basic usage (all intermediate files temporary)
  $0 --train-file examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c

  # Keep intermediate files
  $0 --train-file examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c \\
     --raw-csv measurement.csv \\
     --segments-csv segments.csv \\
     --params energy_params.json

  # Custom measurement settings
  $0 --train-file examples/c_programs/simple.c \\
     --estimate-file examples/c_programs/test.c \\
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
        --num-repeat)
            NUM_REPEAT="$2"
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

# Setup temporary files for measured data and estimated stats (always temp)
ESTIMATED_STATS_JSON="$TEMP_DIR/estimated_stats_$$.json"
MEASURED_RAW_CSV="$TEMP_DIR/measured_$$.csv"
MEASURED_SEGMENTS_CSV="$TEMP_DIR/measured_segments_$$.csv"
USE_TEMP_MEASURED_RAW=1
USE_TEMP_MEASURED_SEGMENTS=1

# Create timestamped report directory
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_DIR_FULL="${REPORT_DIR}/${TIMESTAMP}"
log_info "Report will be saved to: $REPORT_DIR_FULL"

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
    if [[ $USE_TEMP_MEASURED_RAW -eq 1 ]] && [[ -f "$MEASURED_RAW_CSV" ]]; then
        log_info "Cleaning up temporary measured raw CSV: $MEASURED_RAW_CSV"
        rm -f "$MEASURED_RAW_CSV"
    fi
    if [[ $USE_TEMP_MEASURED_SEGMENTS -eq 1 ]] && [[ -f "$MEASURED_SEGMENTS_CSV" ]]; then
        log_info "Cleaning up temporary measured segments CSV: $MEASURED_SEGMENTS_CSV"
        rm -f "$MEASURED_SEGMENTS_CSV"
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
log_info "Report directory: $REPORT_DIR_FULL"

# Step 1: Compile training file
log_step "Step 1/10: Compiling training file"
mkdir -p "$BUILD_DIR" "$ASM_DIR"
cd "$PROJECT_ROOT"
log_info "Compiling with NUM_REPEAT=$NUM_REPEAT"
$CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${TRAIN_BASENAME}.elf" "$TRAIN_FILE"
log_success "Compiled: $BUILD_DIR/${TRAIN_BASENAME}.elf"

# Step 2: Flash training file to device
log_step "Step 2/10: Flashing training file to device"
log_info "Flashing $BUILD_DIR/${TRAIN_BASENAME}.elf..."
mspdebug tilib "prog $BUILD_DIR/${TRAIN_BASENAME}.elf" "exit"
log_success "Flashed to device"

# Step 3: Measure energy
log_step "Step 3/10: Measuring energy consumption"
log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
python3 "$MEASURE_PY" \
    --voltage "$VOLTAGE" \
    --max_current "$MAX_CURRENT" \
    --outfile "$RAW_CSV" \
    $SKIP_RESET
log_success "Raw measurement saved: $RAW_CSV"

# Step 4: Preprocess measurements
log_step "Step 4/10: Preprocessing measurements"
python3 "$PREPROCESS_PY" \
    --input "$RAW_CSV" \
    --output "$SEGMENTS_CSV"
log_success "Segments saved: $SEGMENTS_CSV"

# Step 5: Disassemble training file and train model
log_step "Step 5/10: Training energy model"
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
log_step "Step 6/10: Compiling estimation file"
log_info "Compiling with NUM_REPEAT=1 (estimation mode)"
$CC $CFLAGS -DNUM_REPEAT=1 $INCLUDES $LDFLAGS -o "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" "$ESTIMATE_FILE"
log_success "Compiled: $BUILD_DIR/${ESTIMATE_BASENAME}.elf"
$OBJDUMP -d "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" > "$ASM_DIR/${ESTIMATE_BASENAME}.asm"
log_success "Disassembled: $ASM_DIR/${ESTIMATE_BASENAME}.asm"

# Step 7: Estimate energy consumption
log_step "Step 7/10: Estimating energy consumption"
julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" estimate \
    --asm "$ASM_DIR/${ESTIMATE_BASENAME}.asm" \
    --params "$PARAMS_FILE" \
    --output "$ESTIMATED_STATS_JSON" \
    $MAX_STEPS_FLAG
log_success "Estimation complete: $ESTIMATED_STATS_JSON"

# Step 8: Recompile estimation file for measurement with NUM_REPEAT
log_step "Step 8/10: Recompiling estimation file for measurement"
log_info "Compiling with NUM_REPEAT=$NUM_REPEAT (for measurement)"
$CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${ESTIMATE_BASENAME}.elf" "$ESTIMATE_FILE"
log_success "Recompiled: $BUILD_DIR/${ESTIMATE_BASENAME}.elf"

# Step 9: Flash and measure estimation file
log_step "Step 9/10: Measuring estimation file energy consumption"
log_info "Flashing $BUILD_DIR/${ESTIMATE_BASENAME}.elf..."
mspdebug tilib "prog $BUILD_DIR/${ESTIMATE_BASENAME}.elf" "exit"
log_success "Flashed to device"

log_info "Measuring energy (Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A)"
python3 "$MEASURE_PY" \
    --voltage "$VOLTAGE" \
    --max_current "$MAX_CURRENT" \
    --outfile "$MEASURED_RAW_CSV" \
    $SKIP_RESET
log_success "Measured raw data saved: $MEASURED_RAW_CSV"

log_info "Preprocessing measured data"
python3 "$PREPROCESS_PY" \
    --input "$MEASURED_RAW_CSV" \
    --output "$MEASURED_SEGMENTS_CSV"
log_success "Measured segments saved: $MEASURED_SEGMENTS_CSV"

# Step 10: Generate comparison report
log_step "Step 10/10: Generating comparison report"
python3 "$PROJECT_ROOT/scripts/generate_comparison_report.py" \
    --estimated-stats "$ESTIMATED_STATS_JSON" \
    --measured-data "$MEASURED_SEGMENTS_CSV" \
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
if [[ $USE_TEMP_RAW -eq 0 ]]; then
    echo "  - Training Raw CSV: $RAW_CSV"
fi
if [[ $USE_TEMP_SEGMENTS -eq 0 ]]; then
    echo "  - Training Segments CSV: $SEGMENTS_CSV"
fi
if [[ $USE_TEMP_PARAMS -eq 0 ]]; then
    echo "  - Parameters: $PARAMS_FILE"
fi
