#!/usr/bin/env python3
"""
Test cases for gen_benchmarks.py (pair granularities)

These tests validate the generated C code and serve as documentation
showing what the generator produces for different instruction pairs.

Run with: make test
Or: uv run python -m unittest discover -s test/python -k test_generate_pair_benchmarks
"""

import unittest
from pathlib import Path

# Add parent directory to path for imports
from benchmarks.common import (
    InstructionSpec,
    FILE_TEMPLATE,
    create_dual_operand_specs,
    create_single_operand_specs,
)
from benchmarks.gen_benchmarks import generate_pair_benchmark


class TestGeneratedCode(unittest.TestCase):
    """Test actual generated C code against expected output"""

    def test_add_reg_reg__inc_reg(self):
        """Test pair: add reg->reg with inc reg

        This should generate a benchmark that alternates:
        - add.w src, dst
        - inc.w dst
        """
        spec1 = InstructionSpec(
            opcode="add",
            src_mode="register",
            dst_mode="register",
            asm_template="add.w %[src], %[dst]",
            variables=[
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "src", "type": "uint16_t", "value": "0x5678"},
            ],
            constraints={
                "outputs": '"+r"(dst)',
                "inputs": '"r"(src)',
                "clobbers": '"cc"',
            },
        )
        spec2 = InstructionSpec(
            opcode="inc",
            src_mode="register",
            asm_template="inc.w %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x2222"}],
            constraints={"outputs": '"+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )

        result = generate_pair_benchmark(spec1, spec2)

        expected_code = """
INLINE void bench_add_register_register__inc_register(void) {
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  add.w %[src], %[dst]\\n"
      "  inc.w %[dst]\\n"
      ".endr\\n"
      : "+r"(dst)
      : "r"(src)
      : "cc"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())
        self.assertEqual(result["name"], "add_register_register__inc_register")

    def test_mov_imm_reg__cmp_reg_reg(self):
        """Test pair: mov immediate->reg with cmp reg->reg

        This should generate a benchmark that alternates:
        - mov.w #0x1357, dst
        - cmp.w src, dst
        """
        spec1 = InstructionSpec(
            opcode="mov",
            src_mode="immediate",
            dst_mode="register",
            asm_template="mov.w #0x1357, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x1234"}],
            constraints={"outputs": '"+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )
        spec2 = InstructionSpec(
            opcode="cmp",
            src_mode="register",
            dst_mode="register",
            asm_template="cmp.w %[src], %[dst]",
            variables=[
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "src", "type": "uint16_t", "value": "0x5678"},
            ],
            constraints={
                "outputs": '"+r"(dst)',
                "inputs": '"r"(src)',
                "clobbers": '"cc"',
            },
        )

        result = generate_pair_benchmark(spec1, spec2)

        expected_code = """
INLINE void bench_mov_immediate_register__cmp_register_register(void) {
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  mov.w #0x1357, %[dst]\\n"
      "  cmp.w %[src], %[dst]\\n"
      ".endr\\n"
      : "+r"(dst)
      : "r"(src)
      : "cc"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())

    def test_rlam_constant_variants(self):
        """Test rlam with different constants

        Constants should be included in the key and assembly.
        rlam #1 and rlam #2 should produce different benchmarks.
        """
        spec1 = InstructionSpec(
            opcode="rlam",
            src_mode="immediate",
            dst_mode="register",
            constant=1,
            asm_template="rlam #1, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x3333"}],
            constraints={"outputs": '"+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )
        spec2 = InstructionSpec(
            opcode="rlam",
            src_mode="immediate",
            dst_mode="register",
            constant=2,
            asm_template="rlam #2, %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x3333"}],
            constraints={"outputs": '"+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )

        result = generate_pair_benchmark(spec1, spec2)

        # Check keys include constants
        self.assertEqual(result["key1"], ("rlam", "immediate", 1, "register"))
        self.assertEqual(result["key2"], ("rlam", "immediate", 2, "register"))

        # Check name includes constants
        self.assertEqual(
            result["name"], "rlam_immediate_1_register__rlam_immediate_2_register"
        )

        # Check assembly includes correct constants
        self.assertIn("rlam #1", result["code"])
        self.assertIn("rlam #2", result["code"])

    def test_memory_addressing_modes(self):
        """Test pair with memory addressing modes

        Instructions using indexed/symbolic/absolute addressing should
        include 'memory' in clobbers.
        """
        spec1 = InstructionSpec(
            opcode="add",
            src_mode="indexed",
            dst_mode="register",
            asm_template="add.w %c[offs](%[base]), %[dst]",
            variables=[
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "base", "type": "uint16_t*", "value": "BASE_PTR"},
            ],
            constraints={
                "outputs": '"+r"(dst)',
                "inputs": '"r"(base), "i"(OFFS)',
                "clobbers": '"cc", "memory"',
            },
        )
        spec2 = InstructionSpec(
            opcode="inc",
            src_mode="symbolic",
            asm_template="inc.w sym_data",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc", "memory"'},
        )

        result = generate_pair_benchmark(spec1, spec2)

        expected_code = """
INLINE void bench_add_indexed_register__inc_symbolic(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  add.w %c[offs](%[base]), %[dst]\\n"
      "  inc.w sym_data\\n"
      ".endr\\n"
      : "+r"(dst)
      : "i"(OFFS), "r"(base)
      : "cc", "memory"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())

    def test_pair_includes_support_declarations_for_isolated_memory_specs(self):
        spec1 = next(
            s
            for s in create_dual_operand_specs("xor")
            if s.src_mode == "symbolic" and s.dst_mode == "register"
        )
        spec2 = next(
            s for s in create_single_operand_specs("inv") if s.src_mode == "symbolic"
        )

        result = generate_pair_benchmark(spec1, spec2)

        self.assertIn(
            "static volatile uint16_t bench_xor_symbolic_register_src = 0xFFFF;",
            result["code"],
        )
        self.assertIn(
            "static volatile uint16_t bench_inv_symbolic_dst = 0x0000;",
            result["code"],
        )
        self.assertIn(
            "xor.w bench_xor_symbolic_register_src, %[dst]",
            result["code"],
        )
        self.assertIn("inv.w bench_inv_symbolic_dst", result["code"])

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
                {"name": "dst", "type": "uint16_t", "value": "0x1234"},
                {"name": "src", "type": "uint16_t", "value": "0x5678"},
            ],
            constraints={
                "outputs": '"+r"(dst)',
                "inputs": '"r"(src)',
                "clobbers": '"cc"',
            },
        )
        spec2 = InstructionSpec(
            opcode="inc",
            src_mode="register",
            asm_template="inc.w %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x2222"}],
            constraints={"outputs": '"+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )

        bench1 = generate_pair_benchmark(spec1, spec2)
        bench2 = generate_pair_benchmark(spec2, spec1)

        file_content = FILE_TEMPLATE.render(benchmarks=[bench1, bench2])

        # Check file structure
        self.assertIn('#include "setup.h"', file_content)
        self.assertIn("#undef REPEAT_INNER_ITERS", file_content)
        self.assertIn('_Pragma("GCC unroll 0")', file_content)
        self.assertIn("static volatile uint16_t sym_data", file_content)
        self.assertIn("static volatile uint16_t mem_buf[1024]", file_content)
        self.assertIn("#define BASE_PTR", file_content)
        self.assertIn("int main(void)", file_content)
        self.assertIn("initialize();", file_content)
        self.assertIn("begin_measurement_window();", file_content)
        self.assertIn("end_measurement_window();", file_content)

        # Check both benchmarks are present
        self.assertIn("bench_add_register_register__inc_register", file_content)
        self.assertIn("bench_inc_register__add_register_register", file_content)

        # Check BENCH() calls
        self.assertIn(
            "BENCH(bench_add_register_register__inc_register());", file_content
        )
        self.assertIn(
            "BENCH(bench_inc_register__add_register_register());", file_content
        )

    def test_jmp_instruction(self):
        """Test pair with jump instruction

        Jump instructions use symbolic addressing and have special syntax.
        """
        spec1 = InstructionSpec(
            opcode="jmp",
            src_mode="symbolic",
            asm_template="jmp 1f\\n1:",
            variables=[],
            constraints={"outputs": "", "inputs": "", "clobbers": '"cc"'},
        )
        spec2 = InstructionSpec(
            opcode="inc",
            src_mode="register",
            asm_template="inc.w %[dst]",
            variables=[{"name": "dst", "type": "uint16_t", "value": "0x2222"}],
            constraints={"outputs": '"+r"(dst)', "inputs": "", "clobbers": '"cc"'},
        )

        result = generate_pair_benchmark(spec1, spec2)

        expected_code = """
INLINE void bench_jmp_symbolic__inc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\\n"
      "  jmp 1f\\n1:\\n"
      "  inc.w %[dst]\\n"
      ".endr\\n"
      : "+r"(dst)
      : 
      : "cc"));
}
"""
        self.assertEqual(result["code"].strip(), expected_code.strip())



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


if __name__ == "__main__":
    unittest.main()
