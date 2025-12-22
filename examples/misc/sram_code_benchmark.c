#include "setup.h"

// ============================================================================
// SRAM Code Execution Benchmark
// ============================================================================
// This benchmark demonstrates executing code from SRAM to isolate FRAM data
// access costs from instruction fetch costs.
//
// When code runs from FRAM (normal), every instruction fetch generates
// FRAMReadHit/FRAMReadMiss events, making it hard to learn the true cost
// of FRAM data accesses separately.
//
// When code runs from SRAM (using SRAM_CODE), instruction fetches don't
// generate FRAM cache events, so only explicit FRAM data accesses are tracked.
// ============================================================================

#ifndef FRAM_READ_ITERS
#define FRAM_READ_ITERS 100
#endif

// FRAM data area - placed in .rodata which resides in FRAM
static const volatile uint16_t fram_data[16] __attribute__((section(".rodata"))) = {
    0x1234, 0x5678, 0x9ABC, 0xDEF0,
    0x1111, 0x2222, 0x3333, 0x4444,
    0x5555, 0x6666, 0x7777, 0x8888,
    0x9999, 0xAAAA, 0xBBBB, 0xCCCC
};

// ============================================================================
// Benchmark 1: FRAM reads from SRAM-resident code
// ============================================================================
// This function executes from SRAM, so instruction fetches don't incur
// FRAM cache events. Only the explicit FRAM data reads are tracked.
SRAM_CODE NOINLINE void sram_code_fram_read(void) {
    register volatile uint16_t val;
    register const volatile uint16_t* ptr = fram_data;

    begin_event();
    for (int i = 0; i < FRAM_READ_ITERS; i++) {
        // Each read accesses FRAM - generates FRAMReadHit/FRAMReadMiss
        val = ptr[i & 0xF];
    }
    end_event();

    (void)val;  // Prevent optimization
}

// ============================================================================
// Benchmark 2: FRAM reads from FRAM-resident code (control)
// ============================================================================
// This function executes from FRAM (normal), so instruction fetches
// also generate FRAM cache events - mixed with data access events.
NOINLINE void fram_code_fram_read(void) {
    register volatile uint16_t val;
    register const volatile uint16_t* ptr = fram_data;

    begin_event();
    for (int i = 0; i < FRAM_READ_ITERS; i++) {
        // FRAM data read + instruction fetch events are mixed
        val = ptr[i & 0xF];
    }
    end_event();

    (void)val;
}

// ============================================================================
// Benchmark 3: Pure instruction execution from SRAM (baseline)
// ============================================================================
// Execute NOPs from SRAM to measure pure instruction cost without any
// FRAM cache events.
SRAM_CODE NOINLINE void sram_code_nops(void) {
    begin_event();
    __asm__ volatile(
        ".rept 100\n"
        "  nop\n"
        ".endr\n"
        ::: "memory"
    );
    end_event();
}

// ============================================================================
// Benchmark 4: Pure instruction execution from FRAM (control)
// ============================================================================
// Execute NOPs from FRAM to measure instruction + fetch cost.
NOINLINE void fram_code_nops(void) {
    begin_event();
    __asm__ volatile(
        ".rept 100\n"
        "  nop\n"
        ".endr\n"
        ::: "memory"
    );
    end_event();
}

int main(void) {
    initialize();
    begin_measurement_window();

    // Compare SRAM vs FRAM code execution with FRAM data access
    sram_code_fram_read();  // Only FRAM data events
    fram_code_fram_read();  // FRAM data + instruction fetch events

    // Compare pure instruction execution
    sram_code_nops();       // No FRAM events at all
    fram_code_nops();       // FRAM instruction fetch events only

    end_measurement_window();
    return 0;
}
