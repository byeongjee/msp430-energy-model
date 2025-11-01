// training program for simple energy model
// with opcode-level modularity
#include "setup.h"

#define INNER_ITERS 30

/* ---------- helpers ---------- */
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define NOINLINE __attribute__((noinline))

/* ---------- knobs: inner unrolls (per outer iter) ---------- */
#ifndef REPS_ADD
#define REPS_ADD 256
#endif
#ifndef REPS_CMP
#define REPS_CMP 256
#endif
#ifndef REPS_INC
#define REPS_INC 256
#endif
#ifndef REPS_RLAM
#define REPS_RLAM 64
#endif
#ifndef REPS_JGE_BODY
#define REPS_JGE_BODY 128 /* JGE executed this many times per outer iter */
#endif
#ifndef REPS_JMP_BODY
#define REPS_JMP_BODY 256 /* JMP executed this many times per outer iter */
#endif
#ifndef REPS_MOV_PAIRS
#define REPS_MOV_PAIRS 128 /* (reg MOV + indirect MOV) pairs per outer iter */
#endif

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

/* ---------- 3) inc ---------- */
NOINLINE void bench_inc() {
  register uint16_t x = 0x0000;
  for (uint32_t i = 0; i < INNER_ITERS; ++i) {
    __asm__ volatile(
        ".rept " STR(
            REPS_INC) "\n\t"
                      "  inc  %[v]              \n\t" /* assembler emits ADD
                                                         #1,dst */
                      ".endr                    \n\t"
        : [v] "+r"(x)
        :
        : "cc");
  }
}

NOINLINE void bench_rlam() {
  register uint16_t x = 0x0001;
  for (uint32_t i = 0; i < INNER_ITERS; ++i) {
    __asm__ volatile(".rept " STR(REPS_RLAM) "\n\t"
                                             "  rlam  #1, %0          \n\t"
                                             "  rlam  #2, %0          \n\t"
                                             "  rlam  #3, %0          \n\t"
                                             "  rlam  #4, %0          \n\t"
                                             ".endr                   \n\t"
                     : "+r"(x)
                     :
                     : "cc");
  }
}

/* ---------- 5) jge (finite taken branches per outer iter) ---------- */
/* Per outer iteration, execute JGE exactly REPS_JGE_BODY times (taken),
   then one not-taken to exit that inner counted loop. */
NOINLINE void bench_jge() {
  for (uint32_t i = 0; i < INNER_ITERS; ++i) {
    register uint16_t c = REPS_JGE_BODY;
    __asm__ volatile(
        "1:                         \n\t"
        "  dec  %[cnt]              \n\t"
        "  cmp  #0, %[cnt]          \n\t"
        "  jge  1b                  \n\t" /* taken REPS_JGE_BODY times */
        : [cnt] "+r"(c)
        :
        : "cc");
  }
}

/* ---------- 6) jmp (finite chain of jumps per outer iter) ---------- */
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

/* ---------- 7) mov (alternate reg and indirect) ---------- */
NOINLINE void bench_mov_alt() {
  register uint16_t src_reg = 0xBEEF;
  volatile const uint16_t *p = 0x0164;
  register uint16_t dst;
  for (uint32_t i = 0; i < INNER_ITERS; ++i) {
    __asm__ volatile(
        ".rept " STR(
            REPS_MOV_PAIRS) "\n\t"
                            "  mov  %[sr], r6            \n\t" /* register
                                                                  source */
                            "  mov  @%[pp], r6           \n\t" /* indirect
                                                                  source (no
                                                                  autoinc) */
                            ".endr                       \n\t"
                            "  mov  r6, %[out]           \n\t"
        : [out] "=r"(dst)
        : [sr] "r"(src_reg), [pp] "r"(p)
        : "r6", "memory", "cc");
  }
}

/* ---------- main: one event per instruction family ---------- */
int main(void) {
  initialize();

  begin_measurement_window();

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_mov_alt();
    end_event();
  }

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_add();
    end_event();
  }

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_rlam();
    end_event();
  }

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_jge();
    end_event();
  }

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_jmp();
    end_event();
  }

  end_measurement_window();

  return 0;
}
