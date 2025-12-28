#include <stdint.h>

// Test br (branch) instruction
// br is a pseudo-instruction that translates to "mov dst, PC"
// It's used for indirect jumps

volatile uint16_t jump_target_1 = 0;
volatile uint16_t jump_target_2 = 0;

void test_br_instruction(void) {
  // Use inline assembly to test br instruction with computed goto
  // Use local labels (1:, 2:) to avoid duplicate label issues with inlining
  __asm__ volatile(
      // Test 1: Load address of label1 and branch to it
      "mov #1f, r12\n\t"
      "br r12\n\t"  // Branch to label1

      // This should be skipped
      "mov #99, %0\n\t"

      "1:\n\t"
      // We successfully branched here
      "mov #42, %0\n\t"

      // Test 2: Branch to label2 using R13
      "mov #2f, r13\n\t"
      "br r13\n\t"  // Branch to label2

      // This should be skipped
      "mov #88, %1\n\t"

      "2:\n\t"
      // We successfully branched here
      "mov #84, %1\n\t"
      : "=m"(jump_target_1), "=m"(jump_target_2)
      :
      : "r12", "r13");
}

int main(void) {
  test_br_instruction();

  // If br works correctly:
  // jump_target_1 should be 42 (not 99)
  // jump_target_2 should be 84 (not 88)
  // We return jump_target_1 in R12 for validation

  return (int)jump_target_1;
}
