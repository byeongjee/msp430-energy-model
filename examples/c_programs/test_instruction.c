#include "gpio.h" // expects initialize(), gpio_pin13_up(), end_event()
#include <msp430.h>
#include <stdint.h>

// ------- If you don't have gpio.h, uncomment this minimal version -------
// static inline void gpio_setup_marker(void) {
//   P1DIR |= BIT3;      // P1.3 as output marker
//   P1OUT &= ~BIT3;
// }
// static inline void gpio_pin13_up(void)   { P1OUT |=  BIT3; }
// static inline void end_event(void) { P1OUT &= ~BIT3; }
// static inline void clock_setup_16mhz(void) {
//   CSCTL0_H = CSKEY_H;
//   CSCTL1   = DCOFSEL_4 | DCORSEL;            // DCO ~16 MHz
//   CSCTL2   = SELM__DCOCLK | SELS__DCOCLK | SELA__VLOCLK;
//   CSCTL3   = DIVM__1 | DIVS__1 | DIVA__1;
//   CSCTL0_H = 0;
// }
// static inline void initialize(void) {
//   WDTCTL = WDTPW | WDTHOLD;
//   PM5CTL0 &= ~LOCKLPM5;
//   gpio_setup_marker();
//   clock_setup_16mhz();                       // << fixed for entire run
// }
// -----------------------------------------------------------------------

// --- Buffers sized for ~8 KB RAM devices ---
// Total BSS ~3 KB; plenty of headroom for stack/ISRs.
#define N_SMALL 256  // 1 KB (uint32_t)
#define N_LARGE 1024 // 2 KB (uint16_t)
static volatile uint32_t buf_small[N_SMALL];
static volatile uint16_t buf_large[N_LARGE];

// Prevent inlining so each block is distinct & long-running
__attribute__((noinline)) static void segment_alu_dense(void) {
  // Pure ALU churn with minimal memory traffic.
  // Only one store per loop iteration to keep it compute-bound.
  volatile uint32_t a = 0x13579BDFu, b = 0x2468ACE0u, c = 0xdeadbeefu;
  for (uint16_t outer = 0; outer < 400; ++outer) { // 400 * 256 iterations
    for (uint16_t i = 0; i < N_SMALL; ++i) {
      // rotate/xor/add/sub/mix; no loads/stores from arrays here
      a = (a << 5) | (a >> (32 - 5));
      b ^= a + 0x9E3779B9u;
      c = (c ^ b) + (a ^ (c >> 3)) - 0x7F4A7C15u;
      a ^= (b >> 7);
      b ^= (c << 11);
      c ^= (a >> 13);
      // one store to keep the compiler honest
      buf_small[i] = a ^ b ^ c;
    }
  }
}

__attribute__((noinline)) static void segment_sram_stream(void) {
  // Memory-bound: heavy read–modify–write across SRAM.
  for (uint16_t outer = 0; outer < 200; ++outer) { // 200 * 1024 iterations
    for (uint16_t i = 0; i < N_LARGE; ++i) {
      uint16_t v = buf_large[i]; // load
      v ^= (uint16_t)(i * 73u + outer * 19u);
      v = (uint16_t)((v << 3) | (v >> 13));
      buf_large[i] = (uint16_t)(v + 0x1234u); // store
    }
  }
}

__attribute__((noinline)) static void segment_mpy_hotloop(void) {
  // Exercise the hardware multiplier (16x16) aggressively.
  // MPY/OP2 write triggers multiply; result in RESHI:RESLO.
  volatile uint32_t acc = 0;
  for (uint16_t outer = 0; outer < 400; ++outer) {
    for (uint16_t i = 1; i <= 256; ++i) {
      uint16_t x = (uint16_t)(outer + i * 17u);
      uint16_t y = (uint16_t)(0x1234u ^ (i * 29u));
      MPY = x; // unsigned multiply
      OP2 = y; // start operation
      uint32_t r = ((uint32_t)RESHI << 16) | RESLO;
      acc ^= r + (r >> 3); // keep BUSY toggling & consume result
    }
  }
  buf_small[0] = acc; // observable sink
}

int main(void) {
  initialize(); // WDT off, GPIO ready, MCLK fixed at 16 MHz

  // Warm-up (helps stabilize measurements)
  for (volatile uint32_t i = 0; i < 50000; ++i) {
    __no_operation();
  }

  for (uint16_t iter = 0; iter < 3; ++iter) {
    // A: ALU-dense @ 16 MHz (compute-bound)
    begin_event();
    segment_alu_dense();
    end_event();

    __delay_cycles(10000);

    // B: SRAM-stream @ 16 MHz (memory-bound)
    begin_event();
    segment_sram_stream();
    end_event();

    __delay_cycles(10000);

    // C: MPY hot loop @ 16 MHz (peripheral activity + some memory)
    begin_event();
    segment_mpy_hotloop();
    end_event();

    __delay_cycles(10000);
  }

  volatile uint32_t sink = buf_small[0] + buf_large[0];
  (void)sink;
  return 0;
}
