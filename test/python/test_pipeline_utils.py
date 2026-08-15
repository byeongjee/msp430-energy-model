#!/usr/bin/env python3
"""
Test the pipeline utility functions: defines, file expansion and granularity mapping.

Run with: uv run pem test
Or: uv run python -m unittest discover -s test/python -k test_pipeline_utils -v
"""

import os
import tempfile
import unittest
from pathlib import Path

from pipeline import defines
from pipeline.config import Config, granularity_to_model
from pipeline.errors import PipelineError
from pipeline.files import (
    expand_file_input,
    match_files_by_basename,
    match_single_file,
    source_basename,
)
from pipeline.train import TrainOptions, julia_flags


class TestDefines(unittest.TestCase):
    def test_to_flags_empty(self):
        self.assertEqual(defines.to_flags(""), [])

    def test_to_flags_prefixes_each_macro(self):
        self.assertEqual(
            defines.to_flags("FOO=1 BAR ENABLE_FEATURE=value"),
            ["-DFOO=1", "-DBAR", "-DENABLE_FEATURE=value"],
        )

    def test_extract_returns_value(self):
        self.assertEqual(
            defines.extract("FOO=1 BAR NUM_REPEAT=100", "NUM_REPEAT"), "100"
        )

    def test_extract_missing_returns_none(self):
        self.assertIsNone(defines.extract("FOO=1 BAR", "NUM_REPEAT"))
        self.assertIsNone(defines.extract("", "NUM_REPEAT"))

    def test_extract_does_not_match_similar_names(self):
        self.assertIsNone(defines.extract("NUM_REPEAT_INNER=5", "NUM_REPEAT"))

    def test_override_replaces_existing_value(self):
        self.assertEqual(
            defines.override("FOO=1 BAR NUM_REPEAT=100", "NUM_REPEAT", "1"),
            "FOO=1 BAR NUM_REPEAT=1",
        )

    def test_override_appends_missing_macro(self):
        self.assertEqual(
            defines.override("FOO=1", "NUM_REPEAT", "1"), "FOO=1 NUM_REPEAT=1"
        )
        self.assertEqual(defines.override("", "NUM_REPEAT", "1"), "NUM_REPEAT=1")


class TestFileExpansion(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        (self.root / "nested").mkdir()
        for name in ("a.c", "b.c", "c.S"):
            (self.root / name).touch()
        (self.root / "nested" / "d.c").touch()
        self.cwd = Path.cwd()
        os.chdir(self.root)

    def tearDown(self):
        os.chdir(self.cwd)
        self.temp_dir.cleanup()

    def test_literal_path(self):
        self.assertEqual(expand_file_input("a.c"), [Path("a.c")])

    def test_literal_path_that_does_not_exist(self):
        self.assertEqual(expand_file_input("missing.c"), [])

    def test_glob(self):
        self.assertEqual(expand_file_input("*.c"), [Path("a.c"), Path("b.c")])

    def test_brace_expansion(self):
        self.assertEqual(expand_file_input("{a,b}.c"), [Path("a.c"), Path("b.c")])

    def test_recursive_glob(self):
        self.assertEqual(
            expand_file_input("**/*.c"), [Path("a.c"), Path("b.c"), Path("nested/d.c")]
        )

    def test_duplicates_are_removed(self):
        self.assertEqual(expand_file_input("{a,a}.c"), [Path("a.c")])

    def test_source_basename_strips_extension(self):
        self.assertEqual(source_basename("path/to/file.c"), "file")
        self.assertEqual(source_basename("path/to/file.S"), "file")


class TestSegmentMatching(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        for name in ("a_segments.csv", "b_segments.csv"):
            (self.root / name).touch()

    def tearDown(self):
        self.temp_dir.cleanup()

    def test_matches_by_basename(self):
        matched = match_files_by_basename(
            [Path("src/a.c"), Path("src/b.c")], f"{self.root}/*_segments.csv"
        )
        self.assertEqual(
            matched, [self.root / "a_segments.csv", self.root / "b_segments.csv"]
        )

    def test_unmatched_source_yields_none(self):
        matched = match_files_by_basename(
            [Path("src/z.c")], f"{self.root}/*_segments.csv"
        )
        self.assertEqual(matched, [None])

    def test_filename_placeholder(self):
        matched = match_files_by_basename(
            [Path("src/a.c")], f"{self.root}/{{filename}}_segments.csv"
        )
        self.assertEqual(matched, [self.root / "a_segments.csv"])

    def test_semicolon_separated_list(self):
        matched = match_files_by_basename(
            [Path("src/b.c")], f"{self.root}/a_segments.csv;{self.root}/b_segments.csv"
        )
        self.assertEqual(matched, [self.root / "b_segments.csv"])

    def test_match_single_file(self):
        self.assertEqual(
            match_single_file(f"{self.root}/a_*.csv"), self.root / "a_segments.csv"
        )

    def test_match_single_file_rejects_multiple_matches(self):
        with self.assertRaises(PipelineError):
            match_single_file(f"{self.root}/*_segments.csv")

    def test_match_single_file_rejects_no_match(self):
        with self.assertRaises(PipelineError):
            match_single_file(f"{self.root}/missing.csv")


class TestGranularityMapping(unittest.TestCase):
    EXPECTED_MAPPINGS = {
        "opcode": "mean_per_instruction",
        "addressing_mode": "mean_per_addressing_mode",
        "addressing_mode_constant": "mean_per_addressing_mode_constant",
        "addressing_mode_with_mem_access": "mean_per_addressing_mode_with_mem_access",
        "addressing_mode_constant_with_mem_access": "mean_per_addressing_mode_constant_with_mem_access",
        "opcode_pair": "mean_per_pair_addressing_mode_constant",
        "addressing_mode_pair": "mean_per_pair_addressing_mode_constant",
        "addressing_mode_constant_pair": "mean_per_pair_addressing_mode_constant",
    }

    def test_all_granularities_map_to_expected_model(self):
        for granularity, model in self.EXPECTED_MAPPINGS.items():
            with self.subTest(granularity=granularity):
                self.assertEqual(granularity_to_model(granularity), model)

    def test_invalid_granularity_lists_the_valid_ones(self):
        with self.assertRaises(PipelineError) as context:
            granularity_to_model("invalid")

        message = str(context.exception)
        self.assertIn("Unknown granularity", message)
        for granularity in self.EXPECTED_MAPPINGS:
            self.assertIn(granularity, message)


class TestCompileFlagSelection(unittest.TestCase):
    def config(self) -> Config:
        return Config(
            cc=Path("cc"),
            objdump=Path("objdump"),
            objcopy=Path("objcopy"),
            gdb=Path("gdb"),
            device="MSP430FR5994",
            cflags=["-mcpu=msp430"],
            asmflags=["-mmcu=MSP430FR5994"],
            includes=[],
            ldflags=[],
            ldlibs=[],
            build_dir=Path("build"),
            asm_dir=Path("build/asm"),
            temp_dir=Path("tmp"),
            report_dir=Path("report"),
        )

    def test_c_file_uses_cflags(self):
        self.assertEqual(self.config().compile_flags(Path("a.c")), ["-mcpu=msp430"])

    def test_assembly_file_uses_asmflags(self):
        self.assertEqual(
            self.config().compile_flags(Path("a.S")), ["-mmcu=MSP430FR5994"]
        )


class TestJuliaFlags(unittest.TestCase):
    def test_all_flags(self):
        options = TrainOptions(
            files="*.c",
            max_steps=1000,
            n_samples=100,
            model="mean_per_addressing_mode",
            inference="importance-sampling",
        )
        self.assertEqual(
            julia_flags(options),
            [
                "--max-steps",
                "1000",
                "--n-samples",
                "100",
                "--model",
                "mean_per_addressing_mode",
                "--inference",
                "importance-sampling",
            ],
        )

    def test_unset_flags_are_skipped(self):
        options = TrainOptions(files="*.c", model="", inference="")
        self.assertEqual(julia_flags(options), [])


if __name__ == "__main__":
    unittest.main()
