#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_mov_register_absolute__cmp_immediate_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_indexed_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w %c[offs](%[base]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_symbolic_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_absolute_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w &sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_indirect_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w @%[psrc], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_indirect_auto_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w @%[psrc]+, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_immediate_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w #0x1357, %c[offs](%[base])\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_register_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w %[src], %c[offs](%[base])\n"
      ".endr\n"
      : 
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_immediate_symbolic(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w #0x1357, sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_absolute__cmp_register_symbolic(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &sym_data\n"
      "  cmp.w %[src], sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_register_absolute__cmp_immediate_register());
  BENCH(bench_mov_register_absolute__cmp_indexed_register());
  BENCH(bench_mov_register_absolute__cmp_symbolic_register());
  BENCH(bench_mov_register_absolute__cmp_absolute_register());
  BENCH(bench_mov_register_absolute__cmp_indirect_register());
  BENCH(bench_mov_register_absolute__cmp_indirect_auto_register());
  BENCH(bench_mov_register_absolute__cmp_immediate_indexed());
  BENCH(bench_mov_register_absolute__cmp_register_indexed());
  BENCH(bench_mov_register_absolute__cmp_immediate_symbolic());
  BENCH(bench_mov_register_absolute__cmp_register_symbolic());

  end_measurement_window();

  return 0;
}