#include "setup.h"

#define TEXTUAL_REPT 100

/* Fixed data for memory addressing */
static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf) /* base for indexed addressing */
#define OFFS 4                         /* word-aligned offset for .w */

/* Use word forms for simplicity (.w). Mirror with .b if you want byte benches.
 */
#define WSUF ".w"

/* add.w Rs, Rd */
void bench_add_reg_reg(void) {
  uint16_t dst = 0x1234, src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " %1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(src) : "cc"));
}

/* add.w #imm, Rd */
void bench_add_imm_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " #0x1357, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

/* add.w off(base), Rd  (indexed) */
void bench_add_idx_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *base = (uint16_t *)mem_buf; /* even-aligned */
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " %c2(%1), %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(base),
      "i"(4) : "cc", "memory"));
}

/* add.w sym, Rd  (symbolic, PC-relative) */
void bench_add_sym_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc",
      "memory"));
}

/* add.w &abs, Rd  (absolute) */
void bench_add_abs_reg(void) {
  uint16_t dst = 0x1234;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " &sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc",
      "memory"));
}

/* add.w @Rs, Rd  (indirect) */
void bench_add_ind_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *p = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "add" WSUF " @%1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(p) : "cc",
      "memory"));
}

/* add.w @Rs+, Rd  (autoincrement) */
void bench_add_aut_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *p = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
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
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "add" WSUF " %0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(src),
                       "r"(base), "i"(4) : "cc", "memory"));
}

/* add.w Rs, sym  (symbolic) */
void bench_add_reg_sym(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "add" WSUF " %0, sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

/* add.w Rs, &abs  (absolute) */
void bench_add_reg_abs(void) {
  uint16_t src = 0x5678;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "add" WSUF " %0, &sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

/* ========== INC: register and memory destinations ========== */

/* inc.w Rd */
void bench_inc_reg(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "inc" WSUF " %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

/* inc.w off(base) */
void bench_inc_idx(void) {
  uint16_t *base = (uint16_t *)mem_buf;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "inc" WSUF " %c1(%0)\n"
                                                  ".endr\n" : : "r"(base),
                       "i"(4) : "cc", "memory"));
}

/* inc.w sym */
void bench_inc_sym(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "inc" WSUF " sym_data\n"
                                                  ".endr\n" : : : "cc",
                       "memory"));
}

/* inc.w &abs */
void bench_inc_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "inc" WSUF " &sym_data\n"
                                                  ".endr\n" : : : "cc",
                       "memory"));
}

/* ========== RLAM: immediate {1..4}, register destination ========== */

void bench_rlam_1_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #1, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

void bench_rlam_2_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #2, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

void bench_rlam_3_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #3, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

void bench_rlam_4_reg(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "rlam #4, %0\n"
                                 ".endr\n" : "+r"(dst) : : "cc"));
}

/* ========== Branches: JGE, JMP (relative only) ========== */
/* Provide taken and not-taken variants */

void bench_jge_not_taken(void) {
  uint16_t a = 0x0000,
           b = 0xFFFF; /* signed: a < b -> JGE is false (not taken) */
  REPEAT_INNER_ITERS(__asm__ volatile(
      /* Prime flags once: sets N/Z/C/V based on (a - b). */
      "cmp" WSUF " %1, %0\n"
      /* Repeat only the conditional branch; no cmp inside the loop. */
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  jge 1f\n"
                                 "  nop\n"
                                 "1:\n"
                                 ".endr\n" : "+r"(a) : "r"(b) : "cc"));
}

void bench_jge_taken(void) {
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

void bench_jmp(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "jmp 1f\n"
                                                  "1:\n"
                                                  ".endr\n" : : : "cc"));
}

/* ========== 1) Destination: indexed (off(base)) ========== */

/* reg -> idx */
void bench_mov_reg_to_idx(void) {
  uint16_t src = 0x5678;
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " %0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(src),
                       "r"(base), "i"(OFFS) : "cc", "memory"));
}

/* imm -> idx */
void bench_mov_imm_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " #0x1357, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

/* idx -> idx */
void bench_mov_idx_to_idx(void) {
  uint16_t *bsrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %c2(%0), %c3(%1)\n"
                                 ".endr\n" : : "r"(bsrc),
      "r"(bdst), "i"(OFFS), "i"(OFFS) : "cc", "memory"));
}

/* sym -> idx */
void bench_mov_sym_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " sym_data, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

/* abs -> idx */
void bench_mov_abs_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " &sym_data, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

/* ind -> idx */
void bench_mov_ind_to_idx(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " @%0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(psrc),
                       "r"(bdst), "i"(OFFS) : "cc", "memory"));
}

/* aut -> idx */
void bench_mov_aut_to_idx(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " @%0+, %c2(%1)\n"
                                                  ".endr\n" : : "r"(psrc),
                       "r"(bdst), "i"(OFFS) : "cc", "memory"));
}

/* ========== 2) Destination: symbolic (sym_data) ========== */

/* reg -> sym */
void bench_mov_reg_to_sym(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " %0, sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

/* imm -> sym */
void bench_mov_imm_to_sym(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " #0x1357, sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

/* idx -> sym */
void bench_mov_idx_to_sym(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %c1(%0), sym_data\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

/* sym -> sym */
void bench_mov_sym_to_sym(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " sym_data, sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

/* abs -> sym */
void bench_mov_abs_to_sym(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " &sym_data, sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

/* ind -> sym */
void bench_mov_ind_to_sym(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%0, sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

/* aut -> sym */
void bench_mov_aut_to_sym(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%0+, sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

/* ========== 3) Destination: absolute (&sym_data) ========== */

/* reg -> abs */
void bench_mov_reg_to_abs(void) {
  uint16_t src = 0x5678;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " %0, &sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

/* imm -> abs */
void bench_mov_imm_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " #0x1357, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

/* idx -> abs */
void bench_mov_idx_to_abs(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %c1(%0), &sym_data\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

/* sym -> abs */
void bench_mov_sym_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " sym_data, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

/* abs -> abs */
void bench_mov_abs_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " &sym_data, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

/* ind -> abs */
void bench_mov_ind_to_abs(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%0, &sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

/* aut -> abs */
void bench_mov_aut_to_abs(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%0+, &sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

/* -------- mov SRC -> Rd (7 sources, dest is register) -------- */

void bench_mov_reg_to_reg(void) {
  uint16_t dst = 0x1234, src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(src) :));
}

void bench_mov_imm_to_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "mov" WSUF " #0x1357, %0\n"
                                                  ".endr\n" : "+r"(dst) : :));
}

void bench_mov_idx_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *base = (uint16_t *)BASE_PTR; /* word-aligned base */
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " %c2(%1), %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(base),
      "i"(OFFS) : "memory"));
}

void bench_mov_sym_to_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "memory"));
}

void bench_mov_abs_to_reg(void) {
  uint16_t dst = 0x1234;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " &sym_data, %0\n"
                                 ".endr\n" : "+r"(dst) : : "memory"));
}

void bench_mov_ind_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%1, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(psrc) : "memory"));
}

void bench_mov_aut_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "mov" WSUF " @%1+, %0\n"
                                 ".endr\n" : "+r"(dst) : "r"(psrc) : "memory"));
}

/* =========================
 * CMP: SRC -> REG destination (7)
 * ========================= */

void bench_cmp_reg_to_reg(void) {
  uint16_t dst = 0x1234, src = 0x5678;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " %1, %0\n"
                                                  ".endr\n" : : "r"(dst),
                       "r"(src) : "cc"));
}

void bench_cmp_imm_to_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " #0x1357, %0\n"
                                 ".endr\n" : : "r"(dst) : "cc"));
}

void bench_cmp_idx_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *base = (uint16_t *)BASE_PTR; /* word aligned for .w */
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " %c2(%1), %0\n"
                                                  ".endr\n" : : "r"(dst),
                       "r"(base), "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_sym_to_reg(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " sym_data, %0\n"
                                                  ".endr\n" : : "r"(dst) : "cc",
                       "memory"));
}

void bench_cmp_abs_to_reg(void) {
  uint16_t dst = 0x1234;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " &sym_data, %0\n"
                                                  ".endr\n" : : "r"(dst) : "cc",
                       "memory"));
}

void bench_cmp_ind_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " @%1, %0\n"
                                                  ".endr\n" : : "r"(dst),
                       "r"(psrc) : "cc", "memory"));
}

void bench_cmp_aut_to_reg(void) {
  uint16_t dst = 0x1234;
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " @%1+, %0\n"
                                                  ".endr\n" : : "r"(dst),
                       "r"(psrc) : "cc", "memory"));
}

/* =========================
 * CMP: SRC -> IDX destination (7)
 * ========================= */

void bench_cmp_reg_to_idx(void) {
  uint16_t src = 0x5678;
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " %0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(src),
                       "r"(base), "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_imm_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " #0x1357, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_idx_to_idx(void) {
  uint16_t *bsrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " %c2(%0), %c3(%1)\n"
                                 ".endr\n" : : "r"(bsrc),
      "r"(bdst), "i"(OFFS), "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_sym_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " sym_data, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_abs_to_idx(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " &sym_data, %c1(%0)\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_ind_to_idx(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " @%0, %c2(%1)\n"
                                                  ".endr\n" : : "r"(psrc),
                       "r"(bdst), "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_aut_to_idx(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " @%0+, %c2(%1)\n"
                                                  ".endr\n" : : "r"(psrc),
                       "r"(bdst), "i"(OFFS) : "cc", "memory"));
}

/* =========================
 * CMP: SRC -> SYM destination (7)
 * ========================= */

void bench_cmp_reg_to_sym(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " %0, sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

void bench_cmp_imm_to_sym(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " #0x1357, sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

void bench_cmp_idx_to_sym(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " %c1(%0), sym_data\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_sym_to_sym(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " sym_data, sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

void bench_cmp_abs_to_sym(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " &sym_data, sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

void bench_cmp_ind_to_sym(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " @%0, sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

void bench_cmp_aut_to_sym(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " @%0+, sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

/* =========================
 * CMP: SRC -> ABS destination (7)
 * ========================= */

void bench_cmp_reg_to_abs(void) {
  uint16_t src = 0x5678;
  (void)sym_data;
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "cmp" WSUF " %0, &sym_data\n"
                                                  ".endr\n" : : "r"(src) : "cc",
                       "memory"));
}

void bench_cmp_imm_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " #0x1357, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

void bench_cmp_idx_to_abs(void) {
  uint16_t *base = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " %c1(%0), &sym_data\n"
                                 ".endr\n" : : "r"(base),
      "i"(OFFS) : "cc", "memory"));
}

void bench_cmp_sym_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " sym_data, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

void bench_cmp_abs_to_abs(void) {
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " &sym_data, &sym_data\n"
                                 ".endr\n" : : : "cc",
      "memory"));
}

void bench_cmp_ind_to_abs(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " @%0, &sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
}

void bench_cmp_aut_to_abs(void) {
  uint16_t *psrc = (uint16_t *)BASE_PTR;
  (void)sym_data;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "cmp" WSUF " @%0+, &sym_data\n"
                                 ".endr\n" : : "r"(psrc) : "cc",
      "memory"));
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
  REPEAT_WITH_EVENT(bench_jmp());

  REPEAT_WITH_EVENT(bench_mov_reg_to_idx());
  REPEAT_WITH_EVENT(bench_mov_imm_to_idx());
  REPEAT_WITH_EVENT(bench_mov_idx_to_idx());
  REPEAT_WITH_EVENT(bench_mov_sym_to_idx());
  REPEAT_WITH_EVENT(bench_mov_abs_to_idx());
  REPEAT_WITH_EVENT(bench_mov_ind_to_idx());
  REPEAT_WITH_EVENT(bench_mov_aut_to_idx());

  REPEAT_WITH_EVENT(bench_mov_reg_to_sym());
  REPEAT_WITH_EVENT(bench_mov_imm_to_sym());
  REPEAT_WITH_EVENT(bench_mov_idx_to_sym());
  REPEAT_WITH_EVENT(bench_mov_sym_to_sym());
  REPEAT_WITH_EVENT(bench_mov_abs_to_sym());
  REPEAT_WITH_EVENT(bench_mov_ind_to_sym());
  REPEAT_WITH_EVENT(bench_mov_aut_to_sym());

  REPEAT_WITH_EVENT(bench_mov_reg_to_abs());
  REPEAT_WITH_EVENT(bench_mov_imm_to_abs());
  REPEAT_WITH_EVENT(bench_mov_idx_to_abs());
  REPEAT_WITH_EVENT(bench_mov_sym_to_abs());
  REPEAT_WITH_EVENT(bench_mov_abs_to_abs());
  REPEAT_WITH_EVENT(bench_mov_ind_to_abs());
  REPEAT_WITH_EVENT(bench_mov_aut_to_abs());

  REPEAT_WITH_EVENT(bench_cmp_reg_to_reg());
  REPEAT_WITH_EVENT(bench_cmp_imm_to_reg());
  REPEAT_WITH_EVENT(bench_cmp_idx_to_reg());
  REPEAT_WITH_EVENT(bench_cmp_sym_to_reg());
  REPEAT_WITH_EVENT(bench_cmp_abs_to_reg());
  REPEAT_WITH_EVENT(bench_cmp_ind_to_reg());
  REPEAT_WITH_EVENT(bench_cmp_aut_to_reg());

  REPEAT_WITH_EVENT(bench_cmp_reg_to_idx());
  REPEAT_WITH_EVENT(bench_cmp_imm_to_idx());
  REPEAT_WITH_EVENT(bench_cmp_idx_to_idx());
  REPEAT_WITH_EVENT(bench_cmp_sym_to_idx());
  REPEAT_WITH_EVENT(bench_cmp_abs_to_idx());
  REPEAT_WITH_EVENT(bench_cmp_ind_to_idx());
  REPEAT_WITH_EVENT(bench_cmp_aut_to_idx());

  REPEAT_WITH_EVENT(bench_cmp_reg_to_sym());
  REPEAT_WITH_EVENT(bench_cmp_imm_to_sym());
  REPEAT_WITH_EVENT(bench_cmp_idx_to_sym());
  REPEAT_WITH_EVENT(bench_cmp_sym_to_sym());
  REPEAT_WITH_EVENT(bench_cmp_abs_to_sym());
  REPEAT_WITH_EVENT(bench_cmp_ind_to_sym());
  REPEAT_WITH_EVENT(bench_cmp_aut_to_sym());

  REPEAT_WITH_EVENT(bench_cmp_reg_to_abs());
  REPEAT_WITH_EVENT(bench_cmp_imm_to_abs());
  REPEAT_WITH_EVENT(bench_cmp_idx_to_abs());
  REPEAT_WITH_EVENT(bench_cmp_sym_to_abs());
  REPEAT_WITH_EVENT(bench_cmp_abs_to_abs());
  REPEAT_WITH_EVENT(bench_cmp_ind_to_abs());
  REPEAT_WITH_EVENT(bench_cmp_aut_to_abs());

  end_measurement_window();

  return 0;
}
