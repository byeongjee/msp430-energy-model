/**
 * Test RRA V flag behavior
 *
 * According to MSP430 spec, RRA should always set V=0.
 * Bug: Current implementation does not explicitly reset V flag after RRA.
 *
 * Test strategy:
 * 1. First set V=1 using an operation that causes overflow
 *    - 0x7FFF + 1 = 0x8000 causes signed overflow (V=1)
 *    - Positive + Positive = Negative is overflow
 * 2. Then perform RRA on some value
 * 3. After RRA, V should be 0
 * 4. Use JGE/JL to verify V flag (JGE jumps if N XOR V = 0)
 *
 * Test case:
 * - Set V=1: add #1 to 0x7FFF -> 0x8000 (overflow, V=1, N=1)
 * - Perform RRA on 0x8000: result = 0xC000 (sign extended)
 * - After RRA: N=1 (result negative), V should be 0
 * - If V=0 (correct): N XOR V = 1 XOR 0 = 1, JL jumps
 * - If V=1 (buggy): N XOR V = 1 XOR 1 = 0, JGE jumps
 * - If JL jumps, write 0xCAFE to result
 * - If JGE jumps, write 0xBEEF to result
 */

#include <stdint.h>

volatile uint16_t result = 0;

int main(void) {
    // Test RRA V flag: V should be reset to 0
    __asm__ __volatile__(
        // First, set V=1 using signed overflow
        // 0x7FFF + 1 = 0x8000 causes overflow (positive + positive = negative)
        "mov #0x7FFF, r5\n\t"           // r5 = 0x7FFF (max positive)
        "add #1, r5\n\t"                // r5 = 0x8000, V=1, N=1

        // Now perform RRA on a value
        // RRA on 0x8000: result = 0xC000 (arithmetic right shift preserves sign)
        // N=1 (result negative), V should be reset to 0
        "mov #0x8000, r6\n\t"           // r6 = 0x8000
        "rra r6\n\t"                    // r6 = 0xC000, N=1, V should be 0

        // Check V flag using JL/JGE
        // JL jumps if N XOR V = 1
        // N=1, so JL jumps if V=0 (correct), stays if V=1 (buggy)
        "jl v_flag_correct\n\t"         // Jump if N XOR V = 1 (V=0 when N=1)
        "mov #0xBEEF, %0\n\t"           // Bug: V=1, N XOR V = 0, JGE path taken
        "jmp done\n\t"
        "v_flag_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=0, N XOR V = 1, JL taken
        "done:\n\t"
        : "=m" (result)
        :
        : "r5", "r6"
    );

    return 0;
}
