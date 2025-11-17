#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_cmp_absolute_register__rlam_immediate_2_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %[dst]\n"
      "  rlam #2, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_register__rlam_immediate_3_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %[dst]\n"
      "  rlam #3, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_register__rlam_immediate_4_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %[dst]\n"
      "  rlam #4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_register__jmp_symbolic(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %[dst]\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_register__jge_symbolic(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %[dst]\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_indexed__cmp_absolute_symbolic(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %c[offs_dst](%[base_dst])\n"
      "  cmp.w &sym_data, sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_indexed__cmp_absolute_absolute(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %c[offs_dst](%[base_dst])\n"
      "  cmp.w &sym_data, &sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_indexed__cmp_indirect_register(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_indexed__cmp_indirect_indexed(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc], %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_cmp_absolute_indexed__cmp_indirect_symbolic(void) {
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  cmp.w &sym_data, %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc], sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_cmp_absolute_register__rlam_immediate_2_register());
  BENCH(bench_cmp_absolute_register__rlam_immediate_3_register());
  BENCH(bench_cmp_absolute_register__rlam_immediate_4_register());
  BENCH(bench_cmp_absolute_register__jmp_symbolic());
  BENCH(bench_cmp_absolute_register__jge_symbolic());
  BENCH(bench_cmp_absolute_indexed__cmp_absolute_symbolic());
  BENCH(bench_cmp_absolute_indexed__cmp_absolute_absolute());
  BENCH(bench_cmp_absolute_indexed__cmp_indirect_register());
  BENCH(bench_cmp_absolute_indexed__cmp_indirect_indexed());
  BENCH(bench_cmp_absolute_indexed__cmp_indirect_symbolic());

  end_measurement_window();

  return 0;
}