; Test indexed addressing with various offsets
; Expected: values stored at stack offsets should be read back correctly

        .section .text
        .global _start
_start:
        ; Initialize stack pointer
        mov     #0x2c00, r1

        ; Allocate 40 bytes on stack
        sub     #40, r1         ; SP = 0x2bd8

        ; Store known values at different offsets
        mov     #0x1111, 0(r1)   ; offset 0
        mov     #0x2222, 10(r1)  ; offset 10
        mov     #0x3333, 20(r1)  ; offset 20
        mov     #0x4444, 30(r1)  ; offset 30
        mov     #0x5555, 38(r1)  ; offset 38

        ; Read back values into registers
        mov     0(r1), r4        ; Should be 0x1111
        mov     10(r1), r5       ; Should be 0x2222
        mov     20(r1), r6       ; Should be 0x3333
        mov     30(r1), r7       ; Should be 0x4444
        mov     38(r1), r8       ; Should be 0x5555

        ; Store results to noinit section for checking
        mov     r4, &0x1c00      ; result_0
        mov     r5, &0x1c02      ; result_10
        mov     r6, &0x1c04      ; result_20
        mov     r7, &0x1c06      ; result_30
        mov     r8, &0x1c08      ; result_38

_exit:
        jmp     _exit            ; Infinite loop
