// cache_hit.c  — MSP430FR5994 FRAM cache hit/miss microbench
#include "setup.h"
#include <msp430.h>
#include <stdint.h>

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#ifndef CACHE_REPS
#define CACHE_REPS 128
#endif

#define NOINLINE __attribute__((noinline))

/* -------------------- Observable sink -------------------- */
volatile uint16_t sink;

/* -------------------- FRAM-resident lines for cache tests --------------------
 * We want three addresses in the SAME cache set (2-way set-assoc, 64-bit
 * lines). Use 16-byte spacing so bit A3 (set index) stays the same. Align to 16
 * bytes.
 */
__attribute__((aligned(16))) const volatile uint16_t fram_space[48] = {
    0x1111, 0x2222, 0x3333, 0x4444, // line 0 (A)
    0,      0,      0,      0,
    0x5555, 0x6666, 0x7777, 0x8888, // line 1 (B)  +16 bytes from A
    0,      0,      0,      0,
    0x9999, 0xAAAA, 0xBBBB, 0xCCCC, // line 2 (C)  +32 bytes from A
    0,      0,      0,      0};

/* Pointers into fram_space:
 * A = &fram_space[0], B = &fram_space[8], C = &fram_space[16]
 * (Each “line” = 4 words = 8 bytes; we space by 8 words = 16 bytes.)
 */
static inline volatile const uint16_t *FR_A(void) { return &fram_space[0]; }
static inline volatile const uint16_t *FR_B(void) { return &fram_space[8]; }
static inline volatile const uint16_t *FR_C(void) { return &fram_space[16]; }

/* -------------------- FRAM cache microbenches (data reads)
 * -------------------- */
/* All-hit (data): after warm-up, repeatedly read two lines in the SAME set.
 */
NOINLINE void fram_all_hit(volatile const uint16_t *pA,
                           volatile const uint16_t *pB, uint32_t iters) {
  register uint16_t dst = 0;

  /* Warm-up: touch both lines so they are in cache */
  dst ^= *pA;
  dst ^= *pB;

  for (uint32_t i = 0; i < iters; ++i) {
    __asm__ volatile(
        ".rept " STR(CACHE_REPS) "\n\t"
                                 "  mov  0(%[pa]), r6         \n\t" // A
                                 "  mov  0(%[pb]), r6         \n\t" // B
                                 ".endr                        \n\t"
                                 "mov   r6, %[out]            \n\t"
        : [out] "=r"(dst)
        : [pa] "r"(pA), [pb] "r"(pB)
        : "r6", "memory", "cc");
  }
  sink = dst;
}

/* All-miss (data): thrash a single set with three lines in the SAME set.
 * Sequence A,B,C,A,B,C,... forces each access to miss in a 2-way cache.
 */
NOINLINE void fram_all_miss(volatile const uint16_t *pA,
                            volatile const uint16_t *pB,
                            volatile const uint16_t *pC, uint32_t iters) {
  register uint16_t dst = 0;
  (void)pA;
  (void)pB;
  (void)pC; // silence unused warnings if optimized away

  for (uint32_t i = 0; i < iters; ++i) {
    __asm__ volatile(
        ".rept " STR(CACHE_REPS) "\n\t"
                                 "  mov  0(%[pa]), r6         \n\t" // A
                                 "  mov  0(%[pb]), r6         \n\t" // B
                                 "  mov  0(%[pc]), r6         \n\t" // C
                                 ".endr                        \n\t"
                                 "mov   r6, %[out]            \n\t"
        : [out] "=r"(dst)
        : [pa] "r"(pA), [pb] "r"(pB), [pc] "r"(pC)
        : "r6", "memory", "cc");
  }
  sink = dst;
}

/* -------------------- Main: measurement windows -------------------- */
int main(void) {
  initialize();

  const uint32_t iters_cache = 200; // each iteration does CACHE_REPS loads

  begin_measurement_window();

  /* FRAM cache — ALL-HIT (data) */
  begin_event();
  fram_all_hit(FR_A(), FR_B(), iters_cache);
  end_event();

  /* FRAM cache — ALL-MISS (data) */
  begin_event();
  fram_all_miss(FR_A(), FR_B(), FR_C(), iters_cache);
  end_event();

  end_measurement_window();

  while (1) {
    __no_operation();
  }
}
