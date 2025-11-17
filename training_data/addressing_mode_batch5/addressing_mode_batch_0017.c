#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_inc_indexed(void) {
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w %c[offs](%[base])\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_inc_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_inc_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_rlam_immediate_1_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_2_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #2, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_inc_indexed());
  BENCH(bench_inc_symbolic());
  BENCH(bench_inc_absolute());
  BENCH(bench_rlam_immediate_1_register());
  BENCH(bench_rlam_immediate_2_register());

  end_measurement_window();

  return 0;
}