#include <msp430.h>

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
void gpio_pin13_up() { P1OUT |= BIT3; }
void gpio_pin13_down() { P1OUT &= ~BIT3; }

void gpio_pin12_up() { P1OUT |= BIT2; }
void gpio_pin12_down() { P1OUT &= ~BIT2; }

void initialize() {
  WDTCTL = WDTPW | WDTHOLD; // Stop WDT
  PM5CTL0 &= ~LOCKLPM5; // Disable the GPIO power-on default high-impedance mode

  clockSetup();
  P1DIR |= BIT3; // mark beginning of execution with given input
  gpio_pin13_down();
}
