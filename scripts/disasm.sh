#!/usr/bin/env bash
# Disassembly utility for MSP430 ELF files
#
# This file can be sourced by any script that needs disassembly.
# Requires: MSP430GCC_TOOLCHAIN_PATH and OBJDUMP to be set.

# Disassemble an ELF file, removing local symbols that break instruction disassembly.
# Some GCC-generated local symbols (like L0^A, .LVL*, .Loc.*) can appear in the
# middle of multi-byte instructions, causing objdump to incorrectly split them.
#
# We use objcopy to remove only these problematic symbols while keeping
# function labels intact.
#
# Usage: disasm <elf_file> <output_asm_file> <output_data_file>
#
# Generates both assembly disassembly and data dump with section headers
# for VMA→LMA translation (needed for initialized global variables).
disasm() {
    local elf_file="$1"
    local output_file="$2"
    local data_file="$3"
    local cleaned_elf="${elf_file%.elf}_cleaned.elf"
    local objcopy_cmd="${MSP430GCC_TOOLCHAIN_PATH}/bin/msp430-elf-objcopy"

    # Remove local symbols that can appear mid-instruction:
    # - L0* (includes L0^A with control character)
    # - .LVL* (DWARF location labels)
    # - .Loc.* (DWARF source location labels)
    # - .L* (GCC internal labels like .L1, .L2)
    # - .LCFI* (CFI labels)
    "$objcopy_cmd" \
        --wildcard \
        --strip-symbol='L0*' \
        --strip-symbol='.LVL*' \
        --strip-symbol='.Loc.*' \
        --strip-symbol='.L*' \
        --strip-symbol='.LCFI*' \
        "$elf_file" "$cleaned_elf"

    "$OBJDUMP" -d "$cleaned_elf" > "$output_file"
    rm -f "$cleaned_elf"

    # Generate data dump with section headers
    local data_sections=(.rodata .rodata2 .data .lower.data .upper.data .persistent .text)
    echo "# Section headers: Name Size VMA LMA" > "$data_file"
    "$OBJDUMP" -h "$elf_file" | awk '/^[[:space:]]+[0-9]+[[:space:]]/ { print "# " $2, $3, $4, $5 }' >> "$data_file"
    echo "" >> "$data_file"
    "$OBJDUMP" -s $(printf ' -j %s' "${data_sections[@]}") "$elf_file" >> "$data_file"
}
