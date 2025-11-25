// ===== file: bench_plateau.c =====
#include "setup.h"

// ---------------------------
// User tuning knobs
// ---------------------------

// MCLK in Hz (must match your clockSetup)
#ifndef MCLK_HZ
#define MCLK_HZ 16000000UL
#endif

// Plateau target in microseconds (flat top between guards)
#ifndef PLATEAU_US
#define PLATEAU_US 20000UL // 20 ms by default
#endif

// Guard band around plateau to avoid GPIO edge contamination
#ifndef GUARD_US
#define GUARD_US 150UL // 150 us settle on each side
#endif

// ---------------------------
// Utilities
// ---------------------------

static inline void delay_us() {
  // Good enough for guard bands; assumes 1 cycle per loop body here via
  // __delay_cycles
  __delay_cycles((uint32_t)((MCLK_HZ / 1000000UL) * GUARD_US));
}

// ---------------------------
// Repeat/unroll helpers
// ---------------------------

// Emit BODY N times (choose one UNROLL you like; 64 is a good default)
#define REP2(B) B B
#define REP4(B) REP2(B) REP2(B)
#define REP8(B) REP4(B) REP4(B)
#define REP16(B) REP8(B) REP8(B)
#define REP32(B) REP16(B) REP16(B)
#define REP64(B) REP32(B) REP32(B)
#define REP128(B) REP64(B) REP64(B)

// Choose your unroll factor here:
#ifndef UNROLL_FACTOR
#define UNROLL_FACTOR 64
#endif

#if UNROLL_FACTOR == 64
#define UNROLL(B) REP64(B)
#elif UNROLL_FACTOR == 128
#define UNROLL(B) REP128(B)
#elif UNROLL_FACTOR == 32
#define UNROLL(B) REP32(B)
#elif UNROLL_FACTOR == 16
#define UNROLL(B) REP16(B)
#else
#error "Unsupported UNROLL_FACTOR (choose 16, 32, 64, or 128)"
#endif

// ---------------------------
// Instruction block emitters
// ---------------------------
//
// Each TEST_BLOCK_* emits UNROLL_FACTOR copies of a single instruction pattern.
// You can create your own with one line by changing the asm string.
//
// IMPORTANT: Clobber list keeps registers "owned" by the block so the compiler
// won't reuse them across calls. That helps keep counts “pure”.

// 1) Core ALU: MOV r5, r6  (reg->reg)
static inline void TEST_BLOCK_MOV_RR(void) {
  __asm__ volatile(UNROLL("mov r5, r6\n\t") : : : "r5", "r6");
}

// 2) Core ALU: ADD #4, r7  (immediate via literal; compiler will encode using
// CG when possible)
static inline void TEST_BLOCK_ADD_IMM(void) {
  __asm__ volatile(UNROLL("add #4, r7\n\t") : : : "r7");
}

// 3) Memory load from SRAM: mov @r8, r9  (r8 points into SRAM buffer)
static inline void TEST_BLOCK_LOAD_SRAM(volatile uint16_t *ptr) {
  // Put ptr into r8 once; then repeatedly load from @r8+, or keep @r8 (choose
  // pattern) Here we use autoincrement to sweep memory (sequential access).
  __asm__ volatile("mov %[p], r8\n\t" UNROLL("mov @r8+, r9\n\t")
                   :
                   : [p] "r"(ptr)
                   : "r8", "r9", "memory");
}

// 4) Memory store to SRAM: mov r10, @r11+  (r11 points into SRAM buffer)
static inline void TEST_BLOCK_STORE_SRAM(volatile uint16_t *ptr, uint16_t val) {
  __asm__ volatile("mov %[p], r11\n\t"
                   "mov %[v], r10\n\t" UNROLL("mov r10, 0(r11)\n\t"
                                              "incd r11\n\t")
                   :
                   : [p] "r"(ptr), [v] "r"(val)
                   : "r10", "r11", "memory");
}

// 5) Branch not taken: jnz $+2  (force not-taken with Z=1 via cmp #0, r12)
static inline void TEST_BLOCK_BRANCH_NT(void) {
  __asm__ volatile("mov #0, r12\n\t" UNROLL("cmp #0, r12\n\t"
                                            "jnz 1f\n\t"
                                            "1:\n\t")
                   :
                   :
                   : "r12");
}

// 7) Baseline NOP body (same unroll/structure)
static inline void TEST_BLOCK_NOP(void) {
  __asm__ volatile(UNROLL("nop\n\t") : : :);
}

// ---------------------------
// Plateau runner
// ---------------------------
//
// We want: guard_up → plateau (repeat blocks) → guard_down
// Choose REPS so plateau time ≈ PLATEAU_US.
// If cycles/iter varies, we still get a clean plateau—you can compute actual
// time later from the GPIO edges captured in Otii.

// If you want to pre-compute an approximate trip count:
//   REPS ≈ PLATEAU_US * (MCLK_HZ / 1e6) / cycles_per_BLOCK
// where cycles_per_BLOCK ~ UNROLL_FACTOR * cycles_per_instruction + small
// epsilon. You can just hand-tune REPS by looking at Otii timing once.

#ifndef REPS
#define REPS 3000 // safe default; adjust after first capture to hit ~PLATEAU_US
#endif

// Wrapper macro to run a no-arg block
#define RUN_PLATEAU_BLOCK(block_fn)                                            \
  do {                                                                         \
    delay_us(GUARD_US);                                                        \
    begin_event();                                                             \
    for (volatile unsigned i = 0; i < REPS; ++i) {                             \
      block_fn();                                                              \
    }                                                                          \
    end_event();                                                               \
    delay_us(GUARD_US);                                                        \
  } while (0)

// Overloads for 1-arg and 2-arg blocks
#define RUN_PLATEAU_BLOCK_1(block_fn, arg1)                                    \
  do {                                                                         \
    delay_us(GUARD_US);                                                        \
    begin_event();                                                             \
    for (volatile unsigned i = 0; i < REPS; ++i) {                             \
      block_fn(arg1);                                                          \
    }                                                                          \
    end_event();                                                               \
    delay_us(GUARD_US);                                                        \
  } while (0)

#define RUN_PLATEAU_BLOCK_2(block_fn, a1, a2)                                  \
  do {                                                                         \
    delay_us(GUARD_US);                                                        \
    begin_event();                                                             \
    for (volatile unsigned i = 0; i < REPS; ++i) {                             \
      block_fn(a1, a2);                                                        \
    }                                                                          \
    end_event();                                                               \
    delay_us(GUARD_US);                                                        \
  } while (0)

// ---------------------------
// SRAM buffers for mem tests
// ---------------------------
#define BUF_WORDS (UNROLL_FACTOR * 8)
__attribute__((aligned(2))) static volatile uint16_t sram_src[BUF_WORDS];
__attribute__((aligned(2))) static volatile uint16_t sram_dst[BUF_WORDS];

// ---------------------------
// Main: run a few example plateaus
// ---------------------------

int main(void) {
  WDTCTL = WDTPW | WDTHOLD;
  initialize();

  // Warm up: baseline NOP
  RUN_PLATEAU_BLOCK(TEST_BLOCK_NOP);

  // 1) MOV r5,r6
  RUN_PLATEAU_BLOCK(TEST_BLOCK_MOV_RR);

  // 2) ADD #4, r7
  RUN_PLATEAU_BLOCK(TEST_BLOCK_ADD_IMM);

  // 3) LOAD SRAM: will sweep through sram_src (autoincrement)
  RUN_PLATEAU_BLOCK_1(TEST_BLOCK_LOAD_SRAM, sram_src);

  // 4) STORE SRAM: writes val=0x1234 across sram_dst (autoincrement)
  RUN_PLATEAU_BLOCK_2(TEST_BLOCK_STORE_SRAM, sram_dst, 0x1234);

  // 5) Branch NT
  RUN_PLATEAU_BLOCK(TEST_BLOCK_BRANCH_NT);

  // Idle forever
  for (;;) {
    __no_operation();
  }
  // return 0;
}