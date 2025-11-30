# Hardcoded Benchmarks

This directory contains benchmarks that require hardcoded absolute addresses, which cannot be generated using the standard benchmark generation pipeline.

## br_immediate

The `br_immediate` benchmark creates a chain of `br` (branch) instructions where each instruction jumps to the next one, and the last one jumps back to the loop counter decrement. This requires absolute addresses.

### Compilation

**Important:** Do not compile this file using `make compile` or `make disasm` directly. Use the two-pass compilation script:

```bash
./scripts/compile_hardcoded_benchmarks.sh --file scripts/hardcoded_benchmarks/br_immediate_benchmark.c
```

### How Two-Pass Compilation Works

1. **Pass 1:** Compile with placeholder addresses defined in the source file
2. **Extract:** Parse the disassembly to find actual addresses of:
   - `loop_header` label (first br instruction)
   - Loop counter decrement instruction (`add #-1, r12`)
3. **Pass 2:** Recompile with actual addresses passed as `-D` flags:
   - `-DBR_INITIAL_ADDR=0x4154`
   - `-DLOOP_HEADER_ADDR=0x42e4`

This ensures the addresses are always correct, even if `setup.h` or other included files change.

### Custom Defines

You can pass custom defines to the two-pass compilation:

```bash
./scripts/compile_hardcoded_benchmarks.sh \
    --file scripts/hardcoded_benchmarks/br_immediate_benchmark.c \
    --defines "TEXTUAL_REPT=50 INNER_ITERS=200"
```

## Adding New Hardcoded Benchmarks

1. Create the benchmark C file in this directory
2. Update `scripts/compile_hardcoded_benchmarks.sh` to handle the new benchmark
3. Add an `InstructionSpec` in `scripts/benchmark_common.py` with `hardcoded_benchmark_path` set
4. The benchmark will automatically be included in `list_benchmarks.py` and `gen_benchmarks.py`
