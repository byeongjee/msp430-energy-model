#!/usr/bin/env python3
"""
Tests for extract_bench_labels.py.

These cover both direct C parsing and recovery from generated assembly files
that need to resolve back to their original C benchmark source.
"""

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from extract_bench_labels import extract_bench_labels


class TestExtractBenchLabels(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).resolve().parent.parent

    def test_extracts_labels_from_special_function_c_source(self):
        source = (
            self.project_root
            / "scripts"
            / "hardcoded_benchmarks"
            / "special_function_call_benchmark.c"
        )

        self.assertEqual(
            extract_bench_labels(source),
            [
                "bench_call___mspabi_divu",
                "bench_call___mspabi_divi",
                "bench_call___mspabi_divli",
                "bench_call___mspabi_mpyi",
                "bench_call___mspabi_mpyl",
                "bench_call___mspabi_remu",
            ],
        )

    def test_extracts_labels_from_generated_br_immediate_assembly(self):
        asm = (
            self.project_root
            / "training_data"
            / "checkpoint_insertion"
            / "br_immediate.S"
        )

        self.assertEqual(extract_bench_labels(asm), ["bench_br_immediate"])

    def test_extracts_labels_from_generated_br_indexed_assembly(self):
        asm = (
            self.project_root
            / "training_data"
            / "checkpoint_insertion"
            / "br_indexed.S"
        )

        self.assertEqual(extract_bench_labels(asm), ["bench_br_indexed"])

    def test_extracts_labels_from_generated_special_function_assembly(self):
        asm = (
            self.project_root
            / "training_data"
            / "checkpoint_insertion"
            / "special_function_call_benchmark.S"
        )

        self.assertEqual(
            extract_bench_labels(asm),
            [
                "bench_call___mspabi_divu",
                "bench_call___mspabi_divi",
                "bench_call___mspabi_divli",
                "bench_call___mspabi_mpyi",
                "bench_call___mspabi_mpyl",
                "bench_call___mspabi_remu",
            ],
        )


if __name__ == "__main__":
    unittest.main()
