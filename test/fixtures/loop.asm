
/Users/byeongjee/migration/probabilistic-energy-modeling/build/loop.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;

00004008 <.Loc.254.1>:
    4008:	b0 12 3e 41 	call	#16702		;#0x413e

0000400c <__crt0_call_exit>:
    400c:	b0 12 dc 41 	call	#16860		;#0x41dc

00004010 <clockSetup>:
    4010:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4014:	61 01 

00004016 <.Loc.9.1>:
    4016:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00

0000401a <.Loc.11.1>:
    401a:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    401e:	64 01 

00004020 <.Loc.16.1>:
    4020:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4024:	66 01 

00004026 <.Loc.17.1>:
    4026:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    402a:	62 01 

0000402c <.Loc.19.1>:
    402c:	0d 14       	pushm.a	#1,	r13	;20-bit words
    402e:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004032 <.L1^B1>:
    4032:	1d 83       	dec	r13		;
    4034:	fe 23       	jnz	$-2      	;abs 0x4032
    4036:	0d 16       	popm.a	#1,	r13	;20-bit words

00004038 <L0^A>:
    4038:	00 3c       	jmp	$+2      	;abs 0x403a

0000403a <.Loc.22.1>:
    403a:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00

0000403e <.Loc.25.1>:
    403e:	1c 42 68 01 	mov	&0x0168,r12	;0x0168
    4042:	3c c2       	bic	#8,	r12	;r2 As==11
    4044:	82 4c 68 01 	mov	r12,	&0x0168	;

00004048 <.Loc.26.1>:
    4048:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00

0000404c <.Loc.27.1>:
    404c:	03 43       	nop			
    404e:	30 41       	ret			

00004050 <toggle_gpio>:
    4050:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4054:	7c e2       	xor.b	#8,	r12	;r2 As==11
    4056:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    405a:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

0000405e <.Loc.29.1>:
    405e:	03 43       	nop			
    4060:	30 41       	ret			

00004062 <begin_event>:
    4062:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4064:	3d 40 fc 48 	mov	#18684,	r13	;#0x48fc
    4068:	3e 40 3c 00 	mov	#60,	r14	;#0x003c

0000406c <.L1^B2>:
    406c:	1d 83       	dec	r13		;
    406e:	0e 73       	sbc	r14		;
    4070:	fd 23       	jnz	$-4      	;abs 0x406c
    4072:	0d 93       	cmp	#0,	r13	;r3 As==00
    4074:	fb 23       	jnz	$-8      	;abs 0x406c
    4076:	1d 16       	popm.a	#2,	r14	;20-bit words

00004078 <.Loc.33.1>:
    4078:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    407c:	7c d2       	bis.b	#8,	r12	;r2 As==11
    407e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4082:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004086 <.Loc.34.1>:
    4086:	03 43       	nop			
    4088:	30 41       	ret			

0000408a <end_event>:
    408a:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    408e:	7c c2       	bic.b	#8,	r12	;r2 As==11
    4090:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4094:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004098 <.Loc.37.1>:
    4098:	1e 14       	pushm.a	#2,	r14	;20-bit words
    409a:	3d 40 fc 48 	mov	#18684,	r13	;#0x48fc
    409e:	3e 40 3c 00 	mov	#60,	r14	;#0x003c

000040a2 <.L1^B3>:
    40a2:	1d 83       	dec	r13		;
    40a4:	0e 73       	sbc	r14		;
    40a6:	fd 23       	jnz	$-4      	;abs 0x40a2
    40a8:	0d 93       	cmp	#0,	r13	;r3 As==00
    40aa:	fb 23       	jnz	$-8      	;abs 0x40a2
    40ac:	1d 16       	popm.a	#2,	r14	;20-bit words

000040ae <.Loc.38.1>:
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

000040c8 <.Loc.42.1>:
    40c8:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    40cc:	6c d2       	bis.b	#4,	r12	;r2 As==10
    40ce:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    40d2:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000040d6 <.Loc.43.1>:
    40d6:	03 43       	nop			
    40d8:	30 41       	ret			

000040da <end_measurement_window>:
    40da:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    40de:	6c c2       	bic.b	#4,	r12	;r2 As==10
    40e0:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    40e4:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000040e8 <.Loc.46.1>:
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

000040fe <.Loc.47.1>:
    40fe:	03 43       	nop			
    4100:	30 41       	ret			

00004102 <initialize>:
    4102:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    4106:	5c 01 

00004108 <.Loc.51.1>:
    4108:	1c 42 30 01 	mov	&0x0130,r12	;0x0130
    410c:	1c c3       	bic	#1,	r12	;r3 As==01
    410e:	82 4c 30 01 	mov	r12,	&0x0130	;

00004112 <.Loc.53.1>:
    4112:	b0 12 10 40 	call	#16400		;#0x4010

00004116 <.Loc.56.1>:
    4116:	5c 42 04 02 	mov.b	&0x0204,r12	;0x0204
    411a:	7c d2       	bis.b	#8,	r12	;r2 As==11
    411c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4120:	c2 4c 04 02 	mov.b	r12,	&0x0204	;

00004124 <.Loc.57.1>:
    4124:	5c 42 04 02 	mov.b	&0x0204,r12	;0x0204
    4128:	6c d2       	bis.b	#4,	r12	;r2 As==10
    412a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    412e:	c2 4c 04 02 	mov.b	r12,	&0x0204	;

00004132 <.Loc.58.1>:
    4132:	b0 12 8a 40 	call	#16522		;#0x408a

00004136 <.Loc.59.1>:
    4136:	b0 12 da 40 	call	#16602		;#0x40da

0000413a <.Loc.60.1>:
    413a:	03 43       	nop			
    413c:	30 41       	ret			

0000413e <main>:
    413e:	31 80 2e 00 	sub	#46,	r1	;#0x002e

00004142 <.LCFI0>:
    4142:	b0 12 02 41 	call	#16642		;#0x4102

00004146 <.Loc.9.2>:
    4146:	b0 12 b2 40 	call	#16562		;#0x40b2

0000414a <.LBB2>:
    414a:	81 43 2c 00 	mov	#0,	44(r1)	;r3 As==00, 0x002c

0000414e <.Loc.11.2>:
    414e:	37 3c       	jmp	$+112    	;abs 0x41be

00004150 <.L12>:
    4150:	b0 12 62 40 	call	#16482		;#0x4062

00004154 <.Loc.15.2>:
    4154:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00

00004158 <.Loc.16.2>:
    4158:	91 43 02 00 	mov	#1,	2(r1)	;r3 As==01

0000415c <.LBB3>:
    415c:	a1 43 2a 00 	mov	#2,	42(r1)	;r3 As==10, 0x002a

00004160 <.Loc.17.2>:
    4160:	25 3c       	jmp	$+76     	;abs 0x41ac

00004162 <.L11>:
    4162:	1c 41 2a 00 	mov	42(r1),	r12	;0x0002a
    4166:	3c 53       	add	#-1,	r12	;r3 As==11

00004168 <.Loc.18.2>:
    4168:	5c 02       	rlam	#1,	r12	;
    416a:	7d 40 2e 00 	mov.b	#46,	r13	;#0x002e
    416e:	0d 51       	add	r1,	r13	;
    4170:	0c 5d       	add	r13,	r12	;
    4172:	3c 50 d2 ff 	add	#-46,	r12	;#0xffd2
    4176:	2d 4c       	mov	@r12,	r13	;

00004178 <.Loc.18.2>:
    4178:	1c 41 2a 00 	mov	42(r1),	r12	;0x0002a
    417c:	3c 50 fe ff 	add	#-2,	r12	;#0xfffe

00004180 <.Loc.18.2>:
    4180:	5c 02       	rlam	#1,	r12	;
    4182:	7e 40 2e 00 	mov.b	#46,	r14	;#0x002e
    4186:	0e 51       	add	r1,	r14	;
    4188:	0c 5e       	add	r14,	r12	;
    418a:	3c 50 d2 ff 	add	#-46,	r12	;#0xffd2
    418e:	2c 4c       	mov	@r12,	r12	;

00004190 <.Loc.18.2>:
    4190:	0d 5c       	add	r12,	r13	;

00004192 <.Loc.18.2>:
    4192:	1c 41 2a 00 	mov	42(r1),	r12	;0x0002a
    4196:	5c 02       	rlam	#1,	r12	;
    4198:	7e 40 2e 00 	mov.b	#46,	r14	;#0x002e
    419c:	0e 51       	add	r1,	r14	;
    419e:	0c 5e       	add	r14,	r12	;
    41a0:	3c 50 d2 ff 	add	#-46,	r12	;#0xffd2
    41a4:	8c 4d 00 00 	mov	r13,	0(r12)	;

000041a8 <.Loc.17.2>:
    41a8:	91 53 2a 00 	inc	42(r1)		;

000041ac <.L10>:
    41ac:	7c 40 13 00 	mov.b	#19,	r12	;#0x0013
    41b0:	1c 91 2a 00 	cmp	42(r1),	r12	;0x0002a
    41b4:	d6 37       	jge	$-82     	;abs 0x4162

000041b6 <.LBE3>:
    41b6:	b0 12 8a 40 	call	#16522		;#0x408a

000041ba <.Loc.11.2>:
    41ba:	91 53 2c 00 	inc	44(r1)		;

000041be <.L9>:
    41be:	7c 40 09 00 	mov.b	#9,	r12	;
    41c2:	1c 91 2c 00 	cmp	44(r1),	r12	;0x0002c
    41c6:	c4 37       	jge	$-118    	;abs 0x4150

000041c8 <.LBE2>:
    41c8:	b0 12 da 40 	call	#16602		;#0x40da

000041cc <.Loc.26.2>:
    41cc:	91 41 26 00 	mov	38(r1),	40(r1)	;0x00026, 0x0028
    41d0:	28 00 

000041d2 <.Loc.27.2>:
    41d2:	1c 41 28 00 	mov	40(r1),	r12	;0x00028

000041d6 <.Loc.28.2>:
    41d6:	31 50 2e 00 	add	#46,	r1	;#0x002e

000041da <.LCFI1>:
    41da:	30 41       	ret			

000041dc <_exit>:
    41dc:	ff 3f       	jmp	$+0      	;abs 0x41dc
