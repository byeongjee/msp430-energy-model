
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_rrc_flags_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 04 00 	mov	#4,	r14	;
    4010:	b0 12 58 40 	call	#16472		;#0x4058

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 56 40 	call	#16470		;#0x4056

0000401e <main>:
    401e:	05 15       	pushm	#1,	r5	;16-bit words
    4020:	12 d3       	setc			
    4022:	35 40 ff 7f 	mov	#32767,	r5	;#0x7fff
    4026:	05 10       	rrc	r5		;
    4028:	04 34       	jge	$+10     	;abs 0x4032
    402a:	b2 40 ef be 	mov	#-16657,&0x1c02	;#0xbeef
    402e:	02 1c 
    4030:	03 3c       	jmp	$+8      	;abs 0x4038

00004032 <rrc_v_correct>:
    4032:	b2 40 fe ca 	mov	#-13570,&0x1c02	;#0xcafe
    4036:	02 1c 

00004038 <rrc_v_done>:
    4038:	12 d3       	setc			
    403a:	35 40 00 80 	mov	#-32768,r5	;#0x8000
    403e:	05 10       	rrc	r5		;
    4040:	04 38       	jl	$+10     	;abs 0x404a
    4042:	b2 40 ef be 	mov	#-16657,&0x1c00	;#0xbeef
    4046:	00 1c 
    4048:	03 3c       	jmp	$+8      	;abs 0x4050

0000404a <rrc_v_neg_correct>:
    404a:	b2 40 fe ca 	mov	#-13570,&0x1c00	;#0xcafe
    404e:	00 1c 

00004050 <rrc_v_neg_done>:
    4050:	4c 43       	clr.b	r12		;
    4052:	05 17       	popm	#1,	r5	;16-bit words
    4054:	30 41       	ret			

00004056 <_exit>:
    4056:	ff 3f       	jmp	$+0      	;abs 0x4056

00004058 <memset>:
    4058:	0e 5c       	add	r12,	r14	;
    405a:	0f 4c       	mov	r12,	r15	;
    405c:	0f 9e       	cmp	r14,	r15	;
    405e:	01 20       	jnz	$+4      	;abs 0x4062
    4060:	30 41       	ret			
    4062:	1f 53       	inc	r15		;
    4064:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4068:	f9 3f       	jmp	$-12     	;abs 0x405c
