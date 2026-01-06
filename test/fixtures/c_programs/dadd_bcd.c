// Test DADD BCD arithmetic for byte, word, and address data sizes
// DADD should perform decimal (BCD) addition, not binary

// Word operation results (16-bit BCD)
volatile unsigned int word_result1;  // 0x19 + 0x01 = 0x20 in BCD
volatile unsigned int word_result2;  // 0x99 + 0x01 = 0x0100 in BCD (carry into upper byte)
volatile unsigned int word_result3;  // 0x19 + 0x01 + carry = 0x21 in BCD
volatile unsigned int word_result4;  // 0x0999 + 0x0001 = 0x1000 in BCD
volatile unsigned int word_result5;  // 0x9999 + 0x0001 = 0x0000 in BCD (with carry out)

// Byte operation results (8-bit BCD)
volatile unsigned char byte_result1;  // 0x19 + 0x01 = 0x20 in BCD
volatile unsigned char byte_result2;  // 0x99 + 0x01 = 0x00 in BCD (with carry out)
volatile unsigned char byte_result3;  // 0x09 + 0x09 = 0x18 in BCD
volatile unsigned char byte_result4;  // 0x45 + 0x27 = 0x72 in BCD (45 + 27 = 72)
volatile unsigned char byte_result5;  // 0x50 + 0x50 + carry = 0x01 in BCD (with carry out)

// Address operation results (20-bit BCD)
volatile unsigned long addr_result1;  // 0x19999 + 0x00001 = 0x20000 in BCD
volatile unsigned long addr_result2;  // 0x99999 + 0x00001 = 0x00000 in BCD (with carry out)
volatile unsigned long addr_result3;  // 0x12345 + 0x00001 = 0x12346 in BCD

int main(void) {
    unsigned int wval;
    unsigned char bval;
    unsigned long aval;

    // ===== WORD OPERATIONS (16-bit BCD) =====

    // Word Test 1: 0x19 + 0x01 = 0x20 (BCD: 19 + 1 = 20)
    wval = 0x19;
    __asm__ volatile (
        "clrc\n\t"
        "dadd #0x01, %0"
        : "+r" (wval)
    );
    word_result1 = wval;

    // Word Test 2: 0x99 + 0x01 = 0x0100 (BCD: 99 + 1 = 100, carries into upper byte)
    wval = 0x99;
    __asm__ volatile (
        "clrc\n\t"
        "dadd #0x01, %0"
        : "+r" (wval)
    );
    word_result2 = wval;

    // Word Test 3: 0x19 + 0x01 + carry = 0x21 (BCD: 19 + 1 + 1 = 21)
    wval = 0x19;
    __asm__ volatile (
        "setc\n\t"
        "dadd #0x01, %0"
        : "+r" (wval)
    );
    word_result3 = wval;

    // Word Test 4: 0x0999 + 0x0001 = 0x1000 (BCD: 999 + 1 = 1000)
    wval = 0x0999;
    __asm__ volatile (
        "clrc\n\t"
        "dadd #0x01, %0"
        : "+r" (wval)
    );
    word_result4 = wval;

    // Word Test 5: 0x9999 + 0x0001 = 0x0000 (BCD: 9999 + 1 = 10000, overflow with carry)
    wval = 0x9999;
    __asm__ volatile (
        "clrc\n\t"
        "dadd #0x01, %0"
        : "+r" (wval)
    );
    word_result5 = wval;

    // ===== BYTE OPERATIONS (8-bit BCD) =====

    // Byte Test 1: 0x19 + 0x01 = 0x20 (BCD: 19 + 1 = 20)
    bval = 0x19;
    __asm__ volatile (
        "clrc\n\t"
        "dadd.b #0x01, %0"
        : "+r" (bval)
    );
    byte_result1 = bval;

    // Byte Test 2: 0x99 + 0x01 = 0x00 (BCD: 99 + 1 = 100, overflow with carry)
    bval = 0x99;
    __asm__ volatile (
        "clrc\n\t"
        "dadd.b #0x01, %0"
        : "+r" (bval)
    );
    byte_result2 = bval;

    // Byte Test 3: 0x09 + 0x09 = 0x18 (BCD: 9 + 9 = 18)
    bval = 0x09;
    __asm__ volatile (
        "clrc\n\t"
        "dadd.b #0x09, %0"
        : "+r" (bval)
    );
    byte_result3 = bval;

    // Byte Test 4: 0x45 + 0x27 = 0x72 (BCD: 45 + 27 = 72)
    bval = 0x45;
    __asm__ volatile (
        "clrc\n\t"
        "dadd.b #0x27, %0"
        : "+r" (bval)
    );
    byte_result4 = bval;

    // Byte Test 5: 0x50 + 0x50 + carry = 0x01 (BCD: 50 + 50 + 1 = 101, overflow)
    bval = 0x50;
    __asm__ volatile (
        "setc\n\t"
        "dadd.b #0x50, %0"
        : "+r" (bval)
    );
    byte_result5 = bval;

    // ===== ADDRESS OPERATIONS (20-bit BCD) =====

    // Address Test 1: 0x19999 + 0x00001 = 0x20000 (BCD: 19999 + 1 = 20000)
    aval = 0x19999;
    __asm__ volatile (
        "clrc\n\t"
        "daddx.a #0x01, %0"
        : "+r" (aval)
    );
    addr_result1 = aval;

    // Address Test 2: 0x99999 + 0x00001 = 0x00000 (BCD: 99999 + 1 = 100000, overflow)
    aval = 0x99999;
    __asm__ volatile (
        "clrc\n\t"
        "daddx.a #0x01, %0"
        : "+r" (aval)
    );
    addr_result2 = aval;

    // Address Test 3: 0x12345 + 0x00001 = 0x12346 (BCD: 12345 + 1 = 12346)
    aval = 0x12345;
    __asm__ volatile (
        "clrc\n\t"
        "daddx.a #0x01, %0"
        : "+r" (aval)
    );
    addr_result3 = aval;

    return 0;
}
