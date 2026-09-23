"""
Test the pem commands: compile, disasm, interpret, clean.

These run the actual CLI in a subprocess and check the files it produces.

Run with: uv run pem test
Or: uv run python -m unittest discover -s test/python -k test_cli -v
"""

import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


class PemTestCase(unittest.TestCase):
    """Runs pem commands against a temporary build directory"""

    TEST_C_FILE = "test/fixtures/c_programs/simple.c"
    TEST_NO_MSP430X_FILE = "examples/intermittent/activity_recognition.c"
    # rrc_rrax.S has a main function (test_indexed_simple.S uses _start)
    TEST_S_FILE = "test/fixtures/c_programs/rrc_rrax.S"

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).resolve().parents[2]
        os.chdir(cls.project_root)

        if not Path(cls.TEST_C_FILE).exists():
            raise unittest.SkipTest(f"Test file not found: {cls.TEST_C_FILE}")

    def setUp(self):
        temp_root = self.project_root / "tmp"
        temp_root.mkdir(exist_ok=True)
        self.temp_dir = tempfile.mkdtemp(dir=temp_root)
        self.build_dir = Path(self.temp_dir) / "build"
        self.asm_dir = Path(self.temp_dir) / "asm"

    def tearDown(self):
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def run_pem(
        self, *args: str, temp_dirs: bool = True
    ) -> subprocess.CompletedProcess:
        env = dict(os.environ)
        if temp_dirs:
            env["BUILD_DIR"] = str(self.build_dir)
            env["ASM_DIR"] = str(self.asm_dir)

        return subprocess.run(
            [sys.executable, "-m", "pipeline.cli", *args],
            capture_output=True,
            check=False,
            text=True,
            cwd=self.project_root,
            env=env,
        )


class TestCompile(PemTestCase):
    def test_compile_c_file_produces_elf(self):
        result = self.run_pem("compile", "--file", self.TEST_C_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"pem compile failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertTrue((self.build_dir / "simple.elf").exists())

    def test_compile_s_file_produces_elf(self):
        if not Path(self.TEST_S_FILE).exists():
            self.skipTest(f"Test assembly file not found: {self.TEST_S_FILE}")

        result = self.run_pem("compile", "--file", self.TEST_S_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"pem compile failed for .S file:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertTrue((self.build_dir / "rrc_rrax.elf").exists())

    def test_compile_with_defines(self):
        result = self.run_pem(
            "compile", "--file", self.TEST_C_FILE, "--defines", "TEST_DEFINE=42"
        )

        self.assertEqual(
            result.returncode,
            0,
            f"pem compile with defines failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertIn("DEFINES=TEST_DEFINE=42", result.stdout)

    def test_compile_missing_file_fails(self):
        result = self.run_pem("compile", "--file", "nonexistent_file.c")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("No such file or directory", result.stdout + result.stderr)

    def test_compile_without_file_fails(self):
        result = self.run_pem("compile")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("--file", result.stdout + result.stderr)


class TestDisasm(PemTestCase):
    def test_disasm_produces_asm_and_data(self):
        result = self.run_pem("disasm", "--file", self.TEST_C_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"pem disasm failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )

        asm_file = self.asm_dir / "simple.asm"
        data_file = self.asm_dir / "simple.data"
        self.assertTrue(asm_file.exists(), f"Expected {asm_file} not found")
        self.assertTrue(data_file.exists(), f"Expected {data_file} not found")
        self.assertIn("Disassembly", asm_file.read_text())
        self.assertIn("Section headers", data_file.read_text())

    def test_disasm_s_file_produces_asm_and_data(self):
        if not Path(self.TEST_S_FILE).exists():
            self.skipTest(f"Test assembly file not found: {self.TEST_S_FILE}")

        result = self.run_pem("disasm", "--file", self.TEST_S_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"pem disasm failed for .S file:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertTrue((self.asm_dir / "rrc_rrax.asm").exists())
        self.assertTrue((self.asm_dir / "rrc_rrax.data").exists())

    def test_disasm_default_flags_do_not_emit_msp430x_instructions(self):
        if not Path(self.TEST_NO_MSP430X_FILE).exists():
            self.skipTest(f"Test file not found: {self.TEST_NO_MSP430X_FILE}")

        result = self.run_pem("disasm", "--file", self.TEST_NO_MSP430X_FILE)

        self.assertEqual(
            result.returncode,
            0,
            f"pem disasm failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertNotRegex(
            (self.asm_dir / "activity_recognition.asm").read_text(),
            r"\b(rpt|rrum|rlam|pushm|popm|mova|calla)\b|\.a\b",
            "Default disassembly should not contain MSP430X-only instructions",
        )


class TestInterpret(PemTestCase):
    def test_interpret_runs_without_error(self):
        result = self.run_pem(
            "interpret", "--file", self.TEST_C_FILE, "--max-steps", "1000"
        )

        self.assertEqual(
            result.returncode,
            0,
            f"pem interpret failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )
        self.assertIn("Interpret completed", result.stdout)

    def test_interpret_granularities(self):
        for granularity in ("opcode", "addressing_mode", "addressing_mode_constant"):
            with self.subTest(granularity=granularity):
                result = self.run_pem(
                    "interpret",
                    "--file",
                    self.TEST_C_FILE,
                    "--max-steps",
                    "100",
                    "--granularity",
                    granularity,
                )
                self.assertEqual(
                    result.returncode,
                    0,
                    f"pem interpret --granularity {granularity} failed:\n{result.stderr}",
                )

    def test_interpret_invalid_granularity_fails(self):
        result = self.run_pem(
            "interpret", "--file", self.TEST_C_FILE, "--granularity", "invalid"
        )

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("invalid choice", result.stdout + result.stderr)

    def test_interpret_model_parameter(self):
        result = self.run_pem(
            "interpret",
            "--file",
            self.TEST_C_FILE,
            "--max-steps",
            "100",
            "--model",
            "mean_per_addressing_mode",
        )

        self.assertEqual(
            result.returncode,
            0,
            f"pem interpret --model failed:\nstdout: {result.stdout}\nstderr: {result.stderr}",
        )


class TestClean(PemTestCase):
    def test_clean_removes_build_dir(self):
        self.run_pem("compile", "--file", self.TEST_C_FILE)
        self.assertTrue(self.build_dir.exists(), "Build dir should exist after compile")

        result = self.run_pem("clean")

        self.assertEqual(result.returncode, 0, f"pem clean failed: {result.stderr}")
        self.assertFalse(
            self.build_dir.exists(), "Build dir should not exist after clean"
        )


if __name__ == "__main__":
    unittest.main()
