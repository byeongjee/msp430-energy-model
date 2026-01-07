/**
 * Test POP instruction with memory destination
 *
 * This test verifies that POP supports memory destinations, not just registers.
 * POP is emulated as MOV @SP+,dst, so it should support all addressing modes.
 *
 * Test case:
 * - Push a known value (0xCAFE) onto the stack
 * - Use POP to pop directly to a memory location using indexed addressing
 * - If POP to memory works correctly, result = 0xCAFE
 * - If POP to memory fails, result will be wrong (0x0000 or garbage)
 *
 * Bug: POP handler uses set_register_value! instead of set_operand_value!
 * Fix: Use set_operand_value! to support all addressing modes
 */

#include <stdint.h>

volatile uint16_t result = 0;

int main(void) {
    // Test POP with indexed memory destination
    // Push 0xCAFE, then pop directly to memory using indexed addressing X(Rn)
    __asm__ __volatile__(
        "mov #0xCAFE, r5\n\t"           // Load 0xCAFE into r5
        "push r5\n\t"                   // Push 0xCAFE onto stack
        "mov %0, r6\n\t"                // Load address of result into r6
        "pop 0(r6)\n\t"                 // Pop directly to memory via indexed addressing
        :
        : "i" (&result)
        : "r5", "r6", "memory"
    );

    return 0;
}
