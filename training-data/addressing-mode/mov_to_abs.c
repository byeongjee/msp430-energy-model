#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4

#define WSUF ".w"

INLINE void bench_mov_reg_to_abs(void) {
  uint16_t src = 0x5678;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " %0, &sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

INLINE void bench_mov_imm_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " #0x1357, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

INLINE void bench_mov_idx_to_abs(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %c1(%0), &sym_data\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_mov_sym_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " sym_data, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

INLINE void bench_mov_abs_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " &sym_data, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

INLINE void bench_mov_ind_to_abs(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%0, &sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

INLINE void bench_mov_aut_to_abs(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%0+, &sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_mov_reg_to_abs());
  BENCH(bench_mov_imm_to_abs());
  BENCH(bench_mov_idx_to_abs());
  BENCH(bench_mov_sym_to_abs());
  BENCH(bench_mov_abs_to_abs());
  BENCH(bench_mov_ind_to_abs());
  BENCH(bench_mov_aut_to_abs());

  end_measurement_window();

  return 0;
}
