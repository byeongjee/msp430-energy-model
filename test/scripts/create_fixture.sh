#!/bin/bash
# create_fixture.sh - Create test fixture from C file
# Usage: ./create_fixture.sh <c_file> <test_name>
#
# This script:
# 1. Compiles the C file to MSP430 ELF binary
# 2. Disassembles the binary to assembly
# 3. Runs the binary in GDB simulator and captures register values
# 4. Saves everything as a JSON fixture

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <c_file> <test_name>"
    echo "Example: $0 examples/c_programs/simple.c simple"
    exit 1
fi

C_FILE="$1"
TEST_NAME="$2"

# Convert to absolute path if relative
if [[ "$C_FILE" != /* ]]; then
    C_FILE="$PROJECT_ROOT/$C_FILE"
fi

if [ ! -f "$C_FILE" ]; then
    echo "Error: C file not found: $C_FILE"
    exit 1
fi

echo "Creating test fixture for: $C_FILE"
echo "Test name: $TEST_NAME"
echo ""

# Directories
BUILD_DIR="$PROJECT_ROOT/build"
ASM_DIR="$BUILD_DIR/asm"
FIXTURE_DIR="$PROJECT_ROOT/test/fixtures"

# Ensure directories exist
mkdir -p "$BUILD_DIR"
mkdir -p "$ASM_DIR"
mkdir -p "$FIXTURE_DIR"

# MSP430 toolchain
MSPGCC_PATH="/Users/byeongjee/migration/msp430-gcc/bin"
MSP430_INC_PATH="/Users/byeongjee/ti/msp430-gcc/include"
MSP430_LD_PATH="/Users/byeongjee/ti/msp430-gcc/include"
MEASUREMENT_INCLUDE_PATH="$PROJECT_ROOT/include"

CC="$MSPGCC_PATH/msp430-elf-gcc"
OBJDUMP="$MSPGCC_PATH/msp430-elf-objdump"

DEVICE="MSP430FR5994"
CFLAGS="-mmcu=$DEVICE -O0 -g -Wall"
INCLUDES="-I$MSP430_INC_PATH -I$MEASUREMENT_INCLUDE_PATH"
LDFLAGS="-L$MSP430_LD_PATH"

# Output files
ELF_FILE="$BUILD_DIR/${TEST_NAME}.elf"
ASM_FILE="$ASM_DIR/${TEST_NAME}.asm"
GDB_RESULT_FILE="$BUILD_DIR/${TEST_NAME}_gdb.json"
FIXTURE_FILE="$FIXTURE_DIR/${TEST_NAME}.json"

echo "Step 1: Compiling C to MSP430 ELF..."
"$CC" $CFLAGS $INCLUDES $LDFLAGS -o "$ELF_FILE" "$C_FILE"
echo "✓ Compiled: $ELF_FILE"
echo ""

echo "Step 2: Disassembling to assembly..."
"$OBJDUMP" -d "$ELF_FILE" > "$ASM_FILE"
echo "✓ Disassembled: $ASM_FILE"
echo ""

echo "Step 3: Running in GDB simulator..."
"$SCRIPT_DIR/run_gdb.sh" "$ELF_FILE" "$GDB_RESULT_FILE"
echo "✓ GDB execution complete: $GDB_RESULT_FILE"
echo ""

echo "Step 4: Creating test fixture..."
# Create the fixture JSON by combining assembly path and GDB results
# Use relative paths from project root for portability
ASM_FILE_REL="build/asm/${TEST_NAME}.asm"

# Read GDB result JSON and embed it in fixture
GDB_RESULT=$(cat "$GDB_RESULT_FILE")

cat > "$FIXTURE_FILE" << EOF
{
  "test_name": "$TEST_NAME",
  "asm_file": "$ASM_FILE_REL",
  "gdb_result": $GDB_RESULT
}
EOF

echo "✓ Fixture created: $FIXTURE_FILE"
echo ""
echo "Test fixture created successfully!"
echo ""
echo "To run tests:"
echo "  julia --project=. test/runtests.jl"
