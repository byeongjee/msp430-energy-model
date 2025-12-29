// Test LFSR (Linear Feedback Shift Register) operation
// This is the simple_rand() pattern from activity_recognition

#include <stdint.h>

volatile uint16_t lfsr_state = 0xACE1;  // Same initial value as activity_recognition
volatile uint16_t result1;
volatile uint16_t result2;
volatile uint16_t result3;
volatile uint16_t result4;
volatile uint16_t final_state;

uint16_t simple_rand(void) {
    uint16_t lsb = lfsr_state & 1;
    lfsr_state >>= 1;
    if (lsb) {
        lfsr_state ^= 0xB400;
    }
    return lfsr_state;
}

int main(void) {
    // Run LFSR several times to test the shift/xor pattern
    result1 = simple_rand();
    result2 = simple_rand();
    result3 = simple_rand();
    result4 = simple_rand();
    final_state = lfsr_state;

    return 0;
}
