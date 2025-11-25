#include "setup.h"

int main() {
  initialize();

  // Test rlc instruction - rotate left through carry
  // rlc is typically emulated as: addc Rd, Rd (add with carry)
  unsigned int value = 0x8000;
  __asm__("bis #1, r2\n\t"     // Set carry flag
          "rlc.w %0"           // Rotate left through carry
          : "+r" (value)
          :
          : "r2");

  return value;
}
