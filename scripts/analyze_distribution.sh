#!/usr/bin/env bash
# Analyze energy distribution: flash → measure → preprocess → analyze
# Usage: ./scripts/analyze_distribution.sh [options]
# Requires: bash 4.0+ (for mapfile)

# Setup script directory before sourcing common
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities and configuration
source "$SCRIPT_DIR/common.sh"

# Default values (using common defaults where applicable)
VOLTAGE="${VOLTAGE_DEFAULT}"
MAX_CURRENT="${MAX_CURRENT_DEFAULT}"
TEMP_DIR="${TEMP_DIR_DEFAULT}"
REPORT_DIR="${REPORT_DIR_DEFAULT}"
SKIP_RESET=""
NUM_REPEAT=10
TAG=""
DEFINES=""  # Space-separated list of compiler macros

# Required parameters (to be set via command line)
FILES=""  # Semicolon-separated list of files

# Additional script path specific to this script
GENERATE_REPORT_PY="$SCRIPT_DIR/generate_distribution_report.py"

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Analyze energy distribution: flash → measure → preprocess → analyze

Required arguments:
  --files PATTERN           C file(s) to analyze (supports glob patterns and brace expansion)

Optional arguments:
  --tag TAG                 Tag for naming output files (default: none)
  --voltage V               Voltage for measurement (default: 3.3)
  --max-current A           Max current for measurement (default: 0.01)
  --num-repeat N            NUM_REPEAT value for compilation (default: 10)
  --defines "MACROS"        Space-separated compiler macros (e.g., "FOO=1 BAR ENABLE_FEATURE=value")
  --report-dir DIR          Directory for report (default: ./report)
  --skip-reset              Skip device reset during measurement
  --help                    Show this help message

Examples:
  # Single file
  $0 --files examples/c_programs/simple.c

  # All .c files in a directory
  $0 --files "examples/c_programs/*.c"

  # Recursive glob (all .c files in subdirectories)
  $0 --files "examples/**/*.c"

  # Brace expansion (specific files)
  $0 --files "examples/c_programs/{file1,file2,file3}.c"

  # Brace expansion with directories
  $0 --files "examples/{crypto,math}/*.c" --tag multi_dir

  # With custom measurement settings
  $0 --files "examples/c_programs/*.c" \\
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
        --defines)
            DEFINES="$2"
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

# Parse files into array using pattern expansion
mapfile -t FILE_ARRAY < <(expand_file_input "$FILES")

# Check if any files were found
if [[ ${#FILE_ARRAY[@]} -eq 0 ]]; then
    log_error "No files found matching pattern: $FILES"
    exit 1
fi

log_info "Found ${#FILE_ARRAY[@]} file(s) from pattern: $FILES"

# Check if files exist (should always pass after expand_file_input)
for file in "${FILE_ARRAY[@]}"; do
    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        exit 1
    fi
done

# Process DEFINES variable
DEFINE_FLAGS=$(process_defines "$DEFINES")
if [[ -n "$DEFINES" ]]; then
    log_info "Using compiler defines: $DEFINES"
fi

# Setup temporary files and directories
mkdir -p "$TEMP_DIR"
mkdir -p "$BUILD_DIR"

# Create timestamp
TIMESTAMP=$(create_timestamp)

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
    $CC $CFLAGS $DEFINE_FLAGS -DNUM_REPEAT=$NUM_REPEAT $INCLUDES $LDFLAGS -o "$BUILD_DIR/${BASENAME}.elf" "$FILE"
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
