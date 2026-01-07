/**
 * Test AND instruction flag behavior
 *
 * This test verifies that AND correctly sets flags per MSP430 spec:
 * - V flag should always be 0
 * - C flag should be NOT Z (C=1 when result != 0, C=0 when result == 0)
 *
 * Test case 1 (C flag with non-zero result):
 * - dst=0x00FF, src=0x0F0F
 * - AND: result = 0x00FF & 0x0F0F = 0x000F (non-zero)
 * - Correct: C=1 (result != 0, so C = NOT Z = NOT 0 = 1)
 * - Bug: C is computed using :sub flag behavior
 * - If C=1 (correct), write 0xCAFE to result_c_nonzero
 * - If C=0 (buggy), write 0xBEEF to result_c_nonzero
 *
 * Test case 2 (C flag with zero result):
 * - dst=0x00F0, src=0x0F00
 * - AND: result = 0x00F0 & 0x0F00 = 0x0000 (zero)
 * - Correct: C=0 (result == 0, so C = NOT Z = NOT 1 = 0)
 * - If C=0 (correct), write 0xCAFE to result_c_zero
 * - If C=1 (buggy), write 0xBEEF to result_c_zero
 *
 * Test case 3 (V flag should be 0):
 * - dst=0x8000, src=0xFFFF (negative & negative)
 * - AND: result = 0x8000 & 0xFFFF = 0x8000 (negative)
 * - Correct: V=0 (AND always clears V)
 * - Bug: V might be set by :sub flag behavior
 * - We use JGE/JL to test V indirectly: with N=1 and V=0, JL (N XOR V = 1) should jump
 * - If V=0 (correct), JL jumps -> write 0xCAFE to result_v_flag
 * - If V=1 (buggy), JGE jumps (N XOR V = 0) -> write 0xBEEF to result_v_flag
 */

#include <stdint.h>

volatile uint16_t result_c_nonzero = 0;
volatile uint16_t result_c_zero = 0;
volatile uint16_t result_v_flag = 0;

int main(void) {
    // Test 1: C flag with non-zero result
    // AND with non-zero result should set C=1 (C = NOT Z)
    __asm__ __volatile__(
        "mov #0x00FF, r5\n\t"           // dst = 0x00FF
        "and #0x0F0F, r5\n\t"           // r5 = 0x00FF & 0x0F0F = 0x000F, C should be 1
        "jc c_nonzero_set\n\t"          // Jump if C=1 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=0, write 0xBEEF
        "jmp c_nonzero_done\n\t"
        "c_nonzero_set:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=1, write 0xCAFE
        "c_nonzero_done:\n\t"
        : "=m" (result_c_nonzero)
        :
        : "r5"
    );

    // Test 2: C flag with zero result
    // AND with zero result should set C=0 (C = NOT Z)
    __asm__ __volatile__(
        "mov #0x00F0, r5\n\t"           // dst = 0x00F0
        "and #0x0F00, r5\n\t"           // r5 = 0x00F0 & 0x0F00 = 0x0000, C should be 0
        "jnc c_zero_clear\n\t"          // Jump if C=0 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=1, write 0xBEEF
        "jmp c_zero_done\n\t"
        "c_zero_clear:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=0, write 0xCAFE
        "c_zero_done:\n\t"
        : "=m" (result_c_zero)
        :
        : "r5"
    );

    // Test 3: V flag should always be 0
    // AND should always clear V flag
    // With result negative (N=1) and V=0, JL (N XOR V = 1) should jump
    __asm__ __volatile__(
        "mov #0x8000, r5\n\t"           // dst = 0x8000 (negative)
        "and #0xFFFF, r5\n\t"           // r5 = 0x8000 & 0xFFFF = 0x8000 (negative), V should be 0
        "jl v_flag_clear\n\t"           // Jump if N XOR V = 1 (with N=1, V=0 -> jumps)
        "mov #0xBEEF, %0\n\t"           // Bug: V=1 (N XOR V = 0, didn't jump)
        "jmp v_flag_done\n\t"
        "v_flag_clear:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=0, write 0xCAFE
        "v_flag_done:\n\t"
        : "=m" (result_v_flag)
        :
        : "r5"
    );

    return 0;
}
