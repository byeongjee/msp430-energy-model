#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_rlam_immediate_2_register__jl_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #2, %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_3_register__jl_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #3, %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_4_register__jl_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #4, %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_jmp_symbolic__jl_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jmp 1f\n1:\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jge_symbolic__jl_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jge 1f\n1:\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_rlam_immediate_2_register__jl_symbolic());
  BENCH(bench_rlam_immediate_3_register__jl_symbolic());
  BENCH(bench_rlam_immediate_4_register__jl_symbolic());
  BENCH(bench_jmp_symbolic__jl_symbolic());
  BENCH(bench_jge_symbolic__jl_symbolic());

  end_measurement_window();

  return 0;
}