// Minimal test for signed division by 3
// This isolates the division operation that fails in activity_recognition

#include "setup.h"
#include <stdint.h>

volatile int16_t dividend = -46;
volatile int16_t quotient;

int main() {
    initialize();
    begin_measurement_window();
    begin_event();

    quotient = dividend / 3;  // Should be -15

    end_event();
    end_measurement_window();
    return 0;
}
