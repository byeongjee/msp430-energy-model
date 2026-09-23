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
 ; 221 "include/setup.h" 1
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
 ; 235 "include/setup.h" 1
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
 ; 350 "include/setup.h" 1
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
	.global	__mspabi_remul
	.global	__mspabi_mpyll
	.global	__mspabi_addd
	.global	__mspabi_subd
	.global	__mspabi_mpyd
	.global	__mspabi_divd
	.global	__mspabi_addf
	.global	__mspabi_mpyf
	.global	__mspabi_divf
	.global	__mspabi_cvtdf
	.global	__mspabi_cvtfd
	.global	__mspabi_fltuld
	.global	__mspabi_fltulf
	.global	__mspabi_fixfli
	.balign 2
	.global	main
	.type	main, @function
main:
; start of function
; framesize_regs:     8
; framesize_locals:   184
; framesize_outgoing: 0
; framesize:          192
; elim ap -> fp       10
; elim fp -> sp       184
; saved regs: R7 R8 R9 R10
	; start of prologue
	PUSH	R10
	PUSH	R9
	PUSH	R8
	PUSH	R7
	SUB.W	#184, R1
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
	CALL	#begin_event
	MOV.W	#-1, 32(R1)
	MOV.W	#-1, 34(R1)
	MOV.W	#1, 36(R1)
	MOV.W	#0, 38(R1)
	MOV.B	#100, R10
.L27:
	MOV.W	32(R1), R12
	MOV.W	34(R1), R13
	MOV.W	36(R1), R14
	MOV.W	38(R1), R15
	CALL	#__mspabi_remul
	MOV.W	R12, &sink32
	MOV.W	R13, &sink32+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L27
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 80(R1)
	MOV.W	#-1, 82(R1)
	MOV.W	#-1, 84(R1)
	MOV.W	#-1, 86(R1)
	MOV.W	#-1, 88(R1)
	MOV.W	#-1, 90(R1)
	MOV.W	#-1, 92(R1)
	MOV.W	#-1, 94(R1)
	MOV.B	#100, R7
.L28:
	MOV.W	80(R1), R8
	MOV.W	82(R1), R9
	MOV.W	84(R1), R10
	MOV.W	86(R1), R11
	MOV.W	88(R1), R12
	MOV.W	90(R1), R13
	MOV.W	92(R1), R14
	MOV.W	94(R1), R15
	CALL	#__mspabi_mpyll
	MOV.W	R12, &sink64
	MOV.W	R13, &sink64+2
	MOV.W	R14, &sink64+4
	MOV.W	R15, &sink64+6
	ADD.W	#-1, R7
	CMP.W	#0, R7 { JNE	.L28
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 96(R1)
	MOV.W	#0, 98(R1)
	MOV.W	#0, 100(R1)
	MOV.W	#0, 102(R1)
	MOV.W	#2, 104(R1)
	MOV.W	#0, 106(R1)
	MOV.W	#0, 108(R1)
	MOV.W	#-32768, 110(R1)
	MOV.B	#100, R7
.L29:
	MOV.W	96(R1), R8
	MOV.W	98(R1), R9
	MOV.W	100(R1), R10
	MOV.W	102(R1), R11
	MOV.W	104(R1), R12
	MOV.W	106(R1), R13
	MOV.W	108(R1), R14
	MOV.W	110(R1), R15
	CALL	#__mspabi_addd
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	ADD.W	#-1, R7
	CMP.W	#0, R7 { JNE	.L29
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 112(R1)
	MOV.W	#0, 114(R1)
	MOV.W	#0, 116(R1)
	MOV.W	#0, 118(R1)
	MOV.W	#2, 120(R1)
	MOV.W	#0, 122(R1)
	MOV.W	#0, 124(R1)
	MOV.W	#0, 126(R1)
	MOV.B	#100, R7
.L30:
	MOV.W	112(R1), R8
	MOV.W	114(R1), R9
	MOV.W	116(R1), R10
	MOV.W	118(R1), R11
	MOV.W	120(R1), R12
	MOV.W	122(R1), R13
	MOV.W	124(R1), R14
	MOV.W	126(R1), R15
	CALL	#__mspabi_subd
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	ADD.W	#-1, R7
	CMP.W	#0, R7 { JNE	.L30
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 128(R1)
	MOV.W	#-1, 130(R1)
	MOV.W	#-1, 132(R1)
	MOV.W	#16319, 134(R1)
	MOV.W	#1, 136(R1)
	MOV.W	#0, 138(R1)
	MOV.W	#0, 140(R1)
	MOV.W	#0, 142(R1)
	MOV.B	#100, R7
.L31:
	MOV.W	128(R1), R8
	MOV.W	130(R1), R9
	MOV.W	132(R1), R10
	MOV.W	134(R1), R11
	MOV.W	136(R1), R12
	MOV.W	138(R1), R13
	MOV.W	140(R1), R14
	MOV.W	142(R1), R15
	CALL	#__mspabi_mpyd
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	ADD.W	#-1, R7
	CMP.W	#0, R7 { JNE	.L31
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#15, 144(R1)
	MOV.W	#0, 146(R1)
	MOV.W	#0, 148(R1)
	MOV.W	#0, 150(R1)
	MOV.W	#31, 152(R1)
	MOV.W	#0, 154(R1)
	MOV.W	#0, 156(R1)
	MOV.W	#0, 158(R1)
	MOV.B	#100, R7
.L32:
	MOV.W	144(R1), R8
	MOV.W	146(R1), R9
	MOV.W	148(R1), R10
	MOV.W	150(R1), R11
	MOV.W	152(R1), R12
	MOV.W	154(R1), R13
	MOV.W	156(R1), R14
	MOV.W	158(R1), R15
	CALL	#__mspabi_divd
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	ADD.W	#-1, R7
	CMP.W	#0, R7 { JNE	.L32
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 40(R1)
	MOV.W	#0, 42(R1)
	MOV.W	#2, 44(R1)
	MOV.W	#-32768, 46(R1)
	MOV.B	#100, R10
.L33:
	MOV.W	40(R1), R12
	MOV.W	42(R1), R13
	MOV.W	44(R1), R14
	MOV.W	46(R1), R15
	CALL	#__mspabi_addf
	MOV.W	R12, &sinkf
	MOV.W	R13, &sinkf+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L33
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 48(R1)
	MOV.W	#16127, 50(R1)
	MOV.W	#1, 52(R1)
	MOV.W	#0, 54(R1)
	MOV.B	#100, R10
.L34:
	MOV.W	48(R1), R12
	MOV.W	50(R1), R13
	MOV.W	52(R1), R14
	MOV.W	54(R1), R15
	CALL	#__mspabi_mpyf
	MOV.W	R12, &sinkf
	MOV.W	R13, &sinkf+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L34
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 56(R1)
	MOV.W	#0, 58(R1)
	MOV.W	#-28477, 60(R1)
	MOV.W	#16384, 62(R1)
	MOV.B	#100, R10
.L35:
	MOV.W	56(R1), R12
	MOV.W	58(R1), R13
	MOV.W	60(R1), R14
	MOV.W	62(R1), R15
	CALL	#__mspabi_divf
	MOV.W	R12, &sinkf
	MOV.W	R13, &sinkf+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L35
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 160(R1)
	MOV.W	#0, 162(R1)
	MOV.W	#0, 164(R1)
	MOV.W	#0, 166(R1)
	MOV.B	#100, R10
.L36:
	MOV.W	160(R1), R12
	MOV.W	162(R1), R13
	MOV.W	164(R1), R14
	MOV.W	166(R1), R15
	CALL	#__mspabi_cvtdf
	MOV.W	R12, &sinkf
	MOV.W	R13, &sinkf+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L36
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 64(R1)
	MOV.W	#0, 66(R1)
	MOV.B	#100, R10
.L37:
	MOV.W	64(R1), R12
	MOV.W	66(R1), R13
	CALL	#__mspabi_cvtfd
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L37
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 68(R1)
	MOV.W	#0, 70(R1)
	MOV.B	#100, R10
.L38:
	MOV.W	68(R1), R12
	MOV.W	70(R1), R13
	CALL	#__mspabi_fltuld
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L38
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#0, 72(R1)
	MOV.W	#256, 74(R1)
	MOV.B	#100, R10
.L39:
	MOV.W	72(R1), R12
	MOV.W	74(R1), R13
	CALL	#__mspabi_fltulf
	MOV.W	R12, &sinkf
	MOV.W	R13, &sinkf+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L39
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#1, 76(R1)
	MOV.W	#0, 78(R1)
	MOV.B	#100, R10
.L40:
	MOV.W	76(R1), R12
	MOV.W	78(R1), R13
	CALL	#__mspabi_fixfli
	MOV.W	R12, &sink32
	MOV.W	R13, &sink32+2
	ADD.W	#-1, R10
	CMP.W	#0, R10 { JNE	.L40
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 168(R1)
	MOV.W	#-1, 170(R1)
	MOV.W	#-1, 172(R1)
	MOV.W	#32751, 174(R1)
	MOV.W	168(R1), R12
	MOV.W	170(R1), R13
	MOV.W	172(R1), R14
	MOV.W	174(R1), R15
	CALL	#cos
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	MOV.W	168(R1), R12
	MOV.W	170(R1), R13
	MOV.W	172(R1), R14
	MOV.W	174(R1), R15
	CALL	#cos
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	CALL	#end_event
	CALL	#begin_event
	MOV.W	#-1, 176(R1)
	MOV.W	#-1, 178(R1)
	MOV.W	#-1, 180(R1)
	MOV.W	#32751, 182(R1)
	MOV.W	176(R1), R12
	MOV.W	178(R1), R13
	MOV.W	180(R1), R14
	MOV.W	182(R1), R15
	CALL	#sin
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	MOV.W	176(R1), R12
	MOV.W	178(R1), R13
	MOV.W	180(R1), R14
	MOV.W	182(R1), R15
	CALL	#sin
	MOV.W	R12, &sinkd
	MOV.W	R13, &sinkd+2
	MOV.W	R14, &sinkd+4
	MOV.W	R15, &sinkd+6
	CALL	#end_event
	CALL	#end_measurement_window
	MOV.B	#0, R12
	; start of epilogue
	.refsym	__crt0_call_exit
	ADD.W	#184, R1
	BR	#__mspabi_func_epilog_4
	.size	main, .-main
	.local	sinkd
	.comm	sinkd,8,2
	.local	sinkf
	.comm	sinkf,4,2
	.local	sink64
	.comm	sink64,8,2
	.local	sink32
	.comm	sink32,4,2
	.local	sink16
	.comm	sink16,2,2
	.ident	"GCC: (Mitto Systems Limited - msp430-gcc 9.3.1.11) 9.3.1"
	.mspabi_attribute 4, 2
	.mspabi_attribute 6, 1
	.mspabi_attribute 8, 1
	.gnu_attribute 4, 1
