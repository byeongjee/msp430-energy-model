#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_mov_register_register__cmp_indirect_absolute(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  cmp.w @%[psrc], &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__cmp_indirect_auto_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  cmp.w @%[psrc]+, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__cmp_indirect_auto_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  cmp.w @%[psrc]+, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__cmp_indirect_auto_symbolic(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  cmp.w @%[psrc]+, sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__cmp_indirect_auto_absolute(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  cmp.w @%[psrc]+, &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__inc_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  inc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

INLINE void bench_mov_register_register__inc_indexed(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  inc.w %c[offs](%[base])\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base] "r"(base), [offs] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__inc_symbolic(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  inc.w sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__inc_absolute(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  inc.w &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_register__rlam_immediate_1_register(void) {
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], %[dst]\n"
      "  rlam #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [src] "r"(src)
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_register_register__cmp_indirect_absolute());
  BENCH(bench_mov_register_register__cmp_indirect_auto_register());
  BENCH(bench_mov_register_register__cmp_indirect_auto_indexed());
  BENCH(bench_mov_register_register__cmp_indirect_auto_symbolic());
  BENCH(bench_mov_register_register__cmp_indirect_auto_absolute());
  BENCH(bench_mov_register_register__inc_register());
  BENCH(bench_mov_register_register__inc_indexed());
  BENCH(bench_mov_register_register__inc_symbolic());
  BENCH(bench_mov_register_register__inc_absolute());
  BENCH(bench_mov_register_register__rlam_immediate_1_register());

  end_measurement_window();

  return 0;
}