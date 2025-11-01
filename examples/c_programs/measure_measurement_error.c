// the goal of this program is to estimate the measurement error
#include "setup.h"

#define NOINLINE __attribute__((noinline))

NOINLINE void bench_add() {
  register uint16_t acc = 0x1111;
  register uint16_t src = 0x2222;
  __asm__ volatile(".rept 100\n"
                   "add %[s], %[a]\n"
                   ".endr\n"
                   : [a] "+r"(acc)
                   : [s] "r"(src)
                   : "cc");
}

NOINLINE void bench_mul() {
  uint16_t a = 0x1234;
  uint16_t b = 0x5678;
  volatile uint32_t result = 0;
  MPY = a;
  __asm__ volatile(".rept 5000\n"
                   "mov %[B], &OP2\n"
                   ".endr\n"
                   :
                   : [B] "r"(b)
                   : "memory");
  result = ((uint32_t)RESHI << 16) | RESLO;
}

int main(void) {
  initialize();

  begin_measurement_window();

  for (int i = 0; i < NUM_REPEAT; i++) {
    begin_event();
    bench_mul();
    end_event();
  }

  end_measurement_window();

  return 0;
}
