
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_addressing_modes.elf:     file format elf32-msp430


Disassembly of section .text:

0000400c <__crt0_start>:
    400c:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004010 <__crt0_movedata>:
    4010:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

00004014 <.Loc.116.1>:
    4014:	3d 40 00 40 	mov	#16384,	r13	;#0x4000

00004018 <.Loc.119.1>:
    4018:	0d 9c       	cmp	r12,	r13	;

0000401a <.Loc.120.1>:
    401a:	04 24       	jz	$+10     	;abs 0x4024

0000401c <.Loc.122.1>:
    401c:	3e 40 0a 00 	mov	#10,	r14	;#0x000a

00004020 <.Loc.124.1>:
    4020:	b0 12 86 40 	call	#16518		;#0x4086

00004024 <__crt0_call_main>:
    4024:	0c 43       	clr	r12		;

00004026 <.Loc.254.1>:
    4026:	b0 12 2e 40 	call	#16430		;#0x402e

0000402a <__crt0_call_exit>:
    402a:	b0 12 84 40 	call	#16516		;#0x4084

0000402e <main>:
    402e:	21 82       	sub	#4,	r1	;r2 As==10

00004030 <.LCFI0>:
    4030:	b2 40 34 12 	mov	#4660,	&0x1c00	;#0x1234
    4034:	00 1c 

00004036 <.Loc.11.1>:
    4036:	b2 40 11 11 	mov	#4369,	&0x1c02	;#0x1111
    403a:	02 1c 

0000403c <.Loc.12.1>:
    403c:	b2 40 22 22 	mov	#8738,	&0x1c04	;#0x2222
    4040:	04 1c 

00004042 <.Loc.13.1>:
    4042:	b2 40 33 33 	mov	#13107,	&0x1c06	;#0x3333
    4046:	06 1c 

00004048 <.Loc.14.1>:
    4048:	b2 40 44 44 	mov	#17476,	&0x1c08	;#0x4444
    404c:	08 1c 

0000404e <.Loc.16.1>:
    404e:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00

00004052 <.Loc.17.1>:
    4052:	b1 40 02 1c 	mov	#7170,	0(r1)	;#0x1c02
    4056:	00 00 

00004058 <.Loc.22.1>:
    4058:	1c 41 02 00 	mov	2(r1),	r12	;
    405c:	1c 50 a2 db 	add	0xdba2,	r12	;PC rel. 0x1c00
    4060:	81 4c 02 00 	mov	r12,	2(r1)	;

00004064 <.Loc.26.1>:
    4064:	1d 41 02 00 	mov	2(r1),	r13	;
    4068:	2c 41       	mov	@r1,	r12	;
    406a:	3d 5c       	add	@r12+,	r13	;
    406c:	81 4d 02 00 	mov	r13,	2(r1)	;
    4070:	81 4c 00 00 	mov	r12,	0(r1)	;

00004074 <.Loc.34.1>:
    4074:	1c 41 02 00 	mov	2(r1),	r12	;
    4078:	80 5c 86 db 	add	r12,	0xdb86	; PC rel. 0x1c00

0000407c <.Loc.36.1>:
    407c:	1c 41 02 00 	mov	2(r1),	r12	;

00004080 <.Loc.37.1>:
    4080:	21 52       	add	#4,	r1	;r2 As==10

00004082 <.LCFI1>:
    4082:	30 41       	ret			

00004084 <_exit>:
    4084:	ff 3f       	jmp	$+0      	;abs 0x4084

00004086 <memmove>:
    4086:	1a 15       	pushm	#2,	r10	;16-bit words

00004088 <L0^A>:
    4088:	0f 4d       	mov	r13,	r15	;
    408a:	0f 5e       	add	r14,	r15	;

0000408c <.Loc.69.1>:
    408c:	0d 9c       	cmp	r12,	r13	;
    408e:	02 2c       	jc	$+6      	;abs 0x4094

00004090 <.Loc.69.1>:
    4090:	0c 9f       	cmp	r15,	r12	;
    4092:	07 28       	jnc	$+16     	;abs 0x40a2

00004094 <.L2>:
    4094:	0e 4c       	mov	r12,	r14	;

00004096 <.L4>:
    4096:	0d 9f       	cmp	r15,	r13	;
    4098:	0a 24       	jz	$+22     	;abs 0x40ae

0000409a <.LVL3>:
    409a:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;

0000409e <.LVL4>:
    409e:	1e 53       	inc	r14		;
    40a0:	fa 3f       	jmp	$-10     	;abs 0x4096

000040a2 <.L3>:
    40a2:	09 4e       	mov	r14,	r9	;
    40a4:	39 e3       	inv	r9		;

000040a6 <.Loc.74.1>:
    40a6:	4d 43       	clr.b	r13		;

000040a8 <.L5>:
    40a8:	3d 53       	add	#-1,	r13	;r3 As==11

000040aa <.LVL7>:
    40aa:	09 9d       	cmp	r13,	r9	;
    40ac:	02 20       	jnz	$+6      	;abs 0x40b2

000040ae <.L9>:
    40ae:	19 17       	popm	#2,	r10	;16-bit words

000040b0 <.LCFI1>:
    40b0:	30 41       	ret			

000040b2 <.L6>:
    40b2:	0b 4e       	mov	r14,	r11	;
    40b4:	0b 5d       	add	r13,	r11	;
    40b6:	0b 5c       	add	r12,	r11	;
    40b8:	0a 4f       	mov	r15,	r10	;
    40ba:	0a 5d       	add	r13,	r10	;

000040bc <.LVL10>:
    40bc:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    40c0:	f3 3f       	jmp	$-24     	;abs 0x40a8
