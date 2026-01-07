/**
 * Test SXT (Sign Extend) instruction flag behavior
 *
 * This test verifies that SXT properly sets the V and C flags:
 * - V flag should always be reset to 0
 * - C flag should be set to NOT Z (C=1 if result != 0, C=0 if result == 0)
 *
 * Test case 1 (V flag reset):
 * - Set V=1 by causing an overflow (0x7FFF + 1 = 0x8000)
 * - Execute SXT on a register
 * - V should become 0 after SXT
 * - If V=0 (correct), write 0xCAFE to result_v
 * - If V=1 (buggy), write 0xBEEF to result_v
 *
 * Test case 2 (C flag with non-zero result):
 * - Execute SXT on 0x0080 (sign bit set in low byte)
 * - Result will be 0xFF80 (non-zero)
 * - C should be 1 (NOT Z, since result != 0)
 * - If C=1 (correct), write 0xCAFE to result_c_nonzero
 * - If C=0 (buggy), write 0xBEEF to result_c_nonzero
 *
 * Test case 3 (C flag with zero result):
 * - Execute SXT on 0x0000 (zero in low byte)
 * - Result will be 0x0000 (zero)
 * - C should be 0 (NOT Z, since result == 0)
 * - If C=0 (correct), write 0xCAFE to result_c_zero
 * - If C=1 (buggy), write 0xBEEF to result_c_zero
 */

#include <stdint.h>

volatile uint16_t result_v = 0;
volatile uint16_t result_c_nonzero = 0;
volatile uint16_t result_c_zero = 0;

int main(void) {
    // Test 1: V flag should be reset after SXT
    // First cause overflow to set V=1, then SXT should clear it
    __asm__ __volatile__(
        "mov #0x7FFF, r5\n\t"           // r5 = 0x7FFF (max positive)
        "add #1, r5\n\t"                // r5 = 0x8000, V=1 (overflow: positive + positive = negative)
        "mov #0x0001, r6\n\t"           // r6 = 0x0001 (non-zero low byte, positive)
        "sxt r6\n\t"                    // Sign extend r6, V should become 0
        "jn v_test_check\n\t"           // N flag check (SXT sets N based on result)
        "v_test_check:\n\t"
        // Check V flag using JGE/JL (these depend on N XOR V)
        // After SXT on 0x0001: result=0x0001, N=0, Z=0, V should be 0
        // If V=0: N XOR V = 0 XOR 0 = 0, so JGE will jump
        // If V=1: N XOR V = 0 XOR 1 = 1, so JGE will not jump
        "jge v_flag_correct\n\t"        // Jump if (N XOR V)=0
        "mov #0xBEEF, %0\n\t"           // Bug: V=1 (not reset)
        "jmp v_done\n\t"
        "v_flag_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=0
        "v_done:\n\t"
        : "=m" (result_v)
        :
        : "r5", "r6"
    );

    // Test 2: C flag should be 1 when result is non-zero
    // SXT on 0x0080 -> 0xFF80 (non-zero), C should be 1 (NOT Z)
    __asm__ __volatile__(
        "mov #0x0080, r5\n\t"           // r5 = 0x0080 (sign bit set in low byte)
        "sxt r5\n\t"                    // Sign extend: 0x0080 -> 0xFF80, C should be 1
        "jc c_nonzero_correct\n\t"      // Jump if C=1 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=0
        "jmp c_nonzero_done\n\t"
        "c_nonzero_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=1
        "c_nonzero_done:\n\t"
        : "=m" (result_c_nonzero)
        :
        : "r5"
    );

    // Test 3: C flag should be 0 when result is zero
    // SXT on 0x0000 -> 0x0000 (zero), C should be 0 (NOT Z, Z=1 so C=0)
    __asm__ __volatile__(
        "setc\n\t"                      // Set C=1 first to ensure SXT changes it
        "mov #0x0000, r5\n\t"           // r5 = 0x0000
        "sxt r5\n\t"                    // Sign extend: 0x0000 -> 0x0000, C should be 0
        "jnc c_zero_correct\n\t"        // Jump if C=0 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=1
        "jmp c_zero_done\n\t"
        "c_zero_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=0
        "c_zero_done:\n\t"
        : "=m" (result_c_zero)
        :
        : "r5"
    );

    return 0;
}
