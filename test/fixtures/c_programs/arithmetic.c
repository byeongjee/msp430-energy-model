#include <msp430.h>

volatile int result_sum;
volatile int result_diff;

int main(void) {
  int x = 5;
  int y = 3;
  int sum = x + y;
  int diff = x - y;
  result_sum = sum;   // Store to volatile to prevent optimization
  result_diff = diff;
  return diff;
}
