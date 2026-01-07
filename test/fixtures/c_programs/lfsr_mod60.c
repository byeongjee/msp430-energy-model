// Test LFSR + modulo 60 pattern (the exact pattern from activity_recognition "moving" case)
// This combines simple_rand() with the (% 60) - 30 transformation

#include <stdint.h>

volatile uint16_t lfsr_state = 0xACE1;
volatile int16_t results[8];  // Store multiple results to catch accumulated errors

uint16_t simple_rand(void) {
    uint16_t lsb = lfsr_state & 1;
    lfsr_state >>= 1;
    if (lsb) {
        lfsr_state ^= 0xB400;
    }
    return lfsr_state;
}

int main(void) {
    // This is the exact pattern from activity_recognition "moving" case:
    // sample->x = (simple_rand() % 60) - 30;
    for (int i = 0; i < 8; i++) {
        results[i] = (int16_t)((simple_rand() % 60) - 30);
    }

    return 0;
}
