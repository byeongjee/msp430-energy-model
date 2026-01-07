
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_pop_memory_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 02 00 	mov	#2,	r14	;
    4010:	b0 12 36 40 	call	#16438		;#0x4036

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 34 40 	call	#16436		;#0x4034

0000401e <main>:
    401e:	16 15       	pushm	#2,	r6	;16-bit words
    4020:	35 40 fe ca 	mov	#-13570,r5	;#0xcafe
    4024:	05 12       	push	r5		;
    4026:	36 40 00 1c 	mov	#7168,	r6	;#0x1c00
    402a:	b6 41 00 00 	pop	0(r6)		;
    402e:	4c 43       	clr.b	r12		;
    4030:	15 17       	popm	#2,	r6	;16-bit words
    4032:	30 41       	ret			

00004034 <_exit>:
    4034:	ff 3f       	jmp	$+0      	;abs 0x4034

00004036 <memset>:
    4036:	0e 5c       	add	r12,	r14	;
    4038:	0f 4c       	mov	r12,	r15	;
    403a:	0f 9e       	cmp	r14,	r15	;
    403c:	01 20       	jnz	$+4      	;abs 0x4040
    403e:	30 41       	ret			
    4040:	1f 53       	inc	r15		;
    4042:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4046:	f9 3f       	jmp	$-12     	;abs 0x403a
