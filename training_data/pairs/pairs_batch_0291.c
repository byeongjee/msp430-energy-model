#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_mov_indexed_indexed__cmp_indirect_absolute(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc], &sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__cmp_indirect_auto_register(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc]+, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__cmp_indirect_auto_indexed(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc]+, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__cmp_indirect_auto_symbolic(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc]+, sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__cmp_indirect_auto_absolute(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  cmp.w @%[psrc]+, &sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__inc_register(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  inc.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__inc_indexed(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t* base = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  inc.w %c[offs](%[base])\n"
      ".endr\n"
      : 
      : [base] "r"(base), [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs] "i"(OFFS), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__inc_symbolic(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  inc.w sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__inc_absolute(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  inc.w &sym_data\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

INLINE void bench_mov_indexed_indexed__rlam_immediate_1_register(void) {
  uint16_t* base_src = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %c[offs_src](%[base_src]), %c[offs_dst](%[base_dst])\n"
      "  rlam #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [base_dst] "r"(base_dst), [base_src] "r"(base_src), [offs_dst] "i"(OFFS), [offs_src] "i"(OFFS)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_mov_indexed_indexed__cmp_indirect_absolute());
  BENCH(bench_mov_indexed_indexed__cmp_indirect_auto_register());
  BENCH(bench_mov_indexed_indexed__cmp_indirect_auto_indexed());
  BENCH(bench_mov_indexed_indexed__cmp_indirect_auto_symbolic());
  BENCH(bench_mov_indexed_indexed__cmp_indirect_auto_absolute());
  BENCH(bench_mov_indexed_indexed__inc_register());
  BENCH(bench_mov_indexed_indexed__inc_indexed());
  BENCH(bench_mov_indexed_indexed__inc_symbolic());
  BENCH(bench_mov_indexed_indexed__inc_absolute());
  BENCH(bench_mov_indexed_indexed__rlam_immediate_1_register());

  end_measurement_window();

  return 0;
}