#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_cmp_indirect_absolute__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w @%[psrc], &sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_cmp_indirect_auto_register__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w @%[psrc]+, %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_cmp_indirect_auto_indexed__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w @%[psrc]+, %c[offs_dst](%[base_dst])\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_cmp_indirect_auto_symbolic__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w @%[psrc]+, sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_cmp_indirect_auto_absolute__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w @%[psrc]+, &sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_inc_register__jl_symbolic(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_inc_indexed__jl_symbolic(void) {
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w %c[offs](%[base])\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_inc_symbolic__jl_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_inc_absolute__jl_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w &sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_rlam_immediate_1_register__jl_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #1, %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_cmp_indirect_absolute__jl_symbolic());
  BENCH(bench_cmp_indirect_auto_register__jl_symbolic());
  BENCH(bench_cmp_indirect_auto_indexed__jl_symbolic());
  BENCH(bench_cmp_indirect_auto_symbolic__jl_symbolic());
  BENCH(bench_cmp_indirect_auto_absolute__jl_symbolic());
  BENCH(bench_inc_register__jl_symbolic());
  BENCH(bench_inc_indexed__jl_symbolic());
  BENCH(bench_inc_symbolic__jl_symbolic());
  BENCH(bench_inc_absolute__jl_symbolic());
  BENCH(bench_rlam_immediate_1_register__jl_symbolic());

  end_measurement_window();

  return 0;
}