#!/usr/bin/env python3
"""
List all addressing mode instruction keys as JSON.
Output goes to stdout by default for easy piping.

USAGE:
    # All instructions to stdout
    ./scripts/gen_addressing_mode_for_benchmarks.py

    # Filter for specific opcodes with jq
    ./scripts/gen_addressing_mode_for_benchmarks.py | jq '.instructions[] | select(.opcode == "add")'

    # Save to file
    ./scripts/gen_addressing_mode_for_benchmarks.py --output all_instructions.json
"""

import argparse
import json
import sys
from pathlib import Path
from typing import List

from benchmark_common import (
    InstructionSpec,
    create_dual_operand_specs,
    create_single_operand_specs,
    create_rlam_specs,
    create_jmp_specs,
    create_jge_specs,
    create_jl_specs,
    create_jnz_specs,
    create_jz_specs,
    create_jnc_specs,
    create_jc_specs,
    create_jn_specs,
)


def get_all_instruction_specs() -> List[InstructionSpec]:
    """Get all instruction specifications"""
    specs = []

    # Dual-operand instructions
    for opcode in ["add", "mov", "cmp", "sub", "and", "or", "xor", "bit", "bic", "bis"]:
        specs.extend(create_dual_operand_specs(opcode))

    # Single-operand instructions
    for opcode in ["inc", "dec"]:
        specs.extend(create_single_operand_specs(opcode))

    # Constant-aware instructions
    specs.extend(create_rlam_specs())

    # Jump instructions (all conditional and unconditional jumps)
    specs.extend(create_jmp_specs())
    specs.extend(create_jge_specs())
    specs.extend(create_jl_specs())
    specs.extend(create_jnz_specs())
    specs.extend(create_jz_specs())
    specs.extend(create_jnc_specs())
    specs.extend(create_jc_specs())
    specs.extend(create_jn_specs())

    return specs


def main():
    parser = argparse.ArgumentParser(
        description="List all addressing mode instruction keys as JSON"
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output JSON file path (default: stdout)"
    )

    args = parser.parse_args()

    # Get all instruction specs
    all_specs = get_all_instruction_specs()

    # Create list of instructions
    instructions = []
    for spec in all_specs:
        key_str = spec.get_key_str()
        instructions.append({
            "name": key_str,
            "key": key_str,
            "opcode": spec.opcode,
        })

    # Create output
    output_data = {
        "num_keys": len(all_specs),
        "instructions": instructions
    }

    # Write JSON to stdout or file
    if args.output:
        with open(args.output, 'w') as f:
            json.dump(output_data, f, indent=2)
        print(f"✓ Generated {len(instructions)} instruction keys", file=sys.stderr)
        print(f"✓ Saved to {args.output}", file=sys.stderr)
    else:
        json.dump(output_data, sys.stdout, indent=2)
        sys.stdout.write('\n')


if __name__ == "__main__":
    main()
