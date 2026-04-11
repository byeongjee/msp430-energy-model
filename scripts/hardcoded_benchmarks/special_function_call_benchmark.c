/**
 * Special Function Call Benchmark
 *
 * Generates benchmarks for MSP430 ABI function calls:
 * - __mspabi_divi: signed 16-bit division
 * - __mspabi_divli: signed 32-bit division
 * - __mspabi_divu: unsigned 16-bit division
 * - __mspabi_mpyi: signed 16-bit multiplication
 * - __mspabi_mpyl: signed 32-bit multiplication
 * - __mspabi_remu: unsigned 16-bit remainder
 *
 * IMPORTANT: This file MUST be compiled with -mhwmult=none to prevent
 * GCC from inlining multiplication to hardware multiplier registers.
 * The gen_benchmarks.py script handles this automatically.
 */
#include "setup.h"

/* Volatile sinks to prevent dead-code elimination */
static volatile uint16_t sink16;
static volatile uint32_t sink32;

/*
 * Keep special-call event pulses comfortably above the measurement/export
 * resolution. The global INNER_ITERS default is tuned for generated batches,
 * but these helper calls need a larger runtime loop to avoid dropped segments.
 */
#ifndef SPECIAL_FUNCTION_CALL_INNER_ITERS
#define SPECIAL_FUNCTION_CALL_INNER_ITERS 100
#endif

#define REPEAT_SPECIAL_FUNCTION_INNER_ITERS(X)                                 \
    for (int _rep_special_call_ = 0;                                           \
         _rep_special_call_ < (SPECIAL_FUNCTION_CALL_INNER_ITERS);             \
         ++_rep_special_call_) {                                               \
        X;                                                                     \
    }

/*
 * __mspabi_divu: unsigned 16-bit division (a / b)
 *
 * Worst-case inputs: dividend=0xFFFF, divisor=1.
 * The software implementation uses shift-and-subtract with two phases:
 *   Phase 1 (alignment): left-shifts the divisor until it exceeds the dividend.
 *     divisor=1 requires the maximum 16 left-shifts before reaching 0x8000.
 *   Phase 2 (subtraction): conditionally subtracts at each bit position,
 *     running once per alignment shift = 16 iterations.
 * Total: 32 loop iterations (16 + 16), the maximum possible.
 */
INLINE void bench_call___mspabi_divu(void) {
    volatile uint16_t a = 0xFFFF;
    volatile uint16_t b = 1;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink16 = a / b);
}

/*
 * __mspabi_divi: signed 16-bit division (a / b)
 *
 * Use a large-magnitude dividend while avoiding the INT16_MIN / -1 overflow
 * edge case. The volatile inputs keep the call visible in the generated code.
 */
INLINE void bench_call___mspabi_divi(void) {
    volatile int16_t a = -32767;
    volatile int16_t b = 1;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink16 = (uint16_t)(a / b));
}

/*
 * __mspabi_divli: signed 32-bit division (a / b)
 *
 * This mirrors the signed 16-bit case with 32-bit operands so the compiler
 * emits the long-division helper instead of inlining arithmetic.
 */
INLINE void bench_call___mspabi_divli(void) {
    volatile int32_t a = 2147483647;
    volatile int32_t b = 1;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink32 = (uint32_t)(a / b));
}

/*
 * __mspabi_mpyi: signed 16-bit multiplication (a * b)
 *
 * Worst-case inputs: a=0xFFFF (-1), b=0xFFFF (-1).
 * The software implementation uses shift-and-add: it loops while b != 0,
 * right-shifting b each iteration. With all 16 bits set, b requires all
 * 16 right-shifts before reaching zero (no early exit). All-ones in a
 * ensures every conditional rv += a executes, maximizing work per iteration.
 */
INLINE void bench_call___mspabi_mpyi(void) {
    volatile int16_t a = -1;
    volatile int16_t b = -1;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink16 = (uint16_t)(a * b));
}

/*
 * __mspabi_mpyl: signed 32-bit multiplication (a * b)
 *
 * Worst-case inputs: a=0xFFFFFFFF (-1), b=0xFFFFFFFF (-1).
 * Same shift-and-add algorithm as __mspabi_mpyi but with 32-bit operands.
 * All 32 bits set in b forces the full 32 loop iterations with no early
 * exit, and all-ones in a makes every conditional addition execute.
 */
INLINE void bench_call___mspabi_mpyl(void) {
    volatile int32_t a = -1;
    volatile int32_t b = -1;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink32 = (uint32_t)(a * b));
}

/*
 * __mspabi_remu: unsigned 16-bit remainder (a % b)
 *
 * Remainder uses the same divider family as unsigned division, so large inputs
 * and a divisor of 1 keep the benchmark on the slow software path.
 */
INLINE void bench_call___mspabi_remu(void) {
    volatile uint16_t a = 0xFFFF;
    volatile uint16_t b = 1;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink16 = a % b);
}

int main(void) {
    initialize();
    begin_measurement_window();

    BENCH(bench_call___mspabi_divu());
    BENCH(bench_call___mspabi_divi());
    BENCH(bench_call___mspabi_divli());
    BENCH(bench_call___mspabi_mpyi());
    BENCH(bench_call___mspabi_mpyl());
    BENCH(bench_call___mspabi_remu());

    end_measurement_window();
    return 0;
}
