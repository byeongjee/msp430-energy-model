"""Subprocess helpers."""

import os
import subprocess
import sys
from pathlib import Path
from typing import Sequence

from pipeline.errors import PipelineError


def run(cmd: Sequence[object], env: dict | None = None) -> None:
    """Run a command, letting it write to this process's stdout/stderr."""
    argv = [str(arg) for arg in cmd]
    result = subprocess.run(argv, env=env)
    if result.returncode != 0:
        raise PipelineError(f"Command failed ({result.returncode}): {' '.join(argv)}")


def capture(
    cmd: Sequence[object], env: dict | None = None, stderr_to_stdout: bool = False
) -> str:
    """Run a command and return its output; stderr goes to the terminal unless merged."""
    argv = [str(arg) for arg in cmd]
    result = subprocess.run(
        argv,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT if stderr_to_stdout else None,
        text=True,
        env=env,
    )
    if result.returncode != 0:
        raise PipelineError(
            f"Command failed ({result.returncode}): {' '.join(argv)}\n{result.stdout}"
        )
    return result.stdout


def run_module(module: str, args: Sequence[object], env: dict | None = None) -> None:
    """Run a Python module of this project in a subprocess."""
    run([sys.executable, "-m", module, *args], env=env)


def julia_command(project_root: Path, mode: str, args: Sequence[object]) -> list[str]:
    return [
        "julia",
        f"--project={project_root}",
        str(project_root / "src" / "main.jl"),
        mode,
        *[str(arg) for arg in args],
    ]


def julia_env() -> dict:
    env = dict(os.environ)
    env.setdefault("JULIA_NUM_THREADS", "auto")
    return env


def run_julia(project_root: Path, mode: str, args: Sequence[object]) -> None:
    run(julia_command(project_root, mode, args), env=julia_env())
