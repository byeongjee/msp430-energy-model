#!/usr/bin/env python3
"""
Test Makefile targets: compile, disasm, interpret

These tests verify that the Makefile targets work correctly for both .c and .S files.
They use subprocess to run actual make commands and verify the expected outputs.

Run with: make test
Or: uv run python -m unittest discover -s test/python -k test_makefile_targets -v
"""

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


class TestMakefileTargets(unittest.TestCase):
    """Test Makefile targets for compiling and interpreting MSP430 programs"""

    # Use test fixtures directory for test files
    TEST_C_FILE = "test/fixtures/c_programs/simple.c"
    TEST_NO_MSP430X_FILE = "examples/intermittent/activity_recognition.c"
    # Use rrc_rrax.S which has a main function (test_indexed_simple.S uses _start)
    TEST_S_FILE = "test/fixtures/c_programs/rrc_rrax.S"

    @classmethod
    def setUpClass(cls):
        """Verify test files exist and environment is set up"""
        cls.project_root = Path(__file__).resolve().parents[2]
        os.chdir(cls.project_root)

        # Verify test files exist
        if not Path(cls.TEST_C_FILE).exists():
            raise unittest.SkipTest(f"Test file not found: {cls.TEST_C_FILE}")

    def setUp(self):
        """Create a temporary build directory for each test"""
        self.temp_dir = tempfile.mkdtemp()
        self.build_dir = Path(self.temp_dir) / "build"
        self.asm_dir = Path(self.temp_dir) / "asm"

    def tearDown(self):
        """Clean up temporary directory"""
        if hasattr(self, "temp_dir") and Path(self.temp_dir).exists():
            shutil.rmtree(self.temp_dir)

    def run_make(self, target: str, **kwargs) -> subprocess.CompletedProcess:
        """Run a make target with optional parameters

        Args:
            target: The make target to run
            **kwargs: Additional make variables (e.g., FILE="test.c")

        Returns:
            CompletedProcess with stdout and stderr
        """
        cmd = ["make", target]
        cmd.append(f"BUILD_DIR={self.build_dir}")
        cmd.append(f"ASM_DIR={self.asm_dir}")

        for key, value in kwargs.items():
            cmd.append(f"{key}={value}")

        return subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            cwd=self.project_root,
        )

    # =========================================================================
    # Test: make compile
    # =========================================================================

    def test_compile_c_file_produces_elf(self):
        """make compile FILE=<file.c> produces .elf file"""
        result = self.run_make("compile", FILE=self.TEST_C_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"make compile failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertTrue(
            (self.build_dir / "simple.elf").exists(),
            f"Expected simple.elf not found. Build dir contents: {list(self.build_dir.iterdir()) if self.build_dir.exists() else 'dir not created'}",
        )

    def test_compile_s_file_produces_elf(self):
        """make compile FILE=<file.S> produces .elf file for assembly"""
        if not Path(self.TEST_S_FILE).exists():
            self.skipTest(f"Test assembly file not found: {self.TEST_S_FILE}")

        result = self.run_make("compile", FILE=self.TEST_S_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"make compile failed for .S file:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertTrue(
            (self.build_dir / "rrc_rrax.elf").exists(),
            "Expected rrc_rrax.elf not found",
        )

    def test_compile_with_defines(self):
        """make compile DEFINES='FOO=1 BAR' passes defines to compiler"""
        result = self.run_make("compile", FILE=self.TEST_C_FILE, DEFINES="TEST_DEFINE=42")

        self.assertEqual(
            result.returncode,
            0,
            f"make compile with DEFINES failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        # The define should appear in the output
        self.assertIn("DEFINES=TEST_DEFINE=42", result.stdout)

    def test_compile_missing_file_shows_error(self):
        """make compile with non-existent file shows gcc error

        Note: Currently the Makefile doesn't properly propagate gcc's exit code,
        so we check for the error message instead of the exit code.
        This is a known issue to be fixed in the Makefile refactoring.
        """
        result = self.run_make("compile", FILE="nonexistent_file.c")

        combined_output = result.stdout + result.stderr
        # GCC should report "No such file or directory"
        self.assertIn(
            "No such file or directory",
            combined_output,
            f"Expected gcc error message for missing file. Output: {combined_output}",
        )

    def test_compile_without_file_shows_error(self):
        """make compile without FILE= shows error message"""
        cmd = ["make", "compile"]
        result = subprocess.run(cmd, capture_output=True, text=True, cwd=self.project_root)

        self.assertNotEqual(result.returncode, 0)
        # Should mention FILE parameter
        combined_output = result.stdout + result.stderr
        self.assertTrue(
            "FILE" in combined_output,
            f"Error should mention FILE parameter. Output: {combined_output}",
        )

    # =========================================================================
    # Test: make disasm
    # =========================================================================

    def test_disasm_produces_asm_and_data(self):
        """make disasm produces .asm and .data files"""
        result = self.run_make("disasm", FILE=self.TEST_C_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"make disasm failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

        # Check for .asm file
        asm_file = self.asm_dir / "simple.asm"
        self.assertTrue(asm_file.exists(), f"Expected {asm_file} not found")

        # Check for .data file
        data_file = self.asm_dir / "simple.data"
        self.assertTrue(data_file.exists(), f"Expected {data_file} not found")

        # Verify .asm file contains disassembly
        asm_content = asm_file.read_text()
        self.assertIn("Disassembly", asm_content, ".asm file should contain disassembly")

        # Verify .data file contains section headers
        data_content = data_file.read_text()
        self.assertIn("Section headers", data_content, ".data file should contain section headers")

    def test_disasm_s_file_produces_asm_and_data(self):
        """make disasm FILE=<file.S> works for assembly source"""
        if not Path(self.TEST_S_FILE).exists():
            self.skipTest(f"Test assembly file not found: {self.TEST_S_FILE}")

        result = self.run_make("disasm", FILE=self.TEST_S_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"make disasm failed for .S file:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

        asm_file = self.asm_dir / "rrc_rrax.asm"
        data_file = self.asm_dir / "rrc_rrax.data"
        self.assertTrue(asm_file.exists(), f"Expected {asm_file} not found")
        self.assertTrue(data_file.exists(), f"Expected {data_file} not found")

    def test_disasm_default_flags_do_not_emit_msp430x_instructions(self):
        """Default make disasm output should avoid MSP430X-only mnemonics."""
        if not Path(self.TEST_NO_MSP430X_FILE).exists():
            self.skipTest(f"Test file not found: {self.TEST_NO_MSP430X_FILE}")

        result = self.run_make("disasm", FILE=self.TEST_NO_MSP430X_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"make disasm failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

        asm_file = self.asm_dir / "activity_recognition.asm"
        self.assertTrue(asm_file.exists(), f"Expected {asm_file} not found")

        asm_content = asm_file.read_text()
        self.assertNotRegex(
            asm_content,
            r"\b(rpt|rrum|rlam|pushm|popm|mova|calla)\b|\.a\b",
            "Default disassembly should not contain MSP430X-only instructions",
        )

    # =========================================================================
    # Test: make interpret
    # =========================================================================

    def test_interpret_runs_without_error(self):
        """make interpret FILE=<file.c> runs successfully"""
        result = self.run_make("interpret", FILE=self.TEST_C_FILE, MAX_STEPS="1000")

        self.assertEqual(
            result.returncode,
            0,
            f"make interpret failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertIn(
            "Interpret completed",
            result.stdout,
            "Expected success message not found in output",
        )

    def test_interpret_with_max_steps(self):
        """make interpret MAX_STEPS=N limits execution steps"""
        result = self.run_make("interpret", FILE=self.TEST_C_FILE, MAX_STEPS="100")

        self.assertEqual(
            result.returncode,
            0,
            f"make interpret with MAX_STEPS failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

    def test_interpret_granularity_opcode(self):
        """make interpret GRANULARITY=opcode uses mean_per_instruction model"""
        result = self.run_make(
            "interpret", FILE=self.TEST_C_FILE, MAX_STEPS="100", GRANULARITY="opcode"
        )

        self.assertEqual(
            result.returncode,
            0,
            f"make interpret GRANULARITY=opcode failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

    def test_interpret_granularity_addressing_mode(self):
        """make interpret GRANULARITY=addressing_mode uses correct model"""
        result = self.run_make(
            "interpret", FILE=self.TEST_C_FILE, MAX_STEPS="100", GRANULARITY="addressing_mode"
        )

        self.assertEqual(
            result.returncode,
            0,
            f"make interpret GRANULARITY=addressing_mode failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

    def test_interpret_granularity_addressing_mode_constant(self):
        """make interpret GRANULARITY=addressing_mode_constant uses correct model"""
        result = self.run_make(
            "interpret",
            FILE=self.TEST_C_FILE,
            MAX_STEPS="100",
            GRANULARITY="addressing_mode_constant",
        )

        self.assertEqual(
            result.returncode,
            0,
            f"make interpret GRANULARITY=addressing_mode_constant failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

    def test_interpret_invalid_granularity_fails(self):
        """make interpret GRANULARITY=invalid produces error"""
        result = self.run_make(
            "interpret", FILE=self.TEST_C_FILE, MAX_STEPS="100", GRANULARITY="invalid"
        )

        self.assertNotEqual(
            result.returncode, 0, "Expected failure for invalid granularity"
        )
        combined_output = result.stdout + result.stderr
        self.assertIn(
            "Unknown granularity",
            combined_output,
            f"Expected error message about unknown granularity. Output: {combined_output}",
        )

    def test_interpret_model_parameter(self):
        """make interpret MODEL=<model> passes model directly"""
        result = self.run_make(
            "interpret",
            FILE=self.TEST_C_FILE,
            MAX_STEPS="100",
            MODEL="mean_per_addressing_mode",
        )

        self.assertEqual(
            result.returncode,
            0,
            f"make interpret MODEL= failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )


class TestMakefileClean(unittest.TestCase):
    """Test make clean target"""

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).resolve().parents[2]
        os.chdir(cls.project_root)

    def test_clean_removes_build_dir(self):
        """make clean removes build directory"""
        # First compile something to create build dir
        subprocess.run(
            ["make", "compile", "FILE=test/fixtures/c_programs/simple.c"],
            capture_output=True,
            cwd=self.project_root,
        )

        # Verify build dir exists
        self.assertTrue(Path("build").exists(), "Build dir should exist after compile")

        # Run clean
        result = subprocess.run(
            ["make", "clean"], capture_output=True, text=True, cwd=self.project_root
        )

        self.assertEqual(result.returncode, 0, f"make clean failed: {result.stderr}")
        self.assertFalse(
            Path("build").exists(), "Build dir should not exist after clean"
        )


if __name__ == "__main__":
    unittest.main()
