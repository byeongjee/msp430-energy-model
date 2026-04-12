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

from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
import copy
from typing import List, Dict, Any, Tuple, Optional, Union
from jinja2 import Template


# ============================================================================
# Constants
# ============================================================================

# Benchmarks for these opcodes can corrupt memory or are not yet safely handled.
UNSAFE_OPCODES = set()

COMPOSITE_CALL_AND_RET = "call_and_ret"
COMPOSITE_PUSHM_AND_POPM = "pushm_and_popm"
COMPOSITE_PUSH_AND_RETI = "push_and_reti"
COMPOSITE_PUSH_AND_POP = "push_and_pop"

MULTIPLIER_REGISTERS = [
    ("MPY", 0x04C0),
    ("OP2", 0x04C8),
    ("RESLO", 0x04CA),
    ("RESHI", 0x04CC),
    ("MPY32L", 0x04D0),
    ("MPY32H", 0x04D2),
    ("OP2L", 0x04E0),
    ("OP2H", 0x04E2),
    ("RES0", 0x04E4),
    ("RES1", 0x04E6),
]

JUMP_OPCODES = ["jmp", "jge", "jl", "jnz", "jz", "jnc", "jc", "jn"]

# Dual-operand instructions: opcode src, dst
DUAL_OPERAND_OPCODES = [
    "add",
    "addc",
    "mov",
    "mova",
    "cmp",
    "sub",
    "subc",
    "and",
    "or",
    "xor",
    "bit",
    "bic",
    "bis",
]

# Single-operand instructions: opcode dst
SINGLE_OPERAND_OPCODES = [
    "adc",
    "inc",
    "incd",
    "dec",
    "decd",
    "clr",
    "inv",
    "rla",
    "rlax",
    "rlc",
    "rrc",
    "rrax",
    "rrux",
    "sxt",
    "rra",
    "swpb",
]

# Instructions with immediate constant operand: opcode #const, reg
CONSTANT_OPCODES = ["rlam", "rrum", "pushm", "popm"]

# No-operand instructions
NO_OPERAND_OPCODES = ["clrc", "nop"]


# ============================================================================
# Granularity Enum
# ============================================================================


class Granularity(Enum):
    """Benchmark granularity levels.

    Controls how instruction benchmarks are grouped and what parameters
    are tracked in the energy model.
    """

    OPCODE = "opcode"
    ADDRESSING_MODE = "addressing_mode"
    ADDRESSING_MODE_CONSTANT = "addressing_mode_constant"
    ADDRESSING_MODE_WITH_MEM_ACCESS = "addressing_mode_with_mem_access"
    ADDRESSING_MODE_CONSTANT_WITH_MEM_ACCESS = (
        "addressing_mode_constant_with_mem_access"
    )
    OPCODE_PAIR = "opcode_pair"
    ADDRESSING_MODE_PAIR = "addressing_mode_pair"
    ADDRESSING_MODE_CONSTANT_PAIR = "addressing_mode_constant_pair"

    @property
    def includes_constant(self) -> bool:
        """Whether this granularity tracks constant values in keys."""
        return "constant" in self.value

    @property
    def is_pair(self) -> bool:
        """Whether this is a pair granularity (tracks instruction sequences)."""
        return "pair" in self.value

    @property
    def includes_mem_access(self) -> bool:
        """Whether this granularity includes memory access tracking."""
        return "mem_access" in self.value

    @property
    def base_granularity(self) -> "Granularity":
        """Get the base granularity (without _pair or _with_mem_access suffixes)."""
        base = self.value.replace("_with_mem_access", "").replace("_pair", "")
        return Granularity(base) if base != self.value else self

    @classmethod
    def from_string(cls, s: str) -> "Granularity":
        """Parse a granularity string, handling aliases."""
        normalized = s.lower()
        aliases = {
            "instruction": "addressing_mode",
            "pair": "addressing_mode_pair",
        }
        normalized = aliases.get(normalized, normalized)
        return cls(normalized)


# ============================================================================
# Hardcoded Benchmarks Registry
# ============================================================================
# Instruction-specific benchmarks that cannot be generated programmatically
# and require handwritten C code. These correspond to specific instruction keys
# and are filtered based on whether the instruction is used in the target program.
#
# Each entry maps an instruction key to:
#   - path: Path to the hardcoded C source file
#   - granularities: List of granularities that should include this benchmark
#   - description: Human-readable description
#
# The generation pipeline will copy these files to the output directory
# when the instruction key is required.

SPECIAL_FUNCTION_CALL_GRANULARITIES = [
    "addressing_mode",
    "addressing_mode_constant",
    "addressing_mode_with_mem_access",
    "addressing_mode_constant_with_mem_access",
]

SPECIAL_FUNCTION_CALL_BENCHMARKS = {
    "call___mspabi_divi": "Signed 16-bit division via __mspabi_divi",
    "call___mspabi_divli": "Signed 32-bit division via __mspabi_divli",
    "call___mspabi_divu": "Unsigned 16-bit division via __mspabi_divu",
    "call___mspabi_mpyi": "Signed 16-bit multiplication via __mspabi_mpyi",
    "call___mspabi_mpyl": "Signed 32-bit multiplication via __mspabi_mpyl",
    "call___mspabi_remu": "Unsigned 16-bit remainder via __mspabi_remu",
}

HARDCODED_BENCHMARKS = {
    "br_immediate": {
        "path": "scripts/hardcoded_benchmarks/br_immediate_benchmark.c",
        "granularities": [
            "addressing_mode",
            "addressing_mode_constant",
            "addressing_mode_with_mem_access",
            "addressing_mode_constant_with_mem_access",
        ],
        "description": "Branch with immediate addressing (requires two-pass compilation)",
    },
    "br_indexed": {
        "path": "scripts/hardcoded_benchmarks/br_indexed_benchmark.c",
        "granularities": [
            "addressing_mode",
            "addressing_mode_constant",
            "addressing_mode_with_mem_access",
            "addressing_mode_constant_with_mem_access",
        ],
        "description": "Branch with indexed addressing (requires two-pass compilation)",
    },
    **{
        key: {
            "path": "scripts/hardcoded_benchmarks/special_function_call_benchmark.c",
            "granularities": list(SPECIAL_FUNCTION_CALL_GRANULARITIES),
            "description": f"{description} (requires -mhwmult=none)",
        }
        for key, description in SPECIAL_FUNCTION_CALL_BENCHMARKS.items()
    },
    "call_memcpy": {
        "path": "scripts/hardcoded_benchmarks/memcpy_memset_benchmark.c",
        "granularities": [
            "addressing_mode",
            "addressing_mode_constant",
            "addressing_mode_with_mem_access",
            "addressing_mode_constant_with_mem_access",
        ],
        "description": "memcpy/memset benchmark with varying byte sizes for linear cost model",
    },
    "call_memcpy_bytes": {
        "path": "scripts/hardcoded_benchmarks/memcpy_memset_benchmark.c",
        "granularities": [
            "addressing_mode",
            "addressing_mode_constant",
            "addressing_mode_with_mem_access",
            "addressing_mode_constant_with_mem_access",
        ],
        "description": "memcpy slope parameter (same benchmark file as call_memcpy)",
    },
    "call_memset": {
        "path": "scripts/hardcoded_benchmarks/memcpy_memset_benchmark.c",
        "granularities": [
            "addressing_mode",
            "addressing_mode_constant",
            "addressing_mode_with_mem_access",
            "addressing_mode_constant_with_mem_access",
        ],
        "description": "memset benchmark with varying byte sizes for linear cost model",
    },
    "call_memset_bytes": {
        "path": "scripts/hardcoded_benchmarks/memcpy_memset_benchmark.c",
        "granularities": [
            "addressing_mode",
            "addressing_mode_constant",
            "addressing_mode_with_mem_access",
            "addressing_mode_constant_with_mem_access",
        ],
        "description": "memset slope parameter (same benchmark file as call_memset)",
    },
}


# ============================================================================
# Model Benchmarks Registry
# ============================================================================
# Benchmarks that are always included for certain model types (granularities).
# Unlike HARDCODED_BENCHMARKS, these are not tied to specific instruction keys
# but are needed to train model-specific parameters (e.g., memory access energy).
#
# Keyed by granularity, each entry is a list of benchmarks to include.

MODEL_BENCHMARKS: Dict[str, List[Dict[str, str]]] = {
    "addressing_mode_with_mem_access": [
        {
            "path": "scripts/hardcoded_benchmarks/cache_benchmark.c",
            "description": "FRAM cache hit/miss benchmarks for memory access energy",
        },
    ],
    "addressing_mode_constant_with_mem_access": [
        {
            "path": "scripts/hardcoded_benchmarks/cache_benchmark.c",
            "description": "FRAM cache hit/miss benchmarks for memory access energy",
        },
    ],
}


def get_hardcoded_benchmarks(
    granularity: Union[str, Granularity],
) -> Dict[str, Dict[str, Any]]:
    """Return hardcoded benchmarks that apply to the given granularity.

    Args:
        granularity: The benchmark granularity (Granularity enum or string)

    Returns:
        Dictionary of benchmark_name -> benchmark_info for matching benchmarks
    """
    g = normalize_granularity(granularity)
    return {
        name: info
        for name, info in HARDCODED_BENCHMARKS.items()
        if g in info["granularities"]
    }


def get_model_benchmarks(
    granularity: Union[str, Granularity],
) -> List[Dict[str, str]]:
    """Return model-specific benchmarks for the given granularity.

    These benchmarks are always included when using the specified granularity,
    regardless of which instructions are used in the target program.

    Args:
        granularity: The benchmark granularity (Granularity enum or string)

    Returns:
        List of benchmark info dicts with 'path' and 'description' keys
    """
    g = normalize_granularity(granularity)
    return MODEL_BENCHMARKS.get(g, [])


# ============================================================================
# Instruction Specification
# ============================================================================


def _default_constraints() -> Dict[str, str]:
    """Factory for default constraints dict."""
    return {"outputs": "", "inputs": "", "clobbers": '"cc"'}


@dataclass
class InstructionSpec:
    """Specification for generating a single instruction benchmark.

    This class represents instruction-level benchmarks that can be generated
    programmatically from a template. For special benchmarks that require
    handwritten code (like br_immediate), use the HARDCODED_BENCHMARKS registry.
    For model-specific benchmarks, use the MODEL_BENCHMARKS registry.
    """

    opcode: str
    src_mode: Optional[str] = None
    dst_mode: Optional[str] = None
    constant: Optional[int] = None
    asm_template: str = ""
    post_asm: str = ""
    variables: List[Dict[str, str]] = field(default_factory=list)
    constraints: Dict[str, str] = field(default_factory=_default_constraints)
    key_override: Optional[Tuple] = None
    inner_opcode: Optional[str] = None
    composite_group: Optional[str] = None
    support_declarations: List[str] = field(default_factory=list)

    def get_key(self) -> Tuple:
        """Get the parameter key for this instruction (matches model_common.jl)"""
        if self.key_override is not None:
            return self.key_override

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
# Constraint Builder
# ============================================================================


class ConstraintBuilder:
    """Type-safe builder for GCC inline assembly constraints.

    Avoids error-prone string concatenation when building constraints.

    Example:
        builder = ConstraintBuilder()
        builder.add_output("dst", "+r", "dst")
        builder.add_input("src", "r", "src")
        builder.add_memory_clobber()
        constraints = builder.build()
    """

    def __init__(self):
        self._outputs: List[str] = []
        self._inputs: List[str] = []
        self._clobbers: List[str] = ['"cc"']  # Always clobber condition codes

    def add_output(self, name: str, constraint: str, var: str) -> "ConstraintBuilder":
        """Add an output operand.

        Args:
            name: Operand name (e.g., "dst")
            constraint: Constraint string (e.g., "+r" for read-write register)
            var: C variable name
        """
        self._outputs.append(f'[{name}] "{constraint}"({var})')
        return self

    def add_input(self, name: str, constraint: str, var: str) -> "ConstraintBuilder":
        """Add an input operand.

        Args:
            name: Operand name (e.g., "src")
            constraint: Constraint string (e.g., "r" for register)
            var: C variable name
        """
        self._inputs.append(f'[{name}] "{constraint}"({var})')
        return self

    def add_immediate_input(self, name: str, value: str) -> "ConstraintBuilder":
        """Add an immediate (compile-time constant) input.

        Args:
            name: Operand name (e.g., "offs")
            value: Compile-time constant expression (e.g., "OFFS")
        """
        self._inputs.append(f'[{name}] "i"({value})')
        return self

    def add_memory_clobber(self) -> "ConstraintBuilder":
        """Mark that this instruction may read/write memory."""
        if '"memory"' not in self._clobbers:
            self._clobbers.append('"memory"')
        return self

    def add_register_clobber(self, reg: str) -> "ConstraintBuilder":
        """Mark that this instruction clobbers a specific register.

        Args:
            reg: Register name without quotes (e.g., "r10")
        """
        quoted = f'"{reg}"'
        if quoted not in self._clobbers:
            self._clobbers.append(quoted)
        return self

    def merge(self, other: "ConstraintBuilder") -> "ConstraintBuilder":
        """Merge another builder's constraints into this one.

        Useful for combining constraints from two instructions in a pair.
        """
        for output in other._outputs:
            if output not in self._outputs:
                self._outputs.append(output)
        for inp in other._inputs:
            if inp not in self._inputs:
                self._inputs.append(inp)
        for clobber in other._clobbers:
            if clobber not in self._clobbers:
                self._clobbers.append(clobber)
        return self

    def build(self) -> Dict[str, str]:
        """Build the final constraints dictionary."""
        return {
            "outputs": ", ".join(self._outputs),
            "inputs": ", ".join(self._inputs),
            "clobbers": ", ".join(self._clobbers),
        }


# ============================================================================
# Addressing Mode Definitions
# ============================================================================


@dataclass
class AddressingModeSpec:
    """Specification for an MSP430 addressing mode.

    Describes how to generate assembly syntax and C variables/constraints
    for a particular addressing mode used as source or destination operand.
    """

    # Assembly template pattern (use {prefix} for variable name prefix)
    asm_pattern: str

    # Variables to declare (list of dicts with name_suffix, type, value)
    # name_suffix is appended to the operand prefix (e.g., "src" + "_reset" = "src_reset")
    variables: List[Dict[str, str]] = field(default_factory=list)

    # Whether this mode requires memory clobber
    needs_memory_clobber: bool = False

    # Post-assembly cleanup code (for autoincrement reset)
    post_asm: str = ""

    # For building constraints - list of (name_suffix, constraint_type, is_output)
    # constraint_type is "r" for register, "i" for immediate, "+r" for read-write
    constraint_specs: List[Tuple[str, str, bool]] = field(default_factory=list)


def _build_addressing_mode_specs() -> Dict[str, AddressingModeSpec]:
    """Build the addressing mode specification registry."""
    return {
        # Source modes
        "register": AddressingModeSpec(
            asm_pattern="%[{prefix}]",
            variables=[{"name_suffix": "", "type": "uint16_t", "value": "0x5678"}],
            constraint_specs=[("", "r", False)],  # input
        ),
        "immediate": AddressingModeSpec(
            asm_pattern="#0x1357",
            # No variables or constraints for immediate
        ),
        "indexed": AddressingModeSpec(
            asm_pattern="%c[offs_{prefix}](%[base_{prefix}])",
            variables=[{"name_suffix": "", "type": "uint16_t*", "value": "BASE_PTR"}],
            needs_memory_clobber=True,
            constraint_specs=[
                ("", "r", False),  # base register (input) - named base_{prefix}
            ],
        ),
        "symbolic": AddressingModeSpec(
            asm_pattern="sym_data",
            needs_memory_clobber=True,
        ),
        "absolute": AddressingModeSpec(
            asm_pattern="&sym_data",
            needs_memory_clobber=True,
        ),
        "indirect": AddressingModeSpec(
            asm_pattern="@%[p{prefix}]",
            variables=[{"name_suffix": "", "type": "uint16_t*", "value": "BASE_PTR"}],
            needs_memory_clobber=True,
            constraint_specs=[("", "+r", True)],  # output (read-write pointer)
        ),
        "autoincrement": AddressingModeSpec(
            asm_pattern="@%[p{prefix}]+",
            variables=[
                {"name_suffix": "", "type": "uint16_t*", "value": "BASE_PTR"},
                {"name_suffix": "_reset", "type": "uint16_t*", "value": "BASE_PTR"},
            ],
            needs_memory_clobber=True,
            post_asm="mov %[{prefix}_reset], %[p{prefix}]",
            constraint_specs=[
                ("", "+r", True),  # output (read-write pointer)
                ("_reset", "r", False),  # input (reset value)
            ],
        ),
    }


# Global registry of addressing mode specifications
ADDRESSING_MODE_SPECS = _build_addressing_mode_specs()

# Source and destination mode lists
SOURCE_MODES = [
    "register",
    "immediate",
    "indexed",
    "symbolic",
    "absolute",
    "indirect",
    "autoincrement",
]
DESTINATION_MODES = ["register", "indexed", "symbolic", "absolute"]


# ============================================================================
# Instruction Specification Generators
# ============================================================================

DEFAULT_REGISTER_SRC_VALUE = "0x5678"
DEFAULT_IMMEDIATE_VALUE = "0x1357"
DEFAULT_REGISTER_DST_VALUE = "0x1234"
DEFAULT_SINGLE_OPERAND_DST_VALUE = "0x2222"
DEFAULT_CONSTANT_DST_VALUE = "0x3333"

DUAL_OPERAND_TOGGLE_SEEDS = {
    "xor": {
        "register_src": "0xFFFF",
        "immediate_src": "0xFFFF",
        "register_dst": "0x0000",
    }
}

SINGLE_OPERAND_TOGGLE_SEEDS = {
    "inv": "0x0000",
    "swpb": "0x00FF",
}

ISOLATED_MEMORY_DUAL_OPCODES = {"xor"}
ISOLATED_MEMORY_SINGLE_OPCODES = {"inv", "swpb"}
ISOLATED_MEMORY_BUFFER_SIZE = 16


def get_dual_operand_register_src_value(opcode: str) -> str:
    return DUAL_OPERAND_TOGGLE_SEEDS.get(opcode, {}).get(
        "register_src", DEFAULT_REGISTER_SRC_VALUE
    )


def get_dual_operand_immediate_value(opcode: str) -> str:
    return DUAL_OPERAND_TOGGLE_SEEDS.get(opcode, {}).get(
        "immediate_src", DEFAULT_IMMEDIATE_VALUE
    )


def get_dual_operand_register_dst_value(opcode: str) -> str:
    return DUAL_OPERAND_TOGGLE_SEEDS.get(opcode, {}).get(
        "register_dst", DEFAULT_REGISTER_DST_VALUE
    )


def get_single_operand_register_dst_value(opcode: str) -> str:
    return SINGLE_OPERAND_TOGGLE_SEEDS.get(opcode, DEFAULT_SINGLE_OPERAND_DST_VALUE)


def _make_benchmark_symbol(spec: InstructionSpec, suffix: str) -> str:
    return f"bench_{spec.get_key_str()}_{suffix}"


def _make_isolated_word_declaration(symbol: str, value: str) -> str:
    return f"static volatile uint16_t {symbol} = {value};"


def _make_isolated_buffer_declaration(symbol: str, value: str) -> str:
    if value == "0x0000":
        initializer = "{0}"
    else:
        initializer = (
            "{ [0 ... "
            f"{ISOLATED_MEMORY_BUFFER_SIZE - 1}"
            f"] = {value} }}"
        )
    return (
        f"static volatile uint16_t {symbol}[{ISOLATED_MEMORY_BUFFER_SIZE}] "
        f"__attribute__((aligned(64))) = {initializer};"
    )


def _set_variable_value(
    variables: List[Dict[str, str]], variable_name: str, value: str
) -> None:
    for variable in variables:
        if variable["name"] == variable_name:
            variable["value"] = value
            return
    raise ValueError(f"Variable '{variable_name}' not found in benchmark spec")


def apply_isolated_memory_layout_to_dual_spec(spec: InstructionSpec) -> None:
    if spec.opcode not in ISOLATED_MEMORY_DUAL_OPCODES:
        return
    if spec.src_mode not in {"indexed", "symbolic", "absolute", "indirect", "autoincrement"} and (
        spec.dst_mode not in {"indexed", "symbolic", "absolute"}
    ):
        return

    src_seed = get_dual_operand_register_src_value(spec.opcode)
    dst_seed = get_dual_operand_register_dst_value(spec.opcode)

    if spec.src_mode == "register":
        src_asm = "%[src]"
    elif spec.src_mode == "immediate":
        src_asm = f"#{get_dual_operand_immediate_value(spec.opcode)}"
    elif spec.src_mode == "symbolic":
        src_symbol = _make_benchmark_symbol(spec, "src")
        spec.support_declarations.append(
            _make_isolated_word_declaration(src_symbol, src_seed)
        )
        src_asm = src_symbol
    elif spec.src_mode == "absolute":
        src_symbol = _make_benchmark_symbol(spec, "src")
        spec.support_declarations.append(
            _make_isolated_word_declaration(src_symbol, src_seed)
        )
        src_asm = f"&{src_symbol}"
    elif spec.src_mode == "indexed":
        src_buffer = _make_benchmark_symbol(spec, "src_buf")
        spec.support_declarations.append(
            _make_isolated_buffer_declaration(src_buffer, src_seed)
        )
        _set_variable_value(spec.variables, "base_src", src_buffer)
        src_asm = "%c[offs_src](%[base_src])"
    elif spec.src_mode == "indirect":
        src_buffer = _make_benchmark_symbol(spec, "src_buf")
        spec.support_declarations.append(
            _make_isolated_buffer_declaration(src_buffer, src_seed)
        )
        _set_variable_value(spec.variables, "psrc", src_buffer)
        src_asm = "@%[psrc]"
    else:  # autoincrement
        src_buffer = _make_benchmark_symbol(spec, "src_buf")
        spec.support_declarations.append(
            _make_isolated_buffer_declaration(src_buffer, src_seed)
        )
        _set_variable_value(spec.variables, "psrc", src_buffer)
        _set_variable_value(spec.variables, "psrc_reset", src_buffer)
        src_asm = "@%[psrc]+"

    if spec.dst_mode == "register":
        dst_asm = "%[dst]"
    elif spec.dst_mode == "symbolic":
        dst_symbol = _make_benchmark_symbol(spec, "dst")
        spec.support_declarations.append(
            _make_isolated_word_declaration(dst_symbol, dst_seed)
        )
        dst_asm = dst_symbol
    elif spec.dst_mode == "absolute":
        dst_symbol = _make_benchmark_symbol(spec, "dst")
        spec.support_declarations.append(
            _make_isolated_word_declaration(dst_symbol, dst_seed)
        )
        dst_asm = f"&{dst_symbol}"
    else:
        dst_buffer = _make_benchmark_symbol(spec, "dst_buf")
        spec.support_declarations.append(
            _make_isolated_buffer_declaration(dst_buffer, dst_seed)
        )
        _set_variable_value(spec.variables, "base_dst", f"{dst_buffer} + 8")
        dst_asm = "%c[offs_dst](%[base_dst])"

    spec.asm_template = f"{spec.opcode}.w {src_asm}, {dst_asm}"


def apply_isolated_memory_layout_to_single_spec(spec: InstructionSpec) -> None:
    if spec.opcode not in ISOLATED_MEMORY_SINGLE_OPCODES:
        return
    if spec.src_mode not in {"indexed", "symbolic", "absolute"}:
        return

    dst_seed = get_single_operand_register_dst_value(spec.opcode)

    if spec.src_mode == "symbolic":
        dst_symbol = _make_benchmark_symbol(spec, "dst")
        spec.support_declarations.append(
            _make_isolated_word_declaration(dst_symbol, dst_seed)
        )
        operand_asm = dst_symbol
    elif spec.src_mode == "absolute":
        dst_symbol = _make_benchmark_symbol(spec, "dst")
        spec.support_declarations.append(
            _make_isolated_word_declaration(dst_symbol, dst_seed)
        )
        operand_asm = f"&{dst_symbol}"
    else:
        dst_buffer = _make_benchmark_symbol(spec, "dst_buf")
        spec.support_declarations.append(
            _make_isolated_buffer_declaration(dst_buffer, dst_seed)
        )
        _set_variable_value(spec.variables, "base", dst_buffer)
        operand_asm = "%c[offs](%[base])"

    spec.asm_template = f"{spec.opcode}.w {operand_asm}"


def create_dual_operand_specs(opcode: str) -> List[InstructionSpec]:
    """Create instruction specs for dual-operand instructions (add, mov, cmp, etc.)

    Generates all combinations of:
    - 7 source modes: register, immediate, indexed, symbolic, absolute, indirect, autoincrement
    - 4 destination modes: register, indexed, symbolic, absolute
    Total: 7 × 4 = 28 variants per opcode
    """
    specs = []

    # Helper function to generate assembly template and variables/constraints
    def create_spec(src_mode: str, dst_mode: str) -> InstructionSpec:
        variables = []
        constraints = {"outputs": "", "inputs": "", "clobbers": '"cc"'}
        post_asm = ""

        # Build source operand
        if src_mode == "register":
            src_asm = "%[src]"
            variables.append(
                {
                    "name": "src",
                    "type": "uint16_t",
                    "value": get_dual_operand_register_src_value(opcode),
                }
            )
            constraints["inputs"] = '[src] "r"(src)'
        elif src_mode == "immediate":
            src_asm = f"#{get_dual_operand_immediate_value(opcode)}"
        elif src_mode == "indexed":
            src_asm = "%c[offs_src](%[base_src])"
            variables.append(
                {"name": "base_src", "type": "uint16_t*", "value": "BASE_PTR"}
            )
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
            constraints["outputs"] = '[psrc] "+r"(psrc)'
            constraints["clobbers"] = '"cc", "memory"'
        elif src_mode == "autoincrement":
            src_asm = "@%[psrc]+"
            variables.append({"name": "psrc", "type": "uint16_t*", "value": "BASE_PTR"})
            variables.append(
                {"name": "psrc_reset", "type": "uint16_t*", "value": "BASE_PTR"}
            )
            constraints["outputs"] = '[psrc] "+r"(psrc)'
            constraints["inputs"] = '[psrc_reset] "r"(psrc_reset)'
            constraints["clobbers"] = '"cc", "memory"'
            post_asm = "mov %[psrc_reset], %[psrc]"

        # Build destination operand
        if dst_mode == "register":
            dst_asm = "%[dst]"
            variables.append(
                {
                    "name": "dst",
                    "type": "uint16_t",
                    "value": get_dual_operand_register_dst_value(opcode),
                }
            )
            # Merge with any source-side outputs (e.g., autoincrement pointers)
            if constraints["outputs"]:
                constraints["outputs"] += ", "
            constraints["outputs"] += '[dst] "+r"(dst)'
        elif dst_mode == "indexed":
            dst_asm = "%c[offs_dst](%[base_dst])"
            variables.append(
                {"name": "base_dst", "type": "uint16_t*", "value": "BASE_PTR + 8"}
            )
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

        spec = InstructionSpec(
            opcode=opcode,
            src_mode=src_mode,
            dst_mode=dst_mode,
            asm_template=asm_template,
            post_asm=post_asm,
            variables=variables,
            constraints=constraints,
        )
        apply_isolated_memory_layout_to_dual_spec(spec)
        return spec

    # Generate all combinations
    for src_mode in SOURCE_MODES:
        for dst_mode in DESTINATION_MODES:
            specs.append(create_spec(src_mode, dst_mode))

    return specs


def create_multiplier_mov_specs(include_constant: bool) -> List[InstructionSpec]:
    """Create mov specs that access multiplier-mapped memory addresses.

    These accesses behave differently in hardware and should get distinct parameter keys.
    """
    specs: List[InstructionSpec] = []
    constants = [1, 2, 3, 4, 5] if include_constant else [1]

    for name, addr in MULTIPLIER_REGISTERS:
        hex_addr = f"0x{addr:04X}"

        # Read from multiplier register into a CPU register
        specs.append(
            InstructionSpec(
                opcode="mov",
                src_mode="absolute",
                dst_mode="register",
                asm_template=f"mov.w &{hex_addr}, %[dst]",
                variables=[
                    {
                        "name": "dst",
                        "type": "uint16_t",
                        "value": DEFAULT_REGISTER_DST_VALUE,
                    }
                ],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": "",
                    "clobbers": '"cc", "memory"',
                },
                key_override=("mov", name, "register"),
            )
        )

        # Write a register value into the multiplier register
        specs.append(
            InstructionSpec(
                opcode="mov",
                src_mode="register",
                dst_mode="absolute",
                asm_template=f"mov.w %[src], &{hex_addr}",
                variables=[
                    {
                        "name": "src",
                        "type": "uint16_t",
                        "value": DEFAULT_REGISTER_SRC_VALUE,
                    }
                ],
                constraints={
                    "outputs": "",
                    "inputs": '[src] "r"(src)',
                    "clobbers": '"cc", "memory"',
                },
                key_override=("mov", "register", name),
            )
        )

        # Write an immediate constant into the multiplier register
        for constant in constants:
            specs.append(
                InstructionSpec(
                    opcode="mov",
                    src_mode="immediate",
                    dst_mode="absolute",
                    constant=constant if include_constant else None,
                    asm_template=f"mov.w #{constant}, &{hex_addr}",
                    variables=[],
                    constraints={
                        "outputs": "",
                        "inputs": "",
                        "clobbers": '"cc", "memory"',
                    },
                    key_override=(
                        ("mov", "immediate", constant, name)
                        if include_constant
                        else ("mov", "immediate", name)
                    ),
                )
            )

    return specs


def create_single_operand_specs(opcode: str) -> List[InstructionSpec]:
    """Create instruction specs for single-operand instructions (inc, dec, etc.)"""
    specs = []

    # reg
    spec = InstructionSpec(
            opcode=opcode,
            src_mode="register",
            asm_template=f"{opcode}.w %[dst]",
            variables=[
                {
                    "name": "dst",
                    "type": "uint16_t",
                    "value": get_single_operand_register_dst_value(opcode),
                }
            ],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc"',
            },
        )
    specs.append(spec)

    # idx
    spec = InstructionSpec(
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
    apply_isolated_memory_layout_to_single_spec(spec)
    specs.append(spec)

    # sym
    spec = InstructionSpec(
            opcode=opcode,
            src_mode="symbolic",
            asm_template=f"{opcode}.w sym_data",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'},
        )
    apply_isolated_memory_layout_to_single_spec(spec)
    specs.append(spec)

    # abs
    spec = InstructionSpec(
            opcode=opcode,
            src_mode="absolute",
            asm_template=f"{opcode}.w &sym_data",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'},
        )
    apply_isolated_memory_layout_to_single_spec(spec)
    specs.append(spec)

    return specs


DEFAULT_RPT_COUNTS = list(range(1, 16))


def create_rpt_specs(
    base_specs: List[InstructionSpec],
    repeat_counts: List[int] = None,
    include_constant: bool = False,
) -> List[InstructionSpec]:
    """Wrap base specs into RPT variants.

    - Always generate a register-count variant (non-constant)
    - If include_constant is True, also generate immediate-count variants for repeat_counts
    """
    repeat_counts = repeat_counts or DEFAULT_RPT_COUNTS
    specs: List[InstructionSpec] = []

    for base in base_specs:
        # Register-count variant (non-constant granularity)
        reg_constraints = copy.deepcopy(base.constraints)
        reg_vars = copy.deepcopy(base.variables)
        reg_vars.append({"name": "rcount", "type": "uint16_t", "value": "4"})
        if reg_constraints["inputs"]:
            reg_constraints["inputs"] += ", "
        reg_constraints["inputs"] += '[rcount] "r"(rcount)'
        asm_reg = f"rpt %[rcount] {{ {base.asm_template} }}"
        specs.append(
            InstructionSpec(
                opcode="rpt",
                src_mode="register",
                dst_mode=base.dst_mode,
                constant=None,
                asm_template=asm_reg,
                post_asm=base.post_asm,
                variables=reg_vars,
                constraints=reg_constraints,
                key_override=("rpt", "register", *base.get_key()),
                inner_opcode=base.opcode,
            )
        )

        if include_constant:
            for count in repeat_counts:
                asm = f"rpt #{count} {{ {base.asm_template} }}"
                specs.append(
                    InstructionSpec(
                        opcode="rpt",
                        src_mode="immediate",
                        dst_mode=base.dst_mode,
                        constant=count,
                        asm_template=asm,
                        post_asm=base.post_asm,
                        variables=copy.deepcopy(base.variables),
                        constraints=copy.deepcopy(base.constraints),
                        key_override=("rpt", count, *base.get_key()),
                        inner_opcode=base.opcode,
                    )
                )
    return specs


def create_constant_imm_to_reg_specs(
    opcode: str,
    include_constant: bool,
    composite_group: Optional[str],
    max_constant: int,
) -> List[InstructionSpec]:
    """Create constant-aware instruction specs of the form: opcode #const, reg

    Args:
        opcode: The instruction opcode
        include_constant: Whether to include constant values in keys
        composite_group: Optional composite benchmark group
        max_constant: Maximum constant value to generate (e.g., 4 for rlam/rrum, 16 for pushm/popm)
    """
    specs = []
    constants = list(range(1, max_constant + 1)) if include_constant else [1]
    for constant in constants:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode="immediate",
                dst_mode="register",
                constant=constant if include_constant else None,
                asm_template=f"{opcode} #{constant}, %[dst]",
                variables=[
                    {
                        "name": "dst",
                        "type": "uint16_t",
                        "value": DEFAULT_CONSTANT_DST_VALUE,
                    }
                ],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": "",
                    "clobbers": (
                        '"cc", "memory"' if opcode in {"pushm", "popm"} else '"cc"'
                    ),
                },
                composite_group=composite_group,
            )
        )
    return specs


def create_jump_spec(opcode: str) -> InstructionSpec:
    """Create instruction spec for any jump opcode (jmp, jge, jl, jnz, jz, jnc, jc, jn)"""
    return InstructionSpec(
        opcode=opcode,
        src_mode="symbolic",
        asm_template=f"{opcode} 1f\\n1:",
        variables=[],
        constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
    )


def create_call_specs() -> List[InstructionSpec]:
    """Create instruction specs for call (single operand)"""
    specs = []
    modes = ["register", "immediate", "indexed", "symbolic", "absolute"]

    for mode in modes:
        variables: List[Dict[str, Any]] = []
        constraints = {"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'}

        if mode == "register":
            op_asm = "%[target]"
            variables.append(
                {"name": "target", "type": "uint16_t*", "value": "BASE_PTR"}
            )
            constraints["inputs"] = '[target] "r"(target)'
        elif mode == "immediate":
            op_asm = "#bench_empty_function"
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
                composite_group=COMPOSITE_CALL_AND_RET,
            )
        )

    return specs


def create_no_operand_specs(
    opcode: str, *, composite_group: str = None
) -> List[InstructionSpec]:
    """Create spec for no-operand instructions (e.g., ret)"""
    return [
        InstructionSpec(
            opcode=opcode,
            src_mode=None,
            asm_template=f"{opcode}",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
            composite_group=composite_group,
        )
    ]


def create_dint_specs() -> List[InstructionSpec]:
    """Create spec for dint with a following nop to satisfy assembler requirements."""
    return [
        InstructionSpec(
            opcode="dint",
            src_mode=None,
            asm_template="dint\\n  nop",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
    ]


def create_reti_specs() -> List[InstructionSpec]:
    """Create spec for reti (no operand) grouped with push composite."""
    return create_no_operand_specs("reti", composite_group=COMPOSITE_PUSH_AND_RETI)


def create_push_specs() -> List[InstructionSpec]:
    """Create instruction specs for push (single operand)"""
    specs = []
    modes = ["register", "immediate", "indexed", "symbolic", "absolute"]

    for mode in modes:
        variables: List[Dict[str, Any]] = []
        constraints = {"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'}

        if mode == "register":
            op_asm = "%[src]"
            variables.append(
                {
                    "name": "src",
                    "type": "uint16_t",
                    "value": DEFAULT_SINGLE_OPERAND_DST_VALUE,
                }
            )
            constraints["inputs"] = '[src] "r"(src)'
        elif mode == "immediate":
            op_asm = f"#{DEFAULT_SINGLE_OPERAND_DST_VALUE}"
            constraints["clobbers"] = '"cc", "memory"'
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
                opcode="push",
                src_mode=mode,
                asm_template=f"push.w {op_asm}",
                variables=variables,
                constraints=constraints,
                composite_group=COMPOSITE_PUSH_AND_RETI,
            )
        )

    return specs


def create_pop_specs() -> List[InstructionSpec]:
    """Create instruction specs for pop (single operand, register only)

    Pop is an emulated instruction equivalent to: mov @SP+, dst
    It only supports register destination mode.
    Pop needs to be paired with push for correct stack behavior.
    """
    specs = []

    # Pop only supports register destination
    specs.append(
        InstructionSpec(
            opcode="pop",
            src_mode="register",
            asm_template="pop.w %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0"}],
            constraints={
                "outputs": '[dst] "=r"(dst)',
                "inputs": "",
                "clobbers": '"cc"',
            },
            # Pop must be paired with push for correct stack behavior
            composite_group=COMPOSITE_PUSH_AND_POP,
        )
    )

    return specs


def create_opcode_specs() -> List[InstructionSpec]:
    """Create one representative spec per opcode (granularity: opcode)"""
    specs = []

    for opcode in DUAL_OPERAND_OPCODES:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode=None,
                dst_mode=None,
                asm_template=f"{opcode}.w %[src], %[dst]",
                variables=[
                    {
                        "name": "src",
                        "type": "uint16_t",
                        "value": get_dual_operand_register_src_value(opcode),
                    },
                    {
                        "name": "dst",
                        "type": "uint16_t",
                        "value": get_dual_operand_register_dst_value(opcode),
                    },
                ],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": '[src] "r"(src)',
                    "clobbers": '"cc"',
                },
            )
        )

    for opcode in SINGLE_OPERAND_OPCODES:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode=None,
                asm_template=f"{opcode}.w %[dst]",
                variables=[
                    {
                        "name": "dst",
                        "type": "uint16_t",
                        "value": get_single_operand_register_dst_value(opcode),
                    }
                ],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": "",
                    "clobbers": '"cc"',
                },
            )
        )

    for opcode in CONSTANT_OPCODES:
        specs.append(
            InstructionSpec(
                opcode=opcode,
                src_mode=None,
                asm_template=f"{opcode} #1, %[dst]",
                variables=[
                    {
                        "name": "dst",
                        "type": "uint16_t",
                        "value": DEFAULT_CONSTANT_DST_VALUE,
                    }
                ],
                constraints={
                    "outputs": '[dst] "+r"(dst)',
                    "inputs": "",
                    "clobbers": '"cc"',
                },
            )
        )

    specs.extend(create_call_specs())
    specs.extend(create_push_specs())
    specs.extend(create_pop_specs())

    specs.extend(create_no_operand_specs("clrc"))
    specs.extend(create_dint_specs())
    specs.extend(create_no_operand_specs("ret", composite_group=COMPOSITE_CALL_AND_RET))
    specs.extend(create_reti_specs())

    for opcode in JUMP_OPCODES:
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


def create_addressing_mode_specs(
    include_constant: bool = False,
) -> List[InstructionSpec]:
    """Create specs for addressing-mode-based granularities.

    Args:
        include_constant: Include constant values in keys for constant-aware instructions

    Note: Hardcoded benchmarks (br_immediate, fram_cache) are handled separately
    via the HARDCODED_BENCHMARKS registry.
    """
    specs: List[InstructionSpec] = []

    for opcode in DUAL_OPERAND_OPCODES:
        specs.extend(create_dual_operand_specs(opcode))

    for opcode in SINGLE_OPERAND_OPCODES:
        specs.extend(create_single_operand_specs(opcode))

    specs.extend(create_multiplier_mov_specs(include_constant=include_constant))

    specs.extend(
        create_constant_imm_to_reg_specs("rlam", include_constant, None, 4)
    )
    specs.extend(
        create_constant_imm_to_reg_specs("rrum", include_constant, None, 4)
    )
    specs.extend(
        create_constant_imm_to_reg_specs(
            "pushm", include_constant, COMPOSITE_PUSHM_AND_POPM, 16
        )
    )
    specs.extend(
        create_constant_imm_to_reg_specs(
            "popm", include_constant, COMPOSITE_PUSHM_AND_POPM, 16
        )
    )

    specs.extend(create_call_specs())
    specs.extend(create_push_specs())
    specs.extend(create_pop_specs())

    for jmp_opcode in JUMP_OPCODES:
        specs.append(create_jump_spec(jmp_opcode))

    specs.extend(create_dint_specs())
    specs.extend(create_no_operand_specs("ret", composite_group=COMPOSITE_CALL_AND_RET))
    specs.extend(create_reti_specs())
    specs.extend(create_no_operand_specs("nop"))
    specs.extend(create_no_operand_specs("clrc"))

    # Note: br_immediate and fram_cache benchmarks are handled separately
    # via HARDCODED_BENCHMARKS registry, not through InstructionSpec

    return specs


def normalize_granularity(granularity: Union[str, Granularity]) -> str:
    """Normalize user-facing granularity to canonical string form.

    Args:
        granularity: Either a Granularity enum or a string (with optional aliases)

    Returns:
        Canonical granularity string
    """
    if isinstance(granularity, Granularity):
        return granularity.value
    return Granularity.from_string(granularity).value


def get_instruction_specs(
    granularity: Union[str, Granularity],
) -> List[InstructionSpec]:
    """Return instruction specs for the requested benchmark granularity.

    This returns only programmatically-generated instruction benchmarks.
    For hardcoded benchmarks (br_immediate, fram_cache), use get_hardcoded_benchmarks().

    Args:
        granularity: A Granularity enum value or string

    Note: _with_mem_access variants return the same instruction specs as their
    base variants. The difference is in which hardcoded benchmarks are included.
    """
    if isinstance(granularity, str):
        g = Granularity.from_string(granularity)
    else:
        g = granularity

    # Get the base granularity (strip _pair and _with_mem_access)
    base = g.base_granularity

    if base == Granularity.OPCODE:
        return create_opcode_specs()

    if base == Granularity.ADDRESSING_MODE:
        specs = create_addressing_mode_specs(include_constant=False)
        if not g.is_pair:
            specs.extend(create_rpt_specs(specs, include_constant=False))
        return specs

    if base == Granularity.ADDRESSING_MODE_CONSTANT:
        specs = create_addressing_mode_specs(include_constant=True)
        if not g.is_pair:
            specs.extend(create_rpt_specs(specs, include_constant=True))
        return specs

    raise ValueError(
        f"Unsupported granularity '{granularity}'. "
        f"Expected one of: {[g.value for g in Granularity]}"
    )


# ============================================================================
# Jinja2 Templates
# ============================================================================

FILE_TEMPLATE = Template(
    """#include "setup.h"

#if defined(__GNUC__)
#undef REPEAT_INNER_ITERS
#define REPEAT_INNER_ITERS(X)                                                  \\
  _Pragma("GCC unroll 0")                                                      \\
  for (int _rep_inner_ = 0; _rep_inner_ < (INNER_ITERS); ++_rep_inner_) {      \\
    X;                                                                         \\
  }
#endif

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

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
    start_batch: int = 0,
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
