/**
 * Test RLC V flag behavior
 *
 * RLC is emulated as ADDC dst,dst (dst << 1 + carry)
 * According to MSP430 spec, RLC should set V flag as:
 * - V: Set if arithmetic overflow occurs, otherwise reset
 * - Word mode: V=1 if 0x3FFF < dst_initial < 0xC000, otherwise V=0
 * - (This is the range where dst*2 would cause signed overflow)
 *
 * Bug: Current implementation preserves V flag (doesn't update it)
 *
 * Test case 1:
 * - First clear V flag (using a CMP that doesn't cause overflow)
 * - C=0, dst=0x4000 (in range 0x3FFF < x < 0xC000)
 * - RLC: result = 0x4000 << 1 = 0x8000
 * - 0x4000 is in the overflow range -> V should be set to 1
 * - Correct: V=1 (overflow: positive 0x4000 becomes negative 0x8000)
 * - Bug: V=0 (preserved from initial clear)
 * - N=1 (result 0x8000 is negative), so N XOR V = 1 - V
 * - If V=1 (correct), N XOR V = 0, JGE jumps
 * - If V=0 (buggy), N XOR V = 1, JL jumps
 * - If JGE jumps, write 0xCAFE to result1
 * - If JL jumps, write 0xBEEF to result1
 *
 * Test case 2:
 * - First set V flag (using a subtraction that causes overflow)
 * - C=0, dst=0x2000 (outside range, <= 0x3FFF)
 * - RLC: result = 0x2000 << 1 = 0x4000
 * - 0x2000 is outside the overflow range -> V should be reset to 0
 * - Correct: V=0 (no overflow: positive 0x2000 becomes positive 0x4000)
 * - Bug: V=1 (preserved from initial set)
 * - N=0 (result 0x4000 is positive), so N XOR V = V
 * - If V=0 (correct), N XOR V = 0, JGE jumps
 * - If V=1 (buggy), N XOR V = 1, JL jumps
 * - If JGE jumps, write 0xCAFE to result2
 * - If JL jumps, write 0xBEEF to result2
 */

#include <stdint.h>

volatile uint16_t result1 = 0;
volatile uint16_t result2 = 0;

int main(void) {
    // Test 1: RLC on 0x4000 (in overflow range) with V initially 0
    // V should be SET to 1 after RLC
    __asm__ __volatile__(
        // First, clear V flag: CMP 0x0000, 0x0001 -> no overflow, V=0
        "mov #0x0001, r5\n\t"
        "cmp #0x0000, r5\n\t"           // 0x0001 - 0x0000 = 0x0001, no overflow, V=0

        "clrc\n\t"                      // Clear carry flag (C=0)
        "mov #0x4000, r5\n\t"           // dst = 0x4000 (in overflow range)
        "rlc r5\n\t"                    // r5 = 0x4000 << 1 = 0x8000, V should be 1

        // N=1 (0x8000 is negative), so N XOR V = 1 XOR V
        // If V=1 (correct): N XOR V = 0 -> JGE jumps
        // If V=0 (bug): N XOR V = 1 -> JL jumps
        "jge test1_correct\n\t"         // Jump if N XOR V = 0 (V=1 is correct)
        "mov #0xBEEF, %0\n\t"           // Bug: V=0, write 0xBEEF
        "jmp test1_done\n\t"
        "test1_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=1, write 0xCAFE
        "test1_done:\n\t"
        : "=m" (result1)
        :
        : "r5"
    );

    // Test 2: RLC on 0x2000 (outside overflow range) with V initially 1
    // V should be RESET to 0 after RLC
    __asm__ __volatile__(
        // First, set V flag: SUB 0x8001 from 0x7FFF -> overflow, V=1
        // 0x7FFF - 0x8001 = 0xFFFE, positive - negative = negative -> overflow
        "mov #0x7FFF, r5\n\t"
        "sub #0x8001, r5\n\t"           // Causes overflow, sets V=1

        "clrc\n\t"                      // Clear carry flag (C=0)
        "mov #0x2000, r5\n\t"           // dst = 0x2000 (outside overflow range)
        "rlc r5\n\t"                    // r5 = 0x2000 << 1 = 0x4000, V should be 0

        // N=0 (0x4000 is positive), so N XOR V = 0 XOR V = V
        // If V=0 (correct): N XOR V = 0 -> JGE jumps
        // If V=1 (bug): N XOR V = 1 -> JL jumps
        "jge test2_correct\n\t"         // Jump if N XOR V = 0 (V=0 is correct)
        "mov #0xBEEF, %0\n\t"           // Bug: V=1 preserved, write 0xBEEF
        "jmp test2_done\n\t"
        "test2_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=0, write 0xCAFE
        "test2_done:\n\t"
        : "=m" (result2)
        :
        : "r5"
    );

    return 0;
}
