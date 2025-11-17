#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



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
  uint16_t* dst_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, %c[dst_offs](%[dst_base])\n"
      ".endr\n"
      : 
      : [dst_base] "r"(dst_base), [dst_offs] "i"(OFFS)
      : "cc"));
}

INLINE void bench_cmp_immediate_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_cmp_immediate_absolute(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w #0x1357, &sym_data\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_cmp_indexed_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* src_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %c[src_offs](%[src_base]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src_base] "r"(src_base), [src_offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_indexed_indexed(void) {
  uint16_t* dst_base = BASE_PTR;
  uint16_t* src_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %c[src_offs](%[src_base]), %c[dst_offs](%[dst_base])\n"
      ".endr\n"
      : 
      : [dst_base] "r"(dst_base), [dst_offs] "i"(OFFS), [src_base] "r"(src_base), [src_offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_indexed_symbolic(void) {
  uint16_t* src_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %c[src_offs](%[src_base]), sym_data\n"
      ".endr\n"
      : 
      : [src_base] "r"(src_base), [src_offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_indexed_absolute(void) {
  uint16_t* src_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %c[src_offs](%[src_base]), &sym_data\n"
      ".endr\n"
      : 
      : [src_base] "r"(src_base), [src_offs] "i"(OFFS)
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
  uint16_t* dst_base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w sym_data, %c[dst_offs](%[dst_base])\n"
      ".endr\n"
      : 
      : [dst_base] "r"(dst_base), [dst_offs] "i"(OFFS)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_cmp_immediate_register());
  BENCH(bench_cmp_immediate_indexed());
  BENCH(bench_cmp_immediate_symbolic());
  BENCH(bench_cmp_immediate_absolute());
  BENCH(bench_cmp_indexed_register());
  BENCH(bench_cmp_indexed_indexed());
  BENCH(bench_cmp_indexed_symbolic());
  BENCH(bench_cmp_indexed_absolute());
  BENCH(bench_cmp_symbolic_register());
  BENCH(bench_cmp_symbolic_indexed());

  end_measurement_window();

  return 0;
}