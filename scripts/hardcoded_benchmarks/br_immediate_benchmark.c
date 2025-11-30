#include "setup.h"

// Hardcoded macros determined from compilation and assembly inspection
// BR_INITIAL_ADDR: Address of the first br instruction (at loop_header label)
// LOOP_HEADER_ADDR: Address where loop counter is decremented (after all br instructions)
// These values are for TEXTUAL_REPT=100, INNER_ITERS=100
// If you change compilation settings, you may need to recompile and update these addresses
#ifndef BR_INITIAL_ADDR
#define BR_INITIAL_ADDR 0x4154
#endif

#ifndef LOOP_HEADER_ADDR
#define LOOP_HEADER_ADDR 0x42e4
#endif

INLINE void bench_br_immediate(void) {
  REPEAT_INNER_ITERS(
    __asm__ volatile(
      "loop_header:\n"
      ".set br_addr, " STR(BR_INITIAL_ADDR) "\n"
      ".rept " STR(TEXTUAL_REPT) " - 1\n"
      "  br #br_addr + 4\n"  // Each br instruction is 4 bytes, jump to next br
      "  .set br_addr, br_addr + 4\n"
      ".endr\n"
      "  br #" STR(LOOP_HEADER_ADDR) "\n"  // Last br jumps to loop decrement
      :
      :
      : "memory"
    )
  );
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_br_immediate());

  end_measurement_window();

  return 0;
}
