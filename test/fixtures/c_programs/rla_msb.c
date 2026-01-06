// Test RLA/RLAM MSB detection for different data sizes
// Bug: RLA uses hardcoded 0x8000 for MSB, ignoring data_size
// For byte operations, MSB should be bit 7 (0x80), not bit 15 (0x8000)

// Store results and carry flags
volatile unsigned char byte_result1;   // 0x80 << 1 = 0x00, C=1 (MSB was set)
volatile unsigned char byte_result2;   // 0x40 << 1 = 0x80, C=0 (MSB was not set)
volatile unsigned char byte_carry1;    // Should be 1
volatile unsigned char byte_carry2;    // Should be 0

volatile unsigned int word_result1;    // 0x8000 << 1 = 0x0000, C=1
volatile unsigned int word_result2;    // 0x4000 << 1 = 0x8000, C=0
volatile unsigned char word_carry1;    // Should be 1
volatile unsigned char word_carry2;    // Should be 0

int main(void) {
    unsigned char bval;
    unsigned int wval;
    unsigned char carry;

    // ===== BYTE OPERATIONS =====

    // Byte Test 1: 0x80 << 1 = 0x00 with C=1 (bit 7 was set)
    bval = 0x80;
    __asm__ volatile (
        "rla.b %0"
        : "+r" (bval)
    );
    byte_result1 = bval;
    // Capture carry flag
    __asm__ volatile (
        "mov.b r2, %0\n\t"
        "and.b #1, %0"
        : "=r" (carry)
    );
    byte_carry1 = carry;

    // Byte Test 2: 0x40 << 1 = 0x80 with C=0 (bit 7 was not set)
    bval = 0x40;
    __asm__ volatile (
        "rla.b %0"
        : "+r" (bval)
    );
    byte_result2 = bval;
    // Capture carry flag
    __asm__ volatile (
        "mov.b r2, %0\n\t"
        "and.b #1, %0"
        : "=r" (carry)
    );
    byte_carry2 = carry;

    // ===== WORD OPERATIONS =====

    // Word Test 1: 0x8000 << 1 = 0x0000 with C=1 (bit 15 was set)
    wval = 0x8000;
    __asm__ volatile (
        "rla %0"
        : "+r" (wval)
    );
    word_result1 = wval;
    // Capture carry flag
    __asm__ volatile (
        "mov.b r2, %0\n\t"
        "and.b #1, %0"
        : "=r" (carry)
    );
    word_carry1 = carry;

    // Word Test 2: 0x4000 << 1 = 0x8000 with C=0 (bit 15 was not set)
    wval = 0x4000;
    __asm__ volatile (
        "rla %0"
        : "+r" (wval)
    );
    word_result2 = wval;
    // Capture carry flag
    __asm__ volatile (
        "mov.b r2, %0\n\t"
        "and.b #1, %0"
        : "=r" (carry)
    );
    word_carry2 = carry;

    return 0;
}
