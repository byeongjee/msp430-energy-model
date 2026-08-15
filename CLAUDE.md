# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment Setup

**IMPORTANT**: The following environment variables must be set:
- `MSP430GCC_TOOLCHAIN_PATH`: Path to the MSP430 GCC toolchain
- `MSP430GCC_SUPPORT_PATH`: Path to the MSP430 GCC support files
- `OTII_SERVER_BIN`: Path to the Otii server binary
- `OTII_USERNAME` / `OTII_PASSWORD`: Otii credentials

Python scripts should be run via `uv run` instead of activating a virtual environment directly.

## Common Commands

All commands run through the `pem` CLI (`scripts/pipeline/cli.py`), installed by
`uv sync`. Run `uv run pem --help` for the full list.

### Testing
```bash
# Run all tests (Julia and Python)
uv run pem test

# Run specific test fixture by pattern
uv run pem test --pattern "{fixture_name}"
```

### Interpreting MSP430 Programs
```bash
# Compile and interpret a C or assembly file
uv run pem interpret --file <file.c|file.S>

# With optional parameters
uv run pem interpret --file examples/misc/simple.c --max-steps 1000
uv run pem interpret --file <file.c> --granularity addressing_mode
uv run pem interpret --file <file.c> --model mean_per_addressing_mode

# Valid --granularity values: opcode, addressing_mode, addressing_mode_constant, addressing_mode_with_mem_access, addressing_mode_constant_with_mem_access, opcode_pair, addressing_mode_pair, addressing_mode_constant_pair
```

### Training Energy Models
```bash
# Train from measurement data
uv run pem train --files "examples/**/*.c" --model mean_per_addressing_mode --inference dominant-key

# With output file
uv run pem train --files "examples/**/*.c" --params output.json

# Reuse already measured segments instead of measuring again
uv run pem train --files "examples/**/*.c" --training-segments-csv "tmp/*_segments.csv"
```

### Estimating Energy Consumption
```bash
# Estimate energy for a program using trained parameters
uv run pem estimate --file <file.c> --params <params.json>

# With optional parameters
uv run pem estimate --file <file.c> --params params.json --plot output.png --max-steps 1000
```

### Full Pipeline
```bash
# Train and estimate in one command
uv run pem train-and-estimate --train-files "examples/benchmarks/*.c" --estimate-file examples/misc/test.c --estimate-defines "NUM_REPEAT=30"
```

### Other Commands
```bash
uv run pem compile --file <file.c>                  # Compile to MSP430 binary
uv run pem disasm --file <file.c>                   # Compile and disassemble
uv run pem flash --file <file.c>                    # Flash binary to microcontroller
uv run pem analyze-distribution --files <pattern>   # Flash, measure, and analyze energy distribution
uv run pem gen-benchmarks --file <file.c>           # Generate the benchmarks a program needs
uv run pem gen-benchmarks-from-keys --keys all_keys.txt --output-dir <dir>
uv run pem compile-branch-benchmark --file <file.c> # Two-pass build of a hardcoded branch benchmark
uv run pem create-fixture --file <file.c> --name <name>  # Create an interpreter test fixture
uv run pem info                                     # Show build and toolchain information
uv run pem clean                                    # Clean build artifacts
```

Directories are configured through the environment: `BUILD_DIR` (default
`build`), `ASM_DIR` (default `$BUILD_DIR/asm`), `TEMP_DIR` (default `./tmp`) and
`REPORT_DIR` (default `./report`). `MSP430_DEVICE`, `MSP430_CFLAGS` and
`MSP430_ASMFLAGS` override the compiler settings.

## Code Architecture

### Pipeline Overview
1. **Compilation**: C programs → MSP430 binaries (using MSP430 GCC toolchain)
2. **Interpretation**: Simulate program execution to generate instruction traces
3. **Training**: Learn energy parameters from measured data
4. **Estimation**: Predict energy consumption for new programs

### Key Julia Modules

#### `src/main.jl`
Entry point with three modes: `interpret`, `train`, `estimate`

#### `src/Interpreter.jl`
- MSP430 instruction interpreter and simulator
- Generates execution traces (sequence of ExecutionEvents)
- Implements cache simulation (2-way, 4-line cache for MSP430FR5994)
- Tracks memory accesses to FRAM (non-volatile) and SRAM (volatile)
- Event types: `Inst`, `FRAMReadHit`, `FRAMReadMiss`, `FRAMWrite`, `SRAMRead`, `SRAMWrite`, `Other`

#### `src/Train.jl`
Trains energy models from execution traces + measured energy data. Supports multiple training files.

#### `src/Estimation.jl`
Estimates energy consumption using trained model parameters. Auto-detects model type from params file.

#### `src/model.jl` and `src/models/`
Energy model implementations:
- **Gamma models** (probabilistic): Use Gamma distributions
  - Granularities: per-instruction, per-addressing-mode, per-addressing-mode-constant
  - Inference: `importance-sampling`, `mcmc-blocked`
- **Mean models** (deterministic): Use mean energy values
  - Granularities: per-instruction, per-addressing-mode, per-addressing-mode-constant
  - Also supports instruction pair models (`mean_per_pair_addressing_mode_constant`)
  - Inference: `dominant-key`, `map`, `upper-bound-lp`, `least-squares`, `least-squares-nnpivot`, `least-squares-nnls`, `least-squares-fnnls`

#### `src/types.jl`
Core type definitions:
- `Instruction`: opcode, operands, data_size, rpt_nested
- `Operand`: value, addressing mode
- `ExecutionEvent`: type, inst, memory_access_info, key
- `ExecutionTrace`: Vector of ExecutionEvents
- `MachineState`: registers, memory, cache, flags, repeat_counter, multiplier
- `TrainingData`: execution_traces, energies
- `ModelGranularity`: enum with PerOpcode, PerAddressingMode, PerAddressingModeConstant, and variants with memory access tracking
- `MultiplierState`: hardware multiplier peripheral state

#### `src/parser.jl`
Parses MSP430 assembly (from objdump output). Handles both 16-bit and 20-bit addressing modes.

#### `src/instruction_handlers.jl`
Main entry point that includes the modular instruction handler system. The handlers are organized under `src/handlers/`:
- `handlers/types.jl`: Abstract and concrete handler type definitions
- `handlers/common.jl`: Shared utilities (validation, RMW helper)
- `handlers/dispatch.jl`: Handler lookup and PC advancement logic
- `handlers/dual_operand.jl`: MOV, ADD, ADDC, SUB, SUBC, CMP, DADD, BIT, BIC, BIS, XOR, AND
- `handlers/jump.jl`: JMP, JZ, JNZ, JC, JNC, JN, JGE, JL
- `handlers/single_operand/`:
  - `rotate_shift.jl`: RRC, RRCM, SWPB, RRA, RRUX, RRUM, SXT, INV, RLC, RLA, RLAM
  - `stack_flow.jl`: PUSH, PUSHM, POP, POPM, CALL, CALLA, RET, RETA, RETI, BR
  - `arithmetic.jl`: CLR, INC, DEC, INCD, DECD, ADC, SBC
  - `control.jl`: DINT, EINT, SETC, CLRC, NOP, RPT

#### `src/machine_state.jl`
Cache simulation logic, memory region classification, and hardware multiplier implementation.

#### `src/TraceMetrics.jl`
Utilities for trace analysis including memory region classification (FRAM/SRAM) and event access computation.

### Scripts (scripts/)

`scripts/` is the Python import root: the packages below are installed in
editable mode by `uv sync`, so they import as `pipeline.*`, `measurement.*`,
`benchmarks.*`, `reports.*` and `analysis.*`.

#### `scripts/pipeline/`
- `cli.py`: The `pem` entry point; every command is a subparser here
- `config.py`: Toolchain paths, compiler flags and directory layout, from the environment
- `build.py`: Compilation and disassembly
- `measure.py`: Compile → flash → measure → preprocess for one file
- `train.py`, `train_and_estimate.py`, `analyze_distribution.py`: The pipelines
- `commands.py`: compile, disasm, interpret, estimate, flash, info, clean
- `fixtures.py`: Test fixture creation through the GDB simulator
- `files.py`: Glob, brace and basename matching of file patterns
- `defines.py`: Handling of the `"FOO=1 BAR"` macro lists
- `process.py`: Subprocess and Julia invocation helpers
- `testing.py`: The Julia and Python test suites
- `log.py`, `errors.py`: Console logging and the `PipelineError` type

#### `scripts/measurement/`
- `measure.py`: Flash, run, and measure one program (see `docs/measurement_setup.md`)
- `flash.py`: Flash a program without measuring it
- `check_switchboard.py`: Verify that the switchboard relays connect and isolate the ez-FET
- `preprocess.py`: Processes raw measurements into CSV format
- `device/otii.py` (Otii session, switchboard relays), `device/flash.py`
  (mspdebug `flash_and_hold`), `device/recording.py` (recording and CSV
  export), plus `errors.py` and `log.py`

#### `scripts/benchmarks/`
- `common.py`: Instruction specs and benchmark templates
- `gen_benchmarks.py`: Generate synthetic benchmarks for training
- `list_benchmarks.py`: List available benchmarks
- `extract_bench_labels.py`: Extract event labels from `BENCH()` macros
- `selection.py`: Filter the benchmark listing down to a set of parameter keys
- `generate_required.py`: Generate the benchmarks a program needs
- `generate_from_keys.py`: Generate benchmarks from a keys file
- `compile_branch_benchmark.py`: Two-pass compile for branch benchmarks
- `hardcoded/`: Hand-written C benchmarks

#### `scripts/reports/`
- `generate_comparison_report.py`: Compare estimated vs measured energy
- `generate_distribution_report.py`: Analyze energy distributions

#### `scripts/analysis/`
Ad-hoc plotting tools: `compare_boards_heatmap.py`, `compare_boards_scatter.py`,
`compare_params.py`, `plot_instruction_costs.py`, `plot_measurement_setup.py`

### Test Structure
- `test/runtests.jl`: Main test suite
- `test/test_interpreter.jl`: Interpreter correctness tests (compare against GDB)
- `test/test_br_immediate.jl`: Branch immediate instruction tests
- `test/test_estimate.jl`: Energy estimation tests
- `test/test_sram_code.jl`: SRAM code execution tests
- `test/test_stack_events.jl`: Stack event handling tests
- `test/test_train.jl`: Training functionality tests
- `test/python/`: Python test suite (unittest), run by `uv run pem test`
- `test/fixtures/`: Test fixture data files

## MSP430 Addressing Modes

The interpreter handles 7 MSP430 addressing modes:
- `:register`: Register contents (Rn)
- `:indexed`: Indexed (X(Rn))
- `:symbolic`: Symbolic (X(PC))
- `:absolute`: Absolute address (&addr)
- `:indirect`: Indirect register (@Rn)
- `:autoincrement`: Indirect autoincrement (@Rn+)
- `:immediate`: Immediate constant (#N)

## Adding New Instructions

To add a new MSP430 instruction:
1. Create a handler type (`struct XxxHandler <: [BaseType] end`) in `handlers/types.jl`
2. Add it to `INSTRUCTION_HANDLERS` dict in `handlers/dispatch.jl`
3. Implement `execute!(state, ::XxxHandler, ops, data_size, addresses, current_idx)` in the appropriate handler file
4. Optionally override `should_advance_pc(::XxxHandler, state, ops)` in `handlers/dispatch.jl`

## Commit Guidelines

- Do not include Claude Code signature in commits
- Keep commit messages simple and concise
