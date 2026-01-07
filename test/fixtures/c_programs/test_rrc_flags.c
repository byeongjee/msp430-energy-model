/**
 * Test RRC (Rotate Right through Carry) flag behavior
 *
 * This test verifies that the V flag is properly computed for RRC instruction.
 * According to MSP430 spec, V is set if initial dst positive AND initial C set.
 *
 * Test case 1 (RRC word mode V flag):
 * - Set C=1 (setc)
 * - dst=0x7FFF (positive, MSB=0)
 * - RRC: result = (0x7FFF >> 1) | 0x8000 = 0xBFFF
 * - Correct: V=1 (dst was positive and C was set)
 * - Bug: V=0 (V flag not computed)
 * - After RRC: N=1 (result has MSB set), V should be 1
 * - JGE condition: (N XOR V) = 0 means N==V
 * - If V=1 and N=1: JGE should be taken (correct)
 * - If V=0 and N=1: JGE should NOT be taken (buggy)
 * - If JGE taken (correct), write 0xCAFE to result_rrc_v
 * - If JGE not taken (buggy), write 0xBEEF to result_rrc_v
 *
 * Test case 2 (RRC V flag with negative initial value):
 * - Set C=1 (setc)
 * - dst=0x8000 (negative, MSB=1)
 * - RRC: result = (0x8000 >> 1) | 0x8000 = 0xC000
 * - Correct: V=0 (dst was negative, so V should not be set)
 * - After RRC: N=1 (result has MSB set), V should be 0
 * - JL condition: (N XOR V) = 1 means N!=V
 * - If V=0 and N=1: JL should be taken (correct)
 * - If V=1 and N=1: JL should NOT be taken (buggy)
 * - If JL taken (correct), write 0xCAFE to result_rrc_v_neg
 * - If JL not taken (buggy), write 0xBEEF to result_rrc_v_neg
 */

#include <stdint.h>

volatile uint16_t result_rrc_v = 0;
volatile uint16_t result_rrc_v_neg = 0;

int main(void) {
    // Test 1: RRC V flag with positive initial value and C=1
    // V should be set because dst=0x7FFF is positive and C=1
    __asm__ __volatile__(
        "setc\n\t"                      // Set carry flag (C=1)
        "mov #0x7FFF, r5\n\t"           // dst = 0x7FFF (positive)
        "rrc r5\n\t"                    // r5 = (0x7FFF >> 1) | 0x8000 = 0xBFFF
                                        // After: N=1 (0xBFFF has MSB set)
                                        // Correct: V=1 (positive dst + C=1)
                                        // Bug: V=0 (V not computed)
        // JGE taken if (N XOR V) = 0, i.e., N == V
        // If V=1 and N=1: JGE taken (correct)
        // If V=0 and N=1: JGE not taken (buggy)
        "jge rrc_v_correct\n\t"         // Jump if N==V (correct: V=1, N=1)
        "mov #0xBEEF, %0\n\t"           // Bug: V=0, write 0xBEEF
        "jmp rrc_v_done\n\t"
        "rrc_v_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=1, write 0xCAFE
        "rrc_v_done:\n\t"
        : "=m" (result_rrc_v)
        :
        : "r5"
    );

    // Test 2: RRC V flag with negative initial value and C=1
    // V should NOT be set because dst=0x8000 is negative (even though C=1)
    __asm__ __volatile__(
        "setc\n\t"                      // Set carry flag (C=1)
        "mov #0x8000, r5\n\t"           // dst = 0x8000 (negative)
        "rrc r5\n\t"                    // r5 = (0x8000 >> 1) | 0x8000 = 0xC000
                                        // After: N=1 (0xC000 has MSB set)
                                        // Correct: V=0 (negative dst, V not set)
        // JL taken if (N XOR V) = 1, i.e., N != V
        // If V=0 and N=1: JL taken (correct)
        // If V=1 and N=1: JL not taken (buggy)
        "jl rrc_v_neg_correct\n\t"      // Jump if N!=V (correct: V=0, N=1)
        "mov #0xBEEF, %0\n\t"           // Bug: V=1, write 0xBEEF
        "jmp rrc_v_neg_done\n\t"
        "rrc_v_neg_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=0, write 0xCAFE
        "rrc_v_neg_done:\n\t"
        : "=m" (result_rrc_v_neg)
        :
        : "r5"
    );

    return 0;
}
