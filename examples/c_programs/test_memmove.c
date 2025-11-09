#include <msp430.h>
#include <stdint.h>

// Global variable for symbolic addressing mode tests
static volatile uint16_t global_data = 0x1234;
static volatile uint16_t mem_array[4] = {0x1111, 0x2222, 0x3333, 0x4444};

int main(void) {
  // FIXME: our interpreter doesn't support reading from data section yet.
  global_data = 0x1234;
  mem_array[0] = 0x1111;
  mem_array[1] = 0x2222;
  mem_array[2] = 0x3333;
  mem_array[3] = 0x4444;

  return mem_array[0];
}
