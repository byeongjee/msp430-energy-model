#include "setup.h"

int main() {
  initialize();

  // Test RPT instruction
  // RPT repeats the next instruction N+1 times
  unsigned int value = 0xF000;

  // Use inline assembly to test rpt with rrax (arithmetic right shift)
  // rpt #3 { rrax.w r12 should shift right 4 times (3+1)
  __asm__("mov %0, r12\n\t"
          "rpt #3\n\t"
          "rrax.w r12\n\t"
          "mov r12, %0"
          : "+m" (value)
          :
          : "r12");

  return value;
}
