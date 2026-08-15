#include "setup.h"
#include <string.h>

// Benchmark for memcpy and memset with varying byte sizes.
// Used to infer the linear cost model: cost = intercept + slope * bytes
//
// Each event calls memcpy or memset MEMCPY_MEMSET_INNER_ITERS times with a
// fixed byte count.
// The interpreter emits two feature events per call:
//   - (memcpy,) with feature_value=1.0 (intercept)
//   - (memcpy, bytes) with feature_value=N (slope)
// Varying byte sizes across events lets the solver separate intercept from slope.
//
// Keep this benchmark heavier than the global INNER_ITERS default so short
// memcpy/memset calls remain measurable even when the general benchmark suite is
// tuned down.

#ifndef MEMCPY_MEMSET_INNER_ITERS
#define MEMCPY_MEMSET_INNER_ITERS 100
#endif

static volatile uint8_t src_buf[32];
static volatile uint8_t dst_buf[32];

INLINE void init_buffers(void) {
  for (int i = 0; i < 32; i++) {
    ((uint8_t *)src_buf)[i] = (uint8_t)(i + 1);
  }
}

// --- memcpy benchmarks ---

INLINE void bench_memcpy_1(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memcpy((void *)dst_buf, (const void *)src_buf, 1);
  }
}

INLINE void bench_memcpy_2(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memcpy((void *)dst_buf, (const void *)src_buf, 2);
  }
}

INLINE void bench_memcpy_4(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memcpy((void *)dst_buf, (const void *)src_buf, 4);
  }
}

INLINE void bench_memcpy_8(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memcpy((void *)dst_buf, (const void *)src_buf, 8);
  }
}

INLINE void bench_memcpy_16(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memcpy((void *)dst_buf, (const void *)src_buf, 16);
  }
}

INLINE void bench_memcpy_32(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memcpy((void *)dst_buf, (const void *)src_buf, 32);
  }
}

// --- memset benchmarks ---

INLINE void bench_memset_1(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memset((void *)dst_buf, 0xAA, 1);
  }
}

INLINE void bench_memset_2(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memset((void *)dst_buf, 0xAA, 2);
  }
}

INLINE void bench_memset_4(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memset((void *)dst_buf, 0xAA, 4);
  }
}

INLINE void bench_memset_8(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memset((void *)dst_buf, 0xAA, 8);
  }
}

INLINE void bench_memset_16(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memset((void *)dst_buf, 0xAA, 16);
  }
}

INLINE void bench_memset_32(void) {
  for (int i = 0; i < MEMCPY_MEMSET_INNER_ITERS; i++) {
    memset((void *)dst_buf, 0xAA, 32);
  }
}

int main(void) {
  initialize();
  init_buffers();
  begin_measurement_window();

  BENCH(bench_memcpy_1());
  BENCH(bench_memcpy_2());
  BENCH(bench_memcpy_4());
  BENCH(bench_memcpy_8());
  BENCH(bench_memcpy_16());
  BENCH(bench_memcpy_32());

  BENCH(bench_memset_1());
  BENCH(bench_memset_2());
  BENCH(bench_memset_4());
  BENCH(bench_memset_8());
  BENCH(bench_memset_16());
  BENCH(bench_memset_32());

  end_measurement_window();

  return 0;
}
