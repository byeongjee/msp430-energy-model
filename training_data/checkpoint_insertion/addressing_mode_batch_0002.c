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



INLINE void bench_mov_symbolic_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_symbolic_indexed(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w sym_data, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_symbolic_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w sym_data, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_indexed(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_register(void) {
  uint16_t* psrc0 = BASE_PTR;
  uint16_t* psrc1 = (BASE_PTR) + 8;
  uint16_t* psrc2 = (BASE_PTR) + 16;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w @%[psrc0], %[dst]\n"
      "  mov.w @%[psrc1], %[dst]\n"
      "  mov.w @%[psrc2], %[dst]\n"
      ".endr\n"
      : [psrc0] "+r"(psrc0), [psrc1] "+r"(psrc1), [psrc2] "+r"(psrc2), [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_indexed(void) {
  uint16_t* psrc0 = BASE_PTR;
  uint16_t* psrc1 = (BASE_PTR) + 8;
  uint16_t* psrc2 = (BASE_PTR) + 16;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w @%[psrc0], %c[offs_dst](%[base_dst])\n"
      "  mov.w @%[psrc1], %c[offs_dst](%[base_dst])\n"
      "  mov.w @%[psrc2], %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : [psrc0] "+r"(psrc0), [psrc1] "+r"(psrc1), [psrc2] "+r"(psrc2)
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_absolute(void) {
  uint16_t* psrc0 = BASE_PTR;
  uint16_t* psrc1 = (BASE_PTR) + 8;
  uint16_t* psrc2 = (BASE_PTR) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w @%[psrc0], &sym_data\n"
      "  mov.w @%[psrc1], &sym_data\n"
      "  mov.w @%[psrc2], &sym_data\n"
      ".endr\n"
      : [psrc0] "+r"(psrc0), [psrc1] "+r"(psrc1), [psrc2] "+r"(psrc2)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_autoincrement_register(void) {
  uint16_t* psrc0 = BASE_PTR;
  uint16_t* psrc1 = (BASE_PTR) + 8;
  uint16_t* psrc2 = (BASE_PTR) + 16;
  uint16_t* psrc_reset0 = BASE_PTR;
  uint16_t* psrc_reset1 = (BASE_PTR) + 8;
  uint16_t* psrc_reset2 = (BASE_PTR) + 16;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  mov.w @%[psrc0]+, %[dst]\n"
      "  mov.w @%[psrc1]+, %[dst]\n"
      "  mov.w @%[psrc2]+, %[dst]\n"
      ".endr\n"
      "  mov %[psrc_reset0], %[psrc0]\n"
      "  mov %[psrc_reset1], %[psrc1]\n"
      "  mov %[psrc_reset2], %[psrc2]\n"
      : [psrc0] "+r"(psrc0), [psrc1] "+r"(psrc1), [psrc2] "+r"(psrc2), [dst] "+r"(dst)
      : [psrc_reset0] "r"(psrc_reset0), [psrc_reset1] "r"(psrc_reset1), [psrc_reset2] "r"(psrc_reset2)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_symbolic_register());
  BENCH(bench_mov_symbolic_indexed());
  BENCH(bench_mov_symbolic_absolute());
  BENCH(bench_mov_absolute_register());
  BENCH(bench_mov_absolute_indexed());
  BENCH(bench_mov_absolute_absolute());
  BENCH(bench_mov_indirect_register());
  BENCH(bench_mov_indirect_indexed());
  BENCH(bench_mov_indirect_absolute());
  BENCH(bench_mov_autoincrement_register());

  end_measurement_window();

  return 0;
}