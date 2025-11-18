#!/usr/bin/env python3
"""
List all possible instruction pair combinations as JSON.
Output goes to stdout by default for easy piping.

USAGE:
    # All pairs to stdout
    ./scripts/list_all_pairs.py

    # Filter for jl pairs with jq
    ./scripts/list_all_pairs.py | jq '.pairs[] | select(.opcode1 == "jl" or .opcode2 == "jl")'

    # Save to file
    ./scripts/list_all_pairs.py --output all_pairs.json
"""

import argparse
import json
import sys
from pathlib import Path
from typing import List
from itertools import combinations

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
    for opcode in ["add", "mov", "cmp"]:
        specs.extend(create_dual_operand_specs(opcode))

    # Single-operand instructions
    for opcode in ["inc"]:
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
        description="List all possible instruction pair combinations as JSON"
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output JSON file path (default: stdout)"
    )

    args = parser.parse_args()

    # Get all instruction specs
    all_specs = get_all_instruction_specs()

    # Generate all pair combinations
    pairs = []

    # Same-instruction pairs (A,A)
    for spec in all_specs:
        key_str = spec.get_key_str()
        pairs.append({
            "name": f"{key_str}__{key_str}",
            "key1": key_str,
            "key2": key_str,
            "opcode1": spec.opcode,
            "opcode2": spec.opcode,
        })

    # Different instruction pairs (A,B) where A != B
    for spec1, spec2 in combinations(all_specs, 2):
        key1_str = spec1.get_key_str()
        key2_str = spec2.get_key_str()
        pairs.append({
            "name": f"{key1_str}__{key2_str}",
            "key1": key1_str,
            "key2": key2_str,
            "opcode1": spec1.opcode,
            "opcode2": spec2.opcode,
        })

    # Create output
    output_data = {
        "num_keys": len(all_specs),
        "num_pairs": len(pairs),
        "pairs": pairs
    }

    # Write JSON to stdout or file
    if args.output:
        with open(args.output, 'w') as f:
            json.dump(output_data, f, indent=2)
        print(f"✓ Generated {len(pairs)} pairs", file=sys.stderr)
        print(f"✓ Saved to {args.output}", file=sys.stderr)
    else:
        json.dump(output_data, sys.stdout, indent=2)
        sys.stdout.write('\n')


if __name__ == "__main__":
    main()
