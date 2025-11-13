# Makefile for C to MSP430 compilation and analysis pipeline

# MSP430 toolchain configuration
# Require environment variables to be set
ifndef MSP430GCC_TOOLCHAIN_PATH
$(error MSP430GCC_TOOLCHAIN_PATH is not set.)
endif
ifndef MSP430GCC_SUPPORT_PATH
$(error MSP430GCC_SUPPORT_PATH is not set.)
endif

CC := $(MSP430GCC_TOOLCHAIN_PATH)/bin/msp430-elf-gcc
OBJDUMP := $(MSP430GCC_TOOLCHAIN_PATH)/bin/msp430-elf-objdump
OBJCOPY := $(MSP430GCC_TOOLCHAIN_PATH)/bin/msp430-elf-objcopy

# Device configuration
DEVICE := MSP430FR5994

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
MEASUREMENT_INCLUDE_PATH := $(MKFILE_DIR)/include


# Compiler flags
CFLAGS := -mmcu=$(DEVICE) -O0 -g -Wall

# Process DEFINES variable: space-separated list of macros (e.g., DEFINES="FOO=1 BAR ENABLE_FEATURE=value")
# Each macro gets -D prefix automatically
ifdef DEFINES
DEFINE_FLAGS := $(addprefix -D,$(DEFINES))
else
DEFINE_FLAGS :=
endif

INCLUDES := -I$(MSP430GCC_SUPPORT_PATH)/include -I$(MEASUREMENT_INCLUDE_PATH)
LDFLAGS := -L$(MSP430GCC_SUPPORT_PATH)/include

# Directories
SRC_DIR := examples/c_programs
BUILD_DIR := build
ASM_DIR := $(BUILD_DIR)/asm
TEMP_DIR ?= ./tmp
REPORT_DIR ?= ./report
export TEMP_DIR
export REPORT_DIR

# Julia thread configuration
# Default: 'auto' uses all available cores (Julia 1.5+)
# Override with: make <target> JULIA_NUM_THREADS=4
JULIA_NUM_THREADS ?= auto
export JULIA_NUM_THREADS

# Default target
.PHONY: all clean help interpret train estimate test flash create_fixture train_and_estimate analyze_distribution

all: help

help: ## Show this help message
	@echo "MSP430 C to Assembly Pipeline"
	@echo "============================="
	@echo ""
	@echo "Configuration:"
	@echo "  JULIA_NUM_THREADS=$(JULIA_NUM_THREADS) (override with JULIA_NUM_THREADS=N)"
	@echo "  TEMP_DIR=$(TEMP_DIR) (override with TEMP_DIR=/path/to/tmp)"
	@echo "  REPORT_DIR=$(REPORT_DIR) (override with REPORT_DIR=/path/to/report)"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-30s %s\n", $$1, $$2}'

# Create directories
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(ASM_DIR): | $(BUILD_DIR)
	@mkdir -p $(ASM_DIR)

compile: | $(BUILD_DIR) ## Compile C file to MSP430 binary (FILE=<file.c> [DEFINES="MACRO1=val MACRO2..."])
ifndef FILE
	$(error Please specify FILE=<filename.c>)
endif
	@echo "Compiling $(FILE) for MSP430..."
	@BASENAME=$$(basename $(FILE) .c); \
	if [ -n "$(DEFINES)" ]; then \
		echo "  DEFINES=$(DEFINES)"; \
	fi; \
	$(CC) $(CFLAGS) $(DEFINE_FLAGS) $(INCLUDES) $(LDFLAGS) -o $(BUILD_DIR)/$$BASENAME.elf $(FILE)
	@echo "✓ Compilation successful: $(BUILD_DIR)/$$(basename $(FILE) .c).elf"

disasm: compile | $(ASM_DIR) ## Compile and disassemble (FILE=<file.c>)
	@echo "Disassembling binary..."
	@BASENAME=$$(basename $(FILE) .c); \
	$(OBJDUMP) -d $(BUILD_DIR)/$$BASENAME.elf > $(ASM_DIR)/$$BASENAME.asm
	@echo "✓ Disassembly saved to: $(ASM_DIR)/$$(basename $(FILE) .c).asm"


interpret: disasm ## Interpret assembly program (FILE=<file.c> [MAX_STEPS=<n>])
	@echo "Running MSP430 interpreter..."
	@BASENAME=$$(basename $(FILE) .c); \
	MAX_STEPS_FLAG=""; \
	if [ -n "$(MAX_STEPS)" ]; then MAX_STEPS_FLAG="--max-steps $(MAX_STEPS)"; fi; \
	julia --project=. src/main.jl interpret --asm $(ASM_DIR)/$$BASENAME.asm $$MAX_STEPS_FLAG
	@echo "✓ Interpret completed!"

train: MODEL?=mean_per_addressing_mode
train: INFERENCE?=dominant-key
train: ## Training pipeline: measure → preprocess → train (FILES=<pattern> [PARAMS=<output>] [TAG=<tag>] [DEFINES="..."] [options])
ifndef FILES
	$(error Please specify FILES=<pattern> (supports glob patterns: *.c, **/*.c, {a,b,c}.c))
endif
	@ARGS=("--train-files" "$(FILES)"); \
	[ -n "$(PARAMS)" ] && ARGS+=("--params" "$(PARAMS)"); \
	[ -n "$(TAG)" ] && ARGS+=("--tag" "$(TAG)"); \
	[ -n "$(TRAINING_RAW_CSV)" ] && ARGS+=("--training-raw-csv" "$(TRAINING_RAW_CSV)"); \
	[ -n "$(TRAINING_SEGMENTS_CSV)" ] && ARGS+=("--training-segments-csv" "$(TRAINING_SEGMENTS_CSV)"); \
	[ -n "$(VOLTAGE)" ] && ARGS+=("--voltage" "$(VOLTAGE)"); \
	[ -n "$(MAX_CURRENT)" ] && ARGS+=("--max-current" "$(MAX_CURRENT)"); \
	[ -n "$(MAX_STEPS)" ] && ARGS+=("--max-steps" "$(MAX_STEPS)"); \
	[ -n "$(N_SAMPLES)" ] && ARGS+=("--n-samples" "$(N_SAMPLES)"); \
	[ -n "$(MODEL)" ] && ARGS+=("--model" "$(MODEL)"); \
	[ -n "$(INFERENCE)" ] && ARGS+=("--inference" "$(INFERENCE)"); \
	[ -n "$(DEFINES)" ] && ARGS+=("--defines" "$(DEFINES)"); \
	[ "$(SKIP_RESET)" = "1" ] && ARGS+=("--skip-reset"); \
	[ "$(KEEP_INTERMEDIATES)" = "1" ] && ARGS+=("--keep-intermediates"); \
	./scripts/train.sh "$${ARGS[@]}"

estimate: disasm ## Estimate energy consumption (FILE=<file.c> PARAMS=<params> [PLOT=<file>] [MAX_STEPS=<n>] [DEFINES="..."])
ifndef PARAMS
	$(error Please specify PARAMS=<parameter_file>)
endif
	@echo "Estimating energy consumption..."
	@BASENAME=$$(basename $(FILE) .c); \
	PLOT_FLAG=""; \
	if [ -n "$(PLOT)" ]; then PLOT_FLAG="--plot $(PLOT)"; fi; \
	MAX_STEPS_FLAG=""; \
	if [ -n "$(MAX_STEPS)" ]; then MAX_STEPS_FLAG="--max-steps $(MAX_STEPS)"; fi; \
	julia --project=. src/main.jl estimate --asm $(ASM_DIR)/$$BASENAME.asm --params $(PARAMS) $$PLOT_FLAG $$MAX_STEPS_FLAG
	@echo "✓ Estimation completed!"

train_and_estimate: MODEL?=mean_per_addressing_mode
train_and_estimate: INFERENCE?=importance-sampling
train_and_estimate: ## Full pipeline: measure → train → estimate → compare (TRAIN_FILES=<pattern> ESTIMATE_FILE=<file> [TAG=<tag>] [TRAIN_DEFINES="..."] [ESTIMATE_DEFINES="..."] [options])
ifndef TRAIN_FILES
	$(error Please specify TRAIN_FILES=<pattern> (supports glob patterns: *.c, **/*.c, {a,b,c}.c))
endif
ifndef ESTIMATE_FILE
	$(error Please specify ESTIMATE_FILE=<file.c> for estimation)
endif
	@ARGS=("--train-files" "$(TRAIN_FILES)" "--estimate-file" "$(ESTIMATE_FILE)"); \
	[ -n "$(TAG)" ] && ARGS+=("--tag" "$(TAG)"); \
	[ -n "$(TRAINING_RAW_CSV)" ] && ARGS+=("--training-raw-csv" "$(TRAINING_RAW_CSV)"); \
	[ -n "$(TEST_RAW_CSV)" ] && ARGS+=("--test-raw-csv" "$(TEST_RAW_CSV)"); \
	[ -n "$(TRAINING_SEGMENTS_CSV)" ] && ARGS+=("--training-segments-csv" "$(TRAINING_SEGMENTS_CSV)"); \
	[ -n "$(TEST_SEGMENTS_CSV)" ] && ARGS+=("--test-segments-csv" "$(TEST_SEGMENTS_CSV)"); \
	[ -n "$(PARAMS)" ] && ARGS+=("--params" "$(PARAMS)"); \
	[ -n "$(VOLTAGE)" ] && ARGS+=("--voltage" "$(VOLTAGE)"); \
	[ -n "$(MAX_CURRENT)" ] && ARGS+=("--max-current" "$(MAX_CURRENT)"); \
	[ -n "$(MAX_STEPS)" ] && ARGS+=("--max-steps" "$(MAX_STEPS)"); \
	[ -n "$(N_SAMPLES)" ] && ARGS+=("--n-samples" "$(N_SAMPLES)"); \
	[ -n "$(MODEL)" ] && ARGS+=("--model" "$(MODEL)"); \
	[ -n "$(INFERENCE)" ] && ARGS+=("--inference" "$(INFERENCE)"); \
	[ -n "$(TRAIN_DEFINES)" ] && ARGS+=("--train-defines" "$(TRAIN_DEFINES)"); \
	[ -n "$(ESTIMATE_DEFINES)" ] && ARGS+=("--estimate-defines" "$(ESTIMATE_DEFINES)"); \
	[ "$(SKIP_RESET)" = "1" ] && ARGS+=("--skip-reset"); \
	[ "$(KEEP_INTERMEDIATES)" = "1" ] && ARGS+=("--keep-intermediates"); \
	./scripts/train_and_estimate.sh "$${ARGS[@]}"

analyze_distribution: ## Flash, measure, and analyze energy distribution per event (FILES=<pattern> [TAG=<tag>] [DEFINES="..."] [options])
ifndef FILES
	$(error Please specify FILES=<pattern> (supports glob patterns: *.c, **/*.c, {a,b,c}.c))
endif
	@ARGS=("--files" "$(FILES)"); \
	[ -n "$(TAG)" ] && ARGS+=("--tag" "$(TAG)"); \
	[ -n "$(VOLTAGE)" ] && ARGS+=("--voltage" "$(VOLTAGE)"); \
	[ -n "$(MAX_CURRENT)" ] && ARGS+=("--max-current" "$(MAX_CURRENT)"); \
	[ -n "$(REPORT_DIR)" ] && ARGS+=("--report-dir" "$(REPORT_DIR)"); \
	[ -n "$(DEFINES)" ] && ARGS+=("--defines" "$(DEFINES)"); \
	[ "$(SKIP_RESET)" = "1" ] && ARGS+=("--skip-reset"); \
	./scripts/analyze_distribution.sh "$${ARGS[@]}"

create_fixture: ## Create test fixture (FILE=<file.c> NAME=<name>)
ifndef FILE
	$(error Please specify FILE=<filename.c>)
endif
ifndef NAME
	$(error Please specify NAME=<test_name>)
endif
	@echo "Creating test fixture..."
	@./test/scripts/create_fixture.sh $(FILE) $(NAME)

test: ## Run Julia test suite ([PATTERN=<regex>])
	@echo "Running Julia test suite..."
	@if [ -n "$(PATTERN)" ]; then \
		julia --project=. test/runtests.jl "$(PATTERN)"; \
	else \
		julia --project=. test/runtests.jl; \
	fi

flash: compile ## Flash binary to microcontroller (FILE=<file.c> [DEFINES="..."])
ifndef FILE
	$(error Please specify FILE=<filename.c>)
endif
	@echo "Flashing binary to microcontroller..."
	@BASENAME=$$(basename $(FILE) .c); \
	mspdebug tilib "prog $(BUILD_DIR)/$$BASENAME.elf"
	@echo "✓ Flash completed!"

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Clean completed!"

info: ## Show build and toolchain information
	@echo "MSP430 Toolchain Information"
	@echo "============================"
	@echo "CC:           $(CC)"
	@echo "OBJDUMP:      $(OBJDUMP)"
	@echo "DEVICE:       $(DEVICE)"
	@echo "CFLAGS:       $(CFLAGS)"
	@echo "INCLUDES:     $(INCLUDES)"
	@echo "BUILD_DIR:    $(BUILD_DIR)"
	@echo "ASM_DIR:      $(ASM_DIR)"
	@echo ""
	@echo "Toolchain status:"
	@if [ -x "$(CC)" ]; then \
		echo "✓ MSP430 GCC found: $(CC)"; \
		$(CC) --version | head -1; \
	else \
		echo "❌ MSP430 GCC not found: $(CC)"; \
	fi
	@if [ -x "$(OBJDUMP)" ]; then \
		echo "✓ MSP430 OBJDUMP found: $(OBJDUMP)"; \
	else \
		echo "❌ MSP430 OBJDUMP not found: $(OBJDUMP)"; \
	fi