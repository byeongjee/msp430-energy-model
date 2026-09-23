"""Tests for special function call benchmark registration and listing.

Run with: make test
Or: uv run python -m unittest discover -s test/python -k test_special_function_call_benchmarks
"""

import json
import os
import re
import subprocess
import sys
import unittest
from pathlib import Path

from benchmarks.common import (
    HARDCODED_BENCHMARKS,
    SPECIAL_FUNCTION_CALL_BENCHMARKS,
    get_hardcoded_benchmarks,
)
from benchmarks.gen_benchmarks import (
    build_define_flags,
    build_special_function_compile_command,
)

PROJECT_ROOT = Path(__file__).resolve().parents[2]
ALL_KEYS_FILE = PROJECT_ROOT / "training_data" / "bao_asplos27" / "all_keys.txt"
SPECIAL_BENCHMARK_SOURCE = (
    PROJECT_ROOT
    / "scripts"
    / "benchmarks"
    / "hardcoded"
    / "special_function_call_benchmark.c"
)


def read_all_keys() -> list[str]:
    return [
        key for key in re.split(r"[\s,]+", ALL_KEYS_FILE.read_text().strip()) if key
    ]


SPECIAL_KEYS = [
    key for key in read_all_keys() if key in SPECIAL_FUNCTION_CALL_BENCHMARKS
]


class TestHardcodedBenchmarksRegistry(unittest.TestCase):
    """Test that special function call benchmarks are registered correctly."""

    def test_special_function_keys_in_registry(self):
        """All special function call keys from all_keys.txt exist in the registry."""
        for key in SPECIAL_KEYS:
            self.assertIn(
                key, HARDCODED_BENCHMARKS, f"{key} not in HARDCODED_BENCHMARKS"
            )

    def test_special_function_keys_share_same_source(self):
        """All special function call keys point to the same benchmark C file."""
        paths = {HARDCODED_BENCHMARKS[k]["path"] for k in SPECIAL_KEYS}
        self.assertEqual(len(paths), 1, f"Expected 1 unique path, got {paths}")
        self.assertIn("special_function_call_benchmark.c", paths.pop())

    def test_special_function_keys_included_in_addressing_mode(self):
        """Special function call benchmarks appear for addressing_mode granularity."""
        hardcoded = get_hardcoded_benchmarks("addressing_mode")
        for key in SPECIAL_KEYS:
            self.assertIn(
                key,
                hardcoded,
                f"{key} not in get_hardcoded_benchmarks('addressing_mode')",
            )

    def test_special_function_keys_not_in_opcode(self):
        """Special function call benchmarks should NOT appear for opcode granularity."""
        hardcoded = get_hardcoded_benchmarks("opcode")
        for key in SPECIAL_KEYS:
            self.assertNotIn(
                key, hardcoded, f"{key} should not be in opcode granularity"
            )

    def test_source_file_exists(self):
        """The benchmark C source file exists."""
        for key in SPECIAL_KEYS:
            path = PROJECT_ROOT / HARDCODED_BENCHMARKS[key]["path"]
            self.assertTrue(path.exists(), f"Source file not found: {path}")

    def test_source_file_contains_each_special_function_benchmark(self):
        """The shared benchmark source defines and runs every special function benchmark."""
        source_text = SPECIAL_BENCHMARK_SOURCE.read_text()

        for key in SPECIAL_KEYS:
            self.assertIn(
                f"bench_{key}", source_text, f"Missing benchmark function for {key}"
            )
            self.assertIn(
                f"BENCH(bench_{key}());",
                source_text,
                f"Missing BENCH invocation for {key}",
            )

    def test_source_file_uses_dedicated_repeat_count(self):
        """Special-call benchmarks keep a larger local repeat count for measurement stability."""
        source_text = SPECIAL_BENCHMARK_SOURCE.read_text()
        self.assertIn("#define SPECIAL_FUNCTION_CALL_INNER_ITERS 100", source_text)
        self.assertIn("REPEAT_SPECIAL_FUNCTION_INNER_ITERS", source_text)


class TestHardcodedBenchmarkCommandBuilders(unittest.TestCase):
    def test_build_define_flags_prefixes_each_macro(self):
        self.assertEqual(
            build_define_flags("NUM_REPEAT=30 TEXTUAL_REPT=50"),
            ["-DNUM_REPEAT=30", "-DTEXTUAL_REPT=50"],
        )

    def test_special_function_compile_command_includes_define_flags(self):
        cmd = build_special_function_compile_command(
            "msp430-elf-gcc",
            "-mmcu=MSP430FR5994 -O3",
            "-I include -I support/include",
            "NUM_REPEAT=30",
            Path("/tmp/special_function_call_benchmark.S"),
            Path("/tmp/special_function_call_benchmark.c"),
        )

        self.assertEqual(
            cmd,
            [
                "msp430-elf-gcc",
                "-S",
                "-mmcu=MSP430FR5994",
                "-O3",
                "-mhwmult=none",
                "-DNUM_REPEAT=30",
                "-I",
                "include",
                "-I",
                "support/include",
                "-o",
                "/tmp/special_function_call_benchmark.S",
                "/tmp/special_function_call_benchmark.c",
            ],
        )


class TestListBenchmarks(unittest.TestCase):
    """Test that benchmarks.list_benchmarks includes special function call keys."""

    def test_list_benchmarks_addressing_mode(self):
        """benchmarks.list_benchmarks includes special function call keys for addressing_mode."""
        result = subprocess.run(
            [
                sys.executable,
                "-m",
                "benchmarks.list_benchmarks",
                "--granularity",
                "addressing_mode",
            ],
            capture_output=True,
            check=False,
            text=True,
            env={**os.environ, "PYTHONPATH": str(PROJECT_ROOT / "scripts")},
        )
        self.assertEqual(
            result.returncode, 0, f"benchmarks.list_benchmarks failed: {result.stderr}"
        )
        data = json.loads(result.stdout)

        hardcoded_names = {
            entry["name"] for entry in data.get("hardcoded_benchmarks", [])
        }
        for key in SPECIAL_KEYS:
            self.assertIn(
                key,
                hardcoded_names,
                f"{key} not in list_benchmarks output hardcoded_benchmarks",
            )


if __name__ == "__main__":
    unittest.main()
