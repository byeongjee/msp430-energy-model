#include "setup.h"

// Global variable for symbolic addressing mode tests
static volatile uint16_t global_data = 0x1234;
static volatile uint16_t mem_array[4] = {0x1111, 0x2222, 0x3333, 0x4444};

int main(void) {
  // FIXME: our interpreter doesn't support reading from data section yet.
  initialize();
  global_data = 0x1234;
  mem_array[0] = 0x1111;
  mem_array[1] = 0x2222;
  mem_array[2] = 0x3333;
  mem_array[3] = 0x4444;

  uint16_t result = 0;
  uint16_t *ptr = (uint16_t *)mem_array;

  // Test 1: Symbolic addressing - add global_data to register
  // Use symbol name directly to force symbolic (PC-relative) addressing
  // objdump shows: add 0xXXXX, r12 ; PC rel. 0xYYYY
  __asm__ volatile("add.w global_data, %0\n" : "+r"(result) : : "cc", "memory");

  // Test 2: Autoincrement addressing - add @ptr+ to register
  // This should compile to: add @r13+, r12
  //   __asm__ volatile("add.w @%1+, %0\n"
  //                    : "+r"(result), "+r"(ptr)
  //                    :
  //                    : "cc", "memory");
  //
  // Test 3: Register to symbolic - add register to global variable
  // Use symbol name directly for destination
  // objdump shows: add r12, 0xXXXX ; PC rel. 0xYYYY
  // __asm__ volatile("add.w %0, global_data\n" : : "r"(result) : "cc",
  // "memory");
  // ---- Snapshot R13, R14, R15 and print them ----
  uint16_t r12v;
  __asm__ volatile("mov.w r12, %0\n\t" : "=r"(r12v) : : "cc");

  // Now it's safe to call printf; it won't affect the already-copied values.
  printf("r12=0x%04x\n", (unsigned)r12v);

  return result;
}
