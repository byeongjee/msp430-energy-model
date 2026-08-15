"""Compilation and disassembly of MSP430 programs."""

import re
from pathlib import Path

from pipeline import defines as defines_util
from pipeline import log
from pipeline.config import Config
from pipeline.files import source_basename
from pipeline.process import capture, run

# Local symbols that objdump can mistake for instruction boundaries: L0* (includes
# L0^A with a control character), .LVL*/.Loc.* (DWARF), .L* (GCC internal labels)
# and .LCFI* (CFI labels).
_STRIPPED_SYMBOLS = ("L0*", ".LVL*", ".Loc.*", ".L*", ".LCFI*")

_DATA_SECTIONS = (
    ".rodata",
    ".rodata2",
    ".data",
    ".lower.data",
    ".upper.data",
    ".persistent",
    ".text",
)

_SECTION_HEADER = re.compile(r"^\s+\d+\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)")


def compile_source(
    cfg: Config,
    source: Path,
    defines: str = "",
    extra_flags: list[str] | None = None,
    output: Path | None = None,
) -> Path:
    """Compile a .c or .S file to an ELF binary in the build directory."""
    elf = output or cfg.build_dir / f"{source_basename(source)}.elf"
    elf.parent.mkdir(parents=True, exist_ok=True)

    run(
        [
            cfg.cc,
            *cfg.compile_flags(source),
            *(extra_flags or []),
            *defines_util.to_flags(defines),
            *cfg.includes,
            *cfg.ldflags,
            "-o",
            elf,
            source,
            *cfg.ldlibs,
        ]
    )
    return elf


def disassemble(cfg: Config, elf: Path, asm_file: Path, data_file: Path) -> None:
    """Write the disassembly and the data dump of an ELF binary.

    The symbols stripped here can appear in the middle of a multi-byte instruction
    and make objdump split it incorrectly. Stripping runs on a copy: objcopy
    corrupts the LMA of sections whose VMA differs from it (e.g. .data lives in
    SRAM but is loaded from FRAM), which is harmless for the code disassembly but
    not for the data dump, so the dump below reads the original ELF.
    """
    asm_file.parent.mkdir(parents=True, exist_ok=True)
    data_file.parent.mkdir(parents=True, exist_ok=True)

    cleaned_elf = elf.with_name(f"{elf.stem}_cleaned.elf")
    run(
        [
            cfg.objcopy,
            "--wildcard",
            *(f"--strip-symbol={symbol}" for symbol in _STRIPPED_SYMBOLS),
            elf,
            cleaned_elf,
        ]
    )
    asm_file.write_text(capture([cfg.objdump, "-d", cleaned_elf]))
    cleaned_elf.unlink()

    # Section headers give the VMA→LMA translation needed for initialized globals.
    headers = ["# Section headers: Name Size VMA LMA"]
    for line in capture([cfg.objdump, "-h", elf]).splitlines():
        match = _SECTION_HEADER.match(line)
        if match:
            headers.append(f"# {' '.join(match.groups())}")

    section_flags = [flag for section in _DATA_SECTIONS for flag in ("-j", section)]
    dump = capture([cfg.objdump, "-s", *section_flags, elf])
    data_file.write_text("\n".join(headers) + "\n\n" + dump)


def compile_and_disasm(
    cfg: Config, source: Path, defines: str = ""
) -> tuple[Path, Path]:
    """Compile a source file and disassemble it; returns the .asm and .data paths."""
    base = source_basename(source)
    elf = compile_source(cfg, source, defines)
    asm_file = cfg.asm_dir / f"{base}.asm"
    data_file = cfg.asm_dir / f"{base}.data"

    disassemble(cfg, elf, asm_file, data_file)
    log.info(f"Compiled: {elf}")
    log.info(f"Disassembled: {asm_file}")
    log.info(f"Data dump: {data_file}")
    return asm_file, data_file
