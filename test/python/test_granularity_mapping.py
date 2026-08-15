#!/usr/bin/env python3
"""
Test GRANULARITY to MODEL mapping in Makefile and scripts

This ensures the mapping between user-friendly granularity names and
internal model names is consistent across all locations.

Run with: make test
Or: uv run python -m unittest discover -s test/python -k test_granularity_mapping -v
"""

import os
import subprocess
import unittest
from pathlib import Path


class TestGranularityMapping(unittest.TestCase):
    """Test granularity to model name mapping"""

    # Expected mappings from user-friendly granularity to model name
    # This is the single source of truth for tests
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

    # Test file for running interpret
    TEST_FILE = "test/fixtures/c_programs/simple.c"

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).resolve().parents[2]
        os.chdir(cls.project_root)

    def test_makefile_mapping_opcode(self):
        """Makefile GRANULARITY=opcode maps to mean_per_instruction"""
        self._verify_makefile_granularity("opcode", "mean_per_instruction")

    def test_makefile_mapping_addressing_mode(self):
        """Makefile GRANULARITY=addressing_mode maps to mean_per_addressing_mode"""
        self._verify_makefile_granularity("addressing_mode", "mean_per_addressing_mode")

    def test_makefile_mapping_addressing_mode_constant(self):
        """Makefile GRANULARITY=addressing_mode_constant maps correctly"""
        self._verify_makefile_granularity(
            "addressing_mode_constant", "mean_per_addressing_mode_constant"
        )

    def test_makefile_mapping_addressing_mode_with_mem_access(self):
        """Makefile GRANULARITY=addressing_mode_with_mem_access maps correctly"""
        self._verify_makefile_granularity(
            "addressing_mode_with_mem_access", "mean_per_addressing_mode_with_mem_access"
        )

    def test_makefile_mapping_addressing_mode_constant_with_mem_access(self):
        """Makefile GRANULARITY=addressing_mode_constant_with_mem_access maps correctly"""
        self._verify_makefile_granularity(
            "addressing_mode_constant_with_mem_access",
            "mean_per_addressing_mode_constant_with_mem_access",
        )

    def test_makefile_mapping_opcode_pair(self):
        """Makefile GRANULARITY=opcode_pair maps to pair model"""
        self._verify_makefile_granularity_pair("opcode_pair")

    def test_makefile_mapping_addressing_mode_pair(self):
        """Makefile GRANULARITY=addressing_mode_pair maps to pair model"""
        self._verify_makefile_granularity_pair("addressing_mode_pair")

    def test_makefile_mapping_addressing_mode_constant_pair(self):
        """Makefile GRANULARITY=addressing_mode_constant_pair maps to pair model"""
        self._verify_makefile_granularity_pair("addressing_mode_constant_pair")

    def _verify_makefile_granularity(self, granularity: str, expected_model: str):
        """Helper to verify Makefile correctly passes granularity to interpret.sh

        Now that interpret logic is in interpret.sh, we verify by checking
        that make passes --granularity to the script.
        """
        result = subprocess.run(
            [
                "make",
                "-n",  # Dry run - show commands without executing
                "interpret",
                f"FILE={self.TEST_FILE}",
                f"GRANULARITY={granularity}",
                "MAX_STEPS=1",
            ],
            capture_output=True,
            text=True,
            cwd=self.project_root,
        )

        # The dry-run output should show interpret.sh being called with --granularity
        combined = result.stdout + result.stderr
        self.assertIn(
            "./scripts/pipeline/interpret.sh",
            combined,
            f"Expected interpret.sh to be called. Output: {combined[:500]}...",
        )
        self.assertIn(
            f'"--granularity" "{granularity}"',
            combined,
            f"Expected --granularity {granularity} to be passed. Output: {combined[:500]}...",
        )

    def _verify_makefile_granularity_pair(self, granularity: str):
        """Helper to verify Makefile mapping for pair granularities

        Verify that pair granularities are correctly passed to interpret.sh.
        """
        self._verify_makefile_granularity(
            granularity, "mean_per_pair_addressing_mode_constant"
        )

    def test_makefile_invalid_granularity_fails(self):
        """Makefile rejects invalid granularity"""
        result = subprocess.run(
            [
                "make",
                "interpret",
                f"FILE={self.TEST_FILE}",
                "GRANULARITY=invalid_granularity",
                "MAX_STEPS=1",
            ],
            capture_output=True,
            text=True,
            cwd=self.project_root,
        )

        self.assertNotEqual(result.returncode, 0, "Expected failure for invalid granularity")
        combined = result.stdout + result.stderr
        # Error is now from interpret.sh via granularity_to_model()
        self.assertIn(
            "Unknown granularity",
            combined,
            f"Expected 'Unknown granularity' error message. Got: {combined}",
        )


class TestGenerateRequiredBenchmarksMapping(unittest.TestCase):
    """Test granularity mapping in generate_required_benchmarks.sh"""

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

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).resolve().parents[2]
        os.chdir(cls.project_root)
        cls.base_env = {**os.environ, "SKIP_AUTO_INIT": "1"}

    def test_generate_required_benchmarks_mapping(self):
        """Verify generate_required_benchmarks.sh uses granularity_to_model()"""
        # After refactoring, generate_required_benchmarks.sh uses granularity_to_model()
        # from pipeline_utils.sh instead of a local case statement

        script_path = self.project_root / "scripts" / "benchmarks" / "generate_required_benchmarks.sh"
        if not script_path.exists():
            self.skipTest("generate_required_benchmarks.sh not found")

        script_content = script_path.read_text()

        # Verify the script uses granularity_to_model function
        self.assertIn(
            "granularity_to_model",
            script_content,
            "Expected generate_required_benchmarks.sh to use granularity_to_model()",
        )

        # Verify it sources common.sh (which sources pipeline_utils.sh)
        self.assertIn(
            'source "$REPO_ROOT/scripts/pipeline/common.sh"',
            script_content,
            "Expected generate_required_benchmarks.sh to source common.sh",
        )

    def test_generate_required_benchmarks_invalid_granularity(self):
        """generate_required_benchmarks.sh rejects invalid granularity"""
        result = subprocess.run(
            [
                "bash",
                "-c",
                """
                source scripts/pipeline/common.sh

                # Extract just the case statement logic
                granularity="invalid_granularity"
                case "$granularity" in
                    opcode) MODEL="mean_per_instruction" ;;
                    addressing_mode) MODEL="mean_per_addressing_mode" ;;
                    addressing_mode_constant) MODEL="mean_per_addressing_mode_constant" ;;
                    addressing_mode_with_mem_access) MODEL="mean_per_addressing_mode_with_mem_access" ;;
                    addressing_mode_constant_with_mem_access) MODEL="mean_per_addressing_mode_constant_with_mem_access" ;;
                    opcode_pair|addressing_mode_pair|addressing_mode_constant_pair) MODEL="mean_per_pair_addressing_mode_constant" ;;
                    *)
                        echo "Unknown granularity: $granularity" >&2
                        exit 1
                        ;;
                esac
                """,
            ],
            capture_output=True,
            text=True,
            env=self.base_env,
            cwd=self.project_root,
        )

        self.assertNotEqual(result.returncode, 0, "Expected failure for invalid granularity")
        self.assertIn("Unknown granularity", result.stderr)


class TestMappingConsistency(unittest.TestCase):
    """Test that mappings are consistent across all locations"""

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

    @classmethod
    def setUpClass(cls):
        cls.project_root = Path(__file__).resolve().parents[2]
        os.chdir(cls.project_root)

    def test_pipeline_utils_contains_all_granularities(self):
        """pipeline_utils.sh contains granularity_to_model with all expected granularities"""
        script_path = self.project_root / "scripts" / "pipeline" / "pipeline_utils.sh"
        script_content = script_path.read_text()

        # Verify the function exists
        self.assertIn(
            "granularity_to_model",
            script_content,
            "Expected granularity_to_model function in pipeline_utils.sh",
        )

        # Verify all granularities are handled in the function
        for granularity in self.EXPECTED_MAPPINGS.keys():
            self.assertIn(
                granularity,
                script_content,
                f"Granularity {granularity} not found in pipeline_utils.sh",
            )

    def test_pipeline_utils_has_correct_mappings(self):
        """pipeline_utils.sh granularity_to_model returns correct models"""
        # All unique model names should be in the file
        unique_models = set(self.EXPECTED_MAPPINGS.values())
        script_path = self.project_root / "scripts" / "pipeline" / "pipeline_utils.sh"
        script_content = script_path.read_text()

        for model in unique_models:
            self.assertIn(
                model,
                script_content,
                f"Model {model} not found in pipeline_utils.sh",
            )

    def test_error_message_lists_valid_granularities(self):
        """Error message for invalid granularity lists valid options"""
        result = subprocess.run(
            [
                "make",
                "interpret",
                "FILE=test/fixtures/c_programs/simple.c",
                "GRANULARITY=invalid",
                "MAX_STEPS=1",
            ],
            capture_output=True,
            text=True,
            cwd=self.project_root,
        )

        combined = result.stdout + result.stderr

        # Error message should list valid granularities
        for granularity in ["opcode", "addressing_mode", "addressing_mode_constant"]:
            self.assertIn(
                granularity,
                combined,
                f"Error message should list {granularity} as valid option",
            )


if __name__ == "__main__":
    unittest.main()
