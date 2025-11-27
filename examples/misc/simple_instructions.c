#include "setup.h"

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#ifndef REPS_ADD
#define REPS_ADD 100
#endif
#ifndef REPS_CMP
#define REPS_CMP 100
#endif
#ifndef REPS_INC
#define REPS_INC 100
#endif
#ifndef REPS_RLA
#define REPS_RLA 100
#endif
#ifndef REPS_JGE_BODY
#define REPS_JGE_BODY 128 /* JGE executed this many times per outer iter */
#endif
#ifndef REPS_JMP_BODY
#define REPS_JMP_BODY 100 /* JMP executed this many times per outer iter */
#endif
#ifndef REPS_MOV_PAIRS
#define REPS_MOV_PAIRS 128 /* (reg MOV + indirect MOV) pairs per outer iter */
#endif

/* ---------- knobs: outer loop count per bench ---------- */
#ifndef OUTER_ITERS
#define OUTER_ITERS 100
#endif

#ifndef INNER_ITERS
#define INNER_ITERS 10
#endif

#define NOINLINE __attribute__((noinline))

// change this to run other benchmarks
#define RUN_ADD 1

#ifdef RUN_ADD
NOINLINE void bench_add() {
  register uint16_t acc = 0x1111;
  register uint16_t src = 0x2222;
  for (uint32_t i = 0; i < INNER_ITERS; ++i) {
    __asm__ volatile(".rept " STR(REPS_ADD) "\n\t"
                                            "  add  %[s], %[a]        \n\t"
                                            ".endr                    \n\t"
                     : [a] "+r"(acc)
                     : [s] "r"(src)
                     : "cc");
  }
}
#endif

#ifdef RUN_CMP
NOINLINE void bench_cmp() {
  register uint16_t dst = 0xAAAA;
  register uint16_t src = 0x5555;
  for (uint32_t i = 0; i < INNER_ITERS; ++i) {
    __asm__ volatile(".rept " STR(REPS_CMP) "\n\t"
                                            "  cmp  %[s], %[d]        \n\t"
                                            ".endr                    \n\t"
                     : [d] "+r"(dst)
                     : [s] "r"(src)
                     : "cc");
  }
}
#endif

#ifdef RUN_JMP
NOINLINE void bench_jmp() {
  for (uint32_t i = 0; i < INNER_ITERS; ++i) {
    __asm__ volatile(
        ".rept " STR(REPS_JMP_BODY) "\n\t"
                                    "  jmp  1f                 \n\t"
                                    "1:                        \n\t"
                                    ".endr                     \n\t"
        :
        :
        : "cc");
  }
}
#endif

/* -------------------- Main: measurement windows -------------------- */
int main(void) {
  initialize();

  begin_measurement_window();

#ifdef RUN_ADD
  for (int i = 0; i < OUTER_ITERS; i++) {
    begin_event();
    bench_add();
    end_event();
  }
#endif

#ifdef RUN_CMP
  for (int i = 0; i < OUTER_ITERS; i++) {
    begin_event();
    bench_cmp();
    end_event();
  }
#endif

#ifdef RUN_MOV
  for (int i = 0; i < OUTER_ITERS; i++) {
    begin_event();
    // mov
    end_event();
  }
#endif

#ifdef RUN_JMP
  for (int i = 0; i < OUTER_ITERS; i++) {
    begin_event();
    // jmp
    bench_jmp();
    end_event();
  }
#endif

  end_measurement_window();

  return 0;
}
