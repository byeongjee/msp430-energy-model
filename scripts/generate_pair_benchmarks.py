#!/usr/bin/env python3
"""
Generate pair-based microbenchmarks for training the mean_per_pair_addressing_mode_constant model.

OVERVIEW:
    Generates C microbenchmarks that isolate consecutive instruction pairs.
    Each benchmark repeats the pattern: keyA ; keyB ; keyA ; keyB ; ...

WHY PAIRS:
    For N instruction keys, generates N choose 2 unordered pairs.
    The pattern A;B;A;B;... contains the same A→B and B→A transitions as B;A;B;A;...,
    so one microbenchmark effectively measures both (A,B) and (B,A) pairs.

USAGE:
    # Default: all pairs in single file
    python generate_pair_benchmarks.py

    # One benchmark per file (435 files)
    python generate_pair_benchmarks.py --batch 1

    # 50 benchmarks per file (9 files)
    python generate_pair_benchmarks.py --batch 50

    # Subset for testing
    python generate_pair_benchmarks.py --subset 10

    # Filter by opcode
    python generate_pair_benchmarks.py --opcodes add mov

BATCHING:
    --batch controls benchmarks per file:
    - No batch (default): All in one file (minimal compilation overhead, may not fit on device)
    - --batch N: N per file (balances device constraints and compilation time)
    - --batch 1: One per file (max flexibility, high compilation overhead)

INSTRUCTION KEYS:
    - add/mov/cmp: 28 variants each (7 src modes × 4 dst modes)
    - inc: 4 variants (reg, idx, sym, abs)
    - rlam: 4 variants (constants 1, 2, 3, 4)
    - jmp: 1 variant (symbolic)
    - jge: 1 variant (symbolic)
    - ...

ADDING INSTRUCTIONS:
    1. Update benchmark_common.py to add new instruction specs
    2. Update get_all_instruction_specs() to include new specs
    3. Run tests: make test

TESTS:
    See test_generate_pair_benchmarks.py for snapshot tests showing expected C output.
"""

import argparse
from pathlib import Path
from typing import List, Dict, Any
from itertools import combinations
from jinja2 import Template

# Import common utilities
from benchmark_common import (
    InstructionSpec,
    create_dual_operand_specs,
    create_single_operand_specs,
    create_rlam_specs,
    create_jmp_specs,
    create_jge_specs,
    FILE_TEMPLATE,
    generate_benchmark_file,
    generate_batched_files,
)

# ============================================================================
# Instruction Specifications
# ============================================================================


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

    return specs


# ============================================================================
# Jinja2 Templates
# ============================================================================

BENCHMARK_FUNCTION_TEMPLATE = Template(
    """
INLINE void bench_{{ name }}(void) {
{%- for var in variables %}
  {{ var.type }} {{ var.name }} = {{ var.value }};
{%- endfor %}
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
{%- for inst in instructions %}
      "  {{ inst }}\\n"
{%- endfor %}
      ".endr\\n"
      : {{ constraints.outputs }}
      : {{ constraints.inputs }}
      : {{ constraints.clobbers }}));
}
"""
)

# ============================================================================
# Pair Generation
# ============================================================================


def merge_variables(vars1: List[Dict], vars2: List[Dict]) -> List[Dict]:
    """Merge variable lists, avoiding duplicates"""
    merged = {}
    for var in vars1 + vars2:
        name = var["name"]
        if name not in merged:
            merged[name] = var
    return list(merged.values())


def merge_constraints(c1: Dict[str, str], c2: Dict[str, str]) -> Dict[str, str]:
    """Merge constraints from two instructions"""
    # For outputs, combine but avoid duplicates
    outputs_set = set()
    for c in [c1["outputs"], c2["outputs"]]:
        if c:
            for item in c.split(","):
                outputs_set.add(item.strip())

    # For inputs, combine but avoid duplicates
    inputs_set = set()
    for c in [c1["inputs"], c2["inputs"]]:
        if c:
            for item in c.split(","):
                inputs_set.add(item.strip())

    # For clobbers, union
    clobbers_set = set()
    for c in [c1["clobbers"], c2["clobbers"]]:
        for item in c.split(","):
            clobbers_set.add(item.strip())

    return {
        "outputs": ", ".join(sorted(outputs_set)) if outputs_set else "",
        "inputs": ", ".join(sorted(inputs_set)) if inputs_set else "",
        "clobbers": ", ".join(sorted(clobbers_set)),
    }


def generate_pair_benchmark(
    spec1: InstructionSpec, spec2: InstructionSpec
) -> Dict[str, Any]:
    """Generate a benchmark for a pair of instructions"""
    name = f"{spec1.get_key_str()}__{spec2.get_key_str()}"

    # Merge variables and constraints
    variables = merge_variables(spec1.variables, spec2.variables)
    constraints = merge_constraints(spec1.constraints, spec2.constraints)

    # Create instruction list (alternating pattern)
    instructions = [spec1.asm_template, spec2.asm_template]

    # Generate function code
    code = BENCHMARK_FUNCTION_TEMPLATE.render(
        name=name,
        variables=variables,
        instructions=instructions,
        constraints=constraints,
    )

    return {
        "name": name,
        "code": code,
        "key1": spec1.get_key(),
        "key2": spec2.get_key(),
    }


def generate_all_pairs(specs: List[InstructionSpec]) -> List[Dict[str, Any]]:
    """Generate all unordered pair combinations

    Args:
        specs: List of instruction specifications

    Returns:
        List of pair benchmarks for all pairs including same-instruction pairs (A,A)
    """
    benchmarks = []

    # Generate same-instruction pairs (A,A)
    for spec in specs:
        benchmarks.append(generate_pair_benchmark(spec, spec))

    # Generate unordered pairs (A,B) where A != B
    for spec1, spec2 in combinations(specs, 2):
        benchmarks.append(generate_pair_benchmark(spec1, spec2))

    return benchmarks


# ============================================================================
# Main
# ============================================================================


def main():
    parser = argparse.ArgumentParser(
        description="Generate pair-based microbenchmarks for MSP430 energy modeling"
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        help="Output directory for generated benchmarks (default: training_data/pairs)",
    )
    parser.add_argument(
        "--batch",
        type=int,
        help="Number of benchmarks per file (default: all in one file, use 1 for one benchmark per file)",
    )
    parser.add_argument(
        "--subset", type=int, help="Generate only first N pairs (for testing)"
    )
    parser.add_argument(
        "--opcodes",
        nargs="+",
        help="Only generate pairs for specific opcodes (e.g., add mov)",
    )

    args = parser.parse_args()

    # Create output directory
    args.output_dir.mkdir(parents=True, exist_ok=True)

    # Get instruction specs
    all_specs = get_all_instruction_specs()

    # Filter by opcodes if specified
    if args.opcodes:
        all_specs = [s for s in all_specs if s.opcode in args.opcodes]

    print(f"Generating benchmarks for {len(all_specs)} instruction keys...")

    # Generate pairs (always unordered)
    benchmarks = generate_all_pairs(all_specs)

    # Apply subset if specified
    if args.subset:
        benchmarks = benchmarks[: args.subset]

    print(f"Generated {len(benchmarks)} pair benchmarks")

    # Generate files
    if args.batch is None:
        # All benchmarks in a single file
        output_file = args.output_dir / "all_pairs.c"
        generate_benchmark_file(benchmarks, output_file)
        print(f"✓ Generated {output_file}")
    else:
        # Batched output
        generate_batched_files(benchmarks, args.output_dir, args.batch, file_prefix="pairs_batch")
        num_files = (len(benchmarks) + args.batch - 1) // args.batch
        print(f"✓ Generated {num_files} files in {args.output_dir}")

    # Print statistics
    print(f"\nStatistics:")
    print(f"  Instruction keys: {len(all_specs)}")
    print(f"  Pair benchmarks: {len(benchmarks)}")
    print(f"  Output directory: {args.output_dir}")


if __name__ == "__main__":
    main()
