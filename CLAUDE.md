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

### Testing
```bash
# Run all tests (Julia and Python)
make test

# Run specific test fixture by pattern
make test PATTERN="{fixture_name}"
```

### Interpreting MSP430 Programs
```bash
# Compile and interpret a C or assembly file
make interpret FILE=<file.c|file.S>

# With optional parameters
make interpret FILE=examples/misc/simple.c MAX_STEPS=1000
make interpret FILE=<file.c> GRANULARITY=addressing_mode
make interpret FILE=<file.c> MODEL=mean_per_addressing_mode

# Valid GRANULARITY values: opcode, addressing_mode, addressing_mode_constant, opcode_pair, addressing_mode_pair, addressing_mode_constant_pair
```

### Training Energy Models
```bash
# Train from measurement data
make train FILES="examples/**/*.c" MODEL=mean_per_addressing_mode INFERENCE=dominant-key

# With output file
make train FILES="examples/**/*.c" PARAMS=output.json
```

### Estimating Energy Consumption
```bash
# Estimate energy for a program using trained parameters
make estimate FILE=<file.c> PARAMS=<params.json>

# With optional parameters
make estimate FILE=<file.c> PARAMS=params.json PLOT=output.png MAX_STEPS=1000
```

### Full Pipeline
```bash
# Train and estimate in one command
make train_and_estimate TRAIN_FILES="examples/benchmarks/*.c" ESTIMATE_FILE=examples/misc/test.c
```

### Other Commands
```bash
make compile FILE=<file.c>             # Compile to MSP430 binary
make disasm FILE=<file.c>              # Compile and disassemble
make flash FILE=<file.c>               # Flash binary to microcontroller
make analyze_distribution FILES=<pattern>  # Flash, measure, and analyze energy distribution
make generate_required_benchmarks FILE=<file.c>  # Generate benchmarks for a C file
make info                              # Show build and toolchain information
make clean                             # Clean build artifacts
make help                              # Show all available commands
```

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
  - Inference: `dominant-key`, `least-squares`, `least-squares-nnpivot`, `least-squares-nnls`, `least-squares-fnnls`

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

### Python Scripts (scripts/)

#### Measurement and Analysis
- `measure.py`: Interfaces with Otii Ace Pro to measure energy consumption
- `preprocess.py`: Processes raw measurements into CSV format
- `generate_comparison_report.py`: Compare estimated vs measured energy
- `generate_distribution_report.py`: Analyze energy distributions
- `analyze_least_squares.py`: Analyze least-squares training results

#### Benchmark Generation
- `gen_benchmarks.py`: Generate synthetic benchmarks for training
- `list_benchmarks.py`: List available benchmarks

#### Test Files (in scripts/)
- `test_generate_addressing_mode_benchmarks.py`: Tests for addressing mode benchmarks
- `test_generate_pair_benchmarks.py`: Tests for pair benchmarks
- `test_granularity_mapping.py`: Tests for granularity mapping
- `test_makefile_targets.py`: Tests for Makefile targets
- `test_shell_utils.py`: Tests for shell utilities

### Shell Scripts (scripts/)
- `train.sh`: Full training pipeline
- `train_and_estimate.sh`: Train + estimate + compare
- `analyze_distribution.sh`: Flash + measure + analyze
- `interpret.sh`: Interpret a compiled program
- `disasm.sh`: Disassembly utilities
- `common.sh`: Shared shell utilities
- `pipeline_utils.sh`: Pipeline helper functions
- `file_expansion_utils.sh`: File glob expansion utilities
- `generate_required_benchmarks.sh`: Generate benchmarks for specific files

### Test Structure
- `test/runtests.jl`: Main test suite
- `test/test_interpreter.jl`: Interpreter correctness tests (compare against GDB)
- `test/test_br_immediate.jl`: Branch immediate instruction tests
- `test/test_estimate.jl`: Energy estimation tests
- `test/test_sram_code.jl`: SRAM code execution tests
- `test/test_stack_events.jl`: Stack event handling tests
- `test/test_train.jl`: Training functionality tests
- `test/fixtures/`: Test fixture data files
- `test/scripts/`: Test helper scripts (e.g., create_fixture.sh)

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
