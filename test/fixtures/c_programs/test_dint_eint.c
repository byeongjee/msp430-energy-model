#include "setup.h"

int main() {
  initialize();

  // First enable interrupts
  __enable_interrupt();

  // Then disable them
  __disable_interrupt();

  return 0;
}
