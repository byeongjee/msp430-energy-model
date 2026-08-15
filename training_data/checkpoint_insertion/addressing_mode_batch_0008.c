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



INLINE void bench_incd_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  incd.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_clr_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  clr.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_clr_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  clr.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_inv_register(void) {
  uint16_t dst = 0x0000;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inv.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rla_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rla.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rla_indexed(void) {
  uint16_t* base0 = BASE_PTR;
  uint16_t* base1 = (BASE_PTR) + 8;
  uint16_t* base2 = (BASE_PTR) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  rla.w %c[offs](%[base0])\n"
      "  rla.w %c[offs](%[base1])\n"
      "  rla.w %c[offs](%[base2])\n"
      ".endr\n"
      : 
      : [base0] "r"(base0), [base1] "r"(base1), [base2] "r"(base2), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_rla_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rla.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_rlc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rrc_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rrc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rrc_indexed(void) {
  uint16_t* base0 = BASE_PTR;
  uint16_t* base1 = (BASE_PTR) + 8;
  uint16_t* base2 = (BASE_PTR) + 16;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) " / 3" "\n"
      "  rrc.w %c[offs](%[base0])\n"
      "  rrc.w %c[offs](%[base1])\n"
      "  rrc.w %c[offs](%[base2])\n"
      ".endr\n"
      : 
      : [base0] "r"(base0), [base1] "r"(base1), [base2] "r"(base2), [offs] "i"(OFFS)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_incd_symbolic());
  BENCH(bench_clr_register());
  BENCH(bench_clr_symbolic());
  BENCH(bench_inv_register());
  BENCH(bench_rla_register());
  BENCH(bench_rla_indexed());
  BENCH(bench_rla_symbolic());
  BENCH(bench_rlc_register());
  BENCH(bench_rrc_register());
  BENCH(bench_rrc_indexed());

  end_measurement_window();

  return 0;
}