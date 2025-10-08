#include "gpio.h"
#include <msp430.h>
#include <stdio.h>

int main(void) {
  initialize();

  int buffer[20];

  begin_measurement_window();

  for (int i = 0; i < 10; i++) {
    begin_event();

    // some random computation
    buffer[0] = 0;
    buffer[1] = 1;
    for (int j = 2; j < 20; j++) {
      buffer[j] = buffer[j - 1] + buffer[j - 2];
    }

    end_event();
  }

  end_measurement_window();

  int a = buffer[19];
  return a;
}