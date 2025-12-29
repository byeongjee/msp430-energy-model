// Test signed byte operations matching activity_recognition pattern
// Tests: LFSR -> % 60 -> subtract 30 -> signed byte -> sum -> divide by 3

#include "setup.h"
#include <stdint.h>

volatile uint16_t lfsr_state = 0xACE1;
volatile int8_t samples[3];
volatile int16_t mean_result;
volatile int16_t sum_result;

uint16_t simple_rand(void) {
    uint16_t lsb = lfsr_state & 1;
    lfsr_state >>= 1;
    if (lsb) {
        lfsr_state ^= 0xB400;
    }
    return lfsr_state;
}

int main() {
    initialize();
    begin_measurement_window();
    begin_event();

    // Generate 3 signed bytes like activity_recognition does
    samples[0] = (simple_rand() % 60) - 30;
    samples[1] = (simple_rand() % 60) - 30;
    samples[2] = (simple_rand() % 60) - 30;

    // Sum them (like mean_x += aWin[i].x)
    int16_t sum = 0;
    sum += samples[0];
    sum += samples[1];
    sum += samples[2];
    sum_result = sum;

    // Divide by 3 (like mean_x /= ACCEL_WINDOW_SIZE)
    mean_result = sum / 3;

    end_event();
    end_measurement_window();
    return 0;
}
