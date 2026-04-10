#include "setup.h"

// Hardcoded macros automatically determined via two-pass compilation
// BR_INITIAL_ADDR: Address of the first br instruction (at loop_header label)
// LOOP_HEADER_ADDR: Address where loop counter is decremented (after all br instructions)
// These addresses are extracted from the first compilation pass and passed as -D flags
// Use scripts/compile_br_immediate_benchmark.sh to compile this file
#ifndef BR_INITIAL_ADDR
#define BR_INITIAL_ADDR 0x4154
#endif

#ifndef LOOP_HEADER_ADDR
#define LOOP_HEADER_ADDR 0x42e4
#endif

INLINE void bench_br_indexed(void) {
  uint16_t *base;
  REPEAT_INNER_ITERS(
    __asm__ volatile(
      "mov #jump_table-2, %[base]\n"
      "loop_header:\n"
      ".set br_off, 2\n"
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  br br_off(%[base])\n"
      "  .set br_off, br_off + 2\n"
      ".endr\n"
      "jump_table:\n"
      ".set br_addr, " STR(BR_INITIAL_ADDR) "\n"
      ".rept " STR(TEXTUAL_REPT) " - 1\n"
      "  .word br_addr + 4\n"
      "  .set br_addr, br_addr + 4\n"
      ".endr\n"
      "  .word " STR(LOOP_HEADER_ADDR) "\n"
      : [base] "=&r"(base)
      :
      : "memory"
    )
  );
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_br_indexed());

  end_measurement_window();

  return 0;
}
