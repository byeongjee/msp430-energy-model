# Hardcoded Benchmarks

This directory contains benchmarks that use handwritten control flow and need a helper script to emit stable `.S` sources for the normal pipeline.

## br_immediate

The `br_immediate` benchmark creates a chain of `br` (branch) instructions where each instruction jumps to the next one, and the last one jumps to an inline-asm footer that maintains the outer loop.

### Compilation

**Important:** Do not compile this file using `make compile` or `make disasm` directly. Use the helper script that emits a standalone `.S` file:

```bash
./scripts/benchmarks/compile_br_immediate_benchmark.sh --file scripts/benchmarks/hardcoded/br_immediate_benchmark.c
```

### How Assembly Generation Works

1. Compile the C benchmark to assembly with `gcc -S`
2. Keep the full branch-chain control flow inside one inline-asm block so the optimizer cannot duplicate labels
3. Normalize the emitted ISA attribute and write `build/asm/<benchmark>.S`

This generates `build/asm/br_immediate_benchmark.S` which can then be compiled normally.

### Using the Generated .S File

After generating the `.S` file, you can use it with all make targets:

```bash
# Compile to ELF
make compile FILE=build/asm/br_immediate_benchmark.S

# Disassemble
make disasm FILE=build/asm/br_immediate_benchmark.S

# Interpret
make interpret FILE=build/asm/br_immediate_benchmark.S
```

### Custom Defines

You can pass custom defines to the helper script:

```bash
./scripts/benchmarks/compile_br_immediate_benchmark.sh \
    --file scripts/benchmarks/hardcoded/br_immediate_benchmark.c \
    --defines "TEXTUAL_REPT=50 INNER_ITERS=200"
```

### Integration with gen_benchmarks.py

When `gen_benchmarks.py` encounters a hardcoded benchmark:

1. Automatically runs the branch benchmark helper
2. Copies the generated `.S` file to the output directory

Example:
```bash
python -m benchmarks.list_benchmarks --granularity addressing_mode_constant \
    | jq '.instructions[] | select(.opcode == "br")' \
    | jq -s '{instructions: .}' \
    | python -m benchmarks.gen_benchmarks \
        --granularity addressing_mode_constant \
        --output-dir /path/to/output
```

This generates `/path/to/output/br_immediate.S` automatically.

## special_function_call

Benchmarks for MSP430 ABI software function calls (`__mspabi_divi`, `__mspabi_divli`, `__mspabi_divu`, `__mspabi_mpyi`, `__mspabi_mpyl`, `__mspabi_remu`). The multiply helpers are normally inlined by GCC when targeting MSP430FR5994 (which has a hardware multiplier), so the shared benchmark must be compiled with `-mhwmult=none` to force software calls consistently.

The shared source also uses a file-local `SPECIAL_FUNCTION_CALL_INNER_ITERS=100`
runtime loop so each GPIO-bounded event stays long enough to survive the
measurement export/preprocess pipeline.

### Keys

- `call___mspabi_divi` — signed 16-bit division
- `call___mspabi_divli` — signed 32-bit division
- `call___mspabi_divu` — unsigned 16-bit division
- `call___mspabi_mpyi` — signed 16-bit multiplication
- `call___mspabi_mpyl` — signed 32-bit multiplication
- `call___mspabi_remu` — unsigned 16-bit remainder

### Compilation

The `gen_benchmarks.py` script handles compilation automatically with `-mhwmult=none`. To compile manually:

```bash
make disasm FILE=scripts/benchmarks/hardcoded/special_function_call_benchmark.c MSP430_CFLAGS="-mmcu=MSP430FR5994 -mcpu=msp430 -msmall -mno-warn-mcu -O3 -mhwmult=none"
```

### Integration with gen_benchmarks.py

When any of the special-call keys above is requested, `gen_benchmarks.py`:

1. Compiles `special_function_call_benchmark.c` to assembly source using `gcc -S` with `-mhwmult=none` appended to `$CFLAGS`
2. Copies the resulting `.S` file to the output directory

All of the special-call keys share one source file, so it is compiled only once even if multiple keys are requested.

## Adding New Hardcoded Benchmarks

1. Create the benchmark C file in this directory
2. Update `scripts/benchmarks/compile_br_immediate_benchmark.sh` to handle the new benchmark:
   - Add any custom assembly-generation logic
   - Add benchmark name to supported list
3. Add an `InstructionSpec` in `scripts/benchmarks/common.py` with:
   ```python
   hardcoded_benchmark_path="scripts/benchmarks/hardcoded/your_benchmark.c"
   ```
4. The benchmark will automatically be included in `list_benchmarks.py` and `gen_benchmarks.py`
