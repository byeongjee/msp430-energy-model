#include "setup.h"

// Hardcoded macros automatically determined via two-pass compilation
// BR_INITIAL_ADDR: Address of the first br instruction (at loop_header label)
// LOOP_HEADER_ADDR: Address where loop counter is decremented (after all br instructions)
// These addresses are extracted from the first compilation pass and passed as -D flags
// Use scripts/compile_hardcoded_benchmarks.sh to compile this file
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
