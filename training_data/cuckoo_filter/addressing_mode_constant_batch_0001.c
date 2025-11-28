#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_inc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

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

INLINE void bench_clr_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  clr.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rla_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rla.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rrux_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rrux.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
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

INLINE void bench_rlam_immediate_4_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rrum_immediate_1_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rrum #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_jmp_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jnz_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jnz 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jz_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jz 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_inc_register());
  BENCH(bench_inc_indexed());
  BENCH(bench_clr_register());
  BENCH(bench_rla_register());
  BENCH(bench_rlc_register());
  BENCH(bench_rrux_register());
  BENCH(bench_rlam_immediate_1_register());
  BENCH(bench_rlam_immediate_4_register());
  BENCH(bench_rrum_immediate_1_register());
  BENCH(bench_jmp_symbolic());
  BENCH(bench_jnz_symbolic());
  BENCH(bench_jz_symbolic());

  end_measurement_window();

  return 0;
}