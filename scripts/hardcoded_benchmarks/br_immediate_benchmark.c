#include "setup.h"

INLINE void bench_br_immediate(void) {
  __asm__ volatile(
    "mov #" STR(INNER_ITERS) ", r13\n"
    "bench_br_immediate_outer_loop:\n"
    "bench_br_immediate_loop_header:\n"
    ".rept " STR(TEXTUAL_REPT) " - 1\n"
    "  .word 0x4030\n"
    "  .word . + 2\n"
    ".endr\n"
    "  .word 0x4030\n"
    "  .word bench_br_immediate_loop_footer\n"
    "bench_br_immediate_loop_footer:\n"
    "  add #-1, r13\n"
    "  cmp #0, r13\n"
    "  jne bench_br_immediate_outer_loop\n"
    :
    :
    : "r13", "cc", "memory"
  );
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_br_immediate());

  end_measurement_window();

  return 0;
}
