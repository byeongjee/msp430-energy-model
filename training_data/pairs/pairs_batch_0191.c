#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_add_indirect_symbolic__add_indirect_auto_register(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  add.w @%[psrc]+, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__add_indirect_auto_indexed(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  add.w @%[psrc]+, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__add_indirect_auto_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  add.w @%[psrc]+, sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__add_indirect_auto_absolute(void) {
  uint16_t* psrc = BASE_PTR;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  add.w @%[psrc]+, &sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__mov_register_register(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t src = 0x5678;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  mov.w %[src], %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__mov_register_indexed(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t src = 0x5678;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  mov.w %[src], %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__mov_register_symbolic(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  mov.w %[src], sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__mov_register_absolute(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  mov.w %[src], &sym_data\n"
      ".endr\n"
      : 
      : [psrc] "r"(psrc), [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__mov_immediate_register(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  mov.w #0x1357, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : [psrc] "r"(psrc)
      : "cc", "memory"));
}

INLINE void bench_add_indirect_symbolic__mov_immediate_indexed(void) {
  uint16_t* psrc = BASE_PTR;
  uint16_t* base_dst = BASE_PTR + 8;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  add.w @%[psrc], sym_data\n"
      "  mov.w #0x1357, %c[offs_dst](%[base_dst])\n"
      ".endr\n"
      : 
      : [base_dst] "r"(base_dst), [offs_dst] "i"(OFFS), [psrc] "r"(psrc)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_add_indirect_symbolic__add_indirect_auto_register());
  BENCH(bench_add_indirect_symbolic__add_indirect_auto_indexed());
  BENCH(bench_add_indirect_symbolic__add_indirect_auto_symbolic());
  BENCH(bench_add_indirect_symbolic__add_indirect_auto_absolute());
  BENCH(bench_add_indirect_symbolic__mov_register_register());
  BENCH(bench_add_indirect_symbolic__mov_register_indexed());
  BENCH(bench_add_indirect_symbolic__mov_register_symbolic());
  BENCH(bench_add_indirect_symbolic__mov_register_absolute());
  BENCH(bench_add_indirect_symbolic__mov_immediate_register());
  BENCH(bench_add_indirect_symbolic__mov_immediate_indexed());

  end_measurement_window();

  return 0;
}