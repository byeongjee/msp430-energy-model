#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4

INLINE void bench_and_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  and.w #0x1357, %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_and_immediate_indexed(void) {
  uint16_t *base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  and.w #0x1357, %c[offs_dst](%[base_dst])\n"
                                 ".endr\n" : : [base_dst] "r"(base_dst),
      [offs_dst] "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_xor_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  xor.w #0x1357, %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_xor_indexed_register(void) {
  uint16_t *base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  xor.w %c[offs_src](%[base_src]), %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : [base_src] "r"(
                                     base_src),
      [offs_src] "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_xor_indexed_indexed(void) {
  uint16_t *base_src = BASE_PTR;
  uint16_t *base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  xor.w %c[offs_src](%[base_src]), "
                                 "%c[offs_dst](%[base_dst])\n"
                                 ".endr\n" : : [base_src] "r"(base_src),
      [offs_src] "i"(OFFS), [base_dst] "r"(base_dst),
      [offs_dst] "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_inc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  inc.w %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_inc_indexed(void) {
  uint16_t *base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  inc.w %c[offs](%[base])\n"
                                 ".endr\n" : : [base] "r"(base),
      [offs] "i"(OFFS) : "cc", "memory"));
}

INLINE void bench_incd_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  incd.w %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_decd_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  decd.w %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_clr_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  clr.w %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_rla_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  rla.w %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_rlc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  rlc.w %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_rlam_immediate_1_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  rlam #1, %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_rlam_immediate_4_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  rlam #4, %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_rrum_immediate_1_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  rrum #1, %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_pushm_immediate_2_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  pushm #2, %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_popm_immediate_2_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  popm #2, %[dst]\n"
                                 ".endr\n" : [dst] "+r"(dst) : : "cc"));
}

INLINE void bench_jmp_symbolic(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "  jmp 1f\n1:\n"
                                                  ".endr\n" : : : "cc"));
}

INLINE void bench_jge_symbolic(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "  jge 1f\n1:\n"
                                                  ".endr\n" : : : "cc"));
}

INLINE void bench_jnz_symbolic(void) {
  REPEAT_INNER_ITERS(
      __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                  "  jnz 1f\n1:\n"
                                                  ".endr\n" : : : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_and_immediate_register());
  BENCH(bench_and_immediate_indexed());
  BENCH(bench_xor_immediate_register());
  BENCH(bench_xor_indexed_register());
  BENCH(bench_xor_indexed_indexed());
  BENCH(bench_inc_register());
  BENCH(bench_inc_indexed());
  BENCH(bench_incd_register());
  BENCH(bench_decd_register());
  BENCH(bench_clr_register());
  BENCH(bench_rla_register());
  BENCH(bench_rlc_register());
  BENCH(bench_rlam_immediate_1_register());
  BENCH(bench_rlam_immediate_4_register());
  BENCH(bench_rrum_immediate_1_register());
  BENCH(bench_jmp_symbolic());
  BENCH(bench_jge_symbolic());
  BENCH(bench_jnz_symbolic());

  end_measurement_window();

  return 0;
}