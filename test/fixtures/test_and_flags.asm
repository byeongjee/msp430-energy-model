
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_and_flags_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 06 00 	mov	#6,	r14	;
    4010:	b0 12 6e 40 	call	#16494		;#0x406e

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 6c 40 	call	#16492		;#0x406c

0000401e <main>:
    401e:	05 15       	pushm	#1,	r5	;16-bit words
    4020:	35 40 ff 00 	mov	#255,	r5	;#0x00ff
    4024:	35 f0 0f 0f 	and	#3855,	r5	;#0x0f0f
    4028:	04 2c       	jc	$+10     	;abs 0x4032
    402a:	b2 40 ef be 	mov	#-16657,&0x1c04	;#0xbeef
    402e:	04 1c 
    4030:	03 3c       	jmp	$+8      	;abs 0x4038

00004032 <c_nonzero_set>:
    4032:	b2 40 fe ca 	mov	#-13570,&0x1c04	;#0xcafe
    4036:	04 1c 

00004038 <c_nonzero_done>:
    4038:	35 40 f0 00 	mov	#240,	r5	;#0x00f0
    403c:	35 f0 00 0f 	and	#3840,	r5	;#0x0f00
    4040:	04 28       	jnc	$+10     	;abs 0x404a
    4042:	b2 40 ef be 	mov	#-16657,&0x1c02	;#0xbeef
    4046:	02 1c 
    4048:	03 3c       	jmp	$+8      	;abs 0x4050

0000404a <c_zero_clear>:
    404a:	b2 40 fe ca 	mov	#-13570,&0x1c02	;#0xcafe
    404e:	02 1c 

00004050 <c_zero_done>:
    4050:	35 40 00 80 	mov	#-32768,r5	;#0x8000
    4054:	35 f3       	and	#-1,	r5	;r3 As==11
    4056:	04 38       	jl	$+10     	;abs 0x4060
    4058:	b2 40 ef be 	mov	#-16657,&0x1c00	;#0xbeef
    405c:	00 1c 
    405e:	03 3c       	jmp	$+8      	;abs 0x4066

00004060 <v_flag_clear>:
    4060:	b2 40 fe ca 	mov	#-13570,&0x1c00	;#0xcafe
    4064:	00 1c 

00004066 <v_flag_done>:
    4066:	4c 43       	clr.b	r12		;
    4068:	05 17       	popm	#1,	r5	;16-bit words
    406a:	30 41       	ret			

0000406c <_exit>:
    406c:	ff 3f       	jmp	$+0      	;abs 0x406c

0000406e <memset>:
    406e:	0e 5c       	add	r12,	r14	;
    4070:	0f 4c       	mov	r12,	r15	;
    4072:	0f 9e       	cmp	r14,	r15	;
    4074:	01 20       	jnz	$+4      	;abs 0x4078
    4076:	30 41       	ret			
    4078:	1f 53       	inc	r15		;
    407a:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    407e:	f9 3f       	jmp	$-12     	;abs 0x4072
