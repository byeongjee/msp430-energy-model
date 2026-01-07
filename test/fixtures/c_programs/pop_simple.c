// Test pop instruction directly using inline assembly
#include <stdint.h>

volatile uint16_t result;

int main(void) {
    uint16_t val;

    // Push a value and pop it back
    __asm__ volatile (
        "mov #0x1234, r15\n\t"
        "push r15\n\t"
        "pop r14\n\t"
        "mov r14, %0"
        : "=r" (val)
        :
        : "r14", "r15"
    );

    result = val;
    return 0;
}
