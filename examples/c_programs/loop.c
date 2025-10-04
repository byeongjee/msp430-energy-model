#include "gpio.h"
#include <msp430.h>

int main(void) {
  initialize();

  int sum = 0;
  int i;

  gpio_pin12_up();

  for (i = 1; i <= 100; i++) {
    gpio_pin13_up();
    sum += i;
    gpio_pin13_down();
  }

  gpio_pin12_down();

  return sum;
}