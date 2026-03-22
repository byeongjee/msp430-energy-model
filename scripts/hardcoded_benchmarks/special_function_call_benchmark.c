/**
 * Special Function Call Benchmark
 *
 * Generates benchmarks for MSP430 ABI function calls:
 * - __mspabi_divu: unsigned 16-bit division
 * - __mspabi_mpyi: signed 16-bit multiplication
 * - __mspabi_mpyl: signed 32-bit multiplication
 *
 * IMPORTANT: This file MUST be compiled with -mhwmult=none to prevent
 * GCC from inlining multiplication to hardware multiplier registers.
 * The gen_benchmarks.py script handles this automatically.
 */
#include "setup.h"

/* Volatile sinks to prevent dead-code elimination */
static volatile uint16_t sink16;
static volatile uint32_t sink32;

/* __mspabi_divu: unsigned 16-bit division (a / b) */
INLINE void bench_call___mspabi_divu(void) {
    volatile uint16_t a = 1000;
    volatile uint16_t b = 7;
    REPEAT_INNER_ITERS(sink16 = a / b);
}

/* __mspabi_mpyi: signed 16-bit multiplication (a * b) */
INLINE void bench_call___mspabi_mpyi(void) {
    volatile int16_t a = 123;
    volatile int16_t b = 45;
    REPEAT_INNER_ITERS(sink16 = (uint16_t)(a * b));
}

/* __mspabi_mpyl: signed 32-bit multiplication (a * b) */
INLINE void bench_call___mspabi_mpyl(void) {
    volatile int32_t a = 12345;
    volatile int32_t b = 67;
    REPEAT_INNER_ITERS(sink32 = (uint32_t)(a * b));
}

int main(void) {
    initialize();
    begin_measurement_window();

    BENCH(bench_call___mspabi_divu());
    BENCH(bench_call___mspabi_mpyi());
    BENCH(bench_call___mspabi_mpyl());

    end_measurement_window();
    return 0;
}
