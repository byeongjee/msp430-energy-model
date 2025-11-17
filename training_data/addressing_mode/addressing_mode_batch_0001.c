#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_add_indexed_symbolic(void) {
  uint16_t* src_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[src_offs](%[src_base]), sym_data\n"
      ".endr\n"
      : 
      : [src_base] "r"(src_base), [src_offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_absolute(void) {
  uint16_t* src_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[src_offs](%[src_base]), &sym_data\n"
      ".endr\n"
      : 
      : [src_base] "r"(src_base), [src_offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_symbolic_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_add_symbolic_indexed(void) {
  uint16_t* dst_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w sym_data, %c[dst_offs](%[dst_base])\n"
      ".endr\n"
      : 
      : [dst_base] "r"(dst_base), [dst_offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_symbolic_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w sym_data, sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_add_symbolic_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w sym_data, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_add_absolute_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w &sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_add_absolute_indexed(void) {
  uint16_t* dst_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w &sym_data, %c[dst_offs](%[dst_base])\n"
      ".endr\n"
      : 
      : [dst_base] "r"(dst_base), [dst_offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_absolute_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w &sym_data, sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_add_absolute_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w &sym_data, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_add_indexed_symbolic());
  BENCH(bench_add_indexed_absolute());
  BENCH(bench_add_symbolic_register());
  BENCH(bench_add_symbolic_indexed());
  BENCH(bench_add_symbolic_symbolic());
  BENCH(bench_add_symbolic_absolute());
  BENCH(bench_add_absolute_register());
  BENCH(bench_add_absolute_indexed());
  BENCH(bench_add_absolute_symbolic());
  BENCH(bench_add_absolute_absolute());

  end_measurement_window();

  return 0;
}