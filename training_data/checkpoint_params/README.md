# Checkpoint Insertion Parameters

Energy parameters for checkpoint insertion on MSP430FR5994 at 16 MHz.

## Parameters

| Parameter | Description |
|-----------|-------------|
| `nvm_access_penalty` | `max(\|nvm_read - vm_read\|, \|nvm_write - vm_write\|)` per access |
| `mem_store_energy_per_byte` | Per-byte cost of copying SRAM -> FRAM (checkpoint save) |
| `mem_restore_energy_per_byte` | Per-byte cost of copying FRAM -> SRAM (checkpoint restore) |

## Reproduce from existing data

```bash
uv run python training_data/checkpoint_params/compute_parameters.py \
    report/checkpoint_params/analyze_distribution/20260323_164609/segments.csv
```

## Re-run measurements from scratch

```bash
make analyze_distribution \
    FILES="training_data/checkpoint_params/*.c" \
    DEFINES="NUM_REPEAT=50" \
    REPORT_DIR=report/checkpoint_params
```

Then compute parameters from the new segments file:

```bash
uv run python training_data/checkpoint_params/compute_parameters.py \
    report/checkpoint_params/analyze_distribution/<timestamp>/segments.csv
```

## Benchmark design

### `nvm_access_penalty.c`

Four micro-benchmarks isolating per-access energy:

- `bench_sram_read` / `bench_fram_read_miss`: 3 reads per `.rept` iteration (30,000 total). FRAM reads use a 3-address cache-thrashing pattern (offsets 0, 16, 32 bytes) that maps all accesses to the same cache set, guaranteeing 100% miss rate with the 2-way associative cache.
- `bench_sram_write` / `bench_fram_write`: 1 write per `.rept` iteration (10,000 total). FRAM writes are inherently uncached.

### `mem_copy_energy.c`

Twelve copy benchmarks (6 store + 6 restore) for sizes 2, 8, 32, 64, 128, 256 bytes. Each copy repeats `INNER_ITERS` (100) times per event. Linear regression of energy vs size gives per-byte cost.
