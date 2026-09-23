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



INLINE void bench_mov_autoincrement_indexed(void) {
  uint16_t* psrc0 = BASE_PTR;
  uint16_t* psrc1 = (BASE_PTR) + 8;
  uint16_t* psrc2 = (BASE_PTR) + 16;
  uint16_t* psrc_reset0 = BASE_PTR;
  uint16_t* psrc_reset1 = (BASE_PTR) + 8;
  uint16_t* psrc_reset2 = (BASE_PTR) + 16;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w @%[psrc0]+, %c[offs_dst](%[base_dst])\n"
      "  mov.w @%[psrc1]+, %c[offs_dst](%[base_dst])\n"
      "  mov.w @%[psrc2]+, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      "  mov %[psrc_reset0], %[psrc0]\n"
      "  mov %[psrc_reset1], %[psrc1]\n"
      "  mov %[psrc_reset2], %[psrc2]\n"
      : [psrc0] "+r"(psrc0), [psrc1] "+r"(psrc1), [psrc2] "+r"(psrc2)
      : [psrc_reset0] "r"(psrc_reset0), [psrc_reset1] "r"(psrc_reset1), [psrc_reset2] "r"(psrc_reset2), [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_register_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %[src], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_cmp_register_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  cmp.w %[src], %c[offs_dst](%[base_dst0])\n"
      "  cmp.w %[src], %c[offs_dst](%[base_dst1])\n"
      "  cmp.w %[src], %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [src] "r"(src), [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_cmp_immediate_indexed(void) {
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  cmp.w #0x1357, %c[offs_dst](%[base_dst0])\n"
      "  cmp.w #0x1357, %c[offs_dst](%[base_dst1])\n"
      "  cmp.w #0x1357, %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_immediate_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_indexed_register(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  cmp.w %c[offs_src](%[base_src0]), %[dst]\n"
      "  cmp.w %c[offs_src](%[base_src1]), %[dst]\n"
      "  cmp.w %c[offs_src](%[base_src2]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_indexed_indexed(void) {
  uint16_t* base_src0 = BASE_PTR;
  uint16_t* base_src1 = (BASE_PTR) + 8;
  uint16_t* base_src2 = (BASE_PTR) + 16;
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  cmp.w %c[offs_src](%[base_src0]), %c[offs_dst](%[base_dst0])\n"
      "  cmp.w %c[offs_src](%[base_src1]), %c[offs_dst](%[base_dst1])\n"
      "  cmp.w %c[offs_src](%[base_src2]), %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [base_src0] "r"(base_src0), [base_src1] "r"(base_src1), [base_src2] "r"(base_src2), [offs_src] "i"(OFFS), [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_symbolic_indexed(void) {
  uint16_t* base_dst0 = BASE_PTR + 8;
  uint16_t* base_dst1 = (BASE_PTR + 8) + 8;
  uint16_t* base_dst2 = (BASE_PTR + 8) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  cmp.w sym_data, %c[offs_dst](%[base_dst0])\n"
      "  cmp.w sym_data, %c[offs_dst](%[base_dst1])\n"
      "  cmp.w sym_data, %c[offs_dst](%[base_dst2])\n"
      ".endr\n"
      : 
      : [base_dst0] "r"(base_dst0), [base_dst1] "r"(base_dst1), [base_dst2] "r"(base_dst2), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_autoincrement_indexed());
  BENCH(bench_cmp_register_register());
  BENCH(bench_cmp_register_indexed());
  BENCH(bench_cmp_immediate_register());
  BENCH(bench_cmp_immediate_indexed());
  BENCH(bench_cmp_immediate_absolute());
  BENCH(bench_cmp_indexed_register());
  BENCH(bench_cmp_indexed_indexed());
  BENCH(bench_cmp_symbolic_register());
  BENCH(bench_cmp_symbolic_indexed());

  end_measurement_window();

  return 0;
}