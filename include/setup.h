#include <msp430.h>
#include <stdint.h>

// 16 MHz
#define CLOCK_HZ 16000000UL

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

void toggle_gpio() { P1OUT ^= BIT3; }

void begin_event() {
  __delay_cycles(0.1 * CLOCK_HZ);
  P1OUT |= BIT3;
}
void end_event() {
  P1OUT &= ~BIT3;
  __delay_cycles(0.1 * CLOCK_HZ);
}

void begin_measurement_window() {
  __delay_cycles(CLOCK_HZ * 5);
  P1OUT |= BIT2;
}
void end_measurement_window() {
  P1OUT &= ~BIT2;
  __delay_cycles(CLOCK_HZ * 5);
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

  UCA0CTLW0 =
      UCSWRST |
      UCSSEL__SMCLK; // Hold reset; BRCLK=SMCLK (16 MHz)

#if BAUD == 9600
                     // 16e6 / (16*9600) = 104.1667 -> BRW=104, UCBRF=3, UCBRS=0
  UCA0BRW = 104;
  UCA0MCTLW = UCOS16 | UCBRF_3 | (0x00 << 8);
#elif BAUD == 115200
                     // 16e6 / (16*115200) = 8.6806 -> BRW=8, UCBRF=11, UCBRS=0
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

void initialize(void) {
  WDTCTL = WDTPW | WDTHOLD; // Stop WDT
  PM5CTL0 &= ~LOCKLPM5;     // Unlock I/O (FRAM parts)

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
#define INNER_ITERS 20
#endif

#ifndef TEXTUAL_REPT
#define TEXTUAL_REPT 500
#endif

#define REPEAT_INNER_ITERS(X)                                                  \
  for (int _rep_inner_ = 0; _rep_inner_ < (INNER_ITERS); ++_rep_inner_) {      \
    X;                                                                         \
  }

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define INLINE static inline __attribute__((always_inline))