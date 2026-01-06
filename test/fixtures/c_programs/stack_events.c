// Test stack event tracking for PUSH, POP, CALL, RET operations
// When should_track_memory_access=true, stack operations should generate SRAM events
// Stack is in SRAM (0x1C00-0x2BFF on MSP430FR5994)

#include "setup.h"

// Simple function to be called - forces CALL (stack write) and RET (stack read)
NOINLINE unsigned int add_one(unsigned int x) {
    return x + 1;
}

int main(void) {
    initialize();

    volatile unsigned int val = 42;
    volatile unsigned int result;

    begin_measurement_window();

    // Event 1: Test CALL/RET stack events
    // CALL pushes 16-bit return address to stack (SRAM write)
    // RET pops return address from stack (SRAM read)
    begin_event();
    result = add_one(val);
    end_event();

    // Event 2: Test explicit PUSH/POP
    // Each PUSH writes to stack (SRAM write)
    // Each POP reads from stack (SRAM read)
    begin_event();
    __asm__ volatile (
        "push r12\n\t"    // SRAM write
        "push r13\n\t"    // SRAM write
        "pop r13\n\t"     // SRAM read
        "pop r12\n\t"     // SRAM read
        :
        :
        : "r12", "r13"
    );
    end_event();

    end_measurement_window();

    // Use result to prevent optimization
    return (int)result;
}
