
/Users/byeongjee/migration/probabilistic-energy-modeling/build/dadd_bcd_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 1c 00 	mov	#28,	r14	;#0x001c
    4010:	b0 12 de 40 	call	#16606		;#0x40de

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 dc 40 	call	#16604		;#0x40dc

0000401e <main>:
    401e:	7c 40 19 00 	mov.b	#25,	r12	;#0x0019
    4022:	0d 4c       	mov	r12,	r13	;
    4024:	12 c3       	clrc			
    4026:	1d a3       	dadd	#1,	r13	;r3 As==01
    4028:	82 4d 1a 1c 	mov	r13,	&0x1c1a	;
    402c:	7d 40 99 00 	mov.b	#153,	r13	;#0x0099
    4030:	12 c3       	clrc			
    4032:	1d a3       	dadd	#1,	r13	;r3 As==01
    4034:	82 4d 18 1c 	mov	r13,	&0x1c18	;
    4038:	12 d3       	setc			
    403a:	1c a3       	dadd	#1,	r12	;r3 As==01
    403c:	82 4c 16 1c 	mov	r12,	&0x1c16	;
    4040:	3c 40 99 09 	mov	#2457,	r12	;#0x0999
    4044:	12 c3       	clrc			
    4046:	1c a3       	dadd	#1,	r12	;r3 As==01
    4048:	82 4c 14 1c 	mov	r12,	&0x1c14	;
    404c:	3c 40 99 99 	mov	#-26215,r12	;#0x9999
    4050:	12 c3       	clrc			
    4052:	1c a3       	dadd	#1,	r12	;r3 As==01
    4054:	82 4c 12 1c 	mov	r12,	&0x1c12	;
    4058:	7c 40 19 00 	mov.b	#25,	r12	;#0x0019
    405c:	12 c3       	clrc			
    405e:	5c a3       	dadd.b	#1,	r12	;r3 As==01
    4060:	c2 4c 10 1c 	mov.b	r12,	&0x1c10	;
    4064:	7c 40 99 ff 	mov.b	#-103,	r12	;#0xff99
    4068:	12 c3       	clrc			
    406a:	5c a3       	dadd.b	#1,	r12	;r3 As==01
    406c:	c2 4c 0f 1c 	mov.b	r12,	&0x1c0f	;
    4070:	7c 40 09 00 	mov.b	#9,	r12	;
    4074:	12 c3       	clrc			
    4076:	7c a0 09 00 	dadd.b	#9,	r12	;
    407a:	c2 4c 0e 1c 	mov.b	r12,	&0x1c0e	;
    407e:	7c 40 45 00 	mov.b	#69,	r12	;#0x0045
    4082:	12 c3       	clrc			
    4084:	7c a0 27 00 	dadd.b	#39,	r12	;#0x0027
    4088:	c2 4c 0d 1c 	mov.b	r12,	&0x1c0d	;
    408c:	7c 40 50 00 	mov.b	#80,	r12	;#0x0050
    4090:	12 d3       	setc			
    4092:	7c a0 50 00 	dadd.b	#80,	r12	;#0x0050
    4096:	c2 4c 0c 1c 	mov.b	r12,	&0x1c0c	;
    409a:	3c 40 99 99 	mov	#-26215,r12	;#0x9999
    409e:	5d 43       	mov.b	#1,	r13	;r3 As==01
    40a0:	12 c3       	clrc			
    40a2:	00 18 5c a3 	daddx.a	#1,	r12	;r3 As==01
    40a6:	82 4c 08 1c 	mov	r12,	&0x1c08	;
    40aa:	82 4d 0a 1c 	mov	r13,	&0x1c0a	;
    40ae:	3c 40 99 99 	mov	#-26215,r12	;#0x9999
    40b2:	7d 40 09 00 	mov.b	#9,	r13	;
    40b6:	12 c3       	clrc			
    40b8:	00 18 5c a3 	daddx.a	#1,	r12	;r3 As==01
    40bc:	82 4c 04 1c 	mov	r12,	&0x1c04	;
    40c0:	82 4d 06 1c 	mov	r13,	&0x1c06	;
    40c4:	3c 40 45 23 	mov	#9029,	r12	;#0x2345
    40c8:	5d 43       	mov.b	#1,	r13	;r3 As==01
    40ca:	12 c3       	clrc			
    40cc:	00 18 5c a3 	daddx.a	#1,	r12	;r3 As==01
    40d0:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    40d4:	82 4d 02 1c 	mov	r13,	&0x1c02	;
    40d8:	4c 43       	clr.b	r12		;
    40da:	30 41       	ret			

000040dc <_exit>:
    40dc:	ff 3f       	jmp	$+0      	;abs 0x40dc

000040de <memset>:
    40de:	0e 5c       	add	r12,	r14	;
    40e0:	0f 4c       	mov	r12,	r15	;
    40e2:	0f 9e       	cmp	r14,	r15	;
    40e4:	01 20       	jnz	$+4      	;abs 0x40e8
    40e6:	30 41       	ret			
    40e8:	1f 53       	inc	r15		;
    40ea:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    40ee:	f9 3f       	jmp	$-12     	;abs 0x40e2
