
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_20bit_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;
    4008:	b0 12 26 40 	call	#16422		;#0x4026

0000400c <__crt0_call_exit>:
    400c:	b0 12 3e 40 	call	#16446		;#0x403e

00004010 <test_20bit_operations>:
    4010:	8c 01 45 23 	mova	#74565,	r12	;0x12345
    4014:	8d 0a de bc 	mova	#-344866,r13	;0xfffabcde
    4018:	1d 14       	pushm.a	#2,	r13	;20-bit words
    401a:	8c 00 00 00 	mova	#0,	r12	;
    401e:	8d 00 00 00 	mova	#0,	r13	;
    4022:	1c 16       	popm.a	#2,	r13	;20-bit words
    4024:	30 41       	ret			

00004026 <main>:
    4026:	8c 01 45 23 	mova	#74565,	r12	;0x12345
    402a:	8d 0a de bc 	mova	#-344866,r13	;0xfffabcde
    402e:	1d 14       	pushm.a	#2,	r13	;20-bit words
    4030:	8c 00 00 00 	mova	#0,	r12	;
    4034:	8d 00 00 00 	mova	#0,	r13	;
    4038:	1c 16       	popm.a	#2,	r13	;20-bit words
    403a:	4c 43       	clr.b	r12		;
    403c:	30 41       	ret			

0000403e <_exit>:
    403e:	ff 3f       	jmp	$+0      	;abs 0x403e
