	.file	"special_function_call_benchmark.c"
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
 ; 207 "include/setup.h" 1
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
 ; 221 "include/setup.h" 1
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
 ; 336 "include/setup.h" 1
	bic #0x0107, r2
 ; 0 "" 2
	; start of epilogue
	RET
	.size	initialize, .-initialize
	.global	__mspabi_divu
	.global	__mspabi_divi
	.global	__mspabi_divli
	.global	__mspabi_mpyi
	.global	__mspabi_mpyl
	.global	__mspabi_remu
	.balign 2
	.global	main
	.type	main, @function
main:
; start of function
; framesize_regs:     2
; framesize_locals:   32
; framesize_outgoing: 0
; framesize:          34
; elim ap -> fp       4
; elim fp -> sp       32
; saved regs: R10
	; start of prologue
	PUSH	R10
	SUB.W	#32, R1
	; end of prologue
	CALL	#initialize
	CALL	#begin_measurement_window
	CALL	#begin_event
	MOV.W	#-1, @R1
	MOV.W	#1, 2(R1)
	MOV.B	#100, R10
.L21:
	MOV.W	@R1, R12
	MOV.W	2(R1), R13
	CALL	#__mspabi_divu
	MOV.W	R12, &sink16
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L21
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-32767, 4(R1)
	MOV.W	#1, 6(R1)
	MOV.B	#100, R10
.L22:
	MOV.W	4(R1), R12
	MOV.W	6(R1), R13
	CALL	#__mspabi_divi
	MOV.W	R12, &sink16
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L22
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 16(R1)
	MOV.W	#32767, 18(R1)
	MOV.W	#1, 20(R1)
	MOV.W	#0, 22(R1)
	MOV.B	#100, R10
.L23:
	MOV.W	16(R1), R12
	MOV.W	18(R1), R13
	MOV.W	20(R1), R14
	MOV.W	22(R1), R15
	CALL	#__mspabi_divli
	MOV.W	R12, &sink32
	MOV.W	R13, &sink32+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L23
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 8(R1)
	MOV.W	#-1, 10(R1)
	MOV.B	#100, R10
.L24:
	MOV.W	8(R1), R12
	MOV.W	10(R1), R13
	CALL	#__mspabi_mpyi
	MOV.W	R12, &sink16
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L24
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 24(R1)
	MOV.W	#-1, 26(R1)
	MOV.W	#-1, 28(R1)
	MOV.W	#-1, 30(R1)
	MOV.B	#100, R10
.L25:
	MOV.W	24(R1), R12
	MOV.W	26(R1), R13
	MOV.W	28(R1), R14
	MOV.W	30(R1), R15
	CALL	#__mspabi_mpyl
	MOV.W	R12, &sink32
	MOV.W	R13, &sink32+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L25
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 12(R1)
	MOV.W	#1, 14(R1)
	MOV.B	#100, R10
.L26:
	MOV.W	12(R1), R12
	MOV.W	14(R1), R13
	CALL	#__mspabi_remu
	MOV.W	R12, &sink16
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L26
	CALL	#end_event
	CALL	#end_measurement_window
	MOV.B	#0, R12
	; start of epilogue
	.refsym	__crt0_call_exit
	ADD.W	#32, R1
	POP	R10
	RET
	.size	main, .-main
	.local	sink32
	.comm	sink32,4,2
	.local	sink16
	.comm	sink16,2,2
	.ident	"GCC: (Mitto Systems Limited - msp430-gcc 9.3.1.11) 9.3.1"
	.mspabi_attribute 4, 2
	.mspabi_attribute 6, 1
	.mspabi_attribute 8, 1
	.gnu_attribute 4, 1
