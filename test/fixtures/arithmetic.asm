
/Users/byeongjee/migration/probabilistic-energy-modeling/build/arithmetic.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;

00004008 <.Loc.254.1>:
    4008:	b0 12 10 40 	call	#16400		;#0x4010

0000400c <__crt0_call_exit>:
    400c:	b0 12 3c 40 	call	#16444		;#0x403c

00004010 <main>:
    4010:	31 82       	sub	#8,	r1	;r2 As==11

00004012 <.LCFI0>:
    4012:	b1 40 05 00 	mov	#5,	6(r1)	;
    4016:	06 00 

00004018 <.Loc.5.1>:
    4018:	b1 40 03 00 	mov	#3,	4(r1)	;
    401c:	04 00 

0000401e <.Loc.6.1>:
    401e:	1c 41 06 00 	mov	6(r1),	r12	;
    4022:	1c 51 04 00 	add	4(r1),	r12	;
    4026:	81 4c 02 00 	mov	r12,	2(r1)	;

0000402a <.Loc.7.1>:
    402a:	1c 41 06 00 	mov	6(r1),	r12	;
    402e:	1c 81 04 00 	sub	4(r1),	r12	;
    4032:	81 4c 00 00 	mov	r12,	0(r1)	;

00004036 <.Loc.8.1>:
    4036:	2c 41       	mov	@r1,	r12	;

00004038 <.Loc.9.1>:
    4038:	31 52       	add	#8,	r1	;r2 As==11

0000403a <.LCFI1>:
    403a:	30 41       	ret			

0000403c <_exit>:
    403c:	ff 3f       	jmp	$+0      	;abs 0x403c
