
/Users/byeongjee/migration/probabilistic-energy-modeling/build/arithmetic_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 04 00 	mov	#4,	r14	;
    4010:	b0 12 2c 40 	call	#16428		;#0x402c

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 2a 40 	call	#16426		;#0x402a

0000401e <main>:
    401e:	b2 42 02 1c 	mov	#8,	&0x1c02	;r2 As==11
    4022:	a2 43 00 1c 	mov	#2,	&0x1c00	;r3 As==10
    4026:	6c 43       	mov.b	#2,	r12	;r3 As==10
    4028:	30 41       	ret			

0000402a <_exit>:
    402a:	ff 3f       	jmp	$+0      	;abs 0x402a

0000402c <memset>:
    402c:	0e 5c       	add	r12,	r14	;
    402e:	0f 4c       	mov	r12,	r15	;
    4030:	0f 9e       	cmp	r14,	r15	;
    4032:	01 20       	jnz	$+4      	;abs 0x4036
    4034:	30 41       	ret			
    4036:	1f 53       	inc	r15		;
    4038:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    403c:	f9 3f       	jmp	$-12     	;abs 0x4030
