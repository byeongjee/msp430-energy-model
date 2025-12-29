// Test modulo 60 operation (__mspabi_remu)
// This is the pattern used in activity_recognition for the "moving" model
// which differs from modulo 4 (uses AND instead of division routine)

#include <stdint.h>

volatile uint16_t input = 12345;  // Test input
volatile int16_t result1;          // (input % 60) - 30
volatile int16_t result2;          // Test with different input
volatile int16_t result3;          // Test with edge case

int main(void) {
    // This pattern: (val % 60) - 30 is exactly what activity_recognition does
    // The compiler generates: call __mspabi_remu, mov.b, add.b #-30, sxt

    uint16_t val1 = input;
    result1 = (int16_t)((val1 % 60) - 30);  // 12345 % 60 = 45, 45 - 30 = 15

    uint16_t val2 = 10;
    result2 = (int16_t)((val2 % 60) - 30);  // 10 % 60 = 10, 10 - 30 = -20

    uint16_t val3 = 59;
    result3 = (int16_t)((val3 % 60) - 30);  // 59 % 60 = 59, 59 - 30 = 29

    return 0;
}
