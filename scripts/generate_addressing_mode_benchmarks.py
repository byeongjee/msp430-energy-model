#!/usr/bin/env python3
"""
Generate addressing-mode microbenchmarks for training the PerAddressingMode and PerAddressingModeConstant models.

OVERVIEW:
    Generates C microbenchmarks that isolate individual instruction variations.
    Each benchmark repeats a single instruction: inst ; inst ; inst ; ...

WHY INDIVIDUAL INSTRUCTIONS:
    The PerAddressingMode and PerAddressingModeConstant models assign energy to each instruction
    based on (opcode, src_mode, dst_mode) or (opcode, src_mode, constant, dst_mode).
    By measuring each instruction variation in isolation, we can learn its energy consumption.

USAGE:
    # Default: all benchmarks in single file
    python generate_addressing_mode_benchmarks.py

    # One benchmark per file
    python generate_addressing_mode_benchmarks.py --batch 1

    # 20 benchmarks per file
    python generate_addressing_mode_benchmarks.py --batch 20

    # Subset for testing
    python generate_addressing_mode_benchmarks.py --subset 10

    # Filter by opcode
    python generate_addressing_mode_benchmarks.py --opcodes add mov

BATCHING:
    --batch controls benchmarks per file:
    - No batch (default): All in one file
    - --batch N: N per file
    - --batch 1: One per file (max flexibility)

INSTRUCTION KEYS:
    - Dual-operand (add/mov/cmp/sub/and/or/xor/bit/bic/bis): (opcode, src_mode, dst_mode) - 28 variants each
    - Single-operand (inc/dec): (opcode, src_mode) - 4 variants each
    - Constant-aware (rlam): (opcode, src_mode, constant, dst_mode) - 4 variants
    - Jump (jmp/jge): (opcode, src_mode) - 1 variant each

ADDING INSTRUCTIONS:
    1. Update benchmark_common.py to add new instruction specs
    2. Update get_all_instruction_specs() to include new specs
"""

import argparse
from pathlib import Path
from typing import List, Dict, Any
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
    for opcode in ["add", "mov", "cmp", "sub", "and", "or", "xor", "bit", "bic", "bis"]:
        specs.extend(create_dual_operand_specs(opcode))

    # Single-operand instructions
    for opcode in ["inc", "dec"]:
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
      "  {{ instruction }}\\n"
      ".endr\\n"
      : {{ constraints.outputs }}
      : {{ constraints.inputs }}
      : {{ constraints.clobbers }}));
}
"""
)

# ============================================================================
# Benchmark Generation
# ============================================================================


def generate_benchmark(spec: InstructionSpec) -> Dict[str, Any]:
    """Generate a benchmark for a single instruction"""
    name = spec.get_key_str()

    # Generate function code
    code = BENCHMARK_FUNCTION_TEMPLATE.render(
        name=name,
        variables=spec.variables,
        instruction=spec.asm_template,
        constraints=spec.constraints,
    )

    return {
        "name": name,
        "code": code,
        "key": spec.get_key(),
    }


def generate_all_benchmarks(specs: List[InstructionSpec]) -> List[Dict[str, Any]]:
    """Generate all benchmarks"""
    benchmarks = []
    for spec in specs:
        benchmarks.append(generate_benchmark(spec))
    return benchmarks


# ============================================================================
# Main
# ============================================================================


def main():
    parser = argparse.ArgumentParser(
        description="Generate addressing-mode microbenchmarks for MSP430 energy modeling"
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("training_data/addressing_mode"),
        help="Output directory for generated benchmarks (default: training_data/addressing_mode)",
    )
    parser.add_argument(
        "--batch",
        type=int,
        help="Number of benchmarks per file (default: all in one file, use 1 for one benchmark per file)",
    )
    parser.add_argument(
        "--subset", type=int, help="Generate only first N benchmarks (for testing)"
    )
    parser.add_argument(
        "--opcodes",
        nargs="+",
        help="Only generate benchmarks for specific opcodes (e.g., add mov)",
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

    # Generate benchmarks
    benchmarks = generate_all_benchmarks(all_specs)

    # Apply subset if specified
    if args.subset:
        benchmarks = benchmarks[: args.subset]

    print(f"Generated {len(benchmarks)} benchmarks")

    # Generate files
    if args.batch is None:
        # All benchmarks in a single file
        output_file = args.output_dir / "all_instructions.c"
        generate_benchmark_file(benchmarks, output_file)
        print(f"✓ Generated {output_file}")
    else:
        # Batched output
        generate_batched_files(benchmarks, args.output_dir, args.batch, file_prefix="addressing_mode_batch")
        num_files = (len(benchmarks) + args.batch - 1) // args.batch
        print(f"✓ Generated {num_files} files in {args.output_dir}")

    # Print statistics
    print(f"\nStatistics:")
    print(f"  Instruction keys: {len(all_specs)}")
    print(f"  Benchmarks: {len(benchmarks)}")
    print(f"  Output directory: {args.output_dir}")


if __name__ == "__main__":
    main()
