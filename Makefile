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

# Compiler flags
CFLAGS := -mmcu=$(DEVICE) -O0 -g -Wall
INCLUDES := -I$(MSP430_INC_PATH)
LDFLAGS := -L$(MSP430_LD_PATH)

# Directories
SRC_DIR := examples/c_programs
BUILD_DIR := build
ASM_DIR := $(BUILD_DIR)/asm

# Default target
.PHONY: all clean help pipeline test

all: help

help:
	@echo "MSP430 C to Assembly Pipeline"
	@echo "============================="
	@echo ""
	@echo "Available targets:"
	@echo "  compile FILE=<file.c>     - Compile C file to MSP430 binary"
	@echo "  disasm FILE=<file.c>      - Compile and disassemble"
	@echo "  pipeline FILE=<file.c>    - Run full pipeline (compile -> disasm -> execute)"
	@echo "  test                      - Run pipeline on all example programs"
	@echo "  clean                     - Clean build artifacts"
	@echo ""
	@echo "Examples:"
	@echo "  make compile FILE=examples/c_programs/simple.c"
	@echo "  make pipeline FILE=examples/c_programs/simple.c"
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

# Extract just the assembly instructions for Julia parsing
# This extracts instruction mnemonics from objdump output format:
# "    4010:	31 80 06 00 	sub	#6,	r1	;" -> "sub	#6,	r1"
# The pattern matches lines with hex addresses, then extracts everything after the hex bytes
extract-asm: disasm
	@echo "Extracting assembly instructions..."
	@BASENAME=$$(basename $(FILE) .c); \
	grep -E '^[[:space:]]*[0-9a-fA-F]+:.*\t[a-zA-Z]' $(ASM_DIR)/$$BASENAME.asm | \
	awk '{for(i=1;i<=NF;i++) if($$i ~ /^[a-zA-Z]/) {for(j=i;j<=NF && $$j !~ /^;/;j++) printf "%s ", $$j; print ""; break}}' | \
	sed 's/[[:space:]]*$$//' | \
	sed 's/^[0-9a-fA-F][0-9a-fA-F] [0-9a-fA-F][0-9a-fA-F] [0-9a-fA-F][0-9a-fA-F] [0-9a-fA-F][0-9a-fA-F] //' > $(ASM_DIR)/$$BASENAME.instructions
	@echo "✓ Instructions extracted to: $(ASM_DIR)/$$(basename $(FILE) .c).instructions"

# Run full pipeline
pipeline: disasm
	@echo "Running MSP430 execution and energy analysis..."
	@BASENAME=$$(basename $(FILE) .c); \
	julia examples/msp430_executor.jl $(ASM_DIR)/$$BASENAME.asm
	@echo "✓ Pipeline completed!"

# Test with example programs
test: $(SRC_DIR)
	@echo "Running pipeline on all example programs..."
	@for file in $(SRC_DIR)/*.c; do \
		echo ""; \
		echo "🔄 Processing $$file..."; \
		echo "=========================================="; \
		make pipeline FILE=$$file || echo "❌ Failed: $$file"; \
		echo ""; \
	done
	@echo "✅ All tests completed!"

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