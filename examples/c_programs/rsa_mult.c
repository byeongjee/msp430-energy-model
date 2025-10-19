// task_mult() in the RSA application
// https://github.com/CMUAbstract/app-rsa-chain/blob/updated-libchain-api/src/main.c

// I chose this because it seems to be the most computationally intensive task
// in the RSA program that should run without energy depletion.
#include "setup.h"

// ===================== Configuration =====================
#ifndef NUM_ITER
#define NUM_ITER 100
#endif

#ifndef KEY_SIZE_BITS
#define KEY_SIZE_BITS 128
#endif

#define DIGIT_BITS 8
#define DIGIT_MASK 0x00FFu
#define NUM_DIGITS (KEY_SIZE_BITS / DIGIT_BITS)
// =========================================================

// Type large enough to hold a product of two digits
typedef uint16_t digit_t;

// Test vectors (in RAM). We keep product 2*n bytes, like the libchain version.
static uint8_t A[NUM_DIGITS];
static uint8_t B[NUM_DIGITS];
static uint8_t product[2 * NUM_DIGITS];

// Volatile sink to keep the compiler from optimizing the loop away
static volatile uint32_t energy_bench_sink = 0;

// Simple xorshift PRNG to perturb inputs per iteration (fast, tiny)
static uint32_t xorshift32(uint32_t *state) {
  uint32_t x = *state;
  x ^= x << 13;
  x ^= x >> 17;
  x ^= x << 5;
  *state = x;
  return x;
}

// Fill A,B with pseudo-random but deterministic data (LSB-first digits)
static void fill_operands(uint32_t seed_base) {
  uint32_t s = seed_base | 1u; // avoid zero state
  for (unsigned i = 0; i < NUM_DIGITS; ++i) {
    A[i] = (uint8_t)(xorshift32(&s) & 0xFF);
    B[i] = (uint8_t)(xorshift32(&s) & 0xFF);
  }
}

// ============ The multiply core (schoolbook convolution) ============
// This mirrors your task_mult’s arithmetic but without channels/self-state.
// For each output digit j in [0, 2n), it accumulates products A[j-i]*B[i]
// where indices are in range, with 8-bit radix and 16-bit partials.
static void task_mult(void) {
  digit_t carry = 0;

  for (int j = 0; j < (int)(2 * NUM_DIGITS); ++j) {
    digit_t p = carry; // low part accumulator (plus incoming carry)
    digit_t c = 0;     // high part accumulator

    // Restrict inner range so we can drop the bounds check inside the loop
    int i_min = (j >= (int)(NUM_DIGITS - 1)) ? (j - ((int)NUM_DIGITS - 1)) : 0;
    int i_max = (j < (int)NUM_DIGITS) ? j : ((int)NUM_DIGITS - 1);

    for (int i = i_min; i <= i_max; ++i) {
      // indices are in range by construction:
      //   a_idx = j - i ∈ [0, NUM_DIGITS-1], b_idx = i ∈ [0, NUM_DIGITS-1]
      digit_t a = (digit_t)A[(unsigned)(j - i)];
      digit_t b = (digit_t)B[(unsigned)i];
      digit_t dp = (digit_t)(a * b); // 8x8→16

      c += (digit_t)(dp >> DIGIT_BITS); // high byte
      p += (digit_t)(dp & DIGIT_MASK);  // low byte
    }

    // Fold overflow from p into c, and emit the current output digit (base 256)
    c += (digit_t)(p >> DIGIT_BITS);
    product[(unsigned)j] = (uint8_t)(p & DIGIT_MASK);

    carry = c; // carry to next output digit
  }
}

#ifdef DEBUG
#ifndef PREVIEW_BYTES
// show everything
#define PREVIEW_BYTES (2 * NUM_DIGITS)
#endif
// Pretty-print helpers (hex previews)
static void print_hex_preview(const char *label, const uint8_t *buf,
                              unsigned len) {
  unsigned show = (len < PREVIEW_BYTES) ? len : PREVIEW_BYTES;
  printf("%s[%u]:", label, len);
  for (unsigned i = 0; i < show; ++i)
    printf(" %02x", buf[i]);
  if (len > show)
    printf(" ...");
  // Also show tail preview
  if (len > show) {
    printf(" | tail:");
    for (unsigned i = len - show; i < len; ++i)
      printf(" %02x", buf[i]);
  }
  printf("\r\n");
}
#endif

// Optional: checksum to force materialization of results in RAM
static uint32_t checksum_product(void) {
  uint32_t acc = 0;
  for (unsigned i = 0; i < 2 * NUM_DIGITS; ++i) {
    acc = (acc << 5) ^ (acc >> 27) ^ product[i];
  }
  return acc;
}

int main(void) {
  initialize();

#ifdef DEBUG
  printf("[mult-bench] NUM_ITER=%d  KEY_SIZE_BITS=%d  NUM_DIGITS=%d  "
         "DIGIT_BITS=%d\r\n",
         NUM_ITER, KEY_SIZE_BITS, NUM_DIGITS, DIGIT_BITS);
#endif

  // Seed test inputs once; mutate per iteration to avoid identical work
  // patterns
  fill_operands(0xC0FFEEu);

#ifdef DEBUG
  print_hex_preview("A init ", A, NUM_DIGITS);
  print_hex_preview("B init ", B, NUM_DIGITS);
#endif

  begin_measurement_window();

  for (int iter = 0; iter < NUM_ITER; ++iter) {
    // Vary operands a bit each round to avoid constant-propagation/strength
    // reduction while keeping memory layout identical (important for fair
    // energy measurement). This work is outside the event so you measure the
    // multiply itself.
    uint32_t seed = 0x12345678u + (uint32_t)iter;
    A[(unsigned)(iter % NUM_DIGITS)] ^= (uint8_t)(seed & 0xFF);
    B[(unsigned)((iter * 7) % NUM_DIGITS)] += (uint8_t)((seed >> 8) & 0x1F);

    begin_event();

    task_mult();

    end_event();

    // Prevent DCE: fold result into a volatile sink outside the event window
    // We don't need this as we use -O0 optimization
    // energy_bench_sink ^= checksum_product();
  }

  end_measurement_window();

#ifdef DEBUG
  printf("[mult-bench] Final energy_bench_sink=%08lx\r\n",
         (unsigned long)energy_bench_sink);
  print_hex_preview("A final", A, NUM_DIGITS);
  print_hex_preview("B final", B, NUM_DIGITS);
  print_hex_preview("P final", product, 2 * NUM_DIGITS);
#endif

  // Use the sink so the compiler keeps it; harmless read
  if (energy_bench_sink == 0xFFFFFFFFu) {
    // unreachable in practice; keeps the dependency
    __no_operation();
  }

  return 0;
}
