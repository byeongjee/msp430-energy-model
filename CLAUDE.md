# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment Setup

**IMPORTANT**: Before running any commands, activate the environment:
```bash
source env.sh
source .venv/bin/activate
```

This sets up the MSP430 GCC toolchain paths and Python virtual environment.

## Common Commands

### Testing
```bash
# Run all tests
make test

# Run specific test fixture
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
make interpret FILE=<file.c> LOG_MEMORY_ACCESS=1

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
make compile FILE=<file.c>    # Compile to MSP430 binary
make disasm FILE=<file.c>     # Compile and disassemble
make clean                    # Clean build artifacts
make help                     # Show all available commands
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
- Event types: `Inst`, `FRAMReadHit`, `FRAMReadMiss`, `FRAMWrite`, `SRAMRead`, `SRAMWrite`

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
- `ExecutionEvent`: type, inst, operand_addressing_mode_and_constants
- `ExecutionTrace`: Vector of ExecutionEvents
- `MachineState`: registers, memory, cache
- `TrainingData`: event_traces, energies

#### `src/parser.jl`
Parses MSP430 assembly (from objdump output). Handles both 16-bit and 20-bit addressing modes.

#### `src/instruction_handlers.jl`
Implements execution semantics for MSP430 instructions (arithmetic, logical, control flow, memory).

#### `src/machine_state.jl`
Cache simulation logic and memory region classification.

### Python Scripts (scripts/)

#### Measurement and Analysis
- `measure.py`: Interfaces with Otii Ace Pro to measure energy consumption
- `preprocess.py`: Processes raw measurements into CSV format
- `generate_comparison_report.py`: Compare estimated vs measured energy
- `generate_distribution_report.py`: Analyze energy distributions

#### Benchmark Generation
- `gen_benchmarks.py`: Generate synthetic benchmarks for training
- `benchmark_common.py`: Shared utilities for benchmark generation

### Shell Scripts (scripts/)
- `train.sh`: Full training pipeline
- `train_and_estimate.sh`: Train + estimate + compare
- `analyze_distribution.sh`: Flash + measure + analyze

### Test Structure
- `test/runtests.jl`: Main test suite
- `test/test_interpreter.jl`: Interpreter correctness tests (compare against GDB)
- `test/test_br_immediate.jl`: Branch immediate instruction tests

## MSP430 Addressing Modes

The interpreter handles 7 MSP430 addressing modes:
- `:register`: Register contents (Rn)
- `:indexed`: Indexed (X(Rn))
- `:symbolic`: Symbolic (X(PC))
- `:absolute`: Absolute address (&addr)
- `:indirect`: Indirect register (@Rn)
- `:autoincrement`: Indirect autoincrement (@Rn+)
- `:immediate`: Immediate constant (#N)

## Commit Guidelines

- Do not include Claude Code signature in commits
- Keep commit messages simple and concise
