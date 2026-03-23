/*
 * NVM Access Penalty Benchmark
 *
 * Measures per-access energy for SRAM vs FRAM reads and writes.
 *
 * nvm_access_penalty = max(|fram_read - sram_read|, |fram_write - sram_write|)
 *
 * Read benchmarks: 3 reads per .rept iteration.
 *   - SRAM: 3 reads from nearby SRAM addresses (no cache involvement)
 *   - FRAM: 3 reads from addresses 0, 16, 32 bytes apart, all mapping to
 *     cache set 0 (set stride = 16 bytes). With 2-way associativity, cycling
 *     3 addresses in the same set guarantees 100% cache miss rate.
 *
 * Write benchmarks: 1 write per .rept iteration.
 *   - SRAM: direct write (no cache)
 *   - FRAM: uncached write (FRAM writes always bypass/invalidate cache)
 *
 * Post-processing:
 *   reads_per_event  = INNER_ITERS * TEXTUAL_REPT * 3
 *   writes_per_event = INNER_ITERS * TEXTUAL_REPT
 *   per_access_nJ    = event_energy_nJ / accesses_per_event
 */

#include "setup.h"

/* SRAM buffer (placed in .bss -> RAM by linker) */
static volatile uint16_t sram_buf[64] __attribute__((aligned(16)));

/*
 * FRAM data region: 0xF000-0xF03F
 * Well above typical code placement (starts at 0x4000), within FRAM
 * (0x4000-0xFF7F). Verify no overlap with: msp430-elf-nm -n <binary>
 */
#define FRAM_DATA ((volatile uint16_t *)0xF000u)

/* ---------- Read benchmarks ---------- */

/*
 * SRAM read: 3 reads from SRAM per .rept iteration.
 * All reads are to nearby addresses; SRAM has no cache, so all are direct.
 */
INLINE void bench_sram_read(void) {
  volatile uint16_t *p = sram_buf;
  uint16_t sink;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w 0(%[p]), %[sink]\n"
      "  mov.w 2(%[p]), %[sink]\n"
      "  mov.w 4(%[p]), %[sink]\n"
      ".endr\n"
      : [sink] "=r"(sink)
      : [p] "r"(p)
      : "cc", "memory"));
}

/*
 * FRAM read (worst case: 100% cache misses).
 * Three addresses at offsets 0, 16, 32 from base all map to cache set 0
 * (cache line = 8 bytes, 2 sets, set index = (addr/8) % 2).
 * With 2-way associativity, the 3rd address evicts the 1st on every cycle,
 * so every single access is a compulsory or conflict miss.
 */
INLINE void bench_fram_read_miss(void) {
  volatile uint16_t *p = FRAM_DATA;
  uint16_t sink;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w 0(%[p]), %[sink]\n"
      "  mov.w 16(%[p]), %[sink]\n"
      "  mov.w 32(%[p]), %[sink]\n"
      ".endr\n"
      : [sink] "=r"(sink)
      : [p] "r"(p)
      : "cc", "memory"));
}

/* ---------- Write benchmarks ---------- */

/*
 * SRAM write: repeated writes to SRAM. No cache involvement.
 */
INLINE void bench_sram_write(void) {
  volatile uint16_t *p = sram_buf;
  uint16_t val = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[val], 0(%[p])\n"
      ".endr\n"
      :
      : [val] "r"(val), [p] "r"(p)
      : "cc", "memory"));
}

/*
 * FRAM write: repeated writes to FRAM.
 * FRAM writes are always uncached (they invalidate the corresponding cache
 * line), so this is inherently worst-case.
 */
INLINE void bench_fram_write(void) {
  volatile uint16_t *p = FRAM_DATA;
  uint16_t val = 0x5678;
  REPEAT_INNER_ITERS(__asm__ volatile(
      ".rept " STR(TEXTUAL_REPT) "\n"
      "  mov.w %[val], 0(%[p])\n"
      ".endr\n"
      :
      : [val] "r"(val), [p] "r"(p)
      : "cc", "memory"));
}

int main(void) {
  initialize();
  begin_measurement_window();

  BENCH(bench_sram_read());
  BENCH(bench_fram_read_miss());
  BENCH(bench_sram_write());
  BENCH(bench_fram_write());

  end_measurement_window();

  return 0;
}
