
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_rla_vflag_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 04 00 	mov	#4,	r14	;
    4010:	b0 12 54 40 	call	#16468		;#0x4054

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 52 40 	call	#16466		;#0x4052

0000401e <main>:
    401e:	05 15       	pushm	#1,	r5	;16-bit words
    4020:	35 40 00 40 	mov	#16384,	r5	;#0x4000
    4024:	05 55       	rla	r5		;
    4026:	04 34       	jge	$+10     	;abs 0x4030
    4028:	b2 40 ef be 	mov	#-16657,&0x1c02	;#0xbeef
    402c:	02 1c 
    402e:	03 3c       	jmp	$+8      	;abs 0x4036

00004030 <overflow_correct>:
    4030:	b2 40 fe ca 	mov	#-13570,&0x1c02	;#0xcafe
    4034:	02 1c 

00004036 <overflow_done>:
    4036:	35 40 00 20 	mov	#8192,	r5	;#0x2000
    403a:	05 55       	rla	r5		;
    403c:	04 38       	jl	$+10     	;abs 0x4046
    403e:	b2 40 fe ca 	mov	#-13570,&0x1c00	;#0xcafe
    4042:	00 1c 
    4044:	03 3c       	jmp	$+8      	;abs 0x404c

00004046 <no_overflow_bug>:
    4046:	b2 40 ef be 	mov	#-16657,&0x1c00	;#0xbeef
    404a:	00 1c 

0000404c <no_overflow_done>:
    404c:	4c 43       	clr.b	r12		;
    404e:	05 17       	popm	#1,	r5	;16-bit words
    4050:	30 41       	ret			

00004052 <_exit>:
    4052:	ff 3f       	jmp	$+0      	;abs 0x4052

00004054 <memset>:
    4054:	0e 5c       	add	r12,	r14	;
    4056:	0f 4c       	mov	r12,	r15	;
    4058:	0f 9e       	cmp	r14,	r15	;
    405a:	01 20       	jnz	$+4      	;abs 0x405e
    405c:	30 41       	ret			
    405e:	1f 53       	inc	r15		;
    4060:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4064:	f9 3f       	jmp	$-12     	;abs 0x4058
