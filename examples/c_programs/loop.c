#include "gpio.h"
#include <msp430.h>

int main(void) {
  initialize();

  int sum = 0;
  int i;

  begin_measurement_window();

  for (i = 1; i <= 100; i++) {
    begin_event();
    sum += i;
    end_event();
  }

  end_measurement_window();

  return sum;
}