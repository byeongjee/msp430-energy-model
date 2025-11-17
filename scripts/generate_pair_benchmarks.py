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
    - add/mov/cmp: 7 variants each (reg->reg, imm->reg, idx->reg, sym->reg, abs->reg, ind->reg, aut->reg)
    - inc: 4 variants (reg, idx, sym, abs)
    - rlam: 4 variants (constants 1, 2, 3, 4)
    - jmp: 1 variant (symbolic)
    - jge: 1 variant (symbolic)
    - ...

ADDING INSTRUCTIONS:
    1. For dual-operand (add, sub, etc): add to create_dual_operand_specs()
    2. For single-operand (inc, dec, etc): add to create_single_operand_specs()
    3. For special (rlam, jmp, etc): create new function like create_rlam_specs()
    4. Update get_all_instruction_specs() to include new specs
    5. Run tests: make test

TESTS:
    See test_generate_pair_benchmarks.py for snapshot tests showing expected C output.
"""

import argparse
from pathlib import Path
from typing import List, Dict, Any, Tuple
from itertools import combinations
from jinja2 import Template

# ============================================================================
# Instruction Specifications
# ============================================================================

# Each instruction specification defines how to generate assembly code for that instruction key
# Based on model_common.jl, keys are: (opcode, src_mode, dst_mode) or (opcode, src_mode, constant, dst_mode)

# Addressing modes used in MSP430
# - register: register direct
# - immediate: immediate value
# - indexed: indexed addressing X(Rn)
# - symbolic: symbolic/PC-relative
# - absolute: absolute addressing &addr
# - indirect: indirect register @Rn
# - indirect_auto: indirect autoincrement @Rn+


class InstructionSpec:
    """Specification for generating a single instruction instance"""

    def __init__(
        self,
        opcode: str,
        src_mode: str,
        dst_mode: str = None,
        constant: int = None,
        asm_template: str = "",
        variables: List[Dict[str, str]] = None,
        constraints: Dict[str, str] = None,
    ):
        self.opcode = opcode
        self.src_mode = src_mode
        self.dst_mode = dst_mode
        self.constant = constant
        self.asm_template = asm_template
        self.variables = variables or []
        self.constraints = constraints or {
            "outputs": "",
            "inputs": "",
            "clobbers": '"cc"',
        }

    def get_key(self) -> Tuple:
        """Get the parameter key for this instruction (matches model_common.jl)"""
        if self.dst_mode is None:
            # Single operand or no operand
            return (self.opcode, self.src_mode) if self.src_mode else (self.opcode,)
        elif self.constant is not None:
            # Constant-aware instruction
            return (self.opcode, self.src_mode, self.constant, self.dst_mode)
        else:
            # Dual operand
            return (self.opcode, self.src_mode, self.dst_mode)

    def get_key_str(self) -> str:
        """Get string representation of the key"""
        return "_".join(str(k) for k in self.get_key())


def create_dual_operand_specs(opcode: str) -> List[InstructionSpec]:
    """Create instruction specs for dual-operand instructions (add, mov, cmp, etc.)"""
    specs = []

    # ========== Destination: register ==========
    # reg -> reg
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="register",
            dst_mode="register",
            asm_template=f"{opcode}.w %[src], %[dst]",
            variables=[
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "src", "type": "uint16_t", "value": "0x5678"},
            ],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": '[src] "r"(src)',
                "clobbers": '"cc"',
            },
        )
    )

    # imm -> reg
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="immediate",
            dst_mode="register",
            asm_template=f"{opcode}.w #0x1357, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x1234"}],
            constraints={"outputs": '[dst] "+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )
    )

    # idx -> reg
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="indexed",
            dst_mode="register",
            asm_template=f"{opcode}.w %c[offs](%[base]), %[dst]",
            variables=[
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "base", "type": "uint16_t*", "value": "BASE_PTR"},
            ],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": '[base] "r"(base), [offs] "i"(OFFS)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # sym -> reg
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="symbolic",
            dst_mode="register",
            asm_template=f"{opcode}.w sym_data, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x1234"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # abs -> reg
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="absolute",
            dst_mode="register",
            asm_template=f"{opcode}.w &sym_data, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x1234"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # ind -> reg
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="indirect",
            dst_mode="register",
            asm_template=f"{opcode}.w @%[psrc], %[dst]",
            variables=[
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "psrc", "type": "uint16_t*", "value": "BASE_PTR"},
            ],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": '[psrc] "r"(psrc)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # aut -> reg (indirect autoincrement)
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="indirect_auto",
            dst_mode="register",
            asm_template=f"{opcode}.w @%[psrc]+, %[dst]",
            variables=[
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "psrc", "type": "uint16_t*", "value": "BASE_PTR"},
            ],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": '[psrc] "r"(psrc)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # ========== Destination: indexed ==========
    # imm -> idx
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="immediate",
            dst_mode="indexed",
            asm_template=f"{opcode}.w #0x1357, %c[offs](%[base])",
            variables=[{"name": "base", "type": "uint16_t*", "value": "BASE_PTR"}],
            constraints={
                "outputs": "",
                "inputs": '[base] "r"(base), [offs] "i"(OFFS)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # reg -> idx
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="register",
            dst_mode="indexed",
            asm_template=f"{opcode}.w %[src], %c[offs](%[base])",
            variables=[
                {"name": "src", "type": "uint16_t", "value": "0x5678"},
                {"name": "base", "type": "uint16_t*", "value": "BASE_PTR"},
            ],
            constraints={
                "outputs": "",
                "inputs": '[src] "r"(src), [base] "r"(base), [offs] "i"(OFFS)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # ========== Destination: symbolic ==========
    # imm -> sym
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="immediate",
            dst_mode="symbolic",
            asm_template=f"{opcode}.w #0x1357, sym_data",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'},
        )
    )

    # reg -> sym
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="register",
            dst_mode="symbolic",
            asm_template=f"{opcode}.w %[src], sym_data",
            variables=[{"name": "src", "type": "uint16_t", "value": "0x5678"}],
            constraints={
                "outputs": "",
                "inputs": '[src] "r"(src)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # ========== Destination: absolute ==========
    # imm -> abs
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="immediate",
            dst_mode="absolute",
            asm_template=f"{opcode}.w #0x1357, &sym_data",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'},
        )
    )

    # reg -> abs
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="register",
            dst_mode="absolute",
            asm_template=f"{opcode}.w %[src], &sym_data",
            variables=[{"name": "src", "type": "uint16_t", "value": "0x5678"}],
            constraints={
                "outputs": "",
                "inputs": '[src] "r"(src)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    return specs


def create_single_operand_specs(opcode: str) -> List[InstructionSpec]:
    """Create instruction specs for single-operand instructions (inc, dec, etc.)"""
    specs = []

    # reg
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="register",
            asm_template=f"{opcode}.w %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x2222"}],
            constraints={"outputs": '[dst] "+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )
    )

    # idx
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="indexed",
            asm_template=f"{opcode}.w %c[offs](%[base])",
            variables=[{"name": "base", "type": "uint16_t*", "value": "BASE_PTR"}],
            constraints={
                "outputs": "",
                "inputs": '[base] "r"(base), [offs] "i"(OFFS)',
                "clobbers": '"cc", "memory"',
            },
        )
    )

    # sym
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="symbolic",
            asm_template=f"{opcode}.w sym_data",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'},
        )
    )

    # abs
    specs.append(
        InstructionSpec(
            opcode=opcode,
            src_mode="absolute",
            asm_template=f"{opcode}.w &sym_data",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'},
        )
    )

    return specs


def create_rlam_specs() -> List[InstructionSpec]:
    """Create instruction specs for rlam (constant-aware instruction)"""
    specs = []
    for constant in [1, 2, 3, 4]:
        specs.append(
            InstructionSpec(
                opcode="rlam",
                src_mode="immediate",
                dst_mode="register",
                constant=constant,
                asm_template=f"rlam #{constant}, %[dst]",
                variables=[{"name": "dst", "type": "uint16_t", "value": "0x3333"}],
                constraints={"outputs": '[dst] "+r"(dst)', "inputs": "", "clobbers": '"cc"'},
            )
        )
    return specs


def create_jmp_specs() -> List[InstructionSpec]:
    """Create instruction specs for jmp"""
    return [
        InstructionSpec(
            opcode="jmp",
            src_mode="symbolic",
            asm_template="jmp 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_jge_specs() -> List[InstructionSpec]:
    """Create instruction specs for jge (conditional jump)"""
    return [
        InstructionSpec(
            opcode="jge",
            src_mode="symbolic",
            asm_template="jge 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


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

FILE_TEMPLATE = Template(
    """#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4

{% for bench in benchmarks %}
{{ bench.code }}
{%- endfor %}

int main(void) {
  initialize();
  begin_measurement_window();

{% for bench in benchmarks %}
  BENCH(bench_{{ bench.name }}());
{%- endfor %}

  end_measurement_window();

  return 0;
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
# File Generation
# ============================================================================


def generate_benchmark_file(benchmarks: List[Dict[str, Any]], output_path: Path):
    """Generate a single C file with multiple benchmarks"""
    content = FILE_TEMPLATE.render(benchmarks=benchmarks)
    output_path.write_text(content)


def generate_batched_files(
    benchmarks: List[Dict[str, Any]], output_dir: Path, batch_size: int
):
    """Generate C files with specified number of benchmarks per file

    Args:
        benchmarks: List of benchmark dictionaries
        output_dir: Directory to write files to
        batch_size: Number of benchmarks per file
    """
    for i in range(0, len(benchmarks), batch_size):
        batch = benchmarks[i : i + batch_size]

        # Generate filename
        if batch_size == 1:
            # One file per benchmark - use benchmark name
            filename = f"{batch[0]['name']}.c"
        else:
            # Multiple per file - use batch number
            batch_num = i // batch_size
            filename = f"pairs_batch_{batch_num:04d}.c"

        filepath = output_dir / filename
        content = FILE_TEMPLATE.render(benchmarks=batch)
        filepath.write_text(content)


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
        generate_batched_files(benchmarks, args.output_dir, args.batch)
        num_files = (len(benchmarks) + args.batch - 1) // args.batch
        print(f"✓ Generated {num_files} files in {args.output_dir}")

    # Print statistics
    print(f"\nStatistics:")
    print(f"  Instruction keys: {len(all_specs)}")
    print(f"  Pair benchmarks: {len(benchmarks)}")
    print(f"  Output directory: {args.output_dir}")


if __name__ == "__main__":
    main()
