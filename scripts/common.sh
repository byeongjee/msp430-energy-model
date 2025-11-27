#!/usr/bin/env bash
# Common utilities and configuration for MSP430 measurement scripts
# This file is sourced by other scripts and should not be executed directly

# Ensure script fails on errors
set -euo pipefail

# ============================================================
# COLOR DEFINITIONS
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================
# HELPER FUNCTIONS
# ============================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

log_step() {
    echo ""
    echo -e "${YELLOW}======================================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${YELLOW}======================================${NC}"
}

# ============================================================
# SCRIPT DIRECTORY AND PATHS
# ============================================================

# Determine script directory (must be set by calling script before sourcing)
if [[ -z "${SCRIPT_DIR:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Python script paths
MEASURE_PY="$SCRIPT_DIR/measure.py"
PREPROCESS_PY="$SCRIPT_DIR/preprocess.py"
EXTRACT_BENCH_LABELS_PY="$SCRIPT_DIR/extract_bench_labels.py"

# ============================================================
# ENVIRONMENT VARIABLE VALIDATION
# ============================================================

check_environment() {
    if [[ -z "${MSP430GCC_TOOLCHAIN_PATH:-}" ]]; then
        log_error "MSP430GCC_TOOLCHAIN_PATH is not set. Please set it in your environment or .env file"
        exit 1
    fi
    if [[ -z "${MSP430GCC_SUPPORT_PATH:-}" ]]; then
        log_error "MSP430GCC_SUPPORT_PATH is not set. Please set it in your environment or .env file"
        exit 1
    fi
}

# ============================================================
# TOOLCHAIN CONFIGURATION
# ============================================================

setup_toolchain() {
    # Require Makefile to export these; fail fast if missing
    : "${CC:?CC not set (export from Makefile)}"
    : "${OBJDUMP:?OBJDUMP not set (export from Makefile)}"
    : "${OBJCOPY:?OBJCOPY not set (export from Makefile)}"
    : "${DEVICE:?DEVICE not set (export from Makefile)}"
    : "${CFLAGS:?CFLAGS not set (export from Makefile)}"
    : "${INCLUDES:?INCLUDES not set (export from Makefile)}"
    : "${LDFLAGS:?LDFLAGS not set (export from Makefile)}"

    # Directories
    : "${BUILD_DIR:?BUILD_DIR not set (export from Makefile)}"
    : "${ASM_DIR:?ASM_DIR not set (export from Makefile)}"
}

# ============================================================
# DEFINES PROCESSING
# ============================================================

# Process DEFINES variable: space-separated list of macros
# Usage: process_defines "FOO=1 BAR ENABLE_FEATURE=value"
# Returns: "-DFOO=1 -DBAR -DENABLE_FEATURE=value"
process_defines() {
    local defines_str="$1"
    local result=""

    if [[ -z "$defines_str" ]]; then
        echo ""
        return
    fi

    # Split on spaces and add -D prefix to each
    for define in $defines_str; do
        result="$result -D$define"
    done

    echo "$result"
}

# Extract a define value from a space-separated list of macros
# Usage: extract_define "FOO=1 BAR NUM_REPEAT=100" "NUM_REPEAT"
# Returns: "100" (or empty string if not found)
extract_define() {
    local defines_str="$1"
    local define_name="$2"
    local result=""

    if [[ -z "$defines_str" ]]; then
        echo ""
        return
    fi

    # Search for the define in the list
    for define in $defines_str; do
        if [[ "$define" =~ ^${define_name}=(.+)$ ]]; then
            result="${BASH_REMATCH[1]}"
            break
        fi
    done

    echo "$result"
}

# Override a define value in a space-separated list of macros
# Usage: override_define "FOO=1 BAR NUM_REPEAT=100" "NUM_REPEAT" "1"
# Returns: "FOO=1 BAR NUM_REPEAT=1" (replaces existing value or adds if not present)
override_define() {
    local defines_str="$1"
    local define_name="$2"
    local new_value="$3"
    local result=""
    local found=0

    # Process each define
    for define in $defines_str; do
        if [[ "$define" =~ ^${define_name}=(.+)$ ]]; then
            # Found the define, replace it
            result="$result ${define_name}=${new_value}"
            found=1
        else
            # Keep other defines as-is
            result="$result $define"
        fi
    done

    # If the define wasn't found, add it
    if [[ $found -eq 0 ]]; then
        result="$result ${define_name}=${new_value}"
    fi

    # Trim leading/trailing spaces
    echo "$result" | xargs
}

# ============================================================
# DEFAULT VALUES
# ============================================================

# Measurement defaults
VOLTAGE_DEFAULT=3.3
MAX_CURRENT_DEFAULT=0.01

# Directory defaults
TEMP_DIR_DEFAULT="./tmp"
REPORT_DIR_DEFAULT="./report"

# ============================================================
# UTILITY FUNCTIONS
# ============================================================

# Create timestamp for file naming
create_timestamp() {
    date +"%Y%m%d_%H%M%S"
}

# Source file expansion utilities
source_file_expansion() {
    source "$SCRIPT_DIR/file_expansion_utils.sh"
}

# ============================================================
# INITIALIZATION
# ============================================================

# Auto-initialize when sourced (can be disabled by setting SKIP_AUTO_INIT=1)
if [[ -z "${SKIP_AUTO_INIT:-}" ]]; then
    check_environment
    setup_toolchain
    source_file_expansion
fi
