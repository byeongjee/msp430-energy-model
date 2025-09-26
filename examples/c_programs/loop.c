#include "gpio.h"
#include <msp430.h>

int main(void) {
  initialize();
  int input_list[11];
  int sum = 0;
  int i;
  for (i = 1; i <= 100; i++) {
    gpio_up();

    input_list[0] = 0;
    input_list[1] = 1;
    input_list[2] = 2;
    input_list[3] = 3;
    input_list[4] = 4;
    input_list[5] = 5;
    input_list[6] = 6;
    input_list[7] = 7;
    input_list[8] = 8;
    input_list[9] = 9;
    input_list[10] = 10;
    gpio_down();
    input_list[0] = 10;
    input_list[1] = 9;
    input_list[2] = 8;
    input_list[3] = 7;
    input_list[4] = 9;
    input_list[5] = 8;
    input_list[6] = 7;
    input_list[7] = 6;
    input_list[8] = 5;
    input_list[9] = 4;
    input_list[10] = 3;
  }
  return sum;
}