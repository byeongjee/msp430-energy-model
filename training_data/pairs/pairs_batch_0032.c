#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_mov_indirect_auto_register__inc_indexed(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  inc.w %c[offs](%[base])\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__inc_symbolic(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  inc.w sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__inc_absolute(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  inc.w &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__rlam_immediate_1_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  rlam #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__rlam_immediate_2_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  rlam #2, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__rlam_immediate_3_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  rlam #3, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__rlam_immediate_4_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__jmp_symbolic(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indirect_auto_register__jge_symbolic(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w @%[psrc]+, %[dst]\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_cmp_register_register__cmp_immediate_register(void) {
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w %[src], %[dst]\n"
      "  cmp.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_indirect_auto_register__inc_indexed());
  BENCH(bench_mov_indirect_auto_register__inc_symbolic());
  BENCH(bench_mov_indirect_auto_register__inc_absolute());
  BENCH(bench_mov_indirect_auto_register__rlam_immediate_1_register());
  BENCH(bench_mov_indirect_auto_register__rlam_immediate_2_register());
  BENCH(bench_mov_indirect_auto_register__rlam_immediate_3_register());
  BENCH(bench_mov_indirect_auto_register__rlam_immediate_4_register());
  BENCH(bench_mov_indirect_auto_register__jmp_symbolic());
  BENCH(bench_mov_indirect_auto_register__jge_symbolic());
  BENCH(bench_cmp_register_register__cmp_immediate_register());

  end_measurement_window();

  return 0;
}