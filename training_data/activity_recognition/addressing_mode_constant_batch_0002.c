#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



INLINE void bench_sxt_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  sxt.w %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_mov_register_MPY(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &0x04C0\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_OP2(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &0x04C8\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_RESLO_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &0x04CA, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_register_MPY32L(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &0x04D0\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_MPY32H(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &0x04D2\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_OP2L(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &0x04E0\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_register_OP2H(void) {
  uint16_t src = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[src], &0x04E2\n"
      ".endr\n"
      : 
      : [src] "r"(src)
      : "cc", "memory"));
}

INLINE void bench_mov_RES0_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &0x04E4, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_mov_RES1_register(void) {
  uint16_t dst = 0x1234;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w &0x04E6, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc", "memory"));
}

INLINE void bench_rlam_immediate_2_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rlam #2, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_rrum_immediate_1_register(void) {
  uint16_t dst = 0x3333;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rrum #1, %[dst]\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_jmp_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jmp 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jge_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jge 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jl_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jl 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jnz_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jnz 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jz_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jz 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jnc_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jnc 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_jc_symbolic(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  jc 1f\n1:\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_dint(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  dint\n  nop\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_sxt_register());
  BENCH(bench_mov_register_MPY());
  BENCH(bench_mov_register_OP2());
  BENCH(bench_mov_RESLO_register());
  BENCH(bench_mov_register_MPY32L());
  BENCH(bench_mov_register_MPY32H());
  BENCH(bench_mov_register_OP2L());
  BENCH(bench_mov_register_OP2H());
  BENCH(bench_mov_RES0_register());
  BENCH(bench_mov_RES1_register());
  BENCH(bench_rlam_immediate_2_register());
  BENCH(bench_rrum_immediate_1_register());
  BENCH(bench_jmp_symbolic());
  BENCH(bench_jge_symbolic());
  BENCH(bench_jl_symbolic());
  BENCH(bench_jnz_symbolic());
  BENCH(bench_jz_symbolic());
  BENCH(bench_jnc_symbolic());
  BENCH(bench_jc_symbolic());
  BENCH(bench_dint());

  end_measurement_window();

  return 0;
}