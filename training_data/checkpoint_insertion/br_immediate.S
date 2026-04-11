	.file	"br_immediate_benchmark.c"
.text
	.balign 2
	.global	clockSetup
	.type	clockSetup, @function
clockSetup:
; start of function
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	MOV.W	#-23280, &FRCTL0
	MOV.B	#-91, &CSCTL0_H
	MOV.W	#0, &CSCTL1
	MOV.W	#307, &CSCTL2
	MOV.W	#546, &CSCTL3
	MOV.W	#72, &CSCTL1
	; Begin 60 cycle delay
	PUSH	r13
	MOV.W	#17, r13
1:	SUB.W	#1, r13
	JNE	1b
	POP	r13
	JMP	.+2
	; End 60 cycle delay
	MOV.W	#0, &CSCTL3
	BIC.W	#8, &CSCTL4
	MOV.B	#0, &CSCTL0_H
	; start of epilogue
	RET
	.size	clockSetup, .-clockSetup
	.balign 2
	.global	toggle_gpio
	.type	toggle_gpio, @function
toggle_gpio:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	XOR.B	#8, &P1OUT
	; start of epilogue
	RET
	.size	toggle_gpio, .-toggle_gpio
	.balign 2
	.global	begin_event
	.type	begin_event, @function
begin_event:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	; Begin 1600000 cycle delay
	PUSH	r13
	PUSH	r14
	MOV.W	#23164, r13
	MOV.W	#5, r14
1:	SUB.W	#1, r13
	SUBC.W	#0, r14
	JNE	1b
	TST.W	r13
	JNE	1b
	POP	r14
	POP	r13
	JMP	.+2
	; End 1600000 cycle delay
	BIS.B	#8, &P1OUT
	; start of epilogue
	RET
	.size	begin_event, .-begin_event
	.balign 2
	.global	end_event
	.type	end_event, @function
end_event:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	BIC.B	#8, &P1OUT
	; Begin 1600000 cycle delay
	PUSH	r13
	PUSH	r14
	MOV.W	#23164, r13
	MOV.W	#5, r14
1:	SUB.W	#1, r13
	SUBC.W	#0, r14
	JNE	1b
	TST.W	r13
	JNE	1b
	POP	r14
	POP	r13
	JMP	.+2
	; End 1600000 cycle delay
	; start of epilogue
	RET
	.size	end_event, .-end_event
	.balign 2
	.global	begin_measurement_window
	.type	begin_measurement_window, @function
begin_measurement_window:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	; Begin 80000000 cycle delay
	PUSH	r13
	PUSH	r14
	MOV.W	#27900, r13
	MOV.W	#304, r14
1:	SUB.W	#1, r13
	SUBC.W	#0, r14
	JNE	1b
	TST.W	r13
	JNE	1b
	POP	r14
	POP	r13
	JMP	.+2
	; End 80000000 cycle delay
	BIS.B	#4, &P1OUT
	; start of epilogue
	RET
	.size	begin_measurement_window, .-begin_measurement_window
	.balign 2
	.global	end_measurement_window
	.type	end_measurement_window, @function
end_measurement_window:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	BIC.B	#4, &P1OUT
	; Begin 80000000 cycle delay
	PUSH	r13
	PUSH	r14
	MOV.W	#27900, r13
	MOV.W	#304, r14
1:	SUB.W	#1, r13
	SUBC.W	#0, r14
	JNE	1b
	TST.W	r13
	JNE	1b
	POP	r14
	POP	r13
	JMP	.+2
	; End 80000000 cycle delay
	; start of epilogue
	RET
	.size	end_measurement_window, .-end_measurement_window
	.balign 2
	.global	delay
	.type	delay, @function
delay:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	MOV.W	R12, R14
	ADD	#-1, R14 ; cy
	MOV.W	R13, R15
	ADDC	#-1, R15
	MOV.W	R14, R12
	BIS.W	R15, R12
	CMP.W	#0, R12 { JEQ	.L8
.L11:
	; Begin 1 cycle delay
	NOP
	; End 1 cycle delay
	ADD	#-1, R14 ; cy
	ADDC	#-1, R15
	MOV.W	R14, R12
	BIS.W	R15, R12
	CMP.W	#0, R12 { JNE	.L11
.L8:
	; start of epilogue
	RET
	.size	delay, .-delay
	.balign 2
	.global	bench_empty_function
	.type	bench_empty_function, @function
bench_empty_function:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
 ; 210 "/Users/byeongjee/migration/probabilistic-energy-modeling//include/setup.h" 1
	nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop

 ; 0 "" 2
	; start of epilogue
	RET
	.size	bench_empty_function, .-bench_empty_function
	.balign 2
	.global	bench_empty_interrupt
	.type	bench_empty_interrupt, @function
bench_empty_interrupt:
; start of function
; attributes: naked 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
 ; 224 "/Users/byeongjee/migration/probabilistic-energy-modeling//include/setup.h" 1
	push r2
dint
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
reti

 ; 0 "" 2
	.size	bench_empty_interrupt, .-bench_empty_interrupt
	.balign 2
	.global	initialize
	.type	initialize, @function
initialize:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	MOV.W	#23168, &WDTCTL
	BIC.W	#1, &PM5CTL0
	MOV.W	#__text_sram_start, R12
	CMP.W	#__text_sram_end, R12 { JHS	.L19
	MOV.W	#__text_sram_end, R14
	SUB.W	R12, R14
	MOV.W	#__text_sram_load, R13
	CALL	#memcpy
.L19:
	MOV.W	#-23280, &FRCTL0
	MOV.B	#-91, &CSCTL0_H
	MOV.W	#0, &CSCTL1
	MOV.W	#307, &CSCTL2
	MOV.W	#546, &CSCTL3
	MOV.W	#72, &CSCTL1
	; Begin 60 cycle delay
	PUSH	r13
	MOV.W	#17, r13
1:	SUB.W	#1, r13
	JNE	1b
	POP	r13
	JMP	.+2
	; End 60 cycle delay
	MOV.W	#0, &CSCTL3
	BIC.W	#8, &CSCTL4
	MOV.B	#0, &CSCTL0_H
	BIS.B	#12, &P1DIR
	BIC.B	#8, &P1OUT
	BIC.B	#4, &P1OUT
	; Begin 160000000 cycle delay
	PUSH	r13
	PUSH	r14
	MOV.W	#39420, r13
	MOV.W	#609, r14
1:	SUB.W	#1, r13
	SUBC.W	#0, r14
	JNE	1b
	TST.W	r13
	JNE	1b
	POP	r14
	POP	r13
	JMP	.+2
	; End 160000000 cycle delay
 ; 339 "/Users/byeongjee/migration/probabilistic-energy-modeling//include/setup.h" 1
	bic #0x0107, r2
 ; 0 "" 2
	; start of epilogue
	RET
	.size	initialize, .-initialize
	.balign 2
	.global	main
	.type	main, @function
main:
; start of function
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	CALL	#initialize
	CALL	#begin_measurement_window
	CALL	#begin_event
 ; 4 "/Users/byeongjee/migration/probabilistic-energy-modeling/scripts/hardcoded_benchmarks/br_immediate_benchmark.c" 1
	mov #100, r13
bench_br_immediate_outer_loop:
bench_br_immediate_loop_header:
.rept 100 - 1
  .word 0x4030
  .word . + 2
.endr
  .word 0x4030
  .word bench_br_immediate_loop_footer
bench_br_immediate_loop_footer:
  add #-1, r13
  cmp #0, r13
  jne bench_br_immediate_outer_loop

 ; 0 "" 2
	CALL	#end_event
	CALL	#end_measurement_window
	MOV.B	#0, R12
	; start of epilogue
	.refsym	__crt0_call_exit
	RET
	.size	main, .-main
	.ident	"GCC: (Mitto Systems Limited - msp430-gcc 9.3.1.11) 9.3.1"
	.mspabi_attribute 4, 2
	.mspabi_attribute 6, 1
	.mspabi_attribute 8, 1
	.gnu_attribute 4, 1
