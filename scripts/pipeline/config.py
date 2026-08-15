"""Toolchain configuration and directory layout."""

import os
import shlex
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path

from pipeline.errors import PipelineError

PROJECT_ROOT = Path(__file__).resolve().parents[2]

DEVICE_DEFAULT = "MSP430FR5994"
VOLTAGE_DEFAULT = 3.3
MAX_CURRENT_DEFAULT = 0.01

# Map user-facing granularity names to the model names the Julia code expects.
GRANULARITY_TO_MODEL = {
    "opcode": "mean_per_instruction",
    "addressing_mode": "mean_per_addressing_mode",
    "addressing_mode_constant": "mean_per_addressing_mode_constant",
    "addressing_mode_with_mem_access": "mean_per_addressing_mode_with_mem_access",
    "addressing_mode_constant_with_mem_access": "mean_per_addressing_mode_constant_with_mem_access",
    "opcode_pair": "mean_per_pair_addressing_mode_constant",
    "addressing_mode_pair": "mean_per_pair_addressing_mode_constant",
    "addressing_mode_constant_pair": "mean_per_pair_addressing_mode_constant",
}


def granularity_to_model(granularity: str) -> str:
    try:
        return GRANULARITY_TO_MODEL[granularity]
    except KeyError:
        raise PipelineError(
            f"Unknown granularity: {granularity}\n"
            f"Expected one of: {', '.join(GRANULARITY_TO_MODEL)}"
        ) from None


def timestamp() -> str:
    return datetime.now().strftime("%Y%m%d_%H%M%S")


@dataclass(frozen=True)
class Config:
    cc: Path
    objdump: Path
    objcopy: Path
    gdb: Path
    device: str
    cflags: list[str]
    asmflags: list[str]
    includes: list[str]
    ldflags: list[str]
    ldlibs: list[str]
    build_dir: Path
    asm_dir: Path
    temp_dir: Path
    report_dir: Path

    def compile_flags(self, source: Path) -> list[str]:
        """Hand-written assembly may use MSP430X instructions, so .S files keep the
        MCU-native assembler defaults instead of the base-ISA CFLAGS."""
        return self.asmflags if source.suffix == ".S" else self.cflags


def _env_path(name: str) -> Path:
    value = os.environ.get(name)
    if not value:
        raise PipelineError(
            f"{name} is not set. Please set it in your environment or .env file"
        )
    return Path(value)


def load() -> Config:
    toolchain = _env_path("MSP430GCC_TOOLCHAIN_PATH")
    support = _env_path("MSP430GCC_SUPPORT_PATH")

    device = os.environ.get("MSP430_DEVICE", DEVICE_DEFAULT)
    # Force the base MSP430 ISA so the default pipeline does not emit MSP430X-only
    # instructions such as rpt/pushm/popm/rrum/rlam in compiled binaries.
    cflags = os.environ.get(
        "MSP430_CFLAGS",
        f"-mmcu={device} -mcpu=msp430 -msmall -mhwmult=none -mno-warn-mcu -O3 -Wall",
    )
    asmflags = os.environ.get("MSP430_ASMFLAGS", f"-mmcu={device} -O3 -Wall")

    build_dir = Path(os.environ.get("BUILD_DIR", "build"))
    asm_dir = Path(os.environ.get("ASM_DIR", build_dir / "asm"))

    return Config(
        cc=toolchain / "bin" / "msp430-elf-gcc",
        objdump=toolchain / "bin" / "msp430-elf-objdump",
        objcopy=toolchain / "bin" / "msp430-elf-objcopy",
        gdb=toolchain / "bin" / "msp430-elf-gdb",
        device=device,
        cflags=shlex.split(cflags),
        asmflags=shlex.split(asmflags),
        includes=[f"-I{support}/include", f"-I{PROJECT_ROOT}/include"],
        ldflags=[
            f"-L{support}/include",
            "-T",
            f"{PROJECT_ROOT}/include/msp430fr5994.ld",
        ],
        # libm supplies cos/sin for the special-call benchmarks.
        ldlibs=["-lm"],
        build_dir=build_dir,
        asm_dir=asm_dir,
        temp_dir=Path(os.environ.get("TEMP_DIR", "./tmp")),
        report_dir=Path(os.environ.get("REPORT_DIR", "./report")),
    )
