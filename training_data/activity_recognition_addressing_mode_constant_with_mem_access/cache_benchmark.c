/**
 * Memory Access Benchmark (FRAM Cache + SRAM)
 *
 * This benchmark generates controlled memory access events for training energy
 * models. Code executes from SRAM to eliminate instruction fetch cache events,
 * isolating data access costs.
 *
 * MSP430FR5994 Cache Architecture (for FRAM only):
 * - 2-way set-associative cache
 * - 4 lines total (2 sets x 2 ways)
 * - 8 bytes per line
 * - Set index = (addr / 8) % 2
 * - SRAM has no cache (direct access)
 *
 * Benchmarks:
 * 1. fram_read_hit: Repeated FRAM reads to same location (mostly cache hits)
 * 2. fram_read_miss: FRAM reads to 3 conflicting addresses (all cache misses)
 * 3. fram_read_mixed: Mix of FRAM cache hits and misses for calibration
 * 4. sram_read: SRAM reads (no cache, used to isolate mov_indirect cost)
 */
#include "setup.h"

// ============================================================================
// FRAM Data Layout for Cache Control
// ============================================================================
// Addresses chosen to control cache set mapping:
// - Set 0: addresses where (addr / 8) % 2 == 0
// - Set 1: addresses where (addr / 8) % 2 == 1
//
// To guarantee misses: access 3+ addresses in the same set (2-way cache)
// The data array is aligned and sized to provide addresses in both sets.

// Single location for cache hit testing
static const volatile uint16_t fram_hit_target __attribute__((section(".rodata"))) = 0xCAFE;

// Array for cache miss testing - need addresses that map to same cache set
// Addresses spaced 16 bytes apart (CACHE_SET_STRIDE) to hit same set
static const volatile uint16_t fram_miss_data[48] __attribute__((section(".rodata"), aligned(16))) = {
    0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 0x8888,  // Set 0: offset 0
    0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 0x8888,  // Set 1: offset 16
    0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 0x8888,  // Set 0: offset 32
    0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 0x8888,  // Set 1: offset 48
    0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 0x8888,  // Set 0: offset 64
    0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 0x8888,  // Set 1: offset 80
};

// ============================================================================
// Benchmark 1: Cache Hit (repeated reads to same location)
// ============================================================================
// First read is a miss, subsequent reads are hits.
// Expected: ~99% hits with TEXTUAL_REPT=100
SRAM_CODE NOINLINE void bench_fram_read_hit(void) {
    register const volatile uint16_t* ptr = &fram_hit_target;
    register uint16_t val;

    REPEAT_INNER_ITERS(
        __asm__ volatile(
            ".rept " STR(TEXTUAL_REPT) "\n"
            "  mov.w @%[ptr], %[val]\n"
            ".endr\n"
            : [val] "=r"(val)
            : [ptr] "r"(ptr)
            : "memory"
        )
    );

    (void)val;
}

// ============================================================================
// Benchmark 2: Cache Miss (cycling through 3 conflicting addresses)
// ============================================================================
// Access pattern: A -> B -> C -> A -> B -> C -> ...
// With 2-way cache and 3 addresses in same set, every access is a miss.
// Addresses at offsets 0, 32, 64 bytes (all map to set 0 with 16-byte stride)
SRAM_CODE NOINLINE void bench_fram_read_miss(void) {
    // Three pointers to addresses in the same cache set
    // Offset 0, 16, 32 words = 0, 32, 64 bytes apart
    register const volatile uint16_t* ptr0 = &fram_miss_data[0];   // Set 0
    register const volatile uint16_t* ptr1 = &fram_miss_data[16];  // Set 0 (32 bytes later)
    register const volatile uint16_t* ptr2 = &fram_miss_data[32];  // Set 0 (64 bytes later)
    register uint16_t val;

    REPEAT_INNER_ITERS(
        __asm__ volatile(
            // Each iteration reads 3 conflicting addresses
            // Pattern: ptr0 -> ptr1 -> ptr2 (repeat)
            // This ensures cache eviction on every access
            ".rept " STR(TEXTUAL_REPT) " / 3\n"
            "  mov.w @%[p0], %[val]\n"
            "  mov.w @%[p1], %[val]\n"
            "  mov.w @%[p2], %[val]\n"
            ".endr\n"
            : [val] "=r"(val)
            : [p0] "r"(ptr0), [p1] "r"(ptr1), [p2] "r"(ptr2)
            : "memory"
        )
    );

    (void)val;
}

// ============================================================================
// Benchmark 3: Mixed Hits and Misses (50/50 ratio)
// ============================================================================
// Alternate between hitting cached data and causing misses.
// Pattern: read A twice (1 miss, 1 hit), then read B (1 miss), repeat
// This gives a known mix ratio for training.
SRAM_CODE NOINLINE void bench_fram_read_mixed(void) {
    register const volatile uint16_t* ptr0 = &fram_miss_data[0];   // Set 0
    register const volatile uint16_t* ptr1 = &fram_miss_data[16];  // Set 0
    register const volatile uint16_t* ptr2 = &fram_miss_data[32];  // Set 0
    register uint16_t val;

    REPEAT_INNER_ITERS(
        __asm__ volatile(
            // Pattern: A, A (miss, hit), B (miss), B (hit), C (miss), C (hit)
            // 3 misses + 3 hits per 6 reads = 50% hit rate
            ".rept " STR(TEXTUAL_REPT) " / 6\n"
            "  mov.w @%[p0], %[val]\n"
            "  mov.w @%[p0], %[val]\n"
            "  mov.w @%[p1], %[val]\n"
            "  mov.w @%[p1], %[val]\n"
            "  mov.w @%[p2], %[val]\n"
            "  mov.w @%[p2], %[val]\n"
            ".endr\n"
            : [val] "=r"(val)
            : [p0] "r"(ptr0), [p1] "r"(ptr1), [p2] "r"(ptr2)
            : "memory"
        )
    );

    (void)val;
}

int main(void) {
    initialize();
    begin_measurement_window();

    BENCH(bench_fram_read_hit());
    BENCH(bench_fram_read_miss());
    BENCH(bench_fram_read_mixed());

    end_measurement_window();
    return 0;
}
