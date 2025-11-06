#include "setup.h"

#define TEXTUAL_REPT 100

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define INLINE __attribute__((always_inline))

#define WSUF ".w"

static volatile uint16_t mem_buf[64] __attribute__((aligned(64)));
#define BASE_PTR ((uint16_t *)mem_buf) /* base for indexed addressing */
#define OFFS 4                         /* word-aligned offset for .w */

/* Interleaved: MOV (indexed->indexed) then ADD (1:1) */
INLINE void bench_mov_add_interleaved_idx_to_idx(void) {
  uint16_t *bsrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  register uint16_t acc asm("r7") = 0x1357;  /* accumulator for ADD */
  register uint16_t asrc asm("r8") = 0x2468; /* source for ADD */

  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  mov" WSUF " %c2(%0), %c3(%1)\n"
                                 "  add  r8, r7\n"
                                 "  add  r8, r7\n"
                                 "  add  r8, r7\n"
                                 "  add  r8, r7\n"
                                 ".endr\n" : : "r"(bsrc),
      "r"(bdst), "i"(OFFS), "i"(OFFS) : "cc", "memory"));
}

/* Blocked: first all MOVs, then the same number of ADDs */
INLINE void bench_mov_then_add_idx_to_idx(void) {
  uint16_t *bsrc = (uint16_t *)BASE_PTR;
  uint16_t *bdst = (uint16_t *)BASE_PTR;
  register uint16_t acc asm("r7") = 0x1357;
  register uint16_t asrc asm("r8") = 0x2468;

  /* MOV block (indexed->indexed) */
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
                                 "  mov" WSUF " %c2(%0), %c3(%1)\n"
                                 ".endr\n" : : "r"(bsrc),
      "r"(bdst), "i"(OFFS), "i"(OFFS) : "cc", "memory"));

  /* ADD block (same count as the MOVs above) */
  for (int i = 0; i < INNER_ITERS * 4; i++) {
    __asm__ volatile(".rept " STR(TEXTUAL_REPT) "\n"
                                                "  add  r8, r7\n"
                                                ".endr\n"
                     :
                     :
                     : "cc");
  }
  __asm__ volatile("" : : "r"(acc) : "memory");
}

int main(void) {
  initialize();

  begin_measurement_window();

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_mov_add_interleaved_idx_to_idx();
    end_event();
  }

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_mov_then_add_idx_to_idx();
    end_event();
  }

  end_measurement_window();
  return 0;
}
