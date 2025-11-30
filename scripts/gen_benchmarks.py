#!/usr/bin/env python3
"""
Generate C benchmark files for any supported granularity (opcode/addressing-mode and pairs).

USAGE:
    # Generate addressing-mode benchmarks (single file)
    python scripts/gen_benchmarks.py \
        --granularity addressing_mode \
        --input add_instructions.json \
        --output add_benchmarks.c

    # Generate addressing-mode pair benchmarks in batches
    python scripts/gen_benchmarks.py \
        --granularity addressing_mode_pair \
        --input jl_pairs.json \
        --output-dir training_data/pairs \
        --batch 10 \
        --start-batch 0
"""

import argparse
import json
import sys
import shutil
from pathlib import Path
from typing import Any, Dict, List
from jinja2 import Template

from benchmark_common import (
    InstructionSpec,
    generate_benchmark_file,
    generate_batched_files,
    get_instruction_specs,
    normalize_granularity,
    UNSAFE_OPCODES,
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

PAIR_BENCHMARK_FUNCTION_TEMPLATE = Template(
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
# Instruction-level benchmark generation
# ============================================================================


def generate_benchmark(spec: InstructionSpec) -> Dict[str, Any]:
    """Generate a benchmark for a single instruction"""
    name = spec.get_key_str()

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


def generate_instruction_benchmarks(
    instructions_data: List[Dict[str, Any]],
    spec_lookup: Dict[str, InstructionSpec],
) -> List[Dict[str, Any]]:
    """Generate benchmarks for a list of instruction payloads"""
    benchmarks = []
    for inst_data in instructions_data:
        key = inst_data["key"]

        if key not in spec_lookup:
            print(
                f"Warning: Unknown key '{key}', skipping instruction", file=sys.stderr
            )
            continue

        spec = spec_lookup[key]
        benchmark = generate_benchmark(spec)
        benchmarks.append(benchmark)

    return benchmarks


# ============================================================================
# Pair benchmark generation
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
    outputs_set = set()
    for c in [c1["outputs"], c2["outputs"]]:
        if c:
            for item in c.split(","):
                outputs_set.add(item.strip())

    inputs_set = set()
    for c in [c1["inputs"], c2["inputs"]]:
        if c:
            for item in c.split(","):
                inputs_set.add(item.strip())

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

    variables = merge_variables(spec1.variables, spec2.variables)
    constraints = merge_constraints(spec1.constraints, spec2.constraints)

    instructions = [spec1.asm_template, spec2.asm_template]

    code = PAIR_BENCHMARK_FUNCTION_TEMPLATE.render(
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


def generate_pair_benchmarks(
    pairs_data: List[Dict[str, Any]],
    spec_lookup: Dict[str, InstructionSpec],
) -> List[Dict[str, Any]]:
    """Generate benchmarks for a list of pair payloads"""
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

    return benchmarks


# ============================================================================
# Input handling
# ============================================================================


def load_payload(input_path: Path, granularity: str) -> List[Dict[str, Any]]:
    """Load instructions or pairs from JSON input"""
    if input_path:
        with open(input_path, "r") as f:
            data = json.load(f)
        source = input_path
    else:
        data = json.load(sys.stdin)
        source = "stdin"

    is_pair = normalize_granularity(granularity).endswith("pair")
    key = "pairs" if is_pair else "instructions"

    if isinstance(data, dict):
        if key not in data:
            raise ValueError(f"Invalid JSON format. Expected object with '{key}' array")
        payload = data[key]
    elif isinstance(data, list):
        payload = data
    else:
        raise ValueError("Invalid JSON format. Expected object or array")

    print(f"Loaded {len(payload)} {key} from {source}", file=sys.stderr)
    return payload


def get_all_instruction_specs(
    granularity: str = "instruction",
) -> List[InstructionSpec]:
    """Compatibility wrapper for callers expecting get_all_instruction_specs"""
    return get_instruction_specs(normalize_granularity(granularity))


# ============================================================================
# CLI
# ============================================================================


def main():
    parser = argparse.ArgumentParser(
        description="Generate C benchmark files from filtered JSON"
    )
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
        default="addressing_mode",
        help="Benchmark granularity to generate (default: addressing_mode)",
    )
    parser.add_argument(
        "--input",
        type=Path,
        help="Input JSON file (default: stdin)",
    )

    parser.add_argument(
        "--output-dir",
        type=Path,
        required=True,
        help="Output directory for benchmark files",
    )

    parser.add_argument(
        "--batch",
        type=int,
        help="Number of benchmarks per file (if not specified, creates all_benchmarks.c)",
    )
    parser.add_argument(
        "--start-batch",
        type=int,
        default=0,
        help="Starting batch number (only for batched mode, default: 0)",
    )

    args = parser.parse_args()

    normalized = normalize_granularity(args.granularity)
    payload = load_payload(args.input, normalized)

    # Separate hardcoded benchmarks from regular ones
    is_pair = normalized.endswith("pair")

    hardcoded_items = []
    regular_items = []

    for item in payload:
        if "hardcoded_benchmark_path" in item:
            hardcoded_items.append(item)
        else:
            regular_items.append(item)

    def is_safe(spec):
        outer_ok = spec.opcode not in UNSAFE_OPCODES
        inner = getattr(spec, "inner_opcode", None)
        inner_ok = True if inner is None else inner not in UNSAFE_OPCODES
        return outer_ok and inner_ok

    specs = [spec for spec in get_instruction_specs(normalized) if is_safe(spec)]
    spec_lookup = {spec.get_key_str(): spec for spec in specs}
    print(f"Loaded {len(spec_lookup)} instruction specifications", file=sys.stderr)

    # Generate regular benchmarks
    if normalized.endswith("pair"):
        benchmarks = generate_pair_benchmarks(regular_items, spec_lookup)
        file_prefix = f"{normalized}_batch"
    else:
        benchmarks = generate_instruction_benchmarks(regular_items, spec_lookup)
        file_prefix = f"{normalized}_batch"

    print(f"Generated {len(benchmarks)} regular benchmarks", file=sys.stderr)
    if hardcoded_items:
        print(f"Found {len(hardcoded_items)} hardcoded benchmarks", file=sys.stderr)

    # Create output directory
    args.output_dir.mkdir(parents=True, exist_ok=True)

    # Generate regular benchmark files
    if args.batch:
        # Batched mode
        generate_batched_files(
            benchmarks,
            args.output_dir,
            args.batch,
            file_prefix=file_prefix,
            start_batch=args.start_batch,
        )
        num_files = (len(benchmarks) + args.batch - 1) // args.batch
        if args.start_batch > 0:
            print(
                f"✓ Generated {num_files} batch files in {args.output_dir} (starting from batch {args.start_batch})",
                file=sys.stderr,
            )
        else:
            print(
                f"✓ Generated {num_files} batch files in {args.output_dir}",
                file=sys.stderr,
            )
    else:
        # Single file mode - all regular benchmarks in one file
        output_file = args.output_dir / "all_benchmarks.c"
        generate_benchmark_file(benchmarks, output_file)
        print(f"✓ Generated {output_file}", file=sys.stderr)

    # Copy hardcoded benchmark files
    if hardcoded_items:
        script_dir = Path(__file__).parent.parent  # Go up to repo root
        for item in hardcoded_items:
            name = item["name"]
            hardcoded_path = item["hardcoded_benchmark_path"]
            src = script_dir / hardcoded_path
            dst = args.output_dir / f"{name}.c"
            shutil.copy(src, dst)
            print(f"✓ Copied hardcoded benchmark: {dst}", file=sys.stderr)


if __name__ == "__main__":
    main()
