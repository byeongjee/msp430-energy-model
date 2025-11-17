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
    - Dual-operand (add/mov/cmp/sub/and/or/xor/bit/bic/bis): (opcode, src_mode, dst_mode)
    - Single-operand (inc/dec): (opcode, src_mode)
    - Constant-aware (rlam): (opcode, src_mode, constant, dst_mode)
    - Jump (jmp/jge): (opcode, src_mode)

ADDING INSTRUCTIONS:
    1. For dual-operand: add to create_dual_operand_specs()
    2. For single-operand: add to create_single_operand_specs()
    3. For constant-aware: create new function like create_rlam_specs()
    4. Update get_all_instruction_specs() to include new specs
"""

import argparse
from pathlib import Path
from typing import List, Dict, Any, Tuple
from jinja2 import Template

# ============================================================================
# Instruction Specifications
# ============================================================================


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
    """Create instruction specs for dual-operand instructions (add, mov, cmp, etc.)

    Generates all combinations of:
    - 7 source modes: register, immediate, indexed, symbolic, absolute, indirect, indirect_auto
    - 4 destination modes: register, indexed, symbolic, absolute
    Total: 7 × 4 = 28 variants per opcode
    """
    specs = []

    # Define all source and destination modes
    src_modes = ["register", "immediate", "indexed", "symbolic", "absolute", "indirect", "indirect_auto"]
    dst_modes = ["register", "indexed", "symbolic", "absolute"]

    # Helper function to generate assembly template and variables/constraints
    def create_spec(src_mode: str, dst_mode: str) -> InstructionSpec:
        variables = []
        constraints = {"outputs": "", "inputs": "", "clobbers": '"cc"'}

        # Build source operand
        if src_mode == "register":
            src_asm = "%[src]"
            variables.append({"name": "src", "type": "uint16_t", "value": "0x5678"})
            constraints["inputs"] = '[src] "r"(src)'
        elif src_mode == "immediate":
            src_asm = "#0x1357"
        elif src_mode == "indexed":
            src_asm = "%c[offs_src](%[base_src])"
            variables.append({"name": "base_src", "type": "uint16_t*", "value": "BASE_PTR"})
            constraints["inputs"] = '[base_src] "r"(base_src), [offs_src] "i"(OFFS)'
            constraints["clobbers"] = '"cc", "memory"'
        elif src_mode == "symbolic":
            src_asm = "sym_data"
            constraints["clobbers"] = '"cc", "memory"'
        elif src_mode == "absolute":
            src_asm = "&sym_data"
            constraints["clobbers"] = '"cc", "memory"'
        elif src_mode == "indirect":
            src_asm = "@%[psrc]"
            variables.append({"name": "psrc", "type": "uint16_t*", "value": "BASE_PTR"})
            constraints["inputs"] = '[psrc] "r"(psrc)'
            constraints["clobbers"] = '"cc", "memory"'
        elif src_mode == "indirect_auto":
            src_asm = "@%[psrc]+"
            variables.append({"name": "psrc", "type": "uint16_t*", "value": "BASE_PTR"})
            constraints["inputs"] = '[psrc] "r"(psrc)'
            constraints["clobbers"] = '"cc", "memory"'

        # Build destination operand
        if dst_mode == "register":
            dst_asm = "%[dst]"
            variables.append({"name": "dst", "type": "uint16_t", "value": "0x1234"})
            constraints["outputs"] = '[dst] "+r"(dst)'
        elif dst_mode == "indexed":
            dst_asm = "%c[offs_dst](%[base_dst])"
            variables.append({"name": "base_dst", "type": "uint16_t*", "value": "BASE_PTR + 8"})
            # Merge inputs
            if constraints["inputs"]:
                constraints["inputs"] += ", "
            constraints["inputs"] += '[base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)'
            constraints["clobbers"] = '"cc", "memory"'
        elif dst_mode == "symbolic":
            dst_asm = "sym_data"
            constraints["clobbers"] = '"cc", "memory"'
        elif dst_mode == "absolute":
            dst_asm = "&sym_data"
            constraints["clobbers"] = '"cc", "memory"'

        asm_template = f"{opcode}.w {src_asm}, {dst_asm}"

        return InstructionSpec(
            opcode=opcode,
            src_mode=src_mode,
            dst_mode=dst_mode,
            asm_template=asm_template,
            variables=variables,
            constraints=constraints,
        )

    # Generate all combinations
    for src_mode in src_modes:
        for dst_mode in dst_modes:
            specs.append(create_spec(src_mode, dst_mode))

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
# File Generation
# ============================================================================


def generate_benchmark_file(benchmarks: List[Dict[str, Any]], output_path: Path):
    """Generate a single C file with multiple benchmarks"""
    content = FILE_TEMPLATE.render(benchmarks=benchmarks)
    output_path.write_text(content)


def generate_batched_files(
    benchmarks: List[Dict[str, Any]], output_dir: Path, batch_size: int
):
    """Generate C files with specified number of benchmarks per file"""
    for i in range(0, len(benchmarks), batch_size):
        batch = benchmarks[i : i + batch_size]

        # Generate filename
        if batch_size == 1:
            # One file per benchmark - use benchmark name
            filename = f"{batch[0]['name']}.c"
        else:
            # Multiple per file - use batch number
            batch_num = i // batch_size
            filename = f"addressing_mode_batch_{batch_num:04d}.c"

        filepath = output_dir / filename
        content = FILE_TEMPLATE.render(benchmarks=batch)
        filepath.write_text(content)


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
        generate_batched_files(benchmarks, args.output_dir, args.batch)
        num_files = (len(benchmarks) + args.batch - 1) // args.batch
        print(f"✓ Generated {num_files} files in {args.output_dir}")

    # Print statistics
    print(f"\nStatistics:")
    print(f"  Instruction keys: {len(all_specs)}")
    print(f"  Benchmarks: {len(benchmarks)}")
    print(f"  Output directory: {args.output_dir}")


if __name__ == "__main__":
    main()
