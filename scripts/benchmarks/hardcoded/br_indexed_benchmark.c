#include "setup.h"

INLINE void bench_br_indexed(void) {
  uint16_t *base;
  __asm__ volatile(
    "mov #" STR(INNER_ITERS) ", r14\n"
    "bench_br_indexed_outer_loop:\n"
    "  mov #bench_br_indexed_jump_table-2, %[base]\n"
    "bench_br_indexed_loop_header:\n"
    ".set br_off, 2\n"
    ".rept " STR(TEXTUAL_REPT) "\n"
    "  br br_off(%[base])\n"
    "  .set br_off, br_off + 2\n"
    ".endr\n"
    "bench_br_indexed_jump_table:\n"
    ".rept " STR(TEXTUAL_REPT) " - 1\n"
    "  .word bench_br_indexed_loop_header + 2*(.-bench_br_indexed_jump_table) + 4\n"
    ".endr\n"
    "  .word bench_br_indexed_loop_footer\n"
    "bench_br_indexed_loop_footer:\n"
    "  add #-1, r14\n"
    "  cmp #0, r14\n"
    "  jne bench_br_indexed_outer_loop\n"
    : [base] "=&r"(base)
    :
    : "r14", "cc", "memory"
  );
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_br_indexed());

  end_measurement_window();

  return 0;
}
