#include "setup.h"

#if defined(__GNUC__)
#undef REPEAT_INNER_ITERS
#define REPEAT_INNER_ITERS(X)                                                  \
  _Pragma("GCC unroll 0")                                                      \
  for (int _rep_inner_ = 0; _rep_inner_ < (INNER_ITERS); ++_rep_inner_) {      \
    X;                                                                         \
  }
#endif

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_bis_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bis.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_bis_indexed_register(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  bis.w %c[offs_src](%[base_src0]), %[dst]\n"
      "  bis.w %c[offs_src](%[base_src1]), %[dst]\n"
      "  bis.w %c[offs_src](%[base_src2]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_bis_indexed_indexed(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  bis.w %c[offs_src](%[base_src0]), %c[offs_dst](%[base_dst0])\n"
      "  bis.w %c[offs_src](%[base_src1]), %c[offs_dst](%[base_dst1])\n"
      "  bis.w %c[offs_src](%[base_src2]), %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS), [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_bis_symbolic_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bis.w sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_bis_symbolic_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bis.w sym_data, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_adc_indexed(void) {
  uint16_t* base0 = BASE_PTR;
  uint16_t* base1 = (BASE_PTR) + 8;
  uint16_t* base2 = (BASE_PTR) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  adc.w %c[offs](%[base0])\n"
      "  adc.w %c[offs](%[base1])\n"
      "  adc.w %c[offs](%[base2])\n"
      ".endr\n"
      : 
      : [base0] "r"(base0), [base1] "r"(base1), [base2] "r"(base2), [offs] "i"(OFFS)
      : "cc", "memory"));
}

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
  uint16_t* base0 = BASE_PTR;
  uint16_t* base1 = (BASE_PTR) + 8;
  uint16_t* base2 = (BASE_PTR) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  inc.w %c[offs](%[base0])\n"
      "  inc.w %c[offs](%[base1])\n"
      "  inc.w %c[offs](%[base2])\n"
      ".endr\n"
      : 
      : [base0] "r"(base0), [base1] "r"(base1), [base2] "r"(base2), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_inc_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_incd_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  incd.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_bis_immediate_register());
  BENCH(bench_bis_indexed_register());
  BENCH(bench_bis_indexed_indexed());
  BENCH(bench_bis_symbolic_register());
  BENCH(bench_bis_symbolic_absolute());
  BENCH(bench_adc_indexed());
  BENCH(bench_inc_register());
  BENCH(bench_inc_indexed());
  BENCH(bench_inc_symbolic());
  BENCH(bench_incd_register());

  end_measurement_window();

  return 0;
}