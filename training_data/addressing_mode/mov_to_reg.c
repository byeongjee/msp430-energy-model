#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4

#define WSUF ".w"

INLINE void bench_mov_reg_to_reg(void) {
  uint16_t dst = 0x1234, src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(src) :));
}

INLINE void bench_mov_imm_to_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " #0x1357, %0\n"
                                                  ".endr\n" : "+r"(dst) : :));
}

INLINE void bench_mov_idx_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *base = (uint16_t *)BASE_PTR; /* word-aligned base */
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %c2(%1), %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(base),
      "i"(OFFS) : "memory"));
}

INLINE void bench_mov_sym_to_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "memory"));
}

INLINE void bench_mov_abs_to_reg(void) {
  uint16_t dst = 0x1234;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " &sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "memory"));
}

INLINE void bench_mov_ind_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(psrc) : "memory"));
}

INLINE void bench_mov_aut_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%1+, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(psrc) : "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_mov_reg_to_reg());
  BENCH(bench_mov_imm_to_reg());
  BENCH(bench_mov_idx_to_reg());
  BENCH(bench_mov_sym_to_reg());
  BENCH(bench_mov_abs_to_reg());
  BENCH(bench_mov_ind_to_reg());
  BENCH(bench_mov_aut_to_reg());

  end_measurement_window();

  return 0;
}
