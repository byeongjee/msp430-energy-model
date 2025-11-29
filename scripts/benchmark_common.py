#!/usr/bin/env python3
"""
Common utilities for benchmark generation scripts.

This module contains shared code between generate_pair_benchmarks.py
and generate_addressing_mode_benchmarks.py, including:
- InstructionSpec class
- Instruction specification generators (dual-operand, single-operand, etc.)
- Jinja2 templates
- File generation utilities
"""

from pathlib import Path
from typing import List, Dict, Any, Tuple
from jinja2 import Template


# ============================================================================
# Instruction Specification
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


# ============================================================================
# Instruction Specification Generators
# ============================================================================


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


def create_constant_imm_to_reg_specs(opcode: str, include_constant: bool = True) -> List[InstructionSpec]:
    """Create constant-aware instruction specs of the form: opcode #const, reg"""
    specs = []
    constants = [1, 2, 3, 4] if include_constant else [1]
    for constant in constants:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode="immediate",
                dst_mode="register",
                constant=constant if include_constant else None,
                asm_template=f"{opcode} #{constant}, %[dst]",
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


def create_jl_specs() -> List[InstructionSpec]:
    """Create instruction specs for jl (jump if less)"""
    return [
        InstructionSpec(
            opcode="jl",
            src_mode="symbolic",
            asm_template="jl 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_jnz_specs() -> List[InstructionSpec]:
    """Create instruction specs for jnz (jump if not zero)"""
    return [
        InstructionSpec(
            opcode="jnz",
            src_mode="symbolic",
            asm_template="jnz 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_jz_specs() -> List[InstructionSpec]:
    """Create instruction specs for jz (jump if zero)"""
    return [
        InstructionSpec(
            opcode="jz",
            src_mode="symbolic",
            asm_template="jz 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_jnc_specs() -> List[InstructionSpec]:
    """Create instruction specs for jnc (jump if no carry)"""
    return [
        InstructionSpec(
            opcode="jnc",
            src_mode="symbolic",
            asm_template="jnc 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_jc_specs() -> List[InstructionSpec]:
    """Create instruction specs for jc (jump if carry)"""
    return [
        InstructionSpec(
            opcode="jc",
            src_mode="symbolic",
            asm_template="jc 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_jn_specs() -> List[InstructionSpec]:
    """Create instruction specs for jn (jump if negative)"""
    return [
        InstructionSpec(
            opcode="jn",
            src_mode="symbolic",
            asm_template="jn 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_call_specs() -> List[InstructionSpec]:
    """Create instruction specs for call (single operand)"""
    specs = []
    modes = ["register", "indexed", "symbolic", "absolute"]

    for mode in modes:
        variables: List[Dict[str, Any]] = []
        constraints = {"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'}

        if mode == "register":
            op_asm = "%[target]"
            variables.append({"name": "target", "type": "uint16_t*", "value": "BASE_PTR"})
            constraints["inputs"] = '[target] "r"(target)'
        elif mode == "indexed":
            op_asm = "%c[offs](%[base])"
            variables.append({"name": "base", "type": "uint16_t*", "value": "BASE_PTR"})
            constraints["inputs"] = '[base] "r"(base), [offs] "i"(OFFS)'
        elif mode == "symbolic":
            op_asm = "sym_data"
        elif mode == "absolute":
            op_asm = "&sym_data"

        specs.append(
            InstructionSpec(
                opcode="call",
                src_mode=mode,
                asm_template=f"call {op_asm}",
                variables=variables,
                constraints=constraints,
            )
        )

    return specs


def create_no_operand_specs(opcode: str) -> List[InstructionSpec]:
    """Create spec for no-operand instructions (e.g., ret)"""
    return [
        InstructionSpec(
            opcode=opcode,
            src_mode=None,
            asm_template=f"{opcode}",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_opcode_specs() -> List[InstructionSpec]:
    """Create one representative spec per opcode (granularity: opcode)"""
    specs = []

    dual_opcodes = ["add", "addc", "mov", "mova", "cmp", "sub", "subc", "and", "or", "xor", "bit", "bic", "bis"]
    for opcode in dual_opcodes:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode=None,
                dst_mode=None,
                asm_template=f"{opcode}.w %[src], %[dst]",
                variables=[
                    {"name": "src", "type": "uint16_t", "value": "0x5678"},
                    {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                ],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": '[src] "r"(src)',
                    "clobbers": '"cc"',
                },
            )
        )

    single_opcodes = ["inc", "incd", "dec", "decd", "clr", "inv", "rla", "rlc", "rrc", "rrax", "rrux", "sxt"]
    for opcode in single_opcodes:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode=None,
                asm_template=f"{opcode}.w %[dst]",
                variables=[{"name": "dst", "type": "uint16_t", "value": "0x2222"}],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": "",
                    "clobbers": '"cc"',
                },
            )
        )

    constant_opcodes = ["rlam", "rrum", "pushm", "popm"]
    for opcode in constant_opcodes:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode=None,
                asm_template=f"{opcode} #1, %[dst]",
                variables=[{"name": "dst", "type": "uint16_t", "value": "0x3333"}],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": "",
                    "clobbers": '"cc"',
                },
            )
        )

    specs.extend(create_call_specs())

    for opcode in ["clrc", "dint", "ret"]:
        specs.extend(create_no_operand_specs(opcode))

    jump_opcodes = ["jmp", "jge", "jl", "jnz", "jz", "jnc", "jc", "jn"]
    for opcode in jump_opcodes:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode=None,
                asm_template=f"{opcode} 1f\\n1:",
                variables=[],
                constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
            )
        )

    return specs


def create_addressing_mode_specs(include_constant: bool = False) -> List[InstructionSpec]:
    """Create specs for addressing-mode-based granularities"""
    specs: List[InstructionSpec] = []

    dual_opcodes = ["add", "addc", "mov", "mova", "cmp", "sub", "subc", "and", "or", "xor", "bit", "bic", "bis"]
    single_opcodes = ["inc", "incd", "dec", "decd", "clr", "inv", "rla", "rlc", "rrc", "rrax", "rrux", "sxt"]
    jump_opcodes = ["jmp", "jge", "jl", "jnz", "jz", "jnc", "jc", "jn"]
    no_operand_opcodes = ["clrc", "dint", "ret"]

    for opcode in dual_opcodes:
        specs.extend(create_dual_operand_specs(opcode))

    for opcode in single_opcodes:
        specs.extend(create_single_operand_specs(opcode))

    specs.extend(create_constant_imm_to_reg_specs("rlam", include_constant=include_constant))
    specs.extend(create_constant_imm_to_reg_specs("rrum", include_constant=include_constant))
    specs.extend(create_constant_imm_to_reg_specs("pushm", include_constant=include_constant))
    specs.extend(create_constant_imm_to_reg_specs("popm", include_constant=include_constant))

    specs.extend(create_call_specs())

    specs.extend(create_jmp_specs())
    specs.extend(create_jge_specs())
    specs.extend(create_jl_specs())
    specs.extend(create_jnz_specs())
    specs.extend(create_jz_specs())
    specs.extend(create_jnc_specs())
    specs.extend(create_jc_specs())
    specs.extend(create_jn_specs())

    for opcode in no_operand_opcodes:
        specs.extend(create_no_operand_specs(opcode))

    return specs


def normalize_granularity(granularity: str) -> str:
    """Normalize user-facing granularity string to canonical form"""
    g = granularity.lower()
    aliases = {
        "instruction": "addressing_mode",
        "pair": "addressing_mode_pair",
    }
    return aliases.get(g, g)


def get_instruction_specs(granularity: str) -> List[InstructionSpec]:
    """Return instruction specs for the requested benchmark granularity.

    Supported granularities:
        - opcode
        - addressing_mode
        - addressing_mode_constant
        - opcode_pair
        - addressing_mode_pair
        - addressing_mode_constant_pair
    """
    g = normalize_granularity(granularity)

    if g == "opcode":
        return create_opcode_specs()
    if g == "addressing_mode":
        return create_addressing_mode_specs(include_constant=False)
    if g == "addressing_mode_constant":
        return create_addressing_mode_specs(include_constant=True)
    if g == "opcode_pair":
        return create_opcode_specs()
    if g == "addressing_mode_pair":
        return create_addressing_mode_specs(include_constant=False)
    if g == "addressing_mode_constant_pair":
        return create_addressing_mode_specs(include_constant=True)

    raise ValueError(
        f"Unsupported granularity '{granularity}'. Expected one of: "
        "opcode, addressing_mode, addressing_mode_constant, opcode_pair, "
        "addressing_mode_pair, addressing_mode_constant_pair."
    )


# ============================================================================
# Jinja2 Templates
# ============================================================================

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
# File Generation Utilities
# ============================================================================


def generate_benchmark_file(benchmarks: List[Dict[str, Any]], output_path: Path):
    """Generate a single C file with multiple benchmarks"""
    content = FILE_TEMPLATE.render(benchmarks=benchmarks)
    output_path.write_text(content)


def generate_batched_files(
    benchmarks: List[Dict[str, Any]],
    output_dir: Path,
    batch_size: int,
    file_prefix: str = "batch",
    start_batch: int = 0
):
    """Generate C files with specified number of benchmarks per file

    Args:
        benchmarks: List of benchmark dictionaries
        output_dir: Directory to write files to
        batch_size: Number of benchmarks per file
        file_prefix: Prefix for batch filenames (default: "batch")
        start_batch: Starting batch number for incremental generation (default: 0)
    """
    for i in range(0, len(benchmarks), batch_size):
        batch = benchmarks[i : i + batch_size]

        # Generate filename
        if batch_size == 1:
            # One file per benchmark - use benchmark name
            filename = f"{batch[0]['name']}.c"
        else:
            # Multiple per file - use batch number (offset by start_batch)
            batch_num = (i // batch_size) + start_batch
            filename = f"{file_prefix}_{batch_num:04d}.c"

        filepath = output_dir / filename
        content = FILE_TEMPLATE.render(benchmarks=batch)
        filepath.write_text(content)
