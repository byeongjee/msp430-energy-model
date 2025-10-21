#include "setup.h"

int main(void) {
  initialize();

  int buffer[100];

  begin_measurement_window();
  begin_event();

  for (int i = 0; i < 100; i++) {

    // some random computation
    buffer[0] = 0;
    buffer[1] = 1;
    for (int j = 2; j < 100; j++) {
      buffer[j] = buffer[j - 1] + buffer[j - 2];
    }
  }
  end_event();

  end_measurement_window();

  int a = buffer[19];
  return a;
}