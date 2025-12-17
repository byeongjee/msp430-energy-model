
build/test_train_simple.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;

00004008 <.Loc.254.1>:
    4008:	b0 12 4e 41 	call	#16718		;#0x414e

0000400c <__crt0_call_exit>:
    400c:	b0 12 7a 41 	call	#16762		;#0x417a

00004010 <clockSetup>:
    4010:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4014:	61 01 
    4016:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    401a:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    401e:	64 01 
    4020:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4024:	66 01 
    4026:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    402a:	62 01 
    402c:	0d 14       	pushm.a	#1,	r13	;20-bit words
    402e:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004032 <.L1^B1>:
    4032:	1d 83       	dec	r13		;
    4034:	fe 23       	jnz	$-2      	;abs 0x4032
    4036:	0d 16       	popm.a	#1,	r13	;20-bit words

00004038 <L0^A>:
    4038:	00 3c       	jmp	$+2      	;abs 0x403a
    403a:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    403e:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4042:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4046:	30 41       	ret			

00004048 <toggle_gpio>:
    4048:	f2 e2 02 02 	xor.b	#8,	&0x0202	;r2 As==11
    404c:	30 41       	ret			

0000404e <begin_event>:
    404e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4050:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4054:	3e 40 05 00 	mov	#5,	r14	;

00004058 <.L1^B2>:
    4058:	1d 83       	dec	r13		;
    405a:	0e 73       	sbc	r14		;
    405c:	fd 23       	jnz	$-4      	;abs 0x4058
    405e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4060:	fb 23       	jnz	$-8      	;abs 0x4058
    4062:	1d 16       	popm.a	#2,	r14	;20-bit words
    4064:	f2 d2 02 02 	bis.b	#8,	&0x0202	;r2 As==11
    4068:	30 41       	ret			

0000406a <end_event>:
    406a:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    406e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4070:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4074:	3e 40 05 00 	mov	#5,	r14	;

00004078 <.L1^B3>:
    4078:	1d 83       	dec	r13		;
    407a:	0e 73       	sbc	r14		;
    407c:	fd 23       	jnz	$-4      	;abs 0x4078
    407e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4080:	fb 23       	jnz	$-8      	;abs 0x4078
    4082:	1d 16       	popm.a	#2,	r14	;20-bit words
    4084:	30 41       	ret			

00004086 <begin_measurement_window>:
    4086:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4088:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    408c:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004090 <.L1^B4>:
    4090:	1d 83       	dec	r13		;
    4092:	0e 73       	sbc	r14		;
    4094:	fd 23       	jnz	$-4      	;abs 0x4090
    4096:	0d 93       	cmp	#0,	r13	;r3 As==00
    4098:	fb 23       	jnz	$-8      	;abs 0x4090
    409a:	1d 16       	popm.a	#2,	r14	;20-bit words
    409c:	e2 d2 02 02 	bis.b	#4,	&0x0202	;r2 As==10
    40a0:	30 41       	ret			

000040a2 <end_measurement_window>:
    40a2:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    40a6:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40a8:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40ac:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000040b0 <.L1^B5>:
    40b0:	1d 83       	dec	r13		;
    40b2:	0e 73       	sbc	r14		;
    40b4:	fd 23       	jnz	$-4      	;abs 0x40b0
    40b6:	0d 93       	cmp	#0,	r13	;r3 As==00
    40b8:	fb 23       	jnz	$-8      	;abs 0x40b0
    40ba:	1d 16       	popm.a	#2,	r14	;20-bit words
    40bc:	30 41       	ret			

000040be <delay>:
    40be:	0e 4c       	mov	r12,	r14	;
    40c0:	3e 53       	add	#-1,	r14	;r3 As==11
    40c2:	0f 4d       	mov	r13,	r15	;
    40c4:	3f 63       	addc	#-1,	r15	;r3 As==11
    40c6:	0c 4e       	mov	r14,	r12	;
    40c8:	0c df       	bis	r15,	r12	;
    40ca:	0c 93       	cmp	#0,	r12	;r3 As==00
    40cc:	07 24       	jz	$+16     	;abs 0x40dc

000040ce <.L11>:
    40ce:	03 43       	nop			
    40d0:	3e 53       	add	#-1,	r14	;r3 As==11
    40d2:	3f 63       	addc	#-1,	r15	;r3 As==11
    40d4:	0c 4e       	mov	r14,	r12	;
    40d6:	0c df       	bis	r15,	r12	;
    40d8:	0c 93       	cmp	#0,	r12	;r3 As==00
    40da:	f9 23       	jnz	$-12     	;abs 0x40ce

000040dc <.L8>:
    40dc:	30 41       	ret			

000040de <bench_empty_function>:
    40de:	30 41       	ret			

000040e0 <bench_empty_interrupt>:
    40e0:	02 12       	push	r2		;
    40e2:	32 c2       	dint			
    40e4:	03 43       	nop			
    40e6:	00 13       	reti			

000040e8 <initialize>:
    40e8:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    40ec:	5c 01 
    40ee:	92 c3 30 01 	bic	#1,	&0x0130	;r3 As==01
    40f2:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    40f6:	61 01 
    40f8:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    40fc:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    4100:	64 01 
    4102:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4106:	66 01 
    4108:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    410c:	62 01 
    410e:	0d 14       	pushm.a	#1,	r13	;20-bit words
    4110:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004114 <.L1^B6>:
    4114:	1d 83       	dec	r13		;
    4116:	fe 23       	jnz	$-2      	;abs 0x4114
    4118:	0d 16       	popm.a	#1,	r13	;20-bit words

0000411a <L0^A>:
    411a:	00 3c       	jmp	$+2      	;abs 0x411c
    411c:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    4120:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4124:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4128:	f2 d0 0c 00 	bis.b	#12,	&0x0204	;#0x000c
    412c:	04 02 
    412e:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    4132:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    4136:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4138:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    413c:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004140 <.L1^B7>:
    4140:	1d 83       	dec	r13		;
    4142:	0e 73       	sbc	r14		;
    4144:	fd 23       	jnz	$-4      	;abs 0x4140
    4146:	0d 93       	cmp	#0,	r13	;r3 As==00
    4148:	fb 23       	jnz	$-8      	;abs 0x4140
    414a:	1d 16       	popm.a	#2,	r14	;20-bit words
    414c:	30 41       	ret			

0000414e <main>:
    414e:	21 83       	decd	r1		;
    4150:	b0 12 e8 40 	call	#16616		;#0x40e8
    4154:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    4158:	b0 12 86 40 	call	#16518		;#0x4086
    415c:	b0 12 4e 40 	call	#16462		;#0x404e
    4160:	b1 40 0a 00 	mov	#10,	0(r1)	;#0x000a
    4164:	00 00 
    4166:	b1 50 05 00 	add	#5,	0(r1)	;
    416a:	00 00 
    416c:	b0 12 6a 40 	call	#16490		;#0x406a
    4170:	b0 12 a2 40 	call	#16546		;#0x40a2
    4174:	4c 43       	clr.b	r12		;
    4176:	21 53       	incd	r1		;
    4178:	30 41       	ret			

0000417a <_exit>:
    417a:	ff 3f       	jmp	$+0      	;abs 0x417a
