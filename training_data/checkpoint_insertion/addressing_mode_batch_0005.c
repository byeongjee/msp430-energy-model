#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_inc_indexed(void) {
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  inc.w %c[offs](%[base])\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS)
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
  uint16_t dst = 0x2222;
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

INLINE void bench_rla_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rla.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
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

INLINE void bench_rrc_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rrc.w sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_inc_indexed());
  BENCH(bench_inc_symbolic());
  BENCH(bench_incd_register());
  BENCH(bench_clr_register());
  BENCH(bench_clr_symbolic());
  BENCH(bench_inv_register());
  BENCH(bench_rla_register());
  BENCH(bench_rla_symbolic());
  BENCH(bench_rrc_register());
  BENCH(bench_rrc_symbolic());

  end_measurement_window();

  return 0;
}