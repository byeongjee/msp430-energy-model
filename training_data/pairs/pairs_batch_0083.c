#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_add_indexed_register__mov_register_indexed(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w %[src], %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_register_symbolic(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w %[src], sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_register_absolute(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w %[src], &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_immediate_register(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_immediate_indexed(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w #0x1357, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_immediate_symbolic(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w #0x1357, sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_immediate_absolute(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w #0x1357, &sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_indexed_register(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w %c[offs_src](%[base_src]), %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_indexed_indexed(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_add_indexed_register__mov_indexed_symbolic(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w %c[offs_src](%[base_src]), %[dst]\n"
      "  mov.w %c[offs_src](%[base_src]), sym_data\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_src] "r"(base_src), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_add_indexed_register__mov_register_indexed());
  BENCH(bench_add_indexed_register__mov_register_symbolic());
  BENCH(bench_add_indexed_register__mov_register_absolute());
  BENCH(bench_add_indexed_register__mov_immediate_register());
  BENCH(bench_add_indexed_register__mov_immediate_indexed());
  BENCH(bench_add_indexed_register__mov_immediate_symbolic());
  BENCH(bench_add_indexed_register__mov_immediate_absolute());
  BENCH(bench_add_indexed_register__mov_indexed_register());
  BENCH(bench_add_indexed_register__mov_indexed_indexed());
  BENCH(bench_add_indexed_register__mov_indexed_symbolic());

  end_measurement_window();

  return 0;
}