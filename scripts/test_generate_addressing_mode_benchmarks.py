#!/usr/bin/env python3
"""
Test cases for gen_benchmarks.py (addressing_mode granularity)

These tests validate the generated C code and serve as documentation
showing what the generator produces for different instruction variations.

Run with: make test
Or: uv run python scripts/test_generate_addressing_mode_benchmarks.py
"""

import unittest
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from benchmark_common import InstructionSpec, FILE_TEMPLATE, get_instruction_specs
from gen_benchmarks import generate_benchmark, generate_instruction_benchmarks


class TestGeneratedCode(unittest.TestCase):
    """Test actual generated C code against expected output"""

    def test_add_reg_reg(self):
        """Test add register->register

        This should generate a benchmark that repeats:
        - add.w src, dst
        """
        spec = InstructionSpec(
            opcode="add",
            src_mode="register",
            dst_mode="register",
            asm_template="add.w %[src], %[dst]",
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

        result = generate_benchmark(spec)

        expected_code = """
INLINE void bench_add_register_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  add.w %[src], %[dst]\\n"
      ".endr\\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())
        self.assertEqual(result["name"], "add_register_register")
        self.assertEqual(result["key"], ("add", "register", "register"))

    def test_mov_imm_reg(self):
        """Test mov immediate->register

        This should generate a benchmark that repeats:
        - mov.w #0x1357, dst
        """
        spec = InstructionSpec(
            opcode="mov",
            src_mode="immediate",
            dst_mode="register",
            asm_template="mov.w #0x1357, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x1234"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc"',
            },
        )

        result = generate_benchmark(spec)

        expected_code = """
INLINE void bench_mov_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  mov.w #0x1357, %[dst]\\n"
      ".endr\\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())

    def test_add_indexed_indexed(self):
        """Test add indexed->indexed

        This should generate a benchmark with memory addressing on both sides.
        """
        spec = InstructionSpec(
            opcode="add",
            src_mode="indexed",
            dst_mode="indexed",
            asm_template="add.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])",
            variables=[
                {"name": "base_src", "type": "uint16_t*", "value": "BASE_PTR"},
                {"name": "base_dst", "type": "uint16_t*", "value": "BASE_PTR + 8"},
            ],
            constraints={
                "outputs": "",
                "inputs": '[base_src] "r"(base_src), [offs_src] "i"(OFFS), [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)',
                "clobbers": '"cc", "memory"',
            },
        )

        result = generate_benchmark(spec)

        expected_code = """
INLINE void bench_add_indexed_indexed(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  add.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\\n"
      ".endr\\n"
      : 
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS), [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())

    def test_inc_register(self):
        """Test inc register (single operand)

        This should generate a benchmark that repeats:
        - inc.w dst
        """
        spec = InstructionSpec(
            opcode="inc",
            src_mode="register",
            asm_template="inc.w %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x2222"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc"',
            },
        )

        result = generate_benchmark(spec)

        expected_code = """
INLINE void bench_inc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  inc.w %[dst]\\n"
      ".endr\\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())
        self.assertEqual(result["key"], ("inc", "register"))

    def test_rlam_constant_variants(self):
        """Test rlam with different constants

        Constants should be included in the key and assembly.
        """
        spec1 = InstructionSpec(
            opcode="rlam",
            src_mode="immediate",
            dst_mode="register",
            constant=1,
            asm_template="rlam #1, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x3333"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc"',
            },
        )
        spec2 = InstructionSpec(
            opcode="rlam",
            src_mode="immediate",
            dst_mode="register",
            constant=2,
            asm_template="rlam #2, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x3333"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc"',
            },
        )

        result1 = generate_benchmark(spec1)
        result2 = generate_benchmark(spec2)

        # Check keys include constants
        self.assertEqual(result1["key"], ("rlam", "immediate", 1, "register"))
        self.assertEqual(result2["key"], ("rlam", "immediate", 2, "register"))

        # Check names include constants
        self.assertEqual(result1["name"], "rlam_immediate_1_register")
        self.assertEqual(result2["name"], "rlam_immediate_2_register")

        # Check assembly includes correct constants
        self.assertIn("rlam #1", result1["code"])
        self.assertIn("rlam #2", result2["code"])

    def test_full_file_generation(self):
        """Test generating a complete C file with multiple benchmarks

        The file should include:
        - Header includes
        - Global variable declarations
        - All benchmark functions
        - main() with BENCH() calls for each
        """
        # Create two simple benchmarks
        spec1 = InstructionSpec(
            opcode="add",
            src_mode="register",
            dst_mode="register",
            asm_template="add.w %[src], %[dst]",
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
        spec2 = InstructionSpec(
            opcode="inc",
            src_mode="register",
            asm_template="inc.w %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x2222"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc"',
            },
        )

        bench1 = generate_benchmark(spec1)
        bench2 = generate_benchmark(spec2)

        file_content = FILE_TEMPLATE.render(benchmarks=[bench1, bench2])

        # Check file structure
        self.assertIn('#include "setup.h"', file_content)
        self.assertIn("static volatile uint16_t sym_data", file_content)
        self.assertIn("static volatile uint16_t mem_buf[64]", file_content)
        self.assertIn("#define BASE_PTR", file_content)
        self.assertIn("int main(void)", file_content)
        self.assertIn("initialize();", file_content)
        self.assertIn("begin_measurement_window();", file_content)
        self.assertIn("end_measurement_window();", file_content)

        # Check both benchmarks are present
        self.assertIn("bench_add_register_register", file_content)
        self.assertIn("bench_inc_register", file_content)

        # Check BENCH() calls
        self.assertIn("BENCH(bench_add_register_register());", file_content)
        self.assertIn("BENCH(bench_inc_register());", file_content)

    def test_dual_operand_exhaustiveness(self):
        """Verify all 28 combinations are generated for dual-operand instructions

        For each dual-operand instruction, verify we have all combinations of:
        - 7 source modes: register, immediate, indexed, symbolic, absolute, indirect, indirect_auto
        - 4 destination modes: register, indexed, symbolic, absolute
        """
        from benchmark_common import create_dual_operand_specs

        specs = create_dual_operand_specs("add")
        self.assertEqual(len(specs), 28)

        # Collect all (src_mode, dst_mode) combinations
        combinations = set()
        for spec in specs:
            combinations.add((spec.src_mode, spec.dst_mode))

        # Expected combinations
        src_modes = ["register", "immediate", "indexed", "symbolic", "absolute", "indirect", "indirect_auto"]
        dst_modes = ["register", "indexed", "symbolic", "absolute"]

        expected_combinations = set()
        for src in src_modes:
            for dst in dst_modes:
                expected_combinations.add((src, dst))

        self.assertEqual(combinations, expected_combinations)

    def test_symbolic_addressing(self):
        """Test symbolic addressing mode

        Symbolic addressing should use sym_data and include memory clobber.
        """
        spec = InstructionSpec(
            opcode="mov",
            src_mode="symbolic",
            dst_mode="register",
            asm_template="mov.w sym_data, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x1234"}],
            constraints={
                "outputs": '[dst] "+r"(dst)',
                "inputs": "",
                "clobbers": '"cc", "memory"',
            },
        )

        result = generate_benchmark(spec)

        self.assertIn("sym_data", result["code"])
        self.assertIn('"memory"', result["code"])
        self.assertEqual(result["key"], ("mov", "symbolic", "register"))


class TestKeyGeneration(unittest.TestCase):
    """Test that instruction keys match model_common.jl conventions"""

    def test_dual_operand_key(self):
        """Dual operand keys should be (opcode, src_mode, dst_mode)"""
        spec = InstructionSpec(opcode="add", src_mode="register", dst_mode="register")
        self.assertEqual(spec.get_key(), ("add", "register", "register"))

    def test_single_operand_key(self):
        """Single operand keys should be (opcode, src_mode)"""
        spec = InstructionSpec(opcode="inc", src_mode="register")
        self.assertEqual(spec.get_key(), ("inc", "register"))

    def test_constant_aware_key(self):
        """Constant-aware keys should be (opcode, src_mode, constant, dst_mode)"""
        spec = InstructionSpec(
            opcode="rlam", src_mode="immediate", dst_mode="register", constant=2
        )
        self.assertEqual(spec.get_key(), ("rlam", "immediate", 2, "register"))

    def test_no_operand_key(self):
        """No-operand instructions should just be (opcode,)"""
        spec = InstructionSpec(opcode="nop", src_mode=None)
        self.assertEqual(spec.get_key(), ("nop",))


class TestCompositeGeneration(unittest.TestCase):
    """Ensure composite benchmarks are emitted for supported opcodes"""

    def test_call_and_ret_composite(self):
        specs = get_instruction_specs("addressing_mode")
        lookup = {spec.get_key_str(): spec for spec in specs}
        payload = [{"key": "call_immediate"}, {"key": "ret"}]

        benches = generate_instruction_benchmarks(
            payload, lookup, "addressing_mode"
        )
        names = [b["name"] for b in benches]

        self.assertIn("call_and_ret", names)
        self.assertEqual(names.count("call_and_ret"), 1)
        self.assertNotIn("call_immediate", names)

    def test_pushm_and_popm_composite(self):
        specs = get_instruction_specs("addressing_mode_constant")
        lookup = {spec.get_key_str(): spec for spec in specs}
        payload = [
            {"key": "pushm_immediate_3_register"},
            {"key": "popm_immediate_5_register"},
            {"key": "mov_register_register"},
        ]

        benches = generate_instruction_benchmarks(
            payload, lookup, "addressing_mode_constant"
        )
        names = [b["name"] for b in benches]

        self.assertIn("pushm_and_popm", names)
        self.assertEqual(names.count("pushm_and_popm"), 1)
        self.assertIn("mov_register_register", names)
        self.assertFalse(
            any(n.startswith("pushm_immediate") or n.startswith("popm_immediate") for n in names)
        )


if __name__ == "__main__":
    unittest.main()
