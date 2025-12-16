#include "setup.h"

int main() {
  initialize();

  // Test eint instruction
  __enable_interrupt();

  return 0;
}
