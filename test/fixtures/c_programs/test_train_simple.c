#include "setup.h"

int main(void) {
  initialize();

  volatile uint16_t x = 0;

  begin_measurement_window();

  // Single event
  begin_event();
  x = 10;
  x = x + 5;
  end_event();

  end_measurement_window();

  return 0;
}
