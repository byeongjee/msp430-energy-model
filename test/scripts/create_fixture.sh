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

# Source disassembly utility
source "$PROJECT_ROOT/scripts/disasm.sh"

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

# Check required environment variables
if [[ -z "${MSP430GCC_TOOLCHAIN_PATH}" ]]; then
    echo "Error: MSP430GCC_TOOLCHAIN_PATH is not set. Please set it in your environment or .env file"
    exit 1
fi
if [[ -z "${MSP430GCC_SUPPORT_PATH}" ]]; then
    echo "Error: MSP430GCC_SUPPORT_PATH is not set. Please set it in your environment or .env file"
    exit 1
fi

# MSP430 toolchain
MEASUREMENT_INCLUDE_PATH="$PROJECT_ROOT/include"

# Require toolchain/flags to be provided by the Makefile environment.
if [[ -z "${CC}" ]]; then
    echo "Error: CC is not set. Run via 'make create_fixture' so Makefile exports toolchain variables."
    exit 1
fi
if [[ -z "${OBJDUMP}" ]]; then
    echo "Error: OBJDUMP is not set. Run via 'make create_fixture' so Makefile exports toolchain variables."
    exit 1
fi
if [[ -z "${DEVICE}" ]]; then
    echo "Error: DEVICE is not set. Run via 'make create_fixture' so Makefile exports toolchain variables."
    exit 1
fi
if [[ -z "${CFLAGS}" ]]; then
    echo "Error: CFLAGS is not set. Run via 'make create_fixture' so Makefile exports toolchain variables."
    exit 1
fi
if [[ -z "${INCLUDES}" ]]; then
    echo "Error: INCLUDES is not set. Run via 'make create_fixture' so Makefile exports toolchain variables."
    exit 1
fi
if [[ -z "${LDFLAGS}" ]]; then
    echo "Error: LDFLAGS is not set. Run via 'make create_fixture' so Makefile exports toolchain variables."
    exit 1
fi

# Output files
ELF_FILE="$BUILD_DIR/${TEST_NAME}.elf"
ASM_FILE="$ASM_DIR/${TEST_NAME}.asm"
DATA_FILE="$ASM_DIR/${TEST_NAME}.data"
FIXTURE_ASM_FILE="$FIXTURE_DIR/${TEST_NAME}.asm"
FIXTURE_DATA_FILE="$FIXTURE_DIR/${TEST_NAME}.data"
GDB_RESULT_FILE="$BUILD_DIR/${TEST_NAME}_gdb.json"
FIXTURE_FILE="$FIXTURE_DIR/${TEST_NAME}.json"

echo "Step 1: Compiling C to MSP430 ELF..."
echo "         CC=$CC"
echo "    CFLAGS=$CFLAGS"
echo "  INCLUDES=$INCLUDES"
echo "   LDFLAGS=$LDFLAGS"
"$CC" $CFLAGS $INCLUDES $LDFLAGS -o "$ELF_FILE" "$C_FILE"
echo "✓ Compiled: $ELF_FILE"
echo ""

echo "Step 2: Disassembling to assembly and dumping data sections..."
disasm "$ELF_FILE" "$ASM_FILE" "$DATA_FILE"
echo "✓ Disassembled: $ASM_FILE"
echo "✓ Data dump: $DATA_FILE"
echo ""

echo "Step 3: Running in GDB simulator..."
"$SCRIPT_DIR/run_gdb.sh" "$ELF_FILE" "$GDB_RESULT_FILE" "$DATA_FILE"
echo "✓ GDB execution complete: $GDB_RESULT_FILE"
echo ""

echo "Step 4: Copying assembly to fixtures directory..."
cp "$ASM_FILE" "$FIXTURE_ASM_FILE"
echo "✓ Copied: $FIXTURE_ASM_FILE"
cp "$DATA_FILE" "$FIXTURE_DATA_FILE"
echo "✓ Copied: $FIXTURE_DATA_FILE"
echo ""

echo "Step 5: Creating test fixture JSON..."
# Create the fixture JSON by combining assembly path and GDB results
# Use relative path from project root for portability
ASM_FILE_REL="test/fixtures/${TEST_NAME}.asm"
DATA_FILE_REL="test/fixtures/${TEST_NAME}.data"

# Read GDB result JSON and embed it in fixture
GDB_RESULT=$(cat "$GDB_RESULT_FILE")

cat > "$FIXTURE_FILE" << EOF
{
  "test_name": "$TEST_NAME",
  "asm_file": "$ASM_FILE_REL",
  "data_file": "$DATA_FILE_REL",
  "gdb_result": $GDB_RESULT
}
EOF

echo "✓ Fixture created: $FIXTURE_FILE"
echo ""
echo "Test fixture created successfully!"
echo "  Assembly: $FIXTURE_ASM_FILE"
echo "  Fixture:  $FIXTURE_FILE"
echo ""
echo "To run tests:"
echo "  make test"
echo "  make test PATTERN=${TEST_NAME}"
