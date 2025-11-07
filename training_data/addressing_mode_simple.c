#include "setup.h"

#define TEXTUAL_REPT 100

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4

#define WSUF ".w"

INLINE void bench_add_reg_reg(void) {
  uint16_t dst = 0x1234, src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " %1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(src) : "cc"));
}

INLINE void bench_add_imm_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " #0x1357, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

INLINE void bench_add_idx_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *base = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " %c2(%1), %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(base),
      "i"(4) : "cc", "memory"));
}

INLINE void bench_add_sym_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc",
      "memory"));
}

INLINE void bench_add_abs_reg(void) {
  uint16_t dst = 0x1234;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " &sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc",
      "memory"));
}

INLINE void bench_add_ind_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *p = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " @%1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(p) : "cc",
      "memory"));
}

INLINE void bench_add_aut_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *p = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " @%1+, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(p) : "cc",
      "memory"));
}

INLINE void bench_add_reg_idx(void) {
  uint16_t src = 0x5678;
  uint16_t *base = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "add" WSUF " %0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(src),
                       "r"(base), "i"(4) : "cc", "memory"));
}

INLINE void bench_add_reg_sym(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "add" WSUF " %0, sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

INLINE void bench_add_reg_abs(void) {
  uint16_t src = 0x5678;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "add" WSUF " %0, &sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

INLINE void bench_inc_reg(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "inc" WSUF " %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

INLINE void bench_inc_idx(void) {
  uint16_t *base = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "inc" WSUF " %c1(%0)\n"
                                                  ".endr\n" : : "r"(base),
                       "i"(4) : "cc", "memory"));
}

INLINE void bench_inc_sym(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "inc" WSUF " sym_data\n"
                                                  ".endr\n" : : : "cc",
                       "memory"));
}

INLINE void bench_inc_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "inc" WSUF " &sym_data\n"
                                                  ".endr\n" : : : "cc",
                       "memory"));
}

INLINE void bench_rlam_1_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #1, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

INLINE void bench_rlam_2_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #2, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

INLINE void bench_rlam_3_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #3, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

INLINE void bench_rlam_4_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #4, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

INLINE void bench_jge_not_taken(void) {
  uint16_t a = 0x0000,
           b = 0xFFFF; /* signed: a < b -> JGE is false (not taken) */
  REPEAT_INNER_ITERS(__asm__ volatile(
      "cmp" WSUF " %1, %0\n"
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  jge 1f\n"
                                 "  nop\n"
                                 "1:\n"
                                 ".endr\n" : "+r"(a) : "r"(b) : "cc"));
}

INLINE void bench_jge_taken(void) {
  uint16_t a = 0x7FFF, b = 0x0001; /* signed: a >= b -> JGE is true (taken) */
  REPEAT_INNER_ITERS(__asm__ volatile(
      /* Prime flags once before the repeated jge’s. */
      "cmp" WSUF " %1, %0\n"
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  jge 1f\n"
                                 "  nop\n"
                                 "1:\n"
                                 ".endr\n" : "+r"(a) : "r"(b) : "cc"));
}

INLINE void bench_jmp(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "jmp 1f\n"
                                                  "1:\n"
                                                  ".endr\n" : : : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_add_reg_reg());
  BENCH(bench_add_imm_reg());
  BENCH(bench_add_idx_reg());
  BENCH(bench_add_sym_reg());
  BENCH(bench_add_abs_reg());
  BENCH(bench_add_ind_reg());
  BENCH(bench_add_aut_reg());

  BENCH(bench_add_reg_idx());
  BENCH(bench_add_reg_sym());
  BENCH(bench_add_reg_abs());

  BENCH(bench_inc_reg());
  BENCH(bench_inc_idx());
  BENCH(bench_inc_sym());
  BENCH(bench_inc_abs());

  BENCH(bench_rlam_1_reg());
  BENCH(bench_rlam_2_reg());
  BENCH(bench_rlam_3_reg());
  BENCH(bench_rlam_4_reg());

  BENCH(bench_jge_not_taken());
  BENCH(bench_jge_taken());
  BENCH(bench_jmp());

  end_measurement_window();

  return 0;
}
