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



INLINE void bench_addc_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  addc.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_mov_register_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_mov_register_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [src] "r"(src), [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_mov_immediate_indexed(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w #0x1357, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_immediate_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w #0x1357, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_register(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w %c[offs_src](%[base_src0]), %[dst]\n"
      "  mov.w %c[offs_src](%[base_src1]), %[dst]\n"
      "  mov.w %c[offs_src](%[base_src2]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w %c[offs_src](%[base_src0]), %c[offs_dst](%[base_dst])\n"
      "  mov.w %c[offs_src](%[base_src1]), %c[offs_dst](%[base_dst])\n"
      "  mov.w %c[offs_src](%[base_src2]), %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS), [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_absolute(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w %c[offs_src](%[base_src0]), &sym_data\n"
      "  mov.w %c[offs_src](%[base_src1]), &sym_data\n"
      "  mov.w %c[offs_src](%[base_src2]), &sym_data\n"
      ".endr\n"
      : 
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_addc_immediate_register());
  BENCH(bench_mov_register_register());
  BENCH(bench_mov_register_indexed());
  BENCH(bench_mov_register_absolute());
  BENCH(bench_mov_immediate_register());
  BENCH(bench_mov_immediate_indexed());
  BENCH(bench_mov_immediate_absolute());
  BENCH(bench_mov_indexed_register());
  BENCH(bench_mov_indexed_indexed());
  BENCH(bench_mov_indexed_absolute());

  end_measurement_window();

  return 0;
}