#include <msp430.h>

int main(void) {
    int a = 10;
    int b = 5;
    int result;

    if (a > b) {
        result = a - b;
    } else {
        result = b - a;
    }

    return result;
}