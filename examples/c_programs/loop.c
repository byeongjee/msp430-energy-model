#include "gpio.h"
#include <msp430.h>

int main(void) {
  initialize();
  int sum = 0;
  int i;
  for (i = 1; i <= 100; i++) {
    gpio_up();
    sum += i;
    gpio_down();
  }
  return sum;
}