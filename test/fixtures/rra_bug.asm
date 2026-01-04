
/Users/byeongjee/migration/probabilistic-energy-modeling/build/rra_bug_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;
    4008:	b0 12 10 40 	call	#16400		;#0x4010

0000400c <__crt0_call_exit>:
    400c:	b0 12 24 40 	call	#16420		;#0x4024

00004010 <main>:
    4010:	b2 43 02 1c 	mov	#-1,	&0x1c02	;r3 As==11
    4014:	1c 42 02 1c 	mov	&0x1c02,r12	;0x1c02
    4018:	0c 4c       	mov	r12,	r12	;
    401a:	0c 11       	rra	r12		;
    401c:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4020:	4c 43       	clr.b	r12		;
    4022:	30 41       	ret			

00004024 <_exit>:
    4024:	ff 3f       	jmp	$+0      	;abs 0x4024
