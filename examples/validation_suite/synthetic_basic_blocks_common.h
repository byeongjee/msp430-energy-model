#ifndef VALIDATION_SUITE_SYNTHETIC_BASIC_BLOCKS_COMMON_H
#define VALIDATION_SUITE_SYNTHETIC_BASIC_BLOCKS_COMMON_H

#ifndef NUM_REPEAT
#define NUM_REPEAT 12
#endif

#ifndef INNER_ITERS
#define INNER_ITERS 64
#endif

#ifndef TEXTUAL_REPT
#define TEXTUAL_REPT 32
#endif

#include "setup.h"
#include <stdint.h>

/*
 * Four synthetic basic blocks for validating mean_per_addressing_mode.
 *
 * Repetition happens in two layers:
 * - .rept TEXTUAL_REPT duplicates the exact block textually
 * - REPEAT_INNER_ITERS reruns that duplicated block in C
 *
 * The pointer-walk block resets its stream pointers on each outer iteration so
 * the SRAM footprint stays proportional to TEXTUAL_REPT instead of
 * INNER_ITERS * TEXTUAL_REPT.
 */

static volatile uint16_t sram_src_word = 0x1111;
static volatile uint16_t sram_dst_word = 0x0000;
static volatile uint16_t sram_stream_a[TEXTUAL_REPT] __attribute__((aligned(64)));
static volatile uint16_t sram_stream_b[TEXTUAL_REPT] __attribute__((aligned(64)));
static volatile uint16_t sink = 0x0000;

static inline void seed_validation_data(void) {
  for (unsigned i = 0; i < TEXTUAL_REPT; ++i) {
    sram_stream_a[i] = (uint16_t)(0x0010u + i);
    sram_stream_b[i] = (uint16_t)(0x0100u + i);
  }

  sram_src_word = 0x1111;
  sram_dst_word = 0x0000;
  sink = 0x0000;
}

INLINE void bench_register_only(void) {
  REPEAT_INNER_ITERS(do {
    uint16_t src = 0x1234;
    uint16_t step = 0x0003;
    uint16_t expected = (uint16_t)(src + step);
    uint16_t dst = 0x0000;

    __asm__ volatile(
        ".rept " STR(TEXTUAL_REPT) "\n"
        "  mov.w %[src], %[dst]\n"
        "  add.w %[step], %[dst]\n"
        "  cmp.w %[expected], %[dst]\n"
        "  jnz 1f\n"
        "1:\n"
        ".endr\n"
        : [dst] "+r"(dst)
        : [src] "r"(src), [step] "r"(step), [expected] "r"(expected)
        : "cc");

    sink = dst;
  } while (0));
}

INLINE void bench_load_compute(void) {
  REPEAT_INNER_ITERS(do {
    uint16_t *base_src = (uint16_t *)&sram_src_word;
    uint16_t dst = 0x0000;

    __asm__ volatile(
        ".rept " STR(TEXTUAL_REPT) "\n"
        "  mov.w 0(%[base_src]), %[dst]\n"
        "  add.w #3, %[dst]\n"
        "  cmp.w #0x1114, %[dst]\n"
        "  jnz 1f\n"
        "1:\n"
        ".endr\n"
        : [dst] "+r"(dst)
        : [base_src] "r"(base_src)
        : "cc", "memory");

    sink = dst;
  } while (0));
}

INLINE void bench_load_compute_store(void) {
  REPEAT_INNER_ITERS(do {
    uint16_t *base_src = (uint16_t *)&sram_src_word;
    uint16_t *base_dst = (uint16_t *)&sram_dst_word;
    uint16_t addend = 0x2222;
    uint16_t tmp = 0x0000;

    __asm__ volatile(
        ".rept " STR(TEXTUAL_REPT) "\n"
        "  mov.w 0(%[base_src]), %[tmp]\n"
        "  add.w %[addend], %[tmp]\n"
        "  mov.w %[tmp], 0(%[base_dst])\n"
        "  cmp.w #0x3333, %[tmp]\n"
        ".endr\n"
        : [tmp] "+r"(tmp)
        : [base_src] "r"(base_src), [base_dst] "r"(base_dst), [addend] "r"(addend)
        : "cc", "memory");

    sink = tmp;
  } while (0));
}

INLINE void bench_pointer_walk(void) {
  REPEAT_INNER_ITERS(do {
    uint16_t *stream_a = (uint16_t *)sram_stream_a;
    uint16_t *stream_b = (uint16_t *)sram_stream_b;
    uint16_t acc = 0x4000;
    uint16_t tmp0;
    uint16_t tmp1;

    __asm__ volatile(
        ".rept " STR(TEXTUAL_REPT) "\n"
        "  mov.w @%[stream_a]+, %[tmp0]\n"
        "  mov.w @%[stream_b]+, %[tmp1]\n"
        "  add.w %[tmp0], %[acc]\n"
        "  cmp.w #0x4000, %[acc]\n"
        ".endr\n"
        : [stream_a] "+r"(stream_a), [stream_b] "+r"(stream_b), [acc] "+r"(acc),
          [tmp0] "=&r"(tmp0), [tmp1] "=&r"(tmp1)
        :
        : "cc", "memory");

    sink = (uint16_t)(acc + tmp1);
  } while (0));
}

#endif
