#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_mov_indirect_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc], sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_absolute(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc], &sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_indexed(void) {
  uint16_t* dst_base = BASE_PTR;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %c[dst_offs](%[dst_base])\n"
      ".endr\n"
      : 
      : [dst_base] "r"(dst_base), [dst_offs] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_indirect_symbolic());
  BENCH(bench_mov_indirect_absolute());
  BENCH(bench_mov_indirect_auto_register());
  BENCH(bench_mov_indirect_auto_indexed());
  BENCH(bench_mov_indirect_auto_symbolic());

  end_measurement_window();

  return 0;
}