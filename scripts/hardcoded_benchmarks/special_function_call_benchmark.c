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
 * - __mspabi_remul: unsigned 32-bit remainder
 * - __mspabi_mpyll: 64-bit multiplication
 * - __mspabi_addd: double-precision addition
 * - __mspabi_subd: double-precision subtraction
 * - __mspabi_mpyd: double-precision multiplication
 * - __mspabi_divd: double-precision division
 * - __mspabi_addf: single-precision addition
 * - __mspabi_mpyf: single-precision multiplication
 * - __mspabi_divf: single-precision division
 * - __mspabi_cvtdf: double -> float conversion
 * - __mspabi_cvtfd: float -> double conversion
 * - __mspabi_fltuld: unsigned long -> double conversion
 * - __mspabi_fltulf: unsigned long -> float conversion
 * - __mspabi_fixfli: float -> signed long conversion
 * - cos: double-precision cosine (libm)
 * - sin: double-precision sine (libm)
 *
 * Each benchmark is written so the compiler emits exactly ONE helper call in
 * its loop body: the sink width always matches the result type, because a
 * mismatched sink would pull a second conversion helper into the measured
 * pulse and the energy model attributes one pulse to one key.
 *
 * The cos/sin benchmarks are whole-subtree costs, not leaf costs: they absorb
 * __ieee754_rem_pio2, __kernel_rem_pio2 and ~1000 nested __mspabi_* calls, so
 * their parameters are not comparable to the leaf __mspabi_* parameters.
 *
 * IMPORTANT: This file MUST be compiled with -mhwmult=none to prevent
 * GCC from inlining multiplication to hardware multiplier registers.
 * The gen_benchmarks.py script handles this automatically.
 *
 * IMPORTANT: linking requires -lm for cos/sin (already in the Makefile
 * LDLIBS).
 */
#include "setup.h"

#include <math.h>

/* Volatile sinks to prevent dead-code elimination */
static volatile uint16_t sink16;
static volatile uint32_t sink32;
static volatile uint64_t sink64;
static volatile float sinkf;
static volatile double sinkd;

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
 * cos/sin run ~884k instructions per call at their worst case, four orders of
 * magnitude more than the integer helpers. At the shared repeat count each of
 * their pulses would last 11-17 s; this count keeps them near 0.1 s, still far
 * above the export resolution.
 */
#ifndef LIBM_CALL_INNER_ITERS
#define LIBM_CALL_INNER_ITERS 2
#endif

#define REPEAT_LIBM_CALL_INNER_ITERS(X)                                        \
    for (int _rep_libm_call_ = 0; _rep_libm_call_ < (LIBM_CALL_INNER_ITERS);   \
         ++_rep_libm_call_) {                                                  \
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

/*
 * __mspabi_remul: unsigned 32-bit remainder (a % b)
 *
 * Worst-case inputs: dividend=0xFFFFFFFF, divisor=1.
 * __mspabi_remul only pushes the "modulus wanted" flag and calls the shared
 * udivmodsi4 shift-and-subtract routine, which has two loops:
 *   Phase 1 (alignment): left-shifts divisor and bit mask while divisor <
 *     dividend and bit 31 of the divisor is clear; divisor=1 needs the maximum
 *     31 shifts to reach 0x80000000.
 *   Phase 2 (subtraction): loops while the bit mask is nonzero, so a mask of
 *     0x80000000 forces the full 32 iterations, and dividend=0xFFFFFFFF makes
 *     every conditional subtract-and-set-bit execute.
 * Total: 63 loop iterations (31 + 32), the maximum possible.
 */
INLINE void bench_call___mspabi_remul(void) {
    volatile uint32_t a = 0xFFFFFFFF;
    volatile uint32_t b = 1;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink32 = a % b);
}

/*
 * __mspabi_mpyll: 64-bit multiplication (a * b)
 *
 * Worst-case inputs: a=0xFFFFFFFFFFFFFFFF, b=0xFFFFFFFFFFFFFFFF.
 * __mspabi_mpyll has no loop of its own: it is straight-line code issuing six
 * calls to __mspabi_mpyl (four 16x16 partial products of the low words, two
 * 32x32 cross products), so all iteration is in __mspabi_mpyl's shift-and-add
 * loop, which runs until its multiplier shifts to zero. The six multipliers are
 * the two 16-bit halves of one operand's low word (16 iterations each when bit
 * 15 is set) and both operands' 32-bit high words (32 iterations each when bit
 * 31 is set), so all-ones gives the maximum 4*16 + 2*32 = 128 iterations with
 * the conditional accumulate taken in every one.
 * The 64-bit sink is required: truncating the product to sink32 makes GCC emit
 * the 32-bit __mspabi_mpyl instead.
 */
INLINE void bench_call___mspabi_mpyll(void) {
    volatile uint64_t a = 0xFFFFFFFFFFFFFFFFULL;
    volatile uint64_t b = 0xFFFFFFFFFFFFFFFFULL;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink64 = a * b);
}

/*
 * __mspabi_addd: double-precision addition (a + b)
 *
 * Worst-case inputs: a = 0x0.0000000000001p-1022, b = -0x0.0000000000002p-1022.
 * Both are subnormal, so __unpack_d runs its normalise loop (shift left until
 * bit 60 is set) 52 and 51 times respectively - 103 of the 104 possible passes.
 * Their unpacked exponents differ by 1, so _fpadd_parts takes the alignment
 * branch, whose sticky-bit term always calls __mspabi_srlll with a shift of 63
 * (63 more loop passes). Opposite signs make the fractions cancel down to
 * 2^59, and the difference lands at exponent -1074, the smallest subnormal,
 * so __pack_d re-denormalises with a 52-bit shift (52 srlll + 52 sllll passes).
 */
INLINE void bench_call___mspabi_addd(void) {
    volatile double a = 0x0.0000000000001p-1022;
    volatile double b = -0x0.0000000000002p-1022;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkd = a + b);
}

/*
 * __mspabi_subd: double-precision subtraction (a - b)
 *
 * Worst-case inputs: a = 0x0.0000000000001p-1022, b = 0x0.0000000000002p-1022.
 * __mspabi_subd only flips b's sign bit and then runs the same _fpadd_parts as
 * __mspabi_addd, so the same subnormal pair is worst case: 103 __unpack_d
 * normalise passes, the alignment branch with its fixed 63-pass __mspabi_srlll
 * sticky shift (exponents differ by 1), cancellation of the fractions, and a
 * result at exponent -1074 that costs __pack_d a 52-bit re-denormalising shift.
 * a < b also selects the negate-the-result path in _fpadd_parts.
 */
INLINE void bench_call___mspabi_subd(void) {
    volatile double a = 0x0.0000000000001p-1022;
    volatile double b = 0x0.0000000000002p-1022;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkd = a - b);
}

/*
 * __mspabi_mpyd: double-precision multiplication (a * b)
 *
 * Worst-case inputs: a = 0x1.fffffffffffffp-4, b = 0x0.0000000000001p-1022.
 * The 64-pass shift-and-add loop adds the 128-bit partial product only when the
 * tested bit of the first operand's fraction is set, so a's all-ones mantissa
 * (53 set bits, the most a double can hold) maximises the taken branches.
 * b is the smallest subnormal, which costs __unpack_d 52 normalise passes.
 * Their exponents sum to -1078, four below the subnormal threshold plus the
 * loop's own 4-step renormalisation, which is the largest __pack_d shift (56)
 * that still takes the denormalising path instead of flushing to zero.
 */
INLINE void bench_call___mspabi_mpyd(void) {
    volatile double a = 0x1.fffffffffffffp-4;
    volatile double b = 0x0.0000000000001p-1022;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkd = a * b);
}

/*
 * __mspabi_divd: double-precision division (a / b)
 *
 * Worst-case inputs: a = 0x0.000000000000fp-1022, b = 0x0.000000000001fp-1022.
 * The restoring-division loop always runs 61 passes; the subtract-and-set-bit
 * branch is taken once per set quotient bit. 15/31 unpacks to a quotient of
 * 0b1111011110... (period 5, four ones), giving 49 taken branches, while both
 * operands stay subnormal so __unpack_d spends 49 + 48 = 97 normalise passes.
 * Larger mantissas buy at most 12 more quotient bits but cost far more
 * __unpack_d passes, so this pair maximises the sum.
 */
INLINE void bench_call___mspabi_divd(void) {
    volatile double a = 0x0.000000000000fp-1022;
    volatile double b = 0x0.000000000001fp-1022;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkd = a / b);
}

/*
 * __mspabi_addf: single-precision addition (a + b)
 *
 * Worst-case inputs: a = 1.40129846e-45f (0x00000001), b = -2.80259693e-45f
 * (0x80000002), the two smallest subnormals with opposite signs.
 * __unpack_f normalizes a subnormal with a 1-bit-per-iteration loop that runs
 * until the fraction reaches 1<<30; mantissas 1 and 2 give the maximum 23 and
 * 22 iterations. The 1-exponent gap makes _fpadd_parts call __mspabi_srll and
 * __mspabi_slll (also 1 bit per iteration) for alignment, and the cancellation
 * leaves a result of exactly one subnormal ulp, so __pack_f takes its subnormal
 * path with the largest reachable right-shift count (23 of the 25 it allows).
 */
INLINE void bench_call___mspabi_addf(void) {
    volatile float a = 1.40129846e-45f;
    volatile float b = -2.80259693e-45f;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkf = a + b);
}

/*
 * __mspabi_mpyf: single-precision multiplication (a * b)
 *
 * Worst-case inputs: a = 0.499999970f (0x3EFFFFFF), b = 1.40129846e-45f
 * (0x00000001).
 * The shift-and-add loop always runs 32 times but only adds when a bit of a's
 * fraction is set; an all-ones mantissa gives the maximum 24 conditional adds.
 * b is the smallest subnormal, so __unpack_f spends its full 23 normalization
 * iterations on it, and the resulting exponent (-2 + -149 + 2 - 2 = -151) is
 * the lowest one for which __pack_f still shifts instead of flushing to zero,
 * costing the maximum 25-bit __mspabi_srll/__mspabi_slll pair.
 * Operand order matters: the conditional add is driven by the FIRST argument's
 * fraction, so swapping a and b makes the benchmark cheaper.
 */
INLINE void bench_call___mspabi_mpyf(void) {
    volatile float a = 0.499999970f;
    volatile float b = 1.40129846e-45f;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkf = a * b);
}

/*
 * __mspabi_divf: single-precision division (a / b)
 *
 * Worst-case inputs: a = 1.40129846e-45f (0x00000001), b = 2.00883555f
 * (0x400090C3).
 * a is the smallest subnormal, so __unpack_f runs its full 23 normalization
 * iterations. The restoring-division loop always runs 31 times but subtracts
 * only where a quotient bit is set; b's mantissa (0x0090C3, found by exhaustive
 * search over all 2^23 mantissas) yields quotient 0x7F6FDFFF with 28 set bits.
 * b's exponent puts the result exponent at -151, the lowest for which __pack_f
 * still takes its 25-bit subnormal shift path instead of flushing to zero.
 */
INLINE void bench_call___mspabi_divf(void) {
    volatile float a = 1.40129846e-45f;
    volatile float b = 2.00883555f;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkf = a / b);
}

/*
 * __mspabi_cvtdf: double -> float conversion
 *
 * Worst-case inputs: a = 0x1p-1074 (smallest denormal double, bits 0x1).
 * cvtdf is straight-line (__unpack_d, then __mspabi_srlll with a hardcoded
 * count of 30, then __make_fp/__pack_f), so all input-dependent work sits in
 * __unpack_d's denormal normalization loop at .L18. That loop is entered only
 * when the exponent field is 0 and the fraction is nonzero; it doubles the
 * 64-bit fraction one bit per iteration until the top word exceeds 4095
 * (fraction >= 2^60). With fraction == 1 it runs the maximum 52 iterations of
 * its ~37-instruction body, which dwarfs every other path in the call.
 */
INLINE void bench_call___mspabi_cvtdf(void) {
    volatile double a = 0x1p-1074;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkf = (float)a);
}

/*
 * __mspabi_cvtfd: float -> double conversion
 *
 * Worst-case inputs: a = 0x1p-149f (smallest denormal float, bits 0x00000001).
 * cvtfd has no loop of its own and calls __mspabi_sllll with a hardcoded count
 * of 30, so the only input-dependent work is __unpack_f's denormal
 * normalization loop at .L13. That loop runs only when the exponent field is 0
 * and the fraction is nonzero; it doubles the 32-bit fraction each iteration
 * until the high word exceeds 16383 (fraction >= 2^30). Starting from
 * mantissa<<7, mantissa == 1 forces the maximum 23 iterations. __pack_d cannot
 * add work: its denormal path needs exp < -1022, unreachable from a float.
 */
INLINE void bench_call___mspabi_cvtfd(void) {
    volatile float a = 0x1p-149f;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkd = (double)a);
}

/*
 * __mspabi_fltuld: unsigned long -> double conversion
 *
 * Worst-case inputs: a = 1.
 * fltuld has no loop of its own; it calls __clzsi2 and then __mspabi_sllll with
 * a count of clz+29, so the work is (clzsi2's __mspabi_srll by 0/8/16/24) plus
 * (60 - MSB position) iterations of sllll, both 7 cycles per bit. That sum
 * peaks at 420 cycles whenever the MSB is byte-aligned; a == 1 gives clz == 31,
 * so __clzsi2 shifts by 0 and __mspabi_sllll runs the maximum 60 iterations.
 * Zero is excluded: it short-circuits to __pack_d.
 */
INLINE void bench_call___mspabi_fltuld(void) {
    volatile uint32_t a = 1UL;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkd = (double)a);
}

/*
 * __mspabi_fltulf: unsigned long -> float conversion
 *
 * Worst-case inputs: a = 16777216 (0x01000000).
 * fltulf has no loop of its own; the cost is __clzsi2's byte-normalizing
 * __mspabi_srll (count 0/8/16/24, 7 cycles per bit) plus __mspabi_slll(x,
 * clz-1) (6 cycles per bit). The sum 7*s + 6*(30 - MSB) peaks when the MSB is
 * at bit 24: __clzsi2 pays its full 24-iteration shift because the top byte is
 * nonzero, while slll still runs 6 iterations (204 cycles, versus 180 for
 * a == 1 and 146 for a >= 2^31, which skips slll entirely).
 */
INLINE void bench_call___mspabi_fltulf(void) {
    volatile uint32_t a = 16777216UL;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sinkf = (float)a);
}

/*
 * __mspabi_fixfli: float -> signed long conversion
 *
 * Worst-case inputs: a = 0x1p-149f (smallest denormal float, bits 0x00000001).
 * fixfli itself has no loop; it either returns early or calls
 * __mspabi_srll(frac, 30-exp), which peaks at 30 iterations (~214 cycles) for
 * exponent 0. The more expensive path is __unpack_f's denormal normalization
 * loop .L13, which doubles the fraction until the high word exceeds 16383:
 * mantissa == 1 forces its maximum 23 iterations of a 13-cycle body (~299
 * cycles). A denormal has a negative exponent, so fixfli then returns 0 without
 * calling __mspabi_srll - the two paths are exclusive and the denormal one is
 * only ~20% longer, so this is the least certain of the worst-case choices.
 * The (uint32_t)(int32_t) cast is a reinterpretation, not a second helper call.
 */
INLINE void bench_call___mspabi_fixfli(void) {
    volatile float a = 0x1p-149f;
    REPEAT_SPECIAL_FUNCTION_INNER_ITERS(sink32 = (uint32_t)(int32_t)a);
}

/*
 * cos: double-precision cosine (newlib fdlibm)
 *
 * Worst-case inputs: a = 1.7976931348623157e308 (DBL_MAX = 0x7FEFFFFFFFFFFFFF).
 * cos rejects an argument only when its high half exceeds 0x7fef (cos+0x56), so
 * DBL_MAX is the largest value that still reaches __ieee754_rem_pio2, and
 * ix > 0x413921fb forces the multiprecision __kernel_rem_pio2 branch (jk=4).
 * The all-ones mantissa keeps nx=3, running the x[]*f[] convolution's full 5x3
 * iterations, and the distilled z reaches 0.0, firing the `goto recompute'
 * back-edge at __kernel_rem_pio2+0x912 for a second complete reduction pass.
 * This is a whole-subtree cost: ~884k instructions per call, absorbing roughly
 * 1000 nested __mspabi_* calls.
 */
INLINE void bench_call_cos(void) {
    volatile double a = 1.7976931348623157e308;
    REPEAT_LIBM_CALL_INNER_ITERS(sinkd = cos(a));
}

/*
 * sin: double-precision sine (newlib fdlibm)
 *
 * Worst-case inputs: a = 1.7976931348623157e308 (DBL_MAX = 0x7FEFFFFFFFFFFFFF).
 * sin uses the same guards as cos: only a high half above 0x7fef is rejected
 * (sin+0x56), so DBL_MAX is the largest argument that still enters
 * __ieee754_rem_pio2, and ix > 0x413921fb forces __kernel_rem_pio2 (jk=4).
 * The all-ones mantissa gives nx=3 so the x[]*f[] convolution runs 5x3 times,
 * and z distills to 0.0, taking the `goto recompute' back-edge at
 * __kernel_rem_pio2+0x912 for a second complete reduction pass.
 * sin and cos share their entire argument reduction and differ by only ~2000
 * of ~883k instructions, so the two parameters are not separable by
 * measurement.
 */
INLINE void bench_call_sin(void) {
    volatile double a = 1.7976931348623157e308;
    REPEAT_LIBM_CALL_INNER_ITERS(sinkd = sin(a));
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
    BENCH(bench_call___mspabi_remul());
    BENCH(bench_call___mspabi_mpyll());
    BENCH(bench_call___mspabi_addd());
    BENCH(bench_call___mspabi_subd());
    BENCH(bench_call___mspabi_mpyd());
    BENCH(bench_call___mspabi_divd());
    BENCH(bench_call___mspabi_addf());
    BENCH(bench_call___mspabi_mpyf());
    BENCH(bench_call___mspabi_divf());
    BENCH(bench_call___mspabi_cvtdf());
    BENCH(bench_call___mspabi_cvtfd());
    BENCH(bench_call___mspabi_fltuld());
    BENCH(bench_call___mspabi_fltulf());
    BENCH(bench_call___mspabi_fixfli());
    BENCH(bench_call_cos());
    BENCH(bench_call_sin());

    end_measurement_window();
    return 0;
}
