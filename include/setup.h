#include <msp430.h>
#include <stdint.h>

// 16 MHz
#define CLOCK_HZ 16000000UL
#define NOINLINE __attribute__((noinline))
#define INLINE static inline __attribute__((always_inline))

// ============================================================================
// SRAM Code Execution Support
// ============================================================================
// Place functions in SRAM to isolate FRAM data access costs from instruction
// fetch costs during energy benchmarking.
//
// Usage:
//   SRAM_CODE void my_benchmark(void) {
//       // This code executes from SRAM
//       volatile uint16_t* fram_ptr = (uint16_t*)0x4000;
//       *fram_ptr;  // FRAM read - generates cache events
//   }
//
// The function is stored in FRAM but copied to SRAM at startup by
// copy_text_sram(). Call copy_text_sram() before using any SRAM_CODE functions.
// ============================================================================
#define SRAM_CODE __attribute__((section(".text_sram")))

// Linker symbols for .text_sram section
extern char __text_sram_start[];
extern char __text_sram_end[];
extern char __text_sram_load[];

// Copy .text_sram section from FRAM (load address) to RAM (execution address)
static inline void copy_text_sram(void) {
    char* src = __text_sram_load;
    char* dst = __text_sram_start;
    while (dst < __text_sram_end) {
        *dst++ = *src++;
    }
}

// ============================================================================
// Unified Debug Output System
// ============================================================================
// Usage:
//   make interpret FILE=foo.c                - No debug output
//   make interpret FILE=foo.c DEFINES=DEBUG=1  - Board UART/printf debug
//   make interpret FILE=foo.c DEFINES=DEBUG=2  - Interpreter memory-mapped
//   debug
//
// Macros:
//   DEBUG_OUT_U16(val)  - Print 16-bit unsigned
//   DEBUG_OUT_I16(val)  - Print 16-bit signed
//   DEBUG_OUT_HEX(val)  - Print 16-bit hex
//   DEBUG_OUT_CHAR(c)   - Print single character
//   DEBUG_OUT_U32(val)  - Print 32-bit unsigned
//   DEBUG_OUT_STR(str)  - Print null-terminated string
// ============================================================================

#if defined(DEBUG) && (DEBUG == 2)
// Interpreter mode: emit calls that the interpreter can intercept.
// Functions are defined as noinline with a dummy asm to keep them from being
// optimized away, but they have no effect on-device.
NOINLINE __attribute__((used)) void debug_out_u16(uint16_t val) {
  __asm__ volatile("" ::"r"(val) : "memory");
}
NOINLINE __attribute__((used)) void debug_out_i16(int16_t val) {
  __asm__ volatile("" ::"r"(val) : "memory");
}
NOINLINE __attribute__((used)) void debug_out_hex(uint16_t val) {
  __asm__ volatile("" ::"r"(val) : "memory");
}
NOINLINE __attribute__((used)) void debug_out_char(uint16_t c) {
  __asm__ volatile("" ::"r"(c) : "memory");
}
NOINLINE __attribute__((used)) void debug_out_u32(uint32_t val) {
  __asm__ volatile("" ::"r"(val) : "memory");
}
NOINLINE __attribute__((used)) void debug_out_str(const char *str) {
  __asm__ volatile("" ::"r"(str) : "memory");
}

// Macros map directly to the debug_out_* function calls.
#define DEBUG_OUT_U16(val) debug_out_u16((uint16_t)(val))
#define DEBUG_OUT_I16(val) debug_out_i16((int16_t)(val))
#define DEBUG_OUT_HEX(val) debug_out_hex((uint16_t)(val))
#define DEBUG_OUT_CHAR(c) debug_out_char((uint16_t)(c))
#define DEBUG_OUT_U32(val) debug_out_u32((uint32_t)(val))
#define DEBUG_OUT_STR(str) debug_out_str((const char *)(str))

#elif defined(DEBUG) && (DEBUG == 1)
// Board mode: use printf (requires UART initialization)
#include <stdio.h>
#define DEBUG_OUT_U16(val) printf("[DEBUG] u16: %u\n", (unsigned int)(val))
#define DEBUG_OUT_I16(val) printf("[DEBUG] i16: %d\n", (int)(val))
#define DEBUG_OUT_HEX(val) printf("[DEBUG] hex: 0x%04x\n", (unsigned int)(val))
#define DEBUG_OUT_CHAR(c) printf("[DEBUG] char: %c\n", (char)(c))
#define DEBUG_OUT_U32(val) printf("[DEBUG] u32: %lu\n", (unsigned long)(val))
#define DEBUG_OUT_STR(str) printf("[DEBUG] str: %s\n", (str))

#else
// No debug mode: all macros are no-ops
#define DEBUG_OUT_U16(val) ((void)0)
#define DEBUG_OUT_I16(val) ((void)0)
#define DEBUG_OUT_HEX(val) ((void)0)
#define DEBUG_OUT_CHAR(c) ((void)0)
#define DEBUG_OUT_U32(val) ((void)0)
#define DEBUG_OUT_STR(str) ((void)0)
#endif

// For debugging
#define BAUD 9600
// or 115200

void clockSetup(void) {
  CSCTL0_H = CSKEY_H; // Unlock CS registers
  CSCTL1 = DCOFSEL_0; // Initial Clock Frequency Reset

  CSCTL2 = SELA__VLOCLK | SELS__DCOCLK |
           SELM__DCOCLK; // Set Clock Sources ACLK = VLO & SMCLK = MCLK = DCO

  // As per datasheet, div/4 for preventing out of spec operation. Refer to
  // example codes.
  CSCTL3 = DIVA__4 | DIVS__4 | DIVM__4;
  CSCTL1 = DCOFSEL_4 | DCORSEL; // Frequency = 16MHz

  __delay_cycles(60);

  // Set Dividers to 1
  CSCTL3 = DIVA__1 | DIVS__1 | DIVM__1;

  // Turn on VLO
  CSCTL4 &= ~VLOOFF;
  CSCTL0_H = 0;
}

NOINLINE void toggle_gpio() { P1OUT ^= BIT3; }

NOINLINE void begin_event() {
  __delay_cycles(0.1 * CLOCK_HZ);
  P1OUT |= BIT3;
}
NOINLINE void end_event() {
  P1OUT &= ~BIT3;
  __delay_cycles(0.1 * CLOCK_HZ);
}

NOINLINE void begin_measurement_window() {
  __delay_cycles(CLOCK_HZ * 5);
  P1OUT |= BIT2;
}
NOINLINE void end_measurement_window() {
  P1OUT &= ~BIT2;
  __delay_cycles(CLOCK_HZ * 5);
}

NOINLINE void delay(uint32_t cycles) {
  while (--cycles > 0) {
    __delay_cycles(1);
  }
}

// Target for call/ret composite benchmarks; kept non-inline and non-empty.
// Contains 50 NOPs (100 bytes) to ensure function body exceeds the 64-byte
// FRAM cache, forcing cache misses when returning to caller.
NOINLINE __attribute__((used)) void bench_empty_function(void) {
  __asm__ volatile(
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 10
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 20
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 30
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 40
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 50
      ::: "memory");
}

// Interrupt-style stub for push/reti composite benchmark.
// Contains 50 NOPs (100 bytes) to ensure function body exceeds the 64-byte
// FRAM cache, forcing cache misses when returning to caller.
NOINLINE __attribute__((used, naked)) void bench_empty_interrupt(void) {
  __asm__ volatile(
      "push r2\n"
      "dint\n"
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 10
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 20
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 30
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 40
      "nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n"  // 50
      "reti\n");
}

// Setup for printf over UART. For debugging.
#ifdef DEBUG
#include <reent.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

static inline void uart_putc_block(char c) {
  while (!(UCA0IFG & UCTXIFG)) { /* wait */
  }
  UCA0TXBUF = (uint8_t)c;
}

static void uart_init_uca0_16mhz(void) {
  // Back-channel UART on LaunchPad: P2.0=UCA0TXD, P2.1=UCA0RXD
  P2SEL0 &= ~(BIT0 | BIT1);
  P2SEL1 |= (BIT0 | BIT1);

  UCA0CTLW0 = UCSWRST | UCSSEL__SMCLK; // Hold reset; BRCLK=SMCLK (16 MHz)

#if BAUD == 9600
                                       // 16e6 / (16*9600) = 104.1667 ->
                                       // BRW=104, UCBRF=3, UCBRS=0
  UCA0BRW = 104;
  UCA0MCTLW = UCOS16 | UCBRF_3 | (0x00 << 8);
#elif BAUD == 115200
                                       // 16e6 / (16*115200) = 8.6806 ->
                                       // BRW=8, UCBRF=11, UCBRS=0
  UCA0BRW = 8;
  UCA0MCTLW = UCOS16 | UCBRF_11 | (0x00 << 8);
#else
#error "Unsupported BAUD. Use 9600 or 115200."
#endif

  UCA0CTLW0 &= ~UCSWRST; // Enable UART
}

// Some libcs macro-define putchar/fputc; undef so we can provide functions
#ifdef putchar
#undef putchar
#endif
#ifdef fputc
#undef fputc
#endif

// newlib syscall path: printf → _write/_write_r
int _write(int fd, const void *buf, size_t n) {
  (void)fd;
  const char *p = (const char *)buf;
  for (size_t i = 0; i < n; i++) {
    if (p[i] == '\n')
      uart_putc_block('\r'); // CRLF for terminals
    uart_putc_block(p[i]);
  }
  return (int)n;
}
int _write_r(struct _reent *r, int fd, const void *buf, size_t n) {
  (void)r;
  return _write(fd, buf, n);
}
int fputc(int c, FILE *stream) {
  (void)stream;
  if (c == '\n')
    uart_putc_block('\r');
  uart_putc_block((char)c);
  return c;
}
int putchar(int c) {
  if (c == '\n')
    uart_putc_block('\r');
  uart_putc_block((char)c);
  return c;
}
#endif // DEBUG

NOINLINE void initialize(void) {
  WDTCTL = WDTPW | WDTHOLD; // Stop WDT
  PM5CTL0 &= ~LOCKLPM5;     // Unlock I/O (FRAM parts)

  // Copy SRAM-resident code from FRAM load address to RAM execution address
  copy_text_sram();

  clockSetup();

  // Measurement pins
  P1DIR |= BIT2 | BIT3;
  P1OUT &= ~BIT3;
  P1OUT &= ~BIT2;

  __delay_cycles(CLOCK_HZ * 5);

#ifdef DEBUG
  uart_init_uca0_16mhz();
  // Unbuffer stdout so prints appear immediately
  setvbuf(stdout, NULL, _IONBF, 0);

  printf("DEBUG UART ready @ %d baud, SMCLK=%lu Hz\n", (int)BAUD,
         (unsigned long)CLOCK_HZ);
#endif
}

#ifndef NUM_REPEAT
#define NUM_REPEAT 1
#endif

#define BENCH(X)                                                               \
  for (int _rep_bench_ = 0; _rep_bench_ < (NUM_REPEAT); ++_rep_bench_) {       \
    begin_event();                                                             \
    do {                                                                       \
      X;                                                                       \
    } while (0);                                                               \
    end_event();                                                               \
  }

#ifndef INNER_ITERS
#define INNER_ITERS 100
#endif

#ifndef TEXTUAL_REPT
#define TEXTUAL_REPT 100
#endif

#define REPEAT_INNER_ITERS(X)                                                  \
  for (int _rep_inner_ = 0; _rep_inner_ < (INNER_ITERS); ++_rep_inner_) {      \
    X;                                                                         \
  }

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)
