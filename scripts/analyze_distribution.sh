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
FILES=""  # Semicolon-separated list of files

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MEASURE_PY="$SCRIPT_DIR/measure.py"
PREPROCESS_PY="$SCRIPT_DIR/preprocess.py"
GENERATE_REPORT_PY="$SCRIPT_DIR/generate_distribution_report.py"
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
  --files FILES             C file(s) to analyze (semicolon-separated for multiple)

Optional arguments:
  --tag TAG                 Tag for naming output files (default: none)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --num-repeat N            NUM_REPEAT value for compilation (default: 10)
  --report-dir DIR          Directory for report (default: ./report)
  --skip-reset              Skip device reset during measurement
  --help                    Show this help message

Examples:
  # Basic usage (single file)
  $0 --files examples/c_programs/simple.c

  # Multiple files
  $0 --files "file1.c;file2.c;file3.c"

  # With tag for organized output
  $0 --files examples/c_programs/simple.c --tag experiment1

  # Custom measurement settings
  $0 --files examples/c_programs/simple.c \\
     --voltage 3.0 \\
     --max-current 0.02
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --files)
            FILES="$2"
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
if [[ -z "$FILES" ]]; then
    log_error "Missing required argument: --files"
    usage
    exit 1
fi

# Parse files into array
IFS=';' read -ra FILE_ARRAY <<< "$FILES"

# Check if files exist
for file in "${FILE_ARRAY[@]}"; do
    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        exit 1
    fi
done

# Setup temporary files and directories
mkdir -p "$TEMP_DIR"
mkdir -p "$BUILD_DIR"

# Create timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Determine report directory (single directory for all files)
if [[ -n "$TAG" ]]; then
    REPORT_DIR_FULL="${REPORT_DIR}/analyze_distribution/${TAG}"
else
    REPORT_DIR_FULL="${REPORT_DIR}/analyze_distribution/${TIMESTAMP}"
fi

mkdir -p "$REPORT_DIR_FULL"

# ============================================================
# MAIN PIPELINE
# ============================================================

log_step "ANALYZE DISTRIBUTION START"
log_info "Files: ${#FILE_ARRAY[@]}"
for file in "${FILE_ARRAY[@]}"; do
    log_info "  - $file"
done
log_info "Report directory: $REPORT_DIR_FULL"

cd "$PROJECT_ROOT"

# Array to store individual segments CSV files
SEGMENTS_CSV_ARRAY=()

# Step 1: Extract event labels from all files
log_step "Step 1: Extracting event labels from C source files"
EVENT_LABELS_ARRAY=()
for i in "${!FILE_ARRAY[@]}"; do
    FILE="${FILE_ARRAY[$i]}"
    BASENAME="$(basename "$FILE" .c)"

    EVENT_LABELS_JSON="$TEMP_DIR/labels_${BASENAME}_${TIMESTAMP}.json"

    log_info "Extracting labels from $FILE..."
    python3 "$EXTRACT_BENCH_LABELS_PY" \
        --input "$FILE" \
        --output "$EVENT_LABELS_JSON" \
        --format json

    EVENT_LABELS_ARRAY+=("$EVENT_LABELS_JSON")
done

# Combine all event labels into single JSON file
COMBINED_LABELS_JSON="$TEMP_DIR/combined_labels_${TIMESTAMP}.json"
log_info "Combining event labels from ${#EVENT_LABELS_ARRAY[@]} file(s)..."

# Use Python to combine JSON arrays
python3 -c "
import json
import sys

combined_labels = []
for label_file in sys.argv[1:-1]:
    try:
        with open(label_file, 'r') as f:
            labels = json.load(f)
            combined_labels.extend(labels)
    except Exception as e:
        print(f'Warning: Could not load {label_file}: {e}', file=sys.stderr)

with open(sys.argv[-1], 'w') as f:
    json.dump(combined_labels, f, indent=2)

print(f'Combined {len(combined_labels)} event labels')
" "${EVENT_LABELS_ARRAY[@]}" "$COMBINED_LABELS_JSON"

log_success "Event labels combined: $COMBINED_LABELS_JSON"

# Process each file
for i in "${!FILE_ARRAY[@]}"; do
    FILE="${FILE_ARRAY[$i]}"
    BASENAME="$(basename "$FILE" .c)"

    log_info ""
    log_info "Processing file $((i+1))/${#FILE_ARRAY[@]}: $FILE"

    # Setup file paths for this file
    TRAINING_RAW_CSV="$TEMP_DIR/raw_${BASENAME}_${TIMESTAMP}.csv"
    TRAINING_SEGMENTS_CSV="$TEMP_DIR/segments_${BASENAME}_${TIMESTAMP}.csv"
    EVENT_LABELS_JSON="${EVENT_LABELS_ARRAY[$i]}"

    # Step 2: Compile
    log_step "Step 2.$((i+1)): Compiling $FILE"
    log_info "Compiling with NUM_REPEAT=$NUM_REPEAT"
    $CC $CFLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${BASENAME}.elf" "$FILE"
    log_success "Compiled: $BUILD_DIR/${BASENAME}.elf"

    # Step 3: Flash
    log_step "Step 3.$((i+1)): Flashing binary to device"
    log_info "Flashing $BUILD_DIR/${BASENAME}.elf..."
    mspdebug tilib "prog $BUILD_DIR/${BASENAME}.elf" "exit"
    log_success "Flashed to device"

    # Step 4: Measure
    log_step "Step 4.$((i+1)): Measuring energy consumption"
    log_info "Voltage: $VOLTAGE V, Max current: $MAX_CURRENT A"
    python3 "$MEASURE_PY" \
        --voltage "$VOLTAGE" \
        --max_current "$MAX_CURRENT" \
        --outfile "$TRAINING_RAW_CSV" \
        $SKIP_RESET
    log_success "Raw measurement saved: $TRAINING_RAW_CSV"

    # Step 5: Preprocess
    log_step "Step 5.$((i+1)): Preprocessing measurements"
    python3 "$PREPROCESS_PY" \
        --input "$TRAINING_RAW_CSV" \
        --output "$TRAINING_SEGMENTS_CSV" \
        --event-labels "$EVENT_LABELS_JSON"
    log_success "Segments saved: $TRAINING_SEGMENTS_CSV"

    # Add to segments array
    SEGMENTS_CSV_ARRAY+=("$TRAINING_SEGMENTS_CSV")

    # Cleanup temporary raw CSV
    rm -f "$TRAINING_RAW_CSV"
    log_info "Cleaned up temporary file: $TRAINING_RAW_CSV"
done

# Step 6: Combine all segments into single CSV
log_step "Step 6: Combining segments from ${#FILE_ARRAY[@]} file(s)"
COMBINED_SEGMENTS_CSV="$REPORT_DIR_FULL/segments.csv"

if [[ ${#SEGMENTS_CSV_ARRAY[@]} -eq 1 ]]; then
    # Single file: just move it
    mv "${SEGMENTS_CSV_ARRAY[0]}" "$COMBINED_SEGMENTS_CSV"
    log_success "Segments saved: $COMBINED_SEGMENTS_CSV"
else
    # Multiple files: concatenate them
    # First file with header
    cat "${SEGMENTS_CSV_ARRAY[0]}" > "$COMBINED_SEGMENTS_CSV"

    # Remaining files without header
    for i in "${!SEGMENTS_CSV_ARRAY[@]}"; do
        if [[ $i -gt 0 ]]; then
            tail -n +2 "${SEGMENTS_CSV_ARRAY[$i]}" >> "$COMBINED_SEGMENTS_CSV"
        fi
    done

    log_success "Combined ${#SEGMENTS_CSV_ARRAY[@]} segment files into: $COMBINED_SEGMENTS_CSV"

    # Cleanup individual segment files
    for csv in "${SEGMENTS_CSV_ARRAY[@]}"; do
        rm -f "$csv"
    done
fi

# Calculate total number of events across all files
TOTAL_SEGMENTS=$(tail -n +2 "$COMBINED_SEGMENTS_CSV" | wc -l | tr -d ' ')
TOTAL_EVENTS=$((TOTAL_SEGMENTS / NUM_REPEAT))

log_info "Total segments: $TOTAL_SEGMENTS"
log_info "Total events: $TOTAL_EVENTS"

# Step 7: Generate distribution analysis report
log_step "Step 7: Generating combined distribution analysis report"

# Create a file list string for the report
FILE_LIST=""
for file in "${FILE_ARRAY[@]}"; do
    FILE_LIST="${FILE_LIST}${file}, "
done
FILE_LIST="${FILE_LIST%, }"  # Remove trailing comma and space

python3 "$GENERATE_REPORT_PY" \
    --segments-csv "$COMBINED_SEGMENTS_CSV" \
    --num-repeat "$NUM_REPEAT" \
    --report-dir "$REPORT_DIR_FULL" \
    --file-name "$FILE_LIST"
log_success "Distribution analysis report generated"

# Cleanup temporary label files
for label_file in "${EVENT_LABELS_ARRAY[@]}"; do
    rm -f "$label_file"
done
rm -f "$COMBINED_LABELS_JSON"

# Done
log_step "ANALYSIS COMPLETE"
log_success "All steps completed successfully!"
echo ""
log_info "Output files:"
echo "  - Report directory: $REPORT_DIR_FULL"
echo "  - Markdown Report: ${REPORT_DIR_FULL}/distribution_analysis.md"
echo "  - Segments CSV: $COMBINED_SEGMENTS_CSV"
echo "  - Summary CSV: ${REPORT_DIR_FULL}/distribution_summary.csv"
echo "  - Distribution plots: ${REPORT_DIR_FULL}/event_*_distribution.png"
echo ""
log_info "Files analyzed: ${#FILE_ARRAY[@]}"
for i in "${!FILE_ARRAY[@]}"; do
    echo "  $((i+1)). ${FILE_ARRAY[$i]}"
done
