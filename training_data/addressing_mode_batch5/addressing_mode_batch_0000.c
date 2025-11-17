#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_add_register_register(void) {
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %[src], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_add_register_indexed(void) {
  uint16_t* dst_base = BASE_PTR;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %[src], %c[dst_offs](%[dst_base])\n"
      ".endr\n"
      : 
      : [dst_base] "r"(dst_base), [dst_offs] "i"(OFFS), [src] "r"(src)
      : "cc"));
}

INLINE void bench_add_register_symbolic(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %[src], sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_add_register_absolute(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %[src], &sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_add_immediate_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_add_register_register());
  BENCH(bench_add_register_indexed());
  BENCH(bench_add_register_symbolic());
  BENCH(bench_add_register_absolute());
  BENCH(bench_add_immediate_register());

  end_measurement_window();

  return 0;
}