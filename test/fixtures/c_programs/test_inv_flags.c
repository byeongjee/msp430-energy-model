/**
 * Test INV instruction flag behavior
 *
 * INV is emulated as XOR #-1,dst (XOR #0xFFFF,dst for word mode)
 *
 * According to MSP430 spec:
 * - V should be set if initial dst was negative (MSB=1)
 * - C should be NOT Z (C=1 if result != 0, C=0 if result == 0)
 *
 * Test case 1 (V flag with negative initial value):
 * - dst = 0x8000 (negative, MSB=1)
 * - INV: result = 0x8000 XOR 0xFFFF = 0x7FFF
 * - Correct: V=1 (initial dst was negative)
 * - Bug: V may be incorrectly computed using XOR logic
 * - Use jge/jl to check V flag (jl jumps if N XOR V = 1)
 * - If V=1 and N=0, then N XOR V = 1, jl will jump
 *
 * Test case 2 (V flag with positive initial value):
 * - dst = 0x0001 (positive, MSB=0)
 * - INV: result = 0x0001 XOR 0xFFFF = 0xFFFE
 * - Correct: V=0 (initial dst was positive)
 * - Bug: V may be set incorrectly
 * - If V=0 and N=1, then N XOR V = 1, jl will jump
 * - If V=1 and N=1, then N XOR V = 0, jge will jump
 *
 * Test case 3 (C flag with non-zero result):
 * - dst = 0x0001
 * - INV: result = 0x0001 XOR 0xFFFF = 0xFFFE (non-zero)
 * - Correct: C=1 (result != 0, so C = NOT Z = 1)
 * - Bug: C may be set using XOR carry logic (always 0 or 1 incorrectly)
 */

#include <stdint.h>

volatile uint16_t result_v_negative = 0;
volatile uint16_t result_v_positive = 0;
volatile uint16_t result_c_nonzero = 0;

int main(void) {
    // Test 1: V flag with negative initial value (0x8000)
    // INV 0x8000 -> 0x7FFF, V should be 1 (initial was negative)
    // Result is positive (N=0), if V=1 then N XOR V = 1, jl jumps
    __asm__ __volatile__(
        "mov #0x8000, r5\n\t"           // dst = 0x8000 (negative)
        "inv r5\n\t"                    // r5 = 0x7FFF, V should be 1
        "jl v_neg_correct\n\t"          // Jump if N XOR V = 1 (N=0, V=1 -> jumps)
        "mov #0xBEEF, %0\n\t"           // Bug: V=0, write 0xBEEF
        "jmp v_neg_done\n\t"
        "v_neg_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=1, write 0xCAFE
        "v_neg_done:\n\t"
        : "=m" (result_v_negative)
        :
        : "r5"
    );

    // Test 2: V flag with positive initial value (0x0001)
    // INV 0x0001 -> 0xFFFE, V should be 0 (initial was positive)
    // Result is negative (N=1), if V=0 then N XOR V = 1, jl jumps
    // If V=1 (bug), then N XOR V = 0, jge jumps instead
    __asm__ __volatile__(
        "mov #0x0001, r5\n\t"           // dst = 0x0001 (positive)
        "inv r5\n\t"                    // r5 = 0xFFFE, V should be 0
        "jl v_pos_correct\n\t"          // Jump if N XOR V = 1 (N=1, V=0 -> jumps)
        "mov #0xBEEF, %0\n\t"           // Bug: V=1, write 0xBEEF
        "jmp v_pos_done\n\t"
        "v_pos_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: V=0, write 0xCAFE
        "v_pos_done:\n\t"
        : "=m" (result_v_positive)
        :
        : "r5"
    );

    // Test 3: C flag with non-zero result
    // INV 0x0001 -> 0xFFFE (non-zero), C should be 1 (C = NOT Z)
    __asm__ __volatile__(
        "mov #0x0001, r5\n\t"           // dst = 0x0001
        "inv r5\n\t"                    // r5 = 0xFFFE, C should be 1
        "jc c_nonzero_correct\n\t"      // Jump if C=1 (correct behavior)
        "mov #0xBEEF, %0\n\t"           // Bug: C=0, write 0xBEEF
        "jmp c_nonzero_done\n\t"
        "c_nonzero_correct:\n\t"
        "mov #0xCAFE, %0\n\t"           // Correct: C=1, write 0xCAFE
        "c_nonzero_done:\n\t"
        : "=m" (result_c_nonzero)
        :
        : "r5"
    );

    return 0;
}
