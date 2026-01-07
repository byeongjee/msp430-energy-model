
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_add_wrap_address_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;
    4008:	b0 12 10 40 	call	#16400		;#0x4010

0000400c <__crt0_call_exit>:
    400c:	b0 12 1c 40 	call	#16412		;#0x401c

00004010 <main>:
    4010:	84 0f ff ff 	mova	#-1,	r4	;0xffffffff
    4014:	a4 00 01 00 	adda	#1,	r4	;
    4018:	4c 43       	clr.b	r12		;
    401a:	30 41       	ret			

0000401c <_exit>:
    401c:	ff 3f       	jmp	$+0      	;abs 0x401c
