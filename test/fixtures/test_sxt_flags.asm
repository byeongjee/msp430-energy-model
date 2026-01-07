
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_sxt_flags_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 06 00 	mov	#6,	r14	;
    4010:	b0 12 70 40 	call	#16496		;#0x4070

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 6e 40 	call	#16494		;#0x406e

0000401e <main>:
    401e:	16 15       	pushm	#2,	r6	;16-bit words
    4020:	35 40 ff 7f 	mov	#32767,	r5	;#0x7fff
    4024:	15 53       	inc	r5		;
    4026:	16 43       	mov	#1,	r6	;r3 As==01
    4028:	86 11       	sxt	r6		;
    402a:	00 30       	jn	$+2      	;abs 0x402c

0000402c <v_test_check>:
    402c:	04 34       	jge	$+10     	;abs 0x4036
    402e:	b2 40 ef be 	mov	#-16657,&0x1c04	;#0xbeef
    4032:	04 1c 
    4034:	03 3c       	jmp	$+8      	;abs 0x403c

00004036 <v_flag_correct>:
    4036:	b2 40 fe ca 	mov	#-13570,&0x1c04	;#0xcafe
    403a:	04 1c 

0000403c <v_done>:
    403c:	35 40 80 00 	mov	#128,	r5	;#0x0080
    4040:	85 11       	sxt	r5		;
    4042:	04 2c       	jc	$+10     	;abs 0x404c
    4044:	b2 40 ef be 	mov	#-16657,&0x1c02	;#0xbeef
    4048:	02 1c 
    404a:	03 3c       	jmp	$+8      	;abs 0x4052

0000404c <c_nonzero_correct>:
    404c:	b2 40 fe ca 	mov	#-13570,&0x1c02	;#0xcafe
    4050:	02 1c 

00004052 <c_nonzero_done>:
    4052:	12 d3       	setc			
    4054:	05 43       	clr	r5		;
    4056:	85 11       	sxt	r5		;
    4058:	04 28       	jnc	$+10     	;abs 0x4062
    405a:	b2 40 ef be 	mov	#-16657,&0x1c00	;#0xbeef
    405e:	00 1c 
    4060:	03 3c       	jmp	$+8      	;abs 0x4068

00004062 <c_zero_correct>:
    4062:	b2 40 fe ca 	mov	#-13570,&0x1c00	;#0xcafe
    4066:	00 1c 

00004068 <c_zero_done>:
    4068:	4c 43       	clr.b	r12		;
    406a:	15 17       	popm	#2,	r6	;16-bit words
    406c:	30 41       	ret			

0000406e <_exit>:
    406e:	ff 3f       	jmp	$+0      	;abs 0x406e

00004070 <memset>:
    4070:	0e 5c       	add	r12,	r14	;
    4072:	0f 4c       	mov	r12,	r15	;
    4074:	0f 9e       	cmp	r14,	r15	;
    4076:	01 20       	jnz	$+4      	;abs 0x407a
    4078:	30 41       	ret			
    407a:	1f 53       	inc	r15		;
    407c:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4080:	f9 3f       	jmp	$-12     	;abs 0x4074
