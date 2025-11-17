#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_rlam_immediate_1_register__rlam_immediate_2_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #1, %[dst]\n"
      "  rlam #2, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_1_register__rlam_immediate_3_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #1, %[dst]\n"
      "  rlam #3, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_1_register__rlam_immediate_4_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #1, %[dst]\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_1_register__jmp_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #1, %[dst]\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_1_register__jge_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #1, %[dst]\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_2_register__rlam_immediate_3_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #2, %[dst]\n"
      "  rlam #3, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_2_register__rlam_immediate_4_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #2, %[dst]\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_2_register__jmp_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #2, %[dst]\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_2_register__jge_symbolic(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #2, %[dst]\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rlam_immediate_3_register__rlam_immediate_4_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #3, %[dst]\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_rlam_immediate_1_register__rlam_immediate_2_register());
  BENCH(bench_rlam_immediate_1_register__rlam_immediate_3_register());
  BENCH(bench_rlam_immediate_1_register__rlam_immediate_4_register());
  BENCH(bench_rlam_immediate_1_register__jmp_symbolic());
  BENCH(bench_rlam_immediate_1_register__jge_symbolic());
  BENCH(bench_rlam_immediate_2_register__rlam_immediate_3_register());
  BENCH(bench_rlam_immediate_2_register__rlam_immediate_4_register());
  BENCH(bench_rlam_immediate_2_register__jmp_symbolic());
  BENCH(bench_rlam_immediate_2_register__jge_symbolic());
  BENCH(bench_rlam_immediate_3_register__rlam_immediate_4_register());

  end_measurement_window();

  return 0;
}