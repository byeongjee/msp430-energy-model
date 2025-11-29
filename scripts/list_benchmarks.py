#!/usr/bin/env python3
"""
List benchmark keys as JSON for any supported granularity.
Output goes to stdout by default for easy piping.

USAGE:
    # All addressing-mode keys to stdout
    ./scripts/list_benchmarks.py --granularity addressing_mode

    # Filter for specific opcodes with jq
    ./scripts/list_benchmarks.py --granularity addressing_mode | jq '.instructions[] | select(.opcode == "add")'

    # All addressing-mode pairs written to file
    ./scripts/list_benchmarks.py --granularity addressing_mode_pair --output all_pairs.json
"""

import argparse
import json
import sys
from itertools import combinations
from pathlib import Path
from typing import List

from benchmark_common import (
    InstructionSpec,
    get_instruction_specs,
    normalize_granularity,
)

# Benchmarks for these opcodes can corrupt memory; skip them here.
# TODO: add safe handling for pushm/popm/call/ret generation.
# We also skip instructions that are hard to repeat safely in a tight loop.
UNSAFE_OPCODES = {"br", "call", "nop", "popm", "push", "pushm", "ret", "reti", "rpt"}


def list_instruction_keys(specs: List[InstructionSpec]) -> dict:
    """Create JSON payload for instruction-level benchmarks"""
    instructions = []
    for spec in specs:
        key_str = spec.get_key_str()
        instructions.append(
            {
                "name": key_str,
                "key": key_str,
                "opcode": spec.opcode,
            }
        )

    return {
        "num_keys": len(specs),
        "instructions": instructions,
    }


def list_pair_keys(specs: List[InstructionSpec]) -> dict:
    """Create JSON payload for pair benchmarks"""
    pairs = []

    # Same-instruction pairs (A, A)
    for spec in specs:
        key_str = spec.get_key_str()
        pairs.append(
            {
                "name": f"{key_str}__{key_str}",
                "key1": key_str,
                "key2": key_str,
                "opcode1": spec.opcode,
                "opcode2": spec.opcode,
            }
        )

    # Different instruction pairs (A, B) where A != B
    for spec1, spec2 in combinations(specs, 2):
        key1_str = spec1.get_key_str()
        key2_str = spec2.get_key_str()
        pairs.append(
            {
                "name": f"{key1_str}__{key2_str}",
                "key1": key1_str,
                "key2": key2_str,
                "opcode1": spec1.opcode,
                "opcode2": spec2.opcode,
            }
        )

    return {
        "num_keys": len(specs),
        "num_pairs": len(pairs),
        "pairs": pairs,
    }


def main():
    parser = argparse.ArgumentParser(description="List benchmark keys as JSON")
    parser.add_argument(
        "--granularity",
        choices=[
            "opcode",
            "addressing_mode",
            "addressing_mode_constant",
            "opcode_pair",
            "addressing_mode_pair",
            "addressing_mode_constant_pair",
            "instruction",  # alias
            "pair",  # alias
        ],
        required=True,
        help="Benchmark granularity to list",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output JSON file path (default: stdout)",
    )

    args = parser.parse_args()

    normalized = normalize_granularity(args.granularity)
    specs = [spec for spec in get_instruction_specs(normalized) if spec.opcode not in UNSAFE_OPCODES]

    if normalized.endswith("pair"):
        output_data = list_pair_keys(specs)
    else:
        output_data = list_instruction_keys(specs)

    if args.output:
        args.output.write_text(json.dumps(output_data, indent=2))
        print(f"✓ Generated benchmark list ({args.granularity})", file=sys.stderr)
        print(f"✓ Saved to {args.output}", file=sys.stderr)
    else:
        json.dump(output_data, sys.stdout, indent=2)
        sys.stdout.write("\n")


if __name__ == "__main__":
    main()
