#include "setup.h"

#define INNER_ITERS 100

/* Fixed data for memory addressing */
static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

/* Use word forms for simplicity (.w). Mirror with .b if you want byte benches.
 */
#define WSUF ".w"

/* add.w Rs, Rd */
void bench_add_reg_reg(void) {
  uint16_t dst = 0x1234, src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "add" WSUF " %1, %0\n"
                                ".endr\n" : "+r"(dst) : "r"(src) : "cc"));
}

/* add.w #imm, Rd */
void bench_add_imm_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "add" WSUF " #0x1357, %0\n"
                                ".endr\n" : "+r"(dst) : : "cc"));
}

/* add.w off(base), Rd  (indexed) */
void bench_add_idx_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *base = (uint16_t *)mem_buf; /* even-aligned */
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "add" WSUF " %c2(%1), %0\n"
                                ".endr\n" : "+r"(dst) : "r"(base),
      "i"(4) : "cc", "memory"));
}

/* add.w sym, Rd  (symbolic, PC-relative) */
void bench_add_sym_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "add" WSUF " sym_data, %0\n"
                                                 ".endr\n" : "+r"(dst) : : "cc",
                       "memory"));
}

/* add.w &abs, Rd  (absolute) */
void bench_add_abs_reg(void) {
  uint16_t dst = 0x1234;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "add" WSUF " &sym_data, %0\n"
                                                 ".endr\n" : "+r"(dst) : : "cc",
                       "memory"));
}

/* add.w @Rs, Rd  (indirect) */
void bench_add_ind_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *p = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "add" WSUF " @%1, %0\n"
                                ".endr\n" : "+r"(dst) : "r"(p) : "cc",
      "memory"));
}

/* add.w @Rs+, Rd  (autoincrement) */
void bench_add_aut_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *p = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "add" WSUF " @%1+, %0\n"
                                ".endr\n" : "+r"(dst) : "r"(p) : "cc",
      "memory"));
}

/* ========== ADD: register source to memory destination ========== */

/* add.w Rs, off(base)  (indexed) */
void bench_add_reg_idx(void) {
  uint16_t src = 0x5678;
  uint16_t *base = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "add" WSUF " %0, %c2(%1)\n"
                                                 ".endr\n" : : "r"(src),
                       "r"(base), "i"(4) : "cc", "memory"));
}

/* add.w Rs, sym  (symbolic) */
void bench_add_reg_sym(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "add" WSUF " %0, sym_data\n"
                                                 ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

/* add.w Rs, &abs  (absolute) */
void bench_add_reg_abs(void) {
  uint16_t src = 0x5678;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "add" WSUF " %0, &sym_data\n"
                                                 ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

/* ========== INC: register and memory destinations ========== */

/* inc.w Rd */
void bench_inc_reg(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "inc" WSUF " %0\n"
                                ".endr\n" : "+r"(dst) : : "cc"));
}

/* inc.w off(base) */
void bench_inc_idx(void) {
  uint16_t *base = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "inc" WSUF " %c1(%0)\n"
                                                 ".endr\n" : : "r"(base),
                       "i"(4) : "cc", "memory"));
}

/* inc.w sym */
void bench_inc_sym(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "inc" WSUF " sym_data\n"
                                                 ".endr\n" : : : "cc",
                       "memory"));
}

/* inc.w &abs */
void bench_inc_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "inc" WSUF " &sym_data\n"
                                                 ".endr\n" : : : "cc",
                       "memory"));
}

/* ========== RLAM: immediate {1..4}, register destination ========== */

void bench_rlam_1_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "rlam #1, %0\n"
                                ".endr\n" : "+r"(dst) : : "cc"));
}

void bench_rlam_2_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "rlam #2, %0\n"
                                ".endr\n" : "+r"(dst) : : "cc"));
}

void bench_rlam_3_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "rlam #3, %0\n"
                                ".endr\n" : "+r"(dst) : : "cc"));
}

void bench_rlam_4_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "rlam #4, %0\n"
                                ".endr\n" : "+r"(dst) : : "cc"));
}

/* ========== Branches: JGE, JMP (relative only) ========== */
/* Provide taken and not-taken variants */

void bench_jge_not_taken(void) {
  uint16_t a = 0x0000, b = 0xFFFF; /* a < b (signed), so JGE is false */
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "cmp" WSUF " %1, %0\n"
                                "jge 1f\n"
                                "nop\n"
                                "1:\n"
                                ".endr\n" : "+r"(a) : "r"(b) : "cc"));
}

void bench_jge_taken(void) {
  uint16_t a = 0x7FFF, b = 0x0001; /* a >= b (signed), so JGE is true */
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(INNER_ITERS) "\n"
                                "cmp" WSUF " %1, %0\n"
                                "jge 1f\n"
                                "nop\n"
                                "1:\n"
                                ".endr\n" : "+r"(a) : "r"(b) : "cc"));
}

void bench_jmp_not_taken(void) {
  /* Execute jmp over a local label; sequence is structured so flow is stable */
  REPEAT_INNER_ITERS(__asm__ volatile(".rept " STR(
      INNER_ITERS) "\n"
                   "nop\n"
                   "jnz 1f\n" /* Z=1 from nop, branch not taken */
                   "jmp 2f\n" /* execute jmp, relative hop forward */
                   "2:\n"
                   "1:\n"
                   ".endr\n" : : : "cc"));
}

void bench_jmp_taken(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(INNER_ITERS) "\n"
                                                 "jmp 1f\n"
                                                 "1:\n"
                                                 ".endr\n" : : : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();

  REPEAT_WITH_EVENT(bench_add_reg_reg());
  REPEAT_WITH_EVENT(bench_add_imm_reg());
  REPEAT_WITH_EVENT(bench_add_idx_reg());
  REPEAT_WITH_EVENT(bench_add_sym_reg());
  REPEAT_WITH_EVENT(bench_add_abs_reg());
  REPEAT_WITH_EVENT(bench_add_ind_reg());
  REPEAT_WITH_EVENT(bench_add_aut_reg());

  REPEAT_WITH_EVENT(bench_add_reg_idx());
  REPEAT_WITH_EVENT(bench_add_reg_sym());
  REPEAT_WITH_EVENT(bench_add_reg_abs());

  REPEAT_WITH_EVENT(bench_inc_reg());
  REPEAT_WITH_EVENT(bench_inc_idx());
  REPEAT_WITH_EVENT(bench_inc_sym());
  REPEAT_WITH_EVENT(bench_inc_abs());

  REPEAT_WITH_EVENT(bench_rlam_1_reg());
  REPEAT_WITH_EVENT(bench_rlam_2_reg());
  REPEAT_WITH_EVENT(bench_rlam_3_reg());
  REPEAT_WITH_EVENT(bench_rlam_4_reg());

  REPEAT_WITH_EVENT(bench_jge_not_taken());
  REPEAT_WITH_EVENT(bench_jge_taken());
  REPEAT_WITH_EVENT(bench_jmp_not_taken());
  REPEAT_WITH_EVENT(bench_jmp_taken());

  end_measurement_window();

  return 0;
}
