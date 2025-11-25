#include <msp430.h>
#include <stdint.h>

// Minimal reproducer for GDB MSP430 simulator bug with symbolic addressing
// The GDB simulator fails to correctly handle PC-relative (symbolic) addressing
// in the ADD instruction.

static volatile uint16_t global_value = 0x1234;

int main(void) {
  // Ensure the value is written (not optimized from .data section)
  global_value = 0x1234;

  uint16_t result = 0;

  // This generates: add 0xXXXX, r12  ; PC rel. &global_value
  // The symbolic addressing should read global_value (0x1234) and add to result
  // Expected: result = 0 + 0x1234 = 0x1234
  // GDB bug: result stays 0
  __asm__ volatile("sub.w global_value, %0\n"
                   : "+r"(result)
                   :
                   : "cc", "memory");

  // Return result - should be 0x1234, but GDB returns 0
  return result;
}
