
/Users/byeongjee/migration/probabilistic-energy-modeling/build/simple.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;

00004008 <.Loc.254.1>:
    4008:	b0 12 10 40 	call	#16400		;#0x4010

0000400c <__crt0_call_exit>:
    400c:	b0 12 34 40 	call	#16436		;#0x4034

00004010 <main>:
    4010:	31 80 06 00 	sub	#6,	r1	;

00004014 <.LCFI0>:
    4014:	b1 40 0a 00 	mov	#10,	4(r1)	;#0x000a
    4018:	04 00 

0000401a <.Loc.5.1>:
    401a:	b1 40 14 00 	mov	#20,	2(r1)	;#0x0014
    401e:	02 00 

00004020 <.Loc.6.1>:
    4020:	1c 41 04 00 	mov	4(r1),	r12	;
    4024:	1c 51 02 00 	add	2(r1),	r12	;
    4028:	81 4c 00 00 	mov	r12,	0(r1)	;

0000402c <.Loc.7.1>:
    402c:	2c 41       	mov	@r1,	r12	;

0000402e <.Loc.8.1>:
    402e:	31 50 06 00 	add	#6,	r1	;

00004032 <.LCFI1>:
    4032:	30 41       	ret			

00004034 <_exit>:
    4034:	ff 3f       	jmp	$+0      	;abs 0x4034
