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
import subprocess
from pathlib import Path
from typing import Any, Dict, List
from jinja2 import Template

from benchmark.common import (
    InstructionSpec,
    generate_benchmark_file,
    generate_batched_files,
    get_instruction_specs,
    get_hardcoded_benchmarks,
    normalize_granularity,
    UNSAFE_OPCODES,
    HARDCODED_BENCHMARKS,
    COMPOSITE_CALL_AND_RET,
    COMPOSITE_PUSHM_AND_POPM,
    COMPOSITE_PUSH_AND_RETI,
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
{%- if post_asm %}
      "  {{ post_asm }}\\n"
{%- endif %}
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
{%- if post_asm %}
      "  {{ post_asm }}\\n"
{%- endif %}
      : {{ constraints.outputs }}
      : {{ constraints.inputs }}
      : {{ constraints.clobbers }}));
}
"""
)


# ============================================================================
# Composite benchmarks
# ============================================================================


def generate_call_and_ret_benchmark(source_keys=None) -> Dict[str, Any]:
    """Generate a composite benchmark that measures call+ret together."""
    name = COMPOSITE_CALL_AND_RET
    code = """
INLINE void bench_call_and_ret(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  call #bench_empty_function\\n"
      ".endr\\n"
      : 
      : 
      : "cc", "memory"));
}
"""
    return {
        "name": name,
        "code": code,
        "key": (name,),
        "source_keys": sorted(source_keys) if source_keys else None,
    }


def generate_pushm_and_popm_benchmark(
    source_keys=None, word_count: int = 1
) -> Dict[str, Any]:
    """Generate a composite benchmark that balances pushm/popm in one loop."""
    name = f"{COMPOSITE_PUSHM_AND_POPM}_{word_count}"
    code = """
INLINE void bench_%(name)s(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  pushm #%(cnt)s, r10\\n"
      "  popm #%(cnt)s, r10\\n"
      ".endr\\n"
      : 
      : 
      : "r10", "r11", "cc", "memory"));
}
""" % {"name": name, "cnt": word_count}
    return {
        "name": name,
        "code": code,
        "key": (COMPOSITE_PUSHM_AND_POPM, word_count),
        "source_keys": sorted(source_keys) if source_keys else None,
        "word_count": word_count,
    }


def generate_push_and_reti_benchmark(source_keys=None) -> Dict[str, Any]:
    """Generate a composite benchmark that measures push+reti via an interrupt stub."""
    name = COMPOSITE_PUSH_AND_RETI
    code = """
INLINE void bench_push_and_reti(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  call #bench_empty_interrupt\\n"
      ".endr\\n"
      : 
      : 
      : "cc", "memory"));
}
"""
    return {
        "name": name,
        "code": code,
        "key": (name,),
        "source_keys": sorted(source_keys) if source_keys else None,
    }


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
        post_asm=spec.post_asm,
    )

    return {
        "name": name,
        "code": code,
        "key": spec.get_key(),
    }


def generate_instruction_benchmarks(
    instructions_data: List[Dict[str, Any]],
    spec_lookup: Dict[str, InstructionSpec],
    granularity: str,
) -> List[Dict[str, Any]]:
    """Generate benchmarks for a list of instruction payloads"""
    benchmarks = []
    composite_requests: Dict[str, Dict[str, Any]] = {}

    for inst_data in instructions_data:
        key = inst_data["key"]

        if key not in spec_lookup:
            print(
                f"Warning: Unknown key '{key}', skipping instruction", file=sys.stderr
            )
            continue

        spec = spec_lookup[key]
        if spec.composite_group:
            if not granularity.startswith("addressing_mode"):
                print(
                    f"Warning: Composite benchmarks not supported for granularity '{granularity}', skipping '{key}'",
                    file=sys.stderr,
                )
                continue
            entry = composite_requests.setdefault(
                spec.composite_group, {"keys": set(), "specs": []}
            )
            entry["keys"].add(key)
            entry["specs"].append(spec)
            continue

        benchmark = generate_benchmark(spec)
        benchmarks.append(benchmark)

    for group, info in composite_requests.items():
        source_keys = info["keys"]
        specs = info["specs"]
        if group == COMPOSITE_CALL_AND_RET:
            benchmarks.append(generate_call_and_ret_benchmark(source_keys))
        elif group == COMPOSITE_PUSHM_AND_POPM:
            # Emit one composite per requested word count (default 1 when missing)
            counts = set()
            for s in specs:
                counts.add(s.constant if s.constant else 1)
            for count in sorted(counts):
                benchmarks.append(
                    generate_pushm_and_popm_benchmark(source_keys, count)
                )
        elif group == COMPOSITE_PUSH_AND_RETI:
            benchmarks.append(generate_push_and_reti_benchmark(source_keys))
        else:
            print(
                f"Warning: Unknown composite group '{group}', skipping", file=sys.stderr
            )

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
    post_lines = [s.post_asm for s in (spec1, spec2) if getattr(s, "post_asm", "")]
    post_asm = "\\n  ".join(post_lines) if post_lines else ""

    code = PAIR_BENCHMARK_FUNCTION_TEMPLATE.render(
        name=name,
        variables=variables,
        instructions=instructions,
        constraints=constraints,
        post_asm=post_asm,
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

        if spec1.composite_group or spec2.composite_group:
            print(
                f"Warning: Composite benchmarks are not supported for pairs (skipping '{key1}' / '{key2}')",
                file=sys.stderr,
            )
            continue

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
            "addressing_mode_with_mem_access",
            "addressing_mode_constant_with_mem_access",
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

    def is_safe(spec):
        outer_ok = spec.opcode not in UNSAFE_OPCODES
        inner = getattr(spec, "inner_opcode", None)
        inner_ok = True if inner is None else inner not in UNSAFE_OPCODES
        return outer_ok and inner_ok

    specs = [spec for spec in get_instruction_specs(normalized) if is_safe(spec)]
    spec_lookup = {spec.get_key_str(): spec for spec in specs}
    print(f"Loaded {len(spec_lookup)} instruction specifications", file=sys.stderr)

    # Generate benchmarks from payload
    if normalized.endswith("pair"):
        benchmarks = generate_pair_benchmarks(payload, spec_lookup)
        file_prefix = f"{normalized}_batch"
    else:
        benchmarks = generate_instruction_benchmarks(payload, spec_lookup, normalized)
        file_prefix = f"{normalized}_batch"

    print(f"Generated {len(benchmarks)} benchmarks", file=sys.stderr)

    # Get hardcoded benchmarks for this granularity from the registry
    hardcoded = get_hardcoded_benchmarks(normalized)
    if hardcoded:
        print(f"Found {len(hardcoded)} hardcoded benchmarks for granularity", file=sys.stderr)

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

    # Generate and copy hardcoded benchmark files from registry
    if hardcoded:
        script_dir = Path(__file__).parent.parent  # Go up to repo root
        compile_script = script_dir / "scripts" / "compile_hardcoded_benchmarks.sh"

        for name, info in hardcoded.items():
            hardcoded_path = info["path"]
            src_c_file = script_dir / hardcoded_path

            # Run two-pass compilation to generate .S file
            print(f"Generating {name}.S via two-pass compilation...", file=sys.stderr)
            try:
                subprocess.run(
                    [str(compile_script), "--file", str(src_c_file)],
                    check=True,
                    cwd=str(script_dir),
                    capture_output=True,
                    text=True,
                )
            except subprocess.CalledProcessError as e:
                print(
                    f"ERROR: Failed to compile hardcoded benchmark {name}",
                    file=sys.stderr,
                )
                print(f"STDOUT: {e.stdout}", file=sys.stderr)
                print(f"STDERR: {e.stderr}", file=sys.stderr)
                raise

            # Copy the generated .S file from build/asm/ to output directory
            basename = src_c_file.stem  # e.g., "br_immediate_benchmark"
            src_s_file = script_dir / "build" / "asm" / f"{basename}.S"
            dst_s_file = args.output_dir / f"{name}.S"

            if not src_s_file.exists():
                print(
                    f"ERROR: Expected .S file not found: {src_s_file}", file=sys.stderr
                )
                raise FileNotFoundError(f"Generated .S file not found: {src_s_file}")

            shutil.copy(src_s_file, dst_s_file)
            print(
                f"✓ Generated and copied hardcoded benchmark: {dst_s_file}",
                file=sys.stderr,
            )


if __name__ == "__main__":
    main()
