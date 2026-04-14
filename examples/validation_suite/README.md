# Validation Suite

Synthetic basic blocks for validating `mean_per_addressing_mode` without mixing
them into the existing microbench directory.

Current file:

- `synthetic_basic_blocks.c`: four hand-written blocks
  - `bench_register_only`
  - `bench_load_compute`
  - `bench_load_compute_store`
  - `bench_pointer_walk`
- `register_only.c`, `load_compute.c`, `load_compute_store.c`, `pointer_walk.c`:
  one-file-per-block entrypoints for `make estimate`
- `synthetic_basic_blocks_common.h`: shared data setup and block bodies

The default repetition settings are chosen to make each event measurable while
keeping the pointer-walk buffers small:

- `NUM_REPEAT=12`
- `INNER_ITERS=64`
- `TEXTUAL_REPT=32`

You can override them through the existing `DEFINES` interface, for example:

```bash
make disasm FILE=examples/validation_suite/synthetic_basic_blocks.c
make interpret FILE=examples/validation_suite/synthetic_basic_blocks.c MODEL=mean_per_addressing_mode
make analyze_distribution FILES="examples/validation_suite/synthetic_basic_blocks.c" DEFINES="NUM_REPEAT=20 INNER_ITERS=80 TEXTUAL_REPT=40"
```
