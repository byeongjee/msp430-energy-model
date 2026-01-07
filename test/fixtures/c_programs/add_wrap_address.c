#include <msp430.h>

int main(void) {
    __asm__ volatile(
        "mova #0xFFFFF, r4\n"  // R4 = 0xFFFFF (20-bit)
        "adda #1, r4\n"        // Wraps to 0x00000, should set Z and C
    );
    return 0;
}
