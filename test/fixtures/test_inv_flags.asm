
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_inv_flags_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 06 00 	mov	#6,	r14	;
    4010:	b0 12 66 40 	call	#16486		;#0x4066

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 64 40 	call	#16484		;#0x4064

0000401e <main>:
    401e:	05 15       	pushm	#1,	r5	;16-bit words
    4020:	35 40 00 80 	mov	#-32768,r5	;#0x8000
    4024:	35 e3       	inv	r5		;
    4026:	04 38       	jl	$+10     	;abs 0x4030
    4028:	b2 40 ef be 	mov	#-16657,&0x1c04	;#0xbeef
    402c:	04 1c 
    402e:	03 3c       	jmp	$+8      	;abs 0x4036

00004030 <v_neg_correct>:
    4030:	b2 40 fe ca 	mov	#-13570,&0x1c04	;#0xcafe
    4034:	04 1c 

00004036 <v_neg_done>:
    4036:	15 43       	mov	#1,	r5	;r3 As==01
    4038:	35 e3       	inv	r5		;
    403a:	04 38       	jl	$+10     	;abs 0x4044
    403c:	b2 40 ef be 	mov	#-16657,&0x1c02	;#0xbeef
    4040:	02 1c 
    4042:	03 3c       	jmp	$+8      	;abs 0x404a

00004044 <v_pos_correct>:
    4044:	b2 40 fe ca 	mov	#-13570,&0x1c02	;#0xcafe
    4048:	02 1c 

0000404a <v_pos_done>:
    404a:	15 43       	mov	#1,	r5	;r3 As==01
    404c:	35 e3       	inv	r5		;
    404e:	04 2c       	jc	$+10     	;abs 0x4058
    4050:	b2 40 ef be 	mov	#-16657,&0x1c00	;#0xbeef
    4054:	00 1c 
    4056:	03 3c       	jmp	$+8      	;abs 0x405e

00004058 <c_nonzero_correct>:
    4058:	b2 40 fe ca 	mov	#-13570,&0x1c00	;#0xcafe
    405c:	00 1c 

0000405e <c_nonzero_done>:
    405e:	4c 43       	clr.b	r12		;
    4060:	05 17       	popm	#1,	r5	;16-bit words
    4062:	30 41       	ret			

00004064 <_exit>:
    4064:	ff 3f       	jmp	$+0      	;abs 0x4064

00004066 <memset>:
    4066:	0e 5c       	add	r12,	r14	;
    4068:	0f 4c       	mov	r12,	r15	;
    406a:	0f 9e       	cmp	r14,	r15	;
    406c:	01 20       	jnz	$+4      	;abs 0x4070
    406e:	30 41       	ret			
    4070:	1f 53       	inc	r15		;
    4072:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4076:	f9 3f       	jmp	$-12     	;abs 0x406a
