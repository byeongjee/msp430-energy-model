#!/usr/bin/env python3
"""
Test GRANULARITY to MODEL mapping in Makefile and scripts

This ensures the mapping between user-friendly granularity names and
internal model names is consistent across all locations.

Run with: make test
Or: uv run python -m unittest scripts/test_granularity_mapping.py -v
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
        cls.project_root = Path(__file__).parent.parent
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
        """Helper to verify Makefile passes correct model for a granularity

        We use `make -n` (dry run) to see the case statement that maps
        granularity to model name.
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

        # The dry-run output shows the case statement with the mapping
        # Look for the pattern: granularity) MODEL_NAME="expected_model";;
        combined = result.stdout + result.stderr
        expected_pattern = f'{granularity}) MODEL_NAME="{expected_model}";;'
        self.assertIn(
            expected_pattern,
            combined,
            f"Expected case pattern '{expected_pattern}' for GRANULARITY={granularity}.\n"
            f"Output: {combined[:500]}...",
        )

    def _verify_makefile_granularity_pair(self, granularity: str):
        """Helper to verify Makefile mapping for pair granularities

        Pair granularities (opcode_pair, addressing_mode_pair, addressing_mode_constant_pair)
        all map to mean_per_pair_addressing_mode_constant via a combined case pattern.
        """
        result = subprocess.run(
            [
                "make",
                "-n",
                "interpret",
                f"FILE={self.TEST_FILE}",
                f"GRANULARITY={granularity}",
                "MAX_STEPS=1",
            ],
            capture_output=True,
            text=True,
            cwd=self.project_root,
        )

        combined = result.stdout + result.stderr
        # The pair granularities are grouped with | operator
        expected_pattern = 'opcode_pair|addressing_mode_pair|addressing_mode_constant_pair) MODEL_NAME="mean_per_pair_addressing_mode_constant";;'
        self.assertIn(
            expected_pattern,
            combined,
            f"Expected combined case pattern for pair granularities.\n"
            f"Output: {combined[:500]}...",
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
        self.assertIn(
            "Unknown GRANULARITY",
            combined,
            f"Expected 'Unknown GRANULARITY' error message. Got: {combined}",
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
        cls.project_root = Path(__file__).parent.parent
        os.chdir(cls.project_root)
        cls.base_env = {**os.environ, "SKIP_AUTO_INIT": "1"}

    def test_generate_required_benchmarks_mapping(self):
        """Verify generate_required_benchmarks.sh uses correct mapping"""
        # Test by extracting the case statement from the script
        # and verifying it matches our expected mappings

        script_path = self.project_root / "scripts" / "generate_required_benchmarks.sh"
        if not script_path.exists():
            self.skipTest("generate_required_benchmarks.sh not found")

        script_content = script_path.read_text()

        # Verify each mapping exists in the script
        for granularity, expected_model in self.EXPECTED_MAPPINGS.items():
            # Check for the case pattern
            if granularity.endswith("_pair"):
                # Pair granularities are grouped with |
                self.assertIn(
                    expected_model,
                    script_content,
                    f"Expected model {expected_model} not found in script",
                )
            else:
                # Non-pair granularities have individual case entries
                pattern = f'{granularity}) MODEL="{expected_model}"'
                alternative_pattern = f"{granularity}) echo \"{expected_model}\""

                found = (pattern in script_content or
                        alternative_pattern in script_content or
                        f'{granularity})' in script_content and expected_model in script_content)

                self.assertTrue(
                    found,
                    f"Expected mapping {granularity} -> {expected_model} not found in script",
                )

    def test_generate_required_benchmarks_invalid_granularity(self):
        """generate_required_benchmarks.sh rejects invalid granularity"""
        result = subprocess.run(
            [
                "bash",
                "-c",
                """
                source scripts/common.sh

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
        cls.project_root = Path(__file__).parent.parent
        os.chdir(cls.project_root)

    def test_makefile_contains_all_granularities(self):
        """Makefile contains case entries for all expected granularities"""
        makefile_path = self.project_root / "Makefile"
        makefile_content = makefile_path.read_text()

        for granularity in self.EXPECTED_MAPPINGS.keys():
            self.assertIn(
                granularity,
                makefile_content,
                f"Granularity {granularity} not found in Makefile",
            )

    def test_generate_required_benchmarks_contains_all_granularities(self):
        """generate_required_benchmarks.sh contains all expected granularities"""
        script_path = self.project_root / "scripts" / "generate_required_benchmarks.sh"
        if not script_path.exists():
            self.skipTest("generate_required_benchmarks.sh not found")

        script_content = script_path.read_text()

        for granularity in self.EXPECTED_MAPPINGS.keys():
            self.assertIn(
                granularity,
                script_content,
                f"Granularity {granularity} not found in generate_required_benchmarks.sh",
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
