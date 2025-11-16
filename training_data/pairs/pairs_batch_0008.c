#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_add_indexed_register__inc_absolute(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs](%[base]), %[dst]\n"
      "  inc.w &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__rlam_immediate_1_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs](%[base]), %[dst]\n"
      "  rlam #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__rlam_immediate_2_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs](%[base]), %[dst]\n"
      "  rlam #2, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__rlam_immediate_3_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs](%[base]), %[dst]\n"
      "  rlam #3, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__rlam_immediate_4_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs](%[base]), %[dst]\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__jmp_symbolic(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs](%[base]), %[dst]\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__jge_symbolic(void) {
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs](%[base]), %[dst]\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_symbolic_register__add_absolute_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w sym_data, %[dst]\n"
      "  add.w &sym_data, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_add_symbolic_register__add_indirect_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w sym_data, %[dst]\n"
      "  add.w @%[psrc], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_symbolic_register__add_indirect_auto_register(void) {
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w sym_data, %[dst]\n"
      "  add.w @%[psrc]+, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_add_indexed_register__inc_absolute());
  BENCH(bench_add_indexed_register__rlam_immediate_1_register());
  BENCH(bench_add_indexed_register__rlam_immediate_2_register());
  BENCH(bench_add_indexed_register__rlam_immediate_3_register());
  BENCH(bench_add_indexed_register__rlam_immediate_4_register());
  BENCH(bench_add_indexed_register__jmp_symbolic());
  BENCH(bench_add_indexed_register__jge_symbolic());
  BENCH(bench_add_symbolic_register__add_absolute_register());
  BENCH(bench_add_symbolic_register__add_indirect_register());
  BENCH(bench_add_symbolic_register__add_indirect_auto_register());

  end_measurement_window();

  return 0;
}