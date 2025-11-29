
/Users/byeongjee/migration/probabilistic-energy-modeling/build/activity_recognition.elf:     file format elf32-msp430


Disassembly of section .text:

00004066 <__crt0_start>:
    4066:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

0000406a <__crt0_init_bss>:
    406a:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02

0000406e <.Loc.76.1>:
    406e:	0d 43       	clr	r13		;

00004070 <.Loc.77.1>:
    4070:	3e 40 82 00 	mov	#130,	r14	;#0x0082

00004074 <.Loc.81.1>:
    4074:	b0 12 6e 5e 	call	#24174		;#0x5e6e

00004078 <__crt0_movedata>:
    4078:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

0000407c <.Loc.116.1>:
    407c:	3d 40 62 40 	mov	#16482,	r13	;#0x4062

00004080 <.Loc.119.1>:
    4080:	0d 9c       	cmp	r12,	r13	;

00004082 <.Loc.120.1>:
    4082:	04 24       	jz	$+10     	;abs 0x408c

00004084 <.Loc.122.1>:
    4084:	3e 40 02 00 	mov	#2,	r14	;

00004088 <.Loc.124.1>:
    4088:	b0 12 32 5e 	call	#24114		;#0x5e32

0000408c <__crt0_call_main>:
    408c:	0c 43       	clr	r12		;

0000408e <.Loc.254.1>:
    408e:	b0 12 ca 41 	call	#16842		;#0x41ca

00004092 <__crt0_call_exit>:
    4092:	b0 12 30 5e 	call	#24112		;#0x5e30

00004096 <clockSetup>:
    4096:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    409a:	61 01 
    409c:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    40a0:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    40a4:	64 01 
    40a6:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    40aa:	66 01 
    40ac:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    40b0:	62 01 
    40b2:	0d 14       	pushm.a	#1,	r13	;20-bit words
    40b4:	3d 40 10 00 	mov	#16,	r13	;#0x0010

000040b8 <.L1^B1>:
    40b8:	1d 83       	dec	r13		;
    40ba:	fe 23       	jnz	$-2      	;abs 0x40b8
    40bc:	0d 16       	popm.a	#1,	r13	;20-bit words

000040be <L0^A>:
    40be:	00 3c       	jmp	$+2      	;abs 0x40c0
    40c0:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    40c4:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    40c8:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    40cc:	30 41       	ret			

000040ce <toggle_gpio>:
    40ce:	f2 e2 02 02 	xor.b	#8,	&0x0202	;r2 As==11
    40d2:	30 41       	ret			

000040d4 <begin_event>:
    40d4:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40d6:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    40da:	3e 40 05 00 	mov	#5,	r14	;

000040de <.L1^B2>:
    40de:	1d 83       	dec	r13		;
    40e0:	0e 73       	sbc	r14		;
    40e2:	fd 23       	jnz	$-4      	;abs 0x40de
    40e4:	0d 93       	cmp	#0,	r13	;r3 As==00
    40e6:	fb 23       	jnz	$-8      	;abs 0x40de
    40e8:	1d 16       	popm.a	#2,	r14	;20-bit words
    40ea:	f2 d2 02 02 	bis.b	#8,	&0x0202	;r2 As==11
    40ee:	30 41       	ret			

000040f0 <end_event>:
    40f0:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    40f4:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40f6:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    40fa:	3e 40 05 00 	mov	#5,	r14	;

000040fe <.L1^B3>:
    40fe:	1d 83       	dec	r13		;
    4100:	0e 73       	sbc	r14		;
    4102:	fd 23       	jnz	$-4      	;abs 0x40fe
    4104:	0d 93       	cmp	#0,	r13	;r3 As==00
    4106:	fb 23       	jnz	$-8      	;abs 0x40fe
    4108:	1d 16       	popm.a	#2,	r14	;20-bit words
    410a:	30 41       	ret			

0000410c <begin_measurement_window>:
    410c:	1e 14       	pushm.a	#2,	r14	;20-bit words
    410e:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    4112:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004116 <.L1^B4>:
    4116:	1d 83       	dec	r13		;
    4118:	0e 73       	sbc	r14		;
    411a:	fd 23       	jnz	$-4      	;abs 0x4116
    411c:	0d 93       	cmp	#0,	r13	;r3 As==00
    411e:	fb 23       	jnz	$-8      	;abs 0x4116
    4120:	1d 16       	popm.a	#2,	r14	;20-bit words
    4122:	e2 d2 02 02 	bis.b	#4,	&0x0202	;r2 As==10
    4126:	30 41       	ret			

00004128 <end_measurement_window>:
    4128:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    412c:	1e 14       	pushm.a	#2,	r14	;20-bit words
    412e:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    4132:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004136 <.L1^B5>:
    4136:	1d 83       	dec	r13		;
    4138:	0e 73       	sbc	r14		;
    413a:	fd 23       	jnz	$-4      	;abs 0x4136
    413c:	0d 93       	cmp	#0,	r13	;r3 As==00
    413e:	fb 23       	jnz	$-8      	;abs 0x4136
    4140:	1d 16       	popm.a	#2,	r14	;20-bit words
    4142:	30 41       	ret			

00004144 <delay>:
    4144:	0e 4c       	mov	r12,	r14	;
    4146:	3e 53       	add	#-1,	r14	;r3 As==11
    4148:	0f 4d       	mov	r13,	r15	;
    414a:	3f 63       	addc	#-1,	r15	;r3 As==11
    414c:	0c 4e       	mov	r14,	r12	;
    414e:	0c df       	bis	r15,	r12	;
    4150:	0c 93       	cmp	#0,	r12	;r3 As==00
    4152:	07 24       	jz	$+16     	;abs 0x4162

00004154 <.L11>:
    4154:	03 43       	nop			
    4156:	3e 53       	add	#-1,	r14	;r3 As==11
    4158:	3f 63       	addc	#-1,	r15	;r3 As==11
    415a:	0c 4e       	mov	r14,	r12	;
    415c:	0c df       	bis	r15,	r12	;
    415e:	0c 93       	cmp	#0,	r12	;r3 As==00
    4160:	f9 23       	jnz	$-12     	;abs 0x4154

00004162 <.L8>:
    4162:	30 41       	ret			

00004164 <initialize>:
    4164:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    4168:	5c 01 
    416a:	92 c3 30 01 	bic	#1,	&0x0130	;r3 As==01
    416e:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4172:	61 01 
    4174:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    4178:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    417c:	64 01 
    417e:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4182:	66 01 
    4184:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    4188:	62 01 
    418a:	0d 14       	pushm.a	#1,	r13	;20-bit words
    418c:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004190 <.L1^B6>:
    4190:	1d 83       	dec	r13		;
    4192:	fe 23       	jnz	$-2      	;abs 0x4190
    4194:	0d 16       	popm.a	#1,	r13	;20-bit words

00004196 <L0^A>:
    4196:	00 3c       	jmp	$+2      	;abs 0x4198
    4198:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    419c:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    41a0:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    41a4:	f2 d0 0c 00 	bis.b	#12,	&0x0204	;#0x000c
    41a8:	04 02 
    41aa:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    41ae:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    41b2:	1e 14       	pushm.a	#2,	r14	;20-bit words
    41b4:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    41b8:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000041bc <.L1^B7>:
    41bc:	1d 83       	dec	r13		;
    41be:	0e 73       	sbc	r14		;
    41c0:	fd 23       	jnz	$-4      	;abs 0x41bc
    41c2:	0d 93       	cmp	#0,	r13	;r3 As==00
    41c4:	fb 23       	jnz	$-8      	;abs 0x41bc
    41c6:	1d 16       	popm.a	#2,	r14	;20-bit words
    41c8:	30 41       	ret			

000041ca <main>:
    41ca:	6a 15       	pushm	#7,	r10	;16-bit words
    41cc:	31 80 26 00 	sub	#38,	r1	;#0x0026
    41d0:	b0 12 64 41 	call	#16740		;#0x4164
    41d4:	f2 d0 03 00 	bis.b	#3,	&0x0204	;
    41d8:	04 02 
    41da:	f2 f0 fc ff 	and.b	#-4,	&0x0202	;#0xfffc
    41de:	02 02 
    41e0:	03 43       	nop			
    41e2:	32 d2       	eint			
    41e4:	03 43       	nop			
    41e6:	b0 12 0c 41 	call	#16652		;#0x410c
    41ea:	82 43 82 1c 	mov	#0,	&0x1c82	;r3 As==00
    41ee:	b0 12 d4 40 	call	#16596		;#0x40d4
    41f2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    41f6:	1e 42 82 1c 	mov	&0x1c82,r14	;0x1c82
    41fa:	0d 4c       	mov	r12,	r13	;
    41fc:	5d f3       	and.b	#1,	r13	;r3 As==01
    41fe:	5c 03       	rrum	#1,	r12	;
    4200:	0d 93       	cmp	#0,	r13	;r3 As==00
    4202:	02 24       	jz	$+6      	;abs 0x4208
    4204:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004208 <.L27>:
    4208:	0d 4c       	mov	r12,	r13	;
    420a:	5d 03       	rrum	#1,	r13	;
    420c:	1c b3       	bit	#1,	r12	;r3 As==01
    420e:	02 24       	jz	$+6      	;abs 0x4214
    4210:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

00004214 <.L26>:
    4214:	0c 4d       	mov	r13,	r12	;
    4216:	5c 03       	rrum	#1,	r12	;
    4218:	1d b3       	bit	#1,	r13	;r3 As==01
    421a:	02 24       	jz	$+6      	;abs 0x4220
    421c:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004220 <.L21>:
    4220:	1e 42 82 1c 	mov	&0x1c82,r14	;0x1c82
    4224:	0d 4c       	mov	r12,	r13	;
    4226:	5d f3       	and.b	#1,	r13	;r3 As==01
    4228:	5c 03       	rrum	#1,	r12	;
    422a:	0d 93       	cmp	#0,	r13	;r3 As==00
    422c:	02 24       	jz	$+6      	;abs 0x4232
    422e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004232 <.L37>:
    4232:	0d 4c       	mov	r12,	r13	;
    4234:	5d 03       	rrum	#1,	r13	;
    4236:	1c b3       	bit	#1,	r12	;r3 As==01
    4238:	02 24       	jz	$+6      	;abs 0x423e
    423a:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

0000423e <.L36>:
    423e:	0c 4d       	mov	r13,	r12	;
    4240:	5c 03       	rrum	#1,	r12	;
    4242:	1d b3       	bit	#1,	r13	;r3 As==01
    4244:	02 24       	jz	$+6      	;abs 0x424a
    4246:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

0000424a <.L31>:
    424a:	1e 42 82 1c 	mov	&0x1c82,r14	;0x1c82
    424e:	0d 4c       	mov	r12,	r13	;
    4250:	5d f3       	and.b	#1,	r13	;r3 As==01
    4252:	5c 03       	rrum	#1,	r12	;
    4254:	0d 93       	cmp	#0,	r13	;r3 As==00
    4256:	02 24       	jz	$+6      	;abs 0x425c
    4258:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

0000425c <.L42>:
    425c:	0d 4c       	mov	r12,	r13	;
    425e:	5d 03       	rrum	#1,	r13	;
    4260:	1c b3       	bit	#1,	r12	;r3 As==01
    4262:	02 24       	jz	$+6      	;abs 0x4268
    4264:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

00004268 <.L43>:
    4268:	0a 4d       	mov	r13,	r10	;
    426a:	5a 03       	rrum	#1,	r10	;
    426c:	1d b3       	bit	#1,	r13	;r3 As==01
    426e:	02 24       	jz	$+6      	;abs 0x4274
    4270:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00004274 <.L41>:
    4274:	b1 40 02 1c 	mov	#7170,	12(r1)	;#0x1c02, 0x000c
    4278:	0c 00 

0000427a <.L44>:
    427a:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    427e:	0c 4a       	mov	r10,	r12	;
    4280:	5c f3       	and.b	#1,	r12	;r3 As==01
    4282:	5a 03       	rrum	#1,	r10	;
    4284:	0d 93       	cmp	#0,	r13	;r3 As==00
    4286:	02 20       	jnz	$+6      	;abs 0x428c
    4288:	80 00 8c 5c 	mova	#23692,	r0	;0x05c8c
    428c:	0c 93       	cmp	#0,	r12	;r3 As==00
    428e:	02 24       	jz	$+6      	;abs 0x4294
    4290:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00004294 <.L90>:
    4294:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4298:	0c 4a       	mov	r10,	r12	;
    429a:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    429e:	49 4c       	mov.b	r12,	r9	;
    42a0:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    42a4:	89 11       	sxt	r9		;
    42a6:	08 4a       	mov	r10,	r8	;
    42a8:	58 03       	rrum	#1,	r8	;
    42aa:	1a b3       	bit	#1,	r10	;r3 As==01
    42ac:	02 24       	jz	$+6      	;abs 0x42b2
    42ae:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

000042b2 <.L89>:
    42b2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    42b6:	0c 48       	mov	r8,	r12	;
    42b8:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    42bc:	46 4c       	mov.b	r12,	r6	;
    42be:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    42c2:	86 11       	sxt	r6		;
    42c4:	0a 48       	mov	r8,	r10	;
    42c6:	5a 03       	rrum	#1,	r10	;
    42c8:	18 b3       	bit	#1,	r8	;r3 As==01
    42ca:	02 24       	jz	$+6      	;abs 0x42d0
    42cc:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

000042d0 <.L88>:
    42d0:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    42d4:	0c 4a       	mov	r10,	r12	;
    42d6:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    42da:	47 4c       	mov.b	r12,	r7	;
    42dc:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    42e0:	87 11       	sxt	r7		;

000042e2 <.L87>:
    42e2:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    42e6:	0c 4a       	mov	r10,	r12	;
    42e8:	5c f3       	and.b	#1,	r12	;r3 As==01
    42ea:	5a 03       	rrum	#1,	r10	;
    42ec:	0d 93       	cmp	#0,	r13	;r3 As==00
    42ee:	02 20       	jnz	$+6      	;abs 0x42f4
    42f0:	80 00 38 5c 	mova	#23608,	r0	;0x05c38
    42f4:	0c 93       	cmp	#0,	r12	;r3 As==00
    42f6:	02 24       	jz	$+6      	;abs 0x42fc
    42f8:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

000042fc <.L104>:
    42fc:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4300:	0c 4a       	mov	r10,	r12	;
    4302:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4306:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    430a:	8c 11       	sxt	r12		;
    430c:	81 4c 04 00 	mov	r12,	4(r1)	;
    4310:	08 4a       	mov	r10,	r8	;
    4312:	58 03       	rrum	#1,	r8	;
    4314:	1a b3       	bit	#1,	r10	;r3 As==01
    4316:	02 24       	jz	$+6      	;abs 0x431c
    4318:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

0000431c <.L103>:
    431c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4320:	0c 48       	mov	r8,	r12	;
    4322:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4326:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    432a:	8c 11       	sxt	r12		;
    432c:	81 4c 08 00 	mov	r12,	8(r1)	;
    4330:	0a 48       	mov	r8,	r10	;
    4332:	5a 03       	rrum	#1,	r10	;
    4334:	18 b3       	bit	#1,	r8	;r3 As==01
    4336:	02 24       	jz	$+6      	;abs 0x433c
    4338:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

0000433c <.L102>:
    433c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4340:	0c 4a       	mov	r10,	r12	;
    4342:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4346:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    434a:	8c 11       	sxt	r12		;
    434c:	81 4c 14 00 	mov	r12,	20(r1)	; 0x0014

00004350 <.L101>:
    4350:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    4354:	0c 4a       	mov	r10,	r12	;
    4356:	5c f3       	and.b	#1,	r12	;r3 As==01
    4358:	5a 03       	rrum	#1,	r10	;
    435a:	0d 93       	cmp	#0,	r13	;r3 As==00
    435c:	02 20       	jnz	$+6      	;abs 0x4362
    435e:	80 00 e8 5b 	mova	#23528,	r0	;0x05be8
    4362:	0c 93       	cmp	#0,	r12	;r3 As==00
    4364:	02 24       	jz	$+6      	;abs 0x436a
    4366:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

0000436a <.L119>:
    436a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    436e:	0c 4a       	mov	r10,	r12	;
    4370:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4374:	4b 4c       	mov.b	r12,	r11	;
    4376:	7b 50 e2 ff 	add.b	#-30,	r11	;#0xffe2
    437a:	8b 11       	sxt	r11		;
    437c:	81 4b 0e 00 	mov	r11,	14(r1)	; 0x000e
    4380:	08 4a       	mov	r10,	r8	;
    4382:	58 03       	rrum	#1,	r8	;
    4384:	1a b3       	bit	#1,	r10	;r3 As==01
    4386:	02 24       	jz	$+6      	;abs 0x438c
    4388:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

0000438c <.L118>:
    438c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4390:	0c 48       	mov	r8,	r12	;
    4392:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4396:	44 4c       	mov.b	r12,	r4	;
    4398:	74 50 e2 ff 	add.b	#-30,	r4	;#0xffe2
    439c:	84 11       	sxt	r4		;
    439e:	0a 48       	mov	r8,	r10	;
    43a0:	5a 03       	rrum	#1,	r10	;
    43a2:	18 b3       	bit	#1,	r8	;r3 As==01
    43a4:	02 24       	jz	$+6      	;abs 0x43aa
    43a6:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

000043aa <.L484>:
    43aa:	82 4a 00 1c 	mov	r10,	&0x1c00	;
    43ae:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43b2:	0c 4a       	mov	r10,	r12	;
    43b4:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    43b8:	45 4c       	mov.b	r12,	r5	;
    43ba:	75 50 e2 ff 	add.b	#-30,	r5	;#0xffe2
    43be:	85 11       	sxt	r5		;

000043c0 <.L116>:
    43c0:	0d 49       	mov	r9,	r13	;
    43c2:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    43c6:	4c 4d       	mov.b	r13,	r12	;
    43c8:	4c e9       	xor.b	r9,	r12	;
    43ca:	4c 8d       	sub.b	r13,	r12	;
    43cc:	7b 40 09 00 	mov.b	#9,	r11	;
    43d0:	4b 9c       	cmp.b	r12,	r11	;
    43d2:	02 28       	jnc	$+6      	;abs 0x43d8
    43d4:	80 00 dc 5b 	mova	#23516,	r0	;0x05bdc
    43d8:	81 49 00 00 	mov	r9,	0(r1)	;
    43dc:	08 49       	mov	r9,	r8	;
    43de:	4e 18 09 11 	rpt #15 { rrax.w	r9		;

000043e2 <.L127>:
    43e2:	0c 46       	mov	r6,	r12	;
    43e4:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    43e8:	4d 4c       	mov.b	r12,	r13	;
    43ea:	4d e6       	xor.b	r6,	r13	;
    43ec:	4d 8c       	sub.b	r12,	r13	;
    43ee:	7b 40 09 00 	mov.b	#9,	r11	;
    43f2:	4b 9d       	cmp.b	r13,	r11	;
    43f4:	02 28       	jnc	$+6      	;abs 0x43fa
    43f6:	80 00 d0 5b 	mova	#23504,	r0	;0x05bd0
    43fa:	81 46 12 00 	mov	r6,	18(r1)	; 0x0012
    43fe:	0c 46       	mov	r6,	r12	;
    4400:	0d 46       	mov	r6,	r13	;
    4402:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;

00004406 <.L45>:
    4406:	0e 47       	mov	r7,	r14	;
    4408:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    440c:	4f 4e       	mov.b	r14,	r15	;
    440e:	4f e7       	xor.b	r7,	r15	;
    4410:	4f 8e       	sub.b	r14,	r15	;
    4412:	7e 40 09 00 	mov.b	#9,	r14	;
    4416:	4e 9f       	cmp.b	r15,	r14	;
    4418:	02 28       	jnc	$+6      	;abs 0x441e
    441a:	80 00 c4 5b 	mova	#23492,	r0	;0x05bc4
    441e:	81 47 16 00 	mov	r7,	22(r1)	; 0x0016
    4422:	06 47       	mov	r7,	r6	;
    4424:	4e 18 07 11 	rpt #15 { rrax.w	r7		;

00004428 <.L46>:
    4428:	1e 41 04 00 	mov	4(r1),	r14	;
    442c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4430:	1f 41 04 00 	mov	4(r1),	r15	;
    4434:	4f ee       	xor.b	r14,	r15	;
    4436:	4f 8e       	sub.b	r14,	r15	;
    4438:	81 43 18 00 	mov	#0,	24(r1)	;r3 As==00, 0x0018
    443c:	7b 40 09 00 	mov.b	#9,	r11	;
    4440:	4b 9f       	cmp.b	r15,	r11	;
    4442:	0e 2c       	jc	$+30     	;abs 0x4460
    4444:	91 41 04 00 	mov	4(r1),	24(r1)	; 0x0018
    4448:	18 00 
    444a:	1f 41 18 00 	mov	24(r1),	r15	;0x00018
    444e:	0e 4f       	mov	r15,	r14	;
    4450:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4454:	81 4e 04 00 	mov	r14,	4(r1)	;
    4458:	81 4f 06 00 	mov	r15,	6(r1)	;
    445c:	08 5e       	add	r14,	r8	;
    445e:	09 6f       	addc	r15,	r9	;

00004460 <.L47>:
    4460:	1e 41 08 00 	mov	8(r1),	r14	;
    4464:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4468:	1f 41 08 00 	mov	8(r1),	r15	;
    446c:	4f ee       	xor.b	r14,	r15	;
    446e:	4f 8e       	sub.b	r14,	r15	;
    4470:	81 43 1a 00 	mov	#0,	26(r1)	;r3 As==00, 0x001a
    4474:	7b 40 09 00 	mov.b	#9,	r11	;
    4478:	4b 9f       	cmp.b	r15,	r11	;
    447a:	0e 2c       	jc	$+30     	;abs 0x4498
    447c:	91 41 08 00 	mov	8(r1),	26(r1)	; 0x001a
    4480:	1a 00 
    4482:	1f 41 1a 00 	mov	26(r1),	r15	;0x0001a
    4486:	0e 4f       	mov	r15,	r14	;
    4488:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    448c:	81 4e 04 00 	mov	r14,	4(r1)	;
    4490:	81 4f 06 00 	mov	r15,	6(r1)	;
    4494:	0c 5e       	add	r14,	r12	;
    4496:	0d 6f       	addc	r15,	r13	;

00004498 <.L48>:
    4498:	1e 41 14 00 	mov	20(r1),	r14	;0x00014
    449c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44a0:	1f 41 14 00 	mov	20(r1),	r15	;0x00014
    44a4:	4f ee       	xor.b	r14,	r15	;
    44a6:	4f 8e       	sub.b	r14,	r15	;
    44a8:	81 43 1c 00 	mov	#0,	28(r1)	;r3 As==00, 0x001c
    44ac:	7b 40 09 00 	mov.b	#9,	r11	;
    44b0:	4b 9f       	cmp.b	r15,	r11	;
    44b2:	0e 2c       	jc	$+30     	;abs 0x44d0
    44b4:	91 41 14 00 	mov	20(r1),	28(r1)	;0x00014, 0x001c
    44b8:	1c 00 
    44ba:	1f 41 1c 00 	mov	28(r1),	r15	;0x0001c
    44be:	0e 4f       	mov	r15,	r14	;
    44c0:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    44c4:	81 4e 04 00 	mov	r14,	4(r1)	;
    44c8:	81 4f 06 00 	mov	r15,	6(r1)	;
    44cc:	06 5e       	add	r14,	r6	;
    44ce:	07 6f       	addc	r15,	r7	;

000044d0 <.L49>:
    44d0:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    44d4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44d8:	1f 41 0e 00 	mov	14(r1),	r15	;0x0000e
    44dc:	4f ee       	xor.b	r14,	r15	;
    44de:	4f 8e       	sub.b	r14,	r15	;
    44e0:	7b 40 09 00 	mov.b	#9,	r11	;
    44e4:	4b 9f       	cmp.b	r15,	r11	;
    44e6:	02 28       	jnc	$+6      	;abs 0x44ec
    44e8:	80 00 b4 5b 	mova	#23476,	r0	;0x05bb4
    44ec:	1f 41 0e 00 	mov	14(r1),	r15	;0x0000e
    44f0:	0e 4f       	mov	r15,	r14	;
    44f2:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    44f6:	81 4e 04 00 	mov	r14,	4(r1)	;
    44fa:	81 4f 06 00 	mov	r15,	6(r1)	;

000044fe <.L50>:
    44fe:	0e 44       	mov	r4,	r14	;
    4500:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4504:	4f 44       	mov.b	r4,	r15	;
    4506:	4f ee       	xor.b	r14,	r15	;
    4508:	4f 8e       	sub.b	r14,	r15	;
    450a:	7b 40 09 00 	mov.b	#9,	r11	;
    450e:	4b 9f       	cmp.b	r15,	r11	;
    4510:	02 28       	jnc	$+6      	;abs 0x4516
    4512:	80 00 a6 5b 	mova	#23462,	r0	;0x05ba6
    4516:	0e 44       	mov	r4,	r14	;
    4518:	0f 44       	mov	r4,	r15	;
    451a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    451e:	81 4e 08 00 	mov	r14,	8(r1)	;
    4522:	81 4f 0a 00 	mov	r15,	10(r1)	; 0x000a

00004526 <.L51>:
    4526:	0e 45       	mov	r5,	r14	;
    4528:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    452c:	4f 4e       	mov.b	r14,	r15	;
    452e:	4f e5       	xor.b	r5,	r15	;
    4530:	4f 8e       	sub.b	r14,	r15	;
    4532:	7b 40 09 00 	mov.b	#9,	r11	;
    4536:	4b 9f       	cmp.b	r15,	r11	;
    4538:	02 28       	jnc	$+6      	;abs 0x453e
    453a:	80 00 8c 5b 	mova	#23436,	r0	;0x05b8c
    453e:	81 45 14 00 	mov	r5,	20(r1)	; 0x0014
    4542:	0e 45       	mov	r5,	r14	;
    4544:	0f 45       	mov	r5,	r15	;
    4546:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;

0000454a <.L52>:
    454a:	15 41 08 00 	mov	8(r1),	r5	;
    454e:	05 5c       	add	r12,	r5	;
    4550:	1b 41 0a 00 	mov	10(r1),	r11	;0x0000a
    4554:	0b 6d       	addc	r13,	r11	;
    4556:	81 4b 08 00 	mov	r11,	8(r1)	;
    455a:	06 5e       	add	r14,	r6	;
    455c:	07 6f       	addc	r15,	r7	;
    455e:	7e 40 03 00 	mov.b	#3,	r14	;
    4562:	4f 43       	clr.b	r15		;
    4564:	1c 41 04 00 	mov	4(r1),	r12	;
    4568:	0c 58       	add	r8,	r12	;
    456a:	1d 41 06 00 	mov	6(r1),	r13	;
    456e:	0d 69       	addc	r9,	r13	;
    4570:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4574:	81 4c 04 00 	mov	r12,	4(r1)	;
    4578:	7e 40 03 00 	mov.b	#3,	r14	;
    457c:	4f 43       	clr.b	r15		;
    457e:	0c 45       	mov	r5,	r12	;
    4580:	1d 41 08 00 	mov	8(r1),	r13	;
    4584:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4588:	08 4c       	mov	r12,	r8	;
    458a:	7e 40 03 00 	mov.b	#3,	r14	;
    458e:	4f 43       	clr.b	r15		;
    4590:	0c 46       	mov	r6,	r12	;
    4592:	0d 47       	mov	r7,	r13	;
    4594:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4598:	09 4c       	mov	r12,	r9	;
    459a:	2c 41       	mov	@r1,	r12	;
    459c:	1c 81 04 00 	sub	4(r1),	r12	;
    45a0:	0d 4c       	mov	r12,	r13	;
    45a2:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    45a6:	0e 4d       	mov	r13,	r14	;
    45a8:	0e ec       	xor	r12,	r14	;
    45aa:	0e 8d       	sub	r13,	r14	;
    45ac:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    45b0:	0f 7f       	subc	r15,	r15	;
    45b2:	3f e3       	inv	r15		;
    45b4:	1c 41 18 00 	mov	24(r1),	r12	;0x00018
    45b8:	1c 81 04 00 	sub	4(r1),	r12	;
    45bc:	0d 4c       	mov	r12,	r13	;
    45be:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    45c2:	0c ed       	xor	r13,	r12	;
    45c4:	0c 8d       	sub	r13,	r12	;
    45c6:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    45ca:	0d 7d       	subc	r13,	r13	;
    45cc:	3d e3       	inv	r13		;
    45ce:	0c 5e       	add	r14,	r12	;
    45d0:	05 4f       	mov	r15,	r5	;
    45d2:	05 6d       	addc	r13,	r5	;
    45d4:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    45d8:	16 41 12 00 	mov	18(r1),	r6	;0x00012
    45dc:	06 88       	sub	r8,	r6	;
    45de:	0d 46       	mov	r6,	r13	;
    45e0:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    45e4:	06 ed       	xor	r13,	r6	;
    45e6:	06 8d       	sub	r13,	r6	;
    45e8:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    45ec:	07 77       	subc	r7,	r7	;
    45ee:	37 e3       	inv	r7		;
    45f0:	1d 41 1a 00 	mov	26(r1),	r13	;0x0001a
    45f4:	0d 88       	sub	r8,	r13	;
    45f6:	0f 4d       	mov	r13,	r15	;
    45f8:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    45fc:	0e 4f       	mov	r15,	r14	;
    45fe:	0e ed       	xor	r13,	r14	;
    4600:	0e 8f       	sub	r15,	r14	;
    4602:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4606:	0f 7f       	subc	r15,	r15	;
    4608:	3f e3       	inv	r15		;
    460a:	05 46       	mov	r6,	r5	;
    460c:	05 5e       	add	r14,	r5	;
    460e:	0b 47       	mov	r7,	r11	;
    4610:	0b 6f       	addc	r15,	r11	;
    4612:	81 4b 08 00 	mov	r11,	8(r1)	;
    4616:	17 41 16 00 	mov	22(r1),	r7	;0x00016
    461a:	07 89       	sub	r9,	r7	;
    461c:	0d 47       	mov	r7,	r13	;
    461e:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4622:	06 4d       	mov	r13,	r6	;
    4624:	06 e7       	xor	r7,	r6	;
    4626:	06 8d       	sub	r13,	r6	;
    4628:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    462c:	07 77       	subc	r7,	r7	;
    462e:	37 e3       	inv	r7		;
    4630:	1d 41 1c 00 	mov	28(r1),	r13	;0x0001c
    4634:	0d 89       	sub	r9,	r13	;
    4636:	0f 4d       	mov	r13,	r15	;
    4638:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    463c:	0e 4f       	mov	r15,	r14	;
    463e:	0e ed       	xor	r13,	r14	;
    4640:	0e 8f       	sub	r15,	r14	;
    4642:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4646:	0f 7f       	subc	r15,	r15	;
    4648:	3f e3       	inv	r15		;
    464a:	0d 46       	mov	r6,	r13	;
    464c:	0d 5e       	add	r14,	r13	;
    464e:	0b 47       	mov	r7,	r11	;
    4650:	0b 6f       	addc	r15,	r11	;
    4652:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    4656:	1e 81 04 00 	sub	4(r1),	r14	;
    465a:	0f 4e       	mov	r14,	r15	;
    465c:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4660:	0e ef       	xor	r15,	r14	;
    4662:	0e 8f       	sub	r15,	r14	;
    4664:	06 4e       	mov	r14,	r6	;
    4666:	07 4e       	mov	r14,	r7	;
    4668:	4e 18 07 11 	rpt #15 { rrax.w	r7		;
    466c:	81 46 0e 00 	mov	r6,	14(r1)	; 0x000e
    4670:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    4674:	04 88       	sub	r8,	r4	;
    4676:	0e 44       	mov	r4,	r14	;
    4678:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    467c:	0f 4e       	mov	r14,	r15	;
    467e:	0f e4       	xor	r4,	r15	;
    4680:	0f 8e       	sub	r14,	r15	;
    4682:	0e 4f       	mov	r15,	r14	;
    4684:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4688:	06 4e       	mov	r14,	r6	;
    468a:	06 55       	add	r5,	r6	;
    468c:	14 41 08 00 	mov	8(r1),	r4	;
    4690:	04 6f       	addc	r15,	r4	;
    4692:	15 41 14 00 	mov	20(r1),	r5	;0x00014
    4696:	05 89       	sub	r9,	r5	;
    4698:	0e 45       	mov	r5,	r14	;
    469a:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    469e:	0f 4e       	mov	r14,	r15	;
    46a0:	0f e5       	xor	r5,	r15	;
    46a2:	0f 8e       	sub	r14,	r15	;
    46a4:	0e 4f       	mov	r15,	r14	;
    46a6:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    46aa:	07 4e       	mov	r14,	r7	;
    46ac:	07 5d       	add	r13,	r7	;
    46ae:	05 4b       	mov	r11,	r5	;
    46b0:	05 6f       	addc	r15,	r5	;
    46b2:	7e 40 03 00 	mov.b	#3,	r14	;
    46b6:	4f 43       	clr.b	r15		;
    46b8:	1c 51 0e 00 	add	14(r1),	r12	;0x0000e
    46bc:	1d 41 18 00 	mov	24(r1),	r13	;0x00018
    46c0:	1d 61 10 00 	addc	16(r1),	r13	;0x00010
    46c4:	b0 12 b4 5d 	call	#23988		;#0x5db4
    46c8:	0b 4c       	mov	r12,	r11	;
    46ca:	7e 40 03 00 	mov.b	#3,	r14	;
    46ce:	4f 43       	clr.b	r15		;
    46d0:	0c 46       	mov	r6,	r12	;
    46d2:	0d 44       	mov	r4,	r13	;
    46d4:	81 4b 02 00 	mov	r11,	2(r1)	;
    46d8:	b0 12 b4 5d 	call	#23988		;#0x5db4
    46dc:	06 4c       	mov	r12,	r6	;
    46de:	7e 40 03 00 	mov.b	#3,	r14	;
    46e2:	4f 43       	clr.b	r15		;
    46e4:	0c 47       	mov	r7,	r12	;
    46e6:	0d 45       	mov	r5,	r13	;
    46e8:	b0 12 b4 5d 	call	#23988		;#0x5db4
    46ec:	05 4c       	mov	r12,	r5	;
    46ee:	1b 41 02 00 	mov	2(r1),	r11	;
    46f2:	0c 4b       	mov	r11,	r12	;
    46f4:	0d 4b       	mov	r11,	r13	;
    46f6:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    46fa:	07 4c       	mov	r12,	r7	;
    46fc:	0c 46       	mov	r6,	r12	;
    46fe:	0d 46       	mov	r6,	r13	;
    4700:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4704:	07 5c       	add	r12,	r7	;
    4706:	0c 45       	mov	r5,	r12	;
    4708:	0d 45       	mov	r5,	r13	;
    470a:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    470e:	07 5c       	add	r12,	r7	;
    4710:	1c 41 04 00 	mov	4(r1),	r12	;
    4714:	0d 4c       	mov	r12,	r13	;
    4716:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    471a:	06 4c       	mov	r12,	r6	;
    471c:	0c 48       	mov	r8,	r12	;
    471e:	0d 48       	mov	r8,	r13	;
    4720:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4724:	06 5c       	add	r12,	r6	;
    4726:	0c 49       	mov	r9,	r12	;
    4728:	0d 49       	mov	r9,	r13	;
    472a:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    472e:	06 5c       	add	r12,	r6	;
    4730:	08 46       	mov	r6,	r8	;
    4732:	09 43       	clr	r9		;
    4734:	75 40 80 00 	mov.b	#128,	r5	;#0x0080
    4738:	3b 40 ff 3f 	mov	#16383,	r11	;#0x3fff
    473c:	0b 96       	cmp	r6,	r11	;
    473e:	01 28       	jnc	$+4      	;abs 0x4742
    4740:	45 43       	clr.b	r5		;

00004742 <.L53>:
    4742:	04 45       	mov	r5,	r4	;
    4744:	34 d0 40 00 	bis	#64,	r4	;#0x0040
    4748:	0c 44       	mov	r4,	r12	;
    474a:	4d 43       	clr.b	r13		;
    474c:	0e 44       	mov	r4,	r14	;
    474e:	4f 43       	clr.b	r15		;
    4750:	b0 12 10 5e 	call	#24080		;#0x5e10
    4754:	0d 93       	cmp	#0,	r13	;r3 As==00
    4756:	04 20       	jnz	$+10     	;abs 0x4760
    4758:	09 93       	cmp	#0,	r9	;r3 As==00
    475a:	05 20       	jnz	$+12     	;abs 0x4766
    475c:	06 9c       	cmp	r12,	r6	;
    475e:	03 2c       	jc	$+8      	;abs 0x4766

00004760 <.L369>:
    4760:	04 45       	mov	r5,	r4	;
    4762:	34 f0 bf ff 	and	#-65,	r4	;#0xffbf

00004766 <.L55>:
    4766:	05 44       	mov	r4,	r5	;
    4768:	35 d0 20 00 	bis	#32,	r5	;#0x0020
    476c:	0c 45       	mov	r5,	r12	;
    476e:	4d 43       	clr.b	r13		;
    4770:	0e 45       	mov	r5,	r14	;
    4772:	4f 43       	clr.b	r15		;
    4774:	b0 12 10 5e 	call	#24080		;#0x5e10
    4778:	0d 93       	cmp	#0,	r13	;r3 As==00
    477a:	04 20       	jnz	$+10     	;abs 0x4784
    477c:	09 93       	cmp	#0,	r9	;r3 As==00
    477e:	05 20       	jnz	$+12     	;abs 0x478a
    4780:	06 9c       	cmp	r12,	r6	;
    4782:	03 2c       	jc	$+8      	;abs 0x478a

00004784 <.L370>:
    4784:	05 44       	mov	r4,	r5	;
    4786:	35 f0 df ff 	and	#-33,	r5	;#0xffdf

0000478a <.L57>:
    478a:	04 45       	mov	r5,	r4	;
    478c:	34 d0 10 00 	bis	#16,	r4	;#0x0010
    4790:	0c 44       	mov	r4,	r12	;
    4792:	4d 43       	clr.b	r13		;
    4794:	0e 44       	mov	r4,	r14	;
    4796:	4f 43       	clr.b	r15		;
    4798:	b0 12 10 5e 	call	#24080		;#0x5e10
    479c:	0d 93       	cmp	#0,	r13	;r3 As==00
    479e:	04 20       	jnz	$+10     	;abs 0x47a8
    47a0:	09 93       	cmp	#0,	r9	;r3 As==00
    47a2:	05 20       	jnz	$+12     	;abs 0x47ae
    47a4:	06 9c       	cmp	r12,	r6	;
    47a6:	03 2c       	jc	$+8      	;abs 0x47ae

000047a8 <.L371>:
    47a8:	04 45       	mov	r5,	r4	;
    47aa:	34 f0 ef ff 	and	#-17,	r4	;#0xffef

000047ae <.L59>:
    47ae:	05 44       	mov	r4,	r5	;
    47b0:	35 d2       	bis	#8,	r5	;r2 As==11
    47b2:	0c 45       	mov	r5,	r12	;
    47b4:	4d 43       	clr.b	r13		;
    47b6:	0e 45       	mov	r5,	r14	;
    47b8:	4f 43       	clr.b	r15		;
    47ba:	b0 12 10 5e 	call	#24080		;#0x5e10
    47be:	0d 93       	cmp	#0,	r13	;r3 As==00
    47c0:	02 24       	jz	$+6      	;abs 0x47c6
    47c2:	80 00 5c 59 	mova	#22876,	r0	;0x0595c
    47c6:	09 93       	cmp	#0,	r9	;r3 As==00
    47c8:	04 20       	jnz	$+10     	;abs 0x47d2
    47ca:	06 9c       	cmp	r12,	r6	;
    47cc:	02 2c       	jc	$+6      	;abs 0x47d2
    47ce:	80 00 5c 59 	mova	#22876,	r0	;0x0595c

000047d2 <.L61>:
    47d2:	04 45       	mov	r5,	r4	;
    47d4:	24 d2       	bis	#4,	r4	;r2 As==10
    47d6:	0c 44       	mov	r4,	r12	;
    47d8:	4d 43       	clr.b	r13		;
    47da:	0e 44       	mov	r4,	r14	;
    47dc:	4f 43       	clr.b	r15		;
    47de:	b0 12 10 5e 	call	#24080		;#0x5e10
    47e2:	0d 93       	cmp	#0,	r13	;r3 As==00
    47e4:	02 24       	jz	$+6      	;abs 0x47ea
    47e6:	80 00 54 59 	mova	#22868,	r0	;0x05954
    47ea:	09 93       	cmp	#0,	r9	;r3 As==00
    47ec:	04 20       	jnz	$+10     	;abs 0x47f6
    47ee:	06 9c       	cmp	r12,	r6	;
    47f0:	02 2c       	jc	$+6      	;abs 0x47f6
    47f2:	80 00 54 59 	mova	#22868,	r0	;0x05954

000047f6 <.L63>:
    47f6:	05 44       	mov	r4,	r5	;
    47f8:	25 d3       	bis	#2,	r5	;r3 As==10
    47fa:	0c 45       	mov	r5,	r12	;
    47fc:	4d 43       	clr.b	r13		;
    47fe:	0e 45       	mov	r5,	r14	;
    4800:	4f 43       	clr.b	r15		;
    4802:	b0 12 10 5e 	call	#24080		;#0x5e10
    4806:	0d 93       	cmp	#0,	r13	;r3 As==00
    4808:	02 24       	jz	$+6      	;abs 0x480e
    480a:	80 00 4c 59 	mova	#22860,	r0	;0x0594c
    480e:	09 93       	cmp	#0,	r9	;r3 As==00
    4810:	04 20       	jnz	$+10     	;abs 0x481a
    4812:	06 9c       	cmp	r12,	r6	;
    4814:	02 2c       	jc	$+6      	;abs 0x481a
    4816:	80 00 4c 59 	mova	#22860,	r0	;0x0594c

0000481a <.L65>:
    481a:	04 45       	mov	r5,	r4	;
    481c:	14 d3       	bis	#1,	r4	;r3 As==01
    481e:	0c 44       	mov	r4,	r12	;
    4820:	4d 43       	clr.b	r13		;
    4822:	0e 44       	mov	r4,	r14	;
    4824:	4f 43       	clr.b	r15		;
    4826:	b0 12 10 5e 	call	#24080		;#0x5e10
    482a:	0d 93       	cmp	#0,	r13	;r3 As==00
    482c:	02 24       	jz	$+6      	;abs 0x4832
    482e:	80 00 1e 59 	mova	#22814,	r0	;0x0591e
    4832:	09 93       	cmp	#0,	r9	;r3 As==00
    4834:	04 20       	jnz	$+10     	;abs 0x483e
    4836:	06 9c       	cmp	r12,	r6	;
    4838:	02 2c       	jc	$+6      	;abs 0x483e
    483a:	80 00 1e 59 	mova	#22814,	r0	;0x0591e

0000483e <.L67>:
    483e:	81 44 1e 00 	mov	r4,	30(r1)	; 0x001e
    4842:	08 47       	mov	r7,	r8	;
    4844:	09 43       	clr	r9		;
    4846:	3c 40 ff 0f 	mov	#4095,	r12	;#0x0fff
    484a:	0c 97       	cmp	r7,	r12	;
    484c:	02 2c       	jc	$+6      	;abs 0x4852
    484e:	80 00 36 59 	mova	#22838,	r0	;0x05936

00004852 <.L523>:
    4852:	3d 40 ff 03 	mov	#1023,	r13	;#0x03ff
    4856:	75 40 20 00 	mov.b	#32,	r5	;#0x0020
    485a:	0d 97       	cmp	r7,	r13	;
    485c:	02 28       	jnc	$+6      	;abs 0x4862
    485e:	80 00 9c 5b 	mova	#23452,	r0	;0x05b9c
    4862:	46 43       	clr.b	r6		;

00004864 <.L70>:
    4864:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4868:	0c 45       	mov	r5,	r12	;
    486a:	0d 46       	mov	r6,	r13	;
    486c:	0e 45       	mov	r5,	r14	;
    486e:	0f 46       	mov	r6,	r15	;
    4870:	b0 12 10 5e 	call	#24080		;#0x5e10
    4874:	0d 93       	cmp	#0,	r13	;r3 As==00
    4876:	02 24       	jz	$+6      	;abs 0x487c
    4878:	80 00 44 59 	mova	#22852,	r0	;0x05944
    487c:	09 93       	cmp	#0,	r9	;r3 As==00
    487e:	02 20       	jnz	$+6      	;abs 0x4884
    4880:	80 00 e4 5c 	mova	#23780,	r0	;0x05ce4

00004884 <.L72>:
    4884:	04 45       	mov	r5,	r4	;
    4886:	34 d2       	bis	#8,	r4	;r2 As==11
    4888:	0c 44       	mov	r4,	r12	;
    488a:	0d 46       	mov	r6,	r13	;
    488c:	0e 44       	mov	r4,	r14	;
    488e:	0f 46       	mov	r6,	r15	;
    4890:	b0 12 10 5e 	call	#24080		;#0x5e10
    4894:	0d 93       	cmp	#0,	r13	;r3 As==00
    4896:	02 24       	jz	$+6      	;abs 0x489c
    4898:	80 00 16 59 	mova	#22806,	r0	;0x05916
    489c:	09 93       	cmp	#0,	r9	;r3 As==00
    489e:	04 20       	jnz	$+10     	;abs 0x48a8
    48a0:	07 9c       	cmp	r12,	r7	;
    48a2:	02 2c       	jc	$+6      	;abs 0x48a8
    48a4:	80 00 16 59 	mova	#22806,	r0	;0x05916

000048a8 <.L74>:
    48a8:	05 44       	mov	r4,	r5	;
    48aa:	25 d2       	bis	#4,	r5	;r2 As==10
    48ac:	0c 45       	mov	r5,	r12	;
    48ae:	0d 46       	mov	r6,	r13	;
    48b0:	0e 45       	mov	r5,	r14	;
    48b2:	0f 46       	mov	r6,	r15	;
    48b4:	b0 12 10 5e 	call	#24080		;#0x5e10
    48b8:	0d 93       	cmp	#0,	r13	;r3 As==00
    48ba:	02 24       	jz	$+6      	;abs 0x48c0
    48bc:	80 00 0e 59 	mova	#22798,	r0	;0x0590e
    48c0:	09 93       	cmp	#0,	r9	;r3 As==00
    48c2:	04 20       	jnz	$+10     	;abs 0x48cc
    48c4:	07 9c       	cmp	r12,	r7	;
    48c6:	02 2c       	jc	$+6      	;abs 0x48cc
    48c8:	80 00 0e 59 	mova	#22798,	r0	;0x0590e

000048cc <.L76>:
    48cc:	04 45       	mov	r5,	r4	;
    48ce:	24 d3       	bis	#2,	r4	;r3 As==10
    48d0:	0c 44       	mov	r4,	r12	;
    48d2:	0d 46       	mov	r6,	r13	;
    48d4:	0e 44       	mov	r4,	r14	;
    48d6:	0f 46       	mov	r6,	r15	;
    48d8:	b0 12 10 5e 	call	#24080		;#0x5e10
    48dc:	0d 93       	cmp	#0,	r13	;r3 As==00
    48de:	02 24       	jz	$+6      	;abs 0x48e4
    48e0:	80 00 06 59 	mova	#22790,	r0	;0x05906
    48e4:	09 93       	cmp	#0,	r9	;r3 As==00
    48e6:	04 20       	jnz	$+10     	;abs 0x48f0
    48e8:	07 9c       	cmp	r12,	r7	;
    48ea:	02 2c       	jc	$+6      	;abs 0x48f0
    48ec:	80 00 06 59 	mova	#22790,	r0	;0x05906

000048f0 <.L78>:
    48f0:	05 44       	mov	r4,	r5	;
    48f2:	15 d3       	bis	#1,	r5	;r3 As==01
    48f4:	0c 45       	mov	r5,	r12	;
    48f6:	0d 46       	mov	r6,	r13	;
    48f8:	0e 45       	mov	r5,	r14	;
    48fa:	0f 46       	mov	r6,	r15	;
    48fc:	b0 12 10 5e 	call	#24080		;#0x5e10
    4900:	0d 93       	cmp	#0,	r13	;r3 As==00
    4902:	04 20       	jnz	$+10     	;abs 0x490c
    4904:	09 93       	cmp	#0,	r9	;r3 As==00
    4906:	04 20       	jnz	$+10     	;abs 0x4910
    4908:	07 9c       	cmp	r12,	r7	;
    490a:	02 2c       	jc	$+6      	;abs 0x4910

0000490c <.L380>:
    490c:	05 44       	mov	r4,	r5	;
    490e:	15 c3       	bic	#1,	r5	;r3 As==01

00004910 <.L80>:
    4910:	81 45 20 00 	mov	r5,	32(r1)	; 0x0020
    4914:	15 41 0c 00 	mov	12(r1),	r5	;0x0000c
    4918:	95 41 1e 00 	mov	30(r1),	0(r5)	;0x0001e
    491c:	00 00 
    491e:	95 41 20 00 	mov	32(r1),	2(r5)	;0x00020
    4922:	02 00 
    4924:	25 52       	add	#4,	r5	;r2 As==10
    4926:	81 45 0c 00 	mov	r5,	12(r1)	; 0x000c
    492a:	36 40 42 1c 	mov	#7234,	r6	;#0x1c42
    492e:	06 95       	cmp	r5,	r6	;
    4930:	02 24       	jz	$+6      	;abs 0x4936
    4932:	80 00 7a 42 	mova	#17018,	r0	;0x0427a
    4936:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    493a:	b0 12 f0 40 	call	#16624		;#0x40f0
    493e:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    4942:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    4946:	b0 12 44 41 	call	#16708		;#0x4144
    494a:	92 43 82 1c 	mov	#1,	&0x1c82	;r3 As==01
    494e:	b0 12 d4 40 	call	#16596		;#0x40d4
    4952:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4956:	1e 42 82 1c 	mov	&0x1c82,r14	;0x1c82
    495a:	0d 4c       	mov	r12,	r13	;
    495c:	5d f3       	and.b	#1,	r13	;r3 As==01
    495e:	5c 03       	rrum	#1,	r12	;
    4960:	0d 93       	cmp	#0,	r13	;r3 As==00
    4962:	02 24       	jz	$+6      	;abs 0x4968
    4964:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004968 <.L137>:
    4968:	0d 4c       	mov	r12,	r13	;
    496a:	5d 03       	rrum	#1,	r13	;
    496c:	1c b3       	bit	#1,	r12	;r3 As==01
    496e:	02 24       	jz	$+6      	;abs 0x4974
    4970:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

00004974 <.L136>:
    4974:	0c 4d       	mov	r13,	r12	;
    4976:	5c 03       	rrum	#1,	r12	;
    4978:	1d b3       	bit	#1,	r13	;r3 As==01
    497a:	02 24       	jz	$+6      	;abs 0x4980
    497c:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004980 <.L131>:
    4980:	1e 42 82 1c 	mov	&0x1c82,r14	;0x1c82
    4984:	0d 4c       	mov	r12,	r13	;
    4986:	5d f3       	and.b	#1,	r13	;r3 As==01
    4988:	5c 03       	rrum	#1,	r12	;
    498a:	0d 93       	cmp	#0,	r13	;r3 As==00
    498c:	02 24       	jz	$+6      	;abs 0x4992
    498e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004992 <.L147>:
    4992:	0d 4c       	mov	r12,	r13	;
    4994:	5d 03       	rrum	#1,	r13	;
    4996:	1c b3       	bit	#1,	r12	;r3 As==01
    4998:	02 24       	jz	$+6      	;abs 0x499e
    499a:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

0000499e <.L146>:
    499e:	0c 4d       	mov	r13,	r12	;
    49a0:	5c 03       	rrum	#1,	r12	;
    49a2:	1d b3       	bit	#1,	r13	;r3 As==01
    49a4:	02 24       	jz	$+6      	;abs 0x49aa
    49a6:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000049aa <.L141>:
    49aa:	1e 42 82 1c 	mov	&0x1c82,r14	;0x1c82
    49ae:	0d 4c       	mov	r12,	r13	;
    49b0:	5d f3       	and.b	#1,	r13	;r3 As==01
    49b2:	5c 03       	rrum	#1,	r12	;
    49b4:	0d 93       	cmp	#0,	r13	;r3 As==00
    49b6:	02 24       	jz	$+6      	;abs 0x49bc
    49b8:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000049bc <.L152>:
    49bc:	0d 4c       	mov	r12,	r13	;
    49be:	5d 03       	rrum	#1,	r13	;
    49c0:	1c b3       	bit	#1,	r12	;r3 As==01
    49c2:	02 24       	jz	$+6      	;abs 0x49c8
    49c4:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

000049c8 <.L153>:
    49c8:	0a 4d       	mov	r13,	r10	;
    49ca:	5a 03       	rrum	#1,	r10	;
    49cc:	1d b3       	bit	#1,	r13	;r3 As==01
    49ce:	02 24       	jz	$+6      	;abs 0x49d4
    49d0:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

000049d4 <.L151>:
    49d4:	b1 40 42 1c 	mov	#7234,	12(r1)	;#0x1c42, 0x000c
    49d8:	0c 00 

000049da <.L154>:
    49da:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    49de:	0c 4a       	mov	r10,	r12	;
    49e0:	5c f3       	and.b	#1,	r12	;r3 As==01
    49e2:	5a 03       	rrum	#1,	r10	;
    49e4:	0d 93       	cmp	#0,	r13	;r3 As==00
    49e6:	02 20       	jnz	$+6      	;abs 0x49ec
    49e8:	80 00 44 5b 	mova	#23364,	r0	;0x05b44
    49ec:	0c 93       	cmp	#0,	r12	;r3 As==00
    49ee:	02 24       	jz	$+6      	;abs 0x49f4
    49f0:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

000049f4 <.L200>:
    49f4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    49f8:	0c 4a       	mov	r10,	r12	;
    49fa:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    49fe:	49 4c       	mov.b	r12,	r9	;
    4a00:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    4a04:	89 11       	sxt	r9		;
    4a06:	08 4a       	mov	r10,	r8	;
    4a08:	58 03       	rrum	#1,	r8	;
    4a0a:	1a b3       	bit	#1,	r10	;r3 As==01
    4a0c:	02 24       	jz	$+6      	;abs 0x4a12
    4a0e:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

00004a12 <.L199>:
    4a12:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4a16:	0c 48       	mov	r8,	r12	;
    4a18:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4a1c:	46 4c       	mov.b	r12,	r6	;
    4a1e:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    4a22:	86 11       	sxt	r6		;
    4a24:	0a 48       	mov	r8,	r10	;
    4a26:	5a 03       	rrum	#1,	r10	;
    4a28:	18 b3       	bit	#1,	r8	;r3 As==01
    4a2a:	02 24       	jz	$+6      	;abs 0x4a30
    4a2c:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00004a30 <.L198>:
    4a30:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4a34:	0c 4a       	mov	r10,	r12	;
    4a36:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4a3a:	47 4c       	mov.b	r12,	r7	;
    4a3c:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4a40:	87 11       	sxt	r7		;

00004a42 <.L197>:
    4a42:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    4a46:	0c 4a       	mov	r10,	r12	;
    4a48:	5c f3       	and.b	#1,	r12	;r3 As==01
    4a4a:	5a 03       	rrum	#1,	r10	;
    4a4c:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a4e:	02 20       	jnz	$+6      	;abs 0x4a54
    4a50:	80 00 f0 5a 	mova	#23280,	r0	;0x05af0
    4a54:	0c 93       	cmp	#0,	r12	;r3 As==00
    4a56:	02 24       	jz	$+6      	;abs 0x4a5c
    4a58:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00004a5c <.L214>:
    4a5c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4a60:	0c 4a       	mov	r10,	r12	;
    4a62:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4a66:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4a6a:	8c 11       	sxt	r12		;
    4a6c:	81 4c 04 00 	mov	r12,	4(r1)	;
    4a70:	08 4a       	mov	r10,	r8	;
    4a72:	58 03       	rrum	#1,	r8	;
    4a74:	1a b3       	bit	#1,	r10	;r3 As==01
    4a76:	02 24       	jz	$+6      	;abs 0x4a7c
    4a78:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

00004a7c <.L213>:
    4a7c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4a80:	0c 48       	mov	r8,	r12	;
    4a82:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4a86:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4a8a:	8c 11       	sxt	r12		;
    4a8c:	81 4c 08 00 	mov	r12,	8(r1)	;
    4a90:	0a 48       	mov	r8,	r10	;
    4a92:	5a 03       	rrum	#1,	r10	;
    4a94:	18 b3       	bit	#1,	r8	;r3 As==01
    4a96:	02 24       	jz	$+6      	;abs 0x4a9c
    4a98:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00004a9c <.L212>:
    4a9c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4aa0:	0c 4a       	mov	r10,	r12	;
    4aa2:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4aa6:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4aaa:	8c 11       	sxt	r12		;
    4aac:	81 4c 14 00 	mov	r12,	20(r1)	; 0x0014

00004ab0 <.L211>:
    4ab0:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    4ab4:	0c 4a       	mov	r10,	r12	;
    4ab6:	5c f3       	and.b	#1,	r12	;r3 As==01
    4ab8:	5a 03       	rrum	#1,	r10	;
    4aba:	0d 93       	cmp	#0,	r13	;r3 As==00
    4abc:	02 20       	jnz	$+6      	;abs 0x4ac2
    4abe:	80 00 a0 5a 	mova	#23200,	r0	;0x05aa0
    4ac2:	0c 93       	cmp	#0,	r12	;r3 As==00
    4ac4:	02 24       	jz	$+6      	;abs 0x4aca
    4ac6:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00004aca <.L229>:
    4aca:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4ace:	0c 4a       	mov	r10,	r12	;
    4ad0:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4ad4:	4b 4c       	mov.b	r12,	r11	;
    4ad6:	7b 50 e2 ff 	add.b	#-30,	r11	;#0xffe2
    4ada:	8b 11       	sxt	r11		;
    4adc:	81 4b 0e 00 	mov	r11,	14(r1)	; 0x000e
    4ae0:	08 4a       	mov	r10,	r8	;
    4ae2:	58 03       	rrum	#1,	r8	;
    4ae4:	1a b3       	bit	#1,	r10	;r3 As==01
    4ae6:	02 24       	jz	$+6      	;abs 0x4aec
    4ae8:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

00004aec <.L228>:
    4aec:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4af0:	0c 48       	mov	r8,	r12	;
    4af2:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4af6:	44 4c       	mov.b	r12,	r4	;
    4af8:	74 50 e2 ff 	add.b	#-30,	r4	;#0xffe2
    4afc:	84 11       	sxt	r4		;
    4afe:	0a 48       	mov	r8,	r10	;
    4b00:	5a 03       	rrum	#1,	r10	;
    4b02:	18 b3       	bit	#1,	r8	;r3 As==01
    4b04:	02 24       	jz	$+6      	;abs 0x4b0a
    4b06:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00004b0a <.L489>:
    4b0a:	82 4a 00 1c 	mov	r10,	&0x1c00	;
    4b0e:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b12:	0c 4a       	mov	r10,	r12	;
    4b14:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    4b18:	45 4c       	mov.b	r12,	r5	;
    4b1a:	75 50 e2 ff 	add.b	#-30,	r5	;#0xffe2
    4b1e:	85 11       	sxt	r5		;

00004b20 <.L226>:
    4b20:	0d 49       	mov	r9,	r13	;
    4b22:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    4b26:	4c 4d       	mov.b	r13,	r12	;
    4b28:	4c e9       	xor.b	r9,	r12	;
    4b2a:	4c 8d       	sub.b	r13,	r12	;
    4b2c:	7b 40 09 00 	mov.b	#9,	r11	;
    4b30:	4b 9c       	cmp.b	r12,	r11	;
    4b32:	02 28       	jnc	$+6      	;abs 0x4b38
    4b34:	80 00 94 5a 	mova	#23188,	r0	;0x05a94
    4b38:	81 49 1e 00 	mov	r9,	30(r1)	; 0x001e
    4b3c:	08 49       	mov	r9,	r8	;
    4b3e:	4e 18 09 11 	rpt #15 { rrax.w	r9		;

00004b42 <.L237>:
    4b42:	0c 46       	mov	r6,	r12	;
    4b44:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4b48:	4d 4c       	mov.b	r12,	r13	;
    4b4a:	4d e6       	xor.b	r6,	r13	;
    4b4c:	4d 8c       	sub.b	r12,	r13	;
    4b4e:	7c 40 09 00 	mov.b	#9,	r12	;
    4b52:	4c 9d       	cmp.b	r13,	r12	;
    4b54:	02 28       	jnc	$+6      	;abs 0x4b5a
    4b56:	80 00 88 5a 	mova	#23176,	r0	;0x05a88
    4b5a:	81 46 12 00 	mov	r6,	18(r1)	; 0x0012
    4b5e:	0c 46       	mov	r6,	r12	;
    4b60:	0d 46       	mov	r6,	r13	;
    4b62:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;

00004b66 <.L155>:
    4b66:	0e 47       	mov	r7,	r14	;
    4b68:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4b6c:	4f 4e       	mov.b	r14,	r15	;
    4b6e:	4f e7       	xor.b	r7,	r15	;
    4b70:	4f 8e       	sub.b	r14,	r15	;
    4b72:	7e 40 09 00 	mov.b	#9,	r14	;
    4b76:	4e 9f       	cmp.b	r15,	r14	;
    4b78:	02 28       	jnc	$+6      	;abs 0x4b7e
    4b7a:	80 00 7c 5a 	mova	#23164,	r0	;0x05a7c
    4b7e:	81 47 16 00 	mov	r7,	22(r1)	; 0x0016
    4b82:	06 47       	mov	r7,	r6	;
    4b84:	4e 18 07 11 	rpt #15 { rrax.w	r7		;

00004b88 <.L156>:
    4b88:	1e 41 04 00 	mov	4(r1),	r14	;
    4b8c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4b90:	1f 41 04 00 	mov	4(r1),	r15	;
    4b94:	4f ee       	xor.b	r14,	r15	;
    4b96:	4f 8e       	sub.b	r14,	r15	;
    4b98:	81 43 18 00 	mov	#0,	24(r1)	;r3 As==00, 0x0018
    4b9c:	7b 40 09 00 	mov.b	#9,	r11	;
    4ba0:	4b 9f       	cmp.b	r15,	r11	;
    4ba2:	0e 2c       	jc	$+30     	;abs 0x4bc0
    4ba4:	91 41 04 00 	mov	4(r1),	24(r1)	; 0x0018
    4ba8:	18 00 
    4baa:	1f 41 18 00 	mov	24(r1),	r15	;0x00018
    4bae:	0e 4f       	mov	r15,	r14	;
    4bb0:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4bb4:	81 4e 04 00 	mov	r14,	4(r1)	;
    4bb8:	81 4f 06 00 	mov	r15,	6(r1)	;
    4bbc:	08 5e       	add	r14,	r8	;
    4bbe:	09 6f       	addc	r15,	r9	;

00004bc0 <.L157>:
    4bc0:	1e 41 08 00 	mov	8(r1),	r14	;
    4bc4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4bc8:	1f 41 08 00 	mov	8(r1),	r15	;
    4bcc:	4f ee       	xor.b	r14,	r15	;
    4bce:	4f 8e       	sub.b	r14,	r15	;
    4bd0:	81 43 1a 00 	mov	#0,	26(r1)	;r3 As==00, 0x001a
    4bd4:	7b 40 09 00 	mov.b	#9,	r11	;
    4bd8:	4b 9f       	cmp.b	r15,	r11	;
    4bda:	0e 2c       	jc	$+30     	;abs 0x4bf8
    4bdc:	91 41 08 00 	mov	8(r1),	26(r1)	; 0x001a
    4be0:	1a 00 
    4be2:	1f 41 1a 00 	mov	26(r1),	r15	;0x0001a
    4be6:	0e 4f       	mov	r15,	r14	;
    4be8:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4bec:	81 4e 04 00 	mov	r14,	4(r1)	;
    4bf0:	81 4f 06 00 	mov	r15,	6(r1)	;
    4bf4:	0c 5e       	add	r14,	r12	;
    4bf6:	0d 6f       	addc	r15,	r13	;

00004bf8 <.L158>:
    4bf8:	1e 41 14 00 	mov	20(r1),	r14	;0x00014
    4bfc:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c00:	1f 41 14 00 	mov	20(r1),	r15	;0x00014
    4c04:	4f ee       	xor.b	r14,	r15	;
    4c06:	4f 8e       	sub.b	r14,	r15	;
    4c08:	81 43 1c 00 	mov	#0,	28(r1)	;r3 As==00, 0x001c
    4c0c:	7b 40 09 00 	mov.b	#9,	r11	;
    4c10:	4b 9f       	cmp.b	r15,	r11	;
    4c12:	0e 2c       	jc	$+30     	;abs 0x4c30
    4c14:	91 41 14 00 	mov	20(r1),	28(r1)	;0x00014, 0x001c
    4c18:	1c 00 
    4c1a:	1f 41 1c 00 	mov	28(r1),	r15	;0x0001c
    4c1e:	0e 4f       	mov	r15,	r14	;
    4c20:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4c24:	81 4e 04 00 	mov	r14,	4(r1)	;
    4c28:	81 4f 06 00 	mov	r15,	6(r1)	;
    4c2c:	06 5e       	add	r14,	r6	;
    4c2e:	07 6f       	addc	r15,	r7	;

00004c30 <.L159>:
    4c30:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    4c34:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c38:	1f 41 0e 00 	mov	14(r1),	r15	;0x0000e
    4c3c:	4f ee       	xor.b	r14,	r15	;
    4c3e:	4f 8e       	sub.b	r14,	r15	;
    4c40:	7b 40 09 00 	mov.b	#9,	r11	;
    4c44:	4b 9f       	cmp.b	r15,	r11	;
    4c46:	02 28       	jnc	$+6      	;abs 0x4c4c
    4c48:	80 00 6c 5a 	mova	#23148,	r0	;0x05a6c
    4c4c:	1f 41 0e 00 	mov	14(r1),	r15	;0x0000e
    4c50:	0e 4f       	mov	r15,	r14	;
    4c52:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4c56:	81 4e 04 00 	mov	r14,	4(r1)	;
    4c5a:	81 4f 06 00 	mov	r15,	6(r1)	;

00004c5e <.L160>:
    4c5e:	0e 44       	mov	r4,	r14	;
    4c60:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c64:	4f 44       	mov.b	r4,	r15	;
    4c66:	4f ee       	xor.b	r14,	r15	;
    4c68:	4f 8e       	sub.b	r14,	r15	;
    4c6a:	7b 40 09 00 	mov.b	#9,	r11	;
    4c6e:	4b 9f       	cmp.b	r15,	r11	;
    4c70:	02 28       	jnc	$+6      	;abs 0x4c76
    4c72:	80 00 50 5a 	mova	#23120,	r0	;0x05a50
    4c76:	0e 44       	mov	r4,	r14	;
    4c78:	0f 44       	mov	r4,	r15	;
    4c7a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4c7e:	81 4e 08 00 	mov	r14,	8(r1)	;
    4c82:	81 4f 0a 00 	mov	r15,	10(r1)	; 0x000a

00004c86 <.L161>:
    4c86:	0e 45       	mov	r5,	r14	;
    4c88:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c8c:	4f 4e       	mov.b	r14,	r15	;
    4c8e:	4f e5       	xor.b	r5,	r15	;
    4c90:	4f 8e       	sub.b	r14,	r15	;
    4c92:	7b 40 09 00 	mov.b	#9,	r11	;
    4c96:	4b 9f       	cmp.b	r15,	r11	;
    4c98:	02 28       	jnc	$+6      	;abs 0x4c9e
    4c9a:	80 00 44 5a 	mova	#23108,	r0	;0x05a44
    4c9e:	81 45 14 00 	mov	r5,	20(r1)	; 0x0014
    4ca2:	0e 45       	mov	r5,	r14	;
    4ca4:	0f 45       	mov	r5,	r15	;
    4ca6:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;

00004caa <.L162>:
    4caa:	15 41 08 00 	mov	8(r1),	r5	;
    4cae:	05 5c       	add	r12,	r5	;
    4cb0:	1b 41 0a 00 	mov	10(r1),	r11	;0x0000a
    4cb4:	0b 6d       	addc	r13,	r11	;
    4cb6:	81 4b 08 00 	mov	r11,	8(r1)	;
    4cba:	06 5e       	add	r14,	r6	;
    4cbc:	07 6f       	addc	r15,	r7	;
    4cbe:	7e 40 03 00 	mov.b	#3,	r14	;
    4cc2:	4f 43       	clr.b	r15		;
    4cc4:	1c 41 04 00 	mov	4(r1),	r12	;
    4cc8:	0c 58       	add	r8,	r12	;
    4cca:	1d 41 06 00 	mov	6(r1),	r13	;
    4cce:	0d 69       	addc	r9,	r13	;
    4cd0:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4cd4:	81 4c 04 00 	mov	r12,	4(r1)	;
    4cd8:	7e 40 03 00 	mov.b	#3,	r14	;
    4cdc:	4f 43       	clr.b	r15		;
    4cde:	0c 45       	mov	r5,	r12	;
    4ce0:	1d 41 08 00 	mov	8(r1),	r13	;
    4ce4:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4ce8:	08 4c       	mov	r12,	r8	;
    4cea:	7e 40 03 00 	mov.b	#3,	r14	;
    4cee:	4f 43       	clr.b	r15		;
    4cf0:	0c 46       	mov	r6,	r12	;
    4cf2:	0d 47       	mov	r7,	r13	;
    4cf4:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4cf8:	09 4c       	mov	r12,	r9	;
    4cfa:	1c 41 1e 00 	mov	30(r1),	r12	;0x0001e
    4cfe:	1c 81 04 00 	sub	4(r1),	r12	;
    4d02:	0d 4c       	mov	r12,	r13	;
    4d04:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4d08:	0e 4d       	mov	r13,	r14	;
    4d0a:	0e ec       	xor	r12,	r14	;
    4d0c:	0e 8d       	sub	r13,	r14	;
    4d0e:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4d12:	0f 7f       	subc	r15,	r15	;
    4d14:	3f e3       	inv	r15		;
    4d16:	1c 41 18 00 	mov	24(r1),	r12	;0x00018
    4d1a:	1c 81 04 00 	sub	4(r1),	r12	;
    4d1e:	0d 4c       	mov	r12,	r13	;
    4d20:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4d24:	0c ed       	xor	r13,	r12	;
    4d26:	0c 8d       	sub	r13,	r12	;
    4d28:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4d2c:	0d 7d       	subc	r13,	r13	;
    4d2e:	3d e3       	inv	r13		;
    4d30:	0c 5e       	add	r14,	r12	;
    4d32:	05 4f       	mov	r15,	r5	;
    4d34:	05 6d       	addc	r13,	r5	;
    4d36:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    4d3a:	16 41 12 00 	mov	18(r1),	r6	;0x00012
    4d3e:	06 88       	sub	r8,	r6	;
    4d40:	0d 46       	mov	r6,	r13	;
    4d42:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4d46:	06 ed       	xor	r13,	r6	;
    4d48:	06 8d       	sub	r13,	r6	;
    4d4a:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    4d4e:	07 77       	subc	r7,	r7	;
    4d50:	37 e3       	inv	r7		;
    4d52:	1d 41 1a 00 	mov	26(r1),	r13	;0x0001a
    4d56:	0d 88       	sub	r8,	r13	;
    4d58:	0f 4d       	mov	r13,	r15	;
    4d5a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4d5e:	0e 4f       	mov	r15,	r14	;
    4d60:	0e ed       	xor	r13,	r14	;
    4d62:	0e 8f       	sub	r15,	r14	;
    4d64:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4d68:	0f 7f       	subc	r15,	r15	;
    4d6a:	3f e3       	inv	r15		;
    4d6c:	05 46       	mov	r6,	r5	;
    4d6e:	05 5e       	add	r14,	r5	;
    4d70:	0b 47       	mov	r7,	r11	;
    4d72:	0b 6f       	addc	r15,	r11	;
    4d74:	81 4b 08 00 	mov	r11,	8(r1)	;
    4d78:	17 41 16 00 	mov	22(r1),	r7	;0x00016
    4d7c:	07 89       	sub	r9,	r7	;
    4d7e:	0d 47       	mov	r7,	r13	;
    4d80:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4d84:	06 4d       	mov	r13,	r6	;
    4d86:	06 e7       	xor	r7,	r6	;
    4d88:	06 8d       	sub	r13,	r6	;
    4d8a:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    4d8e:	07 77       	subc	r7,	r7	;
    4d90:	37 e3       	inv	r7		;
    4d92:	1d 41 1c 00 	mov	28(r1),	r13	;0x0001c
    4d96:	0d 89       	sub	r9,	r13	;
    4d98:	0f 4d       	mov	r13,	r15	;
    4d9a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4d9e:	0e 4f       	mov	r15,	r14	;
    4da0:	0e ed       	xor	r13,	r14	;
    4da2:	0e 8f       	sub	r15,	r14	;
    4da4:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4da8:	0f 7f       	subc	r15,	r15	;
    4daa:	3f e3       	inv	r15		;
    4dac:	0d 46       	mov	r6,	r13	;
    4dae:	0d 5e       	add	r14,	r13	;
    4db0:	0b 47       	mov	r7,	r11	;
    4db2:	0b 6f       	addc	r15,	r11	;
    4db4:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    4db8:	1e 81 04 00 	sub	4(r1),	r14	;
    4dbc:	0f 4e       	mov	r14,	r15	;
    4dbe:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4dc2:	0e ef       	xor	r15,	r14	;
    4dc4:	0e 8f       	sub	r15,	r14	;
    4dc6:	06 4e       	mov	r14,	r6	;
    4dc8:	07 4e       	mov	r14,	r7	;
    4dca:	4e 18 07 11 	rpt #15 { rrax.w	r7		;
    4dce:	81 46 0e 00 	mov	r6,	14(r1)	; 0x000e
    4dd2:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    4dd6:	04 88       	sub	r8,	r4	;
    4dd8:	0e 44       	mov	r4,	r14	;
    4dda:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4dde:	0f 4e       	mov	r14,	r15	;
    4de0:	0f e4       	xor	r4,	r15	;
    4de2:	0f 8e       	sub	r14,	r15	;
    4de4:	0e 4f       	mov	r15,	r14	;
    4de6:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4dea:	06 4e       	mov	r14,	r6	;
    4dec:	06 55       	add	r5,	r6	;
    4dee:	14 41 08 00 	mov	8(r1),	r4	;
    4df2:	04 6f       	addc	r15,	r4	;
    4df4:	15 41 14 00 	mov	20(r1),	r5	;0x00014
    4df8:	05 89       	sub	r9,	r5	;
    4dfa:	0e 45       	mov	r5,	r14	;
    4dfc:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4e00:	0f 4e       	mov	r14,	r15	;
    4e02:	0f e5       	xor	r5,	r15	;
    4e04:	0f 8e       	sub	r14,	r15	;
    4e06:	0e 4f       	mov	r15,	r14	;
    4e08:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4e0c:	07 4e       	mov	r14,	r7	;
    4e0e:	07 5d       	add	r13,	r7	;
    4e10:	05 4b       	mov	r11,	r5	;
    4e12:	05 6f       	addc	r15,	r5	;
    4e14:	7e 40 03 00 	mov.b	#3,	r14	;
    4e18:	4f 43       	clr.b	r15		;
    4e1a:	1c 51 0e 00 	add	14(r1),	r12	;0x0000e
    4e1e:	1d 41 18 00 	mov	24(r1),	r13	;0x00018
    4e22:	1d 61 10 00 	addc	16(r1),	r13	;0x00010
    4e26:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4e2a:	0b 4c       	mov	r12,	r11	;
    4e2c:	7e 40 03 00 	mov.b	#3,	r14	;
    4e30:	4f 43       	clr.b	r15		;
    4e32:	0c 46       	mov	r6,	r12	;
    4e34:	0d 44       	mov	r4,	r13	;
    4e36:	81 4b 02 00 	mov	r11,	2(r1)	;
    4e3a:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4e3e:	06 4c       	mov	r12,	r6	;
    4e40:	7e 40 03 00 	mov.b	#3,	r14	;
    4e44:	4f 43       	clr.b	r15		;
    4e46:	0c 47       	mov	r7,	r12	;
    4e48:	0d 45       	mov	r5,	r13	;
    4e4a:	b0 12 b4 5d 	call	#23988		;#0x5db4
    4e4e:	05 4c       	mov	r12,	r5	;
    4e50:	1b 41 02 00 	mov	2(r1),	r11	;
    4e54:	0c 4b       	mov	r11,	r12	;
    4e56:	0d 4b       	mov	r11,	r13	;
    4e58:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4e5c:	07 4c       	mov	r12,	r7	;
    4e5e:	0c 46       	mov	r6,	r12	;
    4e60:	0d 46       	mov	r6,	r13	;
    4e62:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4e66:	07 5c       	add	r12,	r7	;
    4e68:	0c 45       	mov	r5,	r12	;
    4e6a:	0d 45       	mov	r5,	r13	;
    4e6c:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4e70:	07 5c       	add	r12,	r7	;
    4e72:	1c 41 04 00 	mov	4(r1),	r12	;
    4e76:	0d 4c       	mov	r12,	r13	;
    4e78:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4e7c:	06 4c       	mov	r12,	r6	;
    4e7e:	0c 48       	mov	r8,	r12	;
    4e80:	0d 48       	mov	r8,	r13	;
    4e82:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4e86:	06 5c       	add	r12,	r6	;
    4e88:	0c 49       	mov	r9,	r12	;
    4e8a:	0d 49       	mov	r9,	r13	;
    4e8c:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    4e90:	06 5c       	add	r12,	r6	;
    4e92:	08 46       	mov	r6,	r8	;
    4e94:	09 43       	clr	r9		;
    4e96:	75 40 80 00 	mov.b	#128,	r5	;#0x0080
    4e9a:	3b 40 ff 3f 	mov	#16383,	r11	;#0x3fff
    4e9e:	0b 96       	cmp	r6,	r11	;
    4ea0:	01 28       	jnc	$+4      	;abs 0x4ea4
    4ea2:	45 43       	clr.b	r5		;

00004ea4 <.L163>:
    4ea4:	04 45       	mov	r5,	r4	;
    4ea6:	34 d0 40 00 	bis	#64,	r4	;#0x0040
    4eaa:	0c 44       	mov	r4,	r12	;
    4eac:	4d 43       	clr.b	r13		;
    4eae:	0e 44       	mov	r4,	r14	;
    4eb0:	4f 43       	clr.b	r15		;
    4eb2:	b0 12 10 5e 	call	#24080		;#0x5e10
    4eb6:	0d 93       	cmp	#0,	r13	;r3 As==00
    4eb8:	04 20       	jnz	$+10     	;abs 0x4ec2
    4eba:	09 93       	cmp	#0,	r9	;r3 As==00
    4ebc:	05 20       	jnz	$+12     	;abs 0x4ec8
    4ebe:	06 9c       	cmp	r12,	r6	;
    4ec0:	03 2c       	jc	$+8      	;abs 0x4ec8

00004ec2 <.L382>:
    4ec2:	04 45       	mov	r5,	r4	;
    4ec4:	34 f0 bf ff 	and	#-65,	r4	;#0xffbf

00004ec8 <.L165>:
    4ec8:	05 44       	mov	r4,	r5	;
    4eca:	35 d0 20 00 	bis	#32,	r5	;#0x0020
    4ece:	0c 45       	mov	r5,	r12	;
    4ed0:	4d 43       	clr.b	r13		;
    4ed2:	0e 45       	mov	r5,	r14	;
    4ed4:	4f 43       	clr.b	r15		;
    4ed6:	b0 12 10 5e 	call	#24080		;#0x5e10
    4eda:	0d 93       	cmp	#0,	r13	;r3 As==00
    4edc:	04 20       	jnz	$+10     	;abs 0x4ee6
    4ede:	09 93       	cmp	#0,	r9	;r3 As==00
    4ee0:	05 20       	jnz	$+12     	;abs 0x4eec
    4ee2:	06 9c       	cmp	r12,	r6	;
    4ee4:	03 2c       	jc	$+8      	;abs 0x4eec

00004ee6 <.L383>:
    4ee6:	05 44       	mov	r4,	r5	;
    4ee8:	35 f0 df ff 	and	#-33,	r5	;#0xffdf

00004eec <.L167>:
    4eec:	04 45       	mov	r5,	r4	;
    4eee:	34 d0 10 00 	bis	#16,	r4	;#0x0010
    4ef2:	0c 44       	mov	r4,	r12	;
    4ef4:	4d 43       	clr.b	r13		;
    4ef6:	0e 44       	mov	r4,	r14	;
    4ef8:	4f 43       	clr.b	r15		;
    4efa:	b0 12 10 5e 	call	#24080		;#0x5e10
    4efe:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f00:	04 20       	jnz	$+10     	;abs 0x4f0a
    4f02:	09 93       	cmp	#0,	r9	;r3 As==00
    4f04:	05 20       	jnz	$+12     	;abs 0x4f10
    4f06:	06 9c       	cmp	r12,	r6	;
    4f08:	03 2c       	jc	$+8      	;abs 0x4f10

00004f0a <.L384>:
    4f0a:	04 45       	mov	r5,	r4	;
    4f0c:	34 f0 ef ff 	and	#-17,	r4	;#0xffef

00004f10 <.L169>:
    4f10:	05 44       	mov	r4,	r5	;
    4f12:	35 d2       	bis	#8,	r5	;r2 As==11
    4f14:	0c 45       	mov	r5,	r12	;
    4f16:	4d 43       	clr.b	r13		;
    4f18:	0e 45       	mov	r5,	r14	;
    4f1a:	4f 43       	clr.b	r15		;
    4f1c:	b0 12 10 5e 	call	#24080		;#0x5e10
    4f20:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f22:	02 24       	jz	$+6      	;abs 0x4f28
    4f24:	80 00 ba 59 	mova	#22970,	r0	;0x059ba
    4f28:	09 93       	cmp	#0,	r9	;r3 As==00
    4f2a:	04 20       	jnz	$+10     	;abs 0x4f34
    4f2c:	06 9c       	cmp	r12,	r6	;
    4f2e:	02 2c       	jc	$+6      	;abs 0x4f34
    4f30:	80 00 ba 59 	mova	#22970,	r0	;0x059ba

00004f34 <.L171>:
    4f34:	04 45       	mov	r5,	r4	;
    4f36:	24 d2       	bis	#4,	r4	;r2 As==10
    4f38:	0c 44       	mov	r4,	r12	;
    4f3a:	4d 43       	clr.b	r13		;
    4f3c:	0e 44       	mov	r4,	r14	;
    4f3e:	4f 43       	clr.b	r15		;
    4f40:	b0 12 10 5e 	call	#24080		;#0x5e10
    4f44:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f46:	02 24       	jz	$+6      	;abs 0x4f4c
    4f48:	80 00 b2 59 	mova	#22962,	r0	;0x059b2
    4f4c:	09 93       	cmp	#0,	r9	;r3 As==00
    4f4e:	04 20       	jnz	$+10     	;abs 0x4f58
    4f50:	06 9c       	cmp	r12,	r6	;
    4f52:	02 2c       	jc	$+6      	;abs 0x4f58
    4f54:	80 00 b2 59 	mova	#22962,	r0	;0x059b2

00004f58 <.L173>:
    4f58:	05 44       	mov	r4,	r5	;
    4f5a:	25 d3       	bis	#2,	r5	;r3 As==10
    4f5c:	0c 45       	mov	r5,	r12	;
    4f5e:	4d 43       	clr.b	r13		;
    4f60:	0e 45       	mov	r5,	r14	;
    4f62:	4f 43       	clr.b	r15		;
    4f64:	b0 12 10 5e 	call	#24080		;#0x5e10
    4f68:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f6a:	02 24       	jz	$+6      	;abs 0x4f70
    4f6c:	80 00 aa 59 	mova	#22954,	r0	;0x059aa
    4f70:	09 93       	cmp	#0,	r9	;r3 As==00
    4f72:	04 20       	jnz	$+10     	;abs 0x4f7c
    4f74:	06 9c       	cmp	r12,	r6	;
    4f76:	02 2c       	jc	$+6      	;abs 0x4f7c
    4f78:	80 00 aa 59 	mova	#22954,	r0	;0x059aa

00004f7c <.L175>:
    4f7c:	04 45       	mov	r5,	r4	;
    4f7e:	14 d3       	bis	#1,	r4	;r3 As==01
    4f80:	0c 44       	mov	r4,	r12	;
    4f82:	4d 43       	clr.b	r13		;
    4f84:	0e 44       	mov	r4,	r14	;
    4f86:	4f 43       	clr.b	r15		;
    4f88:	b0 12 10 5e 	call	#24080		;#0x5e10
    4f8c:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f8e:	02 24       	jz	$+6      	;abs 0x4f94
    4f90:	80 00 7c 59 	mova	#22908,	r0	;0x0597c
    4f94:	09 93       	cmp	#0,	r9	;r3 As==00
    4f96:	04 20       	jnz	$+10     	;abs 0x4fa0
    4f98:	06 9c       	cmp	r12,	r6	;
    4f9a:	02 2c       	jc	$+6      	;abs 0x4fa0
    4f9c:	80 00 7c 59 	mova	#22908,	r0	;0x0597c

00004fa0 <.L177>:
    4fa0:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    4fa4:	08 47       	mov	r7,	r8	;
    4fa6:	09 43       	clr	r9		;
    4fa8:	3c 40 ff 0f 	mov	#4095,	r12	;#0x0fff
    4fac:	0c 97       	cmp	r7,	r12	;
    4fae:	02 2c       	jc	$+6      	;abs 0x4fb4
    4fb0:	80 00 94 59 	mova	#22932,	r0	;0x05994

00004fb4 <.L524>:
    4fb4:	3d 40 ff 03 	mov	#1023,	r13	;#0x03ff
    4fb8:	75 40 20 00 	mov.b	#32,	r5	;#0x0020
    4fbc:	0d 97       	cmp	r7,	r13	;
    4fbe:	02 28       	jnc	$+6      	;abs 0x4fc4
    4fc0:	80 00 62 5a 	mova	#23138,	r0	;0x05a62
    4fc4:	46 43       	clr.b	r6		;

00004fc6 <.L180>:
    4fc6:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4fca:	0c 45       	mov	r5,	r12	;
    4fcc:	0d 46       	mov	r6,	r13	;
    4fce:	0e 45       	mov	r5,	r14	;
    4fd0:	0f 46       	mov	r6,	r15	;
    4fd2:	b0 12 10 5e 	call	#24080		;#0x5e10
    4fd6:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fd8:	02 24       	jz	$+6      	;abs 0x4fde
    4fda:	80 00 a2 59 	mova	#22946,	r0	;0x059a2
    4fde:	09 93       	cmp	#0,	r9	;r3 As==00
    4fe0:	02 20       	jnz	$+6      	;abs 0x4fe6
    4fe2:	80 00 d4 5c 	mova	#23764,	r0	;0x05cd4

00004fe6 <.L182>:
    4fe6:	04 45       	mov	r5,	r4	;
    4fe8:	34 d2       	bis	#8,	r4	;r2 As==11
    4fea:	0c 44       	mov	r4,	r12	;
    4fec:	0d 46       	mov	r6,	r13	;
    4fee:	0e 44       	mov	r4,	r14	;
    4ff0:	0f 46       	mov	r6,	r15	;
    4ff2:	b0 12 10 5e 	call	#24080		;#0x5e10
    4ff6:	0d 93       	cmp	#0,	r13	;r3 As==00
    4ff8:	02 24       	jz	$+6      	;abs 0x4ffe
    4ffa:	80 00 74 59 	mova	#22900,	r0	;0x05974
    4ffe:	09 93       	cmp	#0,	r9	;r3 As==00
    5000:	04 20       	jnz	$+10     	;abs 0x500a
    5002:	07 9c       	cmp	r12,	r7	;
    5004:	02 2c       	jc	$+6      	;abs 0x500a
    5006:	80 00 74 59 	mova	#22900,	r0	;0x05974

0000500a <.L184>:
    500a:	05 44       	mov	r4,	r5	;
    500c:	25 d2       	bis	#4,	r5	;r2 As==10
    500e:	0c 45       	mov	r5,	r12	;
    5010:	0d 46       	mov	r6,	r13	;
    5012:	0e 45       	mov	r5,	r14	;
    5014:	0f 46       	mov	r6,	r15	;
    5016:	b0 12 10 5e 	call	#24080		;#0x5e10
    501a:	0d 93       	cmp	#0,	r13	;r3 As==00
    501c:	02 24       	jz	$+6      	;abs 0x5022
    501e:	80 00 6c 59 	mova	#22892,	r0	;0x0596c
    5022:	09 93       	cmp	#0,	r9	;r3 As==00
    5024:	04 20       	jnz	$+10     	;abs 0x502e
    5026:	07 9c       	cmp	r12,	r7	;
    5028:	02 2c       	jc	$+6      	;abs 0x502e
    502a:	80 00 6c 59 	mova	#22892,	r0	;0x0596c

0000502e <.L186>:
    502e:	04 45       	mov	r5,	r4	;
    5030:	24 d3       	bis	#2,	r4	;r3 As==10
    5032:	0c 44       	mov	r4,	r12	;
    5034:	0d 46       	mov	r6,	r13	;
    5036:	0e 44       	mov	r4,	r14	;
    5038:	0f 46       	mov	r6,	r15	;
    503a:	b0 12 10 5e 	call	#24080		;#0x5e10
    503e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5040:	02 24       	jz	$+6      	;abs 0x5046
    5042:	80 00 64 59 	mova	#22884,	r0	;0x05964
    5046:	09 93       	cmp	#0,	r9	;r3 As==00
    5048:	04 20       	jnz	$+10     	;abs 0x5052
    504a:	07 9c       	cmp	r12,	r7	;
    504c:	02 2c       	jc	$+6      	;abs 0x5052
    504e:	80 00 64 59 	mova	#22884,	r0	;0x05964

00005052 <.L188>:
    5052:	05 44       	mov	r4,	r5	;
    5054:	15 d3       	bis	#1,	r5	;r3 As==01
    5056:	0c 45       	mov	r5,	r12	;
    5058:	0d 46       	mov	r6,	r13	;
    505a:	0e 45       	mov	r5,	r14	;
    505c:	0f 46       	mov	r6,	r15	;
    505e:	b0 12 10 5e 	call	#24080		;#0x5e10
    5062:	0d 93       	cmp	#0,	r13	;r3 As==00
    5064:	04 20       	jnz	$+10     	;abs 0x506e
    5066:	09 93       	cmp	#0,	r9	;r3 As==00
    5068:	04 20       	jnz	$+10     	;abs 0x5072
    506a:	07 9c       	cmp	r12,	r7	;
    506c:	02 2c       	jc	$+6      	;abs 0x5072

0000506e <.L393>:
    506e:	05 44       	mov	r4,	r5	;
    5070:	15 c3       	bic	#1,	r5	;r3 As==01

00005072 <.L190>:
    5072:	81 45 24 00 	mov	r5,	36(r1)	; 0x0024
    5076:	15 41 0c 00 	mov	12(r1),	r5	;0x0000c
    507a:	95 41 22 00 	mov	34(r1),	0(r5)	;0x00022
    507e:	00 00 
    5080:	95 41 24 00 	mov	36(r1),	2(r5)	;0x00024
    5084:	02 00 
    5086:	25 52       	add	#4,	r5	;r2 As==10
    5088:	81 45 0c 00 	mov	r5,	12(r1)	; 0x000c
    508c:	36 40 82 1c 	mov	#7298,	r6	;#0x1c82
    5090:	06 95       	cmp	r5,	r6	;
    5092:	02 24       	jz	$+6      	;abs 0x5098
    5094:	80 00 da 49 	mova	#18906,	r0	;0x049da
    5098:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    509c:	b0 12 f0 40 	call	#16624		;#0x40f0
    50a0:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    50a4:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    50a8:	b0 12 44 41 	call	#16708		;#0x4144
    50ac:	82 43 82 1c 	mov	#0,	&0x1c82	;r3 As==00
    50b0:	b0 12 d4 40 	call	#16596		;#0x40d4
    50b4:	91 42 00 1c 	mov	&0x1c00,14(r1)	;0x1c00, 0x000e
    50b8:	0e 00 
    50ba:	b1 40 0a 00 	mov	#10,	34(r1)	;#0x000a, 0x0022
    50be:	22 00 

000050c0 <.L238>:
    50c0:	81 43 14 00 	mov	#0,	20(r1)	;r3 As==00, 0x0014

000050c4 <.L322>:
    50c4:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    50c8:	1c 41 0e 00 	mov	14(r1),	r12	;0x0000e
    50cc:	5c f3       	and.b	#1,	r12	;r3 As==01
    50ce:	1a 41 0e 00 	mov	14(r1),	r10	;0x0000e
    50d2:	5a 03       	rrum	#1,	r10	;
    50d4:	0d 93       	cmp	#0,	r13	;r3 As==00
    50d6:	02 20       	jnz	$+6      	;abs 0x50dc
    50d8:	80 00 a0 57 	mova	#22432,	r0	;0x057a0

000050dc <.L517>:
    50dc:	0c 93       	cmp	#0,	r12	;r3 As==00
    50de:	02 24       	jz	$+6      	;abs 0x50e4
    50e0:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

000050e4 <.L247>:
    50e4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    50e8:	0c 4a       	mov	r10,	r12	;
    50ea:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    50ee:	45 4c       	mov.b	r12,	r5	;
    50f0:	75 50 e2 ff 	add.b	#-30,	r5	;#0xffe2
    50f4:	85 11       	sxt	r5		;
    50f6:	08 4a       	mov	r10,	r8	;
    50f8:	58 03       	rrum	#1,	r8	;
    50fa:	1a b3       	bit	#1,	r10	;r3 As==01
    50fc:	02 24       	jz	$+6      	;abs 0x5102
    50fe:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

00005102 <.L246>:
    5102:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5106:	0c 48       	mov	r8,	r12	;
    5108:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    510c:	4a 4c       	mov.b	r12,	r10	;
    510e:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    5112:	8a 11       	sxt	r10		;
    5114:	09 48       	mov	r8,	r9	;
    5116:	59 03       	rrum	#1,	r9	;
    5118:	18 b3       	bit	#1,	r8	;r3 As==01
    511a:	02 24       	jz	$+6      	;abs 0x5120
    511c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

00005120 <.L245>:
    5120:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5124:	0c 49       	mov	r9,	r12	;
    5126:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    512a:	44 4c       	mov.b	r12,	r4	;
    512c:	74 50 e2 ff 	add.b	#-30,	r4	;#0xffe2
    5130:	84 11       	sxt	r4		;
    5132:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    5136:	0c 49       	mov	r9,	r12	;
    5138:	5c f3       	and.b	#1,	r12	;r3 As==01
    513a:	59 03       	rrum	#1,	r9	;
    513c:	0d 93       	cmp	#0,	r13	;r3 As==00
    513e:	02 20       	jnz	$+6      	;abs 0x5144
    5140:	80 00 f6 57 	mova	#22518,	r0	;0x057f6

00005144 <.L518>:
    5144:	0c 93       	cmp	#0,	r12	;r3 As==00
    5146:	02 24       	jz	$+6      	;abs 0x514c
    5148:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

0000514c <.L261>:
    514c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5150:	0c 49       	mov	r9,	r12	;
    5152:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    5156:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    515a:	8c 11       	sxt	r12		;
    515c:	81 4c 0c 00 	mov	r12,	12(r1)	; 0x000c
    5160:	08 49       	mov	r9,	r8	;
    5162:	58 03       	rrum	#1,	r8	;
    5164:	19 b3       	bit	#1,	r9	;r3 As==01
    5166:	02 24       	jz	$+6      	;abs 0x516c
    5168:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400

0000516c <.L260>:
    516c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5170:	0c 48       	mov	r8,	r12	;
    5172:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    5176:	47 4c       	mov.b	r12,	r7	;
    5178:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    517c:	87 11       	sxt	r7		;
    517e:	09 48       	mov	r8,	r9	;
    5180:	59 03       	rrum	#1,	r9	;
    5182:	18 b3       	bit	#1,	r8	;r3 As==01
    5184:	02 24       	jz	$+6      	;abs 0x518a
    5186:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

0000518a <.L259>:
    518a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    518e:	0c 49       	mov	r9,	r12	;
    5190:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    5194:	48 4c       	mov.b	r12,	r8	;
    5196:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    519a:	88 11       	sxt	r8		;
    519c:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    51a0:	0c 49       	mov	r9,	r12	;
    51a2:	5c f3       	and.b	#1,	r12	;r3 As==01
    51a4:	59 03       	rrum	#1,	r9	;
    51a6:	0d 93       	cmp	#0,	r13	;r3 As==00
    51a8:	02 20       	jnz	$+6      	;abs 0x51ae
    51aa:	80 00 50 58 	mova	#22608,	r0	;0x05850

000051ae <.L519>:
    51ae:	0c 93       	cmp	#0,	r12	;r3 As==00
    51b0:	02 24       	jz	$+6      	;abs 0x51b6
    51b2:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

000051b6 <.L275>:
    51b6:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    51ba:	0c 49       	mov	r9,	r12	;
    51bc:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    51c0:	46 4c       	mov.b	r12,	r6	;
    51c2:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    51c6:	86 11       	sxt	r6		;
    51c8:	0e 49       	mov	r9,	r14	;
    51ca:	5e 03       	rrum	#1,	r14	;
    51cc:	19 b3       	bit	#1,	r9	;r3 As==01
    51ce:	02 24       	jz	$+6      	;abs 0x51d4
    51d0:	3e e0 00 b4 	xor	#-19456,r14	;#0xb400

000051d4 <.L274>:
    51d4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    51d8:	0c 4e       	mov	r14,	r12	;
    51da:	81 4e 02 00 	mov	r14,	2(r1)	;
    51de:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    51e2:	49 4c       	mov.b	r12,	r9	;
    51e4:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    51e8:	89 11       	sxt	r9		;
    51ea:	1e 41 02 00 	mov	2(r1),	r14	;
    51ee:	0b 4e       	mov	r14,	r11	;
    51f0:	5b 03       	rrum	#1,	r11	;
    51f2:	81 4b 0e 00 	mov	r11,	14(r1)	; 0x000e
    51f6:	1e b3       	bit	#1,	r14	;r3 As==01
    51f8:	03 24       	jz	$+8      	;abs 0x5200
    51fa:	b1 e0 00 b4 	xor	#-19456,14(r1)	;#0xb400, 0x000e
    51fe:	0e 00 

00005200 <.L273>:
    5200:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5204:	1c 41 0e 00 	mov	14(r1),	r12	;0x0000e
    5208:	b0 12 2c 5d 	call	#23852		;#0x5d2c
    520c:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    5210:	8c 11       	sxt	r12		;
    5212:	0e 45       	mov	r5,	r14	;
    5214:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5218:	4d 4e       	mov.b	r14,	r13	;
    521a:	4d e5       	xor.b	r5,	r13	;
    521c:	4d 8e       	sub.b	r14,	r13	;
    521e:	7e 40 09 00 	mov.b	#9,	r14	;
    5222:	4e 9d       	cmp.b	r13,	r14	;
    5224:	02 28       	jnc	$+6      	;abs 0x522a
    5226:	80 00 b4 58 	mova	#22708,	r0	;0x058b4

0000522a <.L520>:
    522a:	81 45 16 00 	mov	r5,	22(r1)	; 0x0016
    522e:	0d 45       	mov	r5,	r13	;
    5230:	0e 45       	mov	r5,	r14	;
    5232:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5236:	81 4d 04 00 	mov	r13,	4(r1)	;
    523a:	81 4e 06 00 	mov	r14,	6(r1)	;
    523e:	0e 4a       	mov	r10,	r14	;
    5240:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5244:	4d 4e       	mov.b	r14,	r13	;
    5246:	4d ea       	xor.b	r10,	r13	;
    5248:	4d 8e       	sub.b	r14,	r13	;
    524a:	7f 40 09 00 	mov.b	#9,	r15	;
    524e:	4f 9d       	cmp.b	r13,	r15	;
    5250:	02 28       	jnc	$+6      	;abs 0x5256
    5252:	80 00 d8 58 	mova	#22744,	r0	;0x058d8

00005256 <.L521>:
    5256:	81 4a 18 00 	mov	r10,	24(r1)	; 0x0018
    525a:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    525e:	0b 7b       	subc	r11,	r11	;
    5260:	3b e3       	inv	r11		;
    5262:	81 4a 08 00 	mov	r10,	8(r1)	;
    5266:	81 4b 0a 00 	mov	r11,	10(r1)	; 0x000a
    526a:	0e 44       	mov	r4,	r14	;
    526c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5270:	4d 44       	mov.b	r4,	r13	;
    5272:	4d ee       	xor.b	r14,	r13	;
    5274:	4d 8e       	sub.b	r14,	r13	;
    5276:	7e 40 09 00 	mov.b	#9,	r14	;
    527a:	4e 9d       	cmp.b	r13,	r14	;
    527c:	02 28       	jnc	$+6      	;abs 0x5282
    527e:	80 00 fc 58 	mova	#22780,	r0	;0x058fc

00005282 <.L522>:
    5282:	0a 44       	mov	r4,	r10	;
    5284:	0b 44       	mov	r4,	r11	;
    5286:	4e 18 0b 11 	rpt #15 { rrax.w	r11		;

0000528a <.L284>:
    528a:	1e 41 0c 00 	mov	12(r1),	r14	;0x0000c
    528e:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5292:	1d 41 0c 00 	mov	12(r1),	r13	;0x0000c
    5296:	4d ee       	xor.b	r14,	r13	;
    5298:	4d 8e       	sub.b	r14,	r13	;
    529a:	81 43 12 00 	mov	#0,	18(r1)	;r3 As==00, 0x0012
    529e:	7f 40 09 00 	mov.b	#9,	r15	;
    52a2:	4f 9d       	cmp.b	r13,	r15	;
    52a4:	12 2c       	jc	$+38     	;abs 0x52ca
    52a6:	91 41 0c 00 	mov	12(r1),	18(r1)	;0x0000c, 0x0012
    52aa:	12 00 
    52ac:	1e 41 12 00 	mov	18(r1),	r14	;0x00012
    52b0:	0d 4e       	mov	r14,	r13	;
    52b2:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    52b6:	81 4d 1e 00 	mov	r13,	30(r1)	; 0x001e
    52ba:	81 4e 20 00 	mov	r14,	32(r1)	; 0x0020
    52be:	91 51 1e 00 	rla	30(r1)		;#0x0001e
    52c2:	04 00 
    52c4:	91 61 20 00 	rlc	32(r1)		;#0x00020
    52c8:	06 00 

000052ca <.L285>:
    52ca:	0e 47       	mov	r7,	r14	;
    52cc:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    52d0:	4d 4e       	mov.b	r14,	r13	;
    52d2:	4d e7       	xor.b	r7,	r13	;
    52d4:	4d 8e       	sub.b	r14,	r13	;
    52d6:	45 43       	clr.b	r5		;
    52d8:	7f 40 09 00 	mov.b	#9,	r15	;
    52dc:	4f 9d       	cmp.b	r13,	r15	;
    52de:	0f 2c       	jc	$+32     	;abs 0x52fe
    52e0:	05 47       	mov	r7,	r5	;
    52e2:	0d 47       	mov	r7,	r13	;
    52e4:	0e 47       	mov	r7,	r14	;
    52e6:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    52ea:	81 4d 1e 00 	mov	r13,	30(r1)	; 0x001e
    52ee:	81 4e 20 00 	mov	r14,	32(r1)	; 0x0020
    52f2:	91 51 1e 00 	rla	30(r1)		;#0x0001e
    52f6:	08 00 
    52f8:	91 61 20 00 	rlc	32(r1)		;#0x00020
    52fc:	0a 00 

000052fe <.L286>:
    52fe:	0e 48       	mov	r8,	r14	;
    5300:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5304:	4d 4e       	mov.b	r14,	r13	;
    5306:	4d e8       	xor.b	r8,	r13	;
    5308:	4d 8e       	sub.b	r14,	r13	;
    530a:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    530e:	7e 40 09 00 	mov.b	#9,	r14	;
    5312:	4e 9d       	cmp.b	r13,	r14	;
    5314:	08 2c       	jc	$+18     	;abs 0x5326
    5316:	81 48 0c 00 	mov	r8,	12(r1)	; 0x000c
    531a:	0e 48       	mov	r8,	r14	;
    531c:	0f 48       	mov	r8,	r15	;
    531e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5322:	0a 5e       	add	r14,	r10	;
    5324:	0b 6f       	addc	r15,	r11	;

00005326 <.L287>:
    5326:	0e 46       	mov	r6,	r14	;
    5328:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    532c:	4d 4e       	mov.b	r14,	r13	;
    532e:	4d e6       	xor.b	r6,	r13	;
    5330:	4d 8e       	sub.b	r14,	r13	;
    5332:	7f 40 09 00 	mov.b	#9,	r15	;
    5336:	4f 9d       	cmp.b	r13,	r15	;
    5338:	02 28       	jnc	$+6      	;abs 0x533e
    533a:	80 00 06 5a 	mova	#23046,	r0	;0x05a06
    533e:	81 46 1a 00 	mov	r6,	26(r1)	; 0x001a
    5342:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    5346:	07 77       	subc	r7,	r7	;
    5348:	37 e3       	inv	r7		;

0000534a <.L288>:
    534a:	0e 49       	mov	r9,	r14	;
    534c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5350:	4d 4e       	mov.b	r14,	r13	;
    5352:	4d e9       	xor.b	r9,	r13	;
    5354:	4d 8e       	sub.b	r14,	r13	;
    5356:	7e 40 09 00 	mov.b	#9,	r14	;
    535a:	4e 9d       	cmp.b	r13,	r14	;
    535c:	02 28       	jnc	$+6      	;abs 0x5362
    535e:	80 00 fa 59 	mova	#23034,	r0	;0x059fa
    5362:	81 49 1c 00 	mov	r9,	28(r1)	; 0x001c
    5366:	0e 49       	mov	r9,	r14	;
    5368:	0f 49       	mov	r9,	r15	;
    536a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;

0000536e <.L289>:
    536e:	09 4c       	mov	r12,	r9	;
    5370:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    5374:	4d 49       	mov.b	r9,	r13	;
    5376:	4d ec       	xor.b	r12,	r13	;
    5378:	4d 89       	sub.b	r9,	r13	;
    537a:	79 40 09 00 	mov.b	#9,	r9	;
    537e:	49 9d       	cmp.b	r13,	r9	;
    5380:	02 28       	jnc	$+6      	;abs 0x5386
    5382:	80 00 ee 59 	mova	#23022,	r0	;0x059ee
    5386:	81 4c 1e 00 	mov	r12,	30(r1)	; 0x001e
    538a:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    538e:	0d 7d       	subc	r13,	r13	;
    5390:	3d e3       	inv	r13		;

00005392 <.L290>:
    5392:	09 4e       	mov	r14,	r9	;
    5394:	19 51 08 00 	add	8(r1),	r9	;
    5398:	18 41 0a 00 	mov	10(r1),	r8	;0x0000a
    539c:	08 6f       	addc	r15,	r8	;
    539e:	0a 5c       	add	r12,	r10	;
    53a0:	0b 6d       	addc	r13,	r11	;
    53a2:	7e 40 03 00 	mov.b	#3,	r14	;
    53a6:	4f 43       	clr.b	r15		;
    53a8:	0c 46       	mov	r6,	r12	;
    53aa:	1c 51 04 00 	add	4(r1),	r12	;
    53ae:	1d 41 06 00 	mov	6(r1),	r13	;
    53b2:	0d 67       	addc	r7,	r13	;
    53b4:	81 4b 02 00 	mov	r11,	2(r1)	;
    53b8:	b0 12 b4 5d 	call	#23988		;#0x5db4
    53bc:	81 4c 04 00 	mov	r12,	4(r1)	;
    53c0:	7e 40 03 00 	mov.b	#3,	r14	;
    53c4:	4f 43       	clr.b	r15		;
    53c6:	0c 49       	mov	r9,	r12	;
    53c8:	0d 48       	mov	r8,	r13	;
    53ca:	b0 12 b4 5d 	call	#23988		;#0x5db4
    53ce:	81 4c 08 00 	mov	r12,	8(r1)	;
    53d2:	7e 40 03 00 	mov.b	#3,	r14	;
    53d6:	4f 43       	clr.b	r15		;
    53d8:	0c 4a       	mov	r10,	r12	;
    53da:	1b 41 02 00 	mov	2(r1),	r11	;
    53de:	0d 4b       	mov	r11,	r13	;
    53e0:	b0 12 b4 5d 	call	#23988		;#0x5db4
    53e4:	06 4c       	mov	r12,	r6	;
    53e6:	1c 41 16 00 	mov	22(r1),	r12	;0x00016
    53ea:	1c 81 04 00 	sub	4(r1),	r12	;
    53ee:	0d 4c       	mov	r12,	r13	;
    53f0:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    53f4:	0c ed       	xor	r13,	r12	;
    53f6:	0c 8d       	sub	r13,	r12	;
    53f8:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    53fc:	0d 7d       	subc	r13,	r13	;
    53fe:	3d e3       	inv	r13		;
    5400:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    5404:	1a 81 04 00 	sub	4(r1),	r10	;
    5408:	0f 4a       	mov	r10,	r15	;
    540a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    540e:	0a ef       	xor	r15,	r10	;
    5410:	0e 4a       	mov	r10,	r14	;
    5412:	0e 8f       	sub	r15,	r14	;
    5414:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    5418:	0f 7f       	subc	r15,	r15	;
    541a:	3f e3       	inv	r15		;
    541c:	0c 5e       	add	r14,	r12	;
    541e:	0a 4d       	mov	r13,	r10	;
    5420:	0a 6f       	addc	r15,	r10	;
    5422:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5426:	1a 41 18 00 	mov	24(r1),	r10	;0x00018
    542a:	1a 81 08 00 	sub	8(r1),	r10	;
    542e:	0d 4a       	mov	r10,	r13	;
    5430:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5434:	0a ed       	xor	r13,	r10	;
    5436:	0e 4a       	mov	r10,	r14	;
    5438:	0e 8d       	sub	r13,	r14	;
    543a:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    543e:	0f 7f       	subc	r15,	r15	;
    5440:	3f e3       	inv	r15		;
    5442:	15 81 08 00 	sub	8(r1),	r5	;
    5446:	0d 45       	mov	r5,	r13	;
    5448:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    544c:	05 ed       	xor	r13,	r5	;
    544e:	0a 45       	mov	r5,	r10	;
    5450:	0a 8d       	sub	r13,	r10	;
    5452:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    5456:	0b 7b       	subc	r11,	r11	;
    5458:	3b e3       	inv	r11		;
    545a:	08 4e       	mov	r14,	r8	;
    545c:	08 5a       	add	r10,	r8	;
    545e:	07 4f       	mov	r15,	r7	;
    5460:	07 6b       	addc	r11,	r7	;
    5462:	04 86       	sub	r6,	r4	;
    5464:	0d 44       	mov	r4,	r13	;
    5466:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    546a:	04 ed       	xor	r13,	r4	;
    546c:	0a 44       	mov	r4,	r10	;
    546e:	0a 8d       	sub	r13,	r10	;
    5470:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    5474:	0b 7b       	subc	r11,	r11	;
    5476:	3b e3       	inv	r11		;
    5478:	1e 41 0c 00 	mov	12(r1),	r14	;0x0000c
    547c:	0e 86       	sub	r6,	r14	;
    547e:	0d 4e       	mov	r14,	r13	;
    5480:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5484:	0e ed       	xor	r13,	r14	;
    5486:	0e 8d       	sub	r13,	r14	;
    5488:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    548c:	0f 7f       	subc	r15,	r15	;
    548e:	3f e3       	inv	r15		;
    5490:	09 4a       	mov	r10,	r9	;
    5492:	09 5e       	add	r14,	r9	;
    5494:	0d 4b       	mov	r11,	r13	;
    5496:	0d 6f       	addc	r15,	r13	;
    5498:	1a 41 1a 00 	mov	26(r1),	r10	;0x0001a
    549c:	1a 81 04 00 	sub	4(r1),	r10	;
    54a0:	0e 4a       	mov	r10,	r14	;
    54a2:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    54a6:	0a ee       	xor	r14,	r10	;
    54a8:	0a 8e       	sub	r14,	r10	;
    54aa:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    54ae:	0b 7b       	subc	r11,	r11	;
    54b0:	3b e3       	inv	r11		;
    54b2:	1e 41 1c 00 	mov	28(r1),	r14	;0x0001c
    54b6:	1e 81 08 00 	sub	8(r1),	r14	;
    54ba:	0f 4e       	mov	r14,	r15	;
    54bc:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    54c0:	0e ef       	xor	r15,	r14	;
    54c2:	0e 8f       	sub	r15,	r14	;
    54c4:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    54c8:	0f 7f       	subc	r15,	r15	;
    54ca:	3f e3       	inv	r15		;
    54cc:	08 5e       	add	r14,	r8	;
    54ce:	07 6f       	addc	r15,	r7	;
    54d0:	1e 41 1e 00 	mov	30(r1),	r14	;0x0001e
    54d4:	0e 86       	sub	r6,	r14	;
    54d6:	0f 4e       	mov	r14,	r15	;
    54d8:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    54dc:	0e ef       	xor	r15,	r14	;
    54de:	0e 8f       	sub	r15,	r14	;
    54e0:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    54e4:	0f 7f       	subc	r15,	r15	;
    54e6:	3f e3       	inv	r15		;
    54e8:	09 5e       	add	r14,	r9	;
    54ea:	05 4f       	mov	r15,	r5	;
    54ec:	05 6d       	addc	r13,	r5	;
    54ee:	7e 40 03 00 	mov.b	#3,	r14	;
    54f2:	4f 43       	clr.b	r15		;
    54f4:	0c 5a       	add	r10,	r12	;
    54f6:	1d 41 12 00 	mov	18(r1),	r13	;0x00012
    54fa:	0d 6b       	addc	r11,	r13	;
    54fc:	b0 12 b4 5d 	call	#23988		;#0x5db4
    5500:	0a 4c       	mov	r12,	r10	;
    5502:	7e 40 03 00 	mov.b	#3,	r14	;
    5506:	4f 43       	clr.b	r15		;
    5508:	0c 48       	mov	r8,	r12	;
    550a:	0d 47       	mov	r7,	r13	;
    550c:	b0 12 b4 5d 	call	#23988		;#0x5db4
    5510:	08 4c       	mov	r12,	r8	;
    5512:	7e 40 03 00 	mov.b	#3,	r14	;
    5516:	4f 43       	clr.b	r15		;
    5518:	0c 49       	mov	r9,	r12	;
    551a:	0d 45       	mov	r5,	r13	;
    551c:	b0 12 b4 5d 	call	#23988		;#0x5db4
    5520:	09 4c       	mov	r12,	r9	;
    5522:	0c 4a       	mov	r10,	r12	;
    5524:	0d 4a       	mov	r10,	r13	;
    5526:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    552a:	0a 4c       	mov	r12,	r10	;
    552c:	0c 48       	mov	r8,	r12	;
    552e:	0d 48       	mov	r8,	r13	;
    5530:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    5534:	0a 5c       	add	r12,	r10	;
    5536:	0c 49       	mov	r9,	r12	;
    5538:	0d 49       	mov	r9,	r13	;
    553a:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    553e:	0a 5c       	add	r12,	r10	;
    5540:	1c 41 04 00 	mov	4(r1),	r12	;
    5544:	0d 4c       	mov	r12,	r13	;
    5546:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    554a:	07 4c       	mov	r12,	r7	;
    554c:	1c 41 08 00 	mov	8(r1),	r12	;
    5550:	0d 4c       	mov	r12,	r13	;
    5552:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    5556:	07 5c       	add	r12,	r7	;
    5558:	0c 46       	mov	r6,	r12	;
    555a:	0d 46       	mov	r6,	r13	;
    555c:	b0 12 fc 5d 	call	#24060		;#0x5dfc
    5560:	07 5c       	add	r12,	r7	;
    5562:	08 47       	mov	r7,	r8	;
    5564:	09 43       	clr	r9		;
    5566:	75 40 80 00 	mov.b	#128,	r5	;#0x0080
    556a:	3b 40 ff 3f 	mov	#16383,	r11	;#0x3fff
    556e:	0b 97       	cmp	r7,	r11	;
    5570:	01 28       	jnc	$+4      	;abs 0x5574
    5572:	45 43       	clr.b	r5		;

00005574 <.L291>:
    5574:	06 45       	mov	r5,	r6	;
    5576:	36 d0 40 00 	bis	#64,	r6	;#0x0040
    557a:	0c 46       	mov	r6,	r12	;
    557c:	4d 43       	clr.b	r13		;
    557e:	0e 46       	mov	r6,	r14	;
    5580:	4f 43       	clr.b	r15		;
    5582:	b0 12 10 5e 	call	#24080		;#0x5e10
    5586:	0d 93       	cmp	#0,	r13	;r3 As==00
    5588:	04 20       	jnz	$+10     	;abs 0x5592
    558a:	09 93       	cmp	#0,	r9	;r3 As==00
    558c:	05 20       	jnz	$+12     	;abs 0x5598
    558e:	07 9c       	cmp	r12,	r7	;
    5590:	03 2c       	jc	$+8      	;abs 0x5598

00005592 <.L395>:
    5592:	06 45       	mov	r5,	r6	;
    5594:	36 f0 bf ff 	and	#-65,	r6	;#0xffbf

00005598 <.L293>:
    5598:	05 46       	mov	r6,	r5	;
    559a:	35 d0 20 00 	bis	#32,	r5	;#0x0020
    559e:	0c 45       	mov	r5,	r12	;
    55a0:	4d 43       	clr.b	r13		;
    55a2:	0e 45       	mov	r5,	r14	;
    55a4:	4f 43       	clr.b	r15		;
    55a6:	b0 12 10 5e 	call	#24080		;#0x5e10
    55aa:	0d 93       	cmp	#0,	r13	;r3 As==00
    55ac:	04 20       	jnz	$+10     	;abs 0x55b6
    55ae:	09 93       	cmp	#0,	r9	;r3 As==00
    55b0:	05 20       	jnz	$+12     	;abs 0x55bc
    55b2:	07 9c       	cmp	r12,	r7	;
    55b4:	03 2c       	jc	$+8      	;abs 0x55bc

000055b6 <.L396>:
    55b6:	05 46       	mov	r6,	r5	;
    55b8:	35 f0 df ff 	and	#-33,	r5	;#0xffdf

000055bc <.L295>:
    55bc:	06 45       	mov	r5,	r6	;
    55be:	36 d0 10 00 	bis	#16,	r6	;#0x0010
    55c2:	0c 46       	mov	r6,	r12	;
    55c4:	4d 43       	clr.b	r13		;
    55c6:	0e 46       	mov	r6,	r14	;
    55c8:	4f 43       	clr.b	r15		;
    55ca:	b0 12 10 5e 	call	#24080		;#0x5e10
    55ce:	0d 93       	cmp	#0,	r13	;r3 As==00
    55d0:	04 20       	jnz	$+10     	;abs 0x55da
    55d2:	09 93       	cmp	#0,	r9	;r3 As==00
    55d4:	05 20       	jnz	$+12     	;abs 0x55e0
    55d6:	07 9c       	cmp	r12,	r7	;
    55d8:	03 2c       	jc	$+8      	;abs 0x55e0

000055da <.L397>:
    55da:	06 45       	mov	r5,	r6	;
    55dc:	36 f0 ef ff 	and	#-17,	r6	;#0xffef

000055e0 <.L297>:
    55e0:	05 46       	mov	r6,	r5	;
    55e2:	35 d2       	bis	#8,	r5	;r2 As==11
    55e4:	0c 45       	mov	r5,	r12	;
    55e6:	4d 43       	clr.b	r13		;
    55e8:	0e 45       	mov	r5,	r14	;
    55ea:	4f 43       	clr.b	r15		;
    55ec:	b0 12 10 5e 	call	#24080		;#0x5e10
    55f0:	08 4a       	mov	r10,	r8	;
    55f2:	09 43       	clr	r9		;
    55f4:	3c 40 ff 0f 	mov	#4095,	r12	;#0x0fff
    55f8:	0c 9a       	cmp	r10,	r12	;
    55fa:	e9 29       	jnc	$+980    	;abs 0x59ce
    55fc:	3d 40 ff 03 	mov	#1023,	r13	;#0x03ff
    5600:	76 40 20 00 	mov.b	#32,	r6	;#0x0020
    5604:	0d 9a       	cmp	r10,	r13	;
    5606:	ef 2d       	jc	$+992    	;abs 0x59e6
    5608:	47 43       	clr.b	r7		;

0000560a <.L308>:
    560a:	36 d0 10 00 	bis	#16,	r6	;#0x0010
    560e:	0c 46       	mov	r6,	r12	;
    5610:	0d 47       	mov	r7,	r13	;
    5612:	0e 46       	mov	r6,	r14	;
    5614:	0f 47       	mov	r7,	r15	;
    5616:	b0 12 10 5e 	call	#24080		;#0x5e10
    561a:	0d 93       	cmp	#0,	r13	;r3 As==00
    561c:	df 21       	jnz	$+960    	;abs 0x59dc
    561e:	09 93       	cmp	#0,	r9	;r3 As==00
    5620:	f8 25       	jz	$+1010   	;abs 0x5a12

00005622 <.L310>:
    5622:	05 46       	mov	r6,	r5	;
    5624:	35 d2       	bis	#8,	r5	;r2 As==11
    5626:	0c 45       	mov	r5,	r12	;
    5628:	0d 47       	mov	r7,	r13	;
    562a:	0e 45       	mov	r5,	r14	;
    562c:	0f 47       	mov	r7,	r15	;
    562e:	b0 12 10 5e 	call	#24080		;#0x5e10
    5632:	0d 93       	cmp	#0,	r13	;r3 As==00
    5634:	c9 21       	jnz	$+916    	;abs 0x59c8
    5636:	09 93       	cmp	#0,	r9	;r3 As==00
    5638:	02 20       	jnz	$+6      	;abs 0x563e
    563a:	0a 9c       	cmp	r12,	r10	;
    563c:	c5 29       	jnc	$+908    	;abs 0x59c8

0000563e <.L312>:
    563e:	06 45       	mov	r5,	r6	;
    5640:	26 d2       	bis	#4,	r6	;r2 As==10
    5642:	0c 46       	mov	r6,	r12	;
    5644:	0d 47       	mov	r7,	r13	;
    5646:	0e 46       	mov	r6,	r14	;
    5648:	0f 47       	mov	r7,	r15	;
    564a:	b0 12 10 5e 	call	#24080		;#0x5e10
    564e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5650:	b8 21       	jnz	$+882    	;abs 0x59c2
    5652:	09 93       	cmp	#0,	r9	;r3 As==00
    5654:	02 20       	jnz	$+6      	;abs 0x565a
    5656:	0a 9c       	cmp	r12,	r10	;
    5658:	b4 29       	jnc	$+874    	;abs 0x59c2

0000565a <.L314>:
    565a:	3e 40 02 1c 	mov	#7170,	r14	;#0x1c02
    565e:	2c 4e       	mov	@r14,	r12	;
    5660:	1c 42 04 1c 	mov	&0x1c04,r12	;0x1c04
    5664:	1c 42 42 1c 	mov	&0x1c42,r12	;0x1c42
    5668:	1c 42 44 1c 	mov	&0x1c44,r12	;0x1c44
    566c:	1c 42 06 1c 	mov	&0x1c06,r12	;0x1c06
    5670:	1c 42 08 1c 	mov	&0x1c08,r12	;0x1c08
    5674:	1c 42 46 1c 	mov	&0x1c46,r12	;0x1c46
    5678:	1c 42 48 1c 	mov	&0x1c48,r12	;0x1c48
    567c:	1c 42 0a 1c 	mov	&0x1c0a,r12	;0x1c0a
    5680:	1c 42 0c 1c 	mov	&0x1c0c,r12	;0x1c0c
    5684:	1c 42 4a 1c 	mov	&0x1c4a,r12	;0x1c4a
    5688:	1c 42 4c 1c 	mov	&0x1c4c,r12	;0x1c4c
    568c:	1c 42 0e 1c 	mov	&0x1c0e,r12	;0x1c0e
    5690:	1c 42 10 1c 	mov	&0x1c10,r12	;0x1c10
    5694:	1c 42 4e 1c 	mov	&0x1c4e,r12	;0x1c4e
    5698:	1c 42 50 1c 	mov	&0x1c50,r12	;0x1c50
    569c:	1c 42 12 1c 	mov	&0x1c12,r12	;0x1c12
    56a0:	1c 42 14 1c 	mov	&0x1c14,r12	;0x1c14
    56a4:	1c 42 52 1c 	mov	&0x1c52,r12	;0x1c52
    56a8:	1c 42 54 1c 	mov	&0x1c54,r12	;0x1c54
    56ac:	1c 42 16 1c 	mov	&0x1c16,r12	;0x1c16
    56b0:	1c 42 18 1c 	mov	&0x1c18,r12	;0x1c18
    56b4:	1c 42 56 1c 	mov	&0x1c56,r12	;0x1c56
    56b8:	1c 42 58 1c 	mov	&0x1c58,r12	;0x1c58
    56bc:	1c 42 1a 1c 	mov	&0x1c1a,r12	;0x1c1a
    56c0:	1c 42 1c 1c 	mov	&0x1c1c,r12	;0x1c1c
    56c4:	1c 42 5a 1c 	mov	&0x1c5a,r12	;0x1c5a
    56c8:	1c 42 5c 1c 	mov	&0x1c5c,r12	;0x1c5c
    56cc:	1c 42 1e 1c 	mov	&0x1c1e,r12	;0x1c1e
    56d0:	1c 42 20 1c 	mov	&0x1c20,r12	;0x1c20
    56d4:	1c 42 5e 1c 	mov	&0x1c5e,r12	;0x1c5e
    56d8:	1c 42 60 1c 	mov	&0x1c60,r12	;0x1c60
    56dc:	1c 42 22 1c 	mov	&0x1c22,r12	;0x1c22
    56e0:	1c 42 24 1c 	mov	&0x1c24,r12	;0x1c24
    56e4:	1c 42 62 1c 	mov	&0x1c62,r12	;0x1c62
    56e8:	1c 42 64 1c 	mov	&0x1c64,r12	;0x1c64
    56ec:	1c 42 26 1c 	mov	&0x1c26,r12	;0x1c26
    56f0:	1c 42 28 1c 	mov	&0x1c28,r12	;0x1c28
    56f4:	1c 42 66 1c 	mov	&0x1c66,r12	;0x1c66
    56f8:	1c 42 68 1c 	mov	&0x1c68,r12	;0x1c68
    56fc:	1c 42 2a 1c 	mov	&0x1c2a,r12	;0x1c2a
    5700:	1c 42 2c 1c 	mov	&0x1c2c,r12	;0x1c2c
    5704:	1c 42 6a 1c 	mov	&0x1c6a,r12	;0x1c6a
    5708:	1c 42 6c 1c 	mov	&0x1c6c,r12	;0x1c6c
    570c:	1c 42 2e 1c 	mov	&0x1c2e,r12	;0x1c2e
    5710:	1c 42 30 1c 	mov	&0x1c30,r12	;0x1c30
    5714:	1c 42 6e 1c 	mov	&0x1c6e,r12	;0x1c6e
    5718:	1c 42 70 1c 	mov	&0x1c70,r12	;0x1c70
    571c:	1c 42 32 1c 	mov	&0x1c32,r12	;0x1c32
    5720:	1c 42 34 1c 	mov	&0x1c34,r12	;0x1c34
    5724:	1c 42 72 1c 	mov	&0x1c72,r12	;0x1c72
    5728:	1c 42 74 1c 	mov	&0x1c74,r12	;0x1c74
    572c:	1c 42 36 1c 	mov	&0x1c36,r12	;0x1c36
    5730:	1c 42 38 1c 	mov	&0x1c38,r12	;0x1c38
    5734:	1c 42 76 1c 	mov	&0x1c76,r12	;0x1c76
    5738:	1c 42 78 1c 	mov	&0x1c78,r12	;0x1c78
    573c:	1c 42 3a 1c 	mov	&0x1c3a,r12	;0x1c3a
    5740:	1c 42 3c 1c 	mov	&0x1c3c,r12	;0x1c3c
    5744:	1c 42 7a 1c 	mov	&0x1c7a,r12	;0x1c7a
    5748:	1c 42 7c 1c 	mov	&0x1c7c,r12	;0x1c7c
    574c:	1c 42 3e 1c 	mov	&0x1c3e,r12	;0x1c3e
    5750:	1c 42 40 1c 	mov	&0x1c40,r12	;0x1c40
    5754:	1c 42 7e 1c 	mov	&0x1c7e,r12	;0x1c7e
    5758:	1c 42 80 1c 	mov	&0x1c80,r12	;0x1c80
    575c:	91 53 14 00 	inc	20(r1)		;
    5760:	b1 90 40 00 	cmp	#64,	20(r1)	;#0x0040, 0x0014
    5764:	14 00 
    5766:	5b 25       	jz	$+696    	;abs 0x5a1e
    5768:	b1 90 20 00 	cmp	#32,	20(r1)	;#0x0020, 0x0014
    576c:	14 00 
    576e:	02 24       	jz	$+6      	;abs 0x5774
    5770:	80 00 c4 50 	mova	#20676,	r0	;0x050c4
    5774:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    5778:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    577c:	3c 53       	add	#-1,	r12	;r3 As==11
    577e:	0c cd       	bic	r13,	r12	;
    5780:	4e 19 0c 10 	rpt #15 { rrux.w	r12		;
    5784:	82 4c 82 1c 	mov	r12,	&0x1c82	;
    5788:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    578c:	1c 41 0e 00 	mov	14(r1),	r12	;0x0000e
    5790:	5c f3       	and.b	#1,	r12	;r3 As==01
    5792:	1a 41 0e 00 	mov	14(r1),	r10	;0x0000e
    5796:	5a 03       	rrum	#1,	r10	;
    5798:	0d 93       	cmp	#0,	r13	;r3 As==00
    579a:	02 24       	jz	$+6      	;abs 0x57a0
    579c:	80 00 dc 50 	mova	#20700,	r0	;0x050dc

000057a0 <.L240>:
    57a0:	0c 93       	cmp	#0,	r12	;r3 As==00
    57a2:	02 24       	jz	$+6      	;abs 0x57a8
    57a4:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

000057a8 <.L253>:
    57a8:	45 4a       	mov.b	r10,	r5	;
    57aa:	75 f0 03 00 	and.b	#3,	r5	;
    57ae:	75 50 fe ff 	add.b	#-2,	r5	;#0xfffe
    57b2:	85 11       	sxt	r5		;
    57b4:	0d 4a       	mov	r10,	r13	;
    57b6:	5d 03       	rrum	#1,	r13	;
    57b8:	1a b3       	bit	#1,	r10	;r3 As==01
    57ba:	02 24       	jz	$+6      	;abs 0x57c0
    57bc:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

000057c0 <.L252>:
    57c0:	4a 4d       	mov.b	r13,	r10	;
    57c2:	7a f0 03 00 	and.b	#3,	r10	;
    57c6:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    57ca:	8a 11       	sxt	r10		;
    57cc:	09 4d       	mov	r13,	r9	;
    57ce:	59 03       	rrum	#1,	r9	;
    57d0:	1d b3       	bit	#1,	r13	;r3 As==01
    57d2:	02 24       	jz	$+6      	;abs 0x57d8
    57d4:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

000057d8 <.L251>:
    57d8:	44 49       	mov.b	r9,	r4	;
    57da:	74 f0 03 00 	and.b	#3,	r4	;
    57de:	74 50 fe ff 	add.b	#-2,	r4	;#0xfffe
    57e2:	84 11       	sxt	r4		;
    57e4:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    57e8:	0c 49       	mov	r9,	r12	;
    57ea:	5c f3       	and.b	#1,	r12	;r3 As==01
    57ec:	59 03       	rrum	#1,	r9	;
    57ee:	0d 93       	cmp	#0,	r13	;r3 As==00
    57f0:	02 24       	jz	$+6      	;abs 0x57f6
    57f2:	80 00 44 51 	mova	#20804,	r0	;0x05144

000057f6 <.L254>:
    57f6:	0c 93       	cmp	#0,	r12	;r3 As==00
    57f8:	02 24       	jz	$+6      	;abs 0x57fe
    57fa:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

000057fe <.L267>:
    57fe:	4c 49       	mov.b	r9,	r12	;
    5800:	7c f0 03 00 	and.b	#3,	r12	;
    5804:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5808:	8c 11       	sxt	r12		;
    580a:	81 4c 0c 00 	mov	r12,	12(r1)	; 0x000c
    580e:	0d 49       	mov	r9,	r13	;
    5810:	5d 03       	rrum	#1,	r13	;
    5812:	19 b3       	bit	#1,	r9	;r3 As==01
    5814:	02 24       	jz	$+6      	;abs 0x581a
    5816:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

0000581a <.L266>:
    581a:	47 4d       	mov.b	r13,	r7	;
    581c:	77 f0 03 00 	and.b	#3,	r7	;
    5820:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5824:	87 11       	sxt	r7		;
    5826:	09 4d       	mov	r13,	r9	;
    5828:	59 03       	rrum	#1,	r9	;
    582a:	1d b3       	bit	#1,	r13	;r3 As==01
    582c:	02 24       	jz	$+6      	;abs 0x5832
    582e:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

00005832 <.L265>:
    5832:	48 49       	mov.b	r9,	r8	;
    5834:	78 f0 03 00 	and.b	#3,	r8	;
    5838:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    583c:	88 11       	sxt	r8		;
    583e:	1d 42 82 1c 	mov	&0x1c82,r13	;0x1c82
    5842:	0c 49       	mov	r9,	r12	;
    5844:	5c f3       	and.b	#1,	r12	;r3 As==01
    5846:	59 03       	rrum	#1,	r9	;
    5848:	0d 93       	cmp	#0,	r13	;r3 As==00
    584a:	02 24       	jz	$+6      	;abs 0x5850
    584c:	80 00 ae 51 	mova	#20910,	r0	;0x051ae

00005850 <.L268>:
    5850:	0c 93       	cmp	#0,	r12	;r3 As==00
    5852:	02 24       	jz	$+6      	;abs 0x5858
    5854:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400

00005858 <.L281>:
    5858:	46 49       	mov.b	r9,	r6	;
    585a:	76 f0 03 00 	and.b	#3,	r6	;
    585e:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5862:	86 11       	sxt	r6		;
    5864:	0d 49       	mov	r9,	r13	;
    5866:	5d 03       	rrum	#1,	r13	;
    5868:	19 b3       	bit	#1,	r9	;r3 As==01
    586a:	02 24       	jz	$+6      	;abs 0x5870
    586c:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400

00005870 <.L280>:
    5870:	49 4d       	mov.b	r13,	r9	;
    5872:	79 f0 03 00 	and.b	#3,	r9	;
    5876:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    587a:	89 11       	sxt	r9		;
    587c:	0b 4d       	mov	r13,	r11	;
    587e:	5b 03       	rrum	#1,	r11	;
    5880:	81 4b 0e 00 	mov	r11,	14(r1)	; 0x000e
    5884:	1d b3       	bit	#1,	r13	;r3 As==01
    5886:	03 24       	jz	$+8      	;abs 0x588e
    5888:	b1 e0 00 b4 	xor	#-19456,14(r1)	;#0xb400, 0x000e
    588c:	0e 00 

0000588e <.L279>:
    588e:	1c 41 0e 00 	mov	14(r1),	r12	;0x0000e
    5892:	7c f0 03 00 	and.b	#3,	r12	;
    5896:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    589a:	8c 11       	sxt	r12		;
    589c:	0e 45       	mov	r5,	r14	;
    589e:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    58a2:	4d 4e       	mov.b	r14,	r13	;
    58a4:	4d e5       	xor.b	r5,	r13	;
    58a6:	4d 8e       	sub.b	r14,	r13	;
    58a8:	7e 40 09 00 	mov.b	#9,	r14	;
    58ac:	4e 9d       	cmp.b	r13,	r14	;
    58ae:	02 2c       	jc	$+6      	;abs 0x58b4
    58b0:	80 00 2a 52 	mova	#21034,	r0	;0x0522a

000058b4 <.L354>:
    58b4:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    58b8:	81 43 06 00 	mov	#0,	6(r1)	;r3 As==00
    58bc:	81 43 16 00 	mov	#0,	22(r1)	;r3 As==00, 0x0016
    58c0:	0e 4a       	mov	r10,	r14	;
    58c2:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    58c6:	4d 4e       	mov.b	r14,	r13	;
    58c8:	4d ea       	xor.b	r10,	r13	;
    58ca:	4d 8e       	sub.b	r14,	r13	;
    58cc:	7f 40 09 00 	mov.b	#9,	r15	;
    58d0:	4f 9d       	cmp.b	r13,	r15	;
    58d2:	02 2c       	jc	$+6      	;abs 0x58d8
    58d4:	80 00 56 52 	mova	#21078,	r0	;0x05256

000058d8 <.L355>:
    58d8:	81 43 08 00 	mov	#0,	8(r1)	;r3 As==00
    58dc:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    58e0:	81 43 18 00 	mov	#0,	24(r1)	;r3 As==00, 0x0018
    58e4:	0e 44       	mov	r4,	r14	;
    58e6:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    58ea:	4d 44       	mov.b	r4,	r13	;
    58ec:	4d ee       	xor.b	r14,	r13	;
    58ee:	4d 8e       	sub.b	r14,	r13	;
    58f0:	7e 40 09 00 	mov.b	#9,	r14	;
    58f4:	4e 9d       	cmp.b	r13,	r14	;
    58f6:	02 2c       	jc	$+6      	;abs 0x58fc
    58f8:	80 00 82 52 	mova	#21122,	r0	;0x05282

000058fc <.L356>:
    58fc:	4a 43       	clr.b	r10		;
    58fe:	4b 43       	clr.b	r11		;
    5900:	44 43       	clr.b	r4		;
    5902:	30 40 8a 52 	br	#0x528a		;

00005906 <.L379>:
    5906:	04 45       	mov	r5,	r4	;
    5908:	24 c3       	bic	#2,	r4	;r3 As==10
    590a:	30 40 f0 48 	br	#0x48f0		;

0000590e <.L378>:
    590e:	05 44       	mov	r4,	r5	;
    5910:	25 c2       	bic	#4,	r5	;r2 As==10
    5912:	30 40 cc 48 	br	#0x48cc		;

00005916 <.L377>:
    5916:	04 45       	mov	r5,	r4	;
    5918:	34 c2       	bic	#8,	r4	;r2 As==11
    591a:	30 40 a8 48 	br	#0x48a8		;

0000591e <.L375>:
    591e:	04 45       	mov	r5,	r4	;
    5920:	14 c3       	bic	#1,	r4	;r3 As==01
    5922:	81 44 1e 00 	mov	r4,	30(r1)	; 0x001e
    5926:	08 47       	mov	r7,	r8	;
    5928:	09 43       	clr	r9		;
    592a:	3c 40 ff 0f 	mov	#4095,	r12	;#0x0fff
    592e:	0c 97       	cmp	r7,	r12	;
    5930:	02 28       	jnc	$+6      	;abs 0x5936
    5932:	80 00 52 48 	mova	#18514,	r0	;0x04852

00005936 <.L430>:
    5936:	36 40 ff 23 	mov	#9215,	r6	;#0x23ff
    593a:	06 97       	cmp	r7,	r6	;
    593c:	2d 2d       	jc	$+604    	;abs 0x5b98
    593e:	75 40 70 00 	mov.b	#112,	r5	;#0x0070
    5942:	46 43       	clr.b	r6		;

00005944 <.L331>:
    5944:	35 e0 10 00 	xor	#16,	r5	;#0x0010
    5948:	30 40 84 48 	br	#0x4884		;

0000594c <.L374>:
    594c:	05 44       	mov	r4,	r5	;
    594e:	25 c3       	bic	#2,	r5	;r3 As==10
    5950:	30 40 1a 48 	br	#0x481a		;

00005954 <.L373>:
    5954:	04 45       	mov	r5,	r4	;
    5956:	24 c2       	bic	#4,	r4	;r2 As==10
    5958:	30 40 f6 47 	br	#0x47f6		;

0000595c <.L372>:
    595c:	05 44       	mov	r4,	r5	;
    595e:	35 c2       	bic	#8,	r5	;r2 As==11
    5960:	30 40 d2 47 	br	#0x47d2		;

00005964 <.L392>:
    5964:	04 45       	mov	r5,	r4	;
    5966:	24 c3       	bic	#2,	r4	;r3 As==10
    5968:	30 40 52 50 	br	#0x5052		;

0000596c <.L391>:
    596c:	05 44       	mov	r4,	r5	;
    596e:	25 c2       	bic	#4,	r5	;r2 As==10
    5970:	30 40 2e 50 	br	#0x502e		;

00005974 <.L390>:
    5974:	04 45       	mov	r5,	r4	;
    5976:	34 c2       	bic	#8,	r4	;r2 As==11
    5978:	30 40 0a 50 	br	#0x500a		;

0000597c <.L388>:
    597c:	04 45       	mov	r5,	r4	;
    597e:	14 c3       	bic	#1,	r4	;r3 As==01
    5980:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    5984:	08 47       	mov	r7,	r8	;
    5986:	09 43       	clr	r9		;
    5988:	3c 40 ff 0f 	mov	#4095,	r12	;#0x0fff
    598c:	0c 97       	cmp	r7,	r12	;
    598e:	02 28       	jnc	$+6      	;abs 0x5994
    5990:	80 00 b4 4f 	mova	#20404,	r0	;0x04fb4

00005994 <.L431>:
    5994:	35 40 ff 23 	mov	#9215,	r5	;#0x23ff
    5998:	05 97       	cmp	r7,	r5	;
    599a:	61 2c       	jc	$+196    	;abs 0x5a5e
    599c:	75 40 70 00 	mov.b	#112,	r5	;#0x0070
    59a0:	46 43       	clr.b	r6		;

000059a2 <.L328>:
    59a2:	35 e0 10 00 	xor	#16,	r5	;#0x0010
    59a6:	30 40 e6 4f 	br	#0x4fe6		;

000059aa <.L387>:
    59aa:	05 44       	mov	r4,	r5	;
    59ac:	25 c3       	bic	#2,	r5	;r3 As==10
    59ae:	30 40 7c 4f 	br	#0x4f7c		;

000059b2 <.L386>:
    59b2:	04 45       	mov	r5,	r4	;
    59b4:	24 c2       	bic	#4,	r4	;r2 As==10
    59b6:	30 40 58 4f 	br	#0x4f58		;

000059ba <.L385>:
    59ba:	05 44       	mov	r4,	r5	;
    59bc:	35 c2       	bic	#8,	r5	;r2 As==11
    59be:	30 40 34 4f 	br	#0x4f34		;

000059c2 <.L404>:
    59c2:	06 45       	mov	r5,	r6	;
    59c4:	26 c2       	bic	#4,	r6	;r2 As==10
    59c6:	49 3e       	jmp	$-876    	;abs 0x565a

000059c8 <.L403>:
    59c8:	05 46       	mov	r6,	r5	;
    59ca:	35 c2       	bic	#8,	r5	;r2 As==11
    59cc:	38 3e       	jmp	$-910    	;abs 0x563e

000059ce <.L432>:
    59ce:	3f 40 ff 23 	mov	#9215,	r15	;#0x23ff
    59d2:	0f 9a       	cmp	r10,	r15	;
    59d4:	06 2c       	jc	$+14     	;abs 0x59e2
    59d6:	76 40 70 00 	mov.b	#112,	r6	;#0x0070
    59da:	47 43       	clr.b	r7		;

000059dc <.L325>:
    59dc:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    59e0:	20 3e       	jmp	$-958    	;abs 0x5622

000059e2 <.L478>:
    59e2:	76 40 60 00 	mov.b	#96,	r6	;#0x0060

000059e6 <.L323>:
    59e6:	36 e0 20 00 	xor	#32,	r6	;#0x0020
    59ea:	47 43       	clr.b	r7		;
    59ec:	0e 3e       	jmp	$-994    	;abs 0x560a

000059ee <.L362>:
    59ee:	4c 43       	clr.b	r12		;
    59f0:	4d 43       	clr.b	r13		;
    59f2:	81 43 1e 00 	mov	#0,	30(r1)	;r3 As==00, 0x001e
    59f6:	30 40 92 53 	br	#0x5392		;

000059fa <.L361>:
    59fa:	4e 43       	clr.b	r14		;
    59fc:	4f 43       	clr.b	r15		;
    59fe:	81 43 1c 00 	mov	#0,	28(r1)	;r3 As==00, 0x001c
    5a02:	30 40 6e 53 	br	#0x536e		;

00005a06 <.L360>:
    5a06:	46 43       	clr.b	r6		;
    5a08:	47 43       	clr.b	r7		;
    5a0a:	81 43 1a 00 	mov	#0,	26(r1)	;r3 As==00, 0x001a
    5a0e:	30 40 4a 53 	br	#0x534a		;

00005a12 <.L515>:
    5a12:	0a 9c       	cmp	r12,	r10	;
    5a14:	06 2e       	jc	$-1010   	;abs 0x5622
    5a16:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    5a1a:	30 40 22 56 	br	#0x5622		;

00005a1e <.L516>:
    5a1e:	92 41 0e 00 	mov	14(r1),	&0x1c00	;0x0000e
    5a22:	00 1c 
    5a24:	b1 53 22 00 	add	#-1,	34(r1)	;r3 As==11, 0x0022
    5a28:	81 93 22 00 	cmp	#0,	34(r1)	;r3 As==00, 0x0022
    5a2c:	02 24       	jz	$+6      	;abs 0x5a32
    5a2e:	80 00 c0 50 	mova	#20672,	r0	;0x050c0
    5a32:	b0 12 f0 40 	call	#16624		;#0x40f0
    5a36:	b0 12 28 41 	call	#16680		;#0x4128
    5a3a:	4c 43       	clr.b	r12		;
    5a3c:	31 50 26 00 	add	#38,	r1	;#0x0026
    5a40:	64 17       	popm	#7,	r10	;16-bit words
    5a42:	30 41       	ret			

00005a44 <.L350>:
    5a44:	4e 43       	clr.b	r14		;
    5a46:	4f 43       	clr.b	r15		;
    5a48:	81 43 14 00 	mov	#0,	20(r1)	;r3 As==00, 0x0014
    5a4c:	30 40 aa 4c 	br	#0x4caa		;

00005a50 <.L349>:
    5a50:	81 43 08 00 	mov	#0,	8(r1)	;r3 As==00
    5a54:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5a58:	44 43       	clr.b	r4		;
    5a5a:	30 40 86 4c 	br	#0x4c86		;

00005a5e <.L479>:
    5a5e:	75 40 60 00 	mov.b	#96,	r5	;#0x0060

00005a62 <.L326>:
    5a62:	35 e0 20 00 	xor	#32,	r5	;#0x0020
    5a66:	46 43       	clr.b	r6		;
    5a68:	30 40 c6 4f 	br	#0x4fc6		;

00005a6c <.L348>:
    5a6c:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5a70:	81 43 06 00 	mov	#0,	6(r1)	;r3 As==00
    5a74:	81 43 0e 00 	mov	#0,	14(r1)	;r3 As==00, 0x000e
    5a78:	30 40 5e 4c 	br	#0x4c5e		;

00005a7c <.L344>:
    5a7c:	46 43       	clr.b	r6		;
    5a7e:	47 43       	clr.b	r7		;
    5a80:	81 43 16 00 	mov	#0,	22(r1)	;r3 As==00, 0x0016
    5a84:	30 40 88 4b 	br	#0x4b88		;

00005a88 <.L343>:
    5a88:	4c 43       	clr.b	r12		;
    5a8a:	4d 43       	clr.b	r13		;
    5a8c:	81 43 12 00 	mov	#0,	18(r1)	;r3 As==00, 0x0012
    5a90:	30 40 66 4b 	br	#0x4b66		;

00005a94 <.L353>:
    5a94:	48 43       	clr.b	r8		;
    5a96:	49 43       	clr.b	r9		;
    5a98:	81 43 1e 00 	mov	#0,	30(r1)	;r3 As==00, 0x001e
    5a9c:	30 40 42 4b 	br	#0x4b42		;

00005aa0 <.L221>:
    5aa0:	0c 93       	cmp	#0,	r12	;r3 As==00
    5aa2:	02 24       	jz	$+6      	;abs 0x5aa8
    5aa4:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005aa8 <.L236>:
    5aa8:	4b 4a       	mov.b	r10,	r11	;
    5aaa:	7b f0 03 00 	and.b	#3,	r11	;
    5aae:	7b 50 fe ff 	add.b	#-2,	r11	;#0xfffe
    5ab2:	8b 11       	sxt	r11		;
    5ab4:	81 4b 0e 00 	mov	r11,	14(r1)	; 0x000e
    5ab8:	0c 4a       	mov	r10,	r12	;
    5aba:	5c 03       	rrum	#1,	r12	;
    5abc:	1a b3       	bit	#1,	r10	;r3 As==01
    5abe:	02 24       	jz	$+6      	;abs 0x5ac4
    5ac0:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00005ac4 <.L235>:
    5ac4:	44 4c       	mov.b	r12,	r4	;
    5ac6:	74 f0 03 00 	and.b	#3,	r4	;
    5aca:	74 50 fe ff 	add.b	#-2,	r4	;#0xfffe
    5ace:	84 11       	sxt	r4		;
    5ad0:	0a 4c       	mov	r12,	r10	;
    5ad2:	5a 03       	rrum	#1,	r10	;
    5ad4:	1c b3       	bit	#1,	r12	;r3 As==01
    5ad6:	02 24       	jz	$+6      	;abs 0x5adc
    5ad8:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005adc <.L490>:
    5adc:	82 4a 00 1c 	mov	r10,	&0x1c00	;
    5ae0:	45 4a       	mov.b	r10,	r5	;
    5ae2:	75 f0 03 00 	and.b	#3,	r5	;
    5ae6:	75 50 fe ff 	add.b	#-2,	r5	;#0xfffe
    5aea:	85 11       	sxt	r5		;
    5aec:	30 40 20 4b 	br	#0x4b20		;

00005af0 <.L207>:
    5af0:	0c 93       	cmp	#0,	r12	;r3 As==00
    5af2:	02 24       	jz	$+6      	;abs 0x5af8
    5af4:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005af8 <.L220>:
    5af8:	4c 4a       	mov.b	r10,	r12	;
    5afa:	7c f0 03 00 	and.b	#3,	r12	;
    5afe:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5b02:	8c 11       	sxt	r12		;
    5b04:	81 4c 04 00 	mov	r12,	4(r1)	;
    5b08:	0c 4a       	mov	r10,	r12	;
    5b0a:	5c 03       	rrum	#1,	r12	;
    5b0c:	1a b3       	bit	#1,	r10	;r3 As==01
    5b0e:	02 24       	jz	$+6      	;abs 0x5b14
    5b10:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00005b14 <.L219>:
    5b14:	4d 4c       	mov.b	r12,	r13	;
    5b16:	7d f0 03 00 	and.b	#3,	r13	;
    5b1a:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5b1e:	8d 11       	sxt	r13		;
    5b20:	81 4d 08 00 	mov	r13,	8(r1)	;
    5b24:	0a 4c       	mov	r12,	r10	;
    5b26:	5a 03       	rrum	#1,	r10	;
    5b28:	1c b3       	bit	#1,	r12	;r3 As==01
    5b2a:	02 24       	jz	$+6      	;abs 0x5b30
    5b2c:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005b30 <.L218>:
    5b30:	4c 4a       	mov.b	r10,	r12	;
    5b32:	7c f0 03 00 	and.b	#3,	r12	;
    5b36:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5b3a:	8c 11       	sxt	r12		;
    5b3c:	81 4c 14 00 	mov	r12,	20(r1)	; 0x0014
    5b40:	30 40 b0 4a 	br	#0x4ab0		;

00005b44 <.L193>:
    5b44:	0c 93       	cmp	#0,	r12	;r3 As==00
    5b46:	02 24       	jz	$+6      	;abs 0x5b4c
    5b48:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005b4c <.L206>:
    5b4c:	49 4a       	mov.b	r10,	r9	;
    5b4e:	79 f0 03 00 	and.b	#3,	r9	;
    5b52:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5b56:	89 11       	sxt	r9		;
    5b58:	0c 4a       	mov	r10,	r12	;
    5b5a:	5c 03       	rrum	#1,	r12	;
    5b5c:	1a b3       	bit	#1,	r10	;r3 As==01
    5b5e:	02 24       	jz	$+6      	;abs 0x5b64
    5b60:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00005b64 <.L205>:
    5b64:	46 4c       	mov.b	r12,	r6	;
    5b66:	76 f0 03 00 	and.b	#3,	r6	;
    5b6a:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5b6e:	86 11       	sxt	r6		;
    5b70:	0a 4c       	mov	r12,	r10	;
    5b72:	5a 03       	rrum	#1,	r10	;
    5b74:	1c b3       	bit	#1,	r12	;r3 As==01
    5b76:	02 24       	jz	$+6      	;abs 0x5b7c
    5b78:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005b7c <.L204>:
    5b7c:	47 4a       	mov.b	r10,	r7	;
    5b7e:	77 f0 03 00 	and.b	#3,	r7	;
    5b82:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5b86:	87 11       	sxt	r7		;
    5b88:	30 40 42 4a 	br	#0x4a42		;

00005b8c <.L339>:
    5b8c:	4e 43       	clr.b	r14		;
    5b8e:	4f 43       	clr.b	r15		;
    5b90:	81 43 14 00 	mov	#0,	20(r1)	;r3 As==00, 0x0014
    5b94:	30 40 4a 45 	br	#0x454a		;

00005b98 <.L480>:
    5b98:	75 40 60 00 	mov.b	#96,	r5	;#0x0060

00005b9c <.L329>:
    5b9c:	35 e0 20 00 	xor	#32,	r5	;#0x0020
    5ba0:	46 43       	clr.b	r6		;
    5ba2:	30 40 64 48 	br	#0x4864		;

00005ba6 <.L338>:
    5ba6:	81 43 08 00 	mov	#0,	8(r1)	;r3 As==00
    5baa:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5bae:	44 43       	clr.b	r4		;
    5bb0:	30 40 26 45 	br	#0x4526		;

00005bb4 <.L337>:
    5bb4:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5bb8:	81 43 06 00 	mov	#0,	6(r1)	;r3 As==00
    5bbc:	81 43 0e 00 	mov	#0,	14(r1)	;r3 As==00, 0x000e
    5bc0:	30 40 fe 44 	br	#0x44fe		;

00005bc4 <.L333>:
    5bc4:	46 43       	clr.b	r6		;
    5bc6:	47 43       	clr.b	r7		;
    5bc8:	81 43 16 00 	mov	#0,	22(r1)	;r3 As==00, 0x0016
    5bcc:	30 40 28 44 	br	#0x4428		;

00005bd0 <.L332>:
    5bd0:	4c 43       	clr.b	r12		;
    5bd2:	4d 43       	clr.b	r13		;
    5bd4:	81 43 12 00 	mov	#0,	18(r1)	;r3 As==00, 0x0012
    5bd8:	30 40 06 44 	br	#0x4406		;

00005bdc <.L342>:
    5bdc:	48 43       	clr.b	r8		;
    5bde:	49 43       	clr.b	r9		;
    5be0:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    5be4:	30 40 e2 43 	br	#0x43e2		;

00005be8 <.L111>:
    5be8:	0c 93       	cmp	#0,	r12	;r3 As==00
    5bea:	02 24       	jz	$+6      	;abs 0x5bf0
    5bec:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005bf0 <.L126>:
    5bf0:	4b 4a       	mov.b	r10,	r11	;
    5bf2:	7b f0 03 00 	and.b	#3,	r11	;
    5bf6:	7b 50 fe ff 	add.b	#-2,	r11	;#0xfffe
    5bfa:	8b 11       	sxt	r11		;
    5bfc:	81 4b 0e 00 	mov	r11,	14(r1)	; 0x000e
    5c00:	0c 4a       	mov	r10,	r12	;
    5c02:	5c 03       	rrum	#1,	r12	;
    5c04:	1a b3       	bit	#1,	r10	;r3 As==01
    5c06:	02 24       	jz	$+6      	;abs 0x5c0c
    5c08:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00005c0c <.L125>:
    5c0c:	44 4c       	mov.b	r12,	r4	;
    5c0e:	74 f0 03 00 	and.b	#3,	r4	;
    5c12:	74 50 fe ff 	add.b	#-2,	r4	;#0xfffe
    5c16:	84 11       	sxt	r4		;
    5c18:	0a 4c       	mov	r12,	r10	;
    5c1a:	5a 03       	rrum	#1,	r10	;
    5c1c:	1c b3       	bit	#1,	r12	;r3 As==01
    5c1e:	02 24       	jz	$+6      	;abs 0x5c24
    5c20:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005c24 <.L485>:
    5c24:	82 4a 00 1c 	mov	r10,	&0x1c00	;
    5c28:	45 4a       	mov.b	r10,	r5	;
    5c2a:	75 f0 03 00 	and.b	#3,	r5	;
    5c2e:	75 50 fe ff 	add.b	#-2,	r5	;#0xfffe
    5c32:	85 11       	sxt	r5		;
    5c34:	30 40 c0 43 	br	#0x43c0		;

00005c38 <.L97>:
    5c38:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c3a:	02 24       	jz	$+6      	;abs 0x5c40
    5c3c:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005c40 <.L110>:
    5c40:	4c 4a       	mov.b	r10,	r12	;
    5c42:	7c f0 03 00 	and.b	#3,	r12	;
    5c46:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c4a:	8c 11       	sxt	r12		;
    5c4c:	81 4c 04 00 	mov	r12,	4(r1)	;
    5c50:	0c 4a       	mov	r10,	r12	;
    5c52:	5c 03       	rrum	#1,	r12	;
    5c54:	1a b3       	bit	#1,	r10	;r3 As==01
    5c56:	02 24       	jz	$+6      	;abs 0x5c5c
    5c58:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00005c5c <.L109>:
    5c5c:	4d 4c       	mov.b	r12,	r13	;
    5c5e:	7d f0 03 00 	and.b	#3,	r13	;
    5c62:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5c66:	8d 11       	sxt	r13		;
    5c68:	81 4d 08 00 	mov	r13,	8(r1)	;
    5c6c:	0a 4c       	mov	r12,	r10	;
    5c6e:	5a 03       	rrum	#1,	r10	;
    5c70:	1c b3       	bit	#1,	r12	;r3 As==01
    5c72:	02 24       	jz	$+6      	;abs 0x5c78
    5c74:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005c78 <.L108>:
    5c78:	4c 4a       	mov.b	r10,	r12	;
    5c7a:	7c f0 03 00 	and.b	#3,	r12	;
    5c7e:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c82:	8c 11       	sxt	r12		;
    5c84:	81 4c 14 00 	mov	r12,	20(r1)	; 0x0014
    5c88:	30 40 50 43 	br	#0x4350		;

00005c8c <.L83>:
    5c8c:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c8e:	02 24       	jz	$+6      	;abs 0x5c94
    5c90:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005c94 <.L96>:
    5c94:	49 4a       	mov.b	r10,	r9	;
    5c96:	79 f0 03 00 	and.b	#3,	r9	;
    5c9a:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5c9e:	89 11       	sxt	r9		;
    5ca0:	0c 4a       	mov	r10,	r12	;
    5ca2:	5c 03       	rrum	#1,	r12	;
    5ca4:	1a b3       	bit	#1,	r10	;r3 As==01
    5ca6:	02 24       	jz	$+6      	;abs 0x5cac
    5ca8:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00005cac <.L95>:
    5cac:	46 4c       	mov.b	r12,	r6	;
    5cae:	76 f0 03 00 	and.b	#3,	r6	;
    5cb2:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5cb6:	86 11       	sxt	r6		;
    5cb8:	0a 4c       	mov	r12,	r10	;
    5cba:	5a 03       	rrum	#1,	r10	;
    5cbc:	1c b3       	bit	#1,	r12	;r3 As==01
    5cbe:	02 24       	jz	$+6      	;abs 0x5cc4
    5cc0:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400

00005cc4 <.L94>:
    5cc4:	47 4a       	mov.b	r10,	r7	;
    5cc6:	77 f0 03 00 	and.b	#3,	r7	;
    5cca:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5cce:	87 11       	sxt	r7		;
    5cd0:	30 40 e2 42 	br	#0x42e2		;

00005cd4 <.L514>:
    5cd4:	07 9c       	cmp	r12,	r7	;
    5cd6:	02 28       	jnc	$+6      	;abs 0x5cdc
    5cd8:	80 00 e6 4f 	mova	#20454,	r0	;0x04fe6
    5cdc:	35 e0 10 00 	xor	#16,	r5	;#0x0010
    5ce0:	30 40 e6 4f 	br	#0x4fe6		;

00005ce4 <.L513>:
    5ce4:	07 9c       	cmp	r12,	r7	;
    5ce6:	02 28       	jnc	$+6      	;abs 0x5cec
    5ce8:	80 00 84 48 	mova	#18564,	r0	;0x04884
    5cec:	35 e0 10 00 	xor	#16,	r5	;#0x0010
    5cf0:	30 40 84 48 	br	#0x4884		;

00005cf4 <udivmodhi4>:
    5cf4:	0f 4c       	mov	r12,	r15	;

00005cf6 <.LVL1>:
    5cf6:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011

00005cfa <.LVL2>:
    5cfa:	5b 43       	mov.b	#1,	r11	;r3 As==01

00005cfc <.L2>:
    5cfc:	0d 9f       	cmp	r15,	r13	;
    5cfe:	05 2c       	jc	$+12     	;abs 0x5d0a
    5d00:	3c 53       	add	#-1,	r12	;r3 As==11

00005d02 <.Loc.38.1>:
    5d02:	0c 93       	cmp	#0,	r12	;r3 As==00
    5d04:	05 24       	jz	$+12     	;abs 0x5d10

00005d06 <.Loc.38.1>:
    5d06:	0d 93       	cmp	#0,	r13	;r3 As==00
    5d08:	07 34       	jge	$+16     	;abs 0x5d18

00005d0a <.L10>:
    5d0a:	4c 43       	clr.b	r12		;

00005d0c <.L6>:
    5d0c:	0b 93       	cmp	#0,	r11	;r3 As==00
    5d0e:	07 20       	jnz	$+16     	;abs 0x5d1e

00005d10 <.L4>:
    5d10:	0e 93       	cmp	#0,	r14	;r3 As==00
    5d12:	01 24       	jz	$+4      	;abs 0x5d16
    5d14:	0c 4f       	mov	r15,	r12	;

00005d16 <.L1>:
    5d16:	30 41       	ret			

00005d18 <.L5>:
    5d18:	5d 02       	rlam	#1,	r13	;

00005d1a <.Loc.41.1>:
    5d1a:	5b 02       	rlam	#1,	r11	;
    5d1c:	ef 3f       	jmp	$-32     	;abs 0x5cfc

00005d1e <.L8>:
    5d1e:	0f 9d       	cmp	r13,	r15	;
    5d20:	02 28       	jnc	$+6      	;abs 0x5d26

00005d22 <.Loc.47.1>:
    5d22:	0f 8d       	sub	r13,	r15	;

00005d24 <.Loc.48.1>:
    5d24:	0c db       	bis	r11,	r12	;

00005d26 <.L7>:
    5d26:	5b 03       	rrum	#1,	r11	;

00005d28 <.Loc.51.1>:
    5d28:	5d 03       	rrum	#1,	r13	;
    5d2a:	f0 3f       	jmp	$-30     	;abs 0x5d0c

00005d2c <__mspabi_remu>:
    5d2c:	5e 43       	mov.b	#1,	r14	;r3 As==01
    5d2e:	
00005d30 <L0^A>:
    5d30:	
00005d32 <.LVL34>:
    5d32:	30 41       	ret			

00005d34 <udivmodsi4>:
    5d34:	4a 15       	pushm	#5,	r10	;16-bit words

00005d36 <.LCFI0>:
    5d36:	0a 4c       	mov	r12,	r10	;
    5d38:	0b 4d       	mov	r13,	r11	;

00005d3a <.LVL1>:
    5d3a:	7c 40 21 00 	mov.b	#33,	r12	;#0x0021

00005d3e <.LVL2>:
    5d3e:	58 43       	mov.b	#1,	r8	;r3 As==01
    5d40:	49 43       	clr.b	r9		;

00005d42 <.L2>:
    5d42:	0f 9b       	cmp	r11,	r15	;
    5d44:	04 28       	jnc	$+10     	;abs 0x5d4e
    5d46:	0b 9f       	cmp	r15,	r11	;
    5d48:	07 20       	jnz	$+16     	;abs 0x5d58
    5d4a:	0e 9a       	cmp	r10,	r14	;
    5d4c:	05 2c       	jc	$+12     	;abs 0x5d58

00005d4e <.L15>:
    5d4e:	3c 53       	add	#-1,	r12	;r3 As==11

00005d50 <.Loc.38.1>:
    5d50:	0c 93       	cmp	#0,	r12	;r3 As==00
    5d52:	2d 24       	jz	$+92     	;abs 0x5dae

00005d54 <.Loc.38.1>:
    5d54:	0f 93       	cmp	#0,	r15	;r3 As==00
    5d56:	0d 34       	jge	$+28     	;abs 0x5d72

00005d58 <.L13>:
    5d58:	4c 43       	clr.b	r12		;
    5d5a:	4d 43       	clr.b	r13		;

00005d5c <.L8>:
    5d5c:	07 48       	mov	r8,	r7	;
    5d5e:	07 d9       	bis	r9,	r7	;
    5d60:	07 93       	cmp	#0,	r7	;r3 As==00
    5d62:	14 20       	jnz	$+42     	;abs 0x5d8c

00005d64 <.L5>:
    5d64:	81 93 0c 00 	cmp	#0,	12(r1)	;r3 As==00, 0x000c
    5d68:	02 24       	jz	$+6      	;abs 0x5d6e
    5d6a:	0c 4a       	mov	r10,	r12	;
    5d6c:	0d 4b       	mov	r11,	r13	;

00005d6e <.L1>:
    5d6e:	46 17       	popm	#5,	r10	;16-bit words

00005d70 <.LCFI1>:
    5d70:	30 41       	ret			

00005d72 <.L6>:
    5d72:	06 4e       	mov	r14,	r6	;
    5d74:	07 4f       	mov	r15,	r7	;
    5d76:	06 5e       	add	r14,	r6	;
    5d78:	07 6f       	addc	r15,	r7	;
    5d7a:	0e 46       	mov	r6,	r14	;

00005d7c <.LVL7>:
    5d7c:	0f 47       	mov	r7,	r15	;

00005d7e <.LVL8>:
    5d7e:	06 48       	mov	r8,	r6	;
    5d80:	07 49       	mov	r9,	r7	;
    5d82:	06 58       	add	r8,	r6	;
    5d84:	07 69       	addc	r9,	r7	;
    5d86:	08 46       	mov	r6,	r8	;

00005d88 <.LVL9>:
    5d88:	09 47       	mov	r7,	r9	;

00005d8a <.LVL10>:
    5d8a:	db 3f       	jmp	$-72     	;abs 0x5d42

00005d8c <.L11>:
    5d8c:	0b 9f       	cmp	r15,	r11	;
    5d8e:	08 28       	jnc	$+18     	;abs 0x5da0
    5d90:	0f 9b       	cmp	r11,	r15	;
    5d92:	02 20       	jnz	$+6      	;abs 0x5d98
    5d94:	0a 9e       	cmp	r14,	r10	;
    5d96:	04 28       	jnc	$+10     	;abs 0x5da0

00005d98 <.L16>:
    5d98:	0a 8e       	sub	r14,	r10	;
    5d9a:	0b 7f       	subc	r15,	r11	;

00005d9c <.Loc.48.1>:
    5d9c:	0c d8       	bis	r8,	r12	;

00005d9e <.LVL13>:
    5d9e:	0d d9       	bis	r9,	r13	;

00005da0 <.L9>:
    5da0:	12 c3       	clrc			
    5da2:	09 10       	rrc	r9		;
    5da4:	08 10       	rrc	r8		;

00005da6 <.Loc.51.1>:
    5da6:	12 c3       	clrc			
    5da8:	0f 10       	rrc	r15		;
    5daa:	0e 10       	rrc	r14		;
    5dac:	d7 3f       	jmp	$-80     	;abs 0x5d5c

00005dae <.L14>:
    5dae:	4c 43       	clr.b	r12		;
    5db0:	4d 43       	clr.b	r13		;
    5db2:	d8 3f       	jmp	$-78     	;abs 0x5d64

00005db4 <__mspabi_divli>:
    5db4:	2a 15       	pushm	#3,	r10	;16-bit words

00005db6 <.LCFI3>:
    5db6:	21 83       	decd	r1		;

00005db8 <.LCFI4>:
    5db8:	4a 43       	clr.b	r10		;

00005dba <L0^A>:
    5dba:	0d 93       	cmp	#0,	r13	;r3 As==00
    5dbc:	07 34       	jge	$+16     	;abs 0x5dcc

00005dbe <.Loc.66.1>:
    5dbe:	48 43       	clr.b	r8		;
    5dc0:	49 43       	clr.b	r9		;
    5dc2:	08 8c       	sub	r12,	r8	;
    5dc4:	09 7d       	subc	r13,	r9	;
    5dc6:	0c 48       	mov	r8,	r12	;

00005dc8 <.LVL20>:
    5dc8:	0d 49       	mov	r9,	r13	;

00005dca <.LVL21>:
    5dca:	5a 43       	mov.b	#1,	r10	;r3 As==01

00005dcc <.L21>:
    5dcc:	0f 93       	cmp	#0,	r15	;r3 As==00
    5dce:	07 34       	jge	$+16     	;abs 0x5dde

00005dd0 <.Loc.72.1>:
    5dd0:	48 43       	clr.b	r8		;
    5dd2:	49 43       	clr.b	r9		;
    5dd4:	08 8e       	sub	r14,	r8	;
    5dd6:	09 7f       	subc	r15,	r9	;
    5dd8:	0e 48       	mov	r8,	r14	;

00005dda <.LVL23>:
    5dda:	0f 49       	mov	r9,	r15	;

00005ddc <.LVL24>:
    5ddc:	1a e3       	xor	#1,	r10	;r3 As==01

00005dde <.L23>:
    5dde:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    5de2:	b0 12 34 5d 	call	#23860		;#0x5d34

00005de6 <.LVL26>:
    5de6:	0a 93       	cmp	#0,	r10	;r3 As==00
    5de8:	06 24       	jz	$+14     	;abs 0x5df6

00005dea <.LVL27>:
    5dea:	49 43       	clr.b	r9		;
    5dec:	4a 43       	clr.b	r10		;
    5dee:	09 8c       	sub	r12,	r9	;
    5df0:	0a 7d       	subc	r13,	r10	;
    5df2:	0c 49       	mov	r9,	r12	;

00005df4 <.LVL28>:
    5df4:	0d 4a       	mov	r10,	r13	;

00005df6 <.L20>:
    5df6:	21 53       	incd	r1		;

00005df8 <.LCFI5>:
    5df8:	28 17       	popm	#3,	r10	;16-bit words

00005dfa <.LCFI6>:
    5dfa:	30 41       	ret			

00005dfc <__mulhi2>:
    5dfc:	02 12       	push	r2		;
    5dfe:	32 c2       	dint			
    5e00:	03 43       	nop			
    5e02:	82 4c c0 04 	mov	r12,	&0x04c0	;
    5e06:	82 4d c8 04 	mov	r13,	&0x04c8	;
    5e0a:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    5e0e:	00 13       	reti			

00005e10 <__mulsi2>:
    5e10:	02 12       	push	r2		;
    5e12:	32 c2       	dint			
    5e14:	03 43       	nop			
    5e16:	82 4c d0 04 	mov	r12,	&0x04d0	;
    5e1a:	82 4d d2 04 	mov	r13,	&0x04d2	;
    5e1e:	82 4e e0 04 	mov	r14,	&0x04e0	;
    5e22:	82 4f e2 04 	mov	r15,	&0x04e2	;
    5e26:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    5e2a:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    5e2e:	00 13       	reti			

00005e30 <_exit>:
    5e30:	ff 3f       	jmp	$+0      	;abs 0x5e30

00005e32 <memmove>:
    5e32:	1a 15       	pushm	#2,	r10	;16-bit words

00005e34 <L0^A>:
    5e34:	0f 4d       	mov	r13,	r15	;
    5e36:	0f 5e       	add	r14,	r15	;

00005e38 <.Loc.69.1>:
    5e38:	0d 9c       	cmp	r12,	r13	;
    5e3a:	02 2c       	jc	$+6      	;abs 0x5e40

00005e3c <.Loc.69.1>:
    5e3c:	0c 9f       	cmp	r15,	r12	;
    5e3e:	07 28       	jnc	$+16     	;abs 0x5e4e

00005e40 <.L2>:
    5e40:	0e 4c       	mov	r12,	r14	;

00005e42 <.L4>:
    5e42:	0d 9f       	cmp	r15,	r13	;
    5e44:	0a 24       	jz	$+22     	;abs 0x5e5a

00005e46 <.LVL3>:
    5e46:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;

00005e4a <.LVL4>:
    5e4a:	1e 53       	inc	r14		;
    5e4c:	fa 3f       	jmp	$-10     	;abs 0x5e42

00005e4e <.L3>:
    5e4e:	09 4e       	mov	r14,	r9	;
    5e50:	39 e3       	inv	r9		;

00005e52 <.Loc.74.1>:
    5e52:	4d 43       	clr.b	r13		;

00005e54 <.L5>:
    5e54:	3d 53       	add	#-1,	r13	;r3 As==11

00005e56 <.LVL7>:
    5e56:	09 9d       	cmp	r13,	r9	;
    5e58:	02 20       	jnz	$+6      	;abs 0x5e5e

00005e5a <.L9>:
    5e5a:	19 17       	popm	#2,	r10	;16-bit words

00005e5c <.LCFI1>:
    5e5c:	30 41       	ret			

00005e5e <.L6>:
    5e5e:	0b 4e       	mov	r14,	r11	;
    5e60:	0b 5d       	add	r13,	r11	;
    5e62:	0b 5c       	add	r12,	r11	;
    5e64:	0a 4f       	mov	r15,	r10	;
    5e66:	0a 5d       	add	r13,	r10	;

00005e68 <.LVL10>:
    5e68:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    5e6c:	f3 3f       	jmp	$-24     	;abs 0x5e54

00005e6e <memset>:
    5e6e:	0e 5c       	add	r12,	r14	;

00005e70 <.LVL2>:
    5e70:	0f 4c       	mov	r12,	r15	;

00005e72 <L0^A>:
    5e72:	0f 9e       	cmp	r14,	r15	;
    5e74:	01 20       	jnz	$+4      	;abs 0x5e78

00005e76 <.Loc.104.1>:
    5e76:	30 41       	ret			

00005e78 <.L3>:
    5e78:	1f 53       	inc	r15		;

00005e7a <.LVL4>:
    5e7a:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    5e7e:	f9 3f       	jmp	$-12     	;abs 0x5e72
