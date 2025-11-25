
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_eint.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;

00004008 <.Loc.254.1>:
    4008:	b0 12 5c 41 	call	#16732		;#0x415c

0000400c <__crt0_call_exit>:
    400c:	b0 12 6a 41 	call	#16746		;#0x416a

00004010 <clockSetup>:
    4010:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4014:	61 01 

00004016 <.Loc.13.1>:
    4016:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00

0000401a <.Loc.15.1>:
    401a:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    401e:	64 01 

00004020 <.Loc.20.1>:
    4020:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4024:	66 01 

00004026 <.Loc.21.1>:
    4026:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    402a:	62 01 

0000402c <.Loc.23.1>:
    402c:	0d 14       	pushm.a	#1,	r13	;20-bit words
    402e:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004032 <.L1^B1>:
    4032:	1d 83       	dec	r13		;
    4034:	fe 23       	jnz	$-2      	;abs 0x4032
    4036:	0d 16       	popm.a	#1,	r13	;20-bit words

00004038 <L0^A>:
    4038:	00 3c       	jmp	$+2      	;abs 0x403a

0000403a <.Loc.26.1>:
    403a:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00

0000403e <.Loc.29.1>:
    403e:	1c 42 68 01 	mov	&0x0168,r12	;0x0168
    4042:	3c c2       	bic	#8,	r12	;r2 As==11
    4044:	82 4c 68 01 	mov	r12,	&0x0168	;

00004048 <.Loc.30.1>:
    4048:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00

0000404c <.Loc.31.1>:
    404c:	03 43       	nop			
    404e:	30 41       	ret			

00004050 <toggle_gpio>:
    4050:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4054:	7c e2       	xor.b	#8,	r12	;r2 As==11
    4056:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    405a:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

0000405e <.Loc.33.1>:
    405e:	03 43       	nop			
    4060:	30 41       	ret			

00004062 <begin_event>:
    4062:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4064:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4068:	3e 40 05 00 	mov	#5,	r14	;

0000406c <.L1^B2>:
    406c:	1d 83       	dec	r13		;
    406e:	0e 73       	sbc	r14		;
    4070:	fd 23       	jnz	$-4      	;abs 0x406c
    4072:	0d 93       	cmp	#0,	r13	;r3 As==00
    4074:	fb 23       	jnz	$-8      	;abs 0x406c
    4076:	1d 16       	popm.a	#2,	r14	;20-bit words

00004078 <.Loc.37.1>:
    4078:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    407c:	7c d2       	bis.b	#8,	r12	;r2 As==11
    407e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4082:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004086 <.Loc.38.1>:
    4086:	03 43       	nop			
    4088:	30 41       	ret			

0000408a <end_event>:
    408a:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    408e:	7c c2       	bic.b	#8,	r12	;r2 As==11
    4090:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4094:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004098 <.Loc.41.1>:
    4098:	1e 14       	pushm.a	#2,	r14	;20-bit words
    409a:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    409e:	3e 40 05 00 	mov	#5,	r14	;

000040a2 <.L1^B3>:
    40a2:	1d 83       	dec	r13		;
    40a4:	0e 73       	sbc	r14		;
    40a6:	fd 23       	jnz	$-4      	;abs 0x40a2
    40a8:	0d 93       	cmp	#0,	r13	;r3 As==00
    40aa:	fb 23       	jnz	$-8      	;abs 0x40a2
    40ac:	1d 16       	popm.a	#2,	r14	;20-bit words

000040ae <.Loc.42.1>:
    40ae:	03 43       	nop			
    40b0:	30 41       	ret			

000040b2 <begin_measurement_window>:
    40b2:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40b4:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40b8:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000040bc <.L1^B4>:
    40bc:	1d 83       	dec	r13		;
    40be:	0e 73       	sbc	r14		;
    40c0:	fd 23       	jnz	$-4      	;abs 0x40bc
    40c2:	0d 93       	cmp	#0,	r13	;r3 As==00
    40c4:	fb 23       	jnz	$-8      	;abs 0x40bc
    40c6:	1d 16       	popm.a	#2,	r14	;20-bit words

000040c8 <.Loc.46.1>:
    40c8:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    40cc:	6c d2       	bis.b	#4,	r12	;r2 As==10
    40ce:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    40d2:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000040d6 <.Loc.47.1>:
    40d6:	03 43       	nop			
    40d8:	30 41       	ret			

000040da <end_measurement_window>:
    40da:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    40de:	6c c2       	bic.b	#4,	r12	;r2 As==10
    40e0:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    40e4:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000040e8 <.Loc.50.1>:
    40e8:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40ea:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40ee:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000040f2 <.L1^B5>:
    40f2:	1d 83       	dec	r13		;
    40f4:	0e 73       	sbc	r14		;
    40f6:	fd 23       	jnz	$-4      	;abs 0x40f2
    40f8:	0d 93       	cmp	#0,	r13	;r3 As==00
    40fa:	fb 23       	jnz	$-8      	;abs 0x40f2
    40fc:	1d 16       	popm.a	#2,	r14	;20-bit words

000040fe <.Loc.51.1>:
    40fe:	03 43       	nop			
    4100:	30 41       	ret			

00004102 <initialize>:
    4102:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    4106:	5c 01 

00004108 <.Loc.136.1>:
    4108:	1c 42 30 01 	mov	&0x0130,r12	;0x0130
    410c:	1c c3       	bic	#1,	r12	;r3 As==01
    410e:	82 4c 30 01 	mov	r12,	&0x0130	;

00004112 <.Loc.138.1>:
    4112:	b0 12 10 40 	call	#16400		;#0x4010

00004116 <.Loc.141.1>:
    4116:	5c 42 04 02 	mov.b	&0x0204,r12	;0x0204
    411a:	7c d0 0c 00 	bis.b	#12,	r12	;#0x000c
    411e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4122:	c2 4c 04 02 	mov.b	r12,	&0x0204	;

00004126 <.Loc.142.1>:
    4126:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    412a:	7c c2       	bic.b	#8,	r12	;r2 As==11
    412c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4130:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004134 <.Loc.143.1>:
    4134:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4138:	6c c2       	bic.b	#4,	r12	;r2 As==10
    413a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    413e:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004142 <.Loc.145.1>:
    4142:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4144:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    4148:	3e 40 30 01 	mov	#304,	r14	;#0x0130

0000414c <.L1^B6>:
    414c:	1d 83       	dec	r13		;
    414e:	0e 73       	sbc	r14		;
    4150:	fd 23       	jnz	$-4      	;abs 0x414c
    4152:	0d 93       	cmp	#0,	r13	;r3 As==00
    4154:	fb 23       	jnz	$-8      	;abs 0x414c
    4156:	1d 16       	popm.a	#2,	r14	;20-bit words

00004158 <.Loc.155.1>:
    4158:	03 43       	nop			
    415a:	30 41       	ret			

0000415c <main>:
    415c:	b0 12 02 41 	call	#16642		;#0x4102

00004160 <.Loc.7.2>:
    4160:	03 43       	nop			
    4162:	32 d2       	eint			
    4164:	03 43       	nop			

00004166 <.Loc.9.2>:
    4166:	4c 43       	clr.b	r12		;

00004168 <.Loc.10.2>:
    4168:	30 41       	ret			

0000416a <_exit>:
    416a:	ff 3f       	jmp	$+0      	;abs 0x416a
