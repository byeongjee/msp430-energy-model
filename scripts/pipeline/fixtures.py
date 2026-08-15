"""Test fixture creation: compile, disassemble and record the GDB simulator result."""

import json
import re
import shutil
from pathlib import Path

from pipeline import log
from pipeline.build import compile_source, disassemble
from pipeline.config import PROJECT_ROOT, Config
from pipeline.errors import PipelineError
from pipeline.process import capture

FIXTURE_DIR = PROJECT_ROOT / "test" / "fixtures"

_REGISTERS = ("PC", "SP", "SR", *(f"R{index}" for index in range(3, 16)))

# Sections whose contents the fixture records alongside the registers.
_DUMPED_SECTIONS = re.compile(
    r"^# (\.(?:data|bss|noinit|upper\.data|upper\.bss|lower\.data|lower\.bss)) "
    r"(\S+) (\S+) (\S+)"
)

_REGISTER_LINE = re.compile(r"^(\w+):0x([0-9a-fA-F]+)$")
_MEMORY_LINE = re.compile(r"^0x([0-9a-fA-F]+)[^:]*:(.*)$")


def _memory_dump_commands(data_file: Path) -> list[str]:
    """GDB commands dumping every word of the initialized data sections."""
    commands = []
    for line in data_file.read_text().splitlines():
        match = _DUMPED_SECTIONS.match(line)
        if not match:
            continue
        _, size_hex, vma_hex, _ = match.groups()
        words = int(size_hex, 16) // 2
        if words > 0:
            commands.append(f"x/{words}hx 0x{vma_hex}")
    return commands


def _parse_registers(output: str) -> dict[str, int]:
    """Read the register values GDB printed.

    R3 is the constant generator and GDB refuses to format it for some programs
    ("Value can't be converted to integer"); such a register reads as 0.
    """
    section = output.partition("REGISTERS_START")[2].partition("REGISTERS_END")[0]
    values = {}
    for line in section.splitlines():
        match = _REGISTER_LINE.match(line.strip())
        if match:
            values[match.group(1)] = int(match.group(2), 16)
    if "PC" not in values:
        raise PipelineError(f"GDB did not report the registers:\n{output}")
    return {name: values.get(name, 0) for name in _REGISTERS}


def _parse_memory(output: str) -> dict[str, int]:
    """Read the non-zero words of the `x/Nhx` dumps GDB printed."""
    section = output.partition("MEMORY_START")[2].partition("MEMORY_END")[0]
    memory: dict[int, int] = {}
    for line in section.splitlines():
        match = _MEMORY_LINE.match(line.strip())
        if not match:
            continue
        base = int(match.group(1), 16)
        for index, word in enumerate(match.group(2).split()):
            if not word.startswith("0x"):
                continue
            value = int(word, 16)
            if value != 0:
                memory[base + 2 * index] = value
    return {f"0x{address:x}": value for address, value in sorted(memory.items())}


def run_gdb(cfg: Config, elf: Path, data_file: Path | None = None) -> dict:
    """Run an ELF binary in the GDB simulator and return its final state."""
    if not cfg.gdb.is_file():
        raise PipelineError(f"GDB not found: {cfg.gdb}")

    register_commands = [
        f'printf "{name}:0x%04x\\n", ${name.lower()}' for name in _REGISTERS
    ]
    memory_commands = _memory_dump_commands(data_file) if data_file else []
    commands = [
        "target sim",
        "load",
        "break _exit",
        "run",
        'printf "REGISTERS_START\\n"',
        *register_commands,
        'printf "REGISTERS_END\\n"',
        'printf "MEMORY_START\\n"',
        *memory_commands,
        'printf "MEMORY_END\\n"',
    ]
    output = capture(
        [
            cfg.gdb,
            elf,
            "-batch",
            *(flag for command in commands for flag in ("-ex", command)),
        ],
        stderr_to_stdout=True,
    )

    registers = _parse_registers(output)
    status = registers["SR"]
    result = {
        "registers": registers,
        # MSP430 status register: C is bit 0, Z bit 1, N bit 2, V bit 8.
        "flags": {
            "C": bool(status & 0x0001),
            "Z": bool(status & 0x0002),
            "N": bool(status & 0x0004),
            "V": bool(status & 0x0100),
        },
        "pc": registers["PC"],
    }

    memory = _parse_memory(output)
    if memory:
        result = {"memory": memory, **result}
    return result


def create(cfg: Config, source: Path, name: str) -> Path:
    """Create a test fixture from a source file and return the fixture JSON path."""
    if not source.is_file():
        raise PipelineError(f"Source file not found: {source}")

    log.info(f"Creating test fixture for: {source}")
    log.info(f"Test name: {name}")

    FIXTURE_DIR.mkdir(parents=True, exist_ok=True)
    asm_file = cfg.asm_dir / f"{name}.asm"
    data_file = cfg.asm_dir / f"{name}.data"

    log.step("Compiling and disassembling")
    elf = compile_source(cfg, source, output=cfg.build_dir / f"{name}.elf")
    disassemble(cfg, elf, asm_file, data_file)
    log.success(f"Disassembled: {asm_file}")

    log.step("Running in GDB simulator")
    gdb_result = run_gdb(cfg, elf, data_file)
    log.success("GDB execution complete")

    shutil.copy(asm_file, FIXTURE_DIR / f"{name}.asm")
    shutil.copy(data_file, FIXTURE_DIR / f"{name}.data")

    fixture_file = FIXTURE_DIR / f"{name}.json"
    fixture_file.write_text(
        json.dumps(
            {
                "test_name": name,
                "asm_file": f"test/fixtures/{name}.asm",
                "data_file": f"test/fixtures/{name}.data",
                "gdb_result": gdb_result,
            },
            indent=2,
        )
        + "\n"
    )
    log.success(f"Fixture created: {fixture_file}")
    return fixture_file
