#include "setup.h" // expects initialize(), gpio_pin13_up(), end_event()

// ------- If you don't have setup.h, uncomment and use this minimal version
// ------- static inline void gpio_setup_marker(void) {
//   P1DIR |= BIT3;      // P1.3 as output marker
//   P1OUT &= ~BIT3;
// }
// static inline void gpio_pin13_up(void)   { P1OUT |=  BIT3; }
// static inline void end_event(void) { P1OUT &= ~BIT3; }
// static inline void clock_setup_16mhz(void) {
//   // FR5994 CS: set DCO ~16MHz, MCLK=DCO, SMCLK=DCO/1
//   CSCTL0_H = CSKEY_H;
//   CSCTL1 = DCOFSEL_4 | DCORSEL;        // DCO ~16MHz
//   CSCTL2 = SELM__DCOCLK | SELS__DCOCLK | SELA__REFOCLK;
//   CSCTL3 = DIVM__1 | DIVS__1 | DIVA__1;
//   CSCTL0_H = 0;
// }
// static inline void initialize(void) {
//   WDTCTL = WDTPW | WDTHOLD;
//   PM5CTL0 &= ~LOCKLPM5;
//   gpio_setup_marker();
//   clock_setup_16mhz();
// }
// -------------------------------------------------------------------------------

// Quick helpers to switch clock speed per segment (coarse, but effective)
static inline void set_mclk_1mhz(void) {
  CSCTL0_H = CSKEY_H;
  CSCTL1 = DCOFSEL_0; // ~1 MHz
  CSCTL2 = SELM__DCOCLK | SELS__DCOCLK | SELA__VLOCLK;
  CSCTL3 = DIVM__1 | DIVS__1 | DIVA__1;
  CSCTL0_H = 0;
}

static inline void set_mclk_8mhz(void) {
  CSCTL0_H = CSKEY_H;
  CSCTL1 = DCOFSEL_3; // ~8 MHz
  CSCTL2 = SELM__DCOCLK | SELS__DCOCLK | SELA__VLOCLK;
  CSCTL3 = DIVM__1 | DIVS__1 | DIVA__1;
  CSCTL0_H = 0;
}

static inline void set_mclk_16mhz(void) {
  CSCTL0_H = CSKEY_H;
  CSCTL1 = DCOFSEL_4 | DCORSEL; // ~16 MHz
  CSCTL2 = SELM__DCOCLK | SELS__DCOCLK | SELA__VLOCLK;
  CSCTL3 = DIVM__1 | DIVS__1 | DIVA__1;
  CSCTL0_H = 0;
}

// Buffers (volatile to block aggressive optimization)
#define N_SMALL 256
#define N_LARGE 1024
static volatile uint32_t buf_small[N_SMALL];
static volatile uint16_t buf_large[N_LARGE];

// Prevent inlining so each block is “solid”
__attribute__((noinline)) static void segment_compute_heavy(void) {
  set_mclk_16mhz();

  volatile uint32_t acc = 1u;
  for (uint16_t r = 0; r < 8; ++r) { // 8 * 512 iterations
    for (uint16_t i = 0; i < N_SMALL; ++i) {
      // Dense integer math, lots of ALU ops
      uint32_t x = (uint32_t)i + (r * 17u) + 3u;
      uint32_t y = (x * 1103515245u + 12345u) ^ acc;
      y = (y >> 3) + (y << 1);
      // avoid divide-by-zero; keep expensive / and % in
      uint32_t d = (x | 1u);
      acc = (acc + y) ^ (y / d) ^ (y % d);
      buf_small[i] = acc;
    }
  }

  // tie acc to memory so it's observable and not optimized away
  buf_small[0] = acc;
}

__attribute__((noinline)) static void segment_memory_stream(void) {
  set_mclk_8mhz();

  // RMW over a larger array to be bandwidth-bound
  for (uint16_t r = 0; r < 8; ++r) { // 8 * 4096 iterations
    for (uint16_t i = 0; i < N_LARGE; ++i) {
      uint16_t v = buf_large[i];
      v ^= (uint16_t)(i * 73u + r * 19u);
      v = (uint16_t)((v << 3) | (v >> 13));
      buf_large[i] = (uint16_t)(v + 0x1234u);
    }
  }
}

__attribute__((noinline)) static void segment_idleish_delay(void) {
  set_mclk_1mhz();

  // Long delays do burn cycles but with minimal memory traffic
  // Total cycles ~ 1e6–2e6 -> clear time/energy plateau at 1 MHz
  for (uint16_t k = 0; k < 64; ++k) {
    __delay_cycles(2000); // 2k cycles per chunk
  }
}

int main(void) {
  initialize(); // WDT off, GPIO ready, default clock OK

  // Warm-up to stabilize DCO/load before you start logging (optional)
  for (volatile uint32_t i = 0; i < 50000; ++i) {
    __no_operation();
  }

  // Repeat a few iterations to get a nice pattern in the trace
  for (uint16_t iter = 0; iter < 10; ++iter) {
    // A: compute-heavy @ 16 MHz
    begin_event();
    segment_compute_heavy();
    end_event();

    __delay_cycles(100);

    // B: memory stream @ 8 MHz
    begin_event();
    segment_memory_stream();
    end_event();

    __delay_cycles(100);

    // C: delay-dominant @ 1 MHz
    begin_event();
    segment_idleish_delay();
    end_event();
    __delay_cycles(100);
  }

  // Keep state visible
  volatile uint32_t sink = buf_small[0] + buf_large[0];
  (void)sink;

  return 0;
}
