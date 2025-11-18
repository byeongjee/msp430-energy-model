#!/usr/bin/env python3
"""
Generate C benchmark files from a filtered pairs JSON list.

Takes a JSON file containing pair specifications (from list_all_pairs.py)
and generates the corresponding C benchmark files.

USAGE:
    # Generate from filtered pairs list
    python generate_from_pairs_list.py \\
        --input jl_pairs.json \\
        --output-dir training_data/pairs \\
        --batch 10 \\
        --start-batch 447

    # Generate single file
    python generate_from_pairs_list.py \\
        --input jl_pairs.json \\
        --output jl_benchmarks.c
"""

import argparse
import json
from pathlib import Path
from typing import List, Dict, Any

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
    generate_benchmark_file,
    generate_batched_files,
)

from generate_pair_benchmarks import (
    generate_pair_benchmark,
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

    # Jump instructions
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
        description="Generate C benchmark files from filtered pairs JSON"
    )
    parser.add_argument(
        "--input",
        type=Path,
        help="Input JSON file with pair specifications (default: stdin)"
    )

    # Output options: either --output for single file or --output-dir for batched
    output_group = parser.add_mutually_exclusive_group(required=True)
    output_group.add_argument(
        "--output",
        type=Path,
        help="Output C file (single file mode)"
    )
    output_group.add_argument(
        "--output-dir",
        type=Path,
        help="Output directory for batched files"
    )

    parser.add_argument(
        "--batch",
        type=int,
        help="Number of benchmarks per file (only for --output-dir mode)"
    )
    parser.add_argument(
        "--start-batch",
        type=int,
        default=0,
        help="Starting batch number (only for --output-dir mode, default: 0)"
    )

    args = parser.parse_args()

    # Validate batch arguments
    if args.output_dir and not args.batch:
        parser.error("--batch is required when using --output-dir")

    # Read input JSON from stdin or file
    import sys
    if args.input:
        with open(args.input, 'r') as f:
            data = json.load(f)
    else:
        data = json.load(sys.stdin)

    # Handle both formats: full JSON with metadata or just array of pairs
    if isinstance(data, dict) and "pairs" in data:
        pairs_data = data["pairs"]
    elif isinstance(data, list):
        pairs_data = data
    else:
        raise ValueError("Invalid JSON format. Expected object with 'pairs' array or array of pairs")

    source = args.input if args.input else "stdin"
    print(f"Loaded {len(pairs_data)} pairs from {source}", file=sys.stderr)

    # Build lookup table: key_str -> InstructionSpec
    all_specs = get_all_instruction_specs()
    spec_lookup = {spec.get_key_str(): spec for spec in all_specs}

    print(f"Loaded {len(spec_lookup)} instruction specifications", file=sys.stderr)

    # Generate benchmarks
    benchmarks = []
    for pair_data in pairs_data:
        key1 = pair_data["key1"]
        key2 = pair_data["key2"]

        if key1 not in spec_lookup:
            print(f"Warning: Unknown key '{key1}', skipping pair", file=sys.stderr)
            continue
        if key2 not in spec_lookup:
            print(f"Warning: Unknown key '{key2}', skipping pair", file=sys.stderr)
            continue

        spec1 = spec_lookup[key1]
        spec2 = spec_lookup[key2]

        benchmark = generate_pair_benchmark(spec1, spec2)
        benchmarks.append(benchmark)

    print(f"Generated {len(benchmarks)} benchmarks", file=sys.stderr)

    # Write output
    if args.output:
        # Single file mode
        generate_benchmark_file(benchmarks, args.output)
        print(f"✓ Generated {args.output}", file=sys.stderr)
    else:
        # Batched mode
        args.output_dir.mkdir(parents=True, exist_ok=True)
        generate_batched_files(
            benchmarks,
            args.output_dir,
            args.batch,
            file_prefix="pairs_batch",
            start_batch=args.start_batch
        )
        num_files = (len(benchmarks) + args.batch - 1) // args.batch
        if args.start_batch > 0:
            print(f"✓ Generated {num_files} files in {args.output_dir} (starting from batch {args.start_batch})", file=sys.stderr)
        else:
            print(f"✓ Generated {num_files} files in {args.output_dir}", file=sys.stderr)


if __name__ == "__main__":
    main()
