#include <msp430.h>

volatile int result;

int main(void) {
  int a = 10;
  int b = 20;
  int c = a + b;
  result = c;  // Store to volatile to prevent optimization
  return c;
}
