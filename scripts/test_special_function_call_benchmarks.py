"""Tests for special function call benchmark registration and listing.

Run with: make test
Or: uv run python scripts/test_special_function_call_benchmarks.py
"""

import json
import subprocess
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from benchmark.common import (
    HARDCODED_BENCHMARKS,
    get_hardcoded_benchmarks,
)

PROJECT_ROOT = Path(__file__).resolve().parent.parent
ALL_KEYS_FILE = PROJECT_ROOT / "all_keys.txt"
SPECIAL_BENCHMARK_SOURCE = (
    PROJECT_ROOT / "scripts" / "hardcoded_benchmarks" / "special_function_call_benchmark.c"
)

SPECIAL_KEYS = [
    key
    for key in ALL_KEYS_FILE.read_text().strip().split(",")
    if key.startswith("call___mspabi_")
]


class TestHardcodedBenchmarksRegistry(unittest.TestCase):
    """Test that special function call benchmarks are registered correctly."""

    def test_special_function_keys_in_registry(self):
        """All special function call keys from all_keys.txt exist in the registry."""
        for key in SPECIAL_KEYS:
            self.assertIn(key, HARDCODED_BENCHMARKS, f"{key} not in HARDCODED_BENCHMARKS")

    def test_special_function_keys_share_same_source(self):
        """All special function call keys point to the same benchmark C file."""
        paths = {HARDCODED_BENCHMARKS[k]["path"] for k in SPECIAL_KEYS}
        self.assertEqual(len(paths), 1, f"Expected 1 unique path, got {paths}")
        self.assertIn("special_function_call_benchmark.c", paths.pop())

    def test_special_function_keys_included_in_addressing_mode(self):
        """Special function call benchmarks appear for addressing_mode granularity."""
        hardcoded = get_hardcoded_benchmarks("addressing_mode")
        for key in SPECIAL_KEYS:
            self.assertIn(key, hardcoded,
                f"{key} not in get_hardcoded_benchmarks('addressing_mode')")

    def test_special_function_keys_not_in_opcode(self):
        """Special function call benchmarks should NOT appear for opcode granularity."""
        hardcoded = get_hardcoded_benchmarks("opcode")
        for key in SPECIAL_KEYS:
            self.assertNotIn(key, hardcoded,
                f"{key} should not be in opcode granularity")

    def test_source_file_exists(self):
        """The benchmark C source file exists."""
        for key in SPECIAL_KEYS:
            path = PROJECT_ROOT / HARDCODED_BENCHMARKS[key]["path"]
            self.assertTrue(path.exists(), f"Source file not found: {path}")

    def test_source_file_contains_each_special_function_benchmark(self):
        """The shared benchmark source defines and runs every special function benchmark."""
        source_text = SPECIAL_BENCHMARK_SOURCE.read_text()

        for key in SPECIAL_KEYS:
            self.assertIn(f"bench_{key}", source_text, f"Missing benchmark function for {key}")
            self.assertIn(
                f"BENCH(bench_{key}());",
                source_text,
                f"Missing BENCH invocation for {key}",
            )


class TestListBenchmarks(unittest.TestCase):
    """Test that list_benchmarks.py includes special function call keys."""

    def test_list_benchmarks_addressing_mode(self):
        """list_benchmarks.py includes special function call keys for addressing_mode."""
        result = subprocess.run(
            [sys.executable, "scripts/list_benchmarks.py", "--granularity", "addressing_mode"],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, f"list_benchmarks.py failed: {result.stderr}")
        data = json.loads(result.stdout)

        hardcoded_names = {
            entry["name"] for entry in data.get("hardcoded_benchmarks", [])
        }
        for key in SPECIAL_KEYS:
            self.assertIn(key, hardcoded_names,
                f"{key} not in list_benchmarks output hardcoded_benchmarks")


if __name__ == "__main__":
    unittest.main()
