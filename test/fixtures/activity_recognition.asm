
/Users/byeongjee/migration/probabilistic-energy-modeling/build/activity_recognition_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004064 <__crt0_start>:
    4064:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004068 <__crt0_call_main>:
    4068:	0c 43       	clr	r12		;
    406a:	b0 12 7e 52 	call	#21118		;#0x527e

0000406e <__crt0_call_exit>:
    406e:	b0 12 50 54 	call	#21584		;#0x5450

00004072 <clockSetup>:
    4072:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4076:	61 01 
    4078:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    407c:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    4080:	64 01 
    4082:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4086:	66 01 
    4088:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    408c:	62 01 
    408e:	0d 14       	pushm.a	#1,	r13	;20-bit words
    4090:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    4094:	1d 83       	dec	r13		;
    4096:	fe 23       	jnz	$-2      	;abs 0x4094
    4098:	0d 16       	popm.a	#1,	r13	;20-bit words
    409a:	00 3c       	jmp	$+2      	;abs 0x409c
    409c:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    40a0:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    40a4:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    40a8:	30 41       	ret			

000040aa <toggle_gpio>:
    40aa:	f2 e2 02 02 	xor.b	#8,	&0x0202	;r2 As==11
    40ae:	30 41       	ret			

000040b0 <begin_event>:
    40b0:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40b2:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    40b6:	3e 40 05 00 	mov	#5,	r14	;
    40ba:	1d 83       	dec	r13		;
    40bc:	0e 73       	sbc	r14		;
    40be:	fd 23       	jnz	$-4      	;abs 0x40ba
    40c0:	0d 93       	cmp	#0,	r13	;r3 As==00
    40c2:	fb 23       	jnz	$-8      	;abs 0x40ba
    40c4:	1d 16       	popm.a	#2,	r14	;20-bit words
    40c6:	f2 d2 02 02 	bis.b	#8,	&0x0202	;r2 As==11
    40ca:	30 41       	ret			

000040cc <end_event>:
    40cc:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    40d0:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40d2:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    40d6:	3e 40 05 00 	mov	#5,	r14	;
    40da:	1d 83       	dec	r13		;
    40dc:	0e 73       	sbc	r14		;
    40de:	fd 23       	jnz	$-4      	;abs 0x40da
    40e0:	0d 93       	cmp	#0,	r13	;r3 As==00
    40e2:	fb 23       	jnz	$-8      	;abs 0x40da
    40e4:	1d 16       	popm.a	#2,	r14	;20-bit words
    40e6:	30 41       	ret			

000040e8 <begin_measurement_window>:
    40e8:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40ea:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40ee:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    40f2:	1d 83       	dec	r13		;
    40f4:	0e 73       	sbc	r14		;
    40f6:	fd 23       	jnz	$-4      	;abs 0x40f2
    40f8:	0d 93       	cmp	#0,	r13	;r3 As==00
    40fa:	fb 23       	jnz	$-8      	;abs 0x40f2
    40fc:	1d 16       	popm.a	#2,	r14	;20-bit words
    40fe:	e2 d2 02 02 	bis.b	#4,	&0x0202	;r2 As==10
    4102:	30 41       	ret			

00004104 <end_measurement_window>:
    4104:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    4108:	1e 14       	pushm.a	#2,	r14	;20-bit words
    410a:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    410e:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    4112:	1d 83       	dec	r13		;
    4114:	0e 73       	sbc	r14		;
    4116:	fd 23       	jnz	$-4      	;abs 0x4112
    4118:	0d 93       	cmp	#0,	r13	;r3 As==00
    411a:	fb 23       	jnz	$-8      	;abs 0x4112
    411c:	1d 16       	popm.a	#2,	r14	;20-bit words
    411e:	30 41       	ret			

00004120 <delay>:
    4120:	0e 4c       	mov	r12,	r14	;
    4122:	3e 53       	add	#-1,	r14	;r3 As==11
    4124:	0f 4d       	mov	r13,	r15	;
    4126:	3f 63       	addc	#-1,	r15	;r3 As==11
    4128:	0c 4e       	mov	r14,	r12	;
    412a:	0c df       	bis	r15,	r12	;
    412c:	0c 93       	cmp	#0,	r12	;r3 As==00
    412e:	07 24       	jz	$+16     	;abs 0x413e
    4130:	03 43       	nop			
    4132:	3e 53       	add	#-1,	r14	;r3 As==11
    4134:	3f 63       	addc	#-1,	r15	;r3 As==11
    4136:	0c 4e       	mov	r14,	r12	;
    4138:	0c df       	bis	r15,	r12	;
    413a:	0c 93       	cmp	#0,	r12	;r3 As==00
    413c:	f9 23       	jnz	$-12     	;abs 0x4130
    413e:	30 41       	ret			

00004140 <bench_empty_function>:
    4140:	03 43       	nop			
    4142:	03 43       	nop			
    4144:	03 43       	nop			
    4146:	03 43       	nop			
    4148:	03 43       	nop			
    414a:	03 43       	nop			
    414c:	03 43       	nop			
    414e:	03 43       	nop			
    4150:	03 43       	nop			
    4152:	03 43       	nop			
    4154:	03 43       	nop			
    4156:	03 43       	nop			
    4158:	03 43       	nop			
    415a:	03 43       	nop			
    415c:	03 43       	nop			
    415e:	03 43       	nop			
    4160:	03 43       	nop			
    4162:	03 43       	nop			
    4164:	03 43       	nop			
    4166:	03 43       	nop			
    4168:	03 43       	nop			
    416a:	03 43       	nop			
    416c:	03 43       	nop			
    416e:	03 43       	nop			
    4170:	03 43       	nop			
    4172:	03 43       	nop			
    4174:	03 43       	nop			
    4176:	03 43       	nop			
    4178:	03 43       	nop			
    417a:	03 43       	nop			
    417c:	03 43       	nop			
    417e:	03 43       	nop			
    4180:	03 43       	nop			
    4182:	03 43       	nop			
    4184:	03 43       	nop			
    4186:	03 43       	nop			
    4188:	03 43       	nop			
    418a:	03 43       	nop			
    418c:	03 43       	nop			
    418e:	03 43       	nop			
    4190:	03 43       	nop			
    4192:	03 43       	nop			
    4194:	03 43       	nop			
    4196:	03 43       	nop			
    4198:	03 43       	nop			
    419a:	03 43       	nop			
    419c:	03 43       	nop			
    419e:	03 43       	nop			
    41a0:	03 43       	nop			
    41a2:	03 43       	nop			
    41a4:	30 41       	ret			

000041a6 <bench_empty_interrupt>:
    41a6:	02 12       	push	r2		;
    41a8:	32 c2       	dint			
    41aa:	03 43       	nop			
    41ac:	03 43       	nop			
    41ae:	03 43       	nop			
    41b0:	03 43       	nop			
    41b2:	03 43       	nop			
    41b4:	03 43       	nop			
    41b6:	03 43       	nop			
    41b8:	03 43       	nop			
    41ba:	03 43       	nop			
    41bc:	03 43       	nop			
    41be:	03 43       	nop			
    41c0:	03 43       	nop			
    41c2:	03 43       	nop			
    41c4:	03 43       	nop			
    41c6:	03 43       	nop			
    41c8:	03 43       	nop			
    41ca:	03 43       	nop			
    41cc:	03 43       	nop			
    41ce:	03 43       	nop			
    41d0:	03 43       	nop			
    41d2:	03 43       	nop			
    41d4:	03 43       	nop			
    41d6:	03 43       	nop			
    41d8:	03 43       	nop			
    41da:	03 43       	nop			
    41dc:	03 43       	nop			
    41de:	03 43       	nop			
    41e0:	03 43       	nop			
    41e2:	03 43       	nop			
    41e4:	03 43       	nop			
    41e6:	03 43       	nop			
    41e8:	03 43       	nop			
    41ea:	03 43       	nop			
    41ec:	03 43       	nop			
    41ee:	03 43       	nop			
    41f0:	03 43       	nop			
    41f2:	03 43       	nop			
    41f4:	03 43       	nop			
    41f6:	03 43       	nop			
    41f8:	03 43       	nop			
    41fa:	03 43       	nop			
    41fc:	03 43       	nop			
    41fe:	03 43       	nop			
    4200:	03 43       	nop			
    4202:	03 43       	nop			
    4204:	03 43       	nop			
    4206:	03 43       	nop			
    4208:	03 43       	nop			
    420a:	03 43       	nop			
    420c:	03 43       	nop			
    420e:	00 13       	reti			

00004210 <initialize>:
    4210:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    4214:	5c 01 
    4216:	92 c3 30 01 	bic	#1,	&0x0130	;r3 As==01
    421a:	3c 40 88 1c 	mov	#7304,	r12	;#0x1c88
    421e:	3c 90 88 1c 	cmp	#7304,	r12	;#0x1c88
    4222:	07 2c       	jc	$+16     	;abs 0x4232
    4224:	3e 40 88 1c 	mov	#7304,	r14	;#0x1c88
    4228:	0e 8c       	sub	r12,	r14	;
    422a:	3d 40 52 54 	mov	#21586,	r13	;#0x5452
    422e:	b0 12 3e 54 	call	#21566		;#0x543e
    4232:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4236:	61 01 
    4238:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    423c:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    4240:	64 01 
    4242:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4246:	66 01 
    4248:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    424c:	62 01 
    424e:	0d 14       	pushm.a	#1,	r13	;20-bit words
    4250:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    4254:	1d 83       	dec	r13		;
    4256:	fe 23       	jnz	$-2      	;abs 0x4254
    4258:	0d 16       	popm.a	#1,	r13	;20-bit words
    425a:	00 3c       	jmp	$+2      	;abs 0x425c
    425c:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    4260:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4264:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4268:	f2 d0 0c 00 	bis.b	#12,	&0x0204	;#0x000c
    426c:	04 02 
    426e:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    4272:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    4276:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4278:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    427c:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    4280:	1d 83       	dec	r13		;
    4282:	0e 73       	sbc	r14		;
    4284:	fd 23       	jnz	$-4      	;abs 0x4280
    4286:	0d 93       	cmp	#0,	r13	;r3 As==00
    4288:	fb 23       	jnz	$-8      	;abs 0x4280
    428a:	1d 16       	popm.a	#2,	r14	;20-bit words
    428c:	32 c0 07 01 	bic	#263,	r2	;#0x0107
    4290:	30 41       	ret			

00004292 <ACCEL_init>:
    4292:	30 41       	ret			

00004294 <accel_sample>:
    4294:	2a 15       	pushm	#3,	r10	;16-bit words
    4296:	09 4c       	mov	r12,	r9	;
    4298:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    429c:	1a 42 82 1c 	mov	&0x1c82,r10	;0x1c82
    42a0:	0c 4a       	mov	r10,	r12	;
    42a2:	5c f3       	and.b	#1,	r12	;r3 As==01
    42a4:	5a 03       	rrum	#1,	r10	;
    42a6:	0d 93       	cmp	#0,	r13	;r3 As==00
    42a8:	26 20       	jnz	$+78     	;abs 0x42f6
    42aa:	0c 93       	cmp	#0,	r12	;r3 As==00
    42ac:	02 24       	jz	$+6      	;abs 0x42b2
    42ae:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    42b2:	4c 4a       	mov.b	r10,	r12	;
    42b4:	7c f0 03 00 	and.b	#3,	r12	;
    42b8:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    42bc:	c9 4c 00 00 	mov.b	r12,	0(r9)	;
    42c0:	0d 4a       	mov	r10,	r13	;
    42c2:	5d 03       	rrum	#1,	r13	;
    42c4:	1a b3       	bit	#1,	r10	;r3 As==01
    42c6:	02 24       	jz	$+6      	;abs 0x42cc
    42c8:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    42cc:	4c 4d       	mov.b	r13,	r12	;
    42ce:	7c f0 03 00 	and.b	#3,	r12	;
    42d2:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    42d6:	c9 4c 01 00 	mov.b	r12,	1(r9)	;
    42da:	0c 4d       	mov	r13,	r12	;
    42dc:	5c 03       	rrum	#1,	r12	;
    42de:	1d b3       	bit	#1,	r13	;r3 As==01
    42e0:	3b 20       	jnz	$+120    	;abs 0x4358
    42e2:	82 4c 82 1c 	mov	r12,	&0x1c82	;
    42e6:	7c f0 03 00 	and.b	#3,	r12	;
    42ea:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    42ee:	c9 4c 02 00 	mov.b	r12,	2(r9)	;
    42f2:	28 17       	popm	#3,	r10	;16-bit words
    42f4:	30 41       	ret			
    42f6:	0c 93       	cmp	#0,	r12	;r3 As==00
    42f8:	02 24       	jz	$+6      	;abs 0x42fe
    42fa:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    42fe:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4302:	0c 4a       	mov	r10,	r12	;
    4304:	b0 12 3a 53 	call	#21306		;#0x533a
    4308:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    430c:	c9 4c 00 00 	mov.b	r12,	0(r9)	;
    4310:	08 4a       	mov	r10,	r8	;
    4312:	58 03       	rrum	#1,	r8	;
    4314:	1a b3       	bit	#1,	r10	;r3 As==01
    4316:	02 24       	jz	$+6      	;abs 0x431c
    4318:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    431c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4320:	0c 48       	mov	r8,	r12	;
    4322:	b0 12 3a 53 	call	#21306		;#0x533a
    4326:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    432a:	c9 4c 01 00 	mov.b	r12,	1(r9)	;
    432e:	0c 48       	mov	r8,	r12	;
    4330:	5c 03       	rrum	#1,	r12	;
    4332:	18 b3       	bit	#1,	r8	;r3 As==01
    4334:	0c 20       	jnz	$+26     	;abs 0x434e
    4336:	82 4c 82 1c 	mov	r12,	&0x1c82	;
    433a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    433e:	b0 12 3a 53 	call	#21306		;#0x533a
    4342:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4346:	c9 4c 02 00 	mov.b	r12,	2(r9)	;
    434a:	28 17       	popm	#3,	r10	;16-bit words
    434c:	30 41       	ret			
    434e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4352:	82 4c 82 1c 	mov	r12,	&0x1c82	;
    4356:	f1 3f       	jmp	$-28     	;abs 0x433a
    4358:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    435c:	82 4c 82 1c 	mov	r12,	&0x1c82	;
    4360:	c2 3f       	jmp	$-122    	;abs 0x42e6

00004362 <acquire_window>:
    4362:	4a 15       	pushm	#5,	r10	;16-bit words
    4364:	0a 4c       	mov	r12,	r10	;
    4366:	19 42 82 1c 	mov	&0x1c82,r9	;0x1c82
    436a:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    436e:	0c 49       	mov	r9,	r12	;
    4370:	5c f3       	and.b	#1,	r12	;r3 As==01
    4372:	59 03       	rrum	#1,	r9	;
    4374:	0d 93       	cmp	#0,	r13	;r3 As==00
    4376:	ee 24       	jz	$+478    	;abs 0x4554
    4378:	0c 93       	cmp	#0,	r12	;r3 As==00
    437a:	02 24       	jz	$+6      	;abs 0x4380
    437c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4380:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4384:	0c 49       	mov	r9,	r12	;
    4386:	b0 12 3a 53 	call	#21306		;#0x533a
    438a:	48 4c       	mov.b	r12,	r8	;
    438c:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    4390:	88 11       	sxt	r8		;
    4392:	06 49       	mov	r9,	r6	;
    4394:	56 03       	rrum	#1,	r6	;
    4396:	19 b3       	bit	#1,	r9	;r3 As==01
    4398:	02 24       	jz	$+6      	;abs 0x439e
    439a:	36 e0 00 b4 	xor	#-19456,r6	;#0xb400
    439e:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43a2:	0c 46       	mov	r6,	r12	;
    43a4:	b0 12 3a 53 	call	#21306		;#0x533a
    43a8:	47 4c       	mov.b	r12,	r7	;
    43aa:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    43ae:	87 11       	sxt	r7		;
    43b0:	09 46       	mov	r6,	r9	;
    43b2:	59 03       	rrum	#1,	r9	;
    43b4:	16 b3       	bit	#1,	r6	;r3 As==01
    43b6:	f7 20       	jnz	$+496    	;abs 0x45a6
    43b8:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43bc:	0c 49       	mov	r9,	r12	;
    43be:	b0 12 3a 53 	call	#21306		;#0x533a
    43c2:	4d 4c       	mov.b	r12,	r13	;
    43c4:	7d 50 e2 ff 	add.b	#-30,	r13	;#0xffe2
    43c8:	8d 11       	sxt	r13		;
    43ca:	ca 48 00 00 	mov.b	r8,	0(r10)	;
    43ce:	ca 47 01 00 	mov.b	r7,	1(r10)	;
    43d2:	ca 4d 02 00 	mov.b	r13,	2(r10)	;
    43d6:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    43da:	0c 49       	mov	r9,	r12	;
    43dc:	5c f3       	and.b	#1,	r12	;r3 As==01
    43de:	59 03       	rrum	#1,	r9	;
    43e0:	0d 93       	cmp	#0,	r13	;r3 As==00
    43e2:	95 24       	jz	$+300    	;abs 0x450e
    43e4:	0c 93       	cmp	#0,	r12	;r3 As==00
    43e6:	02 24       	jz	$+6      	;abs 0x43ec
    43e8:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    43ec:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43f0:	0c 49       	mov	r9,	r12	;
    43f2:	b0 12 3a 53 	call	#21306		;#0x533a
    43f6:	48 4c       	mov.b	r12,	r8	;
    43f8:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    43fc:	88 11       	sxt	r8		;
    43fe:	06 49       	mov	r9,	r6	;
    4400:	56 03       	rrum	#1,	r6	;
    4402:	19 b3       	bit	#1,	r9	;r3 As==01
    4404:	02 24       	jz	$+6      	;abs 0x440a
    4406:	36 e0 00 b4 	xor	#-19456,r6	;#0xb400
    440a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    440e:	0c 46       	mov	r6,	r12	;
    4410:	b0 12 3a 53 	call	#21306		;#0x533a
    4414:	47 4c       	mov.b	r12,	r7	;
    4416:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    441a:	87 11       	sxt	r7		;
    441c:	09 46       	mov	r6,	r9	;
    441e:	59 03       	rrum	#1,	r9	;
    4420:	16 b3       	bit	#1,	r6	;r3 As==01
    4422:	be 20       	jnz	$+382    	;abs 0x45a0
    4424:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4428:	0c 49       	mov	r9,	r12	;
    442a:	b0 12 3a 53 	call	#21306		;#0x533a
    442e:	4d 4c       	mov.b	r12,	r13	;
    4430:	7d 50 e2 ff 	add.b	#-30,	r13	;#0xffe2
    4434:	8d 11       	sxt	r13		;
    4436:	ca 48 03 00 	mov.b	r8,	3(r10)	;
    443a:	ca 47 04 00 	mov.b	r7,	4(r10)	;
    443e:	ca 4d 05 00 	mov.b	r13,	5(r10)	;
    4442:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4446:	0c 49       	mov	r9,	r12	;
    4448:	5c f3       	and.b	#1,	r12	;r3 As==01
    444a:	59 03       	rrum	#1,	r9	;
    444c:	0d 93       	cmp	#0,	r13	;r3 As==00
    444e:	2a 20       	jnz	$+86     	;abs 0x44a4
    4450:	0c 93       	cmp	#0,	r12	;r3 As==00
    4452:	02 24       	jz	$+6      	;abs 0x4458
    4454:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4458:	48 49       	mov.b	r9,	r8	;
    445a:	78 f0 03 00 	and.b	#3,	r8	;
    445e:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    4462:	88 11       	sxt	r8		;
    4464:	0d 49       	mov	r9,	r13	;
    4466:	5d 03       	rrum	#1,	r13	;
    4468:	19 b3       	bit	#1,	r9	;r3 As==01
    446a:	02 24       	jz	$+6      	;abs 0x4470
    446c:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4470:	49 4d       	mov.b	r13,	r9	;
    4472:	79 f0 03 00 	and.b	#3,	r9	;
    4476:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    447a:	89 11       	sxt	r9		;
    447c:	07 4d       	mov	r13,	r7	;
    447e:	57 03       	rrum	#1,	r7	;
    4480:	1d b3       	bit	#1,	r13	;r3 As==01
    4482:	8b 20       	jnz	$+280    	;abs 0x459a
    4484:	4d 47       	mov.b	r7,	r13	;
    4486:	7d f0 03 00 	and.b	#3,	r13	;
    448a:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    448e:	8d 11       	sxt	r13		;
    4490:	ca 48 06 00 	mov.b	r8,	6(r10)	;
    4494:	ca 49 07 00 	mov.b	r9,	7(r10)	;
    4498:	ca 4d 08 00 	mov.b	r13,	8(r10)	;
    449c:	82 47 82 1c 	mov	r7,	&0x1c82	;
    44a0:	46 17       	popm	#5,	r10	;16-bit words
    44a2:	30 41       	ret			
    44a4:	0c 93       	cmp	#0,	r12	;r3 As==00
    44a6:	02 24       	jz	$+6      	;abs 0x44ac
    44a8:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    44ac:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    44b0:	0c 49       	mov	r9,	r12	;
    44b2:	b0 12 3a 53 	call	#21306		;#0x533a
    44b6:	48 4c       	mov.b	r12,	r8	;
    44b8:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    44bc:	88 11       	sxt	r8		;
    44be:	06 49       	mov	r9,	r6	;
    44c0:	56 03       	rrum	#1,	r6	;
    44c2:	19 b3       	bit	#1,	r9	;r3 As==01
    44c4:	02 24       	jz	$+6      	;abs 0x44ca
    44c6:	36 e0 00 b4 	xor	#-19456,r6	;#0xb400
    44ca:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    44ce:	0c 46       	mov	r6,	r12	;
    44d0:	b0 12 3a 53 	call	#21306		;#0x533a
    44d4:	49 4c       	mov.b	r12,	r9	;
    44d6:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    44da:	89 11       	sxt	r9		;
    44dc:	07 46       	mov	r6,	r7	;
    44de:	57 03       	rrum	#1,	r7	;
    44e0:	16 b3       	bit	#1,	r6	;r3 As==01
    44e2:	02 24       	jz	$+6      	;abs 0x44e8
    44e4:	37 e0 00 b4 	xor	#-19456,r7	;#0xb400
    44e8:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    44ec:	0c 47       	mov	r7,	r12	;
    44ee:	b0 12 3a 53 	call	#21306		;#0x533a
    44f2:	4d 4c       	mov.b	r12,	r13	;
    44f4:	7d 50 e2 ff 	add.b	#-30,	r13	;#0xffe2
    44f8:	8d 11       	sxt	r13		;
    44fa:	ca 48 06 00 	mov.b	r8,	6(r10)	;
    44fe:	ca 49 07 00 	mov.b	r9,	7(r10)	;
    4502:	ca 4d 08 00 	mov.b	r13,	8(r10)	;
    4506:	82 47 82 1c 	mov	r7,	&0x1c82	;
    450a:	46 17       	popm	#5,	r10	;16-bit words
    450c:	30 41       	ret			
    450e:	0c 93       	cmp	#0,	r12	;r3 As==00
    4510:	02 24       	jz	$+6      	;abs 0x4516
    4512:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4516:	48 49       	mov.b	r9,	r8	;
    4518:	78 f0 03 00 	and.b	#3,	r8	;
    451c:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    4520:	88 11       	sxt	r8		;
    4522:	0d 49       	mov	r9,	r13	;
    4524:	5d 03       	rrum	#1,	r13	;
    4526:	19 b3       	bit	#1,	r9	;r3 As==01
    4528:	02 24       	jz	$+6      	;abs 0x452e
    452a:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    452e:	47 4d       	mov.b	r13,	r7	;
    4530:	77 f0 03 00 	and.b	#3,	r7	;
    4534:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    4538:	87 11       	sxt	r7		;
    453a:	09 4d       	mov	r13,	r9	;
    453c:	59 03       	rrum	#1,	r9	;
    453e:	1d b3       	bit	#1,	r13	;r3 As==01
    4540:	02 24       	jz	$+6      	;abs 0x4546
    4542:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4546:	4d 49       	mov.b	r9,	r13	;
    4548:	7d f0 03 00 	and.b	#3,	r13	;
    454c:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    4550:	8d 11       	sxt	r13		;
    4552:	71 3f       	jmp	$-284    	;abs 0x4436
    4554:	0c 93       	cmp	#0,	r12	;r3 As==00
    4556:	02 24       	jz	$+6      	;abs 0x455c
    4558:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    455c:	48 49       	mov.b	r9,	r8	;
    455e:	78 f0 03 00 	and.b	#3,	r8	;
    4562:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    4566:	88 11       	sxt	r8		;
    4568:	0d 49       	mov	r9,	r13	;
    456a:	5d 03       	rrum	#1,	r13	;
    456c:	19 b3       	bit	#1,	r9	;r3 As==01
    456e:	02 24       	jz	$+6      	;abs 0x4574
    4570:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4574:	47 4d       	mov.b	r13,	r7	;
    4576:	77 f0 03 00 	and.b	#3,	r7	;
    457a:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    457e:	87 11       	sxt	r7		;
    4580:	09 4d       	mov	r13,	r9	;
    4582:	59 03       	rrum	#1,	r9	;
    4584:	1d b3       	bit	#1,	r13	;r3 As==01
    4586:	02 24       	jz	$+6      	;abs 0x458c
    4588:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    458c:	4d 49       	mov.b	r9,	r13	;
    458e:	7d f0 03 00 	and.b	#3,	r13	;
    4592:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    4596:	8d 11       	sxt	r13		;
    4598:	18 3f       	jmp	$-462    	;abs 0x43ca
    459a:	37 e0 00 b4 	xor	#-19456,r7	;#0xb400
    459e:	72 3f       	jmp	$-282    	;abs 0x4484
    45a0:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    45a4:	3f 3f       	jmp	$-384    	;abs 0x4424
    45a6:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    45aa:	06 3f       	jmp	$-498    	;abs 0x43b8

000045ac <transform>:
    45ac:	6d 4c       	mov.b	@r12,	r13	;
    45ae:	8d 11       	sxt	r13		;
    45b0:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    45b4:	6e 4c       	mov.b	@r12,	r14	;
    45b6:	4e ed       	xor.b	r13,	r14	;
    45b8:	4e 8d       	sub.b	r13,	r14	;
    45ba:	7d 40 09 00 	mov.b	#9,	r13	;
    45be:	4d 9e       	cmp.b	r14,	r13	;
    45c0:	02 28       	jnc	$+6      	;abs 0x45c6
    45c2:	cc 43 00 00 	mov.b	#0,	0(r12)	;r3 As==00
    45c6:	5d 4c 01 00 	mov.b	1(r12),	r13	;
    45ca:	8d 11       	sxt	r13		;
    45cc:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    45d0:	5e 4c 01 00 	mov.b	1(r12),	r14	;
    45d4:	4e ed       	xor.b	r13,	r14	;
    45d6:	4e 8d       	sub.b	r13,	r14	;
    45d8:	7d 40 09 00 	mov.b	#9,	r13	;
    45dc:	4d 9e       	cmp.b	r14,	r13	;
    45de:	02 28       	jnc	$+6      	;abs 0x45e4
    45e0:	cc 43 01 00 	mov.b	#0,	1(r12)	;r3 As==00
    45e4:	5d 4c 02 00 	mov.b	2(r12),	r13	;
    45e8:	8d 11       	sxt	r13		;
    45ea:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    45ee:	5e 4c 02 00 	mov.b	2(r12),	r14	;
    45f2:	4e ed       	xor.b	r13,	r14	;
    45f4:	4e 8d       	sub.b	r13,	r14	;
    45f6:	7d 40 09 00 	mov.b	#9,	r13	;
    45fa:	4d 9e       	cmp.b	r14,	r13	;
    45fc:	02 28       	jnc	$+6      	;abs 0x4602
    45fe:	cc 43 02 00 	mov.b	#0,	2(r12)	;r3 As==00
    4602:	5d 4c 03 00 	mov.b	3(r12),	r13	;
    4606:	8d 11       	sxt	r13		;
    4608:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    460c:	5e 4c 03 00 	mov.b	3(r12),	r14	;
    4610:	4e ed       	xor.b	r13,	r14	;
    4612:	4e 8d       	sub.b	r13,	r14	;
    4614:	7d 40 09 00 	mov.b	#9,	r13	;
    4618:	4d 9e       	cmp.b	r14,	r13	;
    461a:	02 28       	jnc	$+6      	;abs 0x4620
    461c:	cc 43 03 00 	mov.b	#0,	3(r12)	;r3 As==00
    4620:	5d 4c 04 00 	mov.b	4(r12),	r13	;
    4624:	8d 11       	sxt	r13		;
    4626:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    462a:	5e 4c 04 00 	mov.b	4(r12),	r14	;
    462e:	4e ed       	xor.b	r13,	r14	;
    4630:	4e 8d       	sub.b	r13,	r14	;
    4632:	7d 40 09 00 	mov.b	#9,	r13	;
    4636:	4d 9e       	cmp.b	r14,	r13	;
    4638:	02 28       	jnc	$+6      	;abs 0x463e
    463a:	cc 43 04 00 	mov.b	#0,	4(r12)	;r3 As==00
    463e:	5d 4c 05 00 	mov.b	5(r12),	r13	;
    4642:	8d 11       	sxt	r13		;
    4644:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    4648:	5e 4c 05 00 	mov.b	5(r12),	r14	;
    464c:	4e ed       	xor.b	r13,	r14	;
    464e:	4e 8d       	sub.b	r13,	r14	;
    4650:	7d 40 09 00 	mov.b	#9,	r13	;
    4654:	4d 9e       	cmp.b	r14,	r13	;
    4656:	02 28       	jnc	$+6      	;abs 0x465c
    4658:	cc 43 05 00 	mov.b	#0,	5(r12)	;r3 As==00
    465c:	5d 4c 06 00 	mov.b	6(r12),	r13	;
    4660:	8d 11       	sxt	r13		;
    4662:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    4666:	5e 4c 06 00 	mov.b	6(r12),	r14	;
    466a:	4e ed       	xor.b	r13,	r14	;
    466c:	4e 8d       	sub.b	r13,	r14	;
    466e:	7d 40 09 00 	mov.b	#9,	r13	;
    4672:	4d 9e       	cmp.b	r14,	r13	;
    4674:	02 28       	jnc	$+6      	;abs 0x467a
    4676:	cc 43 06 00 	mov.b	#0,	6(r12)	;r3 As==00
    467a:	5d 4c 07 00 	mov.b	7(r12),	r13	;
    467e:	8d 11       	sxt	r13		;
    4680:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    4684:	5e 4c 07 00 	mov.b	7(r12),	r14	;
    4688:	4e ed       	xor.b	r13,	r14	;
    468a:	4e 8d       	sub.b	r13,	r14	;
    468c:	7d 40 09 00 	mov.b	#9,	r13	;
    4690:	4d 9e       	cmp.b	r14,	r13	;
    4692:	02 28       	jnc	$+6      	;abs 0x4698
    4694:	cc 43 07 00 	mov.b	#0,	7(r12)	;r3 As==00
    4698:	5d 4c 08 00 	mov.b	8(r12),	r13	;
    469c:	8d 11       	sxt	r13		;
    469e:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    46a2:	5e 4c 08 00 	mov.b	8(r12),	r14	;
    46a6:	4e ed       	xor.b	r13,	r14	;
    46a8:	4e 8d       	sub.b	r13,	r14	;
    46aa:	7d 40 09 00 	mov.b	#9,	r13	;
    46ae:	4d 9e       	cmp.b	r14,	r13	;
    46b0:	02 28       	jnc	$+6      	;abs 0x46b6
    46b2:	cc 43 08 00 	mov.b	#0,	8(r12)	;r3 As==00
    46b6:	30 41       	ret			

000046b8 <featurize>:
    46b8:	6a 15       	pushm	#7,	r10	;16-bit words
    46ba:	31 80 18 00 	sub	#24,	r1	;#0x0018
    46be:	81 4c 16 00 	mov	r12,	22(r1)	; 0x0016
    46c2:	0e 4d       	mov	r13,	r14	;
    46c4:	68 4d       	mov.b	@r13,	r8	;
    46c6:	88 11       	sxt	r8		;
    46c8:	57 4d 01 00 	mov.b	1(r13),	r7	;
    46cc:	87 11       	sxt	r7		;
    46ce:	81 47 0c 00 	mov	r7,	12(r1)	; 0x000c
    46d2:	57 4d 02 00 	mov.b	2(r13),	r7	;
    46d6:	87 11       	sxt	r7		;
    46d8:	81 47 0e 00 	mov	r7,	14(r1)	; 0x000e
    46dc:	57 4d 03 00 	mov.b	3(r13),	r7	;
    46e0:	87 11       	sxt	r7		;
    46e2:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    46e6:	0a 48       	mov	r8,	r10	;
    46e8:	0b 48       	mov	r8,	r11	;
    46ea:	4e 18 0b 11 	rpt #15 { rrax.w	r11		;
    46ee:	0c 47       	mov	r7,	r12	;
    46f0:	0d 47       	mov	r7,	r13	;
    46f2:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    46f6:	0c 5a       	add	r10,	r12	;
    46f8:	0b 6d       	addc	r13,	r11	;
    46fa:	57 4e 04 00 	mov.b	4(r14),	r7	;
    46fe:	87 11       	sxt	r7		;
    4700:	81 47 12 00 	mov	r7,	18(r1)	; 0x0012
    4704:	17 41 0c 00 	mov	12(r1),	r7	;0x0000c
    4708:	04 47       	mov	r7,	r4	;
    470a:	05 47       	mov	r7,	r5	;
    470c:	4e 18 05 11 	rpt #15 { rrax.w	r5		;
    4710:	1d 41 12 00 	mov	18(r1),	r13	;0x00012
    4714:	06 4d       	mov	r13,	r6	;
    4716:	07 4d       	mov	r13,	r7	;
    4718:	4e 18 07 11 	rpt #15 { rrax.w	r7		;
    471c:	0a 44       	mov	r4,	r10	;
    471e:	0a 56       	add	r6,	r10	;
    4720:	09 45       	mov	r5,	r9	;
    4722:	09 67       	addc	r7,	r9	;
    4724:	57 4e 05 00 	mov.b	5(r14),	r7	;
    4728:	87 11       	sxt	r7		;
    472a:	81 47 14 00 	mov	r7,	20(r1)	; 0x0014
    472e:	17 41 0e 00 	mov	14(r1),	r7	;0x0000e
    4732:	04 47       	mov	r7,	r4	;
    4734:	05 47       	mov	r7,	r5	;
    4736:	4e 18 05 11 	rpt #15 { rrax.w	r5		;
    473a:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    473e:	06 4d       	mov	r13,	r6	;
    4740:	07 4d       	mov	r13,	r7	;
    4742:	4e 18 07 11 	rpt #15 { rrax.w	r7		;
    4746:	0f 44       	mov	r4,	r15	;
    4748:	0f 56       	add	r6,	r15	;
    474a:	0d 45       	mov	r5,	r13	;
    474c:	0d 67       	addc	r7,	r13	;
    474e:	57 4e 06 00 	mov.b	6(r14),	r7	;
    4752:	87 11       	sxt	r7		;
    4754:	81 47 06 00 	mov	r7,	6(r1)	;
    4758:	04 47       	mov	r7,	r4	;
    475a:	05 47       	mov	r7,	r5	;
    475c:	4e 18 05 11 	rpt #15 { rrax.w	r5		;
    4760:	57 4e 07 00 	mov.b	7(r14),	r7	;
    4764:	87 11       	sxt	r7		;
    4766:	81 47 08 00 	mov	r7,	8(r1)	;
    476a:	06 47       	mov	r7,	r6	;
    476c:	4e 18 07 11 	rpt #15 { rrax.w	r7		;
    4770:	0a 56       	add	r6,	r10	;
    4772:	09 67       	addc	r7,	r9	;
    4774:	5e 4e 08 00 	mov.b	8(r14),	r14	;
    4778:	8e 11       	sxt	r14		;
    477a:	81 4e 0a 00 	mov	r14,	10(r1)	; 0x000a
    477e:	06 4e       	mov	r14,	r6	;
    4780:	07 4e       	mov	r14,	r7	;
    4782:	4e 18 07 11 	rpt #15 { rrax.w	r7		;
    4786:	06 5f       	add	r15,	r6	;
    4788:	07 6d       	addc	r13,	r7	;
    478a:	7e 40 03 00 	mov.b	#3,	r14	;
    478e:	4f 43       	clr.b	r15		;
    4790:	0c 54       	add	r4,	r12	;
    4792:	0d 45       	mov	r5,	r13	;
    4794:	0d 6b       	addc	r11,	r13	;
    4796:	b0 12 c2 53 	call	#21442		;#0x53c2
    479a:	81 4c 04 00 	mov	r12,	4(r1)	;
    479e:	7e 40 03 00 	mov.b	#3,	r14	;
    47a2:	4f 43       	clr.b	r15		;
    47a4:	0c 4a       	mov	r10,	r12	;
    47a6:	0d 49       	mov	r9,	r13	;
    47a8:	b0 12 c2 53 	call	#21442		;#0x53c2
    47ac:	0a 4c       	mov	r12,	r10	;
    47ae:	7e 40 03 00 	mov.b	#3,	r14	;
    47b2:	4f 43       	clr.b	r15		;
    47b4:	0c 46       	mov	r6,	r12	;
    47b6:	0d 47       	mov	r7,	r13	;
    47b8:	b0 12 c2 53 	call	#21442		;#0x53c2
    47bc:	0e 4c       	mov	r12,	r14	;
    47be:	18 81 04 00 	sub	4(r1),	r8	;
    47c2:	0d 48       	mov	r8,	r13	;
    47c4:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    47c8:	08 ed       	xor	r13,	r8	;
    47ca:	0c 48       	mov	r8,	r12	;
    47cc:	0c 8d       	sub	r13,	r12	;
    47ce:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    47d2:	0d 7d       	subc	r13,	r13	;
    47d4:	3d e3       	inv	r13		;
    47d6:	18 41 10 00 	mov	16(r1),	r8	;0x00010
    47da:	18 81 04 00 	sub	4(r1),	r8	;
    47de:	0f 48       	mov	r8,	r15	;
    47e0:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    47e4:	08 ef       	xor	r15,	r8	;
    47e6:	08 8f       	sub	r15,	r8	;
    47e8:	38 b0 00 80 	bit	#-32768,r8	;#0x8000
    47ec:	09 79       	subc	r9,	r9	;
    47ee:	39 e3       	inv	r9		;
    47f0:	0b 4c       	mov	r12,	r11	;
    47f2:	0b 58       	add	r8,	r11	;
    47f4:	04 4d       	mov	r13,	r4	;
    47f6:	04 69       	addc	r9,	r4	;
    47f8:	18 41 0c 00 	mov	12(r1),	r8	;0x0000c
    47fc:	08 8a       	sub	r10,	r8	;
    47fe:	0c 48       	mov	r8,	r12	;
    4800:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    4804:	08 ec       	xor	r12,	r8	;
    4806:	08 8c       	sub	r12,	r8	;
    4808:	38 b0 00 80 	bit	#-32768,r8	;#0x8000
    480c:	09 79       	subc	r9,	r9	;
    480e:	39 e3       	inv	r9		;
    4810:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4814:	0c 8a       	sub	r10,	r12	;
    4816:	0d 4c       	mov	r12,	r13	;
    4818:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    481c:	0c ed       	xor	r13,	r12	;
    481e:	0c 8d       	sub	r13,	r12	;
    4820:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4824:	0d 7d       	subc	r13,	r13	;
    4826:	3d e3       	inv	r13		;
    4828:	08 5c       	add	r12,	r8	;
    482a:	05 49       	mov	r9,	r5	;
    482c:	05 6d       	addc	r13,	r5	;
    482e:	16 41 0e 00 	mov	14(r1),	r6	;0x0000e
    4832:	06 8e       	sub	r14,	r6	;
    4834:	0c 46       	mov	r6,	r12	;
    4836:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    483a:	06 ec       	xor	r12,	r6	;
    483c:	06 8c       	sub	r12,	r6	;
    483e:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    4842:	07 77       	subc	r7,	r7	;
    4844:	37 e3       	inv	r7		;
    4846:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    484a:	0c 8e       	sub	r14,	r12	;
    484c:	0d 4c       	mov	r12,	r13	;
    484e:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4852:	0c ed       	xor	r13,	r12	;
    4854:	0c 8d       	sub	r13,	r12	;
    4856:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    485a:	0d 7d       	subc	r13,	r13	;
    485c:	3d e3       	inv	r13		;
    485e:	09 46       	mov	r6,	r9	;
    4860:	09 5c       	add	r12,	r9	;
    4862:	07 6d       	addc	r13,	r7	;
    4864:	1c 41 06 00 	mov	6(r1),	r12	;
    4868:	1c 81 04 00 	sub	4(r1),	r12	;
    486c:	0d 4c       	mov	r12,	r13	;
    486e:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4872:	0c ed       	xor	r13,	r12	;
    4874:	0c 8d       	sub	r13,	r12	;
    4876:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    487a:	0d 7d       	subc	r13,	r13	;
    487c:	3d e3       	inv	r13		;
    487e:	0b 5c       	add	r12,	r11	;
    4880:	04 6d       	addc	r13,	r4	;
    4882:	1c 41 08 00 	mov	8(r1),	r12	;
    4886:	0c 8a       	sub	r10,	r12	;
    4888:	0d 4c       	mov	r12,	r13	;
    488a:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    488e:	0c ed       	xor	r13,	r12	;
    4890:	0c 8d       	sub	r13,	r12	;
    4892:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4896:	0d 7d       	subc	r13,	r13	;
    4898:	3d e3       	inv	r13		;
    489a:	08 5c       	add	r12,	r8	;
    489c:	05 6d       	addc	r13,	r5	;
    489e:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    48a2:	0c 8e       	sub	r14,	r12	;
    48a4:	0d 4c       	mov	r12,	r13	;
    48a6:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    48aa:	0c ed       	xor	r13,	r12	;
    48ac:	0c 8d       	sub	r13,	r12	;
    48ae:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    48b2:	0d 7d       	subc	r13,	r13	;
    48b4:	3d e3       	inv	r13		;
    48b6:	09 5c       	add	r12,	r9	;
    48b8:	07 6d       	addc	r13,	r7	;
    48ba:	1c 41 04 00 	mov	4(r1),	r12	;
    48be:	0d 4c       	mov	r12,	r13	;
    48c0:	81 4b 00 00 	mov	r11,	0(r1)	;
    48c4:	81 4e 02 00 	mov	r14,	2(r1)	;
    48c8:	b0 12 0a 54 	call	#21514		;#0x540a
    48cc:	06 4c       	mov	r12,	r6	;
    48ce:	0c 4a       	mov	r10,	r12	;
    48d0:	0d 4a       	mov	r10,	r13	;
    48d2:	b0 12 0a 54 	call	#21514		;#0x540a
    48d6:	06 5c       	add	r12,	r6	;
    48d8:	1e 41 02 00 	mov	2(r1),	r14	;
    48dc:	0c 4e       	mov	r14,	r12	;
    48de:	0d 4e       	mov	r14,	r13	;
    48e0:	b0 12 0a 54 	call	#21514		;#0x540a
    48e4:	06 5c       	add	r12,	r6	;
    48e6:	7e 40 03 00 	mov.b	#3,	r14	;
    48ea:	4f 43       	clr.b	r15		;
    48ec:	2b 41       	mov	@r1,	r11	;
    48ee:	0c 4b       	mov	r11,	r12	;
    48f0:	0d 44       	mov	r4,	r13	;
    48f2:	b0 12 c2 53 	call	#21442		;#0x53c2
    48f6:	0a 4c       	mov	r12,	r10	;
    48f8:	7e 40 03 00 	mov.b	#3,	r14	;
    48fc:	4f 43       	clr.b	r15		;
    48fe:	0c 48       	mov	r8,	r12	;
    4900:	0d 45       	mov	r5,	r13	;
    4902:	b0 12 c2 53 	call	#21442		;#0x53c2
    4906:	08 4c       	mov	r12,	r8	;
    4908:	7e 40 03 00 	mov.b	#3,	r14	;
    490c:	4f 43       	clr.b	r15		;
    490e:	0c 49       	mov	r9,	r12	;
    4910:	0d 47       	mov	r7,	r13	;
    4912:	b0 12 c2 53 	call	#21442		;#0x53c2
    4916:	09 4c       	mov	r12,	r9	;
    4918:	0c 4a       	mov	r10,	r12	;
    491a:	0d 4a       	mov	r10,	r13	;
    491c:	b0 12 0a 54 	call	#21514		;#0x540a
    4920:	0a 4c       	mov	r12,	r10	;
    4922:	0c 48       	mov	r8,	r12	;
    4924:	0d 48       	mov	r8,	r13	;
    4926:	b0 12 0a 54 	call	#21514		;#0x540a
    492a:	0a 5c       	add	r12,	r10	;
    492c:	0c 49       	mov	r9,	r12	;
    492e:	0d 49       	mov	r9,	r13	;
    4930:	b0 12 0a 54 	call	#21514		;#0x540a
    4934:	0a 5c       	add	r12,	r10	;
    4936:	08 46       	mov	r6,	r8	;
    4938:	09 43       	clr	r9		;
    493a:	3f 40 ff 3f 	mov	#16383,	r15	;#0x3fff
    493e:	0f 96       	cmp	r6,	r15	;
    4940:	1b 29       	jnc	$+568    	;abs 0x4b78
    4942:	45 43       	clr.b	r5		;
    4944:	47 43       	clr.b	r7		;
    4946:	04 45       	mov	r5,	r4	;
    4948:	34 d0 40 00 	bis	#64,	r4	;#0x0040
    494c:	0c 44       	mov	r4,	r12	;
    494e:	0d 47       	mov	r7,	r13	;
    4950:	0e 44       	mov	r4,	r14	;
    4952:	0f 47       	mov	r7,	r15	;
    4954:	b0 12 1e 54 	call	#21534		;#0x541e
    4958:	0d 93       	cmp	#0,	r13	;r3 As==00
    495a:	0a 21       	jnz	$+534    	;abs 0x4b70
    495c:	09 93       	cmp	#0,	r9	;r3 As==00
    495e:	06 25       	jz	$+526    	;abs 0x4b6c
    4960:	05 44       	mov	r4,	r5	;
    4962:	35 d0 20 00 	bis	#32,	r5	;#0x0020
    4966:	0c 45       	mov	r5,	r12	;
    4968:	0d 47       	mov	r7,	r13	;
    496a:	0e 45       	mov	r5,	r14	;
    496c:	0f 47       	mov	r7,	r15	;
    496e:	b0 12 1e 54 	call	#21534		;#0x541e
    4972:	0d 93       	cmp	#0,	r13	;r3 As==00
    4974:	f7 20       	jnz	$+496    	;abs 0x4b64
    4976:	09 93       	cmp	#0,	r9	;r3 As==00
    4978:	f3 24       	jz	$+488    	;abs 0x4b60
    497a:	04 45       	mov	r5,	r4	;
    497c:	34 d0 10 00 	bis	#16,	r4	;#0x0010
    4980:	0c 44       	mov	r4,	r12	;
    4982:	0d 47       	mov	r7,	r13	;
    4984:	0e 44       	mov	r4,	r14	;
    4986:	0f 47       	mov	r7,	r15	;
    4988:	b0 12 1e 54 	call	#21534		;#0x541e
    498c:	0d 93       	cmp	#0,	r13	;r3 As==00
    498e:	e4 20       	jnz	$+458    	;abs 0x4b58
    4990:	09 93       	cmp	#0,	r9	;r3 As==00
    4992:	e0 24       	jz	$+450    	;abs 0x4b54
    4994:	05 44       	mov	r4,	r5	;
    4996:	35 d2       	bis	#8,	r5	;r2 As==11
    4998:	0c 45       	mov	r5,	r12	;
    499a:	0d 47       	mov	r7,	r13	;
    499c:	0e 45       	mov	r5,	r14	;
    499e:	0f 47       	mov	r7,	r15	;
    49a0:	b0 12 1e 54 	call	#21534		;#0x541e
    49a4:	0d 93       	cmp	#0,	r13	;r3 As==00
    49a6:	d3 20       	jnz	$+424    	;abs 0x4b4e
    49a8:	09 93       	cmp	#0,	r9	;r3 As==00
    49aa:	cf 24       	jz	$+416    	;abs 0x4b4a
    49ac:	04 45       	mov	r5,	r4	;
    49ae:	24 d2       	bis	#4,	r4	;r2 As==10
    49b0:	0c 44       	mov	r4,	r12	;
    49b2:	0d 47       	mov	r7,	r13	;
    49b4:	0e 44       	mov	r4,	r14	;
    49b6:	0f 47       	mov	r7,	r15	;
    49b8:	b0 12 1e 54 	call	#21534		;#0x541e
    49bc:	0d 93       	cmp	#0,	r13	;r3 As==00
    49be:	c2 20       	jnz	$+390    	;abs 0x4b44
    49c0:	09 93       	cmp	#0,	r9	;r3 As==00
    49c2:	be 24       	jz	$+382    	;abs 0x4b40
    49c4:	05 44       	mov	r4,	r5	;
    49c6:	25 d3       	bis	#2,	r5	;r3 As==10
    49c8:	0c 45       	mov	r5,	r12	;
    49ca:	0d 47       	mov	r7,	r13	;
    49cc:	0e 45       	mov	r5,	r14	;
    49ce:	0f 47       	mov	r7,	r15	;
    49d0:	b0 12 1e 54 	call	#21534		;#0x541e
    49d4:	0d 93       	cmp	#0,	r13	;r3 As==00
    49d6:	b1 20       	jnz	$+356    	;abs 0x4b3a
    49d8:	09 93       	cmp	#0,	r9	;r3 As==00
    49da:	ad 24       	jz	$+348    	;abs 0x4b36
    49dc:	04 45       	mov	r5,	r4	;
    49de:	14 d3       	bis	#1,	r4	;r3 As==01
    49e0:	0c 44       	mov	r4,	r12	;
    49e2:	0d 47       	mov	r7,	r13	;
    49e4:	0e 44       	mov	r4,	r14	;
    49e6:	0f 47       	mov	r7,	r15	;
    49e8:	b0 12 1e 54 	call	#21534		;#0x541e
    49ec:	0d 93       	cmp	#0,	r13	;r3 As==00
    49ee:	a0 20       	jnz	$+322    	;abs 0x4b30
    49f0:	09 93       	cmp	#0,	r9	;r3 As==00
    49f2:	9c 24       	jz	$+314    	;abs 0x4b2c
    49f4:	17 41 16 00 	mov	22(r1),	r7	;0x00016
    49f8:	87 44 00 00 	mov	r4,	0(r7)	;
    49fc:	08 4a       	mov	r10,	r8	;
    49fe:	09 43       	clr	r9		;
    4a00:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    4a04:	0c 9a       	cmp	r10,	r12	;
    4a06:	8e 28       	jnc	$+286    	;abs 0x4b24
    4a08:	46 43       	clr.b	r6		;
    4a0a:	47 43       	clr.b	r7		;
    4a0c:	05 46       	mov	r6,	r5	;
    4a0e:	35 d0 40 00 	bis	#64,	r5	;#0x0040
    4a12:	0c 45       	mov	r5,	r12	;
    4a14:	0d 47       	mov	r7,	r13	;
    4a16:	0e 45       	mov	r5,	r14	;
    4a18:	0f 47       	mov	r7,	r15	;
    4a1a:	b0 12 1e 54 	call	#21534		;#0x541e
    4a1e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a20:	7d 20       	jnz	$+252    	;abs 0x4b1c
    4a22:	09 93       	cmp	#0,	r9	;r3 As==00
    4a24:	79 24       	jz	$+244    	;abs 0x4b18
    4a26:	06 45       	mov	r5,	r6	;
    4a28:	36 d0 20 00 	bis	#32,	r6	;#0x0020
    4a2c:	0c 46       	mov	r6,	r12	;
    4a2e:	0d 47       	mov	r7,	r13	;
    4a30:	0e 46       	mov	r6,	r14	;
    4a32:	0f 47       	mov	r7,	r15	;
    4a34:	b0 12 1e 54 	call	#21534		;#0x541e
    4a38:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a3a:	6a 20       	jnz	$+214    	;abs 0x4b10
    4a3c:	09 93       	cmp	#0,	r9	;r3 As==00
    4a3e:	66 24       	jz	$+206    	;abs 0x4b0c
    4a40:	05 46       	mov	r6,	r5	;
    4a42:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4a46:	0c 45       	mov	r5,	r12	;
    4a48:	0d 47       	mov	r7,	r13	;
    4a4a:	0e 45       	mov	r5,	r14	;
    4a4c:	0f 47       	mov	r7,	r15	;
    4a4e:	b0 12 1e 54 	call	#21534		;#0x541e
    4a52:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a54:	57 20       	jnz	$+176    	;abs 0x4b04
    4a56:	09 93       	cmp	#0,	r9	;r3 As==00
    4a58:	53 24       	jz	$+168    	;abs 0x4b00
    4a5a:	06 45       	mov	r5,	r6	;
    4a5c:	36 d2       	bis	#8,	r6	;r2 As==11
    4a5e:	0c 46       	mov	r6,	r12	;
    4a60:	0d 47       	mov	r7,	r13	;
    4a62:	0e 46       	mov	r6,	r14	;
    4a64:	0f 47       	mov	r7,	r15	;
    4a66:	b0 12 1e 54 	call	#21534		;#0x541e
    4a6a:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a6c:	46 20       	jnz	$+142    	;abs 0x4afa
    4a6e:	09 93       	cmp	#0,	r9	;r3 As==00
    4a70:	42 24       	jz	$+134    	;abs 0x4af6
    4a72:	05 46       	mov	r6,	r5	;
    4a74:	25 d2       	bis	#4,	r5	;r2 As==10
    4a76:	0c 45       	mov	r5,	r12	;
    4a78:	0d 47       	mov	r7,	r13	;
    4a7a:	0e 45       	mov	r5,	r14	;
    4a7c:	0f 47       	mov	r7,	r15	;
    4a7e:	b0 12 1e 54 	call	#21534		;#0x541e
    4a82:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a84:	35 20       	jnz	$+108    	;abs 0x4af0
    4a86:	09 93       	cmp	#0,	r9	;r3 As==00
    4a88:	31 24       	jz	$+100    	;abs 0x4aec
    4a8a:	06 45       	mov	r5,	r6	;
    4a8c:	26 d3       	bis	#2,	r6	;r3 As==10
    4a8e:	0c 46       	mov	r6,	r12	;
    4a90:	0d 47       	mov	r7,	r13	;
    4a92:	0e 46       	mov	r6,	r14	;
    4a94:	0f 47       	mov	r7,	r15	;
    4a96:	b0 12 1e 54 	call	#21534		;#0x541e
    4a9a:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a9c:	24 20       	jnz	$+74     	;abs 0x4ae6
    4a9e:	09 93       	cmp	#0,	r9	;r3 As==00
    4aa0:	20 24       	jz	$+66     	;abs 0x4ae2
    4aa2:	05 46       	mov	r6,	r5	;
    4aa4:	15 d3       	bis	#1,	r5	;r3 As==01
    4aa6:	0c 45       	mov	r5,	r12	;
    4aa8:	0d 47       	mov	r7,	r13	;
    4aaa:	0e 45       	mov	r5,	r14	;
    4aac:	0f 47       	mov	r7,	r15	;
    4aae:	b0 12 1e 54 	call	#21534		;#0x541e
    4ab2:	0d 93       	cmp	#0,	r13	;r3 As==00
    4ab4:	0c 20       	jnz	$+26     	;abs 0x4ace
    4ab6:	09 93       	cmp	#0,	r9	;r3 As==00
    4ab8:	08 24       	jz	$+18     	;abs 0x4aca
    4aba:	17 41 16 00 	mov	22(r1),	r7	;0x00016
    4abe:	87 45 02 00 	mov	r5,	2(r7)	;
    4ac2:	31 50 18 00 	add	#24,	r1	;#0x0018
    4ac6:	64 17       	popm	#7,	r10	;16-bit words
    4ac8:	30 41       	ret			
    4aca:	0a 9c       	cmp	r12,	r10	;
    4acc:	f6 2f       	jc	$-18     	;abs 0x4aba
    4ace:	05 46       	mov	r6,	r5	;
    4ad0:	15 c3       	bic	#1,	r5	;r3 As==01
    4ad2:	17 41 16 00 	mov	22(r1),	r7	;0x00016
    4ad6:	87 45 02 00 	mov	r5,	2(r7)	;
    4ada:	31 50 18 00 	add	#24,	r1	;#0x0018
    4ade:	64 17       	popm	#7,	r10	;16-bit words
    4ae0:	30 41       	ret			
    4ae2:	0a 9c       	cmp	r12,	r10	;
    4ae4:	de 2f       	jc	$-66     	;abs 0x4aa2
    4ae6:	06 45       	mov	r5,	r6	;
    4ae8:	26 c3       	bic	#2,	r6	;r3 As==10
    4aea:	db 3f       	jmp	$-72     	;abs 0x4aa2
    4aec:	0a 9c       	cmp	r12,	r10	;
    4aee:	cd 2f       	jc	$-100    	;abs 0x4a8a
    4af0:	05 46       	mov	r6,	r5	;
    4af2:	25 c2       	bic	#4,	r5	;r2 As==10
    4af4:	ca 3f       	jmp	$-106    	;abs 0x4a8a
    4af6:	0a 9c       	cmp	r12,	r10	;
    4af8:	bc 2f       	jc	$-134    	;abs 0x4a72
    4afa:	06 45       	mov	r5,	r6	;
    4afc:	36 c2       	bic	#8,	r6	;r2 As==11
    4afe:	b9 3f       	jmp	$-140    	;abs 0x4a72
    4b00:	0a 9c       	cmp	r12,	r10	;
    4b02:	ab 2f       	jc	$-168    	;abs 0x4a5a
    4b04:	05 46       	mov	r6,	r5	;
    4b06:	35 f0 ef ff 	and	#-17,	r5	;#0xffef
    4b0a:	a7 3f       	jmp	$-176    	;abs 0x4a5a
    4b0c:	0a 9c       	cmp	r12,	r10	;
    4b0e:	98 2f       	jc	$-206    	;abs 0x4a40
    4b10:	06 45       	mov	r5,	r6	;
    4b12:	36 f0 df ff 	and	#-33,	r6	;#0xffdf
    4b16:	94 3f       	jmp	$-214    	;abs 0x4a40
    4b18:	0a 9c       	cmp	r12,	r10	;
    4b1a:	85 2f       	jc	$-244    	;abs 0x4a26
    4b1c:	05 46       	mov	r6,	r5	;
    4b1e:	35 f0 bf ff 	and	#-65,	r5	;#0xffbf
    4b22:	81 3f       	jmp	$-252    	;abs 0x4a26
    4b24:	76 40 80 00 	mov.b	#128,	r6	;#0x0080
    4b28:	47 43       	clr.b	r7		;
    4b2a:	70 3f       	jmp	$-286    	;abs 0x4a0c
    4b2c:	06 9c       	cmp	r12,	r6	;
    4b2e:	62 2f       	jc	$-314    	;abs 0x49f4
    4b30:	04 45       	mov	r5,	r4	;
    4b32:	14 c3       	bic	#1,	r4	;r3 As==01
    4b34:	5f 3f       	jmp	$-320    	;abs 0x49f4
    4b36:	06 9c       	cmp	r12,	r6	;
    4b38:	51 2f       	jc	$-348    	;abs 0x49dc
    4b3a:	05 44       	mov	r4,	r5	;
    4b3c:	25 c3       	bic	#2,	r5	;r3 As==10
    4b3e:	4e 3f       	jmp	$-354    	;abs 0x49dc
    4b40:	06 9c       	cmp	r12,	r6	;
    4b42:	40 2f       	jc	$-382    	;abs 0x49c4
    4b44:	04 45       	mov	r5,	r4	;
    4b46:	24 c2       	bic	#4,	r4	;r2 As==10
    4b48:	3d 3f       	jmp	$-388    	;abs 0x49c4
    4b4a:	06 9c       	cmp	r12,	r6	;
    4b4c:	2f 2f       	jc	$-416    	;abs 0x49ac
    4b4e:	05 44       	mov	r4,	r5	;
    4b50:	35 c2       	bic	#8,	r5	;r2 As==11
    4b52:	2c 3f       	jmp	$-422    	;abs 0x49ac
    4b54:	06 9c       	cmp	r12,	r6	;
    4b56:	1e 2f       	jc	$-450    	;abs 0x4994
    4b58:	04 45       	mov	r5,	r4	;
    4b5a:	34 f0 ef ff 	and	#-17,	r4	;#0xffef
    4b5e:	1a 3f       	jmp	$-458    	;abs 0x4994
    4b60:	06 9c       	cmp	r12,	r6	;
    4b62:	0b 2f       	jc	$-488    	;abs 0x497a
    4b64:	05 44       	mov	r4,	r5	;
    4b66:	35 f0 df ff 	and	#-33,	r5	;#0xffdf
    4b6a:	07 3f       	jmp	$-496    	;abs 0x497a
    4b6c:	06 9c       	cmp	r12,	r6	;
    4b6e:	f8 2e       	jc	$-526    	;abs 0x4960
    4b70:	04 45       	mov	r5,	r4	;
    4b72:	34 f0 bf ff 	and	#-65,	r4	;#0xffbf
    4b76:	f4 3e       	jmp	$-534    	;abs 0x4960
    4b78:	75 40 80 00 	mov.b	#128,	r5	;#0x0080
    4b7c:	47 43       	clr.b	r7		;
    4b7e:	e3 3e       	jmp	$-568    	;abs 0x4946

00004b80 <classify>:
    4b80:	5a 15       	pushm	#6,	r10	;16-bit words
    4b82:	25 4c       	mov	@r12,	r5	;
    4b84:	16 4c 02 00 	mov	2(r12),	r6	;
    4b88:	4a 43       	clr.b	r10		;
    4b8a:	48 43       	clr.b	r8		;
    4b8c:	47 43       	clr.b	r7		;
    4b8e:	0c 4a       	mov	r10,	r12	;
    4b90:	5c 06       	rlam	#2,	r12	;
    4b92:	0c 5d       	add	r13,	r12	;
    4b94:	2b 4c       	mov	@r12,	r11	;
    4b96:	1e 4c 02 00 	mov	2(r12),	r14	;
    4b9a:	0e 86       	sub	r6,	r14	;
    4b9c:	0f 4e       	mov	r14,	r15	;
    4b9e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4ba2:	0e ef       	xor	r15,	r14	;
    4ba4:	0e 8f       	sub	r15,	r14	;
    4ba6:	1f 4c 40 00 	mov	64(r12),r15	;0x00040
    4baa:	1c 4c 42 00 	mov	66(r12),r12	;0x00042
    4bae:	0c 86       	sub	r6,	r12	;
    4bb0:	09 4c       	mov	r12,	r9	;
    4bb2:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    4bb6:	0c e9       	xor	r9,	r12	;
    4bb8:	0c 89       	sub	r9,	r12	;
    4bba:	0b 85       	sub	r5,	r11	;
    4bbc:	09 4b       	mov	r11,	r9	;
    4bbe:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    4bc2:	0b e9       	xor	r9,	r11	;
    4bc4:	0b 89       	sub	r9,	r11	;
    4bc6:	0f 85       	sub	r5,	r15	;
    4bc8:	09 4f       	mov	r15,	r9	;
    4bca:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    4bce:	0f e9       	xor	r9,	r15	;
    4bd0:	0f 89       	sub	r9,	r15	;
    4bd2:	0f 9b       	cmp	r11,	r15	;
    4bd4:	10 34       	jge	$+34     	;abs 0x4bf6
    4bd6:	17 53       	inc	r7		;
    4bd8:	0c 9e       	cmp	r14,	r12	;
    4bda:	0b 34       	jge	$+24     	;abs 0x4bf2
    4bdc:	17 53       	inc	r7		;
    4bde:	1a 53       	inc	r10		;
    4be0:	3a 90 10 00 	cmp	#16,	r10	;#0x0010
    4be4:	d4 23       	jnz	$-86     	;abs 0x4b8e
    4be6:	5c 43       	mov.b	#1,	r12	;r3 As==01
    4be8:	08 97       	cmp	r7,	r8	;
    4bea:	01 38       	jl	$+4      	;abs 0x4bee
    4bec:	4c 43       	clr.b	r12		;
    4bee:	55 17       	popm	#6,	r10	;16-bit words
    4bf0:	30 41       	ret			
    4bf2:	18 53       	inc	r8		;
    4bf4:	f4 3f       	jmp	$-22     	;abs 0x4bde
    4bf6:	18 53       	inc	r8		;
    4bf8:	ef 3f       	jmp	$-32     	;abs 0x4bd8

00004bfa <warmup_sensor>:
    4bfa:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    4bfe:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4c02:	0d 4c       	mov	r12,	r13	;
    4c04:	5d f3       	and.b	#1,	r13	;r3 As==01
    4c06:	5c 03       	rrum	#1,	r12	;
    4c08:	0d 93       	cmp	#0,	r13	;r3 As==00
    4c0a:	02 24       	jz	$+6      	;abs 0x4c10
    4c0c:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4c10:	0d 4c       	mov	r12,	r13	;
    4c12:	5d 03       	rrum	#1,	r13	;
    4c14:	1c b3       	bit	#1,	r12	;r3 As==01
    4c16:	02 24       	jz	$+6      	;abs 0x4c1c
    4c18:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4c1c:	0c 4d       	mov	r13,	r12	;
    4c1e:	5c 03       	rrum	#1,	r12	;
    4c20:	1d b3       	bit	#1,	r13	;r3 As==01
    4c22:	02 24       	jz	$+6      	;abs 0x4c28
    4c24:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4c28:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4c2c:	0d 4c       	mov	r12,	r13	;
    4c2e:	5d f3       	and.b	#1,	r13	;r3 As==01
    4c30:	5c 03       	rrum	#1,	r12	;
    4c32:	0d 93       	cmp	#0,	r13	;r3 As==00
    4c34:	02 24       	jz	$+6      	;abs 0x4c3a
    4c36:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4c3a:	0d 4c       	mov	r12,	r13	;
    4c3c:	5d 03       	rrum	#1,	r13	;
    4c3e:	1c b3       	bit	#1,	r12	;r3 As==01
    4c40:	02 24       	jz	$+6      	;abs 0x4c46
    4c42:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4c46:	0c 4d       	mov	r13,	r12	;
    4c48:	5c 03       	rrum	#1,	r12	;
    4c4a:	1d b3       	bit	#1,	r13	;r3 As==01
    4c4c:	02 24       	jz	$+6      	;abs 0x4c52
    4c4e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4c52:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4c56:	0d 4c       	mov	r12,	r13	;
    4c58:	5d f3       	and.b	#1,	r13	;r3 As==01
    4c5a:	5c 03       	rrum	#1,	r12	;
    4c5c:	0d 93       	cmp	#0,	r13	;r3 As==00
    4c5e:	02 24       	jz	$+6      	;abs 0x4c64
    4c60:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4c64:	0d 4c       	mov	r12,	r13	;
    4c66:	5d 03       	rrum	#1,	r13	;
    4c68:	1c b3       	bit	#1,	r12	;r3 As==01
    4c6a:	02 24       	jz	$+6      	;abs 0x4c70
    4c6c:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4c70:	0c 4d       	mov	r13,	r12	;
    4c72:	5c 03       	rrum	#1,	r12	;
    4c74:	1d b3       	bit	#1,	r13	;r3 As==01
    4c76:	02 24       	jz	$+6      	;abs 0x4c7c
    4c78:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4c7c:	82 4c 82 1c 	mov	r12,	&0x1c82	;
    4c80:	30 41       	ret			

00004c82 <train>:
    4c82:	6a 15       	pushm	#7,	r10	;16-bit words
    4c84:	31 80 16 00 	sub	#22,	r1	;#0x0016
    4c88:	0a 4c       	mov	r12,	r10	;
    4c8a:	0c 41       	mov	r1,	r12	;
    4c8c:	3c 50 0c 00 	add	#12,	r12	;#0x000c
    4c90:	b0 12 94 42 	call	#17044		;#0x4294
    4c94:	0c 41       	mov	r1,	r12	;
    4c96:	3c 50 0c 00 	add	#12,	r12	;#0x000c
    4c9a:	b0 12 94 42 	call	#17044		;#0x4294
    4c9e:	0c 41       	mov	r1,	r12	;
    4ca0:	3c 50 0c 00 	add	#12,	r12	;#0x000c
    4ca4:	b0 12 94 42 	call	#17044		;#0x4294
    4ca8:	1f 42 82 1c 	mov	&0x1c82,r15	;0x1c82
    4cac:	81 4a 04 00 	mov	r10,	4(r1)	;
    4cb0:	0c 4a       	mov	r10,	r12	;
    4cb2:	3c 50 40 00 	add	#64,	r12	;#0x0040
    4cb6:	81 4c 06 00 	mov	r12,	6(r1)	;
    4cba:	39 3d       	jmp	$+628    	;abs 0x4f2e
    4cbc:	0c 93       	cmp	#0,	r12	;r3 As==00
    4cbe:	02 24       	jz	$+6      	;abs 0x4cc4
    4cc0:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4cc4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4cc8:	0c 4a       	mov	r10,	r12	;
    4cca:	b0 12 3a 53 	call	#21306		;#0x533a
    4cce:	45 4c       	mov.b	r12,	r5	;
    4cd0:	75 50 e2 ff 	add.b	#-30,	r5	;#0xffe2
    4cd4:	85 11       	sxt	r5		;
    4cd6:	09 4a       	mov	r10,	r9	;
    4cd8:	59 03       	rrum	#1,	r9	;
    4cda:	1a b3       	bit	#1,	r10	;r3 As==01
    4cdc:	02 24       	jz	$+6      	;abs 0x4ce2
    4cde:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4ce2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4ce6:	0c 49       	mov	r9,	r12	;
    4ce8:	b0 12 3a 53 	call	#21306		;#0x533a
    4cec:	47 4c       	mov.b	r12,	r7	;
    4cee:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4cf2:	87 11       	sxt	r7		;
    4cf4:	0a 49       	mov	r9,	r10	;
    4cf6:	5a 03       	rrum	#1,	r10	;
    4cf8:	19 b3       	bit	#1,	r9	;r3 As==01
    4cfa:	02 24       	jz	$+6      	;abs 0x4d00
    4cfc:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4d00:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4d04:	0c 4a       	mov	r10,	r12	;
    4d06:	b0 12 3a 53 	call	#21306		;#0x533a
    4d0a:	46 4c       	mov.b	r12,	r6	;
    4d0c:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    4d10:	86 11       	sxt	r6		;
    4d12:	4d 45       	mov.b	r5,	r13	;
    4d14:	0c 47       	mov	r7,	r12	;
    4d16:	47 18 0c 5c 	rpt #8 { rlax.w	r12		;
    4d1a:	0d dc       	bis	r12,	r13	;
    4d1c:	81 4d 0c 00 	mov	r13,	12(r1)	; 0x000c
    4d20:	c1 46 0e 00 	mov.b	r6,	14(r1)	; 0x000e
    4d24:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4d28:	0c 4a       	mov	r10,	r12	;
    4d2a:	5c f3       	and.b	#1,	r12	;r3 As==01
    4d2c:	5a 03       	rrum	#1,	r10	;
    4d2e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4d30:	29 25       	jz	$+596    	;abs 0x4f84
    4d32:	0c 93       	cmp	#0,	r12	;r3 As==00
    4d34:	02 24       	jz	$+6      	;abs 0x4d3a
    4d36:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4d3a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4d3e:	0c 4a       	mov	r10,	r12	;
    4d40:	b0 12 3a 53 	call	#21306		;#0x533a
    4d44:	49 4c       	mov.b	r12,	r9	;
    4d46:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    4d4a:	89 11       	sxt	r9		;
    4d4c:	0e 4a       	mov	r10,	r14	;
    4d4e:	5e 03       	rrum	#1,	r14	;
    4d50:	1a b3       	bit	#1,	r10	;r3 As==01
    4d52:	02 24       	jz	$+6      	;abs 0x4d58
    4d54:	3e e0 00 b4 	xor	#-19456,r14	;#0xb400
    4d58:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4d5c:	0c 4e       	mov	r14,	r12	;
    4d5e:	81 4e 00 00 	mov	r14,	0(r1)	;
    4d62:	b0 12 3a 53 	call	#21306		;#0x533a
    4d66:	48 4c       	mov.b	r12,	r8	;
    4d68:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    4d6c:	88 11       	sxt	r8		;
    4d6e:	2e 41       	mov	@r1,	r14	;
    4d70:	04 4e       	mov	r14,	r4	;
    4d72:	54 03       	rrum	#1,	r4	;
    4d74:	1e b3       	bit	#1,	r14	;r3 As==01
    4d76:	02 24       	jz	$+6      	;abs 0x4d7c
    4d78:	34 e0 00 b4 	xor	#-19456,r4	;#0xb400
    4d7c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4d80:	0c 44       	mov	r4,	r12	;
    4d82:	b0 12 3a 53 	call	#21306		;#0x533a
    4d86:	4e 4c       	mov.b	r12,	r14	;
    4d88:	7e 50 e2 ff 	add.b	#-30,	r14	;#0xffe2
    4d8c:	8e 11       	sxt	r14		;
    4d8e:	c1 49 0f 00 	mov.b	r9,	15(r1)	; 0x000f
    4d92:	c1 48 10 00 	mov.b	r8,	16(r1)	; 0x0010
    4d96:	c1 4e 11 00 	mov.b	r14,	17(r1)	; 0x0011
    4d9a:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4d9e:	0c 44       	mov	r4,	r12	;
    4da0:	5c f3       	and.b	#1,	r12	;r3 As==01
    4da2:	54 03       	rrum	#1,	r4	;
    4da4:	0d 93       	cmp	#0,	r13	;r3 As==00
    4da6:	1d 25       	jz	$+572    	;abs 0x4fe2
    4da8:	0c 93       	cmp	#0,	r12	;r3 As==00
    4daa:	02 24       	jz	$+6      	;abs 0x4db0
    4dac:	34 e0 00 b4 	xor	#-19456,r4	;#0xb400
    4db0:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4db4:	0c 44       	mov	r4,	r12	;
    4db6:	81 4e 00 00 	mov	r14,	0(r1)	;
    4dba:	b0 12 3a 53 	call	#21306		;#0x533a
    4dbe:	4a 4c       	mov.b	r12,	r10	;
    4dc0:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    4dc4:	8a 11       	sxt	r10		;
    4dc6:	0b 44       	mov	r4,	r11	;
    4dc8:	5b 03       	rrum	#1,	r11	;
    4dca:	2e 41       	mov	@r1,	r14	;
    4dcc:	14 b3       	bit	#1,	r4	;r3 As==01
    4dce:	02 24       	jz	$+6      	;abs 0x4dd4
    4dd0:	3b e0 00 b4 	xor	#-19456,r11	;#0xb400
    4dd4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4dd8:	0c 4b       	mov	r11,	r12	;
    4dda:	81 4b 02 00 	mov	r11,	2(r1)	;
    4dde:	81 4e 00 00 	mov	r14,	0(r1)	;
    4de2:	b0 12 3a 53 	call	#21306		;#0x533a
    4de6:	44 4c       	mov.b	r12,	r4	;
    4de8:	74 50 e2 ff 	add.b	#-30,	r4	;#0xffe2
    4dec:	84 11       	sxt	r4		;
    4dee:	1b 41 02 00 	mov	2(r1),	r11	;
    4df2:	0f 4b       	mov	r11,	r15	;
    4df4:	5f 03       	rrum	#1,	r15	;
    4df6:	2e 41       	mov	@r1,	r14	;
    4df8:	1b b3       	bit	#1,	r11	;r3 As==01
    4dfa:	02 24       	jz	$+6      	;abs 0x4e00
    4dfc:	3f e0 00 b4 	xor	#-19456,r15	;#0xb400
    4e00:	82 4f 82 1c 	mov	r15,	&0x1c82	;
    4e04:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4e08:	0c 4f       	mov	r15,	r12	;
    4e0a:	81 4e 00 00 	mov	r14,	0(r1)	;
    4e0e:	81 4f 02 00 	mov	r15,	2(r1)	;
    4e12:	b0 12 3a 53 	call	#21306		;#0x533a
    4e16:	4d 4c       	mov.b	r12,	r13	;
    4e18:	7d 50 e2 ff 	add.b	#-30,	r13	;#0xffe2
    4e1c:	8d 11       	sxt	r13		;
    4e1e:	2e 41       	mov	@r1,	r14	;
    4e20:	1f 41 02 00 	mov	2(r1),	r15	;
    4e24:	4b 4a       	mov.b	r10,	r11	;
    4e26:	0c 44       	mov	r4,	r12	;
    4e28:	47 18 0c 5c 	rpt #8 { rlax.w	r12		;
    4e2c:	0b dc       	bis	r12,	r11	;
    4e2e:	81 4b 12 00 	mov	r11,	18(r1)	; 0x0012
    4e32:	c1 4d 14 00 	mov.b	r13,	20(r1)	; 0x0014
    4e36:	0b 45       	mov	r5,	r11	;
    4e38:	46 18 0b 11 	rpt #7 { rrax.w	r11		;
    4e3c:	45 eb       	xor.b	r11,	r5	;
    4e3e:	45 8b       	sub.b	r11,	r5	;
    4e40:	7c 40 09 00 	mov.b	#9,	r12	;
    4e44:	4c 95       	cmp.b	r5,	r12	;
    4e46:	02 28       	jnc	$+6      	;abs 0x4e4c
    4e48:	c1 43 0c 00 	mov.b	#0,	12(r1)	;r3 As==00, 0x000c
    4e4c:	05 47       	mov	r7,	r5	;
    4e4e:	46 18 05 11 	rpt #7 { rrax.w	r5		;
    4e52:	47 e5       	xor.b	r5,	r7	;
    4e54:	47 85       	sub.b	r5,	r7	;
    4e56:	7c 40 09 00 	mov.b	#9,	r12	;
    4e5a:	4c 97       	cmp.b	r7,	r12	;
    4e5c:	02 28       	jnc	$+6      	;abs 0x4e62
    4e5e:	c1 43 0d 00 	mov.b	#0,	13(r1)	;r3 As==00, 0x000d
    4e62:	0c 46       	mov	r6,	r12	;
    4e64:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4e68:	46 ec       	xor.b	r12,	r6	;
    4e6a:	46 8c       	sub.b	r12,	r6	;
    4e6c:	7c 40 09 00 	mov.b	#9,	r12	;
    4e70:	4c 96       	cmp.b	r6,	r12	;
    4e72:	02 28       	jnc	$+6      	;abs 0x4e78
    4e74:	c1 43 0e 00 	mov.b	#0,	14(r1)	;r3 As==00, 0x000e
    4e78:	0c 49       	mov	r9,	r12	;
    4e7a:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4e7e:	49 ec       	xor.b	r12,	r9	;
    4e80:	49 8c       	sub.b	r12,	r9	;
    4e82:	7c 40 09 00 	mov.b	#9,	r12	;
    4e86:	4c 99       	cmp.b	r9,	r12	;
    4e88:	02 28       	jnc	$+6      	;abs 0x4e8e
    4e8a:	c1 43 0f 00 	mov.b	#0,	15(r1)	;r3 As==00, 0x000f
    4e8e:	0c 48       	mov	r8,	r12	;
    4e90:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4e94:	48 ec       	xor.b	r12,	r8	;
    4e96:	48 8c       	sub.b	r12,	r8	;
    4e98:	7c 40 09 00 	mov.b	#9,	r12	;
    4e9c:	4c 98       	cmp.b	r8,	r12	;
    4e9e:	02 28       	jnc	$+6      	;abs 0x4ea4
    4ea0:	c1 43 10 00 	mov.b	#0,	16(r1)	;r3 As==00, 0x0010
    4ea4:	0c 4e       	mov	r14,	r12	;
    4ea6:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4eaa:	4e ec       	xor.b	r12,	r14	;
    4eac:	4e 8c       	sub.b	r12,	r14	;
    4eae:	7c 40 09 00 	mov.b	#9,	r12	;
    4eb2:	4c 9e       	cmp.b	r14,	r12	;
    4eb4:	02 28       	jnc	$+6      	;abs 0x4eba
    4eb6:	c1 43 11 00 	mov.b	#0,	17(r1)	;r3 As==00, 0x0011
    4eba:	0c 4a       	mov	r10,	r12	;
    4ebc:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4ec0:	4a ec       	xor.b	r12,	r10	;
    4ec2:	4a 8c       	sub.b	r12,	r10	;
    4ec4:	7c 40 09 00 	mov.b	#9,	r12	;
    4ec8:	4c 9a       	cmp.b	r10,	r12	;
    4eca:	02 28       	jnc	$+6      	;abs 0x4ed0
    4ecc:	c1 43 12 00 	mov.b	#0,	18(r1)	;r3 As==00, 0x0012
    4ed0:	0c 44       	mov	r4,	r12	;
    4ed2:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4ed6:	44 ec       	xor.b	r12,	r4	;
    4ed8:	44 8c       	sub.b	r12,	r4	;
    4eda:	7c 40 09 00 	mov.b	#9,	r12	;
    4ede:	4c 94       	cmp.b	r4,	r12	;
    4ee0:	02 28       	jnc	$+6      	;abs 0x4ee6
    4ee2:	c1 43 13 00 	mov.b	#0,	19(r1)	;r3 As==00, 0x0013
    4ee6:	0c 4d       	mov	r13,	r12	;
    4ee8:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    4eec:	4d ec       	xor.b	r12,	r13	;
    4eee:	4d 8c       	sub.b	r12,	r13	;
    4ef0:	7c 40 09 00 	mov.b	#9,	r12	;
    4ef4:	4c 9d       	cmp.b	r13,	r12	;
    4ef6:	02 28       	jnc	$+6      	;abs 0x4efc
    4ef8:	c1 43 14 00 	mov.b	#0,	20(r1)	;r3 As==00, 0x0014
    4efc:	0d 41       	mov	r1,	r13	;
    4efe:	3d 50 0c 00 	add	#12,	r13	;#0x000c
    4f02:	0c 41       	mov	r1,	r12	;
    4f04:	3c 52       	add	#8,	r12	;r2 As==11
    4f06:	81 4f 02 00 	mov	r15,	2(r1)	;
    4f0a:	b0 12 b8 46 	call	#18104		;#0x46b8
    4f0e:	1c 41 04 00 	mov	4(r1),	r12	;
    4f12:	9c 41 08 00 	mov	8(r1),	0(r12)	;
    4f16:	00 00 
    4f18:	9c 41 0a 00 	mov	10(r1),	2(r12)	;0x0000a
    4f1c:	02 00 
    4f1e:	2c 52       	add	#4,	r12	;r2 As==10
    4f20:	81 4c 04 00 	mov	r12,	4(r1)	;
    4f24:	1f 41 02 00 	mov	2(r1),	r15	;
    4f28:	1c 91 06 00 	cmp	6(r1),	r12	;
    4f2c:	7f 24       	jz	$+256    	;abs 0x502c
    4f2e:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4f32:	0c 4f       	mov	r15,	r12	;
    4f34:	5c f3       	and.b	#1,	r12	;r3 As==01
    4f36:	0a 4f       	mov	r15,	r10	;
    4f38:	5a 03       	rrum	#1,	r10	;
    4f3a:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f3c:	bf 22       	jnz	$-640    	;abs 0x4cbc
    4f3e:	0c 93       	cmp	#0,	r12	;r3 As==00
    4f40:	02 24       	jz	$+6      	;abs 0x4f46
    4f42:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4f46:	45 4a       	mov.b	r10,	r5	;
    4f48:	75 f0 03 00 	and.b	#3,	r5	;
    4f4c:	75 50 fe ff 	add.b	#-2,	r5	;#0xfffe
    4f50:	85 11       	sxt	r5		;
    4f52:	0d 4a       	mov	r10,	r13	;
    4f54:	5d 03       	rrum	#1,	r13	;
    4f56:	1a b3       	bit	#1,	r10	;r3 As==01
    4f58:	02 24       	jz	$+6      	;abs 0x4f5e
    4f5a:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4f5e:	47 4d       	mov.b	r13,	r7	;
    4f60:	77 f0 03 00 	and.b	#3,	r7	;
    4f64:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    4f68:	87 11       	sxt	r7		;
    4f6a:	0a 4d       	mov	r13,	r10	;
    4f6c:	5a 03       	rrum	#1,	r10	;
    4f6e:	1d b3       	bit	#1,	r13	;r3 As==01
    4f70:	02 24       	jz	$+6      	;abs 0x4f76
    4f72:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4f76:	46 4a       	mov.b	r10,	r6	;
    4f78:	76 f0 03 00 	and.b	#3,	r6	;
    4f7c:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    4f80:	86 11       	sxt	r6		;
    4f82:	c7 3e       	jmp	$-624    	;abs 0x4d12
    4f84:	0c 93       	cmp	#0,	r12	;r3 As==00
    4f86:	02 24       	jz	$+6      	;abs 0x4f8c
    4f88:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4f8c:	49 4a       	mov.b	r10,	r9	;
    4f8e:	79 f0 03 00 	and.b	#3,	r9	;
    4f92:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    4f96:	89 11       	sxt	r9		;
    4f98:	0d 4a       	mov	r10,	r13	;
    4f9a:	5d 03       	rrum	#1,	r13	;
    4f9c:	1a b3       	bit	#1,	r10	;r3 As==01
    4f9e:	02 24       	jz	$+6      	;abs 0x4fa4
    4fa0:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4fa4:	48 4d       	mov.b	r13,	r8	;
    4fa6:	78 f0 03 00 	and.b	#3,	r8	;
    4faa:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    4fae:	88 11       	sxt	r8		;
    4fb0:	04 4d       	mov	r13,	r4	;
    4fb2:	54 03       	rrum	#1,	r4	;
    4fb4:	1d b3       	bit	#1,	r13	;r3 As==01
    4fb6:	02 24       	jz	$+6      	;abs 0x4fbc
    4fb8:	34 e0 00 b4 	xor	#-19456,r4	;#0xb400
    4fbc:	4e 44       	mov.b	r4,	r14	;
    4fbe:	7e f0 03 00 	and.b	#3,	r14	;
    4fc2:	7e 50 fe ff 	add.b	#-2,	r14	;#0xfffe
    4fc6:	8e 11       	sxt	r14		;
    4fc8:	c1 49 0f 00 	mov.b	r9,	15(r1)	; 0x000f
    4fcc:	c1 48 10 00 	mov.b	r8,	16(r1)	; 0x0010
    4fd0:	c1 4e 11 00 	mov.b	r14,	17(r1)	; 0x0011
    4fd4:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4fd8:	0c 44       	mov	r4,	r12	;
    4fda:	5c f3       	and.b	#1,	r12	;r3 As==01
    4fdc:	54 03       	rrum	#1,	r4	;
    4fde:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fe0:	e3 22       	jnz	$-568    	;abs 0x4da8
    4fe2:	0c 93       	cmp	#0,	r12	;r3 As==00
    4fe4:	02 24       	jz	$+6      	;abs 0x4fea
    4fe6:	34 e0 00 b4 	xor	#-19456,r4	;#0xb400
    4fea:	4a 44       	mov.b	r4,	r10	;
    4fec:	7a f0 03 00 	and.b	#3,	r10	;
    4ff0:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    4ff4:	8a 11       	sxt	r10		;
    4ff6:	0d 44       	mov	r4,	r13	;
    4ff8:	5d 03       	rrum	#1,	r13	;
    4ffa:	14 b3       	bit	#1,	r4	;r3 As==01
    4ffc:	02 24       	jz	$+6      	;abs 0x5002
    4ffe:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5002:	44 4d       	mov.b	r13,	r4	;
    5004:	74 f0 03 00 	and.b	#3,	r4	;
    5008:	74 50 fe ff 	add.b	#-2,	r4	;#0xfffe
    500c:	84 11       	sxt	r4		;
    500e:	0f 4d       	mov	r13,	r15	;
    5010:	5f 03       	rrum	#1,	r15	;
    5012:	1d b3       	bit	#1,	r13	;r3 As==01
    5014:	02 24       	jz	$+6      	;abs 0x501a
    5016:	3f e0 00 b4 	xor	#-19456,r15	;#0xb400
    501a:	82 4f 82 1c 	mov	r15,	&0x1c82	;
    501e:	4d 4f       	mov.b	r15,	r13	;
    5020:	7d f0 03 00 	and.b	#3,	r13	;
    5024:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5028:	8d 11       	sxt	r13		;
    502a:	fc 3e       	jmp	$-518    	;abs 0x4e24
    502c:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    5030:	31 50 16 00 	add	#22,	r1	;#0x0016
    5034:	64 17       	popm	#7,	r10	;16-bit words
    5036:	30 41       	ret			

00005038 <recognize_loop>:
    5038:	6a 15       	pushm	#7,	r10	;16-bit words
    503a:	31 80 1a 00 	sub	#26,	r1	;#0x001a
    503e:	06 4c       	mov	r12,	r6	;
    5040:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5044:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    5048:	81 43 0e 00 	mov	#0,	14(r1)	;r3 As==00, 0x000e
    504c:	49 43       	clr.b	r9		;
    504e:	0c 41       	mov	r1,	r12	;
    5050:	2c 52       	add	#4,	r12	;r2 As==10
    5052:	81 4c 00 00 	mov	r12,	0(r1)	;
    5056:	0c 41       	mov	r1,	r12	;
    5058:	3c 50 03 00 	add	#3,	r12	;
    505c:	b0 12 94 42 	call	#17044		;#0x4294
    5060:	d1 41 03 00 	mov.b	3(r1),	17(r1)	; 0x0011
    5064:	11 00 
    5066:	2c 41       	mov	@r1,	r12	;
    5068:	e1 4c 12 00 	mov.b	@r12,	18(r1)	; 0x0012
    506c:	d1 41 05 00 	mov.b	5(r1),	19(r1)	; 0x0013
    5070:	13 00 
    5072:	0c 41       	mov	r1,	r12	;
    5074:	3c 50 03 00 	add	#3,	r12	;
    5078:	b0 12 94 42 	call	#17044		;#0x4294
    507c:	d1 41 03 00 	mov.b	3(r1),	20(r1)	; 0x0014
    5080:	14 00 
    5082:	0c 41       	mov	r1,	r12	;
    5084:	2c 52       	add	#4,	r12	;r2 As==10
    5086:	81 4c 00 00 	mov	r12,	0(r1)	;
    508a:	d1 41 04 00 	mov.b	4(r1),	21(r1)	; 0x0015
    508e:	15 00 
    5090:	d1 41 05 00 	mov.b	5(r1),	22(r1)	; 0x0016
    5094:	16 00 
    5096:	3c 53       	add	#-1,	r12	;r3 As==11
    5098:	b0 12 94 42 	call	#17044		;#0x4294
    509c:	d1 41 03 00 	mov.b	3(r1),	23(r1)	; 0x0017
    50a0:	17 00 
    50a2:	d1 41 04 00 	mov.b	4(r1),	24(r1)	; 0x0018
    50a6:	18 00 
    50a8:	d1 41 05 00 	mov.b	5(r1),	25(r1)	; 0x0019
    50ac:	19 00 
    50ae:	5c 41 11 00 	mov.b	17(r1),	r12	;0x00011
    50b2:	8c 11       	sxt	r12		;
    50b4:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    50b8:	5d 41 11 00 	mov.b	17(r1),	r13	;0x00011
    50bc:	4d ec       	xor.b	r12,	r13	;
    50be:	4d 8c       	sub.b	r12,	r13	;
    50c0:	7c 40 09 00 	mov.b	#9,	r12	;
    50c4:	4c 9d       	cmp.b	r13,	r12	;
    50c6:	02 28       	jnc	$+6      	;abs 0x50cc
    50c8:	c1 43 11 00 	mov.b	#0,	17(r1)	;r3 As==00, 0x0011
    50cc:	5c 41 12 00 	mov.b	18(r1),	r12	;0x00012
    50d0:	8c 11       	sxt	r12		;
    50d2:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    50d6:	5d 41 12 00 	mov.b	18(r1),	r13	;0x00012
    50da:	4d ec       	xor.b	r12,	r13	;
    50dc:	4d 8c       	sub.b	r12,	r13	;
    50de:	7c 40 09 00 	mov.b	#9,	r12	;
    50e2:	4c 9d       	cmp.b	r13,	r12	;
    50e4:	02 28       	jnc	$+6      	;abs 0x50ea
    50e6:	c1 43 12 00 	mov.b	#0,	18(r1)	;r3 As==00, 0x0012
    50ea:	5c 41 13 00 	mov.b	19(r1),	r12	;0x00013
    50ee:	8c 11       	sxt	r12		;
    50f0:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    50f4:	5d 41 13 00 	mov.b	19(r1),	r13	;0x00013
    50f8:	4d ec       	xor.b	r12,	r13	;
    50fa:	4d 8c       	sub.b	r12,	r13	;
    50fc:	7c 40 09 00 	mov.b	#9,	r12	;
    5100:	4c 9d       	cmp.b	r13,	r12	;
    5102:	02 28       	jnc	$+6      	;abs 0x5108
    5104:	c1 43 13 00 	mov.b	#0,	19(r1)	;r3 As==00, 0x0013
    5108:	5c 41 14 00 	mov.b	20(r1),	r12	;0x00014
    510c:	8c 11       	sxt	r12		;
    510e:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    5112:	5d 41 14 00 	mov.b	20(r1),	r13	;0x00014
    5116:	4d ec       	xor.b	r12,	r13	;
    5118:	4d 8c       	sub.b	r12,	r13	;
    511a:	7c 40 09 00 	mov.b	#9,	r12	;
    511e:	4c 9d       	cmp.b	r13,	r12	;
    5120:	02 28       	jnc	$+6      	;abs 0x5126
    5122:	c1 43 14 00 	mov.b	#0,	20(r1)	;r3 As==00, 0x0014
    5126:	5c 41 15 00 	mov.b	21(r1),	r12	;0x00015
    512a:	8c 11       	sxt	r12		;
    512c:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    5130:	5d 41 15 00 	mov.b	21(r1),	r13	;0x00015
    5134:	4d ec       	xor.b	r12,	r13	;
    5136:	4d 8c       	sub.b	r12,	r13	;
    5138:	7c 40 09 00 	mov.b	#9,	r12	;
    513c:	4c 9d       	cmp.b	r13,	r12	;
    513e:	02 28       	jnc	$+6      	;abs 0x5144
    5140:	c1 43 15 00 	mov.b	#0,	21(r1)	;r3 As==00, 0x0015
    5144:	5c 41 16 00 	mov.b	22(r1),	r12	;0x00016
    5148:	8c 11       	sxt	r12		;
    514a:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    514e:	5d 41 16 00 	mov.b	22(r1),	r13	;0x00016
    5152:	4d ec       	xor.b	r12,	r13	;
    5154:	4d 8c       	sub.b	r12,	r13	;
    5156:	7c 40 09 00 	mov.b	#9,	r12	;
    515a:	4c 9d       	cmp.b	r13,	r12	;
    515c:	02 28       	jnc	$+6      	;abs 0x5162
    515e:	c1 43 16 00 	mov.b	#0,	22(r1)	;r3 As==00, 0x0016
    5162:	5c 41 17 00 	mov.b	23(r1),	r12	;0x00017
    5166:	8c 11       	sxt	r12		;
    5168:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    516c:	5d 41 17 00 	mov.b	23(r1),	r13	;0x00017
    5170:	4d ec       	xor.b	r12,	r13	;
    5172:	4d 8c       	sub.b	r12,	r13	;
    5174:	7c 40 09 00 	mov.b	#9,	r12	;
    5178:	4c 9d       	cmp.b	r13,	r12	;
    517a:	02 28       	jnc	$+6      	;abs 0x5180
    517c:	c1 43 17 00 	mov.b	#0,	23(r1)	;r3 As==00, 0x0017
    5180:	5c 41 18 00 	mov.b	24(r1),	r12	;0x00018
    5184:	8c 11       	sxt	r12		;
    5186:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    518a:	5d 41 18 00 	mov.b	24(r1),	r13	;0x00018
    518e:	4d ec       	xor.b	r12,	r13	;
    5190:	4d 8c       	sub.b	r12,	r13	;
    5192:	7c 40 09 00 	mov.b	#9,	r12	;
    5196:	4c 9d       	cmp.b	r13,	r12	;
    5198:	02 28       	jnc	$+6      	;abs 0x519e
    519a:	c1 43 18 00 	mov.b	#0,	24(r1)	;r3 As==00, 0x0018
    519e:	5c 41 19 00 	mov.b	25(r1),	r12	;0x00019
    51a2:	8c 11       	sxt	r12		;
    51a4:	46 18 0c 11 	rpt #7 { rrax.w	r12		;
    51a8:	5d 41 19 00 	mov.b	25(r1),	r13	;0x00019
    51ac:	4d ec       	xor.b	r12,	r13	;
    51ae:	4d 8c       	sub.b	r12,	r13	;
    51b0:	7c 40 09 00 	mov.b	#9,	r12	;
    51b4:	4c 9d       	cmp.b	r13,	r12	;
    51b6:	02 28       	jnc	$+6      	;abs 0x51bc
    51b8:	c1 43 19 00 	mov.b	#0,	25(r1)	;r3 As==00, 0x0019
    51bc:	0d 41       	mov	r1,	r13	;
    51be:	3d 50 11 00 	add	#17,	r13	;#0x0011
    51c2:	0c 41       	mov	r1,	r12	;
    51c4:	3c 50 06 00 	add	#6,	r12	;
    51c8:	b0 12 b8 46 	call	#18104		;#0x46b8
    51cc:	1b 41 06 00 	mov	6(r1),	r11	;
    51d0:	14 41 08 00 	mov	8(r1),	r4	;
    51d4:	47 43       	clr.b	r7		;
    51d6:	45 43       	clr.b	r5		;
    51d8:	4a 43       	clr.b	r10		;
    51da:	0d 4a       	mov	r10,	r13	;
    51dc:	5d 06       	rlam	#2,	r13	;
    51de:	0d 56       	add	r6,	r13	;
    51e0:	2e 4d       	mov	@r13,	r14	;
    51e2:	1c 4d 02 00 	mov	2(r13),	r12	;
    51e6:	0c 84       	sub	r4,	r12	;
    51e8:	0f 4c       	mov	r12,	r15	;
    51ea:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    51ee:	0c ef       	xor	r15,	r12	;
    51f0:	0c 8f       	sub	r15,	r12	;
    51f2:	1f 4d 40 00 	mov	64(r13),r15	;0x00040
    51f6:	1d 4d 42 00 	mov	66(r13),r13	;0x00042
    51fa:	0d 84       	sub	r4,	r13	;
    51fc:	08 4d       	mov	r13,	r8	;
    51fe:	4e 18 08 11 	rpt #15 { rrax.w	r8		;
    5202:	0d e8       	xor	r8,	r13	;
    5204:	0d 88       	sub	r8,	r13	;
    5206:	0f 8b       	sub	r11,	r15	;
    5208:	08 4f       	mov	r15,	r8	;
    520a:	4e 18 08 11 	rpt #15 { rrax.w	r8		;
    520e:	0f e8       	xor	r8,	r15	;
    5210:	0f 88       	sub	r8,	r15	;
    5212:	0e 8b       	sub	r11,	r14	;
    5214:	08 4e       	mov	r14,	r8	;
    5216:	4e 18 08 11 	rpt #15 { rrax.w	r8		;
    521a:	0e e8       	xor	r8,	r14	;
    521c:	0e 88       	sub	r8,	r14	;
    521e:	0f 9e       	cmp	r14,	r15	;
    5220:	22 34       	jge	$+70     	;abs 0x5266
    5222:	15 53       	inc	r5		;
    5224:	0d 9c       	cmp	r12,	r13	;
    5226:	1d 34       	jge	$+60     	;abs 0x5262
    5228:	15 53       	inc	r5		;
    522a:	1a 53       	inc	r10		;
    522c:	3a 90 10 00 	cmp	#16,	r10	;#0x0010
    5230:	d4 23       	jnz	$-86     	;abs 0x51da
    5232:	91 53 0a 00 	inc	10(r1)		;
    5236:	07 95       	cmp	r5,	r7	;
    5238:	18 38       	jl	$+50     	;abs 0x526a
    523a:	91 53 0e 00 	inc	14(r1)		;
    523e:	19 53       	inc	r9		;
    5240:	39 90 40 00 	cmp	#64,	r9	;#0x0040
    5244:	18 24       	jz	$+50     	;abs 0x5276
    5246:	39 90 20 00 	cmp	#32,	r9	;#0x0020
    524a:	05 23       	jnz	$-500    	;abs 0x5056
    524c:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5250:	1c 42 80 1c 	mov	&0x1c80,r12	;0x1c80
    5254:	3c 53       	add	#-1,	r12	;r3 As==11
    5256:	0c cd       	bic	r13,	r12	;
    5258:	4e 19 0c 10 	rpt #15 { rrux.w	r12		;
    525c:	82 4c 80 1c 	mov	r12,	&0x1c80	;
    5260:	fa 3e       	jmp	$-522    	;abs 0x5056
    5262:	17 53       	inc	r7		;
    5264:	e2 3f       	jmp	$-58     	;abs 0x522a
    5266:	17 53       	inc	r7		;
    5268:	dd 3f       	jmp	$-68     	;abs 0x5224
    526a:	91 53 0c 00 	inc	12(r1)		;
    526e:	19 53       	inc	r9		;
    5270:	39 90 40 00 	cmp	#64,	r9	;#0x0040
    5274:	e8 23       	jnz	$-46     	;abs 0x5246
    5276:	31 50 1a 00 	add	#26,	r1	;#0x001a
    527a:	64 17       	popm	#7,	r10	;16-bit words
    527c:	30 41       	ret			

0000527e <main>:
    527e:	19 15       	pushm	#2,	r9	;16-bit words
    5280:	b0 12 10 42 	call	#16912		;#0x4210
    5284:	f2 d0 03 00 	bis.b	#3,	&0x0204	;
    5288:	04 02 
    528a:	f2 f0 fc ff 	and.b	#-4,	&0x0202	;#0xfffc
    528e:	02 02 
    5290:	03 43       	nop			
    5292:	32 d2       	eint			
    5294:	03 43       	nop			
    5296:	b2 40 e1 ac 	mov	#-21279,&0x1c82	;#0xace1
    529a:	82 1c 
    529c:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    52a0:	b0 12 e8 40 	call	#16616		;#0x40e8
    52a4:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    52a8:	b0 12 b0 40 	call	#16560		;#0x40b0
    52ac:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    52b0:	b0 12 82 4c 	call	#19586		;#0x4c82
    52b4:	b0 12 cc 40 	call	#16588		;#0x40cc
    52b8:	38 40 00 24 	mov	#9216,	r8	;#0x2400
    52bc:	79 40 f4 00 	mov.b	#244,	r9	;#0x00f4
    52c0:	0c 48       	mov	r8,	r12	;
    52c2:	0d 49       	mov	r9,	r13	;
    52c4:	b0 12 20 41 	call	#16672		;#0x4120
    52c8:	92 43 80 1c 	mov	#1,	&0x1c80	;r3 As==01
    52cc:	b0 12 b0 40 	call	#16560		;#0x40b0
    52d0:	3c 40 40 1c 	mov	#7232,	r12	;#0x1c40
    52d4:	b0 12 82 4c 	call	#19586		;#0x4c82
    52d8:	b0 12 cc 40 	call	#16588		;#0x40cc
    52dc:	0c 48       	mov	r8,	r12	;
    52de:	0d 49       	mov	r9,	r13	;
    52e0:	b0 12 20 41 	call	#16672		;#0x4120
    52e4:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    52e8:	b0 12 b0 40 	call	#16560		;#0x40b0
    52ec:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    52f0:	b0 12 38 50 	call	#20536		;#0x5038
    52f4:	b0 12 cc 40 	call	#16588		;#0x40cc
    52f8:	b0 12 04 41 	call	#16644		;#0x4104
    52fc:	4c 43       	clr.b	r12		;
    52fe:	18 17       	popm	#2,	r9	;16-bit words
    5300:	30 41       	ret			

00005302 <udivmodhi4>:
    5302:	0f 4c       	mov	r12,	r15	;
    5304:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011
    5308:	5b 43       	mov.b	#1,	r11	;r3 As==01
    530a:	0d 9f       	cmp	r15,	r13	;
    530c:	05 2c       	jc	$+12     	;abs 0x5318
    530e:	3c 53       	add	#-1,	r12	;r3 As==11
    5310:	0c 93       	cmp	#0,	r12	;r3 As==00
    5312:	05 24       	jz	$+12     	;abs 0x531e
    5314:	0d 93       	cmp	#0,	r13	;r3 As==00
    5316:	07 34       	jge	$+16     	;abs 0x5326
    5318:	4c 43       	clr.b	r12		;
    531a:	0b 93       	cmp	#0,	r11	;r3 As==00
    531c:	07 20       	jnz	$+16     	;abs 0x532c
    531e:	0e 93       	cmp	#0,	r14	;r3 As==00
    5320:	01 24       	jz	$+4      	;abs 0x5324
    5322:	0c 4f       	mov	r15,	r12	;
    5324:	30 41       	ret			
    5326:	5d 02       	rlam	#1,	r13	;
    5328:	5b 02       	rlam	#1,	r11	;
    532a:	ef 3f       	jmp	$-32     	;abs 0x530a
    532c:	0f 9d       	cmp	r13,	r15	;
    532e:	02 28       	jnc	$+6      	;abs 0x5334
    5330:	0f 8d       	sub	r13,	r15	;
    5332:	0c db       	bis	r11,	r12	;
    5334:	5b 03       	rrum	#1,	r11	;
    5336:	5d 03       	rrum	#1,	r13	;
    5338:	f0 3f       	jmp	$-30     	;abs 0x531a

0000533a <__mspabi_remu>:
    533a:	5e 43       	mov.b	#1,	r14	;r3 As==01
    533c:	b0 12 02 53 	call	#21250		;#0x5302
    5340:	30 41       	ret			

00005342 <udivmodsi4>:
    5342:	4a 15       	pushm	#5,	r10	;16-bit words
    5344:	0a 4c       	mov	r12,	r10	;
    5346:	0b 4d       	mov	r13,	r11	;
    5348:	7c 40 21 00 	mov.b	#33,	r12	;#0x0021
    534c:	58 43       	mov.b	#1,	r8	;r3 As==01
    534e:	49 43       	clr.b	r9		;
    5350:	0f 9b       	cmp	r11,	r15	;
    5352:	04 28       	jnc	$+10     	;abs 0x535c
    5354:	0b 9f       	cmp	r15,	r11	;
    5356:	07 20       	jnz	$+16     	;abs 0x5366
    5358:	0e 9a       	cmp	r10,	r14	;
    535a:	05 2c       	jc	$+12     	;abs 0x5366
    535c:	3c 53       	add	#-1,	r12	;r3 As==11
    535e:	0c 93       	cmp	#0,	r12	;r3 As==00
    5360:	2d 24       	jz	$+92     	;abs 0x53bc
    5362:	0f 93       	cmp	#0,	r15	;r3 As==00
    5364:	0d 34       	jge	$+28     	;abs 0x5380
    5366:	4c 43       	clr.b	r12		;
    5368:	4d 43       	clr.b	r13		;
    536a:	07 48       	mov	r8,	r7	;
    536c:	07 d9       	bis	r9,	r7	;
    536e:	07 93       	cmp	#0,	r7	;r3 As==00
    5370:	14 20       	jnz	$+42     	;abs 0x539a
    5372:	81 93 0c 00 	cmp	#0,	12(r1)	;r3 As==00, 0x000c
    5376:	02 24       	jz	$+6      	;abs 0x537c
    5378:	0c 4a       	mov	r10,	r12	;
    537a:	0d 4b       	mov	r11,	r13	;
    537c:	46 17       	popm	#5,	r10	;16-bit words
    537e:	30 41       	ret			
    5380:	06 4e       	mov	r14,	r6	;
    5382:	07 4f       	mov	r15,	r7	;
    5384:	06 5e       	add	r14,	r6	;
    5386:	07 6f       	addc	r15,	r7	;
    5388:	0e 46       	mov	r6,	r14	;
    538a:	0f 47       	mov	r7,	r15	;
    538c:	06 48       	mov	r8,	r6	;
    538e:	07 49       	mov	r9,	r7	;
    5390:	06 58       	add	r8,	r6	;
    5392:	07 69       	addc	r9,	r7	;
    5394:	08 46       	mov	r6,	r8	;
    5396:	09 47       	mov	r7,	r9	;
    5398:	db 3f       	jmp	$-72     	;abs 0x5350
    539a:	0b 9f       	cmp	r15,	r11	;
    539c:	08 28       	jnc	$+18     	;abs 0x53ae
    539e:	0f 9b       	cmp	r11,	r15	;
    53a0:	02 20       	jnz	$+6      	;abs 0x53a6
    53a2:	0a 9e       	cmp	r14,	r10	;
    53a4:	04 28       	jnc	$+10     	;abs 0x53ae
    53a6:	0a 8e       	sub	r14,	r10	;
    53a8:	0b 7f       	subc	r15,	r11	;
    53aa:	0c d8       	bis	r8,	r12	;
    53ac:	0d d9       	bis	r9,	r13	;
    53ae:	12 c3       	clrc			
    53b0:	09 10       	rrc	r9		;
    53b2:	08 10       	rrc	r8		;
    53b4:	12 c3       	clrc			
    53b6:	0f 10       	rrc	r15		;
    53b8:	0e 10       	rrc	r14		;
    53ba:	d7 3f       	jmp	$-80     	;abs 0x536a
    53bc:	4c 43       	clr.b	r12		;
    53be:	4d 43       	clr.b	r13		;
    53c0:	d8 3f       	jmp	$-78     	;abs 0x5372

000053c2 <__mspabi_divli>:
    53c2:	2a 15       	pushm	#3,	r10	;16-bit words
    53c4:	21 83       	decd	r1		;
    53c6:	4a 43       	clr.b	r10		;
    53c8:	0d 93       	cmp	#0,	r13	;r3 As==00
    53ca:	07 34       	jge	$+16     	;abs 0x53da
    53cc:	48 43       	clr.b	r8		;
    53ce:	49 43       	clr.b	r9		;
    53d0:	08 8c       	sub	r12,	r8	;
    53d2:	09 7d       	subc	r13,	r9	;
    53d4:	0c 48       	mov	r8,	r12	;
    53d6:	0d 49       	mov	r9,	r13	;
    53d8:	5a 43       	mov.b	#1,	r10	;r3 As==01
    53da:	0f 93       	cmp	#0,	r15	;r3 As==00
    53dc:	07 34       	jge	$+16     	;abs 0x53ec
    53de:	48 43       	clr.b	r8		;
    53e0:	49 43       	clr.b	r9		;
    53e2:	08 8e       	sub	r14,	r8	;
    53e4:	09 7f       	subc	r15,	r9	;
    53e6:	0e 48       	mov	r8,	r14	;
    53e8:	0f 49       	mov	r9,	r15	;
    53ea:	1a e3       	xor	#1,	r10	;r3 As==01
    53ec:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    53f0:	b0 12 42 53 	call	#21314		;#0x5342
    53f4:	0a 93       	cmp	#0,	r10	;r3 As==00
    53f6:	06 24       	jz	$+14     	;abs 0x5404
    53f8:	49 43       	clr.b	r9		;
    53fa:	4a 43       	clr.b	r10		;
    53fc:	09 8c       	sub	r12,	r9	;
    53fe:	0a 7d       	subc	r13,	r10	;
    5400:	0c 49       	mov	r9,	r12	;
    5402:	0d 4a       	mov	r10,	r13	;
    5404:	21 53       	incd	r1		;
    5406:	28 17       	popm	#3,	r10	;16-bit words
    5408:	30 41       	ret			

0000540a <__mulhi2>:
    540a:	02 12       	push	r2		;
    540c:	32 c2       	dint			
    540e:	03 43       	nop			
    5410:	82 4c c0 04 	mov	r12,	&0x04c0	;
    5414:	82 4d c8 04 	mov	r13,	&0x04c8	;
    5418:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    541c:	00 13       	reti			

0000541e <__mulsi2>:
    541e:	02 12       	push	r2		;
    5420:	32 c2       	dint			
    5422:	03 43       	nop			
    5424:	82 4c d0 04 	mov	r12,	&0x04d0	;
    5428:	82 4d d2 04 	mov	r13,	&0x04d2	;
    542c:	82 4e e0 04 	mov	r14,	&0x04e0	;
    5430:	82 4f e2 04 	mov	r15,	&0x04e2	;
    5434:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    5438:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    543c:	00 13       	reti			

0000543e <memcpy>:
    543e:	0f 4c       	mov	r12,	r15	;
    5440:	0e 5d       	add	r13,	r14	;
    5442:	0d 9e       	cmp	r14,	r13	;
    5444:	01 20       	jnz	$+4      	;abs 0x5448
    5446:	30 41       	ret			
    5448:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    544c:	1f 53       	inc	r15		;
    544e:	f9 3f       	jmp	$-12     	;abs 0x5442

00005450 <_exit>:
    5450:	ff 3f       	jmp	$+0      	;abs 0x5450
