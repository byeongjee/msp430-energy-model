#include "setup.h"

// Test hypothesis H1: Division/Modulo routine costs
//
// This benchmark measures energy consumption of division and modulo operations
// to verify whether the model correctly estimates their cost from constituent
// instructions.
//
// Key comparisons:
// - % 4 (power of 2) vs % 60 (non-power of 2)
// - / 3 (constant divisor) vs / n (variable divisor)
// - 16-bit vs 32-bit division

// Volatile to prevent optimization
static volatile uint16_t divisor_16 = 60;
static volatile uint32_t divisor_32 = 60;
static volatile uint16_t result_16;
static volatile uint32_t result_32;

// Simple counter for input values (avoids complex bit manipulation)
static volatile uint16_t counter = 0x1234;

INLINE uint16_t next_val(void) {
  counter += 0x1357;  // Simple increment with odd constant
  return counter;
}

// Baseline: no operation (just loop overhead)
INLINE void bench_baseline(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val;
  }
}

// Modulo by power of 2 (optimized to AND)
INLINE void bench_mod_4(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val % 4;
  }
}

// Modulo by non-power of 2 (requires software division)
INLINE void bench_mod_60(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val % 60;
  }
}

// Modulo by variable (prevents compile-time optimization)
INLINE void bench_mod_variable(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val % divisor_16;
  }
}

// Division by constant 3 (may use multiplication trick)
INLINE void bench_div_3(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val / 3;
  }
}

// Division by constant 60
INLINE void bench_div_60(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val / 60;
  }
}

// Division by variable
INLINE void bench_div_variable(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val / divisor_16;
  }
}

// Combined mod and div (common pattern: quotient and remainder)
INLINE void bench_divmod_60(void) {
  for (int i = 0; i < INNER_ITERS; i++) {
    uint16_t val = next_val();
    result_16 = val / 60;
    result_16 += val % 60;
  }
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_baseline());
  BENCH(bench_mod_4());
  BENCH(bench_mod_60());
  BENCH(bench_mod_variable());
  BENCH(bench_div_3());
  BENCH(bench_div_60());
  BENCH(bench_div_variable());
  BENCH(bench_divmod_60());

  end_measurement_window();

  return 0;
}
