#include <msp430.h>

int main(void) {
    __asm__ volatile(
        "mov #0xFFFF, r4\n"  // R4 = 0xFFFF
        "add #1, r4\n"       // Wraps to 0x0000, should set Z and C
    );
    return 0;
}
