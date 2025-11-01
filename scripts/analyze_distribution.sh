#!/bin/bash
# Analyze energy distribution: flash → measure → preprocess → analyze
# Usage: ./scripts/analyze_distribution.sh [options]

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
NUM_REPEAT=10
REPORT_DIR="./report"
TEMP_DIR="./tmp"
TAG=""

# Required parameters (to be set via command line)
FILE=""

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MEASURE_PY="$SCRIPT_DIR/measure.py"
PREPROCESS_PY="$SCRIPT_DIR/preprocess.py"
GENERATE_REPORT_PY="$SCRIPT_DIR/generate_distribution_report.py"

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
DEVICE="MSP430FR5994"
CFLAGS="-mmcu=$DEVICE -O0 -g -Wall"
INCLUDES="-I$MSP430GCC_SUPPORT_PATH/include -I$PROJECT_ROOT/include"
LDFLAGS="-L$MSP430GCC_SUPPORT_PATH/include"
BUILD_DIR="$PROJECT_ROOT/build"

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

Analyze energy distribution: flash → measure → preprocess → analyze

Required arguments:
  --file FILE               C file to analyze

Optional arguments:
  --tag TAG                 Tag for naming output files (default: none)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --num-repeat N            NUM_REPEAT value for compilation (default: 10)
  --report-dir DIR          Directory for report (default: ./report)
  --skip-reset              Skip device reset during measurement
  --help                    Show this help message

Examples:
  # Basic usage
  $0 --file examples/c_programs/simple.c

  # With tag for organized output
  $0 --file examples/c_programs/simple.c --tag experiment1

  # Custom measurement settings
  $0 --file examples/c_programs/simple.c \\
     --voltage 3.0 \\
     --max-current 0.02
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            FILE="$2"
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
if [[ -z "$FILE" ]]; then
    log_error "Missing required argument: --file"
    usage
    exit 1
fi

# Check if file exists
if [[ ! -f "$FILE" ]]; then
    log_error "File not found: $FILE"
    exit 1
fi

# Setup temporary files and directories
mkdir -p "$TEMP_DIR"
mkdir -p "$BUILD_DIR"

# Create timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Extract basename
BASENAME="$(basename "$FILE" .c)"

# Determine report directory
if [[ -n "$TAG" ]]; then
    REPORT_DIR_FULL="${REPORT_DIR}/analyze_distribution/${TAG}"
else
    REPORT_DIR_FULL="${REPORT_DIR}/analyze_distribution/${TIMESTAMP}"
fi

mkdir -p "$REPORT_DIR_FULL"

# Setup file paths
TRAINING_RAW_CSV="$TEMP_DIR/raw_${BASENAME}_${TIMESTAMP}.csv"
TRAINING_SEGMENTS_CSV="$REPORT_DIR_FULL/segments.csv"

# ============================================================
# MAIN PIPELINE
# ============================================================

log_step "ANALYZE DISTRIBUTION START"
log_info "File: $FILE"
log_info "Report directory: $REPORT_DIR_FULL"

cd "$PROJECT_ROOT"

# Step 1: Compile
log_step "Step 1/4: Compiling $FILE"
log_info "Compiling with NUM_REPEAT=$NUM_REPEAT"
$CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${BASENAME}.elf" "$FILE"
log_success "Compiled: $BUILD_DIR/${BASENAME}.elf"

# Step 2: Flash
log_step "Step 2/4: Flashing binary to device"
log_info "Flashing $BUILD_DIR/${BASENAME}.elf..."
mspdebug tilib "prog $BUILD_DIR/${BASENAME}.elf" "exit"
log_success "Flashed to device"

# Step 3: Measure
log_step "Step 3/4: Measuring energy consumption"
log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
python3 "$MEASURE_PY" \
    --voltage "$VOLTAGE" \
    --max_current "$MAX_CURRENT" \
    --outfile "$TRAINING_RAW_CSV" \
    $SKIP_RESET
log_success "Raw measurement saved: $TRAINING_RAW_CSV"

# Step 4: Preprocess
log_step "Step 4/5: Preprocessing measurements"
python3 "$PREPROCESS_PY" \
    --input "$TRAINING_RAW_CSV" \
    --output "$TRAINING_SEGMENTS_CSV"
log_success "Segments saved: $TRAINING_SEGMENTS_CSV"

# Step 5: Generate distribution analysis report
log_step "Step 5/5: Generating distribution analysis report"
python3 "$GENERATE_REPORT_PY" \
    --segments-csv "$TRAINING_SEGMENTS_CSV" \
    --num-repeat "$NUM_REPEAT" \
    --report-dir "$REPORT_DIR_FULL" \
    --file-name "$FILE"
log_success "Distribution analysis report generated"

# Cleanup temporary raw CSV
rm -f "$TRAINING_RAW_CSV"
log_info "Cleaned up temporary file: $TRAINING_RAW_CSV"

# Done
log_step "ANALYSIS COMPLETE"
log_success "All steps completed successfully!"
echo ""
log_info "Output files:"
echo "  - Markdown Report: ${REPORT_DIR_FULL}/distribution_analysis.md"
echo "  - Segments CSV: $TRAINING_SEGMENTS_CSV"
echo "  - Summary CSV: ${REPORT_DIR_FULL}/distribution_summary.csv"
echo "  - Distribution plots: ${REPORT_DIR_FULL}/event_*_distribution.png"
echo "  - Report directory: $REPORT_DIR_FULL"
