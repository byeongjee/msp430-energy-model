#include "setup.h"

int main(void) {
    initialize();

    begin_measurement_window();
    begin_event();

    volatile unsigned int a = 100;
    volatile unsigned int b = 7;
    volatile unsigned int c = a * b;
    (void)c;

    end_event();
    end_measurement_window();

    return 0;
}
