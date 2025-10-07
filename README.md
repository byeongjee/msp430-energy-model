# Probabilistic Energy Consumption Modeling of MSP430 Programs

This project provides tools for modeling and predicting energy consumption of MSP430 microcontroller programs using probabilistic methods.

## Features

- **Interpreter**: Execute MSP430 assembly programs in a simulated environment
- **Energy Training**: Infer energy parameters from real hardware measurements
- **Energy Estimation**: Predict energy consumption based on learned parameters

## Prerequisites

- Julia (tested on 1.11.7)
- MSP430 GCC toolchain (for compiling C programs)
- Make

## Setup

### 1. Install Julia Dependencies

This project uses Julia's package manager with `Project.toml` and `Manifest.toml` for reproducible dependency management.

First time setup:

```bash
# Navigate to the project directory
cd /path/to/probabilistic-energy-modeling

# Activate the project environment and install dependencies
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

## Usage

The main entrypoint is the Makefile, which provides three modes of operation:

### 1. Interpret Mode

Compile a C program and run the interpreter on the generated assembly:

```bash
make interpret FILE=examples/c_programs/simple.c
```

### 2. Train Mode

Train energy model from measurements:

```bash
make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv

# Optionally specify output file (default: energy_params.json)
make train FILE=examples/c_programs/simple.c DATA=measurements/segments.csv OUTPUT=my_params.json
```

### 3. Estimate Mode

Estimate energy consumption using learned parameters:

```bash
make estimate FILE=examples/c_programs/simple.c PARAMS=params.json
```
