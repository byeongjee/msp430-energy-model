#include "synthetic_basic_blocks_common.h"

int main(void) {
  initialize();
  seed_validation_data();

  begin_measurement_window();
  BENCH(bench_register_only());
  end_measurement_window();

  return (int)sink;
}
