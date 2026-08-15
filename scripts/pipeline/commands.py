"""Single-file commands: compile, disassemble, interpret, estimate, flash, info, clean."""

import shutil
from pathlib import Path

from pipeline import log
from pipeline.build import compile_and_disasm, compile_source
from pipeline.config import PROJECT_ROOT, Config, granularity_to_model
from pipeline.process import run_julia, run_module


def compile_only(cfg: Config, source: Path, defines: str = "") -> Path:
    log.info(f"Compiling {source} for MSP430...")
    if defines:
        log.info(f"  DEFINES={defines}")
    elf = compile_source(cfg, source, defines)
    log.success(f"Compilation successful: {elf}")
    return elf


def disasm(cfg: Config, source: Path, defines: str = "") -> tuple[Path, Path]:
    asm_file, data_file = compile_and_disasm(cfg, source, defines)
    log.success(f"Disassembly saved to: {asm_file}")
    log.success(f"Data dump saved to: {data_file}")
    return asm_file, data_file


def interpret(
    cfg: Config,
    source: Path,
    defines: str = "",
    max_steps: int | None = None,
    granularity: str = "",
    model: str = "",
    intercept_special_calls: bool = False,
) -> None:
    """Interpret a program and list the energy model parameters it requires."""
    asm_file, data_file = disasm(cfg, source, defines)

    if granularity:
        model = granularity_to_model(granularity)

    log.info("Running MSP430 interpreter...")
    run_julia(
        PROJECT_ROOT,
        "interpret",
        [
            "--asm",
            asm_file,
            "--data-dump",
            data_file,
            *(["--max-steps", max_steps] if max_steps is not None else []),
            *(["--model", model] if model else []),
            *(["--intercept-special-calls"] if intercept_special_calls else []),
        ],
    )
    log.success("Interpret completed!")


def estimate(
    cfg: Config,
    source: Path,
    params: Path,
    defines: str = "",
    plot: Path | None = None,
    max_steps: int | None = None,
    intercept_special_calls: bool = False,
) -> None:
    asm_file, data_file = disasm(cfg, source, defines)

    log.info("Estimating energy consumption...")
    run_julia(
        PROJECT_ROOT,
        "estimate",
        [
            "--asm",
            asm_file,
            "--params",
            params,
            "--data-dump",
            data_file,
            *(["--plot", plot] if plot else []),
            *(["--max-steps", max_steps] if max_steps is not None else []),
            *(["--intercept-special-calls"] if intercept_special_calls else []),
        ],
    )
    log.success("Estimation completed!")


def flash(cfg: Config, source: Path, defines: str = "") -> None:
    elf = compile_only(cfg, source, defines)
    log.info("Flashing binary to microcontroller...")
    run_module("measurement.flash", [elf])
    log.success("Flash completed!")


def clean(cfg: Config) -> None:
    log.info("Cleaning build artifacts...")
    shutil.rmtree(cfg.build_dir, ignore_errors=True)
    log.success("Clean completed!")


def info(cfg: Config) -> None:
    print("MSP430 Toolchain Information")
    print("============================")
    print(f"CC:           {cfg.cc}")
    print(f"OBJDUMP:      {cfg.objdump}")
    print(f"DEVICE:       {cfg.device}")
    print(f"CFLAGS:       {' '.join(cfg.cflags)}")
    print(f"ASMFLAGS:     {' '.join(cfg.asmflags)}")
    print(f"INCLUDES:     {' '.join(cfg.includes)}")
    print(f"BUILD_DIR:    {cfg.build_dir}")
    print(f"ASM_DIR:      {cfg.asm_dir}")
    print(f"TEMP_DIR:     {cfg.temp_dir}")
    print(f"REPORT_DIR:   {cfg.report_dir}")
    print()
    print("Toolchain status:")
    for name, tool in (("MSP430 GCC", cfg.cc), ("MSP430 OBJDUMP", cfg.objdump)):
        status = "✓ found" if tool.is_file() else "❌ not found"
        print(f"{name}: {status}: {tool}")
