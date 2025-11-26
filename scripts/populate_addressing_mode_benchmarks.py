#!/usr/bin/env python3
"""
Generate C benchmark files from a filtered addressing mode instruction JSON list.

Takes a JSON file containing instruction specifications (from gen_addressing_mode_for_benchmarks.py)
and generates the corresponding C benchmark files.

OVERVIEW:
    Generates C microbenchmarks that isolate individual instruction variations.
    Each benchmark repeats a single instruction: inst ; inst ; inst ; ...

WHY INDIVIDUAL INSTRUCTIONS:
    The PerAddressingMode and PerAddressingModeConstant models assign energy to each instruction
    based on (opcode, src_mode, dst_mode) or (opcode, src_mode, constant, dst_mode).
    By measuring each instruction variation in isolation, we can learn its energy consumption.

USAGE:
    # Generate from filtered instruction list (batched)
    python populate_addressing_mode_benchmarks.py \
        --input add_instructions.json \
        --output-dir training_data/addressing_mode \
        --batch 20 \
        --start-batch 0

    # Generate single file
    python populate_addressing_mode_benchmarks.py \
        --input add_instructions.json \
        --output add_benchmarks.c

WORKFLOW:
    1. gen_addressing_mode_for_benchmarks.py generates JSON list of all instruction keys
    2. Use jq to filter instructions (e.g., only specific opcode)
    3. This script takes filtered JSON and generates C benchmark files

INSTRUCTION KEYS:
    - Dual-operand (add/mov/cmp/sub/and/or/xor/bit/bic/bis): (opcode, src_mode, dst_mode) - 28 variants each
    - Single-operand (inc/dec): (opcode, src_mode) - 4 variants each
    - Constant-aware (rlam): (opcode, src_mode, constant, dst_mode) - 4 variants
    - Jump (jmp/jge/jl/jnz/jz/jnc/jc/jn): (opcode, src_mode) - 1 variant each

ADDING INSTRUCTIONS:
    1. Update benchmark_common.py to add new instruction specs
    2. Update get_all_instruction_specs() to include new specs
    3. Run tests: make test

TESTS:
    See test_generate_addressing_mode_benchmarks.py for snapshot tests showing expected C output.
"""

import argparse
import json
from pathlib import Path
from typing import List, Dict, Any
from jinja2 import Template

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
    specs.extend(create_jl_specs())
    specs.extend(create_jnz_specs())
    specs.extend(create_jz_specs())
    specs.extend(create_jnc_specs())
    specs.extend(create_jc_specs())
    specs.extend(create_jn_specs())

    return specs


def main():
    parser = argparse.ArgumentParser(
        description="Generate C benchmark files from filtered instruction JSON"
    )
    parser.add_argument(
        "--input",
        type=Path,
        help="Input JSON file with instruction specifications (default: stdin)"
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

    # Handle both formats: full JSON with metadata or just array of instructions
    if isinstance(data, dict) and "instructions" in data:
        instructions_data = data["instructions"]
    elif isinstance(data, list):
        instructions_data = data
    else:
        raise ValueError("Invalid JSON format. Expected object with 'instructions' array or array of instructions")

    source = args.input if args.input else "stdin"
    print(f"Loaded {len(instructions_data)} instructions from {source}", file=sys.stderr)

    # Build lookup table: key_str -> InstructionSpec
    all_specs = get_all_instruction_specs()
    spec_lookup = {spec.get_key_str(): spec for spec in all_specs}

    print(f"Loaded {len(spec_lookup)} instruction specifications", file=sys.stderr)

    # Generate benchmarks
    benchmarks = []
    for inst_data in instructions_data:
        key = inst_data["key"]

        if key not in spec_lookup:
            print(f"Warning: Unknown key '{key}', skipping instruction", file=sys.stderr)
            continue

        spec = spec_lookup[key]
        benchmark = generate_benchmark(spec)
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
            file_prefix="addressing_mode_batch",
            start_batch=args.start_batch
        )
        num_files = (len(benchmarks) + args.batch - 1) // args.batch
        if args.start_batch > 0:
            print(f"✓ Generated {num_files} files in {args.output_dir} (starting from batch {args.start_batch})", file=sys.stderr)
        else:
            print(f"✓ Generated {num_files} files in {args.output_dir}", file=sys.stderr)


if __name__ == "__main__":
    main()
