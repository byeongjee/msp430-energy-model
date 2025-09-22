#include <msp430.h>

int main(void) {
    int sum = 0;
    int i;
    for (i = 1; i <= 5; i++) {
        sum += i;
    }
    return sum;
}