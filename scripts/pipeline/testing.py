"""The Julia and Python test suites."""

import subprocess
import sys

from pipeline.config import PROJECT_ROOT
from pipeline.process import julia_env

_NO_TESTS_MATCHED = 5


def run(pattern: str = "") -> int:
    """Run both test suites and return the exit code for the CLI."""
    print("Running Julia test suite...")
    julia = subprocess.run(
        [
            "julia",
            f"--project={PROJECT_ROOT}",
            str(PROJECT_ROOT / "test" / "runtests.jl"),
            *([pattern] if pattern else []),
        ],
        env=julia_env(),
        check=False,
    )

    print("\nRunning Python test suite...")
    python = subprocess.run(
        [
            sys.executable,
            "-m",
            "unittest",
            "discover",
            "-s",
            str(PROJECT_ROOT / "test" / "python"),
            "-p",
            "test_*.py",
            "-v",
            *(["-k", pattern] if pattern else []),
        ],
        cwd=PROJECT_ROOT,
        check=False,
    )
    python_code = python.returncode
    if python_code == _NO_TESTS_MATCHED:
        print(f"(No Python tests matched pattern '{pattern}')")
        python_code = 0

    print("\n========================================")
    print("Test Summary")
    print("========================================")
    print(f"Julia tests:  {'PASSED' if julia.returncode == 0 else 'FAILED'}")
    print(f"Python tests: {'PASSED' if python_code == 0 else 'FAILED'}")

    if julia.returncode == 0 and python_code == 0:
        print("\nAll tests passed!")
        return 0
    print("\nSome tests failed.")
    return 1
