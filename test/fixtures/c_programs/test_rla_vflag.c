/**
 * Test RLA instruction V flag behavior (overflow detection)
 *
 * RLA (Rotate Left Arithmetic) is emulated as ADD dst,dst
 * The V flag should be set when the shift causes a sign change (overflow).
 *
 * Test case 1 (V should be set):
 * - dst = 0x4000 (positive, bit 14 set)
 * - RLA: result = 0x4000 + 0x4000 = 0x8000 (negative)
 * - Sign changed from positive to negative = overflow
 * - Correct: V=1
 * - Bug: V=0 (V flag not computed)
 * - JGE jumps if (N XOR V) = 0
 * - With N=1, V=1: N XOR V = 0, so JGE should jump
 * - With N=1, V=0: N XOR V = 1, so JGE should NOT jump
 * - If JGE jumps (correct V=1), write 0xCAFE
 * - If JGE doesn't jump (buggy V=0), write 0xBEEF
 *
 * Test case 2 (V should be clear):
 * - dst = 0x2000 (positive, bit 13 set)
 * - RLA: result = 0x2000 + 0x2000 = 0x4000 (positive)
 * - Sign unchanged = no overflow
 * - Correct: V=0
 * - JL jumps if (N XOR V) = 1
 * - With N=0, V=0: N XOR V = 0, so JL should NOT jump
 * - If JL doesn't jump (correct V=0), write 0xCAFE
 * - If JL jumps (buggy V=1), write 0xBEEF
 */

#include <stdint.h>

volatile uint16_t result_overflow = 0;
volatile uint16_t result_no_overflow = 0;

int main(void) {
    // Test 1: RLA causing overflow (positive -> negative)
    // 0x4000 (positive) -> 0x8000 (negative) = sign change, V should be 1
    __asm__ __volatile__(
        "mov #0x4000, r5\n\t"           // dst = 0x4000 (positive, bit 14 set)
        "rla r5\n\t"                    // r5 = 0x4000 + 0x4000 = 0x8000, N=1, V should be 1
        "jge overflow_correct\n\t"      // JGE: jump if (N XOR V) = 0; with N=1,V=1 -> 0, should jump
        "mov #0xBEEF, %0\n\t"           // Bug: V=0, N XOR V = 1, didn't jump
        "jmp overflow_done\n\t"
        "overflow_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=1, N XOR V = 0, jumped
        "overflow_done:\n\t"
        : "=m" (result_overflow)
        :
        : "r5"
    );

    // Test 2: RLA without overflow (positive -> positive)
    // 0x2000 (positive) -> 0x4000 (positive) = no sign change, V should be 0
    __asm__ __volatile__(
        "mov #0x2000, r5\n\t"           // dst = 0x2000 (positive, bit 13 set)
        "rla r5\n\t"                    // r5 = 0x2000 + 0x2000 = 0x4000, N=0, V should be 0
        "jl no_overflow_bug\n\t"        // JL: jump if (N XOR V) = 1; with N=0,V=0 -> 0, should NOT jump
        "mov #0xCAFE, %0\n\t"           // Correct: V=0, N XOR V = 0, didn't jump
        "jmp no_overflow_done\n\t"
        "no_overflow_bug:\n\t"
        "mov #0xBEEF, %0\n\t"           // Bug: V=1, N XOR V = 1, jumped
        "no_overflow_done:\n\t"
        : "=m" (result_no_overflow)
        :
        : "r5"
    );

    return 0;
}
