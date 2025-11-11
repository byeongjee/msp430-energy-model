#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4

#define WSUF ".w"

INLINE void bench_mov_reg_to_idx(void) {
  uint16_t src = 0x5678;
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " %0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(src),
                       "r"(base), "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_mov_imm_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " #0x1357, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_mov_idx_to_idx(void) {
  uint16_t *bsrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %c2(%0), %c3(%1)\n"
                                 ".endr\n" : : "r"(bsrc),
      "r"(bdst), "i"(OFFS), "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_mov_sym_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " sym_data, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_mov_abs_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " &sym_data, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_mov_ind_to_idx(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " @%0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(psrc),
                       "r"(bdst), "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_mov_aut_to_idx(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " @%0+, %c2(%1)\n"
                                                  ".endr\n" : : "r"(psrc),
                       "r"(bdst), "i"(OFFS) : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_mov_reg_to_idx());
  BENCH(bench_mov_imm_to_idx());
  BENCH(bench_mov_idx_to_idx());
  BENCH(bench_mov_sym_to_idx());
  BENCH(bench_mov_abs_to_idx());
  BENCH(bench_mov_ind_to_idx());
  BENCH(bench_mov_aut_to_idx());

  end_measurement_window();

  return 0;
}
