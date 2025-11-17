#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_cmp_symbolic_register__cmp_immediate_symbolic(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  cmp.w #0x1357, sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__cmp_register_symbolic(void) {
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  cmp.w %[src], sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__cmp_immediate_absolute(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  cmp.w #0x1357, &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__cmp_register_absolute(void) {
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  cmp.w %[src], &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__inc_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  inc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__inc_indexed(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  inc.w %c[offs](%[base])\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__inc_symbolic(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  inc.w sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__inc_absolute(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  inc.w &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__rlam_immediate_1_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  rlam #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register__rlam_immediate_2_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      "  rlam #2, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_cmp_symbolic_register__cmp_immediate_symbolic());
  BENCH(bench_cmp_symbolic_register__cmp_register_symbolic());
  BENCH(bench_cmp_symbolic_register__cmp_immediate_absolute());
  BENCH(bench_cmp_symbolic_register__cmp_register_absolute());
  BENCH(bench_cmp_symbolic_register__inc_register());
  BENCH(bench_cmp_symbolic_register__inc_indexed());
  BENCH(bench_cmp_symbolic_register__inc_symbolic());
  BENCH(bench_cmp_symbolic_register__inc_absolute());
  BENCH(bench_cmp_symbolic_register__rlam_immediate_1_register());
  BENCH(bench_cmp_symbolic_register__rlam_immediate_2_register());

  end_measurement_window();

  return 0;
}