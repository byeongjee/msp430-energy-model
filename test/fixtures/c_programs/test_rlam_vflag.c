/**
 * Test RLAM V flag behavior (overflow detection)
 *
 * RLAM (Rotate Left Arithmetic Multiple) is an MSP430X instruction that
 * performs multiple left shifts. The V flag should be set if arithmetic
 * overflow occurs during any of the shifts (sign change).
 *
 * Bug: Current implementation does not set the V flag for overflow.
 * The V flag is only updated via update_flags_simple! which doesn't set V.
 *
 * Test case 1 (RLAM #1 overflow):
 * - Initial value: 0x4000 (positive, bit 14 set)
 * - RLAM #1: 0x4000 << 1 = 0x8000 (negative)
 * - Sign changed from positive to negative = overflow
 * - Correct: V=1
 * - Bug: V=0 (V flag not set)
 * - N=1, so JL (N XOR V = 1) means V=0, JGE (N XOR V = 0) means V=1
 * - If V=1 (correct), JGE jumps (N=1, V=1, N XOR V = 0)
 * - If V=0 (buggy), JL jumps (N=1, V=0, N XOR V = 1)
 * - If JGE jumps, write 0xCAFE to result_test1
 * - If JL jumps, write 0xBEEF to result_test1
 *
 * Test case 2 (RLAM #2 overflow on second shift):
 * - Initial value: 0x2000 (positive, bit 13 set)
 * - First shift: 0x2000 << 1 = 0x4000 (positive, no overflow yet)
 * - Second shift: 0x4000 << 1 = 0x8000 (negative, overflow!)
 * - Correct: V=1 (overflow occurred on second shift)
 * - Bug: V=0 (V flag not tracked during multiple shifts)
 * - N=1, so JL (N XOR V = 1) means V=0, JGE (N XOR V = 0) means V=1
 * - If V=1 (correct), JGE jumps (N=1, V=1, N XOR V = 0)
 * - If V=0 (buggy), JL jumps (N=1, V=0, N XOR V = 1)
 * - If JGE jumps, write 0xCAFE to result_test2
 * - If JL jumps, write 0xBEEF to result_test2
 */

#include <stdint.h>

volatile uint16_t result_test1 = 0;
volatile uint16_t result_test2 = 0;

int main(void) {
    // Test 1: RLAM #1 on 0x4000 -> 0x8000 = overflow, V should be 1
    // Result is negative (N=1), so:
    // - If V=1 (correct): N XOR V = 0, JGE jumps
    // - If V=0 (buggy): N XOR V = 1, JL jumps
    __asm__ __volatile__(
        "mov #0x4000, r5\n\t"           // r5 = 0x4000 (positive)
        "rlam #1, r5\n\t"               // r5 = 0x8000 (negative), V should be 1
        "jge test1_v_set\n\t"           // Jump if N XOR V = 0 (correct: V=1, N=1)
        "mov #0xBEEF, %0\n\t"           // Bug: V=0, N XOR V = 1, JL taken
        "jmp test1_done\n\t"
        "test1_v_set:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=1, N XOR V = 0, JGE taken
        "test1_done:\n\t"
        : "=m" (result_test1)
        :
        : "r5"
    );

    // Test 2: RLAM #2 on 0x2000 -> 0x4000 -> 0x8000 = overflow on second shift
    // First shift: 0x2000 -> 0x4000 (no overflow, still positive)
    // Second shift: 0x4000 -> 0x8000 (overflow! sign changed)
    // Result is negative (N=1), so:
    // - If V=1 (correct): N XOR V = 0, JGE jumps
    // - If V=0 (buggy): N XOR V = 1, JL jumps
    __asm__ __volatile__(
        "mov #0x2000, r5\n\t"           // r5 = 0x2000 (positive)
        "rlam #2, r5\n\t"               // r5 = 0x8000 (negative), V should be 1
        "jge test2_v_set\n\t"           // Jump if N XOR V = 0 (correct: V=1, N=1)
        "mov #0xBEEF, %0\n\t"           // Bug: V=0, N XOR V = 1, JL taken
        "jmp test2_done\n\t"
        "test2_v_set:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=1, N XOR V = 0, JGE taken
        "test2_done:\n\t"
        : "=m" (result_test2)
        :
        : "r5"
    );

    return 0;
}
