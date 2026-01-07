/**
 * Test XOR flag behavior
 *
 * According to MSP430 spec, XOR should set flags as:
 * - N: Set if result is negative (MSB = 1)
 * - Z: Set if result is zero
 * - C: Set if result is NOT zero (C = NOT Z)
 * - V: Set if both operands are negative (both have MSB = 1)
 *
 * Bug: Current implementation uses subtraction flag logic:
 * - C: Set if dst >= src (wrong for XOR)
 * - V: Set if operands have different signs and result differs from dst (wrong for XOR)
 *
 * Test case 1 (C flag):
 * - dst=0x0001, src=0x0002
 * - result = 0x0001 XOR 0x0002 = 0x0003
 * - Correct: C=1 (result != 0)
 * - Bug: C=0 (0x0001 >= 0x0002 is false)
 * - If C=1 (correct), write 0xCAFE to result_c
 * - If C=0 (buggy), write 0xBEEF to result_c
 *
 * Test case 2 (V flag):
 * - dst=0x8000, src=0x8001
 * - result = 0x8000 XOR 0x8001 = 0x0001
 * - Both operands negative (MSB=1)
 * - Correct: V=1 (both operands negative)
 * - Bug: V=0 (subtraction overflow logic gives false)
 * - N=0 (result positive), so N XOR V = V
 * - If V=1 (correct), JL jumps (N XOR V = 1)
 * - If V=0 (buggy), JGE jumps (N XOR V = 0)
 * - If JL jumps, write 0xCAFE to result_v
 * - If JGE jumps, write 0xBEEF to result_v
 */

#include <stdint.h>

volatile uint16_t result_c = 0;
volatile uint16_t result_v = 0;

int main(void) {
    // Test C flag: C should be NOT Z (set if result nonzero)
    // dst=0x0001, src=0x0002 -> result=0x0003, C should be 1
    __asm__ __volatile__(
        "mov #0x0001, r5\n\t"           // dst = 0x0001
        "xor #0x0002, r5\n\t"           // r5 = 0x0001 XOR 0x0002 = 0x0003, C should be 1
        "jc c_flag_correct\n\t"         // Jump if C=1 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=0, write 0xBEEF
        "jmp c_done\n\t"
        "c_flag_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=1, write 0xCAFE
        "c_done:\n\t"
        : "=m" (result_c)
        :
        : "r5"
    );

    // Test V flag: V should be set when both operands negative
    // dst=0x8000, src=0x8001 -> result=0x0001, V should be 1
    // N=0, so JL (N XOR V = 1) should jump when V=1
    __asm__ __volatile__(
        "mov #0x8000, r5\n\t"           // dst = 0x8000 (negative)
        "xor #0x8001, r5\n\t"           // r5 = 0x8000 XOR 0x8001 = 0x0001, V should be 1
        "jl v_flag_correct\n\t"         // Jump if N XOR V = 1 (i.e., V=1 since N=0)
        "mov #0xBEEF, %0\n\t"           // Bug: V=0, N XOR V = 0, JGE taken
        "jmp v_done\n\t"
        "v_flag_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=1, N XOR V = 1, JL taken
        "v_done:\n\t"
        : "=m" (result_v)
        :
        : "r5"
    );

    return 0;
}
