#include <stdint.h>

// Test 20-bit address mode instructions
// This test verifies that mova, pushm.a, and popm.a correctly handle 20-bit
// values

void test_20bit_operations(void) {
  // Use inline assembly to test 20-bit instructions
  __asm__ volatile(
      // Load a 20-bit immediate value into R12 using mova
      // If mova only handles 16 bits, the upper 4 bits would be lost
      // Expected: R12 = 0x12345, not 0x2345
      "mova #0x12345, r12\n\t"

      // Load another 20-bit value into R13
      // Expected: R13 = 0xABCDE, not 0xBCDE
      "mova #0xABCDE, r13\n\t"

      // Save R12 and R13 using pushm.a (should push 4 bytes per register)
      // If pushm.a only saves 2 bytes, upper 4 bits would be lost
      "pushm.a #2, r13\n\t"

      // Corrupt R12 and R13 to verify they get restored properly
      "mova #0x00000, r12\n\t"
      "mova #0x00000, r13\n\t"

      // Restore R12 and R13 using popm.a (should pop 4 bytes per register)
      // If popm.a only restores 2 bytes, upper 4 bits would be 0
      "popm.a #2, r13\n\t"

      // Now R12 should be 0x12345 and R13 should be 0xABCDE
      // This validates all three operations work correctly
      :
      :
      : "r12", "r13", "memory");
}

int main(void) {
  test_20bit_operations();

  // After the test:
  // If implemented correctly: R13 = 0xABCDE

  return 0;
}
