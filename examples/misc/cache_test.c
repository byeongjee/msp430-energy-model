#include "setup.h"

#ifndef HOT1_ITERS
#define HOT1_ITERS 64
#endif
#ifndef HOT2_ITERS
#define HOT2_ITERS 64
#endif
#ifndef CONFLICT_REPS
#define CONFLICT_REPS 32
#endif
#ifndef REPEAT_2B_COUNT
#define REPEAT_2B_COUNT 512
#endif
#ifndef REPEAT_4B_COUNT
#define REPEAT_4B_COUNT 256
#endif

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

// Small loop whose body fits entirely in a single 8-byte line.
NOINLINE void icache_hot_single_line(void) {
  register uint16_t n = HOT1_ITERS;
  begin_event();
  __asm__ volatile("1: nop\n"
                   "   nop\n"
                   "   dec %[cnt]\n"
                   "   jne 1b\n"
                   : [cnt] "+r"(n)
                   :
                   : "cc", "memory");
  end_event();
}

// Loop body spans two 8-byte lines (16 bytes) so first iteration should fill
// two lines; subsequent iterations should be all hits.
NOINLINE void icache_hot_two_lines(void) {
  register uint16_t n = HOT2_ITERS;
  begin_event();
  __asm__ volatile("1: nop\n"
                   "   nop\n"
                   "   nop\n"
                   "   nop\n"
                   "   nop\n"
                   "   nop\n"
                   "   dec %[cnt]\n"
                   "   jne 1b\n"
                   : [cnt] "+r"(n)
                   :
                   : "cc", "memory");
  end_event();
}

// Repeat a 2-byte instruction (nop) many times to observe I-cache fills/hits.
NOINLINE void icache_repeat_2byte(void) {
  begin_event();
  __asm__ volatile(".rept " STR(REPEAT_2B_COUNT) "\n"
                                                 "  nop\n"
                                                 ".endr\n"
                   :
                   :
                   : "cc", "memory");
  end_event();
}

// Repeat a 4-byte instruction (mov #imm20, r5) many times.
NOINLINE void icache_repeat_4byte(void) {
  begin_event();
  __asm__ volatile(".rept " STR(REPEAT_4B_COUNT) "\n"
                                                 "  mov.w #0x1234, r5\n"
                                                 ".endr\n"
                   :
                   :
                   : "r5", "cc", "memory");
  end_event();
}

// Execute A->B->C->A where all blocks map to the same cache set (16-byte
// aligned). Uses only jumps; conditional exit happens inside block A.
NOINLINE void icache_cycle_same_set(void) {
  begin_event();
  register uint16_t n;
  __asm__ volatile("  jmp 1f\n"
                   "  .p2align 3\n" // 16-byte alignment => same cache set
                   "blockA_same:\n"
                   "  nop\n"
                   "  dec %[cnt]\n"
                   "  jne blockB_same\n"
                   "  jmp 2f\n"
                   "  .p2align 4\n"
                   "blockB_same:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  jmp blockC_same\n"
                   "  .p2align 4\n"
                   "blockC_same:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  jmp blockA_same\n"
                   "1:\n"
                   "  mov.w #2, %[cnt]\n"
                   "  jmp blockA_same\n"
                   "  .p2align 4\n"
                   "2:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   : [cnt] "=&r"(n)
                   :
                   : "cc", "memory");
  end_event();
}

// Execute A->B->C->A with 8-byte alignment: A/C alias the same set, B in a
// different set. Uses only jumps; conditional exit happens inside block A.
NOINLINE void icache_cycle_split_set(void) {
  begin_event();
  register uint16_t n;
  __asm__ volatile(
      "  jmp 1f\n"
      "  .p2align 3\n" // 8-byte alignment => stride 8 between blocks
      "blockA_split:\n"
      "  nop\n"
      "  dec %[cnt]\n"
      "  jne blockB_split\n"
      "  jmp 2f\n"
      "  .p2align 3\n"
      "blockB_split:\n"
      "  nop\n"
      "  nop\n"
      "  nop\n"
      "  jmp blockC_split\n"
      "  .p2align 3\n"
      "blockC_split:\n"
      "  nop\n"
      "  nop\n"
      "  nop\n"
      "  jmp blockA_split\n"
      "1:\n"
      "  mov.w #2, %[cnt]\n"
      "  jmp blockA_split\n"
      "  .p2align 3\n"
      "2:\n"
      "  nop\n"
      "  nop\n"
      "  nop\n"
      "  nop\n"
      : [cnt] "=&r"(n)
      :
      : "cc", "memory");
  end_event();
}

// ---------------------------------------------------------------------------
// Main: run windows back-to-back
// ---------------------------------------------------------------------------
int main(void) {
  initialize();
  begin_measurement_window();

  //  icache_hot_single_line(); // First loop: 1 miss then all hits
  //
  //  icache_hot_two_lines(); // Two-line loop: 2 initial misses then hits
  //
  //  icache_repeat_2byte(); // Repeated 2-byte instruction window
  //
  //  icache_repeat_4byte(); // Repeated 6-byte instruction window
  //
  icache_cycle_same_set(); // A/B/C/A in one set; final A should hit

  icache_cycle_split_set(); // A/C alias, B in other set; expect mostly misses

  end_measurement_window();
  return 0;
}
