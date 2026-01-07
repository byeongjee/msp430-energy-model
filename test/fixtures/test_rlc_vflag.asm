
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_rlc_vflag_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 04 00 	mov	#4,	r14	;
    4010:	b0 12 64 40 	call	#16484		;#0x4064

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 62 40 	call	#16482		;#0x4062

0000401e <main>:
    401e:	05 15       	pushm	#1,	r5	;16-bit words
    4020:	15 43       	mov	#1,	r5	;r3 As==01
    4022:	05 93       	cmp	#0,	r5	;r3 As==00
    4024:	12 c3       	clrc			
    4026:	35 40 00 40 	mov	#16384,	r5	;#0x4000
    402a:	05 65       	rlc	r5		;
    402c:	04 34       	jge	$+10     	;abs 0x4036
    402e:	b2 40 ef be 	mov	#-16657,&0x1c02	;#0xbeef
    4032:	02 1c 
    4034:	03 3c       	jmp	$+8      	;abs 0x403c

00004036 <test1_correct>:
    4036:	b2 40 fe ca 	mov	#-13570,&0x1c02	;#0xcafe
    403a:	02 1c 

0000403c <test1_done>:
    403c:	35 40 ff 7f 	mov	#32767,	r5	;#0x7fff
    4040:	35 80 01 80 	sub	#-32767,r5	;#0x8001
    4044:	12 c3       	clrc			
    4046:	35 40 00 20 	mov	#8192,	r5	;#0x2000
    404a:	05 65       	rlc	r5		;
    404c:	04 34       	jge	$+10     	;abs 0x4056
    404e:	b2 40 ef be 	mov	#-16657,&0x1c00	;#0xbeef
    4052:	00 1c 
    4054:	03 3c       	jmp	$+8      	;abs 0x405c

00004056 <test2_correct>:
    4056:	b2 40 fe ca 	mov	#-13570,&0x1c00	;#0xcafe
    405a:	00 1c 

0000405c <test2_done>:
    405c:	4c 43       	clr.b	r12		;
    405e:	05 17       	popm	#1,	r5	;16-bit words
    4060:	30 41       	ret			

00004062 <_exit>:
    4062:	ff 3f       	jmp	$+0      	;abs 0x4062

00004064 <memset>:
    4064:	0e 5c       	add	r12,	r14	;
    4066:	0f 4c       	mov	r12,	r15	;
    4068:	0f 9e       	cmp	r14,	r15	;
    406a:	01 20       	jnz	$+4      	;abs 0x406e
    406c:	30 41       	ret			
    406e:	1f 53       	inc	r15		;
    4070:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4074:	f9 3f       	jmp	$-12     	;abs 0x4068
