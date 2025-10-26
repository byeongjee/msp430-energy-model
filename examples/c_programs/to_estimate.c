#include "setup.h"

#ifdef TRAIN_MODE
#define REPEAT 10
#endif

#ifdef ESTIMATE_MODE
#define REPEAT 1
#endif

int main(void) {
  initialize();

  int buffer[100];

  begin_measurement_window();
  for (int i = 0; i < REPEAT; i++) {
    begin_event();

    for (int j = 0; j < 100; j++) {

      // some random computation
      buffer[0] = 0;
      buffer[1] = 1;
      for (int k = 2; k < 100; k++) {
        buffer[k] = buffer[k - 1] + buffer[k - 2];
      }
    }
    end_event();
  }

  end_measurement_window();

  int a = buffer[19];
  return a;
}