#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_cmp_register_indexed__rlam_immediate_3_register(void) {
  uint16_t src = 0x5678;
  uint16_t* base = BASE_PTR;
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %[src], %c[offs](%[base])\n"
      "  rlam #3, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_register_indexed__rlam_immediate_4_register(void) {
  uint16_t src = 0x5678;
  uint16_t* base = BASE_PTR;
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %[src], %c[offs](%[base])\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_register_indexed__jmp_symbolic(void) {
  uint16_t src = 0x5678;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %[src], %c[offs](%[base])\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_register_indexed__jge_symbolic(void) {
  uint16_t src = 0x5678;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %[src], %c[offs](%[base])\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_symbolic__cmp_register_symbolic(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, sym_data\n"
      "  cmp.w %[src], sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_symbolic__cmp_immediate_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, sym_data\n"
      "  cmp.w #0x1357, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_symbolic__cmp_register_absolute(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, sym_data\n"
      "  cmp.w %[src], &sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_symbolic__inc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, sym_data\n"
      "  inc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_symbolic__inc_indexed(void) {
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, sym_data\n"
      "  inc.w %c[offs](%[base])\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_symbolic__inc_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, sym_data\n"
      "  inc.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_cmp_register_indexed__rlam_immediate_3_register());
  BENCH(bench_cmp_register_indexed__rlam_immediate_4_register());
  BENCH(bench_cmp_register_indexed__jmp_symbolic());
  BENCH(bench_cmp_register_indexed__jge_symbolic());
  BENCH(bench_cmp_immediate_symbolic__cmp_register_symbolic());
  BENCH(bench_cmp_immediate_symbolic__cmp_immediate_absolute());
  BENCH(bench_cmp_immediate_symbolic__cmp_register_absolute());
  BENCH(bench_cmp_immediate_symbolic__inc_register());
  BENCH(bench_cmp_immediate_symbolic__inc_indexed());
  BENCH(bench_cmp_immediate_symbolic__inc_symbolic());

  end_measurement_window();

  return 0;
}