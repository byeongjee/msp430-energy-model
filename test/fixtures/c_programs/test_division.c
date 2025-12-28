// Test division subroutines (__mspabi_divu, udivmodhi4)
// Division by a variable triggers compiler-generated division routines
// These routines use various MSP430X instructions (rlam, rrum, etc.)

#include <stdint.h>

volatile uint16_t divisor = 7;
volatile uint16_t result;

int main(void) {
    // Division by variable triggers software division routine
    // 100 / 7 = 14 (quotient), remainder = 2
    uint16_t val = 100;
    result = val / divisor;
    return 0;
}
