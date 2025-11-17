#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_mov_register_symbolic__mov_symbolic_symbolic(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w sym_data, sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_symbolic_absolute(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w sym_data, &sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_absolute_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w &sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_absolute_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w &sym_data, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_absolute_symbolic(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w &sym_data, sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_absolute_absolute(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w &sym_data, &sym_data\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_indirect_register(void) {
  uint16_t src = 0x5678;
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w @%[psrc], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_indirect_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w @%[psrc], %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_indirect_symbolic(void) {
  uint16_t src = 0x5678;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w @%[psrc], sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_symbolic__mov_indirect_absolute(void) {
  uint16_t src = 0x5678;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], sym_data\n"
      "  mov.w @%[psrc], &sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_register_symbolic__mov_symbolic_symbolic());
  BENCH(bench_mov_register_symbolic__mov_symbolic_absolute());
  BENCH(bench_mov_register_symbolic__mov_absolute_register());
  BENCH(bench_mov_register_symbolic__mov_absolute_indexed());
  BENCH(bench_mov_register_symbolic__mov_absolute_symbolic());
  BENCH(bench_mov_register_symbolic__mov_absolute_absolute());
  BENCH(bench_mov_register_symbolic__mov_indirect_register());
  BENCH(bench_mov_register_symbolic__mov_indirect_indexed());
  BENCH(bench_mov_register_symbolic__mov_indirect_symbolic());
  BENCH(bench_mov_register_symbolic__mov_indirect_absolute());

  end_measurement_window();

  return 0;
}