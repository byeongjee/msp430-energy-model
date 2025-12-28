#include "setup.h"

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



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

INLINE void bench_nop(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  nop\n"
      ".endr\n"
      : 
      : 
      : "cc"));
}

INLINE void bench_rpt_5_rrux_register(void) {
  uint16_t dst = 0x2222;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  rpt #5 { rrux.w %[dst] }\n"
      ".endr\n"
      : [dst] "+r"(dst)
      : 
      : "cc"));
}

INLINE void bench_call_and_ret(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  call #bench_empty_function\n"
      ".endr\n"
      : 
      : 
      : "cc", "memory"));
}


INLINE void bench_push_and_reti(void) {
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  call #bench_empty_interrupt\n"
      ".endr\n"
      :
      :
      : "cc", "memory"));
}


INLINE void bench_push_and_pop(void) {
  uint16_t val = 0x1234;
  uint16_t result;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  push.w %[val]\n"
      "  pop.w %[result]\n"
      ".endr\n"
      : [result] "=r"(result)
      : [val] "r"(val)
      : "cc", "memory"));
}


int main(void) {
  initialize();
  begin_measurement_window();


  BENCH(bench_rrum_immediate_1_register());
  BENCH(bench_jmp_symbolic());
  BENCH(bench_jge_symbolic());
  BENCH(bench_jnz_symbolic());
  BENCH(bench_jz_symbolic());
  BENCH(bench_jnc_symbolic());
  BENCH(bench_jc_symbolic());
  BENCH(bench_dint());
  BENCH(bench_nop());
  BENCH(bench_rpt_5_rrux_register());
  BENCH(bench_call_and_ret());
  BENCH(bench_push_and_reti());
  BENCH(bench_push_and_pop());

  end_measurement_window();

  return 0;
}