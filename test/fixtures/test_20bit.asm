
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_20bit.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;

00004008 <.Loc.254.1>:
    4008:	b0 12 28 40 	call	#16424		;#0x4028

0000400c <__crt0_call_exit>:
    400c:	b0 12 30 40 	call	#16432		;#0x4030

00004010 <test_20bit_operations>:
    4010:	8c 01 45 23 	mova	#74565,	r12	;0x12345
    4014:	8d 0a de bc 	mova	#-344866,r13	;0xfffabcde
    4018:	1d 14       	pushm.a	#2,	r13	;20-bit words
    401a:	8c 00 00 00 	mova	#0,	r12	;
    401e:	8d 00 00 00 	mova	#0,	r13	;
    4022:	1c 16       	popm.a	#2,	r13	;20-bit words

00004024 <.Loc.36.1>:
    4024:	03 43       	nop			
    4026:	30 41       	ret			

00004028 <main>:
    4028:	b0 12 10 40 	call	#16400		;#0x4010

0000402c <.Loc.45.1>:
    402c:	4c 43       	clr.b	r12		;

0000402e <.Loc.46.1>:
    402e:	30 41       	ret			

00004030 <_exit>:
    4030:	ff 3f       	jmp	$+0      	;abs 0x4030
