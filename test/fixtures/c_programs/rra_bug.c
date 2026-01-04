#include <stdint.h>

volatile int16_t input __attribute__((section(".noinit")));
volatile int16_t result __attribute__((section(".noinit")));

int main() {
  input = -1;
  
  asm volatile (
    "mov %1, %0\n\t"
    "rra %0\n\t"
    : "=r" (result)
    : "r" (input)
  );
  
  return 0;
}
