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



INLINE void bench_bit_immediate_indexed(void) {
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  bit.w #0x1357, %c[offs_dst](%[base_dst0])\n"
      "  bit.w #0x1357, %c[offs_dst](%[base_dst1])\n"
      "  bit.w #0x1357, %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_bit_symbolic_indexed(void) {
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  bit.w sym_data, %c[offs_dst](%[base_dst0])\n"
      "  bit.w sym_data, %c[offs_dst](%[base_dst1])\n"
      "  bit.w sym_data, %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_bit_symbolic_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bit.w sym_data, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_bic_register_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bic.w %[src], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_bic_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bic.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_bic_immediate_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bic.w #0x1357, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_bic_symbolic_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bic.w sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_bis_register_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  bis.w %[src], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_bis_register_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  bis.w %[src], %c[offs_dst](%[base_dst0])\n"
      "  bis.w %[src], %c[offs_dst](%[base_dst1])\n"
      "  bis.w %[src], %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [src] "r"(src), [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

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

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_bit_immediate_indexed());
  BENCH(bench_bit_symbolic_indexed());
  BENCH(bench_bit_symbolic_absolute());
  BENCH(bench_bic_register_register());
  BENCH(bench_bic_immediate_register());
  BENCH(bench_bic_immediate_absolute());
  BENCH(bench_bic_symbolic_register());
  BENCH(bench_bis_register_register());
  BENCH(bench_bis_register_indexed());
  BENCH(bench_bis_immediate_register());

  end_measurement_window();

  return 0;
}