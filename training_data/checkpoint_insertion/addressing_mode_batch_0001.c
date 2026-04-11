#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



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
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS), [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_absolute(void) {
  uint16_t* base_src = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), &sym_data\n"
      ".endr\n"
      : 
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

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

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_immediate_indexed());
  BENCH(bench_mov_immediate_absolute());
  BENCH(bench_mov_indexed_register());
  BENCH(bench_mov_indexed_indexed());
  BENCH(bench_mov_indexed_absolute());
  BENCH(bench_mov_symbolic_register());
  BENCH(bench_mov_symbolic_indexed());
  BENCH(bench_mov_symbolic_absolute());
  BENCH(bench_mov_absolute_register());
  BENCH(bench_mov_absolute_indexed());

  end_measurement_window();

  return 0;
}