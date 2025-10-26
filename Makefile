# Makefile for C to MSP430 compilation and analysis pipeline

# MSP430 toolchain configuration
MSPGCC_PATH := /Users/byeongjee/migration/msp430-gcc/bin
MSP430_INC_PATH := /Users/byeongjee/ti/msp430-gcc/include
MSP430_LD_PATH := /Users/byeongjee/ti/msp430-gcc/include

CC := $(MSPGCC_PATH)/msp430-elf-gcc
OBJDUMP := $(MSPGCC_PATH)/msp430-elf-objdump
OBJCOPY := $(MSPGCC_PATH)/msp430-elf-objcopy

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
INCLUDES := -I$(MSP430_INC_PATH) -I$(MEASUREMENT_INCLUDE_PATH)
LDFLAGS := -L$(MSP430_LD_PATH)

# Directories
SRC_DIR := examples/c_programs
BUILD_DIR := build
ASM_DIR := $(BUILD_DIR)/asm
TEMP_DIR := ./tmp

# Default target
.PHONY: all clean help interpret train estimate visualize test flash create_fixture pipeline

all: help

help:
	@echo "MSP430 C to Assembly Pipeline"
	@echo "============================="
	@echo ""
	@echo "Available targets:"
	@echo "  compile FILE=<file.c> [DEBUG=1]       - Compile C file to MSP430 binary"
	@echo "  disasm FILE=<file.c>        - Compile and disassemble"
	@echo "  interpret FILE=<file.c> [MAX_STEPS=<n>] - Interpret assembly program"
	@echo "  train FILE=<file.c> DATA=<data.csv> [OUTPUT=<params>] [MAX_STEPS=<n>] [N_SAMPLES=<n>] - Train energy model"
	@echo "  estimate FILE=<file.c> PARAMS=<params> [PLOT=<file>] [MAX_STEPS=<n>] - Estimate energy consumption"
	@echo "  pipeline TRAIN_FILE=<file.c> ESTIMATE_FILE=<file.c> PLOT=<file> [options] - Full pipeline: measure → train → estimate"
	@echo "           Optional: RAW_CSV=<file> SEGMENTS_CSV=<file> PARAMS=<file> VOLTAGE=<v> MAX_CURRENT=<a> MAX_STEPS=<n> N_SAMPLES=<n> SKIP_RESET=1"
	@echo "  visualize PARAMS=<params> [OUTPUT=<file>] - Visualize instruction energy distributions"
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
	@echo "  make estimate FILE=examples/c_programs/simple.c PARAMS=energy_params.json"
	@echo "  make estimate FILE=examples/c_programs/simple.c PARAMS=energy_params.json PLOT=cost_dist.png"
	@echo "  make pipeline TRAIN_FILE=examples/c_programs/simple.c ESTIMATE_FILE=examples/c_programs/test.c PLOT=result.png"
	@echo "  make pipeline TRAIN_FILE=examples/c_programs/simple.c ESTIMATE_FILE=examples/c_programs/test.c PLOT=result.png PARAMS=my_params.json RAW_CSV=measurement.csv"
	@echo "  make visualize PARAMS=energy_params.json"
	@echo "  make visualize PARAMS=energy_params.json OUTPUT=instruction_distributions.png"
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
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(BUILD_DIR)/$$BASENAME.elf $(FILE)
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
train: disasm
ifndef DATA
	$(error Please specify DATA=<measurement_file.csv>)
endif
	@echo "Training energy model..."
	@BASENAME=$$(basename $(FILE) .c); \
	OUTPUT=$${OUTPUT:-energy_params.json}; \
	MAX_STEPS_FLAG=""; \
	if [ -n "$(MAX_STEPS)" ]; then MAX_STEPS_FLAG="--max-steps $(MAX_STEPS)"; fi; \
	N_SAMPLES_FLAG=""; \
	if [ -n "$(N_SAMPLES)" ]; then N_SAMPLES_FLAG="--n-samples $(N_SAMPLES)"; fi; \
	julia --project=. src/main.jl train --asm $(ASM_DIR)/$$BASENAME.asm --data $(DATA) --output $$OUTPUT $$MAX_STEPS_FLAG $$N_SAMPLES_FLAG
	@echo "✓ Training completed!"

# Estimate mode: predict energy consumption
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

# Pipeline mode: measure → preprocess → train → estimate (full hardware-in-the-loop)
pipeline:
ifndef TRAIN_FILE
	$(error Please specify TRAIN_FILE=<file.c> for training)
endif
ifndef ESTIMATE_FILE
	$(error Please specify ESTIMATE_FILE=<file.c> for estimation)
endif
ifndef PLOT
	$(error Please specify PLOT=<output_plot_file>)
endif
	@ARGS="--train-file $(TRAIN_FILE) --estimate-file $(ESTIMATE_FILE) --plot $(PLOT)"; \
	if [ -n "$(RAW_CSV)" ]; then ARGS="$$ARGS --raw-csv $(RAW_CSV)"; fi; \
	if [ -n "$(SEGMENTS_CSV)" ]; then ARGS="$$ARGS --segments-csv $(SEGMENTS_CSV)"; fi; \
	if [ -n "$(PARAMS)" ]; then ARGS="$$ARGS --params $(PARAMS)"; fi; \
	if [ -n "$(VOLTAGE)" ]; then ARGS="$$ARGS --voltage $(VOLTAGE)"; fi; \
	if [ -n "$(MAX_CURRENT)" ]; then ARGS="$$ARGS --max-current $(MAX_CURRENT)"; fi; \
	if [ -n "$(MAX_STEPS)" ]; then ARGS="$$ARGS --max-steps $(MAX_STEPS)"; fi; \
	if [ -n "$(N_SAMPLES)" ]; then ARGS="$$ARGS --n-samples $(N_SAMPLES)"; fi; \
	if [ "$(SKIP_RESET)" = "1" ]; then ARGS="$$ARGS --skip-reset"; fi; \
	./scripts/pipeline.sh $$ARGS

# Visualize mode: visualize instruction energy distributions
visualize:
ifndef PARAMS
	$(error Please specify PARAMS=<parameter_file>)
endif
	@echo "Visualizing instruction energy distributions..."
	@OUTPUT_FLAG=""; \
	if [ -n "$(OUTPUT)" ]; then OUTPUT_FLAG="--output $(OUTPUT)"; fi; \
	julia --project=. src/main.jl visualize --params $(PARAMS) $$OUTPUT_FLAG
	@echo "✓ Visualization completed!"

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