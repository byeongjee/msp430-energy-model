#!/bin/bash
# run_gdb.sh - Run MSP430 ELF binary in GDB simulator and extract register values as JSON
# Usage: ./run_gdb.sh <elf_file> <output_json>

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <elf_file> <output_json>"
    echo "Example: $0 build/simple.elf output.json"
    exit 1
fi

ELF_FILE="$1"
OUTPUT_JSON="$2"

if [ ! -f "$ELF_FILE" ]; then
    echo "Error: ELF file not found: $ELF_FILE"
    exit 1
fi

# Path to GDB
GDB="/Users/byeongjee/migration/msp430-gcc/bin/msp430-elf-gdb"

if [ ! -x "$GDB" ]; then
    echo "Error: GDB not found or not executable: $GDB"
    exit 1
fi

# Run GDB with -ex flags and capture output
GDB_OUTPUT=$("$GDB" "$ELF_FILE" -batch \
    -ex "target sim" \
    -ex "load" \
    -ex "break _exit" \
    -ex "run" \
    -ex 'printf "REGISTERS_START\n"' \
    -ex 'printf "PC:0x%04x\n", $pc' \
    -ex 'printf "SP:0x%04x\n", $sp' \
    -ex 'printf "SR:0x%04x\n", $r2' \
    -ex 'printf "R3:0x%04x\n", $r3' \
    -ex 'printf "R4:0x%04x\n", $r4' \
    -ex 'printf "R5:0x%04x\n", $r5' \
    -ex 'printf "R6:0x%04x\n", $r6' \
    -ex 'printf "R7:0x%04x\n", $r7' \
    -ex 'printf "R8:0x%04x\n", $r8' \
    -ex 'printf "R9:0x%04x\n", $r9' \
    -ex 'printf "R10:0x%04x\n", $r10' \
    -ex 'printf "R11:0x%04x\n", $r11' \
    -ex 'printf "R12:0x%04x\n", $r12' \
    -ex 'printf "R13:0x%04x\n", $r13' \
    -ex 'printf "R14:0x%04x\n", $r14' \
    -ex 'printf "R15:0x%04x\n", $r15' \
    -ex 'printf "REGISTERS_END\n"' \
    2>&1)

# Extract register values from GDB output
REGISTERS_SECTION=$(echo "$GDB_OUTPUT" | sed -n '/REGISTERS_START/,/REGISTERS_END/p' | grep -v "REGISTERS_")

# Parse each register value
get_reg_value() {
    local reg_name="$1"
    echo "$REGISTERS_SECTION" | grep "^$reg_name:" | cut -d: -f2 | xargs printf "%d" 2>/dev/null || echo "0"
}

PC=$(get_reg_value "PC")
SP=$(get_reg_value "SP")
SR=$(get_reg_value "SR")
R3=$(get_reg_value "R3")
R4=$(get_reg_value "R4")
R5=$(get_reg_value "R5")
R6=$(get_reg_value "R6")
R7=$(get_reg_value "R7")
R8=$(get_reg_value "R8")
R9=$(get_reg_value "R9")
R10=$(get_reg_value "R10")
R11=$(get_reg_value "R11")
R12=$(get_reg_value "R12")
R13=$(get_reg_value "R13")
R14=$(get_reg_value "R14")
R15=$(get_reg_value "R15")

# MSP430 Status Register bit positions:
# Bit 0: C (Carry)
# Bit 1: Z (Zero)
# Bit 2: N (Negative)
# Bit 8: V (Overflow)
C_FLAG=$(( (SR & 0x0001) != 0 ))
Z_FLAG=$(( (SR & 0x0002) != 0 ))
N_FLAG=$(( (SR & 0x0004) != 0 ))
V_FLAG=$(( (SR & 0x0100) != 0 ))

# Convert to JSON boolean
to_json_bool() {
    if [ "$1" -eq 1 ]; then echo "true"; else echo "false"; fi
}

# Build JSON output
cat > "$OUTPUT_JSON" << EOF
{
  "registers": {
    "PC": $PC,
    "SP": $SP,
    "SR": $SR,
    "R3": $R3,
    "R4": $R4,
    "R5": $R5,
    "R6": $R6,
    "R7": $R7,
    "R8": $R8,
    "R9": $R9,
    "R10": $R10,
    "R11": $R11,
    "R12": $R12,
    "R13": $R13,
    "R14": $R14,
    "R15": $R15
  },
  "flags": {
    "C": $(to_json_bool $C_FLAG),
    "Z": $(to_json_bool $Z_FLAG),
    "N": $(to_json_bool $N_FLAG),
    "V": $(to_json_bool $V_FLAG)
  },
  "pc": $PC
}
EOF

echo "Register values saved to: $OUTPUT_JSON"
