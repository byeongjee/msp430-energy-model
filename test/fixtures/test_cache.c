#include "setup.h"

NOINLINE void icache_cycle_same_set(void) {
  begin_event();
  register uint16_t n;
  __asm__ volatile("  jmp 1f\n"
                   "  .p2align 4\n"
                   "blockA_same:\n"
                   "  nop\n"
                   "  dec %[cnt]\n"
                   "  jne blockB_same\n"
                   "  jmp 2f\n"
                   "  .p2align 4\n"
                   "blockB_same:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  jmp blockC_same\n"
                   "  .p2align 4\n"
                   "blockC_same:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  jmp blockA_same\n"
                   "1:\n"
                   "  mov.w #2, %[cnt]\n"
                   "  jmp blockA_same\n"
                   "  .p2align 4\n"
                   "2:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   : [cnt] "=&r"(n)
                   :
                   : "cc", "memory");
  end_event();
}

NOINLINE void icache_cycle_split_set(void) {
  begin_event();
  register uint16_t n;
  __asm__ volatile("  jmp 1f\n"
                   "  .p2align 3\n"
                   "blockA_split:\n"
                   "  nop\n"
                   "  dec %[cnt]\n"
                   "  jne blockB_split\n"
                   "  jmp 2f\n"
                   "  .p2align 3\n"
                   "blockB_split:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  jmp blockC_split\n"
                   "  .p2align 3\n"
                   "blockC_split:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  jmp blockA_split\n"
                   "1:\n"
                   "  mov.w #2, %[cnt]\n"
                   "  jmp blockA_split\n"
                   "  .p2align 3\n"
                   "2:\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   "  nop\n"
                   : [cnt] "=&r"(n)
                   :
                   : "cc", "memory");
  end_event();
}

int main(void) {
  initialize();
  begin_measurement_window();
  icache_cycle_same_set();
  icache_cycle_split_set();
  end_measurement_window();
  return 0;
}
