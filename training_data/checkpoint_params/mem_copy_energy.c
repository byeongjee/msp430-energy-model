/*
 * Memory Copy Energy Benchmark
 *
 * Measures per-byte energy cost of copying between SRAM and FRAM
 * for checkpoint store (SRAM->FRAM) and restore (FRAM->SRAM).
 *
 * Each benchmark copies N bytes using word-sized moves, repeated
 * INNER_ITERS times per BENCH event. Linear regression of measured
 * energy vs copy size gives the per-byte cost (slope).
 *
 * Sizes tested: 2, 8, 32, 64, 128, 256 bytes
 *
 * Post-processing:
 *   For each direction (store/restore), collect (size_bytes, energy_nJ) pairs.
 *   Per-byte cost = slope of linear regression energy_nJ vs size_bytes,
 *   divided by INNER_ITERS.
 *   Intercept absorbs per-call overhead (function call, loop control).
 */

#include "setup.h"

/* SRAM buffer (placed in .bss -> RAM by linker) */
static volatile uint16_t sram_buf[128] __attribute__((aligned(16)));

/*
 * FRAM data region: 0xF000-0xF0FF (256 bytes)
 * Well above typical code placement, within FRAM (0x4000-0xFF7F).
 * Verify no overlap with: msp430-elf-nm -n <binary>
 */
#define FRAM_DATA ((volatile uint16_t *)0xF000u)

/* ---------- Helper macros ---------- */

#define DEFINE_STORE_BENCH(suffix, nwords)                                     \
  NOINLINE void bench_store_##suffix(void) {                                   \
    volatile uint16_t *src = sram_buf;                                         \
    volatile uint16_t *dst = FRAM_DATA;                                        \
    REPEAT_INNER_ITERS({                                                       \
      for (int _i = 0; _i < (nwords); _i++) {                                 \
        dst[_i] = src[_i];                                                     \
      }                                                                        \
    });                                                                        \
  }

#define DEFINE_RESTORE_BENCH(suffix, nwords)                                   \
  NOINLINE void bench_restore_##suffix(void) {                                 \
    volatile uint16_t *src = FRAM_DATA;                                        \
    volatile uint16_t *dst = sram_buf;                                         \
    REPEAT_INNER_ITERS({                                                       \
      for (int _i = 0; _i < (nwords); _i++) {                                 \
        dst[_i] = src[_i];                                                     \
      }                                                                        \
    });                                                                        \
  }

/* ---------- Store benchmarks: SRAM -> FRAM ---------- */

DEFINE_STORE_BENCH(2, 1)     /*   2 bytes =   1 word  */
DEFINE_STORE_BENCH(8, 4)     /*   8 bytes =   4 words */
DEFINE_STORE_BENCH(32, 16)   /*  32 bytes =  16 words */
DEFINE_STORE_BENCH(64, 32)   /*  64 bytes =  32 words */
DEFINE_STORE_BENCH(128, 64)  /* 128 bytes =  64 words */
DEFINE_STORE_BENCH(256, 128) /* 256 bytes = 128 words */

/* ---------- Restore benchmarks: FRAM -> SRAM ---------- */

DEFINE_RESTORE_BENCH(2, 1)     /*   2 bytes =   1 word  */
DEFINE_RESTORE_BENCH(8, 4)     /*   8 bytes =   4 words */
DEFINE_RESTORE_BENCH(32, 16)   /*  32 bytes =  16 words */
DEFINE_RESTORE_BENCH(64, 32)   /*  64 bytes =  32 words */
DEFINE_RESTORE_BENCH(128, 64)  /* 128 bytes =  64 words */
DEFINE_RESTORE_BENCH(256, 128) /* 256 bytes = 128 words */

int main(void) {
  initialize();
  begin_measurement_window();

  /* Store: SRAM -> FRAM (checkpoint save) */
  BENCH(bench_store_2());
  BENCH(bench_store_8());
  BENCH(bench_store_32());
  BENCH(bench_store_64());
  BENCH(bench_store_128());
  BENCH(bench_store_256());

  /* Restore: FRAM -> SRAM (checkpoint restore) */
  BENCH(bench_restore_2());
  BENCH(bench_restore_8());
  BENCH(bench_restore_32());
  BENCH(bench_restore_64());
  BENCH(bench_restore_128());
  BENCH(bench_restore_256());

  end_measurement_window();

  return 0;
}
