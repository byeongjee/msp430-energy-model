// Test pop instruction
// pop is used by compiler-generated division routines

#include <stdint.h>

volatile uint16_t divisor = 7;
volatile uint16_t result;

int main(void) {
    // Division by variable triggers software division routine which uses pop
    uint16_t val = 100;
    result = val / divisor;  // This will use __mspabi_divu which has pop
    return 0;
}
