#include "synthetic_basic_blocks_common.h"

int main(void) {
  initialize();
  seed_validation_data();

  begin_measurement_window();
  BENCH(bench_pointer_walk());
  end_measurement_window();

  return (int)sink;
}
