.text
.global main
.global _exit

# Exercise RRC (word and byte) with different carry states and RRAx under RPT.
main:
    # RRC on word: start 0x8001, then rotate with C cleared and set.
    mov     #0x8001, r14
    clrc
    rrc     r14             # expect 0x4000, C=1
    setc
    rrc     r14             # expect 0xa000, C=0

    # RRC on byte at memory: verify carry/byte behavior.
    mov     #memval, r12
    mov.b   #0xff, 0(r12)   # memval = 0xff
    clrc
    rrc.b   0(r12)          # expect 0x7f, C=1 if byte rotate uses bit0
    mov.b   0(r12), r15     # capture byte result

    # RRAx under RPT to stress sign extension/count logic.
    mov     #0xffff, r13
    mov     #0xffff, r12
    rpt     #3 { rrax.w r12 }

    br      #_exit

_exit:
    jmp     _exit

.data
memval:
    .word 0x0000
