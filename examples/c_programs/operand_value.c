// operand_value_microbench.c  — MSP430FR5994
#include "setup.h"
#include <msp430.h>
#include <stdint.h>

/* ========= Tunables ========= */
#ifndef REPS_ADD
#define REPS_ADD 256 // ADD ops per iteration
#endif
#ifndef REPS_MPY
#define REPS_MPY 256 // MPY ops per iteration
#endif
#ifndef ITERS
#define ITERS 200 // loop iterations (outer loop)
#endif

/* ========= Helpers ========= */
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define NOINLINE __attribute__((noinline))

/* Make results observable so the compiler can’t DCE the loops */
volatile uint16_t sink_w;
volatile uint32_t sink_dw;

/* ========= ADD microbench =========
   We keep the per-op sequence identical in all cases:
     MOV  b -> R6
     ADD  a, R6
   That way, any delta is attributable to operand bits of the ADD itself.
*/
NOINLINE void bench_add(uint16_t a, uint16_t b, uint32_t iters) {
  register uint16_t out = 0;
  for (uint32_t i = 0; i < iters; ++i) {
    __asm__ volatile(
        ".rept " STR(
            REPS_ADD) "\n\t"
                      "  mov   %[B], r6          \n\t" /* right operand (dst
                                                          preload) */
                      "  add   %[A], r6          \n\t" /* left operand (src) */
                      ".endr                      \n\t"
                      "mov   r6, %[dst]          \n\t"
        : [dst] "=r"(out)
        : [A] "r"(a), [B] "r"(b)
        : "r6", "cc", "memory");
  }
  sink_w ^= out;
}

/* ========= MUL microbench (MPY32 peripheral) =========
   16×16 unsigned multiply using MPY/OP2 -> RESHI:RESLO.
   MPY32 is memory-mapped; writing OP2 triggers the multiply.
   Per-op sequence (constant across cases):
     MPY = a;   [once per iteration or keep in a register-like manner]
     OP2 = b;   [triggers multiply]
   To keep overhead identical across cases, we:
     - Write MPY once per iteration with 'a'
     - Then write OP2 REPS_MPY times with 'b'
   We optionally read RESLO to keep things observable.
*/
static inline void mpy_write_a(uint16_t a) { MPY = a; } // unsigned
static inline void mpy_write_b(uint16_t b) { OP2 = b; } // unsigned
static inline uint16_t mpy_read_lo(void) { return RESLO; }
static inline uint16_t mpy_read_hi(void) { return RESHI; }

NOINLINE void bench_mul_u16(uint16_t a, uint16_t b, uint32_t iters) {
  uint32_t acc = 0;
  for (uint32_t i = 0; i < iters; ++i) {
    mpy_write_a(a); /* set left operand once per iter */
    __asm__ volatile(
        ".rept " STR(
            REPS_MPY) "\n\t"
                      "  mov   %[B],  &OP2       \n\t" /* write b -> triggers
                                                          multiply */
                      ".endr                      \n\t"
        :
        : [B] "r"(b)
        : "memory");
    /* Touch results so compiler can’t elide the work */
    acc ^= ((uint32_t)mpy_read_hi() << 16) ^ mpy_read_lo();
  }
  sink_dw ^= acc;
}

/* ========= Main: 8 measurement windows =========
   ADD cases (A is left/src, B is right/dst preload):
     1) none zero:  A=0x1234, B=0xAAAA
     2) left zero:  A=0x0000, B=0xAAAA
     3) right zero: A=0x1234, B=0x0000
     4) both zero:  A=0x0000, B=0x0000
   MUL cases (same (A,B) sets) using MPY32.
*/
int main(void) {
  initialize(); /* your clock/GPIO setup */

  const uint16_t A_nz = 0x1234;
  const uint16_t B_nz = 0xAAAA;

  begin_measurement_window();

  /* ---------- ADD (4 cases) ---------- */
  begin_event();
  bench_add(A_nz, B_nz, ITERS);
  end_event(); /* none zero */
  begin_event();
  bench_add(0x0000, B_nz, ITERS);
  end_event(); /* left zero */
  begin_event();
  bench_add(A_nz, 0x0000, ITERS);
  end_event(); /* right zero */
  begin_event();
  bench_add(0x0000, 0x0000, ITERS);
  end_event(); /* both zero */

  /* ---------- MUL (4 cases, MPY32) ---------- */
  begin_event();
  bench_mul_u16(A_nz, B_nz, ITERS);
  end_event(); /* none zero */
  begin_event();
  bench_mul_u16(0x0000, B_nz, ITERS);
  end_event(); /* left zero */
  begin_event();
  bench_mul_u16(A_nz, 0x0000, ITERS);
  end_event(); /* right zero */
  begin_event();
  bench_mul_u16(0x0000, 0x0000, ITERS);
  end_event(); /* both zero */

  end_measurement_window();

  while (1) {
    __no_operation();
  }
}
