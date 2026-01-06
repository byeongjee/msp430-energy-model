// Test CALLA/RETA instructions for 20-bit addressing
// CALLA pushes 4-byte return address, RETA pops 4-byte return address

#include "setup.h"

volatile unsigned int result1;
volatile unsigned int result2;
volatile unsigned int sp_before_calla;
volatile unsigned int sp_after_calla;
volatile unsigned int sp_after_reta;

// Simple function that uses RETA to return (20-bit return address)
// Must be declared naked to avoid compiler-generated prologue/epilogue
NOINLINE __attribute__((naked)) unsigned int add_ten_reta(unsigned int x) {
    // x is passed in r12
    // add 10 to r12 and return using RETA
    __asm__ volatile (
        "add #10, r12\n\t"   // r12 = r12 + 10
        "reta\n\t"           // Return using 20-bit address
    );
}

int main(void) {
    initialize();

    volatile unsigned int val = 100;

    begin_measurement_window();

    begin_event();

    // Save SP before CALLA
    __asm__ volatile (
        "mov sp, %0\n\t"
        : "=r" (sp_before_calla)
    );

    // Call add_ten_reta using CALLA (pushes 4-byte return address)
    // r12 is used for argument passing
    __asm__ volatile (
        "mov %1, r12\n\t"       // Load argument into r12
        "calla #add_ten_reta\n\t"  // Call function using CALLA
        "mov r12, %0\n\t"       // Store result
        : "=r" (result1)
        : "r" (val)
        : "r12", "r13", "r14", "r15"
    );

    // Save SP after RETA returned
    __asm__ volatile (
        "mov sp, %0\n\t"
        : "=r" (sp_after_reta)
    );

    end_event();

    // Test 2: Another CALLA call with different value
    begin_event();

    val = 200;
    __asm__ volatile (
        "mov %1, r12\n\t"
        "calla #add_ten_reta\n\t"
        "mov r12, %0\n\t"
        : "=r" (result2)
        : "r" (val)
        : "r12", "r13", "r14", "r15"
    );

    end_event();

    end_measurement_window();

    // Expected results:
    // result1 = 110 (100 + 10)
    // result2 = 210 (200 + 10)
    // SP should return to same value after CALLA/RETA

    return 0;
}
