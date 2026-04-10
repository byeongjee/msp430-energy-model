#!/usr/bin/env python3
"""
Test shell utility functions in common.sh and file_expansion_utils.sh

These tests verify that shell utility functions work correctly by running
them via subprocess. This ensures the actual shell code is tested.

Run with: make test
Or: uv run python -m unittest scripts/test_shell_utils.py -v
"""

import os
import subprocess
import tempfile
import unittest
from pathlib import Path


class TestShellUtils(unittest.TestCase):
    """Test utility functions in common.sh"""

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).parent.parent
        os.chdir(cls.project_root)

        # Get required environment variables from Makefile
        # We need to set minimal variables for common.sh to source without errors
        cls.base_env = {
            **os.environ,
            "SKIP_AUTO_INIT": "1",  # Skip auto-initialization
        }

    def run_bash(self, script: str, env: dict = None) -> subprocess.CompletedProcess:
        """Run a bash script and return the result

        Args:
            script: Bash script to run
            env: Optional environment variables

        Returns:
            CompletedProcess with stdout and stderr
        """
        run_env = self.base_env.copy()
        if env:
            run_env.update(env)

        return subprocess.run(
            ["bash", "-c", script],
            capture_output=True,
            text=True,
            env=run_env,
            cwd=self.project_root,
        )

    # =========================================================================
    # Test: process_defines
    # =========================================================================

    def test_process_defines_empty(self):
        """process_defines '' returns empty string"""
        result = self.run_bash(
            """
            source scripts/common.sh
            process_defines ""
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "")

    def test_process_defines_single(self):
        """process_defines 'FOO=1' returns '-DFOO=1'"""
        result = self.run_bash(
            """
            source scripts/common.sh
            process_defines "FOO=1"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("-DFOO=1", result.stdout)

    def test_process_defines_single_no_value(self):
        """process_defines 'BAR' returns '-DBAR'"""
        result = self.run_bash(
            """
            source scripts/common.sh
            process_defines "BAR"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("-DBAR", result.stdout)

    def test_process_defines_multiple(self):
        """process_defines 'FOO=1 BAR' returns '-DFOO=1 -DBAR'"""
        result = self.run_bash(
            """
            source scripts/common.sh
            process_defines "FOO=1 BAR"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout.strip()
        self.assertIn("-DFOO=1", output)
        self.assertIn("-DBAR", output)

    def test_process_defines_complex(self):
        """process_defines handles complex values like 'ENABLE_FEATURE=value'"""
        result = self.run_bash(
            """
            source scripts/common.sh
            process_defines "ENABLE_FEATURE=value NUM_REPEAT=100"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout.strip()
        self.assertIn("-DENABLE_FEATURE=value", output)
        self.assertIn("-DNUM_REPEAT=100", output)

    # =========================================================================
    # Test: extract_define
    # =========================================================================

    def test_extract_define_found(self):
        """extract_define finds and returns define value"""
        result = self.run_bash(
            """
            source scripts/common.sh
            extract_define "FOO=1 NUM_REPEAT=100" "NUM_REPEAT"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "100")

    def test_extract_define_first(self):
        """extract_define finds first define in list"""
        result = self.run_bash(
            """
            source scripts/common.sh
            extract_define "FOO=42 BAR=2" "FOO"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "42")

    def test_extract_define_not_found(self):
        """extract_define returns empty when not found"""
        result = self.run_bash(
            """
            source scripts/common.sh
            result=$(extract_define "FOO=1" "BAR")
            echo "result='$result'"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("result=''", result.stdout)

    def test_extract_define_empty_input(self):
        """extract_define handles empty input"""
        result = self.run_bash(
            """
            source scripts/common.sh
            result=$(extract_define "" "FOO")
            echo "result='$result'"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("result=''", result.stdout)

    def test_extract_define_similar_names(self):
        """extract_define doesn't match partial names"""
        result = self.run_bash(
            """
            source scripts/common.sh
            result=$(extract_define "FOO_BAR=1 FOO=2" "FOO")
            echo "$result"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "2")

    # =========================================================================
    # Test: override_define
    # =========================================================================

    def test_override_define_existing(self):
        """override_define replaces existing value"""
        result = self.run_bash(
            """
            source scripts/common.sh
            override_define "NUM_REPEAT=100" "NUM_REPEAT" "1"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout.strip()
        self.assertIn("NUM_REPEAT=1", output)
        self.assertNotIn("NUM_REPEAT=100", output)

    def test_override_define_new(self):
        """override_define adds new define when not present"""
        result = self.run_bash(
            """
            source scripts/common.sh
            override_define "FOO=1" "BAR" "2"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout.strip()
        self.assertIn("FOO=1", output)
        self.assertIn("BAR=2", output)

    def test_override_define_preserves_others(self):
        """override_define preserves other defines"""
        result = self.run_bash(
            """
            source scripts/common.sh
            override_define "FOO=1 BAR=2 NUM_REPEAT=100" "NUM_REPEAT" "1"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout.strip()
        self.assertIn("FOO=1", output)
        self.assertIn("BAR=2", output)
        self.assertIn("NUM_REPEAT=1", output)

    def test_override_define_empty_input(self):
        """override_define handles empty input by adding the define"""
        result = self.run_bash(
            """
            source scripts/common.sh
            override_define "" "FOO" "1"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("FOO=1", result.stdout)

    # =========================================================================
    # Test: create_timestamp
    # =========================================================================

    def test_create_timestamp_format(self):
        """create_timestamp returns timestamp in expected format"""
        result = self.run_bash(
            """
            source scripts/common.sh
            create_timestamp
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        timestamp = result.stdout.strip()
        # Should be in format YYYYMMDD_HHMMSS
        self.assertRegex(
            timestamp,
            r"^\d{8}_\d{6}$",
            f"Timestamp should match YYYYMMDD_HHMMSS format, got: {timestamp}",
        )


class TestFileExpansion(unittest.TestCase):
    """Test file expansion functions in file_expansion_utils.sh"""

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).parent.parent
        os.chdir(cls.project_root)

        cls.base_env = {
            **os.environ,
            "SKIP_AUTO_INIT": "1",
        }

    def run_bash(self, script: str) -> subprocess.CompletedProcess:
        """Run a bash script and return the result"""
        return subprocess.run(
            ["bash", "-c", script],
            capture_output=True,
            text=True,
            env=self.base_env,
            cwd=self.project_root,
        )

    # =========================================================================
    # Test: expand_file_input
    # =========================================================================

    def test_expand_file_input_literal(self):
        """expand_file_input returns literal file if it exists"""
        result = self.run_bash(
            """
            source scripts/file_expansion_utils.sh
            expand_file_input "test/fixtures/c_programs/simple.c"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("simple.c", result.stdout)

    def test_expand_file_input_glob(self):
        """expand_file_input expands glob patterns"""
        result = self.run_bash(
            """
            source scripts/file_expansion_utils.sh
            expand_file_input "test/fixtures/c_programs/*.c"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout
        # Should find multiple .c files
        self.assertIn("simple.c", output)
        self.assertIn("arithmetic.c", output)

    def test_expand_file_input_brace(self):
        """expand_file_input expands brace patterns"""
        result = self.run_bash(
            """
            source scripts/file_expansion_utils.sh
            expand_file_input "test/fixtures/c_programs/{simple,arithmetic}.c"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout
        self.assertIn("simple.c", output)
        self.assertIn("arithmetic.c", output)

    def test_expand_file_input_recursive(self):
        """expand_file_input handles recursive glob (**/*.c)"""
        result = self.run_bash(
            """
            source scripts/file_expansion_utils.sh
            expand_file_input "test/fixtures/**/*.c"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout
        # Should find files in subdirectories
        self.assertIn(".c", output)

    def test_expand_file_input_no_match(self):
        """expand_file_input returns empty for no matches"""
        result = self.run_bash(
            """
            source scripts/file_expansion_utils.sh
            result=$(expand_file_input "nonexistent_dir/*.c")
            if [ -z "$result" ]; then
                echo "EMPTY"
            else
                echo "$result"
            fi
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("EMPTY", result.stdout)

    def test_expand_file_input_removes_duplicates(self):
        """expand_file_input removes duplicate entries"""
        result = self.run_bash(
            """
            source scripts/file_expansion_utils.sh
            # Use patterns that might produce duplicates
            expand_file_input "test/fixtures/c_programs/simple.c" | wc -l
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        count = int(result.stdout.strip())
        self.assertEqual(count, 1, "Should have exactly 1 entry (no duplicates)")

    # =========================================================================
    # Test: match_files_by_basename
    # =========================================================================

    def test_match_files_by_basename_glob_pattern(self):
        """match_files_by_basename matches files by basename using glob"""
        with tempfile.TemporaryDirectory() as tmpdir:
            # Create test files
            Path(f"{tmpdir}/simple_segments.csv").touch()
            Path(f"{tmpdir}/arithmetic_segments.csv").touch()

            result = self.run_bash(
                f"""
                source scripts/file_expansion_utils.sh

                # Define source files array
                source_files=(
                    "test/fixtures/c_programs/simple.c"
                    "test/fixtures/c_programs/arithmetic.c"
                )

                # Match by basename
                match_files_by_basename source_files "{tmpdir}/*_segments.csv" "segments CSV"
                """
            )
            self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
            output = result.stdout
            self.assertIn("simple_segments.csv", output)
            self.assertIn("arithmetic_segments.csv", output)


class TestLoggingFunctions(unittest.TestCase):
    """Test logging functions in common.sh"""

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).parent.parent
        cls.base_env = {**os.environ, "SKIP_AUTO_INIT": "1"}

    def run_bash(
        self, script: str, env: dict | None = None
    ) -> subprocess.CompletedProcess:
        run_env = self.base_env.copy()
        if env:
            run_env.update(env)

        return subprocess.run(
            ["bash", "-c", script],
            capture_output=True,
            text=True,
            env=run_env,
            cwd=self.project_root,
        )

    def test_log_info_outputs_to_stdout(self):
        """log_info outputs to stdout with [INFO] prefix"""
        result = self.run_bash(
            """
            source scripts/common.sh
            log_info "test message"
            """
        )
        self.assertEqual(result.returncode, 0)
        self.assertIn("[INFO]", result.stdout)
        self.assertIn("test message", result.stdout)

    def test_log_error_outputs_to_stderr(self):
        """log_error outputs to stderr with [ERROR] prefix"""
        result = self.run_bash(
            """
            source scripts/common.sh
            log_error "error message"
            """
        )
        self.assertEqual(result.returncode, 0)
        self.assertIn("[ERROR]", result.stderr)
        self.assertIn("error message", result.stderr)

    def test_log_success_outputs_to_stdout(self):
        """log_success outputs to stdout with [SUCCESS] prefix"""
        result = self.run_bash(
            """
            source scripts/common.sh
            log_success "success message"
            """
        )
        self.assertEqual(result.returncode, 0)
        self.assertIn("[SUCCESS]", result.stdout)
        self.assertIn("success message", result.stdout)

    def test_log_warn_outputs_to_stderr(self):
        """log_warn outputs to stderr with [WARN] prefix"""
        result = self.run_bash(
            """
            source scripts/common.sh
            log_warn "warning message"
            """
        )
        self.assertEqual(result.returncode, 0)
        self.assertIn("[WARN]", result.stderr)
        self.assertIn("warning message", result.stderr)


class TestPipelineUtils(unittest.TestCase):
    """Test utility functions in pipeline_utils.sh"""

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).parent.parent
        os.chdir(cls.project_root)
        cls.base_env = {**os.environ, "SKIP_AUTO_INIT": "1"}

    def run_bash(
        self, script: str, env: dict | None = None
    ) -> subprocess.CompletedProcess:
        run_env = self.base_env.copy()
        if env:
            run_env.update(env)

        return subprocess.run(
            ["bash", "-c", script],
            capture_output=True,
            text=True,
            env=run_env,
            cwd=self.project_root,
        )

    # =========================================================================
    # Test: get_basename
    # =========================================================================

    def test_get_basename_c_file(self):
        """get_basename 'path/to/file.c' returns 'file'"""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            get_basename "path/to/file.c"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "file")

    def test_get_basename_s_file(self):
        """get_basename 'path/to/file.S' returns 'file'"""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            get_basename "path/to/file.S"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "file")

    def test_get_basename_nested_path(self):
        """get_basename handles deeply nested paths"""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            get_basename "a/b/c/d/test_program.c"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "test_program")

    # =========================================================================
    # Test: get_compile_flags
    # =========================================================================

    def test_get_compile_flags_c_file_uses_cflags(self):
        """get_compile_flags returns CFLAGS for C sources."""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            get_compile_flags "training_data/checkpoint_insertion/addressing_mode_batch_0000.c"
            """,
            env={"CFLAGS": "CFLAGS_SENTINEL", "ASMFLAGS": "ASMFLAGS_SENTINEL"},
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "CFLAGS_SENTINEL")

    def test_get_compile_flags_s_file_uses_asmflags(self):
        """get_compile_flags returns ASMFLAGS for assembly sources."""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            get_compile_flags "training_data/checkpoint_insertion/br_immediate.S"
            """,
            env={"CFLAGS": "CFLAGS_SENTINEL", "ASMFLAGS": "ASMFLAGS_SENTINEL"},
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "ASMFLAGS_SENTINEL")

    # =========================================================================
    # Test: granularity_to_model
    # =========================================================================

    def test_granularity_to_model_opcode(self):
        """granularity_to_model 'opcode' returns 'mean_per_instruction'"""
        result = self.run_bash(
            """
            source scripts/common.sh
            source scripts/pipeline_utils.sh
            granularity_to_model "opcode"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "mean_per_instruction")

    def test_granularity_to_model_addressing_mode(self):
        """granularity_to_model 'addressing_mode' returns correct model"""
        result = self.run_bash(
            """
            source scripts/common.sh
            source scripts/pipeline_utils.sh
            granularity_to_model "addressing_mode"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "mean_per_addressing_mode")

    def test_granularity_to_model_addressing_mode_constant(self):
        """granularity_to_model 'addressing_mode_constant' returns correct model"""
        result = self.run_bash(
            """
            source scripts/common.sh
            source scripts/pipeline_utils.sh
            granularity_to_model "addressing_mode_constant"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertEqual(result.stdout.strip(), "mean_per_addressing_mode_constant")

    def test_granularity_to_model_pair(self):
        """granularity_to_model for pair types returns pair model"""
        for granularity in ["opcode_pair", "addressing_mode_pair", "addressing_mode_constant_pair"]:
            with self.subTest(granularity=granularity):
                result = self.run_bash(
                    f"""
                    source scripts/common.sh
                    source scripts/pipeline_utils.sh
                    granularity_to_model "{granularity}"
                    """
                )
                self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
                self.assertEqual(result.stdout.strip(), "mean_per_pair_addressing_mode_constant")

    def test_granularity_to_model_invalid(self):
        """granularity_to_model with invalid input returns error"""
        result = self.run_bash(
            """
            source scripts/common.sh
            source scripts/pipeline_utils.sh
            granularity_to_model "invalid_granularity"
            """
        )
        self.assertNotEqual(result.returncode, 0, "Expected failure for invalid granularity")
        self.assertIn("Unknown granularity", result.stderr)

    # =========================================================================
    # Test: build_julia_flags
    # =========================================================================

    def test_build_julia_flags_all(self):
        """build_julia_flags with all parameters"""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            build_julia_flags "1000" "100" "mean_per_addressing_mode" "importance-sampling"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout.strip()
        self.assertIn("--max-steps 1000", output)
        self.assertIn("--n-samples 100", output)
        self.assertIn("--model mean_per_addressing_mode", output)
        self.assertIn("--inference importance-sampling", output)

    def test_build_julia_flags_partial(self):
        """build_julia_flags with some empty parameters"""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            build_julia_flags "500" "" "mean_per_instruction" ""
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        output = result.stdout.strip()
        self.assertIn("--max-steps 500", output)
        self.assertIn("--model mean_per_instruction", output)
        self.assertNotIn("--n-samples", output)
        self.assertNotIn("--inference", output)

    def test_build_julia_flags_empty(self):
        """build_julia_flags with all empty parameters returns empty"""
        result = self.run_bash(
            """
            source scripts/pipeline_utils.sh
            result=$(build_julia_flags "" "" "" "")
            echo "result='$result'"
            """
        )
        self.assertEqual(result.returncode, 0, f"Script failed: {result.stderr}")
        self.assertIn("result=''", result.stdout)


if __name__ == "__main__":
    unittest.main()
