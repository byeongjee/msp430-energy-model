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

1. **Pass 1:** Compile with placeholder addresses and disassemble
2. **Extract:** Parse the disassembly to find actual addresses of:
   - `loop_header` label (first br instruction)
   - Loop counter decrement instruction (`add #-1, r12`)
3. **Pass 2:** Generate `.S` assembly file with correct addresses passed as `-D` flags

This generates `build/asm/br_immediate_benchmark.S` which can then be compiled normally. The addresses are always correct, even if `setup.h` or other included files change.

### Using the Generated .S File

After running two-pass compilation, you can use the `.S` file with all make targets:

```bash
# Compile to ELF
make compile FILE=build/asm/br_immediate_benchmark.S

# Disassemble
make disasm FILE=build/asm/br_immediate_benchmark.S

# Interpret
make interpret FILE=build/asm/br_immediate_benchmark.S
```

### Custom Defines

You can pass custom defines to the two-pass compilation:

```bash
./scripts/compile_hardcoded_benchmarks.sh \
    --file scripts/hardcoded_benchmarks/br_immediate_benchmark.c \
    --defines "TEXTUAL_REPT=50 INNER_ITERS=200"
```

### Integration with gen_benchmarks.py

When `gen_benchmarks.py` encounters a hardcoded benchmark (identified by `hardcoded_benchmark_path` field):

1. Automatically runs two-pass compilation
2. Copies the generated `.S` file to the output directory

Example:
```bash
python scripts/list_benchmarks.py --granularity addressing_mode_constant \
    | jq '.instructions[] | select(.opcode == "br")' \
    | jq -s '{instructions: .}' \
    | python scripts/gen_benchmarks.py \
        --granularity addressing_mode_constant \
        --output-dir /path/to/output
```

This generates `/path/to/output/br_immediate.S` automatically.

## Adding New Hardcoded Benchmarks

1. Create the benchmark C file in this directory
2. Update `scripts/compile_hardcoded_benchmarks.sh` to handle the new benchmark:
   - Add address extraction logic
   - Add benchmark name to supported list
3. Add an `InstructionSpec` in `scripts/benchmark_common.py` with:
   ```python
   hardcoded_benchmark_path="scripts/hardcoded_benchmarks/your_benchmark.c"
   ```
4. The benchmark will automatically be included in `list_benchmarks.py` and `gen_benchmarks.py`
