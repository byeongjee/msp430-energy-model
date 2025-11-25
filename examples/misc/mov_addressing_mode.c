#include "setup.h"
#include <stdint.h>

/* --- Stringify helper: STR(MOVS_PER_ITER) -> "256" --- */
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

volatile uint16_t sink;             // observable side effect
__attribute__((section(".data")))   // keep in RAM for consistent timing
volatile uint16_t abs_src = 0xABCD; // absolute-mode source target in RAM

#ifndef MOVS_PER_ITER
#define MOVS_PER_ITER 256
#endif

#define NOINLINE __attribute__((noinline))

NOINLINE void mov_src_register(uint16_t value, uint32_t iters) {
  register uint16_t dst;
  for (uint32_t i = 0; i < iters; ++i) {
    __asm__ volatile(
        ".rept " STR(MOVS_PER_ITER) "\n\t"
                                    "  mov  %[val], r6            \n\t"
                                    ".endr                         \n\t"
                                    "mov   r6, %[out]             \n\t"
        : [out] "=r"(dst)
        : [val] "r"(value)
        : "r6", "cc");
  }
  sink = dst;
}

/* Accept a volatile base to match your 'buf' definition */
NOINLINE void mov_src_indexed(volatile const uint16_t *base, uint32_t iters) {
  register uint16_t dst;
  for (uint32_t i = 0; i < iters; ++i) {
    __asm__ volatile(
        ".rept " STR(MOVS_PER_ITER) "\n\t"
                                    "  mov  2(%[bp]), r6          \n\t"
                                    ".endr                         \n\t"
                                    "mov   r6, %[out]             \n\t"
        : [out] "=r"(dst)
        : [bp] "r"(base)
        : "r6", "memory", "cc");
  }
  sink = dst;
}

NOINLINE void mov_src_absolute(uint32_t iters) {
  register uint16_t dst;
  for (uint32_t i = 0; i < iters; ++i) {
    __asm__ volatile(
        ".rept " STR(MOVS_PER_ITER) "\n\t"
                                    "  mov  &abs_src, r6          \n\t"
                                    ".endr                         \n\t"
                                    "mov   r6, %[out]             \n\t"
        : [out] "=r"(dst)
        : /* no inputs */
        : "r6", "memory", "cc");
  }
  sink = dst;
}

static volatile uint16_t buf[4]
    __attribute__((section(".data"))) = {0x1111, 0x2222, 0x3333, 0x4444};

int main(void) {
  initialize();
  const uint32_t iters = 100;

  begin_measurement_window();
  begin_event();
  mov_src_register(0x1357, iters);
  end_event();
  begin_event();
  mov_src_indexed(&buf[0], iters);
  end_event();
  begin_event();
  mov_src_absolute(iters);
  end_event();
  end_measurement_window();

  while (1) {
    __no_operation();
  }
}
