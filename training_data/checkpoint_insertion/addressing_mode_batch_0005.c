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



INLINE void bench_and_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  and.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_and_immediate_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  and.w #0x1357, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_and_indexed_register(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  and.w %c[offs_src](%[base_src0]), %[dst]\n"
      "  and.w %c[offs_src](%[base_src1]), %[dst]\n"
      "  and.w %c[offs_src](%[base_src2]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_and_symbolic_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  and.w sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_and_symbolic_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  and.w sym_data, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_and_absolute_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  and.w &sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_xor_register_register(void) {
  uint16_t src = 0xFFFF;
  uint16_t dst = 0x0000;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  xor.w %[src], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}
static volatile uint16_t bench_xor_register_indexed_dst_buf[32] __attribute__((aligned(64))) = {0};


INLINE void bench_xor_register_indexed(void) {
  uint16_t src = 0xFFFF;
  uint16_t* base_dst0 = bench_xor_register_indexed_dst_buf + 8;
  uint16_t* base_dst1 = (bench_xor_register_indexed_dst_buf + 8) + 8;
  uint16_t* base_dst2 = (bench_xor_register_indexed_dst_buf + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  xor.w %[src], %c[offs_dst](%[base_dst0])\n"
      "  xor.w %[src], %c[offs_dst](%[base_dst1])\n"
      "  xor.w %[src], %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [src] "r"(src), [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_xor_immediate_register(void) {
  uint16_t dst = 0x0000;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  xor.w #0xFFFE, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}
static volatile uint16_t bench_xor_immediate_indexed_dst_buf[32] __attribute__((aligned(64))) = {0};


INLINE void bench_xor_immediate_indexed(void) {
  uint16_t* base_dst0 = bench_xor_immediate_indexed_dst_buf + 8;
  uint16_t* base_dst1 = (bench_xor_immediate_indexed_dst_buf + 8) + 8;
  uint16_t* base_dst2 = (bench_xor_immediate_indexed_dst_buf + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  xor.w #0xFFFE, %c[offs_dst](%[base_dst0])\n"
      "  xor.w #0xFFFE, %c[offs_dst](%[base_dst1])\n"
      "  xor.w #0xFFFE, %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_and_immediate_register());
  BENCH(bench_and_immediate_absolute());
  BENCH(bench_and_indexed_register());
  BENCH(bench_and_symbolic_register());
  BENCH(bench_and_symbolic_absolute());
  BENCH(bench_and_absolute_register());
  BENCH(bench_xor_register_register());
  BENCH(bench_xor_register_indexed());
  BENCH(bench_xor_immediate_register());
  BENCH(bench_xor_immediate_indexed());

  end_measurement_window();

  return 0;
}