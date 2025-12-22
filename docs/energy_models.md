# Energy Models

This document describes all available energy models for the MSP430 energy estimation system.

## Overview

The system provides two families of energy models:

1. **Mean Models** - Deterministic models that assign a fixed mean energy cost to each event
2. **Gamma Models** - Probabilistic models using Gamma distributions to capture energy variability

Each family supports multiple granularity levels that determine how fine-grained the energy parameters are.

## Model Taxonomy

```
Energy Models
├── Mean Models (deterministic)
│   ├── Per-Instruction Models
│   │   ├── mean_per_instruction
│   │   └── mean_per_instruction_with_mem_access
│   ├── Per-Addressing-Mode Models
│   │   ├── mean_per_addressing_mode
│   │   └── mean_per_addressing_mode_with_mem_access
│   ├── Per-Addressing-Mode-Constant Models
│   │   ├── mean_per_addressing_mode_constant
│   │   └── mean_per_addressing_mode_constant_with_mem_access
│   └── Pair Models
│       └── mean_per_pair_addressing_mode_constant
│
└── Gamma Models (probabilistic)
    ├── gamma_per_instruction
    ├── gamma_per_addressing_mode
    └── gamma_per_addressing_mode_constant
```

---

## Granularity Levels

### PerOpcode (Per-Instruction)
- **Key format**: `(opcode,)`
- **Example**: `(:mov,)`, `(:add,)`, `(:push,)`
- **Description**: One energy parameter per opcode. Simplest model with fewest parameters.

### PerAddressingMode
- **Key format**: `(opcode, src_mode)` or `(opcode, src_mode, dst_mode)`
- **Example**: `(:mov, :register, :indexed)`, `(:push, :immediate)`
- **Description**: Distinguishes instructions by their addressing modes. Captures that `mov R5, R6` has different energy than `mov #5, &addr`.

### PerAddressingModeConstant
- **Key format**: Same as PerAddressingMode, but includes constant values for specific opcodes
- **Example**: `(:rlam, :immediate, 4, :register)` for `rlam #4, R5`
- **Description**: For instructions where immediate values significantly affect energy (e.g., `rlam`, `pushm`, `popm`, `rpt`), the constant value is included in the key.
- **Constant-aware opcodes**: `rlam`, `rrum`, `pushm`, `popm`, `rpt`

---

## Mean Models

Mean models assign a fixed mean energy value to each event type. They are deterministic and fast to train and estimate.

### Training Algorithms

| Algorithm | Description |
|-----------|-------------|
| `dominant-key` | For microbenchmarks: assigns total energy / event count to the dominant event type |
| `least-squares` | Solves `Ax = B` via standard least squares |
| `least-squares-nnpivot` | Non-negative least squares using pivot method |
| `least-squares-nnls` | Non-negative least squares using NNLS algorithm |
| `least-squares-fnnls` | Non-negative least squares using Fast NNLS algorithm |

### Model Descriptions

#### `mean_per_instruction`
- **Granularity**: PerOpcode
- **Parameters**: One mean energy value per opcode
- **Use case**: Quick baseline estimates, low training data requirements

#### `mean_per_addressing_mode`
- **Granularity**: PerAddressingMode
- **Parameters**: One mean energy value per (opcode, addressing_mode) combination
- **Use case**: Captures addressing mode effects on energy

#### `mean_per_addressing_mode_constant`
- **Granularity**: PerAddressingModeConstant
- **Parameters**: Like `mean_per_addressing_mode` but with constant-aware keys
- **Use case**: Most accurate single-instruction model for general programs

#### `mean_per_pair_addressing_mode_constant`
- **Granularity**: PerAddressingModeConstant (applied to pairs)
- **Parameters**: One mean energy value per consecutive instruction pair
- **Use case**: Captures inter-instruction effects (pipeline, cache)
- **Note**: Uses unordered pairs (A→B and B→A map to the same parameter)

---

## Models with Memory Access Tracking

The `_with_mem_access` suffix indicates models that track memory access events in addition to instruction execution events.

### Delta Cost Semantics

FRAM events represent the **additional cost over SRAM baseline**:
- **SRAM accesses**: No events generated. SRAM access cost is absorbed into instruction energy parameters.
- **FRAM accesses**: Generate delta-cost events representing the extra cost compared to equivalent SRAM operations.

This design reduces the parameter space from 5 memory event types to 3, making training more tractable.

### Memory Access Event Types

| Event Type | Description |
|------------|-------------|
| `FRAMReadHit` | Delta cost for FRAM read with cache hit (vs SRAM read) |
| `FRAMReadMiss` | Delta cost for FRAM read with cache miss (vs SRAM read) |
| `FRAMWrite` | Delta cost for FRAM write (vs SRAM write) |

Note: `SRAMRead` and `SRAMWrite` event types exist in the enum for backward compatibility but are never generated.

### Models

#### `mean_per_instruction_with_mem_access`
- **Base granularity**: PerOpcode
- **Additional events**: FRAM memory access events (delta costs)
- **Use case**: Separate instruction and FRAM delta energy modeling

#### `mean_per_addressing_mode_with_mem_access`
- **Base granularity**: PerAddressingMode
- **Additional events**: FRAM memory access events (delta costs)
- **Use case**: Addressing mode awareness plus FRAM delta tracking

#### `mean_per_addressing_mode_constant_with_mem_access`
- **Base granularity**: PerAddressingModeConstant
- **Additional events**: FRAM memory access events (delta costs)
- **Use case**: Most detailed memory-aware model

### How Memory Tracking Works

1. **Instruction keys** are computed using the base granularity (e.g., PerOpcode)
2. **Memory event keys** are derived from the event type (e.g., `(:FRAMReadHit,)`)
3. SRAM accesses generate no events (cost absorbed in instruction parameters)
4. FRAM accesses generate delta-cost events
5. During estimation, instruction energies + FRAM delta costs are summed

---

## Gamma Models

Gamma models use Gamma(α, β) distributions for each event type, capturing energy variability. They are probabilistic and produce energy distributions rather than point estimates.

### Training Algorithms

| Algorithm | Description |
|-----------|-------------|
| `importance-sampling` | Uses Gen.jl importance sampling for Bayesian inference |
| `mcmc-blocked` | Uses blocked Gibbs/Metropolis-Hastings sampling |

### Parameters

Each event type has two parameters:
- **α (alpha)**: Shape parameter
- **β (beta)**: Scale parameter
- **Mean energy** = α × β

### Model Descriptions

#### `gamma_per_instruction`
- **Granularity**: PerOpcode
- **Parameters**: (α, β) pair per opcode
- **Use case**: Probabilistic estimates with uncertainty quantification

#### `gamma_per_addressing_mode`
- **Granularity**: PerAddressingMode
- **Parameters**: (α, β) pair per (opcode, addressing_mode) combination
- **Use case**: Addressing mode aware probabilistic model

#### `gamma_per_addressing_mode_constant`
- **Granularity**: PerAddressingModeConstant
- **Parameters**: (α, β) pair per constant-aware key
- **Use case**: Most detailed probabilistic model

### Estimation

Gamma models generate samples by:
1. For each event in the trace, sample from Gamma(α, β)
2. Sum all samples for total program energy
3. Repeat N times to get energy distribution
4. Return statistics (mean, std, min, max, samples)

---

## Usage Examples

### Training

```bash
# Mean model with dominant-key inference
make train FILES="benchmarks/*.c" MODEL=mean_per_addressing_mode INFERENCE=dominant-key

# Mean model with least-squares inference
make train FILES="programs/*.c" MODEL=mean_per_addressing_mode_constant INFERENCE=least-squares-fnnls

# Gamma model with MCMC inference
make train FILES="benchmarks/*.c" MODEL=gamma_per_addressing_mode INFERENCE=mcmc-blocked
```

### Estimation

```bash
# Estimate with trained parameters
make estimate FILE=program.c PARAMS=trained_params.json
```

---

## Choosing a Model

| Scenario | Recommended Model |
|----------|-------------------|
| Quick baseline estimate | `mean_per_instruction` |
| General-purpose accuracy | `mean_per_addressing_mode_constant` |
| Memory-intensive programs | `mean_per_addressing_mode_constant_with_mem_access` |
| Pipeline/cache effects | `mean_per_pair_addressing_mode_constant` |
| Uncertainty quantification | `gamma_per_addressing_mode_constant` |
| Microbenchmark training | Use `dominant-key` inference |
| Mixed program training | Use `least-squares-fnnls` inference |

---

## Implementation Files

| File | Description |
|------|-------------|
| `src/models/mean.jl` | Base MeanModel implementation |
| `src/models/gamma.jl` | Base GammaModel implementation |
| `src/models/mean_pair.jl` | Base MeanPairModel implementation |
| `src/models/mean_per_*.jl` | Specific mean model constructors |
| `src/models/gamma_per_*.jl` | Specific gamma model constructors |
| `src/types.jl` | Granularity enums and key computation |
| `src/model.jl` | Model factory and interface definitions |
