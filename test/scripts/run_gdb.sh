#!/bin/bash
# run_gdb.sh - Run MSP430 ELF binary in GDB simulator and extract register/memory values as JSON
# Usage: ./run_gdb.sh <elf_file> <output_json> [data_file]
#
# If data_file is provided, memory sections are parsed from it and dumped.
# The data_file should contain section headers in the format produced by disasm.sh.

set -e

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: $0 <elf_file> <output_json> [data_file]"
    echo "Example: $0 build/simple.elf output.json"
    echo "Example: $0 build/simple.elf output.json build/simple.data"
    exit 1
fi

ELF_FILE="$1"
OUTPUT_JSON="$2"
DATA_FILE="${3:-}"

if [ ! -f "$ELF_FILE" ]; then
    echo "Error: ELF file not found: $ELF_FILE"
    exit 1
fi

# Check required environment variables
if [[ -z "${MSP430GCC_TOOLCHAIN_PATH}" ]]; then
    echo "Error: MSP430GCC_TOOLCHAIN_PATH is not set. Please set it in your environment or .env file"
    exit 1
fi

# Path to GDB
GDB="$MSP430GCC_TOOLCHAIN_PATH/bin/msp430-elf-gdb"

if [ ! -x "$GDB" ]; then
    echo "Error: GDB not found or not executable: $GDB"
    exit 1
fi

# Build GDB memory dump arguments from data file section headers
GDB_MEMORY_ARGS=()
if [ -n "$DATA_FILE" ] && [ -f "$DATA_FILE" ]; then
    # Parse section headers from data file
    # Format: # .data 00000002 00001c00 00004000
    # Fields: # name size vma lma
    while read -r line; do
        # Extract fields: size, vma (skip the "# " prefix and name)
        size_hex=$(echo "$line" | awk '{print $3}')
        vma_hex=$(echo "$line" | awk '{print $4}')

        # Validate hex values
        if [ -z "$size_hex" ] || [ -z "$vma_hex" ]; then
            continue
        fi

        # Convert hex to decimal
        size=$((16#${size_hex}))

        # Only process sections with non-zero size (word-aligned)
        if [ "$size" -gt 0 ]; then
            num_words=$((size / 2))
            if [ "$num_words" -gt 0 ]; then
                GDB_MEMORY_ARGS+=(-ex "x/${num_words}hx 0x${vma_hex}")
            fi
        fi
    done < <(grep -E "^# \.(data|bss|noinit|upper\.data|upper\.bss|lower\.data|lower\.bss) " "$DATA_FILE" 2>/dev/null || true)
fi

# Run GDB with array-based arguments
GDB_OUTPUT=$("$GDB" "$ELF_FILE" -batch \
    -ex 'target sim' \
    -ex 'load' \
    -ex 'break _exit' \
    -ex 'run' \
    -ex 'printf "REGISTERS_START\n"' \
    -ex 'printf "PC:0x%04x\n", $pc' \
    -ex 'printf "SP:0x%04x\n", $sp' \
    -ex 'printf "SR:0x%04x\n", $sr' \
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
    -ex 'printf "MEMORY_START\n"' \
    "${GDB_MEMORY_ARGS[@]}" \
    -ex 'printf "MEMORY_END\n"' \
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

# Parse memory values from GDB output
# GDB x/ format: "0x1c00 <symbol>:	0x0007	0x000e"
MEMORY_JSON=""
if [ ${#GDB_MEMORY_ARGS[@]} -gt 0 ]; then
    MEMORY_SECTION=$(echo "$GDB_OUTPUT" | sed -n '/MEMORY_START/,/MEMORY_END/p' | grep "^0x" || true)

    # Build memory entries as "addr:value" pairs, one per line
    MEMORY_ENTRIES=""
    while read -r line; do
        # Skip empty lines
        [ -z "$line" ] && continue

        # Parse line format: "0x1c00 <symbol>:	0x0007	0x000e" or "0x1c00:	0x0007"
        # Extract base address (first hex value before optional symbol name)
        base_addr=$(echo "$line" | sed 's/^\(0x[0-9a-fA-F]*\).*/\1/')
        base_addr_dec=$((base_addr))

        # Extract values after the colon
        values=$(echo "$line" | cut -d: -f2 | tr '\t' ' ')

        # Process each value
        offset=0
        for val in $values; do
            # Skip if not a hex value
            case "$val" in
                0x[0-9a-fA-F]*) ;;
                *) continue ;;
            esac

            # Convert to decimal
            val_dec=$((val))

            # Only include non-zero values
            if [ "$val_dec" -ne 0 ]; then
                addr=$((base_addr_dec + offset))
                addr_hex=$(printf "0x%x" $addr)
                MEMORY_ENTRIES="${MEMORY_ENTRIES}${addr_hex}:${val_dec}
"
            fi

            offset=$((offset + 2))  # Each word is 2 bytes
        done
    done <<< "$MEMORY_SECTION"

    # Build JSON object from entries (sort by address)
    if [ -n "$MEMORY_ENTRIES" ]; then
        MEMORY_CONTENT=$(echo "$MEMORY_ENTRIES" | sort -t: -k1 | {
            first=true
            while read -r entry; do
                [ -z "$entry" ] && continue
                addr=$(echo "$entry" | cut -d: -f1)
                val=$(echo "$entry" | cut -d: -f2)
                if [ "$first" = true ]; then
                    first=false
                    printf '"%s": %s' "$addr" "$val"
                else
                    printf ', "%s": %s' "$addr" "$val"
                fi
            done
        })
        MEMORY_JSON="  \"memory\": { $MEMORY_CONTENT },"
    fi
fi

# Build JSON output
cat > "$OUTPUT_JSON" << EOF
{
$MEMORY_JSON
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
