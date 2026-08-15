#!/usr/bin/env python3
"""
Test cases for gen_benchmarks.py (addressing_mode granularity)

These tests validate the generated C code and serve as documentation
showing what the generator produces for different instruction variations.

Run with: make test
Or: uv run python scripts/test_generate_addressing_mode_benchmarks.py
"""

import sys
import re
import unittest
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from benchmark.common import (
    InstructionSpec,
    FILE_TEMPLATE,
    get_instruction_specs,
    get_hardcoded_benchmarks,
    get_model_benchmarks,
    create_dint_specs,
    create_dual_operand_specs,
    create_push_specs,
    create_single_operand_specs,
    UNSAFE_OPCODES,
)
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

    def test_xor_register_register_uses_toggle_seeds(self):
        specs = create_dual_operand_specs("xor")
        spec = next(
            s for s in specs if s.src_mode == "register" and s.dst_mode == "register"
        )

        bench = generate_benchmark(spec)

        self.assertIn("uint16_t src = 0xFFFF;", bench["code"])
        self.assertIn("uint16_t dst = 0x0000;", bench["code"])
        self.assertIn("xor.w %[src], %[dst]", bench["code"])

    def test_xor_immediate_register_avoids_constant_generator(self):
        """0xFFFF would assemble to the emulated INV and be measured as inv_register."""
        specs = create_dual_operand_specs("xor")
        spec = next(
            s for s in specs if s.src_mode == "immediate" and s.dst_mode == "register"
        )

        bench = generate_benchmark(spec)

        self.assertIn("xor.w #0xFFFE, %[dst]", bench["code"])
        self.assertIn("uint16_t dst = 0x0000;", bench["code"])

    def test_inv_register_uses_toggle_seed(self):
        specs = create_single_operand_specs("inv")
        spec = next(s for s in specs if s.src_mode == "register")

        bench = generate_benchmark(spec)

        self.assertIn("uint16_t dst = 0x0000;", bench["code"])
        self.assertIn("inv.w %[dst]", bench["code"])

    def test_swpb_register_uses_cross_byte_seed(self):
        specs = create_single_operand_specs("swpb")
        spec = next(s for s in specs if s.src_mode == "register")

        bench = generate_benchmark(spec)

        self.assertIn("uint16_t dst = 0x00FF;", bench["code"])
        self.assertIn("swpb.w %[dst]", bench["code"])

    def test_xor_symbolic_absolute_uses_isolated_memory_symbols(self):
        specs = create_dual_operand_specs("xor")
        spec = next(
            s for s in specs if s.src_mode == "symbolic" and s.dst_mode == "absolute"
        )

        bench = generate_benchmark(spec)

        self.assertIn(
            "static volatile uint16_t bench_xor_symbolic_absolute_src = 0xFFFF;",
            bench["code"],
        )
        self.assertIn(
            "static volatile uint16_t bench_xor_symbolic_absolute_dst = 0x0000;",
            bench["code"],
        )
        self.assertIn(
            "xor.w bench_xor_symbolic_absolute_src, &bench_xor_symbolic_absolute_dst",
            bench["code"],
        )
        self.assertNotIn("xor.w sym_data, &sym_data", bench["code"])

    def test_xor_indexed_indexed_uses_isolated_memory_buffers(self):
        specs = create_dual_operand_specs("xor")
        spec = next(
            s for s in specs if s.src_mode == "indexed" and s.dst_mode == "indexed"
        )

        bench = generate_benchmark(spec)

        self.assertIn(
            "static volatile uint16_t bench_xor_indexed_indexed_src_buf[32]",
            bench["code"],
        )
        self.assertIn(
            "static volatile uint16_t bench_xor_indexed_indexed_dst_buf[32]",
            bench["code"],
        )
        self.assertIn(
            "uint16_t* base_src = bench_xor_indexed_indexed_src_buf;",
            bench["code"],
        )
        self.assertIn(
            "uint16_t* base_dst = bench_xor_indexed_indexed_dst_buf + 8;",
            bench["code"],
        )

    def test_inv_symbolic_uses_isolated_memory_symbol(self):
        specs = create_single_operand_specs("inv")
        spec = next(s for s in specs if s.src_mode == "symbolic")

        bench = generate_benchmark(spec)

        self.assertIn(
            "static volatile uint16_t bench_inv_symbolic_dst = 0x0000;",
            bench["code"],
        )
        self.assertIn("inv.w bench_inv_symbolic_dst", bench["code"])
        self.assertNotIn("inv.w sym_data", bench["code"])

    def test_swpb_indexed_uses_isolated_memory_buffer(self):
        specs = create_single_operand_specs("swpb")
        spec = next(s for s in specs if s.src_mode == "indexed")

        bench = generate_benchmark(spec)

        self.assertIn(
            "static volatile uint16_t bench_swpb_indexed_dst_buf[32]",
            bench["code"],
        )
        self.assertIn(
            "uint16_t* base = bench_swpb_indexed_dst_buf;",
            bench["code"],
        )
        self.assertIn("swpb.w %c[offs](%[base])", bench["code"])

    def test_get_instruction_specs_applies_three_address_pattern_to_indexed_reads(self):
        specs = get_instruction_specs("addressing_mode")
        spec = next(
            s for s in specs if s.get_key() == ("add", "indexed", "register")
        )

        bench = generate_benchmark(spec)

        self.assertIn('".rept " STR(TEXTUAL_REPT) " / 3" "\\n"', bench["code"])
        self.assertIn("uint16_t* base_src0 = BASE_PTR;", bench["code"])
        self.assertIn("uint16_t* base_src1 = (BASE_PTR) + 8;", bench["code"])
        self.assertIn("uint16_t* base_src2 = (BASE_PTR) + 16;", bench["code"])
        self.assertIn(
            '"  add.w %c[offs_src](%[base_src0]), %[dst]\\n"', bench["code"]
        )
        self.assertIn(
            '"  add.w %c[offs_src](%[base_src1]), %[dst]\\n"', bench["code"]
        )
        self.assertIn(
            '"  add.w %c[offs_src](%[base_src2]), %[dst]\\n"', bench["code"]
        )

    def test_get_instruction_specs_skips_three_address_pattern_for_mov_store_only(self):
        specs = get_instruction_specs("addressing_mode")
        spec = next(
            s for s in specs if s.get_key() == ("mov", "register", "indexed")
        )

        bench = generate_benchmark(spec)

        self.assertIn('".rept " STR(TEXTUAL_REPT) "\\n"', bench["code"])
        self.assertIn("uint16_t* base_dst = BASE_PTR + 8;", bench["code"])
        self.assertNotIn("base_dst0", bench["code"])

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
        self.assertIn("bench_add_register_register", file_content)
        self.assertIn("bench_inc_register", file_content)

        # Check BENCH() calls
        self.assertIn("BENCH(bench_add_register_register());", file_content)
        self.assertIn("BENCH(bench_inc_register());", file_content)

    def test_dual_operand_exhaustiveness(self):
        """Verify all 28 combinations are generated for dual-operand instructions

        For each dual-operand instruction, verify we have all combinations of:
        - 7 source modes: register, immediate, indexed, symbolic, absolute, indirect, autoincrement
        - 4 destination modes: register, indexed, symbolic, absolute
        """
        from benchmark.common import create_dual_operand_specs

        specs = create_dual_operand_specs("add")
        self.assertEqual(len(specs), 28)

        # Collect all (src_mode, dst_mode) combinations
        combinations = set()
        for spec in specs:
            combinations.add((spec.src_mode, spec.dst_mode))

        # Expected combinations
        src_modes = ["register", "immediate", "indexed", "symbolic", "absolute", "indirect", "autoincrement"]
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

    def test_autoincrement_uses_readwrite_pointer(self):
        """Autoincrement addressing should treat the pointer register as read-write."""
        specs = create_dual_operand_specs("mov")
        spec = next(
            s for s in specs if s.src_mode == "autoincrement" and s.dst_mode == "register"
        )

        bench = generate_benchmark(spec)

        self.assertIn('[psrc] "+r"(psrc)', bench["code"])
        self.assertNotIn('[psrc] "r"(psrc)', bench["code"])
        self.assertIn("psrc_reset", bench["code"])
        self.assertIn("mov %[psrc_reset], %[psrc]", bench["code"])
        self.assertIn('"memory"', bench["code"])

    def test_push_immediate_clobbers_memory(self):
        """Immediate push should declare a memory clobber because it updates the stack."""
        spec = next(s for s in create_push_specs() if s.src_mode == "immediate")
        bench = generate_benchmark(spec)

        self.assertIn("push.w #0x2222", bench["code"])
        self.assertIn('"memory"', bench["code"])

    def test_indirect_pointer_marked_readwrite(self):
        """Indirect addressing should keep the pointer live with a read-write constraint."""
        specs = create_dual_operand_specs("mov")
        spec = next(
            s for s in specs if s.src_mode == "indirect" and s.dst_mode == "register"
        )

        bench = generate_benchmark(spec)

        self.assertIn('[psrc] "+r"(psrc)', bench["code"])
        self.assertIn('"memory"', bench["code"])


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

    def test_multiplier_register_keys(self):
        """Multiplier-mapped addresses should produce distinct mov keys"""
        specs = get_instruction_specs("addressing_mode")
        lookup = {spec.get_key_str(): spec for spec in specs}

        self.assertIn("mov_MPY_register", lookup)
        self.assertIn("mov_register_MPY", lookup)
        self.assertIn("mov_RESHI_register", lookup)

        read_spec = lookup["mov_MPY_register"]
        bench = generate_benchmark(read_spec)
        self.assertEqual(read_spec.get_key(), ("mov", "MPY", "register"))
        self.assertIn("&0x04c0".lower(), bench["code"].lower())

        reshi_spec = lookup["mov_RESHI_register"]
        reshi_bench = generate_benchmark(reshi_spec)
        self.assertEqual(reshi_spec.get_key(), ("mov", "RESHI", "register"))
        self.assertIn("&0x04cc".lower(), reshi_bench["code"].lower())

    def test_multiplier_register_constant_keys(self):
        """Immediate writes to multiplier registers should carry constants in the key"""
        specs = get_instruction_specs("addressing_mode_constant")
        lookup = {spec.get_key_str(): spec for spec in specs}

        self.assertIn("mov_immediate_1_MPY", lookup)
        spec = lookup["mov_immediate_1_MPY"]
        bench = generate_benchmark(spec)

        self.assertEqual(spec.get_key(), ("mov", "immediate", 1, "MPY"))
        self.assertIn("#1", bench["code"])
        self.assertIn("&0x04c0".lower(), bench["code"].lower())

    def test_no_operand_key(self):
        """No-operand instructions should just be (opcode,)"""
        spec = InstructionSpec(opcode="nop", src_mode=None)
        self.assertEqual(spec.get_key(), ("nop",))

    def test_dint_has_trailing_nop(self):
        """dint benchmark should emit a nop to satisfy assembler warning."""
        spec = create_dint_specs()[0]
        result = generate_benchmark(spec)
        self.assertIn("dint\\n", result["code"])
        self.assertIn("nop\\n", result["code"])


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

        self.assertIn("pushm_and_popm_3", names)
        self.assertIn("pushm_and_popm_5", names)
        composite5 = next(b for b in benches if b["name"] == "pushm_and_popm_5")
        self.assertIn("#5", composite5["code"])
        composite3 = next(b for b in benches if b["name"] == "pushm_and_popm_3")
        self.assertIn("#3", composite3["code"])
        self.assertIn("mov_register_register", names)
        self.assertFalse(
            any(n.startswith("pushm_immediate") or n.startswith("popm_immediate") for n in names)
        )

    def test_push_and_reti_composite(self):
        specs = get_instruction_specs("addressing_mode")
        lookup = {spec.get_key_str(): spec for spec in specs}
        payload = [
            {"key": "push_register"},
            {"key": "reti"},
            {"key": "add_register_register"},
        ]

        benches = generate_instruction_benchmarks(payload, lookup, "addressing_mode")
        names = [b["name"] for b in benches]

        self.assertIn("push_and_reti", names)
        self.assertEqual(names.count("push_and_reti"), 1)
        self.assertIn("add_register_register", names)
        residual_push = [n for n in names if n.startswith("push_") and n != "push_and_reti"]
        self.assertEqual(residual_push, [])
        self.assertNotIn("reti", names)


class TestAllKeysCoverage(unittest.TestCase):
    """Ensure all_keys.txt can be satisfied by the addressing-mode listing."""

    def test_all_keys_covered_by_addressing_mode_listing(self):
        def is_safe(spec: InstructionSpec) -> bool:
            outer_ok = spec.opcode not in UNSAFE_OPCODES
            inner = getattr(spec, "inner_opcode", None)
            inner_ok = True if inner is None else inner not in UNSAFE_OPCODES
            return outer_ok and inner_ok

        instruction_names = {
            spec.get_key_str()
            for spec in get_instruction_specs("addressing_mode")
            if is_safe(spec)
        }
        hardcoded_names = set(get_hardcoded_benchmarks("addressing_mode").keys())
        model_names = {
            entry["name"]
            for entry in get_model_benchmarks("addressing_mode")
            if "name" in entry
        }
        available_names = instruction_names | hardcoded_names | model_names

        all_keys_path = Path(__file__).resolve().parent.parent / "all_keys.txt"
        requested_keys = {
            key for key in re.split(r"[\s,]+", all_keys_path.read_text().strip()) if key
        }

        missing = sorted(requested_keys - available_names)
        self.assertEqual(
            missing,
            [],
            f"Keys in all_keys.txt missing from addressing_mode listing: {missing}",
        )


if __name__ == "__main__":
    unittest.main()
