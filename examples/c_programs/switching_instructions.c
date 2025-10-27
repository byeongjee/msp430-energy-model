#include "setup.h"

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

/* Loop knobs */
#ifndef INNER_ITERS
#define INNER_ITERS 40
#endif
#ifndef REPT_OPS
#define REPT_OPS 256
#endif

#define NOINLINE __attribute__((noinline))

/* =================== Kernel 1: interleaved (add; sub) =================== */
/* for j = 0 .. INNER_ITERS-1:
 *   .rept REPT_OPS: add r8→r6; sub r9→r7
 */
NOINLINE void add_sub_interleaved() {
  /* Pin variables to registers */
  register uint16_t acc_add asm("r6") = 0x1234;
  register uint16_t acc_sub asm("r7") = 0xFEDC;
  register uint16_t src_add asm("r8") = 0x0003;
  register uint16_t src_sub asm("r9") = 0x0002;

  for (uint32_t j = 0; j < INNER_ITERS; ++j) {
    __asm__ volatile(".rept " STR(REPT_OPS) " \n\t"
                                            "  add  r8, r6           \n\t"
                                            "  sub  r9, r7           \n\t"
                                            ".endr                   \n\t"
                     :
                     :
                     : "cc", "memory");
  }
}

/* =================== Kernel 2: blocked (adds then subs) ================== */
/* for j = 0 .. (INNER_ITERS/2)-1:
 *   .rept (REPT_OPS*2): add r8→r6
 * for j = 0 .. (INNER_ITERS/2)-1:
 *   .rept (REPT_OPS*2): sub r9→r7
 */
NOINLINE void add_then_sub_blocked() {
  register uint16_t acc_add asm("r6") = 0x0000;
  register uint16_t acc_sub asm("r7") = 0x8000;
  register uint16_t src_add asm("r8") = 0x0001;
  register uint16_t src_sub asm("r9") = 0x0001;

  for (uint32_t j = 0; j < (INNER_ITERS / 2); ++j) {
    __asm__ volatile(
        ".rept " STR(REPT_OPS * 2) " \n\t"
                                   "  add  r8, r6               \n\t"
                                   ".endr                       \n\t"
        :
        :
        : "cc", "memory");
  }
  /* Subs half */
  for (uint32_t j = 0; j < (INNER_ITERS / 2); ++j) {
    __asm__ volatile(
        ".rept " STR(REPT_OPS * 2) " \n\t"
                                   "  sub  r9, r7               \n\t"
                                   ".endr                       \n\t"
        :
        :
        : "cc", "memory");
  }
}

/* -------------------------------- Main -------------------------------- */
int main(void) {
  initialize();

  begin_measurement_window();

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    add_sub_interleaved();
    end_event();
  }

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    add_then_sub_blocked();
    end_event();
  }

  end_measurement_window();
  return 0;
}
