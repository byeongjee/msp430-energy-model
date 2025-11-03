# Makefile for C to MSP430 compilation and analysis pipeline

# MSP430 toolchain configuration
# Require environment variables to be set
ifndef MSP430GCC_TOOLCHAIN_PATH
$(error MSP430GCC_TOOLCHAIN_PATH is not set. Please set it in your environment or .env file)
endif
ifndef MSP430GCC_SUPPORT_PATH
$(error MSP430GCC_SUPPORT_PATH is not set. Please set it in your environment or .env file)
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
ifdef DEBUG
CFLAGS += -DDEBUG
endif
INCLUDES := -I$(MSP430GCC_SUPPORT_PATH)/include -I$(MEASUREMENT_INCLUDE_PATH)
LDFLAGS := -L$(MSP430GCC_SUPPORT_PATH)/include

# Directories
SRC_DIR := examples/c_programs
BUILD_DIR := build
ASM_DIR := $(BUILD_DIR)/asm
TEMP_DIR := ./tmp

# Julia thread configuration
# Default: 'auto' uses all available cores (Julia 1.5+)
# Override with: make <target> JULIA_NUM_THREADS=4
JULIA_NUM_THREADS ?= auto
export JULIA_NUM_THREADS

# Default target
.PHONY: all clean help interpret train estimate test flash create_fixture train_and_estimate analyze_distribution

all: help

help:
	@echo "MSP430 C to Assembly Pipeline"
	@echo "============================="
	@echo ""
	@echo "Configuration:"
	@echo "  JULIA_NUM_THREADS=$(JULIA_NUM_THREADS) (override with JULIA_NUM_THREADS=N)"
	@echo ""
	@echo "Available targets:"
	@echo "  compile FILE=<file.c> [DEBUG=1]       - Compile C file to MSP430 binary"
	@echo "  disasm FILE=<file.c>        - Compile and disassemble"
	@echo "  interpret FILE=<file.c> [MAX_STEPS=<n>] - Interpret assembly program"
	@echo "  train FILE=<file.c> DATA=<data.csv> [OUTPUT=<params>] [MAX_STEPS=<n>] [N_SAMPLES=<n>] [NUM_REPEAT=<n>] [INFERENCE=<alg>] [GRANULARITY=<gran>] - Train energy model"
	@echo "  estimate FILE=<file.c> PARAMS=<params> [PLOT=<file>] [MAX_STEPS=<n>] - Estimate energy consumption"
	@echo "  train_and_estimate TRAIN_FILES=<files> ESTIMATE_FILE=<file.c> [options] - Full pipeline: measure → train → estimate → compare"
	@echo "           TRAIN_FILES can be single or semicolon-separated: file.c or file1.c;file2.c;file3.c"
	@echo "           Optional: TAG=<tag> REPORT_DIR=<dir> TRAINING_RAW_CSV=<files> TEST_RAW_CSV=<file> TRAINING_SEGMENTS_CSV=<files> TEST_SEGMENTS_CSV=<file> PARAMS=<file>"
	@echo "                     VOLTAGE=<v> MAX_CURRENT=<a> MAX_STEPS=<n> N_SAMPLES=<n> NUM_REPEAT=<n> GRANULARITY=<gran> SKIP_RESET=1 KEEP_INTERMEDIATES=1"
	@echo "                     INFERENCE=<alg> (importance-sampling, mcmc-hmc, mcmc-blocked)"
	@echo "  analyze_distribution FILE=<file.c> [TAG=<tag>] [REPORT_DIR=<dir>] [VOLTAGE=<v>] [MAX_CURRENT=<a>] [NUM_REPEAT=<n>] [SKIP_RESET=1] - Flash, measure, and analyze energy distribution per event"
	@echo "  flash FILE=<file.c> [DEBUG=1]         - Flash binary to microcontroller"
	@echo "  create_fixture FILE=<file.c> NAME=<name> - Create test fixture (compile, run in GDB, save results)"
	@echo "  test [PATTERN=<regex>]      - Run Julia test suite (compare interpreter vs GDB)"
	@echo "  clean                       - Clean build artifacts"
	@echo ""
	@echo "Examples:"
	@echo "  make compile FILE=examples/c_programs/simple.c"
	@echo "  make compile FILE=examples/c_programs/simple.c DEBUG=1"
	@echo "  make interpret FILE=examples/c_programs/simple.c"
	@echo "  make interpret FILE=examples/c_programs/simple.c MAX_STEPS=1000"
	@echo "  make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv"
	@echo "  make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv OUTPUT=my_params.json MAX_STEPS=500 N_SAMPLES=200"
	@echo "  make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv INFERENCE=mcmc-hmc"
	@echo "  make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv INFERENCE=mcmc-blocked"
	@echo "  make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv INFERENCE=importance-sampling GRANULARITY=addressing_mode"
	@echo "  make estimate FILE=examples/c_programs/simple.c PARAMS=energy_params.json"
	@echo "  make estimate FILE=examples/c_programs/simple.c PARAMS=energy_params.json PLOT=cost_dist.png"
	@echo "  make train_and_estimate TRAIN_FILES=examples/c_programs/simple.c ESTIMATE_FILE=examples/c_programs/test.c"
	@echo "  make train_and_estimate TRAIN_FILES=\"file1.c;file2.c;file3.c\" ESTIMATE_FILE=test.c TAG=multi_train"
	@echo "  make train_and_estimate TRAIN_FILES=examples/c_programs/simple.c ESTIMATE_FILE=examples/c_programs/test.c TAG=experiment1 KEEP_INTERMEDIATES=1"
	@echo "  make train_and_estimate TRAIN_FILES=examples/c_programs/simple.c ESTIMATE_FILE=examples/c_programs/test.c TRAINING_RAW_CSV=train.csv TEST_RAW_CSV=estimate.csv  # Resume without hardware"
	@echo "  make analyze_distribution FILE=examples/c_programs/simple.c"
	@echo "  make analyze_distribution FILE=examples/c_programs/simple.c TAG=experiment1 NUM_REPEAT=20"
	@echo "  make estimate FILE=examples/c_programs/simple.c PARAMS=energy_params.json JULIA_NUM_THREADS=4  # Use 4 threads"
	@echo "  make flash FILE=examples/c_programs/simple.c"
	@echo "  make flash FILE=examples/c_programs/simple.c DEBUG=1"
	@echo "  make create_fixture FILE=examples/c_programs/simple.c NAME=simple"
	@echo "  make test"
	@echo "  make test PATTERN=simple"
	@echo "  make test PATTERN='arith.*'"

# Create directories
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(ASM_DIR): | $(BUILD_DIR)
	@mkdir -p $(ASM_DIR)

# Compile C to MSP430 binary
compile: | $(BUILD_DIR)
ifndef FILE
	$(error Please specify FILE=<filename.c>)
endif
	@echo "Compiling $(FILE) for MSP430..."
	@BASENAME=$$(basename $(FILE) .c); \
	NUM_REPEAT_FLAG=""; \
	if [ -n "$(NUM_REPEAT)" ]; then \
		NUM_REPEAT_FLAG="-DNUM_REPEAT=$(NUM_REPEAT)"; \
		echo "  NUM_REPEAT=$(NUM_REPEAT)"; \
	fi; \
	$(CC) $(CFLAGS) $$NUM_REPEAT_FLAG $(INCLUDES) $(LDFLAGS) -o $(BUILD_DIR)/$$BASENAME.elf $(FILE)
	@echo "✓ Compilation successful: $(BUILD_DIR)/$$(basename $(FILE) .c).elf"

# Disassemble binary
disasm: compile | $(ASM_DIR)
	@echo "Disassembling binary..."
	@BASENAME=$$(basename $(FILE) .c); \
	$(OBJDUMP) -d $(BUILD_DIR)/$$BASENAME.elf > $(ASM_DIR)/$$BASENAME.asm
	@echo "✓ Disassembly saved to: $(ASM_DIR)/$$(basename $(FILE) .c).asm"


# Interpret mode: run interpreter on assembly
interpret: disasm
	@echo "Running MSP430 interpreter..."
	@BASENAME=$$(basename $(FILE) .c); \
	MAX_STEPS_FLAG=""; \
	if [ -n "$(MAX_STEPS)" ]; then MAX_STEPS_FLAG="--max-steps $(MAX_STEPS)"; fi; \
	julia --project=. src/main.jl interpret --asm $(ASM_DIR)/$$BASENAME.asm $$MAX_STEPS_FLAG
	@echo "✓ Interpret completed!"

# Train mode: infer energy parameters from measurements
train: NUM_REPEAT?=10
train: GRANULARITY?=opcode
train: INFERENCE?=importance-sampling
train: | $(BUILD_DIR) $(ASM_DIR)
ifndef FILES
	$(error Please specify FILES=file1.c;file2.c;... (semicolon-separated))
endif
ifndef DATA
	$(error Please specify DATA=data1.csv;data2.csv;... (semicolon-separated))
endif
	@echo "Compiling and disassembling files..."
	@IFS=';' read -ra FILE_ARRAY <<< "$(FILES)"; \
	for file in "$${FILE_ARRAY[@]}"; do \
		echo "  Processing $$file..."; \
		BASENAME=$$(basename $$file .c); \
		NUM_REPEAT_FLAG=""; \
		if [ -n "$(NUM_REPEAT)" ]; then \
			NUM_REPEAT_FLAG="-DNUM_REPEAT=$(NUM_REPEAT)"; \
		fi; \
		$(CC) $(CFLAGS) $$NUM_REPEAT_FLAG $(INCLUDES) $(LDFLAGS) -o $(BUILD_DIR)/$$BASENAME.elf $$file; \
		$(OBJDUMP) -d $(BUILD_DIR)/$$BASENAME.elf > $(ASM_DIR)/$$BASENAME.asm; \
		echo "  ✓ Compiled and disassembled $$BASENAME"; \
	done
	@echo "Training energy model..."
	@IFS=';' read -ra FILE_ARRAY <<< "$(FILES)"; \
	IFS=';' read -ra DATA_ARRAY <<< "$(DATA)"; \
	if [ $${#FILE_ARRAY[@]} -ne $${#DATA_ARRAY[@]} ]; then \
		echo "Error: Number of FILES ($${#FILE_ARRAY[@]}) must match number of DATA files ($${#DATA_ARRAY[@]})"; \
		exit 1; \
	fi; \
	ASM_FILES=(); \
	DATA_FILES=(); \
	for i in "$${!FILE_ARRAY[@]}"; do \
		BASENAME=$$(basename "$${FILE_ARRAY[$$i]}" .c); \
		ASM_FILES+=("$(ASM_DIR)/$$BASENAME.asm"); \
		DATA_FILES+=("$${DATA_ARRAY[$$i]}"); \
	done; \
	OUTPUT=$${OUTPUT:-energy_params.json}; \
	MAX_STEPS_FLAG=""; \
	if [ -n "$(MAX_STEPS)" ]; then MAX_STEPS_FLAG="--max-steps $(MAX_STEPS)"; fi; \
	N_SAMPLES_FLAG=""; \
	if [ -n "$(N_SAMPLES)" ]; then N_SAMPLES_FLAG="--n-samples $(N_SAMPLES)"; fi; \
	GRANULARITY_FLAG="--granularity $(GRANULARITY)"; \
	INFERENCE_FLAG="--inference $(INFERENCE)"; \
	julia --project=. src/main.jl train --asm "$${ASM_FILES[@]}" --data "$${DATA_FILES[@]}" --output $$OUTPUT $$MAX_STEPS_FLAG $$N_SAMPLES_FLAG $$GRANULARITY_FLAG $$INFERENCE_FLAG
	@echo "✓ Training completed!"

# Estimate mode: predict energy consumption
estimate: NUM_REPEAT=1
estimate: disasm
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

# Pipeline mode: measure train → measure estimate → preprocess both → train → estimate → compare (full hardware-in-the-loop)
train_and_estimate: GRANULARITY?=opcode
train_and_estimate: INFERENCE?=importance-sampling
train_and_estimate:
ifndef TRAIN_FILES
	$(error Please specify TRAIN_FILES=<file.c> or TRAIN_FILES=<file1.c>;<file2.c>;... (semicolon-separated))
endif
ifndef ESTIMATE_FILE
	$(error Please specify ESTIMATE_FILE=<file.c> for estimation)
endif
	@ARGS="--train-files $(TRAIN_FILES) --estimate-file $(ESTIMATE_FILE)"; \
	if [ -n "$(TAG)" ]; then ARGS="$$ARGS --tag $(TAG)"; fi; \
	if [ -n "$(TRAINING_RAW_CSV)" ]; then ARGS="$$ARGS --training-raw-csv $(TRAINING_RAW_CSV)"; fi; \
	if [ -n "$(TEST_RAW_CSV)" ]; then ARGS="$$ARGS --test-raw-csv $(TEST_RAW_CSV)"; fi; \
	if [ -n "$(TRAINING_SEGMENTS_CSV)" ]; then ARGS="$$ARGS --training-segments-csv $(TRAINING_SEGMENTS_CSV)"; fi; \
	if [ -n "$(TEST_SEGMENTS_CSV)" ]; then ARGS="$$ARGS --test-segments-csv $(TEST_SEGMENTS_CSV)"; fi; \
	if [ -n "$(PARAMS)" ]; then ARGS="$$ARGS --params $(PARAMS)"; fi; \
	if [ -n "$(VOLTAGE)" ]; then ARGS="$$ARGS --voltage $(VOLTAGE)"; fi; \
	if [ -n "$(MAX_CURRENT)" ]; then ARGS="$$ARGS --max-current $(MAX_CURRENT)"; fi; \
	if [ -n "$(MAX_STEPS)" ]; then ARGS="$$ARGS --max-steps $(MAX_STEPS)"; fi; \
	if [ -n "$(N_SAMPLES)" ]; then ARGS="$$ARGS --n-samples $(N_SAMPLES)"; fi; \
	if [ -n "$(NUM_REPEAT)" ]; then ARGS="$$ARGS --num-repeat $(NUM_REPEAT)"; fi; \
	if [ -n "$(GRANULARITY)" ]; then ARGS="$$ARGS --granularity $(GRANULARITY)"; fi; \
	if [ -n "$(INFERENCE)" ]; then ARGS="$$ARGS --inference $(INFERENCE)"; fi; \
	if [ "$(SKIP_RESET)" = "1" ]; then ARGS="$$ARGS --skip-reset"; fi; \
	if [ "$(KEEP_INTERMEDIATES)" = "1" ]; then ARGS="$$ARGS --keep-intermediates"; fi; \
	./scripts/train_and_estimate.sh $$ARGS

# Analyze distribution mode: flash → measure → preprocess → analyze
analyze_distribution:
ifndef FILE
	$(error Please specify FILE=<file.c>)
endif
	@ARGS="--file $(FILE)"; \
	if [ -n "$(TAG)" ]; then ARGS="$$ARGS --tag $(TAG)"; fi; \
	if [ -n "$(VOLTAGE)" ]; then ARGS="$$ARGS --voltage $(VOLTAGE)"; fi; \
	if [ -n "$(MAX_CURRENT)" ]; then ARGS="$$ARGS --max-current $(MAX_CURRENT)"; fi; \
	if [ -n "$(NUM_REPEAT)" ]; then ARGS="$$ARGS --num-repeat $(NUM_REPEAT)"; fi; \
	if [ -n "$(REPORT_DIR)" ]; then ARGS="$$ARGS --report-dir $(REPORT_DIR)"; fi; \
	if [ "$(SKIP_RESET)" = "1" ]; then ARGS="$$ARGS --skip-reset"; fi; \
	./scripts/analyze_distribution.sh $$ARGS

# Create test fixture
create_fixture:
ifndef FILE
	$(error Please specify FILE=<filename.c>)
endif
ifndef NAME
	$(error Please specify NAME=<test_name>)
endif
	@echo "Creating test fixture..."
	@./test/scripts/create_fixture.sh $(FILE) $(NAME)

# Run Julia test suite
# Optional: make test PATTERN=<regex> to filter tests
test:
	@echo "Running Julia test suite..."
	@if [ -n "$(PATTERN)" ]; then \
		julia --project=. test/runtests.jl "$(PATTERN)"; \
	else \
		julia --project=. test/runtests.jl; \
	fi

# Flash binary to microcontroller
flash: compile
ifndef FILE
	$(error Please specify FILE=<filename.c>)
endif
	@echo "Flashing binary to microcontroller..."
	@BASENAME=$$(basename $(FILE) .c); \
	mspdebug tilib "prog $(BUILD_DIR)/$$BASENAME.elf"
	@echo "✓ Flash completed!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Clean completed!"

# Show build information
info:
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