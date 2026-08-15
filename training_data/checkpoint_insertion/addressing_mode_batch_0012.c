#include "setup.h"

#if defined(__GNUC__)
#undef REPEAT_INNER_ITERS
#define REPEAT_INNER_ITERS(X)                                                  \
  _Pragma("GCC unroll 0")                                                      \
  for (int _rep_inner_ = 0; _rep_inner_ < (INNER_ITERS); ++_rep_inner_) {      \
    X;                                                                         \
  }
#endif

static volatile uint16_t sym_data = 0x1111;
static volatile uint16_t mem_buf[1024] __attribute__((aligned(64)));

#define BASE_PTR ((uint16_t *)mem_buf)
#define OFFS 4



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


  BENCH(bench_call_and_ret());
  BENCH(bench_push_and_reti());
  BENCH(bench_push_and_pop());

  end_measurement_window();

  return 0;
}