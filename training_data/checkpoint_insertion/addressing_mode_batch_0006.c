#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_sxt_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  sxt.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rra_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rra.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rra_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rra.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_swpb_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  swpb.w %[dst]\n"
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

INLINE void bench_jge_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jl_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jl 1f\n1:\n"
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

INLINE void bench_jnc_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jnc 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_sxt_register());
  BENCH(bench_rra_register());
  BENCH(bench_rra_symbolic());
  BENCH(bench_swpb_register());
  BENCH(bench_jmp_symbolic());
  BENCH(bench_jge_symbolic());
  BENCH(bench_jl_symbolic());
  BENCH(bench_jnz_symbolic());
  BENCH(bench_jz_symbolic());
  BENCH(bench_jnc_symbolic());

  end_measurement_window();

  return 0;
}