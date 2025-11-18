#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_add_absolute_absolute__jl_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w &sym_data, &sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_add_indirect_register__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_indexed__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], %c[offs_dst](%[base_dst])\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_absolute__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], &sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_auto_register__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc]+, %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_auto_indexed__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc]+, %c[offs_dst](%[base_dst])\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_auto_symbolic__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc]+, sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_auto_absolute__jl_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc]+, &sym_data\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__jl_symbolic(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_add_absolute_absolute__jl_symbolic());
  BENCH(bench_add_indirect_register__jl_symbolic());
  BENCH(bench_add_indirect_indexed__jl_symbolic());
  BENCH(bench_add_indirect_symbolic__jl_symbolic());
  BENCH(bench_add_indirect_absolute__jl_symbolic());
  BENCH(bench_add_indirect_auto_register__jl_symbolic());
  BENCH(bench_add_indirect_auto_indexed__jl_symbolic());
  BENCH(bench_add_indirect_auto_symbolic__jl_symbolic());
  BENCH(bench_add_indirect_auto_absolute__jl_symbolic());
  BENCH(bench_mov_register_register__jl_symbolic());

  end_measurement_window();

  return 0;
}