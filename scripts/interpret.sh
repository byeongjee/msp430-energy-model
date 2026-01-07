#!/usr/bin/env bash
# Interpret MSP430 assembly program
# Usage: ./scripts/interpret.sh --asm FILE.asm --data FILE.data [options]

# Setup script directory before sourcing common
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities and configuration
source "$SCRIPT_DIR/common.sh"

# Default values
MAX_STEPS=""
GRANULARITY=""
MODEL=""

# Required parameters
ASM_FILE=""
DATA_FILE=""

usage() {
    cat << EOF
Usage: $0 --asm FILE.asm --data FILE.data [OPTIONS]

Interpret MSP430 assembly program and list required energy model parameters.

Required arguments:
  --asm FILE              Assembly file (.asm from objdump)
  --data FILE             Data dump file (.data from objdump)

Optional arguments:
  --max-steps N           Maximum execution steps
  --granularity GRAN      Granularity level (mapped to model name)
                          Values: opcode, addressing_mode, addressing_mode_constant,
                                  addressing_mode_with_mem_access,
                                  addressing_mode_constant_with_mem_access,
                                  opcode_pair, addressing_mode_pair,
                                  addressing_mode_constant_pair
  --model MODEL           Model name (overrides granularity if both specified)
  --help                  Show this help message

Examples:
  $0 --asm build/asm/simple.asm --data build/asm/simple.data
  $0 --asm build/asm/simple.asm --data build/asm/simple.data --granularity addressing_mode
  $0 --asm build/asm/simple.asm --data build/asm/simple.data --max-steps 1000
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --asm)
            ASM_FILE="$2"
            shift 2
            ;;
        --data)
            DATA_FILE="$2"
            shift 2
            ;;
        --max-steps)
            MAX_STEPS="$2"
            shift 2
            ;;
        --granularity)
            GRANULARITY="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
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
if [[ -z "$ASM_FILE" ]]; then
    log_error "Missing required argument: --asm"
    usage
    exit 1
fi

if [[ -z "$DATA_FILE" ]]; then
    log_error "Missing required argument: --data"
    usage
    exit 1
fi

if [[ ! -f "$ASM_FILE" ]]; then
    log_error "Assembly file not found: $ASM_FILE"
    exit 1
fi

if [[ ! -f "$DATA_FILE" ]]; then
    log_error "Data file not found: $DATA_FILE"
    exit 1
fi

# Build command line flags
MAX_STEPS_FLAG=""
if [[ -n "$MAX_STEPS" ]]; then
    MAX_STEPS_FLAG="--max-steps $MAX_STEPS"
fi

DATA_DUMP_FLAG="--data-dump $DATA_FILE"

MODEL_FLAG=""
if [[ -n "$GRANULARITY" ]]; then
    # Map granularity to model name using shared function
    MODEL_NAME=$(granularity_to_model "$GRANULARITY") || exit 1
    MODEL_FLAG="--model $MODEL_NAME"
elif [[ -n "$MODEL" ]]; then
    MODEL_FLAG="--model $MODEL"
fi

# Run interpreter
log_info "Running MSP430 interpreter..."
julia --project="$PROJECT_ROOT" "$PROJECT_ROOT/src/main.jl" interpret \
    --asm "$ASM_FILE" \
    $MAX_STEPS_FLAG \
    $DATA_DUMP_FLAG \
    $MODEL_FLAG

log_success "Interpret completed!"
