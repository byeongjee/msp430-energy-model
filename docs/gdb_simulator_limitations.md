# GDB Simulator Limitations

This document tracks known deviations between the MSP430 GDB simulator and the TI MSP430 specification. Our test framework uses GDB as ground truth for generating expected values, but in these cases the fixtures have been manually corrected to match the specification.

## Flag Computation Bugs

### RRC (Rotate Right through Carry) - V Flag

**Specification (TI SLAU208):** V flag is set if the initial destination value was positive (MSB=0) AND the initial carry flag was set.

**GDB Behavior:** V flag is not correctly computed for RRC.

**Affected Fixture:** `test/fixtures/test_rrc_flags.json`
- Address `0x1c00` manually set to `51966` (0xCAFE) instead of GDB's `48879` (0xBEEF)

### SXT (Sign Extend) - C Flag

**Specification (TI SLAU208):** C flag is set to NOT Z (C=1 if result is non-zero, C=0 if result is zero).

**GDB Behavior:** C flag is not correctly set to NOT Z for SXT.

**Affected Fixture:** `test/fixtures/test_sxt_flags.json`
- Address `0x1c02` manually set to `51966` (0xCAFE) instead of GDB's `48879` (0xBEEF)

## Stack Byte Order (CALLA/RETA)

**Specification (TI SLAU208):** CALLA pushes the 20-bit return address as:
- High nibble (bits 16-19) at SP (lower address)
- Low word (bits 0-15) at SP+2 (higher address)

**GDB Behavior:** Both GDB and our interpreter push in reversed order:
- Low word at SP
- High nibble at SP+2

**Note:** This is internally consistent (CALLA and RETA both use the same reversed order), so function calls work correctly. We match GDB behavior rather than fixing this, since it would break compatibility with GDB-generated fixtures.

**Affected Test:** `test/fixtures/test_calla_stack.c` documents this deviation but expects GDB's behavior (0xBEEF).

## Test Pattern Convention

Our flag bug tests use a marker convention:
- `0xCAFE` (51966) = Correct behavior per TI specification
- `0xBEEF` (48879) = Buggy behavior

When a fixture contains 0xBEEF as an expected value, it means:
1. GDB produced that result, AND
2. We intentionally match GDB's buggy behavior for compatibility

When a fixture is manually corrected to 0xCAFE, it means:
1. GDB produced 0xBEEF (buggy), BUT
2. We override it to match the TI specification
