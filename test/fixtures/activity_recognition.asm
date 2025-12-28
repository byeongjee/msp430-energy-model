
/Users/byeongjee/migration/probabilistic-energy-modeling/build/activity_recognition_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004064 <__crt0_start>:
    4064:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004068 <__crt0_call_main>:
    4068:	0c 43       	clr	r12		;
    406a:	b0 12 8e 42 	call	#17038		;#0x428e

0000406e <__crt0_call_exit>:
    406e:	b0 12 50 60 	call	#24656		;#0x6050

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
    422a:	3d 40 52 60 	mov	#24658,	r13	;#0x6052
    422e:	b0 12 3e 60 	call	#24638		;#0x603e
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
    428c:	30 41       	ret			

0000428e <main>:
    428e:	6a 15       	pushm	#7,	r10	;16-bit words
    4290:	31 80 30 00 	sub	#48,	r1	;#0x0030
    4294:	b0 12 10 42 	call	#16912		;#0x4210
    4298:	f2 d0 03 00 	bis.b	#3,	&0x0204	;
    429c:	04 02 
    429e:	f2 f0 fc ff 	and.b	#-4,	&0x0202	;#0xfffc
    42a2:	02 02 
    42a4:	03 43       	nop			
    42a6:	32 d2       	eint			
    42a8:	03 43       	nop			
    42aa:	b2 40 e1 ac 	mov	#-21279,&0x1c82	;#0xace1
    42ae:	82 1c 
    42b0:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    42b4:	b0 12 e8 40 	call	#16616		;#0x40e8
    42b8:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    42bc:	b0 12 b0 40 	call	#16560		;#0x40b0
    42c0:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    42c4:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    42c8:	0d 4c       	mov	r12,	r13	;
    42ca:	5d f3       	and.b	#1,	r13	;r3 As==01
    42cc:	5c 03       	rrum	#1,	r12	;
    42ce:	0d 93       	cmp	#0,	r13	;r3 As==00
    42d0:	02 24       	jz	$+6      	;abs 0x42d6
    42d2:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    42d6:	0d 4c       	mov	r12,	r13	;
    42d8:	5d 03       	rrum	#1,	r13	;
    42da:	1c b3       	bit	#1,	r12	;r3 As==01
    42dc:	02 24       	jz	$+6      	;abs 0x42e2
    42de:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    42e2:	0c 4d       	mov	r13,	r12	;
    42e4:	5c 03       	rrum	#1,	r12	;
    42e6:	1d b3       	bit	#1,	r13	;r3 As==01
    42e8:	02 24       	jz	$+6      	;abs 0x42ee
    42ea:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    42ee:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    42f2:	0d 4c       	mov	r12,	r13	;
    42f4:	5d f3       	and.b	#1,	r13	;r3 As==01
    42f6:	5c 03       	rrum	#1,	r12	;
    42f8:	0d 93       	cmp	#0,	r13	;r3 As==00
    42fa:	02 24       	jz	$+6      	;abs 0x4300
    42fc:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4300:	0d 4c       	mov	r12,	r13	;
    4302:	5d 03       	rrum	#1,	r13	;
    4304:	1c b3       	bit	#1,	r12	;r3 As==01
    4306:	02 24       	jz	$+6      	;abs 0x430c
    4308:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    430c:	0c 4d       	mov	r13,	r12	;
    430e:	5c 03       	rrum	#1,	r12	;
    4310:	1d b3       	bit	#1,	r13	;r3 As==01
    4312:	02 24       	jz	$+6      	;abs 0x4318
    4314:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4318:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    431c:	0d 4c       	mov	r12,	r13	;
    431e:	5d f3       	and.b	#1,	r13	;r3 As==01
    4320:	5c 03       	rrum	#1,	r12	;
    4322:	0e 93       	cmp	#0,	r14	;r3 As==00
    4324:	02 24       	jz	$+6      	;abs 0x432a
    4326:	80 00 ba 5e 	mova	#24250,	r0	;0x05eba
    432a:	0d 93       	cmp	#0,	r13	;r3 As==00
    432c:	02 24       	jz	$+6      	;abs 0x4332
    432e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4332:	0d 4c       	mov	r12,	r13	;
    4334:	5d 03       	rrum	#1,	r13	;
    4336:	1c b3       	bit	#1,	r12	;r3 As==01
    4338:	02 24       	jz	$+6      	;abs 0x433e
    433a:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    433e:	09 4d       	mov	r13,	r9	;
    4340:	59 03       	rrum	#1,	r9	;
    4342:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    4346:	1d b3       	bit	#1,	r13	;r3 As==01
    4348:	02 24       	jz	$+6      	;abs 0x434e
    434a:	80 00 f6 5e 	mova	#24310,	r0	;0x05ef6
    434e:	b1 40 00 1c 	mov	#7168,	14(r1)	;#0x1c00, 0x000e
    4352:	0e 00 
    4354:	44 43       	clr.b	r4		;
    4356:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    435a:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    435e:	5c f3       	and.b	#1,	r12	;r3 As==01
    4360:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    4364:	5a 03       	rrum	#1,	r10	;
    4366:	0d 93       	cmp	#0,	r13	;r3 As==00
    4368:	02 20       	jnz	$+6      	;abs 0x436e
    436a:	80 00 1e 5e 	mova	#24094,	r0	;0x05e1e
    436e:	0c 93       	cmp	#0,	r12	;r3 As==00
    4370:	02 24       	jz	$+6      	;abs 0x4376
    4372:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4376:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    437a:	0c 4a       	mov	r10,	r12	;
    437c:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4380:	46 4c       	mov.b	r12,	r6	;
    4382:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    4386:	86 11       	sxt	r6		;
    4388:	08 4a       	mov	r10,	r8	;
    438a:	58 03       	rrum	#1,	r8	;
    438c:	1a b3       	bit	#1,	r10	;r3 As==01
    438e:	02 24       	jz	$+6      	;abs 0x4394
    4390:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4394:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4398:	0c 48       	mov	r8,	r12	;
    439a:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    439e:	4a 4c       	mov.b	r12,	r10	;
    43a0:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    43a4:	8a 11       	sxt	r10		;
    43a6:	09 48       	mov	r8,	r9	;
    43a8:	59 03       	rrum	#1,	r9	;
    43aa:	18 b3       	bit	#1,	r8	;r3 As==01
    43ac:	02 24       	jz	$+6      	;abs 0x43b2
    43ae:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    43b2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43b6:	0c 49       	mov	r9,	r12	;
    43b8:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    43bc:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    43c0:	8c 11       	sxt	r12		;
    43c2:	81 4c 06 00 	mov	r12,	6(r1)	;
    43c6:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    43ca:	0c 49       	mov	r9,	r12	;
    43cc:	5c f3       	and.b	#1,	r12	;r3 As==01
    43ce:	59 03       	rrum	#1,	r9	;
    43d0:	0d 93       	cmp	#0,	r13	;r3 As==00
    43d2:	02 20       	jnz	$+6      	;abs 0x43d8
    43d4:	80 00 ce 5d 	mova	#24014,	r0	;0x05dce
    43d8:	0c 93       	cmp	#0,	r12	;r3 As==00
    43da:	02 24       	jz	$+6      	;abs 0x43e0
    43dc:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    43e0:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43e4:	0c 49       	mov	r9,	r12	;
    43e6:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    43ea:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    43ee:	8c 11       	sxt	r12		;
    43f0:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    43f4:	08 49       	mov	r9,	r8	;
    43f6:	58 03       	rrum	#1,	r8	;
    43f8:	19 b3       	bit	#1,	r9	;r3 As==01
    43fa:	02 24       	jz	$+6      	;abs 0x4400
    43fc:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4400:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4404:	0c 48       	mov	r8,	r12	;
    4406:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    440a:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    440e:	8c 11       	sxt	r12		;
    4410:	81 4c 10 00 	mov	r12,	16(r1)	; 0x0010
    4414:	09 48       	mov	r8,	r9	;
    4416:	59 03       	rrum	#1,	r9	;
    4418:	18 b3       	bit	#1,	r8	;r3 As==01
    441a:	02 24       	jz	$+6      	;abs 0x4420
    441c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4420:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4424:	0c 49       	mov	r9,	r12	;
    4426:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    442a:	47 4c       	mov.b	r12,	r7	;
    442c:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4430:	87 11       	sxt	r7		;
    4432:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4436:	0c 49       	mov	r9,	r12	;
    4438:	5c f3       	and.b	#1,	r12	;r3 As==01
    443a:	59 03       	rrum	#1,	r9	;
    443c:	0d 93       	cmp	#0,	r13	;r3 As==00
    443e:	02 20       	jnz	$+6      	;abs 0x4444
    4440:	80 00 78 5d 	mova	#23928,	r0	;0x05d78
    4444:	0c 93       	cmp	#0,	r12	;r3 As==00
    4446:	02 24       	jz	$+6      	;abs 0x444c
    4448:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    444c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4450:	0c 49       	mov	r9,	r12	;
    4452:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4456:	48 4c       	mov.b	r12,	r8	;
    4458:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    445c:	88 11       	sxt	r8		;
    445e:	05 49       	mov	r9,	r5	;
    4460:	55 03       	rrum	#1,	r5	;
    4462:	19 b3       	bit	#1,	r9	;r3 As==01
    4464:	02 24       	jz	$+6      	;abs 0x446a
    4466:	35 e0 00 b4 	xor	#-19456,r5	;#0xb400
    446a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    446e:	0c 45       	mov	r5,	r12	;
    4470:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4474:	49 4c       	mov.b	r12,	r9	;
    4476:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    447a:	89 11       	sxt	r9		;
    447c:	0d 45       	mov	r5,	r13	;
    447e:	5d 03       	rrum	#1,	r13	;
    4480:	81 4d 12 00 	mov	r13,	18(r1)	; 0x0012
    4484:	15 b3       	bit	#1,	r5	;r3 As==01
    4486:	03 24       	jz	$+8      	;abs 0x448e
    4488:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    448c:	12 00 
    448e:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    4492:	82 1c 
    4494:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4498:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    449c:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    44a0:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    44a4:	8c 11       	sxt	r12		;
    44a6:	0e 46       	mov	r6,	r14	;
    44a8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44ac:	4d 4e       	mov.b	r14,	r13	;
    44ae:	4d e6       	xor.b	r6,	r13	;
    44b0:	4d 8e       	sub.b	r14,	r13	;
    44b2:	7e 40 09 00 	mov.b	#9,	r14	;
    44b6:	4e 9d       	cmp.b	r13,	r14	;
    44b8:	02 28       	jnc	$+6      	;abs 0x44be
    44ba:	80 00 6c 5d 	mova	#23916,	r0	;0x05d6c
    44be:	81 46 1c 00 	mov	r6,	28(r1)	; 0x001c
    44c2:	05 46       	mov	r6,	r5	;
    44c4:	4e 18 06 11 	rpt #15 { rrax.w	r6		;
    44c8:	0e 4a       	mov	r10,	r14	;
    44ca:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44ce:	4d 4e       	mov.b	r14,	r13	;
    44d0:	4d ea       	xor.b	r10,	r13	;
    44d2:	4d 8e       	sub.b	r14,	r13	;
    44d4:	7e 40 09 00 	mov.b	#9,	r14	;
    44d8:	4e 9d       	cmp.b	r13,	r14	;
    44da:	02 28       	jnc	$+6      	;abs 0x44e0
    44dc:	80 00 60 5d 	mova	#23904,	r0	;0x05d60
    44e0:	81 4a 22 00 	mov	r10,	34(r1)	; 0x0022
    44e4:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    44e8:	0b 7b       	subc	r11,	r11	;
    44ea:	3b e3       	inv	r11		;
    44ec:	1e 41 06 00 	mov	6(r1),	r14	;
    44f0:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44f4:	1d 41 06 00 	mov	6(r1),	r13	;
    44f8:	4d ee       	xor.b	r14,	r13	;
    44fa:	4d 8e       	sub.b	r14,	r13	;
    44fc:	7e 40 09 00 	mov.b	#9,	r14	;
    4500:	4e 9d       	cmp.b	r13,	r14	;
    4502:	02 28       	jnc	$+6      	;abs 0x4508
    4504:	80 00 50 5d 	mova	#23888,	r0	;0x05d50
    4508:	1e 41 06 00 	mov	6(r1),	r14	;
    450c:	0d 4e       	mov	r14,	r13	;
    450e:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4512:	81 4d 02 00 	mov	r13,	2(r1)	;
    4516:	81 4e 04 00 	mov	r14,	4(r1)	;
    451a:	1e 41 0a 00 	mov	10(r1),	r14	;0x0000a
    451e:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4522:	1d 41 0a 00 	mov	10(r1),	r13	;0x0000a
    4526:	4d ee       	xor.b	r14,	r13	;
    4528:	4d 8e       	sub.b	r14,	r13	;
    452a:	81 44 14 00 	mov	r4,	20(r1)	; 0x0014
    452e:	7e 40 09 00 	mov.b	#9,	r14	;
    4532:	4e 9d       	cmp.b	r13,	r14	;
    4534:	0b 2c       	jc	$+24     	;abs 0x454c
    4536:	91 41 0a 00 	mov	10(r1),	20(r1)	;0x0000a, 0x0014
    453a:	14 00 
    453c:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4540:	0e 4d       	mov	r13,	r14	;
    4542:	0f 4d       	mov	r13,	r15	;
    4544:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4548:	05 5e       	add	r14,	r5	;
    454a:	06 6f       	addc	r15,	r6	;
    454c:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    4550:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4554:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4558:	4d ee       	xor.b	r14,	r13	;
    455a:	4d 8e       	sub.b	r14,	r13	;
    455c:	81 44 16 00 	mov	r4,	22(r1)	; 0x0016
    4560:	7e 40 09 00 	mov.b	#9,	r14	;
    4564:	4e 9d       	cmp.b	r13,	r14	;
    4566:	0b 2c       	jc	$+24     	;abs 0x457e
    4568:	91 41 10 00 	mov	16(r1),	22(r1)	;0x00010, 0x0016
    456c:	16 00 
    456e:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4572:	0e 4d       	mov	r13,	r14	;
    4574:	0f 4d       	mov	r13,	r15	;
    4576:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    457a:	0a 5e       	add	r14,	r10	;
    457c:	0b 6f       	addc	r15,	r11	;
    457e:	0e 47       	mov	r7,	r14	;
    4580:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4584:	4d 4e       	mov.b	r14,	r13	;
    4586:	4d e7       	xor.b	r7,	r13	;
    4588:	4d 8e       	sub.b	r14,	r13	;
    458a:	81 44 10 00 	mov	r4,	16(r1)	; 0x0010
    458e:	7e 40 09 00 	mov.b	#9,	r14	;
    4592:	4e 9d       	cmp.b	r13,	r14	;
    4594:	10 2c       	jc	$+34     	;abs 0x45b6
    4596:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    459a:	0d 47       	mov	r7,	r13	;
    459c:	0e 47       	mov	r7,	r14	;
    459e:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    45a2:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    45a6:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    45aa:	91 51 0a 00 	rla	10(r1)		;#0x0000a
    45ae:	02 00 
    45b0:	91 61 0c 00 	rlc	12(r1)		;#0x0000c
    45b4:	04 00 
    45b6:	0e 48       	mov	r8,	r14	;
    45b8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    45bc:	4d 4e       	mov.b	r14,	r13	;
    45be:	4d e8       	xor.b	r8,	r13	;
    45c0:	4d 8e       	sub.b	r14,	r13	;
    45c2:	7e 40 09 00 	mov.b	#9,	r14	;
    45c6:	4e 9d       	cmp.b	r13,	r14	;
    45c8:	02 28       	jnc	$+6      	;abs 0x45ce
    45ca:	80 00 40 5d 	mova	#23872,	r0	;0x05d40
    45ce:	81 48 24 00 	mov	r8,	36(r1)	; 0x0024
    45d2:	0d 48       	mov	r8,	r13	;
    45d4:	0e 48       	mov	r8,	r14	;
    45d6:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    45da:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    45de:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    45e2:	0e 49       	mov	r9,	r14	;
    45e4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    45e8:	4d 4e       	mov.b	r14,	r13	;
    45ea:	4d e9       	xor.b	r9,	r13	;
    45ec:	4d 8e       	sub.b	r14,	r13	;
    45ee:	7e 40 09 00 	mov.b	#9,	r14	;
    45f2:	4e 9d       	cmp.b	r13,	r14	;
    45f4:	02 28       	jnc	$+6      	;abs 0x45fa
    45f6:	80 00 26 5d 	mova	#23846,	r0	;0x05d26
    45fa:	81 49 26 00 	mov	r9,	38(r1)	; 0x0026
    45fe:	0e 49       	mov	r9,	r14	;
    4600:	0f 49       	mov	r9,	r15	;
    4602:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4606:	09 4c       	mov	r12,	r9	;
    4608:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    460c:	4d 49       	mov.b	r9,	r13	;
    460e:	4d ec       	xor.b	r12,	r13	;
    4610:	4d 89       	sub.b	r9,	r13	;
    4612:	79 40 09 00 	mov.b	#9,	r9	;
    4616:	49 9d       	cmp.b	r13,	r9	;
    4618:	02 28       	jnc	$+6      	;abs 0x461e
    461a:	80 00 1a 5d 	mova	#23834,	r0	;0x05d1a
    461e:	81 4c 28 00 	mov	r12,	40(r1)	; 0x0028
    4622:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4626:	0d 7d       	subc	r13,	r13	;
    4628:	3d e3       	inv	r13		;
    462a:	08 4e       	mov	r14,	r8	;
    462c:	08 5a       	add	r10,	r8	;
    462e:	09 4f       	mov	r15,	r9	;
    4630:	09 6b       	addc	r11,	r9	;
    4632:	0a 4c       	mov	r12,	r10	;
    4634:	1a 51 02 00 	add	2(r1),	r10	;
    4638:	17 41 04 00 	mov	4(r1),	r7	;
    463c:	07 6d       	addc	r13,	r7	;
    463e:	7e 40 03 00 	mov.b	#3,	r14	;
    4642:	4f 43       	clr.b	r15		;
    4644:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    4648:	0c 55       	add	r5,	r12	;
    464a:	1d 41 0c 00 	mov	12(r1),	r13	;0x0000c
    464e:	0d 66       	addc	r6,	r13	;
    4650:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4654:	81 4c 02 00 	mov	r12,	2(r1)	;
    4658:	7e 40 03 00 	mov.b	#3,	r14	;
    465c:	4f 43       	clr.b	r15		;
    465e:	0c 48       	mov	r8,	r12	;
    4660:	0d 49       	mov	r9,	r13	;
    4662:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4666:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    466a:	7e 40 03 00 	mov.b	#3,	r14	;
    466e:	4f 43       	clr.b	r15		;
    4670:	0c 4a       	mov	r10,	r12	;
    4672:	0d 47       	mov	r7,	r13	;
    4674:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4678:	05 4c       	mov	r12,	r5	;
    467a:	16 41 1c 00 	mov	28(r1),	r6	;0x0001c
    467e:	16 81 02 00 	sub	2(r1),	r6	;
    4682:	0c 46       	mov	r6,	r12	;
    4684:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    4688:	06 ec       	xor	r12,	r6	;
    468a:	0e 46       	mov	r6,	r14	;
    468c:	0e 8c       	sub	r12,	r14	;
    468e:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4692:	0f 7f       	subc	r15,	r15	;
    4694:	3f e3       	inv	r15		;
    4696:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    469a:	1c 81 02 00 	sub	2(r1),	r12	;
    469e:	0d 4c       	mov	r12,	r13	;
    46a0:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    46a4:	0c ed       	xor	r13,	r12	;
    46a6:	0c 8d       	sub	r13,	r12	;
    46a8:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    46ac:	0d 7d       	subc	r13,	r13	;
    46ae:	3d e3       	inv	r13		;
    46b0:	0c 5e       	add	r14,	r12	;
    46b2:	0a 4f       	mov	r15,	r10	;
    46b4:	0a 6d       	addc	r13,	r10	;
    46b6:	81 4a 14 00 	mov	r10,	20(r1)	; 0x0014
    46ba:	1a 41 22 00 	mov	34(r1),	r10	;0x00022
    46be:	1a 81 0a 00 	sub	10(r1),	r10	;0x0000a
    46c2:	0d 4a       	mov	r10,	r13	;
    46c4:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    46c8:	0a ed       	xor	r13,	r10	;
    46ca:	0a 8d       	sub	r13,	r10	;
    46cc:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    46d0:	0b 7b       	subc	r11,	r11	;
    46d2:	3b e3       	inv	r11		;
    46d4:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    46d8:	1d 81 0a 00 	sub	10(r1),	r13	;0x0000a
    46dc:	0f 4d       	mov	r13,	r15	;
    46de:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    46e2:	0d ef       	xor	r15,	r13	;
    46e4:	0e 4d       	mov	r13,	r14	;
    46e6:	0e 8f       	sub	r15,	r14	;
    46e8:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    46ec:	0f 7f       	subc	r15,	r15	;
    46ee:	3f e3       	inv	r15		;
    46f0:	09 4a       	mov	r10,	r9	;
    46f2:	09 5e       	add	r14,	r9	;
    46f4:	08 4b       	mov	r11,	r8	;
    46f6:	08 6f       	addc	r15,	r8	;
    46f8:	1d 41 06 00 	mov	6(r1),	r13	;
    46fc:	0d 85       	sub	r5,	r13	;
    46fe:	0e 4d       	mov	r13,	r14	;
    4700:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4704:	0d ee       	xor	r14,	r13	;
    4706:	0a 4d       	mov	r13,	r10	;
    4708:	0a 8e       	sub	r14,	r10	;
    470a:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    470e:	0b 7b       	subc	r11,	r11	;
    4710:	3b e3       	inv	r11		;
    4712:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4716:	0d 85       	sub	r5,	r13	;
    4718:	0f 4d       	mov	r13,	r15	;
    471a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    471e:	0d ef       	xor	r15,	r13	;
    4720:	0e 4d       	mov	r13,	r14	;
    4722:	0e 8f       	sub	r15,	r14	;
    4724:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4728:	0f 7f       	subc	r15,	r15	;
    472a:	3f e3       	inv	r15		;
    472c:	07 4a       	mov	r10,	r7	;
    472e:	07 5e       	add	r14,	r7	;
    4730:	0d 4b       	mov	r11,	r13	;
    4732:	0d 6f       	addc	r15,	r13	;
    4734:	1e 41 24 00 	mov	36(r1),	r14	;0x00024
    4738:	1e 81 02 00 	sub	2(r1),	r14	;
    473c:	0f 4e       	mov	r14,	r15	;
    473e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4742:	0e ef       	xor	r15,	r14	;
    4744:	0a 4e       	mov	r14,	r10	;
    4746:	0a 8f       	sub	r15,	r10	;
    4748:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    474c:	0b 7b       	subc	r11,	r11	;
    474e:	3b e3       	inv	r11		;
    4750:	1e 41 26 00 	mov	38(r1),	r14	;0x00026
    4754:	1e 81 0a 00 	sub	10(r1),	r14	;0x0000a
    4758:	0f 4e       	mov	r14,	r15	;
    475a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    475e:	0e ef       	xor	r15,	r14	;
    4760:	0e 8f       	sub	r15,	r14	;
    4762:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4766:	0f 7f       	subc	r15,	r15	;
    4768:	3f e3       	inv	r15		;
    476a:	09 5e       	add	r14,	r9	;
    476c:	08 6f       	addc	r15,	r8	;
    476e:	1e 41 28 00 	mov	40(r1),	r14	;0x00028
    4772:	0e 85       	sub	r5,	r14	;
    4774:	0f 4e       	mov	r14,	r15	;
    4776:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    477a:	0e ef       	xor	r15,	r14	;
    477c:	0e 8f       	sub	r15,	r14	;
    477e:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4782:	0f 7f       	subc	r15,	r15	;
    4784:	3f e3       	inv	r15		;
    4786:	07 5e       	add	r14,	r7	;
    4788:	06 4f       	mov	r15,	r6	;
    478a:	06 6d       	addc	r13,	r6	;
    478c:	7e 40 03 00 	mov.b	#3,	r14	;
    4790:	4f 43       	clr.b	r15		;
    4792:	0c 5a       	add	r10,	r12	;
    4794:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4798:	0d 6b       	addc	r11,	r13	;
    479a:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    479e:	0a 4c       	mov	r12,	r10	;
    47a0:	7e 40 03 00 	mov.b	#3,	r14	;
    47a4:	4f 43       	clr.b	r15		;
    47a6:	0c 49       	mov	r9,	r12	;
    47a8:	0d 48       	mov	r8,	r13	;
    47aa:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    47ae:	09 4c       	mov	r12,	r9	;
    47b0:	7e 40 03 00 	mov.b	#3,	r14	;
    47b4:	4f 43       	clr.b	r15		;
    47b6:	0c 47       	mov	r7,	r12	;
    47b8:	0d 46       	mov	r6,	r13	;
    47ba:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    47be:	08 4c       	mov	r12,	r8	;
    47c0:	0c 4a       	mov	r10,	r12	;
    47c2:	0d 4a       	mov	r10,	r13	;
    47c4:	b0 12 0a 60 	call	#24586		;#0x600a
    47c8:	0a 4c       	mov	r12,	r10	;
    47ca:	0c 49       	mov	r9,	r12	;
    47cc:	0d 49       	mov	r9,	r13	;
    47ce:	b0 12 0a 60 	call	#24586		;#0x600a
    47d2:	0a 5c       	add	r12,	r10	;
    47d4:	0c 48       	mov	r8,	r12	;
    47d6:	0d 48       	mov	r8,	r13	;
    47d8:	b0 12 0a 60 	call	#24586		;#0x600a
    47dc:	0a 5c       	add	r12,	r10	;
    47de:	1c 41 02 00 	mov	2(r1),	r12	;
    47e2:	0d 4c       	mov	r12,	r13	;
    47e4:	b0 12 0a 60 	call	#24586		;#0x600a
    47e8:	07 4c       	mov	r12,	r7	;
    47ea:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    47ee:	0d 4c       	mov	r12,	r13	;
    47f0:	b0 12 0a 60 	call	#24586		;#0x600a
    47f4:	07 5c       	add	r12,	r7	;
    47f6:	0c 45       	mov	r5,	r12	;
    47f8:	0d 45       	mov	r5,	r13	;
    47fa:	b0 12 0a 60 	call	#24586		;#0x600a
    47fe:	07 5c       	add	r12,	r7	;
    4800:	08 47       	mov	r7,	r8	;
    4802:	09 43       	clr	r9		;
    4804:	76 40 80 00 	mov.b	#128,	r6	;#0x0080
    4808:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    480c:	0c 97       	cmp	r7,	r12	;
    480e:	01 28       	jnc	$+4      	;abs 0x4812
    4810:	06 44       	mov	r4,	r6	;
    4812:	05 46       	mov	r6,	r5	;
    4814:	35 d0 40 00 	bis	#64,	r5	;#0x0040
    4818:	0c 45       	mov	r5,	r12	;
    481a:	0d 44       	mov	r4,	r13	;
    481c:	0e 45       	mov	r5,	r14	;
    481e:	0f 44       	mov	r4,	r15	;
    4820:	b0 12 1e 60 	call	#24606		;#0x601e
    4824:	0d 93       	cmp	#0,	r13	;r3 As==00
    4826:	04 20       	jnz	$+10     	;abs 0x4830
    4828:	09 93       	cmp	#0,	r9	;r3 As==00
    482a:	05 20       	jnz	$+12     	;abs 0x4836
    482c:	07 9c       	cmp	r12,	r7	;
    482e:	03 2c       	jc	$+8      	;abs 0x4836
    4830:	05 46       	mov	r6,	r5	;
    4832:	35 f0 bf ff 	and	#-65,	r5	;#0xffbf
    4836:	06 45       	mov	r5,	r6	;
    4838:	36 d0 20 00 	bis	#32,	r6	;#0x0020
    483c:	0c 46       	mov	r6,	r12	;
    483e:	0d 44       	mov	r4,	r13	;
    4840:	0e 46       	mov	r6,	r14	;
    4842:	0f 44       	mov	r4,	r15	;
    4844:	b0 12 1e 60 	call	#24606		;#0x601e
    4848:	0d 93       	cmp	#0,	r13	;r3 As==00
    484a:	04 20       	jnz	$+10     	;abs 0x4854
    484c:	09 93       	cmp	#0,	r9	;r3 As==00
    484e:	05 20       	jnz	$+12     	;abs 0x485a
    4850:	07 9c       	cmp	r12,	r7	;
    4852:	03 2c       	jc	$+8      	;abs 0x485a
    4854:	06 45       	mov	r5,	r6	;
    4856:	36 f0 df ff 	and	#-33,	r6	;#0xffdf
    485a:	05 46       	mov	r6,	r5	;
    485c:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4860:	0c 45       	mov	r5,	r12	;
    4862:	0d 44       	mov	r4,	r13	;
    4864:	0e 45       	mov	r5,	r14	;
    4866:	0f 44       	mov	r4,	r15	;
    4868:	b0 12 1e 60 	call	#24606		;#0x601e
    486c:	0d 93       	cmp	#0,	r13	;r3 As==00
    486e:	04 20       	jnz	$+10     	;abs 0x4878
    4870:	09 93       	cmp	#0,	r9	;r3 As==00
    4872:	05 20       	jnz	$+12     	;abs 0x487e
    4874:	07 9c       	cmp	r12,	r7	;
    4876:	03 2c       	jc	$+8      	;abs 0x487e
    4878:	05 46       	mov	r6,	r5	;
    487a:	35 f0 ef ff 	and	#-17,	r5	;#0xffef
    487e:	06 45       	mov	r5,	r6	;
    4880:	36 d2       	bis	#8,	r6	;r2 As==11
    4882:	0c 46       	mov	r6,	r12	;
    4884:	0d 44       	mov	r4,	r13	;
    4886:	0e 46       	mov	r6,	r14	;
    4888:	0f 44       	mov	r4,	r15	;
    488a:	b0 12 1e 60 	call	#24606		;#0x601e
    488e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4890:	02 24       	jz	$+6      	;abs 0x4896
    4892:	80 00 80 5a 	mova	#23168,	r0	;0x05a80
    4896:	09 93       	cmp	#0,	r9	;r3 As==00
    4898:	04 20       	jnz	$+10     	;abs 0x48a2
    489a:	07 9c       	cmp	r12,	r7	;
    489c:	02 2c       	jc	$+6      	;abs 0x48a2
    489e:	80 00 80 5a 	mova	#23168,	r0	;0x05a80
    48a2:	05 46       	mov	r6,	r5	;
    48a4:	25 d2       	bis	#4,	r5	;r2 As==10
    48a6:	0c 45       	mov	r5,	r12	;
    48a8:	0d 44       	mov	r4,	r13	;
    48aa:	0e 45       	mov	r5,	r14	;
    48ac:	0f 44       	mov	r4,	r15	;
    48ae:	b0 12 1e 60 	call	#24606		;#0x601e
    48b2:	0d 93       	cmp	#0,	r13	;r3 As==00
    48b4:	02 24       	jz	$+6      	;abs 0x48ba
    48b6:	80 00 78 5a 	mova	#23160,	r0	;0x05a78
    48ba:	09 93       	cmp	#0,	r9	;r3 As==00
    48bc:	04 20       	jnz	$+10     	;abs 0x48c6
    48be:	07 9c       	cmp	r12,	r7	;
    48c0:	02 2c       	jc	$+6      	;abs 0x48c6
    48c2:	80 00 78 5a 	mova	#23160,	r0	;0x05a78
    48c6:	06 45       	mov	r5,	r6	;
    48c8:	26 d3       	bis	#2,	r6	;r3 As==10
    48ca:	0c 46       	mov	r6,	r12	;
    48cc:	0d 44       	mov	r4,	r13	;
    48ce:	0e 46       	mov	r6,	r14	;
    48d0:	0f 44       	mov	r4,	r15	;
    48d2:	b0 12 1e 60 	call	#24606		;#0x601e
    48d6:	0d 93       	cmp	#0,	r13	;r3 As==00
    48d8:	02 24       	jz	$+6      	;abs 0x48de
    48da:	80 00 70 5a 	mova	#23152,	r0	;0x05a70
    48de:	09 93       	cmp	#0,	r9	;r3 As==00
    48e0:	04 20       	jnz	$+10     	;abs 0x48ea
    48e2:	07 9c       	cmp	r12,	r7	;
    48e4:	02 2c       	jc	$+6      	;abs 0x48ea
    48e6:	80 00 70 5a 	mova	#23152,	r0	;0x05a70
    48ea:	05 46       	mov	r6,	r5	;
    48ec:	15 d3       	bis	#1,	r5	;r3 As==01
    48ee:	0c 45       	mov	r5,	r12	;
    48f0:	0d 44       	mov	r4,	r13	;
    48f2:	0e 45       	mov	r5,	r14	;
    48f4:	0f 44       	mov	r4,	r15	;
    48f6:	b0 12 1e 60 	call	#24606		;#0x601e
    48fa:	0d 93       	cmp	#0,	r13	;r3 As==00
    48fc:	02 24       	jz	$+6      	;abs 0x4902
    48fe:	80 00 3a 5a 	mova	#23098,	r0	;0x05a3a
    4902:	09 93       	cmp	#0,	r9	;r3 As==00
    4904:	04 20       	jnz	$+10     	;abs 0x490e
    4906:	07 9c       	cmp	r12,	r7	;
    4908:	02 2c       	jc	$+6      	;abs 0x490e
    490a:	80 00 3a 5a 	mova	#23098,	r0	;0x05a3a
    490e:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    4912:	0d 4a       	mov	r10,	r13	;
    4914:	0e 43       	clr	r14		;
    4916:	81 4d 06 00 	mov	r13,	6(r1)	;
    491a:	81 4e 08 00 	mov	r14,	8(r1)	;
    491e:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    4922:	0e 9a       	cmp	r10,	r14	;
    4924:	02 2c       	jc	$+6      	;abs 0x492a
    4926:	80 00 5a 5a 	mova	#23130,	r0	;0x05a5a
    492a:	39 40 ff 03 	mov	#1023,	r9	;#0x03ff
    492e:	78 40 20 00 	mov.b	#32,	r8	;#0x0020
    4932:	09 9a       	cmp	r10,	r9	;
    4934:	02 28       	jnc	$+6      	;abs 0x493a
    4936:	80 00 36 5d 	mova	#23862,	r0	;0x05d36
    493a:	09 44       	mov	r4,	r9	;
    493c:	38 d0 10 00 	bis	#16,	r8	;#0x0010
    4940:	0c 48       	mov	r8,	r12	;
    4942:	0d 49       	mov	r9,	r13	;
    4944:	0e 48       	mov	r8,	r14	;
    4946:	0f 49       	mov	r9,	r15	;
    4948:	b0 12 1e 60 	call	#24606		;#0x601e
    494c:	0d 93       	cmp	#0,	r13	;r3 As==00
    494e:	02 24       	jz	$+6      	;abs 0x4954
    4950:	80 00 68 5a 	mova	#23144,	r0	;0x05a68
    4954:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    4958:	02 20       	jnz	$+6      	;abs 0x495e
    495a:	80 00 6a 5e 	mova	#24170,	r0	;0x05e6a
    495e:	06 48       	mov	r8,	r6	;
    4960:	36 d2       	bis	#8,	r6	;r2 As==11
    4962:	0c 46       	mov	r6,	r12	;
    4964:	0d 49       	mov	r9,	r13	;
    4966:	0e 46       	mov	r6,	r14	;
    4968:	0f 49       	mov	r9,	r15	;
    496a:	b0 12 1e 60 	call	#24606		;#0x601e
    496e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4970:	02 24       	jz	$+6      	;abs 0x4976
    4972:	80 00 32 5a 	mova	#23090,	r0	;0x05a32
    4976:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    497a:	04 20       	jnz	$+10     	;abs 0x4984
    497c:	0a 9c       	cmp	r12,	r10	;
    497e:	02 2c       	jc	$+6      	;abs 0x4984
    4980:	80 00 32 5a 	mova	#23090,	r0	;0x05a32
    4984:	07 46       	mov	r6,	r7	;
    4986:	27 d2       	bis	#4,	r7	;r2 As==10
    4988:	0c 47       	mov	r7,	r12	;
    498a:	0d 49       	mov	r9,	r13	;
    498c:	0e 47       	mov	r7,	r14	;
    498e:	0f 49       	mov	r9,	r15	;
    4990:	b0 12 1e 60 	call	#24606		;#0x601e
    4994:	0d 93       	cmp	#0,	r13	;r3 As==00
    4996:	02 24       	jz	$+6      	;abs 0x499c
    4998:	80 00 2a 5a 	mova	#23082,	r0	;0x05a2a
    499c:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49a0:	04 20       	jnz	$+10     	;abs 0x49aa
    49a2:	0a 9c       	cmp	r12,	r10	;
    49a4:	02 2c       	jc	$+6      	;abs 0x49aa
    49a6:	80 00 2a 5a 	mova	#23082,	r0	;0x05a2a
    49aa:	08 47       	mov	r7,	r8	;
    49ac:	28 d3       	bis	#2,	r8	;r3 As==10
    49ae:	0c 48       	mov	r8,	r12	;
    49b0:	0d 49       	mov	r9,	r13	;
    49b2:	0e 48       	mov	r8,	r14	;
    49b4:	0f 49       	mov	r9,	r15	;
    49b6:	b0 12 1e 60 	call	#24606		;#0x601e
    49ba:	0d 93       	cmp	#0,	r13	;r3 As==00
    49bc:	02 24       	jz	$+6      	;abs 0x49c2
    49be:	80 00 22 5a 	mova	#23074,	r0	;0x05a22
    49c2:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49c6:	04 20       	jnz	$+10     	;abs 0x49d0
    49c8:	0a 9c       	cmp	r12,	r10	;
    49ca:	02 2c       	jc	$+6      	;abs 0x49d0
    49cc:	80 00 22 5a 	mova	#23074,	r0	;0x05a22
    49d0:	07 48       	mov	r8,	r7	;
    49d2:	17 d3       	bis	#1,	r7	;r3 As==01
    49d4:	0c 47       	mov	r7,	r12	;
    49d6:	0d 49       	mov	r9,	r13	;
    49d8:	0e 47       	mov	r7,	r14	;
    49da:	0f 49       	mov	r9,	r15	;
    49dc:	b0 12 1e 60 	call	#24606		;#0x601e
    49e0:	0d 93       	cmp	#0,	r13	;r3 As==00
    49e2:	05 20       	jnz	$+12     	;abs 0x49ee
    49e4:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49e8:	04 20       	jnz	$+10     	;abs 0x49f2
    49ea:	0a 9c       	cmp	r12,	r10	;
    49ec:	02 2c       	jc	$+6      	;abs 0x49f2
    49ee:	07 48       	mov	r8,	r7	;
    49f0:	17 c3       	bic	#1,	r7	;r3 As==01
    49f2:	81 47 1a 00 	mov	r7,	26(r1)	; 0x001a
    49f6:	1a 41 0e 00 	mov	14(r1),	r10	;0x0000e
    49fa:	9a 41 18 00 	mov	24(r1),	0(r10)	;0x00018
    49fe:	00 00 
    4a00:	9a 41 1a 00 	mov	26(r1),	2(r10)	;0x0001a
    4a04:	02 00 
    4a06:	2a 52       	add	#4,	r10	;r2 As==10
    4a08:	81 4a 0e 00 	mov	r10,	14(r1)	; 0x000e
    4a0c:	3c 40 40 1c 	mov	#7232,	r12	;#0x1c40
    4a10:	0c 9a       	cmp	r10,	r12	;
    4a12:	02 24       	jz	$+6      	;abs 0x4a18
    4a14:	80 00 56 43 	mova	#17238,	r0	;0x04356
    4a18:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    4a1c:	b0 12 cc 40 	call	#16588		;#0x40cc
    4a20:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    4a24:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    4a28:	b0 12 20 41 	call	#16672		;#0x4120
    4a2c:	92 43 80 1c 	mov	#1,	&0x1c80	;r3 As==01
    4a30:	b0 12 b0 40 	call	#16560		;#0x40b0
    4a34:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    4a38:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a3c:	0d 4c       	mov	r12,	r13	;
    4a3e:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a40:	5c 03       	rrum	#1,	r12	;
    4a42:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a44:	02 24       	jz	$+6      	;abs 0x4a4a
    4a46:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a4a:	0d 4c       	mov	r12,	r13	;
    4a4c:	5d 03       	rrum	#1,	r13	;
    4a4e:	1c b3       	bit	#1,	r12	;r3 As==01
    4a50:	02 24       	jz	$+6      	;abs 0x4a56
    4a52:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4a56:	0c 4d       	mov	r13,	r12	;
    4a58:	5c 03       	rrum	#1,	r12	;
    4a5a:	1d b3       	bit	#1,	r13	;r3 As==01
    4a5c:	02 24       	jz	$+6      	;abs 0x4a62
    4a5e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a62:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a66:	0d 4c       	mov	r12,	r13	;
    4a68:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a6a:	5c 03       	rrum	#1,	r12	;
    4a6c:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a6e:	02 24       	jz	$+6      	;abs 0x4a74
    4a70:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a74:	0d 4c       	mov	r12,	r13	;
    4a76:	5d 03       	rrum	#1,	r13	;
    4a78:	1c b3       	bit	#1,	r12	;r3 As==01
    4a7a:	02 24       	jz	$+6      	;abs 0x4a80
    4a7c:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4a80:	0c 4d       	mov	r13,	r12	;
    4a82:	5c 03       	rrum	#1,	r12	;
    4a84:	1d b3       	bit	#1,	r13	;r3 As==01
    4a86:	02 24       	jz	$+6      	;abs 0x4a8c
    4a88:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a8c:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a90:	0d 4c       	mov	r12,	r13	;
    4a92:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a94:	5c 03       	rrum	#1,	r12	;
    4a96:	0e 93       	cmp	#0,	r14	;r3 As==00
    4a98:	02 24       	jz	$+6      	;abs 0x4a9e
    4a9a:	80 00 8a 5e 	mova	#24202,	r0	;0x05e8a
    4a9e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4aa0:	02 24       	jz	$+6      	;abs 0x4aa6
    4aa2:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4aa6:	0d 4c       	mov	r12,	r13	;
    4aa8:	5d 03       	rrum	#1,	r13	;
    4aaa:	1c b3       	bit	#1,	r12	;r3 As==01
    4aac:	02 24       	jz	$+6      	;abs 0x4ab2
    4aae:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4ab2:	09 4d       	mov	r13,	r9	;
    4ab4:	59 03       	rrum	#1,	r9	;
    4ab6:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    4aba:	1d b3       	bit	#1,	r13	;r3 As==01
    4abc:	02 24       	jz	$+6      	;abs 0x4ac2
    4abe:	80 00 ea 5e 	mova	#24298,	r0	;0x05eea
    4ac2:	b1 40 40 1c 	mov	#7232,	14(r1)	;#0x1c40, 0x000e
    4ac6:	0e 00 
    4ac8:	44 43       	clr.b	r4		;
    4aca:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4ace:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4ad2:	5c f3       	and.b	#1,	r12	;r3 As==01
    4ad4:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    4ad8:	5a 03       	rrum	#1,	r10	;
    4ada:	0d 93       	cmp	#0,	r13	;r3 As==00
    4adc:	02 20       	jnz	$+6      	;abs 0x4ae2
    4ade:	80 00 ce 5c 	mova	#23758,	r0	;0x05cce
    4ae2:	0c 93       	cmp	#0,	r12	;r3 As==00
    4ae4:	02 24       	jz	$+6      	;abs 0x4aea
    4ae6:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4aea:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4aee:	0c 4a       	mov	r10,	r12	;
    4af0:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4af4:	46 4c       	mov.b	r12,	r6	;
    4af6:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    4afa:	86 11       	sxt	r6		;
    4afc:	08 4a       	mov	r10,	r8	;
    4afe:	58 03       	rrum	#1,	r8	;
    4b00:	1a b3       	bit	#1,	r10	;r3 As==01
    4b02:	02 24       	jz	$+6      	;abs 0x4b08
    4b04:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4b08:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b0c:	0c 48       	mov	r8,	r12	;
    4b0e:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4b12:	4a 4c       	mov.b	r12,	r10	;
    4b14:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    4b18:	8a 11       	sxt	r10		;
    4b1a:	09 48       	mov	r8,	r9	;
    4b1c:	59 03       	rrum	#1,	r9	;
    4b1e:	18 b3       	bit	#1,	r8	;r3 As==01
    4b20:	02 24       	jz	$+6      	;abs 0x4b26
    4b22:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b26:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b2a:	0c 49       	mov	r9,	r12	;
    4b2c:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4b30:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b34:	8c 11       	sxt	r12		;
    4b36:	81 4c 06 00 	mov	r12,	6(r1)	;
    4b3a:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4b3e:	0c 49       	mov	r9,	r12	;
    4b40:	5c f3       	and.b	#1,	r12	;r3 As==01
    4b42:	59 03       	rrum	#1,	r9	;
    4b44:	0d 93       	cmp	#0,	r13	;r3 As==00
    4b46:	02 20       	jnz	$+6      	;abs 0x4b4c
    4b48:	80 00 7e 5c 	mova	#23678,	r0	;0x05c7e
    4b4c:	0c 93       	cmp	#0,	r12	;r3 As==00
    4b4e:	02 24       	jz	$+6      	;abs 0x4b54
    4b50:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b54:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b58:	0c 49       	mov	r9,	r12	;
    4b5a:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4b5e:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b62:	8c 11       	sxt	r12		;
    4b64:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    4b68:	08 49       	mov	r9,	r8	;
    4b6a:	58 03       	rrum	#1,	r8	;
    4b6c:	19 b3       	bit	#1,	r9	;r3 As==01
    4b6e:	02 24       	jz	$+6      	;abs 0x4b74
    4b70:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4b74:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b78:	0c 48       	mov	r8,	r12	;
    4b7a:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4b7e:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b82:	8c 11       	sxt	r12		;
    4b84:	81 4c 10 00 	mov	r12,	16(r1)	; 0x0010
    4b88:	09 48       	mov	r8,	r9	;
    4b8a:	59 03       	rrum	#1,	r9	;
    4b8c:	18 b3       	bit	#1,	r8	;r3 As==01
    4b8e:	02 24       	jz	$+6      	;abs 0x4b94
    4b90:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b94:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b98:	0c 49       	mov	r9,	r12	;
    4b9a:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4b9e:	47 4c       	mov.b	r12,	r7	;
    4ba0:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4ba4:	87 11       	sxt	r7		;
    4ba6:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4baa:	0c 49       	mov	r9,	r12	;
    4bac:	5c f3       	and.b	#1,	r12	;r3 As==01
    4bae:	59 03       	rrum	#1,	r9	;
    4bb0:	0d 93       	cmp	#0,	r13	;r3 As==00
    4bb2:	02 20       	jnz	$+6      	;abs 0x4bb8
    4bb4:	80 00 28 5c 	mova	#23592,	r0	;0x05c28
    4bb8:	0c 93       	cmp	#0,	r12	;r3 As==00
    4bba:	02 24       	jz	$+6      	;abs 0x4bc0
    4bbc:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4bc0:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4bc4:	0c 49       	mov	r9,	r12	;
    4bc6:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4bca:	48 4c       	mov.b	r12,	r8	;
    4bcc:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    4bd0:	88 11       	sxt	r8		;
    4bd2:	05 49       	mov	r9,	r5	;
    4bd4:	55 03       	rrum	#1,	r5	;
    4bd6:	19 b3       	bit	#1,	r9	;r3 As==01
    4bd8:	02 24       	jz	$+6      	;abs 0x4bde
    4bda:	35 e0 00 b4 	xor	#-19456,r5	;#0xb400
    4bde:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4be2:	0c 45       	mov	r5,	r12	;
    4be4:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4be8:	49 4c       	mov.b	r12,	r9	;
    4bea:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    4bee:	89 11       	sxt	r9		;
    4bf0:	0d 45       	mov	r5,	r13	;
    4bf2:	5d 03       	rrum	#1,	r13	;
    4bf4:	81 4d 12 00 	mov	r13,	18(r1)	; 0x0012
    4bf8:	15 b3       	bit	#1,	r5	;r3 As==01
    4bfa:	03 24       	jz	$+8      	;abs 0x4c02
    4bfc:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    4c00:	12 00 
    4c02:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    4c06:	82 1c 
    4c08:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4c0c:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4c10:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    4c14:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4c18:	8c 11       	sxt	r12		;
    4c1a:	0e 46       	mov	r6,	r14	;
    4c1c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c20:	4d 4e       	mov.b	r14,	r13	;
    4c22:	4d e6       	xor.b	r6,	r13	;
    4c24:	4d 8e       	sub.b	r14,	r13	;
    4c26:	7e 40 09 00 	mov.b	#9,	r14	;
    4c2a:	4e 9d       	cmp.b	r13,	r14	;
    4c2c:	02 28       	jnc	$+6      	;abs 0x4c32
    4c2e:	80 00 1c 5c 	mova	#23580,	r0	;0x05c1c
    4c32:	81 46 18 00 	mov	r6,	24(r1)	; 0x0018
    4c36:	05 46       	mov	r6,	r5	;
    4c38:	4e 18 06 11 	rpt #15 { rrax.w	r6		;
    4c3c:	0e 4a       	mov	r10,	r14	;
    4c3e:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c42:	4d 4e       	mov.b	r14,	r13	;
    4c44:	4d ea       	xor.b	r10,	r13	;
    4c46:	4d 8e       	sub.b	r14,	r13	;
    4c48:	7e 40 09 00 	mov.b	#9,	r14	;
    4c4c:	4e 9d       	cmp.b	r13,	r14	;
    4c4e:	02 28       	jnc	$+6      	;abs 0x4c54
    4c50:	80 00 10 5c 	mova	#23568,	r0	;0x05c10
    4c54:	81 4a 1c 00 	mov	r10,	28(r1)	; 0x001c
    4c58:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4c5c:	0b 7b       	subc	r11,	r11	;
    4c5e:	3b e3       	inv	r11		;
    4c60:	1e 41 06 00 	mov	6(r1),	r14	;
    4c64:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c68:	1d 41 06 00 	mov	6(r1),	r13	;
    4c6c:	4d ee       	xor.b	r14,	r13	;
    4c6e:	4d 8e       	sub.b	r14,	r13	;
    4c70:	7e 40 09 00 	mov.b	#9,	r14	;
    4c74:	4e 9d       	cmp.b	r13,	r14	;
    4c76:	02 28       	jnc	$+6      	;abs 0x4c7c
    4c78:	80 00 00 5c 	mova	#23552,	r0	;0x05c00
    4c7c:	1e 41 06 00 	mov	6(r1),	r14	;
    4c80:	0d 4e       	mov	r14,	r13	;
    4c82:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4c86:	81 4d 02 00 	mov	r13,	2(r1)	;
    4c8a:	81 4e 04 00 	mov	r14,	4(r1)	;
    4c8e:	1e 41 0a 00 	mov	10(r1),	r14	;0x0000a
    4c92:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c96:	1d 41 0a 00 	mov	10(r1),	r13	;0x0000a
    4c9a:	4d ee       	xor.b	r14,	r13	;
    4c9c:	4d 8e       	sub.b	r14,	r13	;
    4c9e:	81 44 14 00 	mov	r4,	20(r1)	; 0x0014
    4ca2:	7e 40 09 00 	mov.b	#9,	r14	;
    4ca6:	4e 9d       	cmp.b	r13,	r14	;
    4ca8:	0b 2c       	jc	$+24     	;abs 0x4cc0
    4caa:	91 41 0a 00 	mov	10(r1),	20(r1)	;0x0000a, 0x0014
    4cae:	14 00 
    4cb0:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4cb4:	0e 4d       	mov	r13,	r14	;
    4cb6:	0f 4d       	mov	r13,	r15	;
    4cb8:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4cbc:	05 5e       	add	r14,	r5	;
    4cbe:	06 6f       	addc	r15,	r6	;
    4cc0:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    4cc4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4cc8:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4ccc:	4d ee       	xor.b	r14,	r13	;
    4cce:	4d 8e       	sub.b	r14,	r13	;
    4cd0:	81 44 16 00 	mov	r4,	22(r1)	; 0x0016
    4cd4:	7e 40 09 00 	mov.b	#9,	r14	;
    4cd8:	4e 9d       	cmp.b	r13,	r14	;
    4cda:	0b 2c       	jc	$+24     	;abs 0x4cf2
    4cdc:	91 41 10 00 	mov	16(r1),	22(r1)	;0x00010, 0x0016
    4ce0:	16 00 
    4ce2:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4ce6:	0e 4d       	mov	r13,	r14	;
    4ce8:	0f 4d       	mov	r13,	r15	;
    4cea:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4cee:	0a 5e       	add	r14,	r10	;
    4cf0:	0b 6f       	addc	r15,	r11	;
    4cf2:	0e 47       	mov	r7,	r14	;
    4cf4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4cf8:	4d 4e       	mov.b	r14,	r13	;
    4cfa:	4d e7       	xor.b	r7,	r13	;
    4cfc:	4d 8e       	sub.b	r14,	r13	;
    4cfe:	81 44 10 00 	mov	r4,	16(r1)	; 0x0010
    4d02:	7e 40 09 00 	mov.b	#9,	r14	;
    4d06:	4e 9d       	cmp.b	r13,	r14	;
    4d08:	10 2c       	jc	$+34     	;abs 0x4d2a
    4d0a:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    4d0e:	0d 47       	mov	r7,	r13	;
    4d10:	0e 47       	mov	r7,	r14	;
    4d12:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4d16:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    4d1a:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    4d1e:	91 51 0a 00 	rla	10(r1)		;#0x0000a
    4d22:	02 00 
    4d24:	91 61 0c 00 	rlc	12(r1)		;#0x0000c
    4d28:	04 00 
    4d2a:	0e 48       	mov	r8,	r14	;
    4d2c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4d30:	4d 4e       	mov.b	r14,	r13	;
    4d32:	4d e8       	xor.b	r8,	r13	;
    4d34:	4d 8e       	sub.b	r14,	r13	;
    4d36:	7e 40 09 00 	mov.b	#9,	r14	;
    4d3a:	4e 9d       	cmp.b	r13,	r14	;
    4d3c:	02 28       	jnc	$+6      	;abs 0x4d42
    4d3e:	80 00 f0 5b 	mova	#23536,	r0	;0x05bf0
    4d42:	81 48 22 00 	mov	r8,	34(r1)	; 0x0022
    4d46:	0d 48       	mov	r8,	r13	;
    4d48:	0e 48       	mov	r8,	r14	;
    4d4a:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4d4e:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    4d52:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    4d56:	0e 49       	mov	r9,	r14	;
    4d58:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4d5c:	4d 4e       	mov.b	r14,	r13	;
    4d5e:	4d e9       	xor.b	r9,	r13	;
    4d60:	4d 8e       	sub.b	r14,	r13	;
    4d62:	7e 40 09 00 	mov.b	#9,	r14	;
    4d66:	4e 9d       	cmp.b	r13,	r14	;
    4d68:	02 28       	jnc	$+6      	;abs 0x4d6e
    4d6a:	80 00 e4 5b 	mova	#23524,	r0	;0x05be4
    4d6e:	81 49 24 00 	mov	r9,	36(r1)	; 0x0024
    4d72:	0e 49       	mov	r9,	r14	;
    4d74:	0f 49       	mov	r9,	r15	;
    4d76:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4d7a:	09 4c       	mov	r12,	r9	;
    4d7c:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    4d80:	4d 49       	mov.b	r9,	r13	;
    4d82:	4d ec       	xor.b	r12,	r13	;
    4d84:	4d 89       	sub.b	r9,	r13	;
    4d86:	79 40 09 00 	mov.b	#9,	r9	;
    4d8a:	49 9d       	cmp.b	r13,	r9	;
    4d8c:	02 28       	jnc	$+6      	;abs 0x4d92
    4d8e:	80 00 d8 5b 	mova	#23512,	r0	;0x05bd8
    4d92:	81 4c 26 00 	mov	r12,	38(r1)	; 0x0026
    4d96:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4d9a:	0d 7d       	subc	r13,	r13	;
    4d9c:	3d e3       	inv	r13		;
    4d9e:	08 4e       	mov	r14,	r8	;
    4da0:	08 5a       	add	r10,	r8	;
    4da2:	09 4f       	mov	r15,	r9	;
    4da4:	09 6b       	addc	r11,	r9	;
    4da6:	0a 4c       	mov	r12,	r10	;
    4da8:	1a 51 02 00 	add	2(r1),	r10	;
    4dac:	17 41 04 00 	mov	4(r1),	r7	;
    4db0:	07 6d       	addc	r13,	r7	;
    4db2:	7e 40 03 00 	mov.b	#3,	r14	;
    4db6:	4f 43       	clr.b	r15		;
    4db8:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    4dbc:	0c 55       	add	r5,	r12	;
    4dbe:	1d 41 0c 00 	mov	12(r1),	r13	;0x0000c
    4dc2:	0d 66       	addc	r6,	r13	;
    4dc4:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4dc8:	81 4c 02 00 	mov	r12,	2(r1)	;
    4dcc:	7e 40 03 00 	mov.b	#3,	r14	;
    4dd0:	4f 43       	clr.b	r15		;
    4dd2:	0c 48       	mov	r8,	r12	;
    4dd4:	0d 49       	mov	r9,	r13	;
    4dd6:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4dda:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    4dde:	7e 40 03 00 	mov.b	#3,	r14	;
    4de2:	4f 43       	clr.b	r15		;
    4de4:	0c 4a       	mov	r10,	r12	;
    4de6:	0d 47       	mov	r7,	r13	;
    4de8:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4dec:	05 4c       	mov	r12,	r5	;
    4dee:	16 41 18 00 	mov	24(r1),	r6	;0x00018
    4df2:	16 81 02 00 	sub	2(r1),	r6	;
    4df6:	0c 46       	mov	r6,	r12	;
    4df8:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    4dfc:	06 ec       	xor	r12,	r6	;
    4dfe:	0e 46       	mov	r6,	r14	;
    4e00:	0e 8c       	sub	r12,	r14	;
    4e02:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4e06:	0f 7f       	subc	r15,	r15	;
    4e08:	3f e3       	inv	r15		;
    4e0a:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    4e0e:	1c 81 02 00 	sub	2(r1),	r12	;
    4e12:	0d 4c       	mov	r12,	r13	;
    4e14:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4e18:	0c ed       	xor	r13,	r12	;
    4e1a:	0c 8d       	sub	r13,	r12	;
    4e1c:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4e20:	0d 7d       	subc	r13,	r13	;
    4e22:	3d e3       	inv	r13		;
    4e24:	0c 5e       	add	r14,	r12	;
    4e26:	0a 4f       	mov	r15,	r10	;
    4e28:	0a 6d       	addc	r13,	r10	;
    4e2a:	81 4a 14 00 	mov	r10,	20(r1)	; 0x0014
    4e2e:	1a 41 1c 00 	mov	28(r1),	r10	;0x0001c
    4e32:	1a 81 0a 00 	sub	10(r1),	r10	;0x0000a
    4e36:	0d 4a       	mov	r10,	r13	;
    4e38:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4e3c:	0a ed       	xor	r13,	r10	;
    4e3e:	0a 8d       	sub	r13,	r10	;
    4e40:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4e44:	0b 7b       	subc	r11,	r11	;
    4e46:	3b e3       	inv	r11		;
    4e48:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4e4c:	1d 81 0a 00 	sub	10(r1),	r13	;0x0000a
    4e50:	0f 4d       	mov	r13,	r15	;
    4e52:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4e56:	0d ef       	xor	r15,	r13	;
    4e58:	0e 4d       	mov	r13,	r14	;
    4e5a:	0e 8f       	sub	r15,	r14	;
    4e5c:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4e60:	0f 7f       	subc	r15,	r15	;
    4e62:	3f e3       	inv	r15		;
    4e64:	09 4a       	mov	r10,	r9	;
    4e66:	09 5e       	add	r14,	r9	;
    4e68:	08 4b       	mov	r11,	r8	;
    4e6a:	08 6f       	addc	r15,	r8	;
    4e6c:	1d 41 06 00 	mov	6(r1),	r13	;
    4e70:	0d 85       	sub	r5,	r13	;
    4e72:	0e 4d       	mov	r13,	r14	;
    4e74:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4e78:	0d ee       	xor	r14,	r13	;
    4e7a:	0a 4d       	mov	r13,	r10	;
    4e7c:	0a 8e       	sub	r14,	r10	;
    4e7e:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4e82:	0b 7b       	subc	r11,	r11	;
    4e84:	3b e3       	inv	r11		;
    4e86:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4e8a:	0d 85       	sub	r5,	r13	;
    4e8c:	0f 4d       	mov	r13,	r15	;
    4e8e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4e92:	0d ef       	xor	r15,	r13	;
    4e94:	0e 4d       	mov	r13,	r14	;
    4e96:	0e 8f       	sub	r15,	r14	;
    4e98:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4e9c:	0f 7f       	subc	r15,	r15	;
    4e9e:	3f e3       	inv	r15		;
    4ea0:	07 4a       	mov	r10,	r7	;
    4ea2:	07 5e       	add	r14,	r7	;
    4ea4:	0d 4b       	mov	r11,	r13	;
    4ea6:	0d 6f       	addc	r15,	r13	;
    4ea8:	1e 41 22 00 	mov	34(r1),	r14	;0x00022
    4eac:	1e 81 02 00 	sub	2(r1),	r14	;
    4eb0:	0f 4e       	mov	r14,	r15	;
    4eb2:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4eb6:	0e ef       	xor	r15,	r14	;
    4eb8:	0a 4e       	mov	r14,	r10	;
    4eba:	0a 8f       	sub	r15,	r10	;
    4ebc:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4ec0:	0b 7b       	subc	r11,	r11	;
    4ec2:	3b e3       	inv	r11		;
    4ec4:	1e 41 24 00 	mov	36(r1),	r14	;0x00024
    4ec8:	1e 81 0a 00 	sub	10(r1),	r14	;0x0000a
    4ecc:	0f 4e       	mov	r14,	r15	;
    4ece:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4ed2:	0e ef       	xor	r15,	r14	;
    4ed4:	0e 8f       	sub	r15,	r14	;
    4ed6:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4eda:	0f 7f       	subc	r15,	r15	;
    4edc:	3f e3       	inv	r15		;
    4ede:	09 5e       	add	r14,	r9	;
    4ee0:	08 6f       	addc	r15,	r8	;
    4ee2:	1e 41 26 00 	mov	38(r1),	r14	;0x00026
    4ee6:	0e 85       	sub	r5,	r14	;
    4ee8:	0f 4e       	mov	r14,	r15	;
    4eea:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4eee:	0e ef       	xor	r15,	r14	;
    4ef0:	0e 8f       	sub	r15,	r14	;
    4ef2:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4ef6:	0f 7f       	subc	r15,	r15	;
    4ef8:	3f e3       	inv	r15		;
    4efa:	07 5e       	add	r14,	r7	;
    4efc:	06 4f       	mov	r15,	r6	;
    4efe:	06 6d       	addc	r13,	r6	;
    4f00:	7e 40 03 00 	mov.b	#3,	r14	;
    4f04:	4f 43       	clr.b	r15		;
    4f06:	0c 5a       	add	r10,	r12	;
    4f08:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4f0c:	0d 6b       	addc	r11,	r13	;
    4f0e:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4f12:	0a 4c       	mov	r12,	r10	;
    4f14:	7e 40 03 00 	mov.b	#3,	r14	;
    4f18:	4f 43       	clr.b	r15		;
    4f1a:	0c 49       	mov	r9,	r12	;
    4f1c:	0d 48       	mov	r8,	r13	;
    4f1e:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4f22:	09 4c       	mov	r12,	r9	;
    4f24:	7e 40 03 00 	mov.b	#3,	r14	;
    4f28:	4f 43       	clr.b	r15		;
    4f2a:	0c 47       	mov	r7,	r12	;
    4f2c:	0d 46       	mov	r6,	r13	;
    4f2e:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    4f32:	08 4c       	mov	r12,	r8	;
    4f34:	0c 4a       	mov	r10,	r12	;
    4f36:	0d 4a       	mov	r10,	r13	;
    4f38:	b0 12 0a 60 	call	#24586		;#0x600a
    4f3c:	0a 4c       	mov	r12,	r10	;
    4f3e:	0c 49       	mov	r9,	r12	;
    4f40:	0d 49       	mov	r9,	r13	;
    4f42:	b0 12 0a 60 	call	#24586		;#0x600a
    4f46:	0a 5c       	add	r12,	r10	;
    4f48:	0c 48       	mov	r8,	r12	;
    4f4a:	0d 48       	mov	r8,	r13	;
    4f4c:	b0 12 0a 60 	call	#24586		;#0x600a
    4f50:	0a 5c       	add	r12,	r10	;
    4f52:	1c 41 02 00 	mov	2(r1),	r12	;
    4f56:	0d 4c       	mov	r12,	r13	;
    4f58:	b0 12 0a 60 	call	#24586		;#0x600a
    4f5c:	07 4c       	mov	r12,	r7	;
    4f5e:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    4f62:	0d 4c       	mov	r12,	r13	;
    4f64:	b0 12 0a 60 	call	#24586		;#0x600a
    4f68:	07 5c       	add	r12,	r7	;
    4f6a:	0c 45       	mov	r5,	r12	;
    4f6c:	0d 45       	mov	r5,	r13	;
    4f6e:	b0 12 0a 60 	call	#24586		;#0x600a
    4f72:	07 5c       	add	r12,	r7	;
    4f74:	08 47       	mov	r7,	r8	;
    4f76:	09 43       	clr	r9		;
    4f78:	76 40 80 00 	mov.b	#128,	r6	;#0x0080
    4f7c:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    4f80:	0c 97       	cmp	r7,	r12	;
    4f82:	01 28       	jnc	$+4      	;abs 0x4f86
    4f84:	06 44       	mov	r4,	r6	;
    4f86:	05 46       	mov	r6,	r5	;
    4f88:	35 d0 40 00 	bis	#64,	r5	;#0x0040
    4f8c:	0c 45       	mov	r5,	r12	;
    4f8e:	0d 44       	mov	r4,	r13	;
    4f90:	0e 45       	mov	r5,	r14	;
    4f92:	0f 44       	mov	r4,	r15	;
    4f94:	b0 12 1e 60 	call	#24606		;#0x601e
    4f98:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f9a:	04 20       	jnz	$+10     	;abs 0x4fa4
    4f9c:	09 93       	cmp	#0,	r9	;r3 As==00
    4f9e:	05 20       	jnz	$+12     	;abs 0x4faa
    4fa0:	07 9c       	cmp	r12,	r7	;
    4fa2:	03 2c       	jc	$+8      	;abs 0x4faa
    4fa4:	05 46       	mov	r6,	r5	;
    4fa6:	35 f0 bf ff 	and	#-65,	r5	;#0xffbf
    4faa:	06 45       	mov	r5,	r6	;
    4fac:	36 d0 20 00 	bis	#32,	r6	;#0x0020
    4fb0:	0c 46       	mov	r6,	r12	;
    4fb2:	0d 44       	mov	r4,	r13	;
    4fb4:	0e 46       	mov	r6,	r14	;
    4fb6:	0f 44       	mov	r4,	r15	;
    4fb8:	b0 12 1e 60 	call	#24606		;#0x601e
    4fbc:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fbe:	04 20       	jnz	$+10     	;abs 0x4fc8
    4fc0:	09 93       	cmp	#0,	r9	;r3 As==00
    4fc2:	05 20       	jnz	$+12     	;abs 0x4fce
    4fc4:	07 9c       	cmp	r12,	r7	;
    4fc6:	03 2c       	jc	$+8      	;abs 0x4fce
    4fc8:	06 45       	mov	r5,	r6	;
    4fca:	36 f0 df ff 	and	#-33,	r6	;#0xffdf
    4fce:	05 46       	mov	r6,	r5	;
    4fd0:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4fd4:	0c 45       	mov	r5,	r12	;
    4fd6:	0d 44       	mov	r4,	r13	;
    4fd8:	0e 45       	mov	r5,	r14	;
    4fda:	0f 44       	mov	r4,	r15	;
    4fdc:	b0 12 1e 60 	call	#24606		;#0x601e
    4fe0:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fe2:	04 20       	jnz	$+10     	;abs 0x4fec
    4fe4:	09 93       	cmp	#0,	r9	;r3 As==00
    4fe6:	05 20       	jnz	$+12     	;abs 0x4ff2
    4fe8:	07 9c       	cmp	r12,	r7	;
    4fea:	03 2c       	jc	$+8      	;abs 0x4ff2
    4fec:	05 46       	mov	r6,	r5	;
    4fee:	35 f0 ef ff 	and	#-17,	r5	;#0xffef
    4ff2:	06 45       	mov	r5,	r6	;
    4ff4:	36 d2       	bis	#8,	r6	;r2 As==11
    4ff6:	0c 46       	mov	r6,	r12	;
    4ff8:	0d 44       	mov	r4,	r13	;
    4ffa:	0e 46       	mov	r6,	r14	;
    4ffc:	0f 44       	mov	r4,	r15	;
    4ffe:	b0 12 1e 60 	call	#24606		;#0x601e
    5002:	0d 93       	cmp	#0,	r13	;r3 As==00
    5004:	02 24       	jz	$+6      	;abs 0x500a
    5006:	80 00 fa 5a 	mova	#23290,	r0	;0x05afa
    500a:	09 93       	cmp	#0,	r9	;r3 As==00
    500c:	04 20       	jnz	$+10     	;abs 0x5016
    500e:	07 9c       	cmp	r12,	r7	;
    5010:	02 2c       	jc	$+6      	;abs 0x5016
    5012:	80 00 fa 5a 	mova	#23290,	r0	;0x05afa
    5016:	05 46       	mov	r6,	r5	;
    5018:	25 d2       	bis	#4,	r5	;r2 As==10
    501a:	0c 45       	mov	r5,	r12	;
    501c:	0d 44       	mov	r4,	r13	;
    501e:	0e 45       	mov	r5,	r14	;
    5020:	0f 44       	mov	r4,	r15	;
    5022:	b0 12 1e 60 	call	#24606		;#0x601e
    5026:	0d 93       	cmp	#0,	r13	;r3 As==00
    5028:	02 24       	jz	$+6      	;abs 0x502e
    502a:	80 00 f2 5a 	mova	#23282,	r0	;0x05af2
    502e:	09 93       	cmp	#0,	r9	;r3 As==00
    5030:	04 20       	jnz	$+10     	;abs 0x503a
    5032:	07 9c       	cmp	r12,	r7	;
    5034:	02 2c       	jc	$+6      	;abs 0x503a
    5036:	80 00 f2 5a 	mova	#23282,	r0	;0x05af2
    503a:	06 45       	mov	r5,	r6	;
    503c:	26 d3       	bis	#2,	r6	;r3 As==10
    503e:	0c 46       	mov	r6,	r12	;
    5040:	0d 44       	mov	r4,	r13	;
    5042:	0e 46       	mov	r6,	r14	;
    5044:	0f 44       	mov	r4,	r15	;
    5046:	b0 12 1e 60 	call	#24606		;#0x601e
    504a:	0d 93       	cmp	#0,	r13	;r3 As==00
    504c:	02 24       	jz	$+6      	;abs 0x5052
    504e:	80 00 ea 5a 	mova	#23274,	r0	;0x05aea
    5052:	09 93       	cmp	#0,	r9	;r3 As==00
    5054:	04 20       	jnz	$+10     	;abs 0x505e
    5056:	07 9c       	cmp	r12,	r7	;
    5058:	02 2c       	jc	$+6      	;abs 0x505e
    505a:	80 00 ea 5a 	mova	#23274,	r0	;0x05aea
    505e:	05 46       	mov	r6,	r5	;
    5060:	15 d3       	bis	#1,	r5	;r3 As==01
    5062:	0c 45       	mov	r5,	r12	;
    5064:	0d 44       	mov	r4,	r13	;
    5066:	0e 45       	mov	r5,	r14	;
    5068:	0f 44       	mov	r4,	r15	;
    506a:	b0 12 1e 60 	call	#24606		;#0x601e
    506e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5070:	02 24       	jz	$+6      	;abs 0x5076
    5072:	80 00 b4 5a 	mova	#23220,	r0	;0x05ab4
    5076:	09 93       	cmp	#0,	r9	;r3 As==00
    5078:	04 20       	jnz	$+10     	;abs 0x5082
    507a:	07 9c       	cmp	r12,	r7	;
    507c:	02 2c       	jc	$+6      	;abs 0x5082
    507e:	80 00 b4 5a 	mova	#23220,	r0	;0x05ab4
    5082:	81 45 1e 00 	mov	r5,	30(r1)	; 0x001e
    5086:	0d 4a       	mov	r10,	r13	;
    5088:	0e 43       	clr	r14		;
    508a:	81 4d 06 00 	mov	r13,	6(r1)	;
    508e:	81 4e 08 00 	mov	r14,	8(r1)	;
    5092:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    5096:	0e 9a       	cmp	r10,	r14	;
    5098:	02 2c       	jc	$+6      	;abs 0x509e
    509a:	80 00 d4 5a 	mova	#23252,	r0	;0x05ad4
    509e:	39 40 ff 03 	mov	#1023,	r9	;#0x03ff
    50a2:	78 40 20 00 	mov.b	#32,	r8	;#0x0020
    50a6:	09 9a       	cmp	r10,	r9	;
    50a8:	02 28       	jnc	$+6      	;abs 0x50ae
    50aa:	80 00 ce 5b 	mova	#23502,	r0	;0x05bce
    50ae:	09 44       	mov	r4,	r9	;
    50b0:	38 d0 10 00 	bis	#16,	r8	;#0x0010
    50b4:	0c 48       	mov	r8,	r12	;
    50b6:	0d 49       	mov	r9,	r13	;
    50b8:	0e 48       	mov	r8,	r14	;
    50ba:	0f 49       	mov	r9,	r15	;
    50bc:	b0 12 1e 60 	call	#24606		;#0x601e
    50c0:	0d 93       	cmp	#0,	r13	;r3 As==00
    50c2:	02 24       	jz	$+6      	;abs 0x50c8
    50c4:	80 00 e2 5a 	mova	#23266,	r0	;0x05ae2
    50c8:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    50cc:	02 20       	jnz	$+6      	;abs 0x50d2
    50ce:	80 00 7a 5e 	mova	#24186,	r0	;0x05e7a
    50d2:	06 48       	mov	r8,	r6	;
    50d4:	36 d2       	bis	#8,	r6	;r2 As==11
    50d6:	0c 46       	mov	r6,	r12	;
    50d8:	0d 49       	mov	r9,	r13	;
    50da:	0e 46       	mov	r6,	r14	;
    50dc:	0f 49       	mov	r9,	r15	;
    50de:	b0 12 1e 60 	call	#24606		;#0x601e
    50e2:	0d 93       	cmp	#0,	r13	;r3 As==00
    50e4:	02 24       	jz	$+6      	;abs 0x50ea
    50e6:	80 00 ac 5a 	mova	#23212,	r0	;0x05aac
    50ea:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    50ee:	04 20       	jnz	$+10     	;abs 0x50f8
    50f0:	0a 9c       	cmp	r12,	r10	;
    50f2:	02 2c       	jc	$+6      	;abs 0x50f8
    50f4:	80 00 ac 5a 	mova	#23212,	r0	;0x05aac
    50f8:	07 46       	mov	r6,	r7	;
    50fa:	27 d2       	bis	#4,	r7	;r2 As==10
    50fc:	0c 47       	mov	r7,	r12	;
    50fe:	0d 49       	mov	r9,	r13	;
    5100:	0e 47       	mov	r7,	r14	;
    5102:	0f 49       	mov	r9,	r15	;
    5104:	b0 12 1e 60 	call	#24606		;#0x601e
    5108:	0d 93       	cmp	#0,	r13	;r3 As==00
    510a:	02 24       	jz	$+6      	;abs 0x5110
    510c:	80 00 88 5a 	mova	#23176,	r0	;0x05a88
    5110:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    5114:	04 20       	jnz	$+10     	;abs 0x511e
    5116:	0a 9c       	cmp	r12,	r10	;
    5118:	02 2c       	jc	$+6      	;abs 0x511e
    511a:	80 00 88 5a 	mova	#23176,	r0	;0x05a88
    511e:	08 47       	mov	r7,	r8	;
    5120:	28 d3       	bis	#2,	r8	;r3 As==10
    5122:	0c 48       	mov	r8,	r12	;
    5124:	0d 49       	mov	r9,	r13	;
    5126:	0e 48       	mov	r8,	r14	;
    5128:	0f 49       	mov	r9,	r15	;
    512a:	b0 12 1e 60 	call	#24606		;#0x601e
    512e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5130:	02 24       	jz	$+6      	;abs 0x5136
    5132:	80 00 a4 5a 	mova	#23204,	r0	;0x05aa4
    5136:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    513a:	04 20       	jnz	$+10     	;abs 0x5144
    513c:	0a 9c       	cmp	r12,	r10	;
    513e:	02 2c       	jc	$+6      	;abs 0x5144
    5140:	80 00 a4 5a 	mova	#23204,	r0	;0x05aa4
    5144:	07 48       	mov	r8,	r7	;
    5146:	17 d3       	bis	#1,	r7	;r3 As==01
    5148:	0c 47       	mov	r7,	r12	;
    514a:	0d 49       	mov	r9,	r13	;
    514c:	0e 47       	mov	r7,	r14	;
    514e:	0f 49       	mov	r9,	r15	;
    5150:	b0 12 1e 60 	call	#24606		;#0x601e
    5154:	0d 93       	cmp	#0,	r13	;r3 As==00
    5156:	05 20       	jnz	$+12     	;abs 0x5162
    5158:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    515c:	04 20       	jnz	$+10     	;abs 0x5166
    515e:	0a 9c       	cmp	r12,	r10	;
    5160:	02 2c       	jc	$+6      	;abs 0x5166
    5162:	07 48       	mov	r8,	r7	;
    5164:	17 c3       	bic	#1,	r7	;r3 As==01
    5166:	81 47 20 00 	mov	r7,	32(r1)	; 0x0020
    516a:	1a 41 0e 00 	mov	14(r1),	r10	;0x0000e
    516e:	9a 41 1e 00 	mov	30(r1),	0(r10)	;0x0001e
    5172:	00 00 
    5174:	9a 41 20 00 	mov	32(r1),	2(r10)	;0x00020
    5178:	02 00 
    517a:	2a 52       	add	#4,	r10	;r2 As==10
    517c:	81 4a 0e 00 	mov	r10,	14(r1)	; 0x000e
    5180:	3c 40 80 1c 	mov	#7296,	r12	;#0x1c80
    5184:	0c 9a       	cmp	r10,	r12	;
    5186:	02 24       	jz	$+6      	;abs 0x518c
    5188:	80 00 ca 4a 	mova	#19146,	r0	;0x04aca
    518c:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    5190:	b0 12 cc 40 	call	#16588		;#0x40cc
    5194:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    5198:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    519c:	b0 12 20 41 	call	#16672		;#0x4120
    51a0:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    51a4:	b0 12 b0 40 	call	#16560		;#0x40b0
    51a8:	81 43 2a 00 	mov	#0,	42(r1)	;r3 As==00, 0x002a
    51ac:	81 43 2c 00 	mov	#0,	44(r1)	;r3 As==00, 0x002c
    51b0:	81 43 2e 00 	mov	#0,	46(r1)	;r3 As==00, 0x002e
    51b4:	91 42 82 1c 	mov	&0x1c82,18(r1)	;0x1c82, 0x0012
    51b8:	12 00 
    51ba:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    51be:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    51c2:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    51c6:	5c f3       	and.b	#1,	r12	;r3 As==01
    51c8:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    51cc:	5a 03       	rrum	#1,	r10	;
    51ce:	0d 93       	cmp	#0,	r13	;r3 As==00
    51d0:	02 20       	jnz	$+6      	;abs 0x51d6
    51d2:	80 00 bc 58 	mova	#22716,	r0	;0x058bc
    51d6:	0c 93       	cmp	#0,	r12	;r3 As==00
    51d8:	02 24       	jz	$+6      	;abs 0x51de
    51da:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    51de:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    51e2:	0c 4a       	mov	r10,	r12	;
    51e4:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    51e8:	45 4c       	mov.b	r12,	r5	;
    51ea:	75 50 e2 ff 	add.b	#-30,	r5	;#0xffe2
    51ee:	85 11       	sxt	r5		;
    51f0:	08 4a       	mov	r10,	r8	;
    51f2:	58 03       	rrum	#1,	r8	;
    51f4:	1a b3       	bit	#1,	r10	;r3 As==01
    51f6:	02 24       	jz	$+6      	;abs 0x51fc
    51f8:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    51fc:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5200:	0c 48       	mov	r8,	r12	;
    5202:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    5206:	4a 4c       	mov.b	r12,	r10	;
    5208:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    520c:	8a 11       	sxt	r10		;
    520e:	09 48       	mov	r8,	r9	;
    5210:	59 03       	rrum	#1,	r9	;
    5212:	18 b3       	bit	#1,	r8	;r3 As==01
    5214:	02 24       	jz	$+6      	;abs 0x521a
    5216:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    521a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    521e:	0c 49       	mov	r9,	r12	;
    5220:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    5224:	44 4c       	mov.b	r12,	r4	;
    5226:	74 50 e2 ff 	add.b	#-30,	r4	;#0xffe2
    522a:	84 11       	sxt	r4		;
    522c:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5230:	0c 49       	mov	r9,	r12	;
    5232:	5c f3       	and.b	#1,	r12	;r3 As==01
    5234:	59 03       	rrum	#1,	r9	;
    5236:	0d 93       	cmp	#0,	r13	;r3 As==00
    5238:	02 20       	jnz	$+6      	;abs 0x523e
    523a:	80 00 12 59 	mova	#22802,	r0	;0x05912
    523e:	0c 93       	cmp	#0,	r12	;r3 As==00
    5240:	02 24       	jz	$+6      	;abs 0x5246
    5242:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5246:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    524a:	0c 49       	mov	r9,	r12	;
    524c:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    5250:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    5254:	8c 11       	sxt	r12		;
    5256:	81 4c 0e 00 	mov	r12,	14(r1)	; 0x000e
    525a:	08 49       	mov	r9,	r8	;
    525c:	58 03       	rrum	#1,	r8	;
    525e:	19 b3       	bit	#1,	r9	;r3 As==01
    5260:	02 24       	jz	$+6      	;abs 0x5266
    5262:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    5266:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    526a:	0c 48       	mov	r8,	r12	;
    526c:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    5270:	47 4c       	mov.b	r12,	r7	;
    5272:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    5276:	87 11       	sxt	r7		;
    5278:	09 48       	mov	r8,	r9	;
    527a:	59 03       	rrum	#1,	r9	;
    527c:	18 b3       	bit	#1,	r8	;r3 As==01
    527e:	02 24       	jz	$+6      	;abs 0x5284
    5280:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5284:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5288:	0c 49       	mov	r9,	r12	;
    528a:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    528e:	48 4c       	mov.b	r12,	r8	;
    5290:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    5294:	88 11       	sxt	r8		;
    5296:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    529a:	0c 49       	mov	r9,	r12	;
    529c:	5c f3       	and.b	#1,	r12	;r3 As==01
    529e:	59 03       	rrum	#1,	r9	;
    52a0:	0d 93       	cmp	#0,	r13	;r3 As==00
    52a2:	02 20       	jnz	$+6      	;abs 0x52a8
    52a4:	80 00 6c 59 	mova	#22892,	r0	;0x0596c
    52a8:	0c 93       	cmp	#0,	r12	;r3 As==00
    52aa:	02 24       	jz	$+6      	;abs 0x52b0
    52ac:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    52b0:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52b4:	0c 49       	mov	r9,	r12	;
    52b6:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    52ba:	46 4c       	mov.b	r12,	r6	;
    52bc:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    52c0:	86 11       	sxt	r6		;
    52c2:	0e 49       	mov	r9,	r14	;
    52c4:	5e 03       	rrum	#1,	r14	;
    52c6:	19 b3       	bit	#1,	r9	;r3 As==01
    52c8:	02 24       	jz	$+6      	;abs 0x52ce
    52ca:	3e e0 00 b4 	xor	#-19456,r14	;#0xb400
    52ce:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52d2:	0c 4e       	mov	r14,	r12	;
    52d4:	81 4e 00 00 	mov	r14,	0(r1)	;
    52d8:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    52dc:	49 4c       	mov.b	r12,	r9	;
    52de:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    52e2:	89 11       	sxt	r9		;
    52e4:	2e 41       	mov	@r1,	r14	;
    52e6:	0c 4e       	mov	r14,	r12	;
    52e8:	5c 03       	rrum	#1,	r12	;
    52ea:	81 4c 12 00 	mov	r12,	18(r1)	; 0x0012
    52ee:	1e b3       	bit	#1,	r14	;r3 As==01
    52f0:	03 24       	jz	$+8      	;abs 0x52f8
    52f2:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    52f6:	12 00 
    52f8:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52fc:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5300:	b0 12 3a 5f 	call	#24378		;#0x5f3a
    5304:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    5308:	8c 11       	sxt	r12		;
    530a:	0e 45       	mov	r5,	r14	;
    530c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5310:	4d 4e       	mov.b	r14,	r13	;
    5312:	4d e5       	xor.b	r5,	r13	;
    5314:	4d 8e       	sub.b	r14,	r13	;
    5316:	7e 40 09 00 	mov.b	#9,	r14	;
    531a:	4e 9d       	cmp.b	r13,	r14	;
    531c:	02 28       	jnc	$+6      	;abs 0x5322
    531e:	80 00 d0 59 	mova	#22992,	r0	;0x059d0
    5322:	81 45 14 00 	mov	r5,	20(r1)	; 0x0014
    5326:	0d 45       	mov	r5,	r13	;
    5328:	0e 45       	mov	r5,	r14	;
    532a:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    532e:	81 4d 06 00 	mov	r13,	6(r1)	;
    5332:	81 4e 08 00 	mov	r14,	8(r1)	;
    5336:	0e 4a       	mov	r10,	r14	;
    5338:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    533c:	4d 4e       	mov.b	r14,	r13	;
    533e:	4d ea       	xor.b	r10,	r13	;
    5340:	4d 8e       	sub.b	r14,	r13	;
    5342:	7e 40 09 00 	mov.b	#9,	r14	;
    5346:	4e 9d       	cmp.b	r13,	r14	;
    5348:	02 28       	jnc	$+6      	;abs 0x534e
    534a:	80 00 f4 59 	mova	#23028,	r0	;0x059f4
    534e:	81 4a 16 00 	mov	r10,	22(r1)	; 0x0016
    5352:	0d 4a       	mov	r10,	r13	;
    5354:	0e 4a       	mov	r10,	r14	;
    5356:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    535a:	81 4d 02 00 	mov	r13,	2(r1)	;
    535e:	81 4e 04 00 	mov	r14,	4(r1)	;
    5362:	0e 44       	mov	r4,	r14	;
    5364:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5368:	4d 44       	mov.b	r4,	r13	;
    536a:	4d ee       	xor.b	r14,	r13	;
    536c:	4d 8e       	sub.b	r14,	r13	;
    536e:	7a 40 09 00 	mov.b	#9,	r10	;
    5372:	4a 9d       	cmp.b	r13,	r10	;
    5374:	02 28       	jnc	$+6      	;abs 0x537a
    5376:	80 00 18 5a 	mova	#23064,	r0	;0x05a18
    537a:	0a 44       	mov	r4,	r10	;
    537c:	0b 44       	mov	r4,	r11	;
    537e:	4e 18 0b 11 	rpt #15 { rrax.w	r11		;
    5382:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    5386:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    538a:	1d 41 0e 00 	mov	14(r1),	r13	;0x0000e
    538e:	4d ee       	xor.b	r14,	r13	;
    5390:	4d 8e       	sub.b	r14,	r13	;
    5392:	81 43 10 00 	mov	#0,	16(r1)	;r3 As==00, 0x0010
    5396:	7e 40 09 00 	mov.b	#9,	r14	;
    539a:	4e 9d       	cmp.b	r13,	r14	;
    539c:	12 2c       	jc	$+38     	;abs 0x53c2
    539e:	91 41 0e 00 	mov	14(r1),	16(r1)	;0x0000e, 0x0010
    53a2:	10 00 
    53a4:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    53a8:	0d 4e       	mov	r14,	r13	;
    53aa:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    53ae:	81 4d 18 00 	mov	r13,	24(r1)	; 0x0018
    53b2:	81 4e 1a 00 	mov	r14,	26(r1)	; 0x001a
    53b6:	91 51 18 00 	rla	24(r1)		;#0x00018
    53ba:	06 00 
    53bc:	91 61 1a 00 	rlc	26(r1)		;#0x0001a
    53c0:	08 00 
    53c2:	0e 47       	mov	r7,	r14	;
    53c4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    53c8:	4d 4e       	mov.b	r14,	r13	;
    53ca:	4d e7       	xor.b	r7,	r13	;
    53cc:	4d 8e       	sub.b	r14,	r13	;
    53ce:	45 43       	clr.b	r5		;
    53d0:	7e 40 09 00 	mov.b	#9,	r14	;
    53d4:	4e 9d       	cmp.b	r13,	r14	;
    53d6:	0f 2c       	jc	$+32     	;abs 0x53f6
    53d8:	05 47       	mov	r7,	r5	;
    53da:	0d 47       	mov	r7,	r13	;
    53dc:	0e 47       	mov	r7,	r14	;
    53de:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    53e2:	81 4d 18 00 	mov	r13,	24(r1)	; 0x0018
    53e6:	81 4e 1a 00 	mov	r14,	26(r1)	; 0x001a
    53ea:	91 51 18 00 	rla	24(r1)		;#0x00018
    53ee:	02 00 
    53f0:	91 61 1a 00 	rlc	26(r1)		;#0x0001a
    53f4:	04 00 
    53f6:	0e 48       	mov	r8,	r14	;
    53f8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    53fc:	4d 4e       	mov.b	r14,	r13	;
    53fe:	4d e8       	xor.b	r8,	r13	;
    5400:	4d 8e       	sub.b	r14,	r13	;
    5402:	81 43 0e 00 	mov	#0,	14(r1)	;r3 As==00, 0x000e
    5406:	7e 40 09 00 	mov.b	#9,	r14	;
    540a:	4e 9d       	cmp.b	r13,	r14	;
    540c:	08 2c       	jc	$+18     	;abs 0x541e
    540e:	81 48 0e 00 	mov	r8,	14(r1)	; 0x000e
    5412:	0e 48       	mov	r8,	r14	;
    5414:	0f 48       	mov	r8,	r15	;
    5416:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    541a:	0a 5e       	add	r14,	r10	;
    541c:	0b 6f       	addc	r15,	r11	;
    541e:	0e 46       	mov	r6,	r14	;
    5420:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5424:	4d 4e       	mov.b	r14,	r13	;
    5426:	4d e6       	xor.b	r6,	r13	;
    5428:	4d 8e       	sub.b	r14,	r13	;
    542a:	7e 40 09 00 	mov.b	#9,	r14	;
    542e:	4e 9d       	cmp.b	r13,	r14	;
    5430:	02 28       	jnc	$+6      	;abs 0x5436
    5432:	80 00 a0 5b 	mova	#23456,	r0	;0x05ba0
    5436:	81 46 18 00 	mov	r6,	24(r1)	; 0x0018
    543a:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    543e:	07 77       	subc	r7,	r7	;
    5440:	37 e3       	inv	r7		;
    5442:	0e 49       	mov	r9,	r14	;
    5444:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5448:	4d 4e       	mov.b	r14,	r13	;
    544a:	4d e9       	xor.b	r9,	r13	;
    544c:	4d 8e       	sub.b	r14,	r13	;
    544e:	7e 40 09 00 	mov.b	#9,	r14	;
    5452:	4e 9d       	cmp.b	r13,	r14	;
    5454:	02 28       	jnc	$+6      	;abs 0x545a
    5456:	80 00 94 5b 	mova	#23444,	r0	;0x05b94
    545a:	81 49 1e 00 	mov	r9,	30(r1)	; 0x001e
    545e:	0e 49       	mov	r9,	r14	;
    5460:	0f 49       	mov	r9,	r15	;
    5462:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5466:	09 4c       	mov	r12,	r9	;
    5468:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    546c:	4d 49       	mov.b	r9,	r13	;
    546e:	4d ec       	xor.b	r12,	r13	;
    5470:	4d 89       	sub.b	r9,	r13	;
    5472:	79 40 09 00 	mov.b	#9,	r9	;
    5476:	49 9d       	cmp.b	r13,	r9	;
    5478:	02 28       	jnc	$+6      	;abs 0x547e
    547a:	80 00 88 5b 	mova	#23432,	r0	;0x05b88
    547e:	81 4c 1c 00 	mov	r12,	28(r1)	; 0x001c
    5482:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5486:	0d 7d       	subc	r13,	r13	;
    5488:	3d e3       	inv	r13		;
    548a:	09 4e       	mov	r14,	r9	;
    548c:	19 51 02 00 	add	2(r1),	r9	;
    5490:	18 41 04 00 	mov	4(r1),	r8	;
    5494:	08 6f       	addc	r15,	r8	;
    5496:	0a 5c       	add	r12,	r10	;
    5498:	0b 6d       	addc	r13,	r11	;
    549a:	7e 40 03 00 	mov.b	#3,	r14	;
    549e:	4f 43       	clr.b	r15		;
    54a0:	0c 46       	mov	r6,	r12	;
    54a2:	1c 51 06 00 	add	6(r1),	r12	;
    54a6:	1d 41 08 00 	mov	8(r1),	r13	;
    54aa:	0d 67       	addc	r7,	r13	;
    54ac:	81 4b 00 00 	mov	r11,	0(r1)	;
    54b0:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    54b4:	81 4c 06 00 	mov	r12,	6(r1)	;
    54b8:	7e 40 03 00 	mov.b	#3,	r14	;
    54bc:	4f 43       	clr.b	r15		;
    54be:	0c 49       	mov	r9,	r12	;
    54c0:	0d 48       	mov	r8,	r13	;
    54c2:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    54c6:	06 4c       	mov	r12,	r6	;
    54c8:	7e 40 03 00 	mov.b	#3,	r14	;
    54cc:	4f 43       	clr.b	r15		;
    54ce:	0c 4a       	mov	r10,	r12	;
    54d0:	2b 41       	mov	@r1,	r11	;
    54d2:	0d 4b       	mov	r11,	r13	;
    54d4:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    54d8:	81 4c 02 00 	mov	r12,	2(r1)	;
    54dc:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    54e0:	1c 81 06 00 	sub	6(r1),	r12	;
    54e4:	0d 4c       	mov	r12,	r13	;
    54e6:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    54ea:	0c ed       	xor	r13,	r12	;
    54ec:	0c 8d       	sub	r13,	r12	;
    54ee:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    54f2:	0d 7d       	subc	r13,	r13	;
    54f4:	3d e3       	inv	r13		;
    54f6:	1a 41 10 00 	mov	16(r1),	r10	;0x00010
    54fa:	1a 81 06 00 	sub	6(r1),	r10	;
    54fe:	0f 4a       	mov	r10,	r15	;
    5500:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5504:	0a ef       	xor	r15,	r10	;
    5506:	0e 4a       	mov	r10,	r14	;
    5508:	0e 8f       	sub	r15,	r14	;
    550a:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    550e:	0f 7f       	subc	r15,	r15	;
    5510:	3f e3       	inv	r15		;
    5512:	0c 5e       	add	r14,	r12	;
    5514:	0a 4d       	mov	r13,	r10	;
    5516:	0a 6f       	addc	r15,	r10	;
    5518:	81 4a 10 00 	mov	r10,	16(r1)	; 0x0010
    551c:	1a 41 16 00 	mov	22(r1),	r10	;0x00016
    5520:	0a 86       	sub	r6,	r10	;
    5522:	0d 4a       	mov	r10,	r13	;
    5524:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5528:	0a ed       	xor	r13,	r10	;
    552a:	0e 4a       	mov	r10,	r14	;
    552c:	0e 8d       	sub	r13,	r14	;
    552e:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    5532:	0f 7f       	subc	r15,	r15	;
    5534:	3f e3       	inv	r15		;
    5536:	05 86       	sub	r6,	r5	;
    5538:	0d 45       	mov	r5,	r13	;
    553a:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    553e:	05 ed       	xor	r13,	r5	;
    5540:	0a 45       	mov	r5,	r10	;
    5542:	0a 8d       	sub	r13,	r10	;
    5544:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    5548:	0b 7b       	subc	r11,	r11	;
    554a:	3b e3       	inv	r11		;
    554c:	08 4e       	mov	r14,	r8	;
    554e:	08 5a       	add	r10,	r8	;
    5550:	07 4f       	mov	r15,	r7	;
    5552:	07 6b       	addc	r11,	r7	;
    5554:	14 81 02 00 	sub	2(r1),	r4	;
    5558:	0d 44       	mov	r4,	r13	;
    555a:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    555e:	04 ed       	xor	r13,	r4	;
    5560:	0a 44       	mov	r4,	r10	;
    5562:	0a 8d       	sub	r13,	r10	;
    5564:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    5568:	0b 7b       	subc	r11,	r11	;
    556a:	3b e3       	inv	r11		;
    556c:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    5570:	1e 81 02 00 	sub	2(r1),	r14	;
    5574:	0d 4e       	mov	r14,	r13	;
    5576:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    557a:	0e ed       	xor	r13,	r14	;
    557c:	0e 8d       	sub	r13,	r14	;
    557e:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    5582:	0f 7f       	subc	r15,	r15	;
    5584:	3f e3       	inv	r15		;
    5586:	09 4a       	mov	r10,	r9	;
    5588:	09 5e       	add	r14,	r9	;
    558a:	0d 4b       	mov	r11,	r13	;
    558c:	0d 6f       	addc	r15,	r13	;
    558e:	1a 41 18 00 	mov	24(r1),	r10	;0x00018
    5592:	1a 81 06 00 	sub	6(r1),	r10	;
    5596:	0e 4a       	mov	r10,	r14	;
    5598:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    559c:	0a ee       	xor	r14,	r10	;
    559e:	0a 8e       	sub	r14,	r10	;
    55a0:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    55a4:	0b 7b       	subc	r11,	r11	;
    55a6:	3b e3       	inv	r11		;
    55a8:	1e 41 1e 00 	mov	30(r1),	r14	;0x0001e
    55ac:	0e 86       	sub	r6,	r14	;
    55ae:	0f 4e       	mov	r14,	r15	;
    55b0:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    55b4:	0e ef       	xor	r15,	r14	;
    55b6:	0e 8f       	sub	r15,	r14	;
    55b8:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    55bc:	0f 7f       	subc	r15,	r15	;
    55be:	3f e3       	inv	r15		;
    55c0:	08 5e       	add	r14,	r8	;
    55c2:	07 6f       	addc	r15,	r7	;
    55c4:	1e 41 1c 00 	mov	28(r1),	r14	;0x0001c
    55c8:	1e 81 02 00 	sub	2(r1),	r14	;
    55cc:	0f 4e       	mov	r14,	r15	;
    55ce:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    55d2:	0e ef       	xor	r15,	r14	;
    55d4:	0e 8f       	sub	r15,	r14	;
    55d6:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    55da:	0f 7f       	subc	r15,	r15	;
    55dc:	3f e3       	inv	r15		;
    55de:	09 5e       	add	r14,	r9	;
    55e0:	05 4f       	mov	r15,	r5	;
    55e2:	05 6d       	addc	r13,	r5	;
    55e4:	7e 40 03 00 	mov.b	#3,	r14	;
    55e8:	4f 43       	clr.b	r15		;
    55ea:	0c 5a       	add	r10,	r12	;
    55ec:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    55f0:	0d 6b       	addc	r11,	r13	;
    55f2:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    55f6:	0a 4c       	mov	r12,	r10	;
    55f8:	7e 40 03 00 	mov.b	#3,	r14	;
    55fc:	4f 43       	clr.b	r15		;
    55fe:	0c 48       	mov	r8,	r12	;
    5600:	0d 47       	mov	r7,	r13	;
    5602:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    5606:	08 4c       	mov	r12,	r8	;
    5608:	7e 40 03 00 	mov.b	#3,	r14	;
    560c:	4f 43       	clr.b	r15		;
    560e:	0c 49       	mov	r9,	r12	;
    5610:	0d 45       	mov	r5,	r13	;
    5612:	b0 12 c2 5f 	call	#24514		;#0x5fc2
    5616:	09 4c       	mov	r12,	r9	;
    5618:	0c 4a       	mov	r10,	r12	;
    561a:	0d 4a       	mov	r10,	r13	;
    561c:	b0 12 0a 60 	call	#24586		;#0x600a
    5620:	0a 4c       	mov	r12,	r10	;
    5622:	0c 48       	mov	r8,	r12	;
    5624:	0d 48       	mov	r8,	r13	;
    5626:	b0 12 0a 60 	call	#24586		;#0x600a
    562a:	0a 5c       	add	r12,	r10	;
    562c:	0c 49       	mov	r9,	r12	;
    562e:	0d 49       	mov	r9,	r13	;
    5630:	b0 12 0a 60 	call	#24586		;#0x600a
    5634:	0a 5c       	add	r12,	r10	;
    5636:	1c 41 06 00 	mov	6(r1),	r12	;
    563a:	0d 4c       	mov	r12,	r13	;
    563c:	b0 12 0a 60 	call	#24586		;#0x600a
    5640:	09 4c       	mov	r12,	r9	;
    5642:	0c 46       	mov	r6,	r12	;
    5644:	0d 46       	mov	r6,	r13	;
    5646:	b0 12 0a 60 	call	#24586		;#0x600a
    564a:	06 49       	mov	r9,	r6	;
    564c:	06 5c       	add	r12,	r6	;
    564e:	1c 41 02 00 	mov	2(r1),	r12	;
    5652:	0d 4c       	mov	r12,	r13	;
    5654:	b0 12 0a 60 	call	#24586		;#0x600a
    5658:	06 5c       	add	r12,	r6	;
    565a:	08 46       	mov	r6,	r8	;
    565c:	09 43       	clr	r9		;
    565e:	75 40 80 00 	mov.b	#128,	r5	;#0x0080
    5662:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    5666:	0c 96       	cmp	r6,	r12	;
    5668:	01 28       	jnc	$+4      	;abs 0x566c
    566a:	45 43       	clr.b	r5		;
    566c:	07 45       	mov	r5,	r7	;
    566e:	37 d0 40 00 	bis	#64,	r7	;#0x0040
    5672:	0c 47       	mov	r7,	r12	;
    5674:	4d 43       	clr.b	r13		;
    5676:	0e 47       	mov	r7,	r14	;
    5678:	4f 43       	clr.b	r15		;
    567a:	b0 12 1e 60 	call	#24606		;#0x601e
    567e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5680:	04 20       	jnz	$+10     	;abs 0x568a
    5682:	09 93       	cmp	#0,	r9	;r3 As==00
    5684:	05 20       	jnz	$+12     	;abs 0x5690
    5686:	06 9c       	cmp	r12,	r6	;
    5688:	03 2c       	jc	$+8      	;abs 0x5690
    568a:	07 45       	mov	r5,	r7	;
    568c:	37 f0 bf ff 	and	#-65,	r7	;#0xffbf
    5690:	05 47       	mov	r7,	r5	;
    5692:	35 d0 20 00 	bis	#32,	r5	;#0x0020
    5696:	0c 45       	mov	r5,	r12	;
    5698:	4d 43       	clr.b	r13		;
    569a:	0e 45       	mov	r5,	r14	;
    569c:	4f 43       	clr.b	r15		;
    569e:	b0 12 1e 60 	call	#24606		;#0x601e
    56a2:	0d 93       	cmp	#0,	r13	;r3 As==00
    56a4:	04 20       	jnz	$+10     	;abs 0x56ae
    56a6:	09 93       	cmp	#0,	r9	;r3 As==00
    56a8:	05 20       	jnz	$+12     	;abs 0x56b4
    56aa:	06 9c       	cmp	r12,	r6	;
    56ac:	03 2c       	jc	$+8      	;abs 0x56b4
    56ae:	05 47       	mov	r7,	r5	;
    56b0:	35 f0 df ff 	and	#-33,	r5	;#0xffdf
    56b4:	07 45       	mov	r5,	r7	;
    56b6:	37 d0 10 00 	bis	#16,	r7	;#0x0010
    56ba:	0c 47       	mov	r7,	r12	;
    56bc:	4d 43       	clr.b	r13		;
    56be:	0e 47       	mov	r7,	r14	;
    56c0:	4f 43       	clr.b	r15		;
    56c2:	b0 12 1e 60 	call	#24606		;#0x601e
    56c6:	0d 93       	cmp	#0,	r13	;r3 As==00
    56c8:	04 20       	jnz	$+10     	;abs 0x56d2
    56ca:	09 93       	cmp	#0,	r9	;r3 As==00
    56cc:	05 20       	jnz	$+12     	;abs 0x56d8
    56ce:	06 9c       	cmp	r12,	r6	;
    56d0:	03 2c       	jc	$+8      	;abs 0x56d8
    56d2:	07 45       	mov	r5,	r7	;
    56d4:	37 f0 ef ff 	and	#-17,	r7	;#0xffef
    56d8:	05 47       	mov	r7,	r5	;
    56da:	35 d2       	bis	#8,	r5	;r2 As==11
    56dc:	0c 45       	mov	r5,	r12	;
    56de:	4d 43       	clr.b	r13		;
    56e0:	0e 45       	mov	r5,	r14	;
    56e2:	4f 43       	clr.b	r15		;
    56e4:	b0 12 1e 60 	call	#24606		;#0x601e
    56e8:	0d 93       	cmp	#0,	r13	;r3 As==00
    56ea:	02 24       	jz	$+6      	;abs 0x56f0
    56ec:	80 00 4e 5b 	mova	#23374,	r0	;0x05b4e
    56f0:	09 93       	cmp	#0,	r9	;r3 As==00
    56f2:	04 20       	jnz	$+10     	;abs 0x56fc
    56f4:	06 9c       	cmp	r12,	r6	;
    56f6:	02 2c       	jc	$+6      	;abs 0x56fc
    56f8:	80 00 4e 5b 	mova	#23374,	r0	;0x05b4e
    56fc:	07 45       	mov	r5,	r7	;
    56fe:	27 d2       	bis	#4,	r7	;r2 As==10
    5700:	0c 47       	mov	r7,	r12	;
    5702:	4d 43       	clr.b	r13		;
    5704:	0e 47       	mov	r7,	r14	;
    5706:	4f 43       	clr.b	r15		;
    5708:	b0 12 1e 60 	call	#24606		;#0x601e
    570c:	0d 93       	cmp	#0,	r13	;r3 As==00
    570e:	02 24       	jz	$+6      	;abs 0x5714
    5710:	80 00 46 5b 	mova	#23366,	r0	;0x05b46
    5714:	09 93       	cmp	#0,	r9	;r3 As==00
    5716:	04 20       	jnz	$+10     	;abs 0x5720
    5718:	06 9c       	cmp	r12,	r6	;
    571a:	02 2c       	jc	$+6      	;abs 0x5720
    571c:	80 00 46 5b 	mova	#23366,	r0	;0x05b46
    5720:	05 47       	mov	r7,	r5	;
    5722:	25 d3       	bis	#2,	r5	;r3 As==10
    5724:	0c 45       	mov	r5,	r12	;
    5726:	4d 43       	clr.b	r13		;
    5728:	0e 45       	mov	r5,	r14	;
    572a:	4f 43       	clr.b	r15		;
    572c:	b0 12 1e 60 	call	#24606		;#0x601e
    5730:	0d 93       	cmp	#0,	r13	;r3 As==00
    5732:	02 24       	jz	$+6      	;abs 0x5738
    5734:	80 00 3e 5b 	mova	#23358,	r0	;0x05b3e
    5738:	09 93       	cmp	#0,	r9	;r3 As==00
    573a:	02 20       	jnz	$+6      	;abs 0x5740
    573c:	06 9c       	cmp	r12,	r6	;
    573e:	ff 29       	jnc	$+1024   	;abs 0x5b3e
    5740:	07 45       	mov	r5,	r7	;
    5742:	17 d3       	bis	#1,	r7	;r3 As==01
    5744:	0c 47       	mov	r7,	r12	;
    5746:	4d 43       	clr.b	r13		;
    5748:	0e 47       	mov	r7,	r14	;
    574a:	4f 43       	clr.b	r15		;
    574c:	b0 12 1e 60 	call	#24606		;#0x601e
    5750:	0d 93       	cmp	#0,	r13	;r3 As==00
    5752:	e3 21       	jnz	$+968    	;abs 0x5b1a
    5754:	09 93       	cmp	#0,	r9	;r3 As==00
    5756:	02 20       	jnz	$+6      	;abs 0x575c
    5758:	06 9c       	cmp	r12,	r6	;
    575a:	df 29       	jnc	$+960    	;abs 0x5b1a
    575c:	08 4a       	mov	r10,	r8	;
    575e:	09 43       	clr	r9		;
    5760:	3d 40 ff 0f 	mov	#4095,	r13	;#0x0fff
    5764:	0d 9a       	cmp	r10,	r13	;
    5766:	e1 29       	jnc	$+964    	;abs 0x5b2a
    5768:	3e 40 ff 03 	mov	#1023,	r14	;#0x03ff
    576c:	76 40 20 00 	mov.b	#32,	r6	;#0x0020
    5770:	0e 9a       	cmp	r10,	r14	;
    5772:	02 28       	jnc	$+6      	;abs 0x5778
    5774:	80 00 b0 5b 	mova	#23472,	r0	;0x05bb0
    5778:	45 43       	clr.b	r5		;
    577a:	36 d0 10 00 	bis	#16,	r6	;#0x0010
    577e:	0c 46       	mov	r6,	r12	;
    5780:	0d 45       	mov	r5,	r13	;
    5782:	0e 46       	mov	r6,	r14	;
    5784:	0f 45       	mov	r5,	r15	;
    5786:	b0 12 1e 60 	call	#24606		;#0x601e
    578a:	0d 93       	cmp	#0,	r13	;r3 As==00
    578c:	d5 21       	jnz	$+940    	;abs 0x5b38
    578e:	09 93       	cmp	#0,	r9	;r3 As==00
    5790:	02 20       	jnz	$+6      	;abs 0x5796
    5792:	80 00 ba 5b 	mova	#23482,	r0	;0x05bba
    5796:	04 46       	mov	r6,	r4	;
    5798:	34 d2       	bis	#8,	r4	;r2 As==11
    579a:	0c 44       	mov	r4,	r12	;
    579c:	0d 45       	mov	r5,	r13	;
    579e:	0e 44       	mov	r4,	r14	;
    57a0:	0f 45       	mov	r5,	r15	;
    57a2:	b0 12 1e 60 	call	#24606		;#0x601e
    57a6:	0d 93       	cmp	#0,	r13	;r3 As==00
    57a8:	b5 21       	jnz	$+876    	;abs 0x5b14
    57aa:	09 93       	cmp	#0,	r9	;r3 As==00
    57ac:	02 20       	jnz	$+6      	;abs 0x57b2
    57ae:	0a 9c       	cmp	r12,	r10	;
    57b0:	b1 29       	jnc	$+868    	;abs 0x5b14
    57b2:	06 44       	mov	r4,	r6	;
    57b4:	26 d2       	bis	#4,	r6	;r2 As==10
    57b6:	0c 46       	mov	r6,	r12	;
    57b8:	0d 45       	mov	r5,	r13	;
    57ba:	0e 46       	mov	r6,	r14	;
    57bc:	0f 45       	mov	r5,	r15	;
    57be:	b0 12 1e 60 	call	#24606		;#0x601e
    57c2:	0d 93       	cmp	#0,	r13	;r3 As==00
    57c4:	a4 21       	jnz	$+842    	;abs 0x5b0e
    57c6:	09 93       	cmp	#0,	r9	;r3 As==00
    57c8:	02 20       	jnz	$+6      	;abs 0x57ce
    57ca:	0a 9c       	cmp	r12,	r10	;
    57cc:	a0 29       	jnc	$+834    	;abs 0x5b0e
    57ce:	04 46       	mov	r6,	r4	;
    57d0:	24 d3       	bis	#2,	r4	;r3 As==10
    57d2:	0c 44       	mov	r4,	r12	;
    57d4:	0d 45       	mov	r5,	r13	;
    57d6:	0e 44       	mov	r4,	r14	;
    57d8:	0f 45       	mov	r5,	r15	;
    57da:	b0 12 1e 60 	call	#24606		;#0x601e
    57de:	0d 93       	cmp	#0,	r13	;r3 As==00
    57e0:	93 21       	jnz	$+808    	;abs 0x5b08
    57e2:	09 93       	cmp	#0,	r9	;r3 As==00
    57e4:	02 20       	jnz	$+6      	;abs 0x57ea
    57e6:	0a 9c       	cmp	r12,	r10	;
    57e8:	8f 29       	jnc	$+800    	;abs 0x5b08
    57ea:	06 44       	mov	r4,	r6	;
    57ec:	16 d3       	bis	#1,	r6	;r3 As==01
    57ee:	0c 46       	mov	r6,	r12	;
    57f0:	0d 45       	mov	r5,	r13	;
    57f2:	0e 46       	mov	r6,	r14	;
    57f4:	0f 45       	mov	r5,	r15	;
    57f6:	b0 12 1e 60 	call	#24606		;#0x601e
    57fa:	0d 93       	cmp	#0,	r13	;r3 As==00
    57fc:	82 21       	jnz	$+774    	;abs 0x5b02
    57fe:	09 93       	cmp	#0,	r9	;r3 As==00
    5800:	02 20       	jnz	$+6      	;abs 0x5806
    5802:	0a 9c       	cmp	r12,	r10	;
    5804:	7e 29       	jnc	$+766    	;abs 0x5b02
    5806:	45 43       	clr.b	r5		;
    5808:	48 43       	clr.b	r8		;
    580a:	4a 43       	clr.b	r10		;
    580c:	0d 4a       	mov	r10,	r13	;
    580e:	5d 06       	rlam	#2,	r13	;
    5810:	1f 4d 00 1c 	mov	7168(r13),r15	;0x01c00
    5814:	1c 4d 02 1c 	mov	7170(r13),r12	;0x01c02
    5818:	3d 50 00 1c 	add	#7168,	r13	;#0x1c00
    581c:	0c 86       	sub	r6,	r12	;
    581e:	0e 4c       	mov	r12,	r14	;
    5820:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5824:	0c ee       	xor	r14,	r12	;
    5826:	0c 8e       	sub	r14,	r12	;
    5828:	0e 4a       	mov	r10,	r14	;
    582a:	5e 06       	rlam	#2,	r14	;
    582c:	1e 4e 40 1c 	mov	7232(r14),r14	;0x01c40
    5830:	1d 4d 42 00 	mov	66(r13),r13	;0x00042
    5834:	0d 86       	sub	r6,	r13	;
    5836:	09 4d       	mov	r13,	r9	;
    5838:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    583c:	0d e9       	xor	r9,	r13	;
    583e:	0d 89       	sub	r9,	r13	;
    5840:	0f 87       	sub	r7,	r15	;
    5842:	09 4f       	mov	r15,	r9	;
    5844:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    5848:	0f e9       	xor	r9,	r15	;
    584a:	0f 89       	sub	r9,	r15	;
    584c:	0e 87       	sub	r7,	r14	;
    584e:	09 4e       	mov	r14,	r9	;
    5850:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    5854:	0e e9       	xor	r9,	r14	;
    5856:	0e 89       	sub	r9,	r14	;
    5858:	0e 9f       	cmp	r15,	r14	;
    585a:	7d 35       	jge	$+764    	;abs 0x5b56
    585c:	18 53       	inc	r8		;
    585e:	0d 9c       	cmp	r12,	r13	;
    5860:	7d 35       	jge	$+764    	;abs 0x5b5c
    5862:	18 53       	inc	r8		;
    5864:	1a 53       	inc	r10		;
    5866:	3a 90 10 00 	cmp	#16,	r10	;#0x0010
    586a:	d0 23       	jnz	$-94     	;abs 0x580c
    586c:	91 53 2a 00 	inc	42(r1)		;
    5870:	05 98       	cmp	r8,	r5	;
    5872:	76 35       	jge	$+750    	;abs 0x5b60
    5874:	91 53 2c 00 	inc	44(r1)		;
    5878:	91 53 0a 00 	inc	10(r1)		;
    587c:	b1 90 40 00 	cmp	#64,	10(r1)	;#0x0040, 0x000a
    5880:	0a 00 
    5882:	76 25       	jz	$+750    	;abs 0x5b70
    5884:	b1 90 20 00 	cmp	#32,	10(r1)	;#0x0020, 0x000a
    5888:	0a 00 
    588a:	02 24       	jz	$+6      	;abs 0x5890
    588c:	80 00 be 51 	mova	#20926,	r0	;0x051be
    5890:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5894:	1c 42 80 1c 	mov	&0x1c80,r12	;0x1c80
    5898:	3c 53       	add	#-1,	r12	;r3 As==11
    589a:	0c cd       	bic	r13,	r12	;
    589c:	4e 19 0c 10 	rpt #15 { rrux.w	r12		;
    58a0:	82 4c 80 1c 	mov	r12,	&0x1c80	;
    58a4:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    58a8:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    58ac:	5c f3       	and.b	#1,	r12	;r3 As==01
    58ae:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    58b2:	5a 03       	rrum	#1,	r10	;
    58b4:	0d 93       	cmp	#0,	r13	;r3 As==00
    58b6:	02 24       	jz	$+6      	;abs 0x58bc
    58b8:	80 00 d6 51 	mova	#20950,	r0	;0x051d6
    58bc:	0c 93       	cmp	#0,	r12	;r3 As==00
    58be:	02 24       	jz	$+6      	;abs 0x58c4
    58c0:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    58c4:	45 4a       	mov.b	r10,	r5	;
    58c6:	75 f0 03 00 	and.b	#3,	r5	;
    58ca:	75 50 fe ff 	add.b	#-2,	r5	;#0xfffe
    58ce:	85 11       	sxt	r5		;
    58d0:	0d 4a       	mov	r10,	r13	;
    58d2:	5d 03       	rrum	#1,	r13	;
    58d4:	1a b3       	bit	#1,	r10	;r3 As==01
    58d6:	02 24       	jz	$+6      	;abs 0x58dc
    58d8:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    58dc:	4a 4d       	mov.b	r13,	r10	;
    58de:	7a f0 03 00 	and.b	#3,	r10	;
    58e2:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    58e6:	8a 11       	sxt	r10		;
    58e8:	09 4d       	mov	r13,	r9	;
    58ea:	59 03       	rrum	#1,	r9	;
    58ec:	1d b3       	bit	#1,	r13	;r3 As==01
    58ee:	02 24       	jz	$+6      	;abs 0x58f4
    58f0:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    58f4:	44 49       	mov.b	r9,	r4	;
    58f6:	74 f0 03 00 	and.b	#3,	r4	;
    58fa:	74 50 fe ff 	add.b	#-2,	r4	;#0xfffe
    58fe:	84 11       	sxt	r4		;
    5900:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5904:	0c 49       	mov	r9,	r12	;
    5906:	5c f3       	and.b	#1,	r12	;r3 As==01
    5908:	59 03       	rrum	#1,	r9	;
    590a:	0d 93       	cmp	#0,	r13	;r3 As==00
    590c:	02 24       	jz	$+6      	;abs 0x5912
    590e:	80 00 3e 52 	mova	#21054,	r0	;0x0523e
    5912:	0c 93       	cmp	#0,	r12	;r3 As==00
    5914:	02 24       	jz	$+6      	;abs 0x591a
    5916:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    591a:	4c 49       	mov.b	r9,	r12	;
    591c:	7c f0 03 00 	and.b	#3,	r12	;
    5920:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5924:	8c 11       	sxt	r12		;
    5926:	81 4c 0e 00 	mov	r12,	14(r1)	; 0x000e
    592a:	0d 49       	mov	r9,	r13	;
    592c:	5d 03       	rrum	#1,	r13	;
    592e:	19 b3       	bit	#1,	r9	;r3 As==01
    5930:	02 24       	jz	$+6      	;abs 0x5936
    5932:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5936:	47 4d       	mov.b	r13,	r7	;
    5938:	77 f0 03 00 	and.b	#3,	r7	;
    593c:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5940:	87 11       	sxt	r7		;
    5942:	09 4d       	mov	r13,	r9	;
    5944:	59 03       	rrum	#1,	r9	;
    5946:	1d b3       	bit	#1,	r13	;r3 As==01
    5948:	02 24       	jz	$+6      	;abs 0x594e
    594a:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    594e:	48 49       	mov.b	r9,	r8	;
    5950:	78 f0 03 00 	and.b	#3,	r8	;
    5954:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5958:	88 11       	sxt	r8		;
    595a:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    595e:	0c 49       	mov	r9,	r12	;
    5960:	5c f3       	and.b	#1,	r12	;r3 As==01
    5962:	59 03       	rrum	#1,	r9	;
    5964:	0d 93       	cmp	#0,	r13	;r3 As==00
    5966:	02 24       	jz	$+6      	;abs 0x596c
    5968:	80 00 a8 52 	mova	#21160,	r0	;0x052a8
    596c:	0c 93       	cmp	#0,	r12	;r3 As==00
    596e:	02 24       	jz	$+6      	;abs 0x5974
    5970:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5974:	46 49       	mov.b	r9,	r6	;
    5976:	76 f0 03 00 	and.b	#3,	r6	;
    597a:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    597e:	86 11       	sxt	r6		;
    5980:	0d 49       	mov	r9,	r13	;
    5982:	5d 03       	rrum	#1,	r13	;
    5984:	19 b3       	bit	#1,	r9	;r3 As==01
    5986:	02 24       	jz	$+6      	;abs 0x598c
    5988:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    598c:	49 4d       	mov.b	r13,	r9	;
    598e:	79 f0 03 00 	and.b	#3,	r9	;
    5992:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5996:	89 11       	sxt	r9		;
    5998:	0e 4d       	mov	r13,	r14	;
    599a:	5e 03       	rrum	#1,	r14	;
    599c:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    59a0:	1d b3       	bit	#1,	r13	;r3 As==01
    59a2:	03 24       	jz	$+8      	;abs 0x59aa
    59a4:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    59a8:	12 00 
    59aa:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    59ae:	7c f0 03 00 	and.b	#3,	r12	;
    59b2:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    59b6:	8c 11       	sxt	r12		;
    59b8:	0e 45       	mov	r5,	r14	;
    59ba:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    59be:	4d 4e       	mov.b	r14,	r13	;
    59c0:	4d e5       	xor.b	r5,	r13	;
    59c2:	4d 8e       	sub.b	r14,	r13	;
    59c4:	7e 40 09 00 	mov.b	#9,	r14	;
    59c8:	4e 9d       	cmp.b	r13,	r14	;
    59ca:	02 2c       	jc	$+6      	;abs 0x59d0
    59cc:	80 00 22 53 	mova	#21282,	r0	;0x05322
    59d0:	81 43 06 00 	mov	#0,	6(r1)	;r3 As==00
    59d4:	81 43 08 00 	mov	#0,	8(r1)	;r3 As==00
    59d8:	81 43 14 00 	mov	#0,	20(r1)	;r3 As==00, 0x0014
    59dc:	0e 4a       	mov	r10,	r14	;
    59de:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    59e2:	4d 4e       	mov.b	r14,	r13	;
    59e4:	4d ea       	xor.b	r10,	r13	;
    59e6:	4d 8e       	sub.b	r14,	r13	;
    59e8:	7e 40 09 00 	mov.b	#9,	r14	;
    59ec:	4e 9d       	cmp.b	r13,	r14	;
    59ee:	02 2c       	jc	$+6      	;abs 0x59f4
    59f0:	80 00 4e 53 	mova	#21326,	r0	;0x0534e
    59f4:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    59f8:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    59fc:	81 43 16 00 	mov	#0,	22(r1)	;r3 As==00, 0x0016
    5a00:	0e 44       	mov	r4,	r14	;
    5a02:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5a06:	4d 44       	mov.b	r4,	r13	;
    5a08:	4d ee       	xor.b	r14,	r13	;
    5a0a:	4d 8e       	sub.b	r14,	r13	;
    5a0c:	7a 40 09 00 	mov.b	#9,	r10	;
    5a10:	4a 9d       	cmp.b	r13,	r10	;
    5a12:	02 2c       	jc	$+6      	;abs 0x5a18
    5a14:	80 00 7a 53 	mova	#21370,	r0	;0x0537a
    5a18:	4a 43       	clr.b	r10		;
    5a1a:	4b 43       	clr.b	r11		;
    5a1c:	44 43       	clr.b	r4		;
    5a1e:	30 40 82 53 	br	#0x5382		;
    5a22:	08 47       	mov	r7,	r8	;
    5a24:	28 c3       	bic	#2,	r8	;r3 As==10
    5a26:	30 40 d0 49 	br	#0x49d0		;
    5a2a:	07 46       	mov	r6,	r7	;
    5a2c:	27 c2       	bic	#4,	r7	;r2 As==10
    5a2e:	30 40 aa 49 	br	#0x49aa		;
    5a32:	06 48       	mov	r8,	r6	;
    5a34:	36 c2       	bic	#8,	r6	;r2 As==11
    5a36:	30 40 84 49 	br	#0x4984		;
    5a3a:	05 46       	mov	r6,	r5	;
    5a3c:	15 c3       	bic	#1,	r5	;r3 As==01
    5a3e:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    5a42:	0d 4a       	mov	r10,	r13	;
    5a44:	0e 43       	clr	r14		;
    5a46:	81 4d 06 00 	mov	r13,	6(r1)	;
    5a4a:	81 4e 08 00 	mov	r14,	8(r1)	;
    5a4e:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    5a52:	0e 9a       	cmp	r10,	r14	;
    5a54:	02 28       	jnc	$+6      	;abs 0x5a5a
    5a56:	80 00 2a 49 	mova	#18730,	r0	;0x0492a
    5a5a:	3e 40 ff 23 	mov	#9215,	r14	;#0x23ff
    5a5e:	0e 9a       	cmp	r10,	r14	;
    5a60:	68 2d       	jc	$+722    	;abs 0x5d32
    5a62:	78 40 70 00 	mov.b	#112,	r8	;#0x0070
    5a66:	09 44       	mov	r4,	r9	;
    5a68:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5a6c:	30 40 5e 49 	br	#0x495e		;
    5a70:	06 45       	mov	r5,	r6	;
    5a72:	26 c3       	bic	#2,	r6	;r3 As==10
    5a74:	30 40 ea 48 	br	#0x48ea		;
    5a78:	05 46       	mov	r6,	r5	;
    5a7a:	25 c2       	bic	#4,	r5	;r2 As==10
    5a7c:	30 40 c6 48 	br	#0x48c6		;
    5a80:	06 45       	mov	r5,	r6	;
    5a82:	36 c2       	bic	#8,	r6	;r2 As==11
    5a84:	30 40 a2 48 	br	#0x48a2		;
    5a88:	07 46       	mov	r6,	r7	;
    5a8a:	27 c2       	bic	#4,	r7	;r2 As==10
    5a8c:	08 47       	mov	r7,	r8	;
    5a8e:	28 d3       	bis	#2,	r8	;r3 As==10
    5a90:	0c 48       	mov	r8,	r12	;
    5a92:	0d 49       	mov	r9,	r13	;
    5a94:	0e 48       	mov	r8,	r14	;
    5a96:	0f 49       	mov	r9,	r15	;
    5a98:	b0 12 1e 60 	call	#24606		;#0x601e
    5a9c:	0d 93       	cmp	#0,	r13	;r3 As==00
    5a9e:	02 20       	jnz	$+6      	;abs 0x5aa4
    5aa0:	80 00 36 51 	mova	#20790,	r0	;0x05136
    5aa4:	08 47       	mov	r7,	r8	;
    5aa6:	28 c3       	bic	#2,	r8	;r3 As==10
    5aa8:	30 40 44 51 	br	#0x5144		;
    5aac:	06 48       	mov	r8,	r6	;
    5aae:	36 c2       	bic	#8,	r6	;r2 As==11
    5ab0:	30 40 f8 50 	br	#0x50f8		;
    5ab4:	05 46       	mov	r6,	r5	;
    5ab6:	15 c3       	bic	#1,	r5	;r3 As==01
    5ab8:	81 45 1e 00 	mov	r5,	30(r1)	; 0x001e
    5abc:	0d 4a       	mov	r10,	r13	;
    5abe:	0e 43       	clr	r14		;
    5ac0:	81 4d 06 00 	mov	r13,	6(r1)	;
    5ac4:	81 4e 08 00 	mov	r14,	8(r1)	;
    5ac8:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    5acc:	0e 9a       	cmp	r10,	r14	;
    5ace:	02 28       	jnc	$+6      	;abs 0x5ad4
    5ad0:	80 00 9e 50 	mova	#20638,	r0	;0x0509e
    5ad4:	3d 40 ff 23 	mov	#9215,	r13	;#0x23ff
    5ad8:	0d 9a       	cmp	r10,	r13	;
    5ada:	77 2c       	jc	$+240    	;abs 0x5bca
    5adc:	78 40 70 00 	mov.b	#112,	r8	;#0x0070
    5ae0:	09 44       	mov	r4,	r9	;
    5ae2:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5ae6:	30 40 d2 50 	br	#0x50d2		;
    5aea:	06 45       	mov	r5,	r6	;
    5aec:	26 c3       	bic	#2,	r6	;r3 As==10
    5aee:	30 40 5e 50 	br	#0x505e		;
    5af2:	05 46       	mov	r6,	r5	;
    5af4:	25 c2       	bic	#4,	r5	;r2 As==10
    5af6:	30 40 3a 50 	br	#0x503a		;
    5afa:	06 45       	mov	r5,	r6	;
    5afc:	36 c2       	bic	#8,	r6	;r2 As==11
    5afe:	30 40 16 50 	br	#0x5016		;
    5b02:	06 44       	mov	r4,	r6	;
    5b04:	16 c3       	bic	#1,	r6	;r3 As==01
    5b06:	7f 3e       	jmp	$-768    	;abs 0x5806
    5b08:	04 46       	mov	r6,	r4	;
    5b0a:	24 c3       	bic	#2,	r4	;r3 As==10
    5b0c:	6e 3e       	jmp	$-802    	;abs 0x57ea
    5b0e:	06 44       	mov	r4,	r6	;
    5b10:	26 c2       	bic	#4,	r6	;r2 As==10
    5b12:	5d 3e       	jmp	$-836    	;abs 0x57ce
    5b14:	04 46       	mov	r6,	r4	;
    5b16:	34 c2       	bic	#8,	r4	;r2 As==11
    5b18:	4c 3e       	jmp	$-870    	;abs 0x57b2
    5b1a:	07 45       	mov	r5,	r7	;
    5b1c:	17 c3       	bic	#1,	r7	;r3 As==01
    5b1e:	08 4a       	mov	r10,	r8	;
    5b20:	09 43       	clr	r9		;
    5b22:	3d 40 ff 0f 	mov	#4095,	r13	;#0x0fff
    5b26:	0d 9a       	cmp	r10,	r13	;
    5b28:	1f 2e       	jc	$-960    	;abs 0x5768
    5b2a:	3c 40 ff 23 	mov	#9215,	r12	;#0x23ff
    5b2e:	0c 9a       	cmp	r10,	r12	;
    5b30:	3d 2c       	jc	$+124    	;abs 0x5bac
    5b32:	76 40 70 00 	mov.b	#112,	r6	;#0x0070
    5b36:	45 43       	clr.b	r5		;
    5b38:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    5b3c:	2c 3e       	jmp	$-934    	;abs 0x5796
    5b3e:	05 47       	mov	r7,	r5	;
    5b40:	25 c3       	bic	#2,	r5	;r3 As==10
    5b42:	30 40 40 57 	br	#0x5740		;
    5b46:	07 45       	mov	r5,	r7	;
    5b48:	27 c2       	bic	#4,	r7	;r2 As==10
    5b4a:	30 40 20 57 	br	#0x5720		;
    5b4e:	05 47       	mov	r7,	r5	;
    5b50:	35 c2       	bic	#8,	r5	;r2 As==11
    5b52:	30 40 fc 56 	br	#0x56fc		;
    5b56:	15 53       	inc	r5		;
    5b58:	0d 9c       	cmp	r12,	r13	;
    5b5a:	83 3a       	jl	$-760    	;abs 0x5862
    5b5c:	15 53       	inc	r5		;
    5b5e:	82 3e       	jmp	$-762    	;abs 0x5864
    5b60:	91 53 2e 00 	inc	46(r1)		;
    5b64:	91 53 0a 00 	inc	10(r1)		;
    5b68:	b1 90 40 00 	cmp	#64,	10(r1)	;#0x0040, 0x000a
    5b6c:	0a 00 
    5b6e:	8a 22       	jnz	$-746    	;abs 0x5884
    5b70:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5b74:	82 1c 
    5b76:	b0 12 cc 40 	call	#16588		;#0x40cc
    5b7a:	b0 12 04 41 	call	#16644		;#0x4104
    5b7e:	4c 43       	clr.b	r12		;
    5b80:	31 50 30 00 	add	#48,	r1	;#0x0030
    5b84:	64 17       	popm	#7,	r10	;16-bit words
    5b86:	30 41       	ret			
    5b88:	4c 43       	clr.b	r12		;
    5b8a:	4d 43       	clr.b	r13		;
    5b8c:	81 43 1c 00 	mov	#0,	28(r1)	;r3 As==00, 0x001c
    5b90:	30 40 8a 54 	br	#0x548a		;
    5b94:	4e 43       	clr.b	r14		;
    5b96:	4f 43       	clr.b	r15		;
    5b98:	81 43 1e 00 	mov	#0,	30(r1)	;r3 As==00, 0x001e
    5b9c:	30 40 66 54 	br	#0x5466		;
    5ba0:	46 43       	clr.b	r6		;
    5ba2:	47 43       	clr.b	r7		;
    5ba4:	81 43 18 00 	mov	#0,	24(r1)	;r3 As==00, 0x0018
    5ba8:	30 40 42 54 	br	#0x5442		;
    5bac:	76 40 60 00 	mov.b	#96,	r6	;#0x0060
    5bb0:	36 e0 20 00 	xor	#32,	r6	;#0x0020
    5bb4:	45 43       	clr.b	r5		;
    5bb6:	30 40 7a 57 	br	#0x577a		;
    5bba:	0a 9c       	cmp	r12,	r10	;
    5bbc:	02 28       	jnc	$+6      	;abs 0x5bc2
    5bbe:	80 00 96 57 	mova	#22422,	r0	;0x05796
    5bc2:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    5bc6:	30 40 96 57 	br	#0x5796		;
    5bca:	78 40 60 00 	mov.b	#96,	r8	;#0x0060
    5bce:	38 e0 20 00 	xor	#32,	r8	;#0x0020
    5bd2:	09 44       	mov	r4,	r9	;
    5bd4:	30 40 b0 50 	br	#0x50b0		;
    5bd8:	4c 43       	clr.b	r12		;
    5bda:	4d 43       	clr.b	r13		;
    5bdc:	81 44 26 00 	mov	r4,	38(r1)	; 0x0026
    5be0:	30 40 9e 4d 	br	#0x4d9e		;
    5be4:	4e 43       	clr.b	r14		;
    5be6:	4f 43       	clr.b	r15		;
    5be8:	81 44 24 00 	mov	r4,	36(r1)	; 0x0024
    5bec:	30 40 7a 4d 	br	#0x4d7a		;
    5bf0:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5bf4:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    5bf8:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    5bfc:	30 40 56 4d 	br	#0x4d56		;
    5c00:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    5c04:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5c08:	81 44 06 00 	mov	r4,	6(r1)	;
    5c0c:	30 40 8e 4c 	br	#0x4c8e		;
    5c10:	4a 43       	clr.b	r10		;
    5c12:	4b 43       	clr.b	r11		;
    5c14:	81 44 1c 00 	mov	r4,	28(r1)	; 0x001c
    5c18:	30 40 60 4c 	br	#0x4c60		;
    5c1c:	45 43       	clr.b	r5		;
    5c1e:	46 43       	clr.b	r6		;
    5c20:	81 44 18 00 	mov	r4,	24(r1)	; 0x0018
    5c24:	30 40 3c 4c 	br	#0x4c3c		;
    5c28:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c2a:	02 24       	jz	$+6      	;abs 0x5c30
    5c2c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5c30:	48 49       	mov.b	r9,	r8	;
    5c32:	78 f0 03 00 	and.b	#3,	r8	;
    5c36:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5c3a:	88 11       	sxt	r8		;
    5c3c:	0c 49       	mov	r9,	r12	;
    5c3e:	5c 03       	rrum	#1,	r12	;
    5c40:	19 b3       	bit	#1,	r9	;r3 As==01
    5c42:	02 24       	jz	$+6      	;abs 0x5c48
    5c44:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5c48:	49 4c       	mov.b	r12,	r9	;
    5c4a:	79 f0 03 00 	and.b	#3,	r9	;
    5c4e:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5c52:	89 11       	sxt	r9		;
    5c54:	0e 4c       	mov	r12,	r14	;
    5c56:	5e 03       	rrum	#1,	r14	;
    5c58:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    5c5c:	1c b3       	bit	#1,	r12	;r3 As==01
    5c5e:	03 24       	jz	$+8      	;abs 0x5c66
    5c60:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    5c64:	12 00 
    5c66:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5c6a:	82 1c 
    5c6c:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5c70:	7c f0 03 00 	and.b	#3,	r12	;
    5c74:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c78:	8c 11       	sxt	r12		;
    5c7a:	30 40 1a 4c 	br	#0x4c1a		;
    5c7e:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c80:	02 24       	jz	$+6      	;abs 0x5c86
    5c82:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5c86:	4c 49       	mov.b	r9,	r12	;
    5c88:	7c f0 03 00 	and.b	#3,	r12	;
    5c8c:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c90:	8c 11       	sxt	r12		;
    5c92:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    5c96:	0c 49       	mov	r9,	r12	;
    5c98:	5c 03       	rrum	#1,	r12	;
    5c9a:	19 b3       	bit	#1,	r9	;r3 As==01
    5c9c:	02 24       	jz	$+6      	;abs 0x5ca2
    5c9e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5ca2:	4d 4c       	mov.b	r12,	r13	;
    5ca4:	7d f0 03 00 	and.b	#3,	r13	;
    5ca8:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5cac:	8d 11       	sxt	r13		;
    5cae:	81 4d 10 00 	mov	r13,	16(r1)	; 0x0010
    5cb2:	09 4c       	mov	r12,	r9	;
    5cb4:	59 03       	rrum	#1,	r9	;
    5cb6:	1c b3       	bit	#1,	r12	;r3 As==01
    5cb8:	02 24       	jz	$+6      	;abs 0x5cbe
    5cba:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5cbe:	47 49       	mov.b	r9,	r7	;
    5cc0:	77 f0 03 00 	and.b	#3,	r7	;
    5cc4:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5cc8:	87 11       	sxt	r7		;
    5cca:	30 40 a6 4b 	br	#0x4ba6		;
    5cce:	0c 93       	cmp	#0,	r12	;r3 As==00
    5cd0:	02 24       	jz	$+6      	;abs 0x5cd6
    5cd2:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5cd6:	46 4a       	mov.b	r10,	r6	;
    5cd8:	76 f0 03 00 	and.b	#3,	r6	;
    5cdc:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5ce0:	86 11       	sxt	r6		;
    5ce2:	0c 4a       	mov	r10,	r12	;
    5ce4:	5c 03       	rrum	#1,	r12	;
    5ce6:	1a b3       	bit	#1,	r10	;r3 As==01
    5ce8:	02 24       	jz	$+6      	;abs 0x5cee
    5cea:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5cee:	4a 4c       	mov.b	r12,	r10	;
    5cf0:	7a f0 03 00 	and.b	#3,	r10	;
    5cf4:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    5cf8:	8a 11       	sxt	r10		;
    5cfa:	09 4c       	mov	r12,	r9	;
    5cfc:	59 03       	rrum	#1,	r9	;
    5cfe:	1c b3       	bit	#1,	r12	;r3 As==01
    5d00:	02 24       	jz	$+6      	;abs 0x5d06
    5d02:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5d06:	4c 49       	mov.b	r9,	r12	;
    5d08:	7c f0 03 00 	and.b	#3,	r12	;
    5d0c:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5d10:	8c 11       	sxt	r12		;
    5d12:	81 4c 06 00 	mov	r12,	6(r1)	;
    5d16:	30 40 3a 4b 	br	#0x4b3a		;
    5d1a:	4c 43       	clr.b	r12		;
    5d1c:	4d 43       	clr.b	r13		;
    5d1e:	81 44 28 00 	mov	r4,	40(r1)	; 0x0028
    5d22:	30 40 2a 46 	br	#0x462a		;
    5d26:	4e 43       	clr.b	r14		;
    5d28:	4f 43       	clr.b	r15		;
    5d2a:	81 44 26 00 	mov	r4,	38(r1)	; 0x0026
    5d2e:	30 40 06 46 	br	#0x4606		;
    5d32:	78 40 60 00 	mov.b	#96,	r8	;#0x0060
    5d36:	38 e0 20 00 	xor	#32,	r8	;#0x0020
    5d3a:	09 44       	mov	r4,	r9	;
    5d3c:	30 40 3c 49 	br	#0x493c		;
    5d40:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5d44:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    5d48:	81 44 24 00 	mov	r4,	36(r1)	; 0x0024
    5d4c:	30 40 e2 45 	br	#0x45e2		;
    5d50:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    5d54:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5d58:	81 44 06 00 	mov	r4,	6(r1)	;
    5d5c:	30 40 1a 45 	br	#0x451a		;
    5d60:	4a 43       	clr.b	r10		;
    5d62:	4b 43       	clr.b	r11		;
    5d64:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    5d68:	30 40 ec 44 	br	#0x44ec		;
    5d6c:	45 43       	clr.b	r5		;
    5d6e:	46 43       	clr.b	r6		;
    5d70:	81 44 1c 00 	mov	r4,	28(r1)	; 0x001c
    5d74:	30 40 c8 44 	br	#0x44c8		;
    5d78:	0c 93       	cmp	#0,	r12	;r3 As==00
    5d7a:	02 24       	jz	$+6      	;abs 0x5d80
    5d7c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5d80:	48 49       	mov.b	r9,	r8	;
    5d82:	78 f0 03 00 	and.b	#3,	r8	;
    5d86:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5d8a:	88 11       	sxt	r8		;
    5d8c:	0c 49       	mov	r9,	r12	;
    5d8e:	5c 03       	rrum	#1,	r12	;
    5d90:	19 b3       	bit	#1,	r9	;r3 As==01
    5d92:	02 24       	jz	$+6      	;abs 0x5d98
    5d94:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5d98:	49 4c       	mov.b	r12,	r9	;
    5d9a:	79 f0 03 00 	and.b	#3,	r9	;
    5d9e:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5da2:	89 11       	sxt	r9		;
    5da4:	0e 4c       	mov	r12,	r14	;
    5da6:	5e 03       	rrum	#1,	r14	;
    5da8:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    5dac:	1c b3       	bit	#1,	r12	;r3 As==01
    5dae:	03 24       	jz	$+8      	;abs 0x5db6
    5db0:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    5db4:	12 00 
    5db6:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5dba:	82 1c 
    5dbc:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5dc0:	7c f0 03 00 	and.b	#3,	r12	;
    5dc4:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5dc8:	8c 11       	sxt	r12		;
    5dca:	30 40 a6 44 	br	#0x44a6		;
    5dce:	0c 93       	cmp	#0,	r12	;r3 As==00
    5dd0:	02 24       	jz	$+6      	;abs 0x5dd6
    5dd2:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5dd6:	4c 49       	mov.b	r9,	r12	;
    5dd8:	7c f0 03 00 	and.b	#3,	r12	;
    5ddc:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5de0:	8c 11       	sxt	r12		;
    5de2:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    5de6:	0c 49       	mov	r9,	r12	;
    5de8:	5c 03       	rrum	#1,	r12	;
    5dea:	19 b3       	bit	#1,	r9	;r3 As==01
    5dec:	02 24       	jz	$+6      	;abs 0x5df2
    5dee:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5df2:	4d 4c       	mov.b	r12,	r13	;
    5df4:	7d f0 03 00 	and.b	#3,	r13	;
    5df8:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5dfc:	8d 11       	sxt	r13		;
    5dfe:	81 4d 10 00 	mov	r13,	16(r1)	; 0x0010
    5e02:	09 4c       	mov	r12,	r9	;
    5e04:	59 03       	rrum	#1,	r9	;
    5e06:	1c b3       	bit	#1,	r12	;r3 As==01
    5e08:	02 24       	jz	$+6      	;abs 0x5e0e
    5e0a:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5e0e:	47 49       	mov.b	r9,	r7	;
    5e10:	77 f0 03 00 	and.b	#3,	r7	;
    5e14:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5e18:	87 11       	sxt	r7		;
    5e1a:	30 40 32 44 	br	#0x4432		;
    5e1e:	0c 93       	cmp	#0,	r12	;r3 As==00
    5e20:	02 24       	jz	$+6      	;abs 0x5e26
    5e22:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5e26:	46 4a       	mov.b	r10,	r6	;
    5e28:	76 f0 03 00 	and.b	#3,	r6	;
    5e2c:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5e30:	86 11       	sxt	r6		;
    5e32:	0c 4a       	mov	r10,	r12	;
    5e34:	5c 03       	rrum	#1,	r12	;
    5e36:	1a b3       	bit	#1,	r10	;r3 As==01
    5e38:	02 24       	jz	$+6      	;abs 0x5e3e
    5e3a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5e3e:	4a 4c       	mov.b	r12,	r10	;
    5e40:	7a f0 03 00 	and.b	#3,	r10	;
    5e44:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    5e48:	8a 11       	sxt	r10		;
    5e4a:	09 4c       	mov	r12,	r9	;
    5e4c:	59 03       	rrum	#1,	r9	;
    5e4e:	1c b3       	bit	#1,	r12	;r3 As==01
    5e50:	02 24       	jz	$+6      	;abs 0x5e56
    5e52:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5e56:	4c 49       	mov.b	r9,	r12	;
    5e58:	7c f0 03 00 	and.b	#3,	r12	;
    5e5c:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5e60:	8c 11       	sxt	r12		;
    5e62:	81 4c 06 00 	mov	r12,	6(r1)	;
    5e66:	30 40 c6 43 	br	#0x43c6		;
    5e6a:	0a 9c       	cmp	r12,	r10	;
    5e6c:	02 28       	jnc	$+6      	;abs 0x5e72
    5e6e:	80 00 5e 49 	mova	#18782,	r0	;0x0495e
    5e72:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5e76:	30 40 5e 49 	br	#0x495e		;
    5e7a:	0a 9c       	cmp	r12,	r10	;
    5e7c:	02 28       	jnc	$+6      	;abs 0x5e82
    5e7e:	80 00 d2 50 	mova	#20690,	r0	;0x050d2
    5e82:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5e86:	30 40 d2 50 	br	#0x50d2		;
    5e8a:	0d 93       	cmp	#0,	r13	;r3 As==00
    5e8c:	02 24       	jz	$+6      	;abs 0x5e92
    5e8e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5e92:	0d 4c       	mov	r12,	r13	;
    5e94:	5d 03       	rrum	#1,	r13	;
    5e96:	1c b3       	bit	#1,	r12	;r3 As==01
    5e98:	02 24       	jz	$+6      	;abs 0x5e9e
    5e9a:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5e9e:	0a 4d       	mov	r13,	r10	;
    5ea0:	5a 03       	rrum	#1,	r10	;
    5ea2:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5ea6:	1d b3       	bit	#1,	r13	;r3 As==01
    5ea8:	02 20       	jnz	$+6      	;abs 0x5eae
    5eaa:	80 00 c2 4a 	mova	#19138,	r0	;0x04ac2
    5eae:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5eb2:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5eb6:	30 40 c2 4a 	br	#0x4ac2		;
    5eba:	0d 93       	cmp	#0,	r13	;r3 As==00
    5ebc:	02 24       	jz	$+6      	;abs 0x5ec2
    5ebe:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5ec2:	0d 4c       	mov	r12,	r13	;
    5ec4:	5d 03       	rrum	#1,	r13	;
    5ec6:	1c b3       	bit	#1,	r12	;r3 As==01
    5ec8:	02 24       	jz	$+6      	;abs 0x5ece
    5eca:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5ece:	0a 4d       	mov	r13,	r10	;
    5ed0:	5a 03       	rrum	#1,	r10	;
    5ed2:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5ed6:	1d b3       	bit	#1,	r13	;r3 As==01
    5ed8:	02 20       	jnz	$+6      	;abs 0x5ede
    5eda:	80 00 4e 43 	mova	#17230,	r0	;0x0434e
    5ede:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5ee2:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5ee6:	30 40 4e 43 	br	#0x434e		;
    5eea:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5eee:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    5ef2:	30 40 c2 4a 	br	#0x4ac2		;
    5ef6:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5efa:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    5efe:	30 40 4e 43 	br	#0x434e		;

00005f02 <udivmodhi4>:
    5f02:	0f 4c       	mov	r12,	r15	;
    5f04:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011
    5f08:	5b 43       	mov.b	#1,	r11	;r3 As==01
    5f0a:	0d 9f       	cmp	r15,	r13	;
    5f0c:	05 2c       	jc	$+12     	;abs 0x5f18
    5f0e:	3c 53       	add	#-1,	r12	;r3 As==11
    5f10:	0c 93       	cmp	#0,	r12	;r3 As==00
    5f12:	05 24       	jz	$+12     	;abs 0x5f1e
    5f14:	0d 93       	cmp	#0,	r13	;r3 As==00
    5f16:	07 34       	jge	$+16     	;abs 0x5f26
    5f18:	4c 43       	clr.b	r12		;
    5f1a:	0b 93       	cmp	#0,	r11	;r3 As==00
    5f1c:	07 20       	jnz	$+16     	;abs 0x5f2c
    5f1e:	0e 93       	cmp	#0,	r14	;r3 As==00
    5f20:	01 24       	jz	$+4      	;abs 0x5f24
    5f22:	0c 4f       	mov	r15,	r12	;
    5f24:	30 41       	ret			
    5f26:	5d 02       	rlam	#1,	r13	;
    5f28:	5b 02       	rlam	#1,	r11	;
    5f2a:	ef 3f       	jmp	$-32     	;abs 0x5f0a
    5f2c:	0f 9d       	cmp	r13,	r15	;
    5f2e:	02 28       	jnc	$+6      	;abs 0x5f34
    5f30:	0f 8d       	sub	r13,	r15	;
    5f32:	0c db       	bis	r11,	r12	;
    5f34:	5b 03       	rrum	#1,	r11	;
    5f36:	5d 03       	rrum	#1,	r13	;
    5f38:	f0 3f       	jmp	$-30     	;abs 0x5f1a

00005f3a <__mspabi_remu>:
    5f3a:	5e 43       	mov.b	#1,	r14	;r3 As==01
    5f3c:	b0 12 02 5f 	call	#24322		;#0x5f02
    5f40:	30 41       	ret			

00005f42 <udivmodsi4>:
    5f42:	4a 15       	pushm	#5,	r10	;16-bit words
    5f44:	0a 4c       	mov	r12,	r10	;
    5f46:	0b 4d       	mov	r13,	r11	;
    5f48:	7c 40 21 00 	mov.b	#33,	r12	;#0x0021
    5f4c:	58 43       	mov.b	#1,	r8	;r3 As==01
    5f4e:	49 43       	clr.b	r9		;
    5f50:	0f 9b       	cmp	r11,	r15	;
    5f52:	04 28       	jnc	$+10     	;abs 0x5f5c
    5f54:	0b 9f       	cmp	r15,	r11	;
    5f56:	07 20       	jnz	$+16     	;abs 0x5f66
    5f58:	0e 9a       	cmp	r10,	r14	;
    5f5a:	05 2c       	jc	$+12     	;abs 0x5f66
    5f5c:	3c 53       	add	#-1,	r12	;r3 As==11
    5f5e:	0c 93       	cmp	#0,	r12	;r3 As==00
    5f60:	2d 24       	jz	$+92     	;abs 0x5fbc
    5f62:	0f 93       	cmp	#0,	r15	;r3 As==00
    5f64:	0d 34       	jge	$+28     	;abs 0x5f80
    5f66:	4c 43       	clr.b	r12		;
    5f68:	4d 43       	clr.b	r13		;
    5f6a:	07 48       	mov	r8,	r7	;
    5f6c:	07 d9       	bis	r9,	r7	;
    5f6e:	07 93       	cmp	#0,	r7	;r3 As==00
    5f70:	14 20       	jnz	$+42     	;abs 0x5f9a
    5f72:	81 93 0c 00 	cmp	#0,	12(r1)	;r3 As==00, 0x000c
    5f76:	02 24       	jz	$+6      	;abs 0x5f7c
    5f78:	0c 4a       	mov	r10,	r12	;
    5f7a:	0d 4b       	mov	r11,	r13	;
    5f7c:	46 17       	popm	#5,	r10	;16-bit words
    5f7e:	30 41       	ret			
    5f80:	06 4e       	mov	r14,	r6	;
    5f82:	07 4f       	mov	r15,	r7	;
    5f84:	06 5e       	add	r14,	r6	;
    5f86:	07 6f       	addc	r15,	r7	;
    5f88:	0e 46       	mov	r6,	r14	;
    5f8a:	0f 47       	mov	r7,	r15	;
    5f8c:	06 48       	mov	r8,	r6	;
    5f8e:	07 49       	mov	r9,	r7	;
    5f90:	06 58       	add	r8,	r6	;
    5f92:	07 69       	addc	r9,	r7	;
    5f94:	08 46       	mov	r6,	r8	;
    5f96:	09 47       	mov	r7,	r9	;
    5f98:	db 3f       	jmp	$-72     	;abs 0x5f50
    5f9a:	0b 9f       	cmp	r15,	r11	;
    5f9c:	08 28       	jnc	$+18     	;abs 0x5fae
    5f9e:	0f 9b       	cmp	r11,	r15	;
    5fa0:	02 20       	jnz	$+6      	;abs 0x5fa6
    5fa2:	0a 9e       	cmp	r14,	r10	;
    5fa4:	04 28       	jnc	$+10     	;abs 0x5fae
    5fa6:	0a 8e       	sub	r14,	r10	;
    5fa8:	0b 7f       	subc	r15,	r11	;
    5faa:	0c d8       	bis	r8,	r12	;
    5fac:	0d d9       	bis	r9,	r13	;
    5fae:	12 c3       	clrc			
    5fb0:	09 10       	rrc	r9		;
    5fb2:	08 10       	rrc	r8		;
    5fb4:	12 c3       	clrc			
    5fb6:	0f 10       	rrc	r15		;
    5fb8:	0e 10       	rrc	r14		;
    5fba:	d7 3f       	jmp	$-80     	;abs 0x5f6a
    5fbc:	4c 43       	clr.b	r12		;
    5fbe:	4d 43       	clr.b	r13		;
    5fc0:	d8 3f       	jmp	$-78     	;abs 0x5f72

00005fc2 <__mspabi_divli>:
    5fc2:	2a 15       	pushm	#3,	r10	;16-bit words
    5fc4:	21 83       	decd	r1		;
    5fc6:	4a 43       	clr.b	r10		;
    5fc8:	0d 93       	cmp	#0,	r13	;r3 As==00
    5fca:	07 34       	jge	$+16     	;abs 0x5fda
    5fcc:	48 43       	clr.b	r8		;
    5fce:	49 43       	clr.b	r9		;
    5fd0:	08 8c       	sub	r12,	r8	;
    5fd2:	09 7d       	subc	r13,	r9	;
    5fd4:	0c 48       	mov	r8,	r12	;
    5fd6:	0d 49       	mov	r9,	r13	;
    5fd8:	5a 43       	mov.b	#1,	r10	;r3 As==01
    5fda:	0f 93       	cmp	#0,	r15	;r3 As==00
    5fdc:	07 34       	jge	$+16     	;abs 0x5fec
    5fde:	48 43       	clr.b	r8		;
    5fe0:	49 43       	clr.b	r9		;
    5fe2:	08 8e       	sub	r14,	r8	;
    5fe4:	09 7f       	subc	r15,	r9	;
    5fe6:	0e 48       	mov	r8,	r14	;
    5fe8:	0f 49       	mov	r9,	r15	;
    5fea:	1a e3       	xor	#1,	r10	;r3 As==01
    5fec:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    5ff0:	b0 12 42 5f 	call	#24386		;#0x5f42
    5ff4:	0a 93       	cmp	#0,	r10	;r3 As==00
    5ff6:	06 24       	jz	$+14     	;abs 0x6004
    5ff8:	49 43       	clr.b	r9		;
    5ffa:	4a 43       	clr.b	r10		;
    5ffc:	09 8c       	sub	r12,	r9	;
    5ffe:	0a 7d       	subc	r13,	r10	;
    6000:	0c 49       	mov	r9,	r12	;
    6002:	0d 4a       	mov	r10,	r13	;
    6004:	21 53       	incd	r1		;
    6006:	28 17       	popm	#3,	r10	;16-bit words
    6008:	30 41       	ret			

0000600a <__mulhi2>:
    600a:	02 12       	push	r2		;
    600c:	32 c2       	dint			
    600e:	03 43       	nop			
    6010:	82 4c c0 04 	mov	r12,	&0x04c0	;
    6014:	82 4d c8 04 	mov	r13,	&0x04c8	;
    6018:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    601c:	00 13       	reti			

0000601e <__mulsi2>:
    601e:	02 12       	push	r2		;
    6020:	32 c2       	dint			
    6022:	03 43       	nop			
    6024:	82 4c d0 04 	mov	r12,	&0x04d0	;
    6028:	82 4d d2 04 	mov	r13,	&0x04d2	;
    602c:	82 4e e0 04 	mov	r14,	&0x04e0	;
    6030:	82 4f e2 04 	mov	r15,	&0x04e2	;
    6034:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    6038:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    603c:	00 13       	reti			

0000603e <memcpy>:
    603e:	0f 4c       	mov	r12,	r15	;
    6040:	0e 5d       	add	r13,	r14	;
    6042:	0d 9e       	cmp	r14,	r13	;
    6044:	01 20       	jnz	$+4      	;abs 0x6048
    6046:	30 41       	ret			
    6048:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    604c:	1f 53       	inc	r15		;
    604e:	f9 3f       	jmp	$-12     	;abs 0x6042

00006050 <_exit>:
    6050:	ff 3f       	jmp	$+0      	;abs 0x6050
