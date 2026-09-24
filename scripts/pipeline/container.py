import hashlib
import os
import subprocess
from collections.abc import Sequence
from functools import cache
from pathlib import Path

from pipeline import log
from pipeline.config import PROJECT_ROOT
from pipeline.errors import PipelineError

_IMAGE_INPUTS = (
    "Dockerfile",
    ".dockerignore",
    "Project.toml",
    "Manifest.toml",
    "pyproject.toml",
    "uv.lock",
    ".python-version",
)

_PLATFORM = "linux/amd64"

_FORWARDED_ENV = (
    "BUILD_DIR",
    "ASM_DIR",
    "TEMP_DIR",
    "REPORT_DIR",
    "MSP430_DEVICE",
    "MSP430_CFLAGS",
    "MSP430_ASMFLAGS",
    "JULIA_NUM_THREADS",
    "JULIA_LS_DEBUG_DUMP_PATH",
    "JULIA_ESTIMATE_DEBUG_DUMP_PATH",
    "JULIA_ESTIMATE_PRINT_KEY_COUNTS",
)


@cache
def image() -> str:
    digest = hashlib.sha256()
    for name in _IMAGE_INPUTS:
        digest.update(name.encode())
        digest.update((PROJECT_ROOT / name).read_bytes())
    tag = f"pem-toolchain:{digest.hexdigest()[:12]}"

    try:
        inspect = subprocess.run(
            ["docker", "image", "inspect", tag], capture_output=True, check=False
        )
    except FileNotFoundError as exc:
        raise PipelineError("Docker is not installed or not on PATH") from exc
    if inspect.returncode == 0:
        return tag

    log.info(f"Building the toolchain image {tag}; this takes a while once...")
    build = subprocess.run(
        ["docker", "build", "--platform", _PLATFORM, "-t", tag, str(PROJECT_ROOT)],
        check=False,
    )
    if build.returncode != 0:
        raise PipelineError(f"Failed to build the toolchain image {tag}")
    return tag


def command(cmd: Sequence[object], cwd: Path | None = None) -> list[str]:
    args = [str(arg) for arg in cmd]
    if os.environ.get("PEM_IN_CONTAINER"):
        return args

    workdir = (cwd or Path.cwd()).absolute()
    if not workdir.is_relative_to(PROJECT_ROOT):
        raise PipelineError(f"Run pem from inside the repository: {PROJECT_ROOT}")

    return [
        "docker",
        "run",
        "--rm",
        "--init",
        "--platform",
        _PLATFORM,
        "--user",
        f"{os.getuid()}:{os.getgid()}",
        "-v",
        f"{PROJECT_ROOT}:{PROJECT_ROOT}",
        "-w",
        str(workdir),
        *(arg for name in _FORWARDED_ENV if name in os.environ for arg in ("-e", name)),
        image(),
        *args,
    ]
