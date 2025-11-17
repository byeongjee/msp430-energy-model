#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_mov_absolute_symbolic__rlam_immediate_3_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, sym_data\n"
      "  rlam #3, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_symbolic__rlam_immediate_4_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, sym_data\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_symbolic__jmp_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, sym_data\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_symbolic__jge_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, sym_data\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_absolute__mov_indirect_register(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, &sym_data\n"
      "  mov.w @%[psrc], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_absolute__mov_indirect_indexed(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, &sym_data\n"
      "  mov.w @%[psrc], %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_absolute__mov_indirect_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, &sym_data\n"
      "  mov.w @%[psrc], sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_absolute__mov_indirect_absolute(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, &sym_data\n"
      "  mov.w @%[psrc], &sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_absolute__mov_indirect_auto_register(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, &sym_data\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_absolute_absolute__mov_indirect_auto_indexed(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &sym_data, &sym_data\n"
      "  mov.w @%[psrc]+, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_absolute_symbolic__rlam_immediate_3_register());
  BENCH(bench_mov_absolute_symbolic__rlam_immediate_4_register());
  BENCH(bench_mov_absolute_symbolic__jmp_symbolic());
  BENCH(bench_mov_absolute_symbolic__jge_symbolic());
  BENCH(bench_mov_absolute_absolute__mov_indirect_register());
  BENCH(bench_mov_absolute_absolute__mov_indirect_indexed());
  BENCH(bench_mov_absolute_absolute__mov_indirect_symbolic());
  BENCH(bench_mov_absolute_absolute__mov_indirect_absolute());
  BENCH(bench_mov_absolute_absolute__mov_indirect_auto_register());
  BENCH(bench_mov_absolute_absolute__mov_indirect_auto_indexed());

  end_measurement_window();

  return 0;
}