/**
 * Test ADDC and SUBC carry flag behavior
 *
 * This test verifies that the carry-in is properly included in the
 * carry-out computation for ADDC and SUBC instructions.
 *
 * Test case 1 (ADDC):
 * - Set C=1 (setc)
 * - dst=0xFFFF, src=0x0000
 * - ADDC: result = 0xFFFF + 0x0000 + 1 = 0x10000 (wraps to 0x0000)
 * - Correct: C=1 (overflow occurred because 0xFFFF + 0x0000 + 1 > 0xFFFF)
 * - Bug: C=0 (only checks 0xFFFF + 0x0000 <= 0xFFFF)
 * - If C=1 (correct), write 0xCAFE to result_addc
 * - If C=0 (buggy), write 0xBEEF to result_addc
 *
 * Test case 2 (SUBC):
 * - Set C=0 (clrc) -> borrow_in = 1
 * - dst=0x0001, src=0x0001
 * - SUBC: result = 0x0001 - 0x0001 - 1 = 0xFFFF (underflow)
 * - Correct: C=0 (borrow occurred because 0x0001 < 0x0001 + 1)
 * - Bug: C=1 (only checks 0x0001 >= 0x0001)
 * - If C=0 (correct), write 0xCAFE to result_subc
 * - If C=1 (buggy), write 0xBEEF to result_subc
 */

#include <stdint.h>

volatile uint16_t result_addc = 0;
volatile uint16_t result_subc = 0;

int main(void) {
    // Test ADDC carry flag with carry-in
    // C=1, dst=0xFFFF, src=0x0000 -> result=0x0000, C should be 1
    __asm__ __volatile__(
        "setc\n\t"                      // Set carry flag (C=1)
        "mov #0xFFFF, r5\n\t"           // dst = 0xFFFF
        "addc #0x0000, r5\n\t"          // r5 = 0xFFFF + 0x0000 + 1 = 0x0000, C should be 1
        "jc addc_carry_set\n\t"         // Jump if C=1 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=0, write 0xBEEF
        "jmp addc_done\n\t"
        "addc_carry_set:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=1, write 0xCAFE
        "addc_done:\n\t"
        : "=m" (result_addc)
        :
        : "r5"
    );

    // Test SUBC carry flag with borrow-in
    // C=0 (borrow_in=1), dst=0x0001, src=0x0001 -> result=0xFFFF, C should be 0
    __asm__ __volatile__(
        "clrc\n\t"                      // Clear carry flag (C=0, borrow_in=1)
        "mov #0x0001, r5\n\t"           // dst = 0x0001
        "subc #0x0001, r5\n\t"          // r5 = 0x0001 - 0x0001 - 1 = 0xFFFF, C should be 0
        "jnc subc_no_carry\n\t"         // Jump if C=0 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=1, write 0xBEEF
        "jmp subc_done\n\t"
        "subc_no_carry:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=0, write 0xCAFE
        "subc_done:\n\t"
        : "=m" (result_subc)
        :
        : "r5"
    );

    return 0;
}
