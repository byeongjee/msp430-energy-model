#include <msp430.h>

// 16 MHz
#define CLOCK_HZ 16000000UL

void clockSetup() {

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
  __delay_cycles(CLOCK_HZ);
  P1OUT |= BIT3;
}
void end_event() {
  P1OUT &= ~BIT3;
  __delay_cycles(CLOCK_HZ);
}

void begin_measurement_window() {
  __delay_cycles(CLOCK_HZ * 5);
  P1OUT |= BIT2;
}
void end_measurement_window() {
  P1OUT &= ~BIT2;
  __delay_cycles(CLOCK_HZ * 5);
}

void initialize() {
  WDTCTL = WDTPW | WDTHOLD; // Stop WDT
  PM5CTL0 &= ~LOCKLPM5; // Disable the GPIO power-on default high-impedance mode

  clockSetup();

  // mark beginning of execution with given input
  P1DIR |= BIT3;
  P1DIR |= BIT2;
  end_event();
  end_measurement_window();
}
