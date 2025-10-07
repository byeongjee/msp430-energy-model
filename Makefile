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
INCLUDES := -I$(MSP430_INC_PATH) -I$(MEASUREMENT_INCLUDE_PATH)
LDFLAGS := -L$(MSP430_LD_PATH)

# Directories
SRC_DIR := examples/c_programs
BUILD_DIR := build
ASM_DIR := $(BUILD_DIR)/asm

# Default target
.PHONY: all clean help interpret train estimate test flash

all: help

help:
	@echo "MSP430 C to Assembly Pipeline"
	@echo "============================="
	@echo ""
	@echo "Available targets:"
	@echo "  compile FILE=<file.c>       - Compile C file to MSP430 binary"
	@echo "  disasm FILE=<file.c>        - Compile and disassemble"
	@echo "  interpret FILE=<file.c>     - Interpret assembly program"
	@echo "  train FILE=<file.c> DATA=<data.csv> - Train energy model"
	@echo "  estimate FILE=<file.c> PARAMS=<params> - Estimate energy consumption"
	@echo "  flash FILE=<file.c>         - Flash binary to microcontroller"
	@echo "  test                        - Run interpreter on all example programs"
	@echo "  clean                       - Clean build artifacts"
	@echo ""
	@echo "Examples:"
	@echo "  make compile FILE=examples/c_programs/simple.c"
	@echo "  make interpret FILE=examples/c_programs/simple.c"
	@echo "  make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv"
	@echo "  make estimate FILE=examples/c_programs/simple.c PARAMS=params.json"
	@echo "  make flash FILE=examples/c_programs/simple.c"
	@echo "  make test"

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
	julia --project=. src/main.jl interpret --asm $(ASM_DIR)/$$BASENAME.asm
	@echo "✓ Interpret completed!"

# Train mode: infer energy parameters from measurements
train: disasm
ifndef DATA
	$(error Please specify DATA=<measurement_file.csv>)
endif
	@echo "Training energy model..."
	@BASENAME=$$(basename $(FILE) .c); \
	OUTPUT=$${OUTPUT:-energy_params.json}; \
	julia --project=. src/main.jl train --asm $(ASM_DIR)/$$BASENAME.asm --data $(DATA) --output $$OUTPUT
	@echo "✓ Training completed!"

# Estimate mode: predict energy consumption
estimate: disasm
ifndef PARAMS
	$(error Please specify PARAMS=<parameter_file>)
endif
	@echo "Estimating energy consumption..."
	@BASENAME=$$(basename $(FILE) .c); \
	julia --project=. src/main.jl estimate --asm $(ASM_DIR)/$$BASENAME.asm --params $(PARAMS)
	@echo "✓ Estimation completed!"

# Test with example programs
test: $(SRC_DIR)
	@echo "Running interpreter on all example programs..."
	@for file in $(SRC_DIR)/*.c; do \
		echo ""; \
		echo "🔄 Processing $$file..."; \
		echo "=========================================="; \
		make interpret FILE=$$file || echo "❌ Failed: $$file"; \
		echo ""; \
	done
	@echo "✅ All tests completed!"

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