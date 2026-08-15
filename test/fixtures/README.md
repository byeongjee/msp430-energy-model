# Test Fixtures

This directory contains test fixtures for the MSP430 interpreter. Each fixture consists of:
- `.asm` file: Disassembled MSP430 code
- `.json` file: Expected register and flag values from GDB simulation

## Creating Fixtures

Use the `pem create-fixture` command:
```bash
uv run pem create-fixture --file examples/misc/test_example.c --name test_example
```

## Known GDB Simulator Limitations

The GDB MSP430 simulator has some limitations that cause expected test failures:

### Interrupt Control Instructions (eint, dint)

**Affected tests:** `test_eint`, `test_dint_eint`

The GDB simulator does not properly track the GIE (Global Interrupt Enable) bit in the Status Register:
- `eint` should set SR bit 3 (GIE) → our interpreter: 0x0008 ✓, GDB: 0x0000 ❌
- `dint` should clear SR bit 3 (GIE) → our interpreter: 0x0000 ✓, GDB: 0x0000 ✓

**Result:** Tests comparing interrupt enable state will fail with SR mismatches.

**Resolution:** Our interpreter implementation is correct per MSP430 specification. These test failures are expected and indicate GDB limitations, not interpreter bugs.

### Other Status Register Flags

GDB may not properly track all status register flags in simulation mode. When test fixtures show SR=0x0000 but the interpreter shows non-zero SR values for flag-setting instructions, verify the interpreter behavior against the MSP430 Family User's Guide rather than assuming the interpreter is wrong.
