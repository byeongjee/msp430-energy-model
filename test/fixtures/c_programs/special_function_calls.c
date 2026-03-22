#include "setup.h"

int main(void) {
    initialize();

    volatile unsigned int a = 100;
    volatile unsigned int b = 7;

    begin_measurement_window();

    begin_event();
    volatile unsigned int c = a / b;  // triggers __mspabi_divu
    end_event();

    begin_event();
    volatile unsigned int d = a * b;  // triggers __mspabi_mpyi
    end_event();

    end_measurement_window();

    return 0;
}
