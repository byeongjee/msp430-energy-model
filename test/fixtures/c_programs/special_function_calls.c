#include "setup.h"

int main(void) {
    initialize();

    volatile unsigned int ua = 100;
    volatile unsigned int ub = 7;
    volatile int16_t sa = -100;
    volatile int16_t sb = 7;
    volatile int32_t la = 100000;
    volatile int32_t lb = 7;

    begin_measurement_window();

    begin_event();
    volatile unsigned int c = ua / ub;  // triggers __mspabi_divu
    end_event();

    begin_event();
    volatile unsigned int d = ua * ub;  // triggers __mspabi_mpyi
    end_event();

    begin_event();
    volatile int16_t e = sa / sb;  // triggers __mspabi_divi
    end_event();

    begin_event();
    volatile unsigned int f = ua % ub;  // triggers __mspabi_remu
    end_event();

    begin_event();
    volatile int32_t g = la / lb;  // triggers __mspabi_divli
    end_event();

    end_measurement_window();

    return 0;
}
