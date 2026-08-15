#!/usr/bin/env python3
"""
Tests for extract_bench_labels.py.

These cover both direct C parsing and recovery from generated assembly files
that need to resolve back to their original C benchmark source.
"""

import unittest
from pathlib import Path

from benchmarks.extract_bench_labels import extract_bench_labels

# Order follows the BENCH() calls in special_function_call_benchmark.c's main().
SPECIAL_FUNCTION_LABELS = [
    "bench_call___mspabi_divu",
    "bench_call___mspabi_divi",
    "bench_call___mspabi_divli",
    "bench_call___mspabi_mpyi",
    "bench_call___mspabi_mpyl",
    "bench_call___mspabi_remu",
    "bench_call___mspabi_remul",
    "bench_call___mspabi_mpyll",
    "bench_call___mspabi_addd",
    "bench_call___mspabi_subd",
    "bench_call___mspabi_mpyd",
    "bench_call___mspabi_divd",
    "bench_call___mspabi_addf",
    "bench_call___mspabi_mpyf",
    "bench_call___mspabi_divf",
    "bench_call___mspabi_cvtdf",
    "bench_call___mspabi_cvtfd",
    "bench_call___mspabi_fltuld",
    "bench_call___mspabi_fltulf",
    "bench_call___mspabi_fixfli",
    "bench_call_cos",
    "bench_call_sin",
]


class TestExtractBenchLabels(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).resolve().parents[2]

    def test_extracts_labels_from_special_function_c_source(self):
        source = (
            self.project_root
            / "scripts"
            / "benchmarks"
            / "hardcoded"
            / "special_function_call_benchmark.c"
        )

        self.assertEqual(
            extract_bench_labels(source),
            SPECIAL_FUNCTION_LABELS,
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
            SPECIAL_FUNCTION_LABELS,
        )


if __name__ == "__main__":
    unittest.main()
