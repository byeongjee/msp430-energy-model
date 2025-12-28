
/Users/byeongjee/migration/probabilistic-energy-modeling/build/activity_recognition_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004064 <__crt0_start>:
    4064:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004068 <__crt0_call_main>:
    4068:	0c 43       	clr	r12		;
    406a:	b0 12 92 42 	call	#17042		;#0x4292

0000406e <__crt0_call_exit>:
    406e:	b0 12 54 60 	call	#24660		;#0x6054

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
    422a:	3d 40 56 60 	mov	#24662,	r13	;#0x6056
    422e:	b0 12 42 60 	call	#24642		;#0x6042
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

00004292 <main>:
    4292:	6a 15       	pushm	#7,	r10	;16-bit words
    4294:	31 80 30 00 	sub	#48,	r1	;#0x0030
    4298:	b0 12 10 42 	call	#16912		;#0x4210
    429c:	f2 d0 03 00 	bis.b	#3,	&0x0204	;
    42a0:	04 02 
    42a2:	f2 f0 fc ff 	and.b	#-4,	&0x0202	;#0xfffc
    42a6:	02 02 
    42a8:	03 43       	nop			
    42aa:	32 d2       	eint			
    42ac:	03 43       	nop			
    42ae:	b2 40 e1 ac 	mov	#-21279,&0x1c82	;#0xace1
    42b2:	82 1c 
    42b4:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    42b8:	b0 12 e8 40 	call	#16616		;#0x40e8
    42bc:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    42c0:	b0 12 b0 40 	call	#16560		;#0x40b0
    42c4:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    42c8:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    42cc:	0d 4c       	mov	r12,	r13	;
    42ce:	5d f3       	and.b	#1,	r13	;r3 As==01
    42d0:	5c 03       	rrum	#1,	r12	;
    42d2:	0d 93       	cmp	#0,	r13	;r3 As==00
    42d4:	02 24       	jz	$+6      	;abs 0x42da
    42d6:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    42da:	0d 4c       	mov	r12,	r13	;
    42dc:	5d 03       	rrum	#1,	r13	;
    42de:	1c b3       	bit	#1,	r12	;r3 As==01
    42e0:	02 24       	jz	$+6      	;abs 0x42e6
    42e2:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    42e6:	0c 4d       	mov	r13,	r12	;
    42e8:	5c 03       	rrum	#1,	r12	;
    42ea:	1d b3       	bit	#1,	r13	;r3 As==01
    42ec:	02 24       	jz	$+6      	;abs 0x42f2
    42ee:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    42f2:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    42f6:	0d 4c       	mov	r12,	r13	;
    42f8:	5d f3       	and.b	#1,	r13	;r3 As==01
    42fa:	5c 03       	rrum	#1,	r12	;
    42fc:	0d 93       	cmp	#0,	r13	;r3 As==00
    42fe:	02 24       	jz	$+6      	;abs 0x4304
    4300:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4304:	0d 4c       	mov	r12,	r13	;
    4306:	5d 03       	rrum	#1,	r13	;
    4308:	1c b3       	bit	#1,	r12	;r3 As==01
    430a:	02 24       	jz	$+6      	;abs 0x4310
    430c:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4310:	0c 4d       	mov	r13,	r12	;
    4312:	5c 03       	rrum	#1,	r12	;
    4314:	1d b3       	bit	#1,	r13	;r3 As==01
    4316:	02 24       	jz	$+6      	;abs 0x431c
    4318:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    431c:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4320:	0d 4c       	mov	r12,	r13	;
    4322:	5d f3       	and.b	#1,	r13	;r3 As==01
    4324:	5c 03       	rrum	#1,	r12	;
    4326:	0e 93       	cmp	#0,	r14	;r3 As==00
    4328:	02 24       	jz	$+6      	;abs 0x432e
    432a:	80 00 be 5e 	mova	#24254,	r0	;0x05ebe
    432e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4330:	02 24       	jz	$+6      	;abs 0x4336
    4332:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4336:	0d 4c       	mov	r12,	r13	;
    4338:	5d 03       	rrum	#1,	r13	;
    433a:	1c b3       	bit	#1,	r12	;r3 As==01
    433c:	02 24       	jz	$+6      	;abs 0x4342
    433e:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4342:	09 4d       	mov	r13,	r9	;
    4344:	59 03       	rrum	#1,	r9	;
    4346:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    434a:	1d b3       	bit	#1,	r13	;r3 As==01
    434c:	02 24       	jz	$+6      	;abs 0x4352
    434e:	80 00 fa 5e 	mova	#24314,	r0	;0x05efa
    4352:	b1 40 00 1c 	mov	#7168,	14(r1)	;#0x1c00, 0x000e
    4356:	0e 00 
    4358:	44 43       	clr.b	r4		;
    435a:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    435e:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4362:	5c f3       	and.b	#1,	r12	;r3 As==01
    4364:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    4368:	5a 03       	rrum	#1,	r10	;
    436a:	0d 93       	cmp	#0,	r13	;r3 As==00
    436c:	02 20       	jnz	$+6      	;abs 0x4372
    436e:	80 00 22 5e 	mova	#24098,	r0	;0x05e22
    4372:	0c 93       	cmp	#0,	r12	;r3 As==00
    4374:	02 24       	jz	$+6      	;abs 0x437a
    4376:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    437a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    437e:	0c 4a       	mov	r10,	r12	;
    4380:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4384:	46 4c       	mov.b	r12,	r6	;
    4386:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    438a:	86 11       	sxt	r6		;
    438c:	08 4a       	mov	r10,	r8	;
    438e:	58 03       	rrum	#1,	r8	;
    4390:	1a b3       	bit	#1,	r10	;r3 As==01
    4392:	02 24       	jz	$+6      	;abs 0x4398
    4394:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4398:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    439c:	0c 48       	mov	r8,	r12	;
    439e:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    43a2:	4a 4c       	mov.b	r12,	r10	;
    43a4:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    43a8:	8a 11       	sxt	r10		;
    43aa:	09 48       	mov	r8,	r9	;
    43ac:	59 03       	rrum	#1,	r9	;
    43ae:	18 b3       	bit	#1,	r8	;r3 As==01
    43b0:	02 24       	jz	$+6      	;abs 0x43b6
    43b2:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    43b6:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43ba:	0c 49       	mov	r9,	r12	;
    43bc:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    43c0:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    43c4:	8c 11       	sxt	r12		;
    43c6:	81 4c 06 00 	mov	r12,	6(r1)	;
    43ca:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    43ce:	0c 49       	mov	r9,	r12	;
    43d0:	5c f3       	and.b	#1,	r12	;r3 As==01
    43d2:	59 03       	rrum	#1,	r9	;
    43d4:	0d 93       	cmp	#0,	r13	;r3 As==00
    43d6:	02 20       	jnz	$+6      	;abs 0x43dc
    43d8:	80 00 d2 5d 	mova	#24018,	r0	;0x05dd2
    43dc:	0c 93       	cmp	#0,	r12	;r3 As==00
    43de:	02 24       	jz	$+6      	;abs 0x43e4
    43e0:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    43e4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43e8:	0c 49       	mov	r9,	r12	;
    43ea:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    43ee:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    43f2:	8c 11       	sxt	r12		;
    43f4:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    43f8:	08 49       	mov	r9,	r8	;
    43fa:	58 03       	rrum	#1,	r8	;
    43fc:	19 b3       	bit	#1,	r9	;r3 As==01
    43fe:	02 24       	jz	$+6      	;abs 0x4404
    4400:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4404:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4408:	0c 48       	mov	r8,	r12	;
    440a:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    440e:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4412:	8c 11       	sxt	r12		;
    4414:	81 4c 10 00 	mov	r12,	16(r1)	; 0x0010
    4418:	09 48       	mov	r8,	r9	;
    441a:	59 03       	rrum	#1,	r9	;
    441c:	18 b3       	bit	#1,	r8	;r3 As==01
    441e:	02 24       	jz	$+6      	;abs 0x4424
    4420:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4424:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4428:	0c 49       	mov	r9,	r12	;
    442a:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    442e:	47 4c       	mov.b	r12,	r7	;
    4430:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4434:	87 11       	sxt	r7		;
    4436:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    443a:	0c 49       	mov	r9,	r12	;
    443c:	5c f3       	and.b	#1,	r12	;r3 As==01
    443e:	59 03       	rrum	#1,	r9	;
    4440:	0d 93       	cmp	#0,	r13	;r3 As==00
    4442:	02 20       	jnz	$+6      	;abs 0x4448
    4444:	80 00 7c 5d 	mova	#23932,	r0	;0x05d7c
    4448:	0c 93       	cmp	#0,	r12	;r3 As==00
    444a:	02 24       	jz	$+6      	;abs 0x4450
    444c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4450:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4454:	0c 49       	mov	r9,	r12	;
    4456:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    445a:	48 4c       	mov.b	r12,	r8	;
    445c:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    4460:	88 11       	sxt	r8		;
    4462:	05 49       	mov	r9,	r5	;
    4464:	55 03       	rrum	#1,	r5	;
    4466:	19 b3       	bit	#1,	r9	;r3 As==01
    4468:	02 24       	jz	$+6      	;abs 0x446e
    446a:	35 e0 00 b4 	xor	#-19456,r5	;#0xb400
    446e:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4472:	0c 45       	mov	r5,	r12	;
    4474:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4478:	49 4c       	mov.b	r12,	r9	;
    447a:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    447e:	89 11       	sxt	r9		;
    4480:	0d 45       	mov	r5,	r13	;
    4482:	5d 03       	rrum	#1,	r13	;
    4484:	81 4d 12 00 	mov	r13,	18(r1)	; 0x0012
    4488:	15 b3       	bit	#1,	r5	;r3 As==01
    448a:	03 24       	jz	$+8      	;abs 0x4492
    448c:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    4490:	12 00 
    4492:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    4496:	82 1c 
    4498:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    449c:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    44a0:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    44a4:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    44a8:	8c 11       	sxt	r12		;
    44aa:	0e 46       	mov	r6,	r14	;
    44ac:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44b0:	4d 4e       	mov.b	r14,	r13	;
    44b2:	4d e6       	xor.b	r6,	r13	;
    44b4:	4d 8e       	sub.b	r14,	r13	;
    44b6:	7e 40 09 00 	mov.b	#9,	r14	;
    44ba:	4e 9d       	cmp.b	r13,	r14	;
    44bc:	02 28       	jnc	$+6      	;abs 0x44c2
    44be:	80 00 70 5d 	mova	#23920,	r0	;0x05d70
    44c2:	81 46 1c 00 	mov	r6,	28(r1)	; 0x001c
    44c6:	05 46       	mov	r6,	r5	;
    44c8:	4e 18 06 11 	rpt #15 { rrax.w	r6		;
    44cc:	0e 4a       	mov	r10,	r14	;
    44ce:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44d2:	4d 4e       	mov.b	r14,	r13	;
    44d4:	4d ea       	xor.b	r10,	r13	;
    44d6:	4d 8e       	sub.b	r14,	r13	;
    44d8:	7e 40 09 00 	mov.b	#9,	r14	;
    44dc:	4e 9d       	cmp.b	r13,	r14	;
    44de:	02 28       	jnc	$+6      	;abs 0x44e4
    44e0:	80 00 64 5d 	mova	#23908,	r0	;0x05d64
    44e4:	81 4a 22 00 	mov	r10,	34(r1)	; 0x0022
    44e8:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    44ec:	0b 7b       	subc	r11,	r11	;
    44ee:	3b e3       	inv	r11		;
    44f0:	1e 41 06 00 	mov	6(r1),	r14	;
    44f4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    44f8:	1d 41 06 00 	mov	6(r1),	r13	;
    44fc:	4d ee       	xor.b	r14,	r13	;
    44fe:	4d 8e       	sub.b	r14,	r13	;
    4500:	7e 40 09 00 	mov.b	#9,	r14	;
    4504:	4e 9d       	cmp.b	r13,	r14	;
    4506:	02 28       	jnc	$+6      	;abs 0x450c
    4508:	80 00 54 5d 	mova	#23892,	r0	;0x05d54
    450c:	1e 41 06 00 	mov	6(r1),	r14	;
    4510:	0d 4e       	mov	r14,	r13	;
    4512:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4516:	81 4d 02 00 	mov	r13,	2(r1)	;
    451a:	81 4e 04 00 	mov	r14,	4(r1)	;
    451e:	1e 41 0a 00 	mov	10(r1),	r14	;0x0000a
    4522:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4526:	1d 41 0a 00 	mov	10(r1),	r13	;0x0000a
    452a:	4d ee       	xor.b	r14,	r13	;
    452c:	4d 8e       	sub.b	r14,	r13	;
    452e:	81 44 14 00 	mov	r4,	20(r1)	; 0x0014
    4532:	7e 40 09 00 	mov.b	#9,	r14	;
    4536:	4e 9d       	cmp.b	r13,	r14	;
    4538:	0b 2c       	jc	$+24     	;abs 0x4550
    453a:	91 41 0a 00 	mov	10(r1),	20(r1)	;0x0000a, 0x0014
    453e:	14 00 
    4540:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4544:	0e 4d       	mov	r13,	r14	;
    4546:	0f 4d       	mov	r13,	r15	;
    4548:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    454c:	05 5e       	add	r14,	r5	;
    454e:	06 6f       	addc	r15,	r6	;
    4550:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    4554:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4558:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    455c:	4d ee       	xor.b	r14,	r13	;
    455e:	4d 8e       	sub.b	r14,	r13	;
    4560:	81 44 16 00 	mov	r4,	22(r1)	; 0x0016
    4564:	7e 40 09 00 	mov.b	#9,	r14	;
    4568:	4e 9d       	cmp.b	r13,	r14	;
    456a:	0b 2c       	jc	$+24     	;abs 0x4582
    456c:	91 41 10 00 	mov	16(r1),	22(r1)	;0x00010, 0x0016
    4570:	16 00 
    4572:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4576:	0e 4d       	mov	r13,	r14	;
    4578:	0f 4d       	mov	r13,	r15	;
    457a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    457e:	0a 5e       	add	r14,	r10	;
    4580:	0b 6f       	addc	r15,	r11	;
    4582:	0e 47       	mov	r7,	r14	;
    4584:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4588:	4d 4e       	mov.b	r14,	r13	;
    458a:	4d e7       	xor.b	r7,	r13	;
    458c:	4d 8e       	sub.b	r14,	r13	;
    458e:	81 44 10 00 	mov	r4,	16(r1)	; 0x0010
    4592:	7e 40 09 00 	mov.b	#9,	r14	;
    4596:	4e 9d       	cmp.b	r13,	r14	;
    4598:	10 2c       	jc	$+34     	;abs 0x45ba
    459a:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    459e:	0d 47       	mov	r7,	r13	;
    45a0:	0e 47       	mov	r7,	r14	;
    45a2:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    45a6:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    45aa:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    45ae:	91 51 0a 00 	rla	10(r1)		;#0x0000a
    45b2:	02 00 
    45b4:	91 61 0c 00 	rlc	12(r1)		;#0x0000c
    45b8:	04 00 
    45ba:	0e 48       	mov	r8,	r14	;
    45bc:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    45c0:	4d 4e       	mov.b	r14,	r13	;
    45c2:	4d e8       	xor.b	r8,	r13	;
    45c4:	4d 8e       	sub.b	r14,	r13	;
    45c6:	7e 40 09 00 	mov.b	#9,	r14	;
    45ca:	4e 9d       	cmp.b	r13,	r14	;
    45cc:	02 28       	jnc	$+6      	;abs 0x45d2
    45ce:	80 00 44 5d 	mova	#23876,	r0	;0x05d44
    45d2:	81 48 24 00 	mov	r8,	36(r1)	; 0x0024
    45d6:	0d 48       	mov	r8,	r13	;
    45d8:	0e 48       	mov	r8,	r14	;
    45da:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    45de:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    45e2:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    45e6:	0e 49       	mov	r9,	r14	;
    45e8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    45ec:	4d 4e       	mov.b	r14,	r13	;
    45ee:	4d e9       	xor.b	r9,	r13	;
    45f0:	4d 8e       	sub.b	r14,	r13	;
    45f2:	7e 40 09 00 	mov.b	#9,	r14	;
    45f6:	4e 9d       	cmp.b	r13,	r14	;
    45f8:	02 28       	jnc	$+6      	;abs 0x45fe
    45fa:	80 00 2a 5d 	mova	#23850,	r0	;0x05d2a
    45fe:	81 49 26 00 	mov	r9,	38(r1)	; 0x0026
    4602:	0e 49       	mov	r9,	r14	;
    4604:	0f 49       	mov	r9,	r15	;
    4606:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    460a:	09 4c       	mov	r12,	r9	;
    460c:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    4610:	4d 49       	mov.b	r9,	r13	;
    4612:	4d ec       	xor.b	r12,	r13	;
    4614:	4d 89       	sub.b	r9,	r13	;
    4616:	79 40 09 00 	mov.b	#9,	r9	;
    461a:	49 9d       	cmp.b	r13,	r9	;
    461c:	02 28       	jnc	$+6      	;abs 0x4622
    461e:	80 00 1e 5d 	mova	#23838,	r0	;0x05d1e
    4622:	81 4c 28 00 	mov	r12,	40(r1)	; 0x0028
    4626:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    462a:	0d 7d       	subc	r13,	r13	;
    462c:	3d e3       	inv	r13		;
    462e:	08 4e       	mov	r14,	r8	;
    4630:	08 5a       	add	r10,	r8	;
    4632:	09 4f       	mov	r15,	r9	;
    4634:	09 6b       	addc	r11,	r9	;
    4636:	0a 4c       	mov	r12,	r10	;
    4638:	1a 51 02 00 	add	2(r1),	r10	;
    463c:	17 41 04 00 	mov	4(r1),	r7	;
    4640:	07 6d       	addc	r13,	r7	;
    4642:	7e 40 03 00 	mov.b	#3,	r14	;
    4646:	4f 43       	clr.b	r15		;
    4648:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    464c:	0c 55       	add	r5,	r12	;
    464e:	1d 41 0c 00 	mov	12(r1),	r13	;0x0000c
    4652:	0d 66       	addc	r6,	r13	;
    4654:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    4658:	81 4c 02 00 	mov	r12,	2(r1)	;
    465c:	7e 40 03 00 	mov.b	#3,	r14	;
    4660:	4f 43       	clr.b	r15		;
    4662:	0c 48       	mov	r8,	r12	;
    4664:	0d 49       	mov	r9,	r13	;
    4666:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    466a:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    466e:	7e 40 03 00 	mov.b	#3,	r14	;
    4672:	4f 43       	clr.b	r15		;
    4674:	0c 4a       	mov	r10,	r12	;
    4676:	0d 47       	mov	r7,	r13	;
    4678:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    467c:	05 4c       	mov	r12,	r5	;
    467e:	16 41 1c 00 	mov	28(r1),	r6	;0x0001c
    4682:	16 81 02 00 	sub	2(r1),	r6	;
    4686:	0c 46       	mov	r6,	r12	;
    4688:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    468c:	06 ec       	xor	r12,	r6	;
    468e:	0e 46       	mov	r6,	r14	;
    4690:	0e 8c       	sub	r12,	r14	;
    4692:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4696:	0f 7f       	subc	r15,	r15	;
    4698:	3f e3       	inv	r15		;
    469a:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    469e:	1c 81 02 00 	sub	2(r1),	r12	;
    46a2:	0d 4c       	mov	r12,	r13	;
    46a4:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    46a8:	0c ed       	xor	r13,	r12	;
    46aa:	0c 8d       	sub	r13,	r12	;
    46ac:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    46b0:	0d 7d       	subc	r13,	r13	;
    46b2:	3d e3       	inv	r13		;
    46b4:	0c 5e       	add	r14,	r12	;
    46b6:	0a 4f       	mov	r15,	r10	;
    46b8:	0a 6d       	addc	r13,	r10	;
    46ba:	81 4a 14 00 	mov	r10,	20(r1)	; 0x0014
    46be:	1a 41 22 00 	mov	34(r1),	r10	;0x00022
    46c2:	1a 81 0a 00 	sub	10(r1),	r10	;0x0000a
    46c6:	0d 4a       	mov	r10,	r13	;
    46c8:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    46cc:	0a ed       	xor	r13,	r10	;
    46ce:	0a 8d       	sub	r13,	r10	;
    46d0:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    46d4:	0b 7b       	subc	r11,	r11	;
    46d6:	3b e3       	inv	r11		;
    46d8:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    46dc:	1d 81 0a 00 	sub	10(r1),	r13	;0x0000a
    46e0:	0f 4d       	mov	r13,	r15	;
    46e2:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    46e6:	0d ef       	xor	r15,	r13	;
    46e8:	0e 4d       	mov	r13,	r14	;
    46ea:	0e 8f       	sub	r15,	r14	;
    46ec:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    46f0:	0f 7f       	subc	r15,	r15	;
    46f2:	3f e3       	inv	r15		;
    46f4:	09 4a       	mov	r10,	r9	;
    46f6:	09 5e       	add	r14,	r9	;
    46f8:	08 4b       	mov	r11,	r8	;
    46fa:	08 6f       	addc	r15,	r8	;
    46fc:	1d 41 06 00 	mov	6(r1),	r13	;
    4700:	0d 85       	sub	r5,	r13	;
    4702:	0e 4d       	mov	r13,	r14	;
    4704:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4708:	0d ee       	xor	r14,	r13	;
    470a:	0a 4d       	mov	r13,	r10	;
    470c:	0a 8e       	sub	r14,	r10	;
    470e:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4712:	0b 7b       	subc	r11,	r11	;
    4714:	3b e3       	inv	r11		;
    4716:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    471a:	0d 85       	sub	r5,	r13	;
    471c:	0f 4d       	mov	r13,	r15	;
    471e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4722:	0d ef       	xor	r15,	r13	;
    4724:	0e 4d       	mov	r13,	r14	;
    4726:	0e 8f       	sub	r15,	r14	;
    4728:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    472c:	0f 7f       	subc	r15,	r15	;
    472e:	3f e3       	inv	r15		;
    4730:	07 4a       	mov	r10,	r7	;
    4732:	07 5e       	add	r14,	r7	;
    4734:	0d 4b       	mov	r11,	r13	;
    4736:	0d 6f       	addc	r15,	r13	;
    4738:	1e 41 24 00 	mov	36(r1),	r14	;0x00024
    473c:	1e 81 02 00 	sub	2(r1),	r14	;
    4740:	0f 4e       	mov	r14,	r15	;
    4742:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4746:	0e ef       	xor	r15,	r14	;
    4748:	0a 4e       	mov	r14,	r10	;
    474a:	0a 8f       	sub	r15,	r10	;
    474c:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4750:	0b 7b       	subc	r11,	r11	;
    4752:	3b e3       	inv	r11		;
    4754:	1e 41 26 00 	mov	38(r1),	r14	;0x00026
    4758:	1e 81 0a 00 	sub	10(r1),	r14	;0x0000a
    475c:	0f 4e       	mov	r14,	r15	;
    475e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4762:	0e ef       	xor	r15,	r14	;
    4764:	0e 8f       	sub	r15,	r14	;
    4766:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    476a:	0f 7f       	subc	r15,	r15	;
    476c:	3f e3       	inv	r15		;
    476e:	09 5e       	add	r14,	r9	;
    4770:	08 6f       	addc	r15,	r8	;
    4772:	1e 41 28 00 	mov	40(r1),	r14	;0x00028
    4776:	0e 85       	sub	r5,	r14	;
    4778:	0f 4e       	mov	r14,	r15	;
    477a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    477e:	0e ef       	xor	r15,	r14	;
    4780:	0e 8f       	sub	r15,	r14	;
    4782:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4786:	0f 7f       	subc	r15,	r15	;
    4788:	3f e3       	inv	r15		;
    478a:	07 5e       	add	r14,	r7	;
    478c:	06 4f       	mov	r15,	r6	;
    478e:	06 6d       	addc	r13,	r6	;
    4790:	7e 40 03 00 	mov.b	#3,	r14	;
    4794:	4f 43       	clr.b	r15		;
    4796:	0c 5a       	add	r10,	r12	;
    4798:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    479c:	0d 6b       	addc	r11,	r13	;
    479e:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    47a2:	0a 4c       	mov	r12,	r10	;
    47a4:	7e 40 03 00 	mov.b	#3,	r14	;
    47a8:	4f 43       	clr.b	r15		;
    47aa:	0c 49       	mov	r9,	r12	;
    47ac:	0d 48       	mov	r8,	r13	;
    47ae:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    47b2:	09 4c       	mov	r12,	r9	;
    47b4:	7e 40 03 00 	mov.b	#3,	r14	;
    47b8:	4f 43       	clr.b	r15		;
    47ba:	0c 47       	mov	r7,	r12	;
    47bc:	0d 46       	mov	r6,	r13	;
    47be:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    47c2:	08 4c       	mov	r12,	r8	;
    47c4:	0c 4a       	mov	r10,	r12	;
    47c6:	0d 4a       	mov	r10,	r13	;
    47c8:	b0 12 0e 60 	call	#24590		;#0x600e
    47cc:	0a 4c       	mov	r12,	r10	;
    47ce:	0c 49       	mov	r9,	r12	;
    47d0:	0d 49       	mov	r9,	r13	;
    47d2:	b0 12 0e 60 	call	#24590		;#0x600e
    47d6:	0a 5c       	add	r12,	r10	;
    47d8:	0c 48       	mov	r8,	r12	;
    47da:	0d 48       	mov	r8,	r13	;
    47dc:	b0 12 0e 60 	call	#24590		;#0x600e
    47e0:	0a 5c       	add	r12,	r10	;
    47e2:	1c 41 02 00 	mov	2(r1),	r12	;
    47e6:	0d 4c       	mov	r12,	r13	;
    47e8:	b0 12 0e 60 	call	#24590		;#0x600e
    47ec:	07 4c       	mov	r12,	r7	;
    47ee:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    47f2:	0d 4c       	mov	r12,	r13	;
    47f4:	b0 12 0e 60 	call	#24590		;#0x600e
    47f8:	07 5c       	add	r12,	r7	;
    47fa:	0c 45       	mov	r5,	r12	;
    47fc:	0d 45       	mov	r5,	r13	;
    47fe:	b0 12 0e 60 	call	#24590		;#0x600e
    4802:	07 5c       	add	r12,	r7	;
    4804:	08 47       	mov	r7,	r8	;
    4806:	09 43       	clr	r9		;
    4808:	76 40 80 00 	mov.b	#128,	r6	;#0x0080
    480c:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    4810:	0c 97       	cmp	r7,	r12	;
    4812:	01 28       	jnc	$+4      	;abs 0x4816
    4814:	06 44       	mov	r4,	r6	;
    4816:	05 46       	mov	r6,	r5	;
    4818:	35 d0 40 00 	bis	#64,	r5	;#0x0040
    481c:	0c 45       	mov	r5,	r12	;
    481e:	0d 44       	mov	r4,	r13	;
    4820:	0e 45       	mov	r5,	r14	;
    4822:	0f 44       	mov	r4,	r15	;
    4824:	b0 12 22 60 	call	#24610		;#0x6022
    4828:	0d 93       	cmp	#0,	r13	;r3 As==00
    482a:	04 20       	jnz	$+10     	;abs 0x4834
    482c:	09 93       	cmp	#0,	r9	;r3 As==00
    482e:	05 20       	jnz	$+12     	;abs 0x483a
    4830:	07 9c       	cmp	r12,	r7	;
    4832:	03 2c       	jc	$+8      	;abs 0x483a
    4834:	05 46       	mov	r6,	r5	;
    4836:	35 f0 bf ff 	and	#-65,	r5	;#0xffbf
    483a:	06 45       	mov	r5,	r6	;
    483c:	36 d0 20 00 	bis	#32,	r6	;#0x0020
    4840:	0c 46       	mov	r6,	r12	;
    4842:	0d 44       	mov	r4,	r13	;
    4844:	0e 46       	mov	r6,	r14	;
    4846:	0f 44       	mov	r4,	r15	;
    4848:	b0 12 22 60 	call	#24610		;#0x6022
    484c:	0d 93       	cmp	#0,	r13	;r3 As==00
    484e:	04 20       	jnz	$+10     	;abs 0x4858
    4850:	09 93       	cmp	#0,	r9	;r3 As==00
    4852:	05 20       	jnz	$+12     	;abs 0x485e
    4854:	07 9c       	cmp	r12,	r7	;
    4856:	03 2c       	jc	$+8      	;abs 0x485e
    4858:	06 45       	mov	r5,	r6	;
    485a:	36 f0 df ff 	and	#-33,	r6	;#0xffdf
    485e:	05 46       	mov	r6,	r5	;
    4860:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4864:	0c 45       	mov	r5,	r12	;
    4866:	0d 44       	mov	r4,	r13	;
    4868:	0e 45       	mov	r5,	r14	;
    486a:	0f 44       	mov	r4,	r15	;
    486c:	b0 12 22 60 	call	#24610		;#0x6022
    4870:	0d 93       	cmp	#0,	r13	;r3 As==00
    4872:	04 20       	jnz	$+10     	;abs 0x487c
    4874:	09 93       	cmp	#0,	r9	;r3 As==00
    4876:	05 20       	jnz	$+12     	;abs 0x4882
    4878:	07 9c       	cmp	r12,	r7	;
    487a:	03 2c       	jc	$+8      	;abs 0x4882
    487c:	05 46       	mov	r6,	r5	;
    487e:	35 f0 ef ff 	and	#-17,	r5	;#0xffef
    4882:	06 45       	mov	r5,	r6	;
    4884:	36 d2       	bis	#8,	r6	;r2 As==11
    4886:	0c 46       	mov	r6,	r12	;
    4888:	0d 44       	mov	r4,	r13	;
    488a:	0e 46       	mov	r6,	r14	;
    488c:	0f 44       	mov	r4,	r15	;
    488e:	b0 12 22 60 	call	#24610		;#0x6022
    4892:	0d 93       	cmp	#0,	r13	;r3 As==00
    4894:	02 24       	jz	$+6      	;abs 0x489a
    4896:	80 00 84 5a 	mova	#23172,	r0	;0x05a84
    489a:	09 93       	cmp	#0,	r9	;r3 As==00
    489c:	04 20       	jnz	$+10     	;abs 0x48a6
    489e:	07 9c       	cmp	r12,	r7	;
    48a0:	02 2c       	jc	$+6      	;abs 0x48a6
    48a2:	80 00 84 5a 	mova	#23172,	r0	;0x05a84
    48a6:	05 46       	mov	r6,	r5	;
    48a8:	25 d2       	bis	#4,	r5	;r2 As==10
    48aa:	0c 45       	mov	r5,	r12	;
    48ac:	0d 44       	mov	r4,	r13	;
    48ae:	0e 45       	mov	r5,	r14	;
    48b0:	0f 44       	mov	r4,	r15	;
    48b2:	b0 12 22 60 	call	#24610		;#0x6022
    48b6:	0d 93       	cmp	#0,	r13	;r3 As==00
    48b8:	02 24       	jz	$+6      	;abs 0x48be
    48ba:	80 00 7c 5a 	mova	#23164,	r0	;0x05a7c
    48be:	09 93       	cmp	#0,	r9	;r3 As==00
    48c0:	04 20       	jnz	$+10     	;abs 0x48ca
    48c2:	07 9c       	cmp	r12,	r7	;
    48c4:	02 2c       	jc	$+6      	;abs 0x48ca
    48c6:	80 00 7c 5a 	mova	#23164,	r0	;0x05a7c
    48ca:	06 45       	mov	r5,	r6	;
    48cc:	26 d3       	bis	#2,	r6	;r3 As==10
    48ce:	0c 46       	mov	r6,	r12	;
    48d0:	0d 44       	mov	r4,	r13	;
    48d2:	0e 46       	mov	r6,	r14	;
    48d4:	0f 44       	mov	r4,	r15	;
    48d6:	b0 12 22 60 	call	#24610		;#0x6022
    48da:	0d 93       	cmp	#0,	r13	;r3 As==00
    48dc:	02 24       	jz	$+6      	;abs 0x48e2
    48de:	80 00 74 5a 	mova	#23156,	r0	;0x05a74
    48e2:	09 93       	cmp	#0,	r9	;r3 As==00
    48e4:	04 20       	jnz	$+10     	;abs 0x48ee
    48e6:	07 9c       	cmp	r12,	r7	;
    48e8:	02 2c       	jc	$+6      	;abs 0x48ee
    48ea:	80 00 74 5a 	mova	#23156,	r0	;0x05a74
    48ee:	05 46       	mov	r6,	r5	;
    48f0:	15 d3       	bis	#1,	r5	;r3 As==01
    48f2:	0c 45       	mov	r5,	r12	;
    48f4:	0d 44       	mov	r4,	r13	;
    48f6:	0e 45       	mov	r5,	r14	;
    48f8:	0f 44       	mov	r4,	r15	;
    48fa:	b0 12 22 60 	call	#24610		;#0x6022
    48fe:	0d 93       	cmp	#0,	r13	;r3 As==00
    4900:	02 24       	jz	$+6      	;abs 0x4906
    4902:	80 00 3e 5a 	mova	#23102,	r0	;0x05a3e
    4906:	09 93       	cmp	#0,	r9	;r3 As==00
    4908:	04 20       	jnz	$+10     	;abs 0x4912
    490a:	07 9c       	cmp	r12,	r7	;
    490c:	02 2c       	jc	$+6      	;abs 0x4912
    490e:	80 00 3e 5a 	mova	#23102,	r0	;0x05a3e
    4912:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    4916:	0d 4a       	mov	r10,	r13	;
    4918:	0e 43       	clr	r14		;
    491a:	81 4d 06 00 	mov	r13,	6(r1)	;
    491e:	81 4e 08 00 	mov	r14,	8(r1)	;
    4922:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    4926:	0e 9a       	cmp	r10,	r14	;
    4928:	02 2c       	jc	$+6      	;abs 0x492e
    492a:	80 00 5e 5a 	mova	#23134,	r0	;0x05a5e
    492e:	39 40 ff 03 	mov	#1023,	r9	;#0x03ff
    4932:	78 40 20 00 	mov.b	#32,	r8	;#0x0020
    4936:	09 9a       	cmp	r10,	r9	;
    4938:	02 28       	jnc	$+6      	;abs 0x493e
    493a:	80 00 3a 5d 	mova	#23866,	r0	;0x05d3a
    493e:	09 44       	mov	r4,	r9	;
    4940:	38 d0 10 00 	bis	#16,	r8	;#0x0010
    4944:	0c 48       	mov	r8,	r12	;
    4946:	0d 49       	mov	r9,	r13	;
    4948:	0e 48       	mov	r8,	r14	;
    494a:	0f 49       	mov	r9,	r15	;
    494c:	b0 12 22 60 	call	#24610		;#0x6022
    4950:	0d 93       	cmp	#0,	r13	;r3 As==00
    4952:	02 24       	jz	$+6      	;abs 0x4958
    4954:	80 00 6c 5a 	mova	#23148,	r0	;0x05a6c
    4958:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    495c:	02 20       	jnz	$+6      	;abs 0x4962
    495e:	80 00 6e 5e 	mova	#24174,	r0	;0x05e6e
    4962:	06 48       	mov	r8,	r6	;
    4964:	36 d2       	bis	#8,	r6	;r2 As==11
    4966:	0c 46       	mov	r6,	r12	;
    4968:	0d 49       	mov	r9,	r13	;
    496a:	0e 46       	mov	r6,	r14	;
    496c:	0f 49       	mov	r9,	r15	;
    496e:	b0 12 22 60 	call	#24610		;#0x6022
    4972:	0d 93       	cmp	#0,	r13	;r3 As==00
    4974:	02 24       	jz	$+6      	;abs 0x497a
    4976:	80 00 36 5a 	mova	#23094,	r0	;0x05a36
    497a:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    497e:	04 20       	jnz	$+10     	;abs 0x4988
    4980:	0a 9c       	cmp	r12,	r10	;
    4982:	02 2c       	jc	$+6      	;abs 0x4988
    4984:	80 00 36 5a 	mova	#23094,	r0	;0x05a36
    4988:	07 46       	mov	r6,	r7	;
    498a:	27 d2       	bis	#4,	r7	;r2 As==10
    498c:	0c 47       	mov	r7,	r12	;
    498e:	0d 49       	mov	r9,	r13	;
    4990:	0e 47       	mov	r7,	r14	;
    4992:	0f 49       	mov	r9,	r15	;
    4994:	b0 12 22 60 	call	#24610		;#0x6022
    4998:	0d 93       	cmp	#0,	r13	;r3 As==00
    499a:	02 24       	jz	$+6      	;abs 0x49a0
    499c:	80 00 2e 5a 	mova	#23086,	r0	;0x05a2e
    49a0:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49a4:	04 20       	jnz	$+10     	;abs 0x49ae
    49a6:	0a 9c       	cmp	r12,	r10	;
    49a8:	02 2c       	jc	$+6      	;abs 0x49ae
    49aa:	80 00 2e 5a 	mova	#23086,	r0	;0x05a2e
    49ae:	08 47       	mov	r7,	r8	;
    49b0:	28 d3       	bis	#2,	r8	;r3 As==10
    49b2:	0c 48       	mov	r8,	r12	;
    49b4:	0d 49       	mov	r9,	r13	;
    49b6:	0e 48       	mov	r8,	r14	;
    49b8:	0f 49       	mov	r9,	r15	;
    49ba:	b0 12 22 60 	call	#24610		;#0x6022
    49be:	0d 93       	cmp	#0,	r13	;r3 As==00
    49c0:	02 24       	jz	$+6      	;abs 0x49c6
    49c2:	80 00 26 5a 	mova	#23078,	r0	;0x05a26
    49c6:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49ca:	04 20       	jnz	$+10     	;abs 0x49d4
    49cc:	0a 9c       	cmp	r12,	r10	;
    49ce:	02 2c       	jc	$+6      	;abs 0x49d4
    49d0:	80 00 26 5a 	mova	#23078,	r0	;0x05a26
    49d4:	07 48       	mov	r8,	r7	;
    49d6:	17 d3       	bis	#1,	r7	;r3 As==01
    49d8:	0c 47       	mov	r7,	r12	;
    49da:	0d 49       	mov	r9,	r13	;
    49dc:	0e 47       	mov	r7,	r14	;
    49de:	0f 49       	mov	r9,	r15	;
    49e0:	b0 12 22 60 	call	#24610		;#0x6022
    49e4:	0d 93       	cmp	#0,	r13	;r3 As==00
    49e6:	05 20       	jnz	$+12     	;abs 0x49f2
    49e8:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49ec:	04 20       	jnz	$+10     	;abs 0x49f6
    49ee:	0a 9c       	cmp	r12,	r10	;
    49f0:	02 2c       	jc	$+6      	;abs 0x49f6
    49f2:	07 48       	mov	r8,	r7	;
    49f4:	17 c3       	bic	#1,	r7	;r3 As==01
    49f6:	81 47 1a 00 	mov	r7,	26(r1)	; 0x001a
    49fa:	1a 41 0e 00 	mov	14(r1),	r10	;0x0000e
    49fe:	9a 41 18 00 	mov	24(r1),	0(r10)	;0x00018
    4a02:	00 00 
    4a04:	9a 41 1a 00 	mov	26(r1),	2(r10)	;0x0001a
    4a08:	02 00 
    4a0a:	2a 52       	add	#4,	r10	;r2 As==10
    4a0c:	81 4a 0e 00 	mov	r10,	14(r1)	; 0x000e
    4a10:	3c 40 40 1c 	mov	#7232,	r12	;#0x1c40
    4a14:	0c 9a       	cmp	r10,	r12	;
    4a16:	02 24       	jz	$+6      	;abs 0x4a1c
    4a18:	80 00 5a 43 	mova	#17242,	r0	;0x0435a
    4a1c:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    4a20:	b0 12 cc 40 	call	#16588		;#0x40cc
    4a24:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    4a28:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    4a2c:	b0 12 20 41 	call	#16672		;#0x4120
    4a30:	92 43 80 1c 	mov	#1,	&0x1c80	;r3 As==01
    4a34:	b0 12 b0 40 	call	#16560		;#0x40b0
    4a38:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    4a3c:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a40:	0d 4c       	mov	r12,	r13	;
    4a42:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a44:	5c 03       	rrum	#1,	r12	;
    4a46:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a48:	02 24       	jz	$+6      	;abs 0x4a4e
    4a4a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a4e:	0d 4c       	mov	r12,	r13	;
    4a50:	5d 03       	rrum	#1,	r13	;
    4a52:	1c b3       	bit	#1,	r12	;r3 As==01
    4a54:	02 24       	jz	$+6      	;abs 0x4a5a
    4a56:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4a5a:	0c 4d       	mov	r13,	r12	;
    4a5c:	5c 03       	rrum	#1,	r12	;
    4a5e:	1d b3       	bit	#1,	r13	;r3 As==01
    4a60:	02 24       	jz	$+6      	;abs 0x4a66
    4a62:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a66:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a6a:	0d 4c       	mov	r12,	r13	;
    4a6c:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a6e:	5c 03       	rrum	#1,	r12	;
    4a70:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a72:	02 24       	jz	$+6      	;abs 0x4a78
    4a74:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a78:	0d 4c       	mov	r12,	r13	;
    4a7a:	5d 03       	rrum	#1,	r13	;
    4a7c:	1c b3       	bit	#1,	r12	;r3 As==01
    4a7e:	02 24       	jz	$+6      	;abs 0x4a84
    4a80:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4a84:	0c 4d       	mov	r13,	r12	;
    4a86:	5c 03       	rrum	#1,	r12	;
    4a88:	1d b3       	bit	#1,	r13	;r3 As==01
    4a8a:	02 24       	jz	$+6      	;abs 0x4a90
    4a8c:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a90:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a94:	0d 4c       	mov	r12,	r13	;
    4a96:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a98:	5c 03       	rrum	#1,	r12	;
    4a9a:	0e 93       	cmp	#0,	r14	;r3 As==00
    4a9c:	02 24       	jz	$+6      	;abs 0x4aa2
    4a9e:	80 00 8e 5e 	mova	#24206,	r0	;0x05e8e
    4aa2:	0d 93       	cmp	#0,	r13	;r3 As==00
    4aa4:	02 24       	jz	$+6      	;abs 0x4aaa
    4aa6:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4aaa:	0d 4c       	mov	r12,	r13	;
    4aac:	5d 03       	rrum	#1,	r13	;
    4aae:	1c b3       	bit	#1,	r12	;r3 As==01
    4ab0:	02 24       	jz	$+6      	;abs 0x4ab6
    4ab2:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4ab6:	09 4d       	mov	r13,	r9	;
    4ab8:	59 03       	rrum	#1,	r9	;
    4aba:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    4abe:	1d b3       	bit	#1,	r13	;r3 As==01
    4ac0:	02 24       	jz	$+6      	;abs 0x4ac6
    4ac2:	80 00 ee 5e 	mova	#24302,	r0	;0x05eee
    4ac6:	b1 40 40 1c 	mov	#7232,	14(r1)	;#0x1c40, 0x000e
    4aca:	0e 00 
    4acc:	44 43       	clr.b	r4		;
    4ace:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4ad2:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4ad6:	5c f3       	and.b	#1,	r12	;r3 As==01
    4ad8:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    4adc:	5a 03       	rrum	#1,	r10	;
    4ade:	0d 93       	cmp	#0,	r13	;r3 As==00
    4ae0:	02 20       	jnz	$+6      	;abs 0x4ae6
    4ae2:	80 00 d2 5c 	mova	#23762,	r0	;0x05cd2
    4ae6:	0c 93       	cmp	#0,	r12	;r3 As==00
    4ae8:	02 24       	jz	$+6      	;abs 0x4aee
    4aea:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4aee:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4af2:	0c 4a       	mov	r10,	r12	;
    4af4:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4af8:	46 4c       	mov.b	r12,	r6	;
    4afa:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    4afe:	86 11       	sxt	r6		;
    4b00:	08 4a       	mov	r10,	r8	;
    4b02:	58 03       	rrum	#1,	r8	;
    4b04:	1a b3       	bit	#1,	r10	;r3 As==01
    4b06:	02 24       	jz	$+6      	;abs 0x4b0c
    4b08:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4b0c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b10:	0c 48       	mov	r8,	r12	;
    4b12:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4b16:	4a 4c       	mov.b	r12,	r10	;
    4b18:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    4b1c:	8a 11       	sxt	r10		;
    4b1e:	09 48       	mov	r8,	r9	;
    4b20:	59 03       	rrum	#1,	r9	;
    4b22:	18 b3       	bit	#1,	r8	;r3 As==01
    4b24:	02 24       	jz	$+6      	;abs 0x4b2a
    4b26:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b2a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b2e:	0c 49       	mov	r9,	r12	;
    4b30:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4b34:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b38:	8c 11       	sxt	r12		;
    4b3a:	81 4c 06 00 	mov	r12,	6(r1)	;
    4b3e:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4b42:	0c 49       	mov	r9,	r12	;
    4b44:	5c f3       	and.b	#1,	r12	;r3 As==01
    4b46:	59 03       	rrum	#1,	r9	;
    4b48:	0d 93       	cmp	#0,	r13	;r3 As==00
    4b4a:	02 20       	jnz	$+6      	;abs 0x4b50
    4b4c:	80 00 82 5c 	mova	#23682,	r0	;0x05c82
    4b50:	0c 93       	cmp	#0,	r12	;r3 As==00
    4b52:	02 24       	jz	$+6      	;abs 0x4b58
    4b54:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b58:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b5c:	0c 49       	mov	r9,	r12	;
    4b5e:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4b62:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b66:	8c 11       	sxt	r12		;
    4b68:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    4b6c:	08 49       	mov	r9,	r8	;
    4b6e:	58 03       	rrum	#1,	r8	;
    4b70:	19 b3       	bit	#1,	r9	;r3 As==01
    4b72:	02 24       	jz	$+6      	;abs 0x4b78
    4b74:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4b78:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b7c:	0c 48       	mov	r8,	r12	;
    4b7e:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4b82:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b86:	8c 11       	sxt	r12		;
    4b88:	81 4c 10 00 	mov	r12,	16(r1)	; 0x0010
    4b8c:	09 48       	mov	r8,	r9	;
    4b8e:	59 03       	rrum	#1,	r9	;
    4b90:	18 b3       	bit	#1,	r8	;r3 As==01
    4b92:	02 24       	jz	$+6      	;abs 0x4b98
    4b94:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b98:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b9c:	0c 49       	mov	r9,	r12	;
    4b9e:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4ba2:	47 4c       	mov.b	r12,	r7	;
    4ba4:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4ba8:	87 11       	sxt	r7		;
    4baa:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4bae:	0c 49       	mov	r9,	r12	;
    4bb0:	5c f3       	and.b	#1,	r12	;r3 As==01
    4bb2:	59 03       	rrum	#1,	r9	;
    4bb4:	0d 93       	cmp	#0,	r13	;r3 As==00
    4bb6:	02 20       	jnz	$+6      	;abs 0x4bbc
    4bb8:	80 00 2c 5c 	mova	#23596,	r0	;0x05c2c
    4bbc:	0c 93       	cmp	#0,	r12	;r3 As==00
    4bbe:	02 24       	jz	$+6      	;abs 0x4bc4
    4bc0:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4bc4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4bc8:	0c 49       	mov	r9,	r12	;
    4bca:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4bce:	48 4c       	mov.b	r12,	r8	;
    4bd0:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    4bd4:	88 11       	sxt	r8		;
    4bd6:	05 49       	mov	r9,	r5	;
    4bd8:	55 03       	rrum	#1,	r5	;
    4bda:	19 b3       	bit	#1,	r9	;r3 As==01
    4bdc:	02 24       	jz	$+6      	;abs 0x4be2
    4bde:	35 e0 00 b4 	xor	#-19456,r5	;#0xb400
    4be2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4be6:	0c 45       	mov	r5,	r12	;
    4be8:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4bec:	49 4c       	mov.b	r12,	r9	;
    4bee:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    4bf2:	89 11       	sxt	r9		;
    4bf4:	0d 45       	mov	r5,	r13	;
    4bf6:	5d 03       	rrum	#1,	r13	;
    4bf8:	81 4d 12 00 	mov	r13,	18(r1)	; 0x0012
    4bfc:	15 b3       	bit	#1,	r5	;r3 As==01
    4bfe:	03 24       	jz	$+8      	;abs 0x4c06
    4c00:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    4c04:	12 00 
    4c06:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    4c0a:	82 1c 
    4c0c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4c10:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4c14:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    4c18:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4c1c:	8c 11       	sxt	r12		;
    4c1e:	0e 46       	mov	r6,	r14	;
    4c20:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c24:	4d 4e       	mov.b	r14,	r13	;
    4c26:	4d e6       	xor.b	r6,	r13	;
    4c28:	4d 8e       	sub.b	r14,	r13	;
    4c2a:	7e 40 09 00 	mov.b	#9,	r14	;
    4c2e:	4e 9d       	cmp.b	r13,	r14	;
    4c30:	02 28       	jnc	$+6      	;abs 0x4c36
    4c32:	80 00 20 5c 	mova	#23584,	r0	;0x05c20
    4c36:	81 46 18 00 	mov	r6,	24(r1)	; 0x0018
    4c3a:	05 46       	mov	r6,	r5	;
    4c3c:	4e 18 06 11 	rpt #15 { rrax.w	r6		;
    4c40:	0e 4a       	mov	r10,	r14	;
    4c42:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c46:	4d 4e       	mov.b	r14,	r13	;
    4c48:	4d ea       	xor.b	r10,	r13	;
    4c4a:	4d 8e       	sub.b	r14,	r13	;
    4c4c:	7e 40 09 00 	mov.b	#9,	r14	;
    4c50:	4e 9d       	cmp.b	r13,	r14	;
    4c52:	02 28       	jnc	$+6      	;abs 0x4c58
    4c54:	80 00 14 5c 	mova	#23572,	r0	;0x05c14
    4c58:	81 4a 1c 00 	mov	r10,	28(r1)	; 0x001c
    4c5c:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4c60:	0b 7b       	subc	r11,	r11	;
    4c62:	3b e3       	inv	r11		;
    4c64:	1e 41 06 00 	mov	6(r1),	r14	;
    4c68:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c6c:	1d 41 06 00 	mov	6(r1),	r13	;
    4c70:	4d ee       	xor.b	r14,	r13	;
    4c72:	4d 8e       	sub.b	r14,	r13	;
    4c74:	7e 40 09 00 	mov.b	#9,	r14	;
    4c78:	4e 9d       	cmp.b	r13,	r14	;
    4c7a:	02 28       	jnc	$+6      	;abs 0x4c80
    4c7c:	80 00 04 5c 	mova	#23556,	r0	;0x05c04
    4c80:	1e 41 06 00 	mov	6(r1),	r14	;
    4c84:	0d 4e       	mov	r14,	r13	;
    4c86:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4c8a:	81 4d 02 00 	mov	r13,	2(r1)	;
    4c8e:	81 4e 04 00 	mov	r14,	4(r1)	;
    4c92:	1e 41 0a 00 	mov	10(r1),	r14	;0x0000a
    4c96:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c9a:	1d 41 0a 00 	mov	10(r1),	r13	;0x0000a
    4c9e:	4d ee       	xor.b	r14,	r13	;
    4ca0:	4d 8e       	sub.b	r14,	r13	;
    4ca2:	81 44 14 00 	mov	r4,	20(r1)	; 0x0014
    4ca6:	7e 40 09 00 	mov.b	#9,	r14	;
    4caa:	4e 9d       	cmp.b	r13,	r14	;
    4cac:	0b 2c       	jc	$+24     	;abs 0x4cc4
    4cae:	91 41 0a 00 	mov	10(r1),	20(r1)	;0x0000a, 0x0014
    4cb2:	14 00 
    4cb4:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4cb8:	0e 4d       	mov	r13,	r14	;
    4cba:	0f 4d       	mov	r13,	r15	;
    4cbc:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4cc0:	05 5e       	add	r14,	r5	;
    4cc2:	06 6f       	addc	r15,	r6	;
    4cc4:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    4cc8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4ccc:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4cd0:	4d ee       	xor.b	r14,	r13	;
    4cd2:	4d 8e       	sub.b	r14,	r13	;
    4cd4:	81 44 16 00 	mov	r4,	22(r1)	; 0x0016
    4cd8:	7e 40 09 00 	mov.b	#9,	r14	;
    4cdc:	4e 9d       	cmp.b	r13,	r14	;
    4cde:	0b 2c       	jc	$+24     	;abs 0x4cf6
    4ce0:	91 41 10 00 	mov	16(r1),	22(r1)	;0x00010, 0x0016
    4ce4:	16 00 
    4ce6:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4cea:	0e 4d       	mov	r13,	r14	;
    4cec:	0f 4d       	mov	r13,	r15	;
    4cee:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4cf2:	0a 5e       	add	r14,	r10	;
    4cf4:	0b 6f       	addc	r15,	r11	;
    4cf6:	0e 47       	mov	r7,	r14	;
    4cf8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4cfc:	4d 4e       	mov.b	r14,	r13	;
    4cfe:	4d e7       	xor.b	r7,	r13	;
    4d00:	4d 8e       	sub.b	r14,	r13	;
    4d02:	81 44 10 00 	mov	r4,	16(r1)	; 0x0010
    4d06:	7e 40 09 00 	mov.b	#9,	r14	;
    4d0a:	4e 9d       	cmp.b	r13,	r14	;
    4d0c:	10 2c       	jc	$+34     	;abs 0x4d2e
    4d0e:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    4d12:	0d 47       	mov	r7,	r13	;
    4d14:	0e 47       	mov	r7,	r14	;
    4d16:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4d1a:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    4d1e:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    4d22:	91 51 0a 00 	rla	10(r1)		;#0x0000a
    4d26:	02 00 
    4d28:	91 61 0c 00 	rlc	12(r1)		;#0x0000c
    4d2c:	04 00 
    4d2e:	0e 48       	mov	r8,	r14	;
    4d30:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4d34:	4d 4e       	mov.b	r14,	r13	;
    4d36:	4d e8       	xor.b	r8,	r13	;
    4d38:	4d 8e       	sub.b	r14,	r13	;
    4d3a:	7e 40 09 00 	mov.b	#9,	r14	;
    4d3e:	4e 9d       	cmp.b	r13,	r14	;
    4d40:	02 28       	jnc	$+6      	;abs 0x4d46
    4d42:	80 00 f4 5b 	mova	#23540,	r0	;0x05bf4
    4d46:	81 48 22 00 	mov	r8,	34(r1)	; 0x0022
    4d4a:	0d 48       	mov	r8,	r13	;
    4d4c:	0e 48       	mov	r8,	r14	;
    4d4e:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4d52:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    4d56:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    4d5a:	0e 49       	mov	r9,	r14	;
    4d5c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4d60:	4d 4e       	mov.b	r14,	r13	;
    4d62:	4d e9       	xor.b	r9,	r13	;
    4d64:	4d 8e       	sub.b	r14,	r13	;
    4d66:	7e 40 09 00 	mov.b	#9,	r14	;
    4d6a:	4e 9d       	cmp.b	r13,	r14	;
    4d6c:	02 28       	jnc	$+6      	;abs 0x4d72
    4d6e:	80 00 e8 5b 	mova	#23528,	r0	;0x05be8
    4d72:	81 49 24 00 	mov	r9,	36(r1)	; 0x0024
    4d76:	0e 49       	mov	r9,	r14	;
    4d78:	0f 49       	mov	r9,	r15	;
    4d7a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4d7e:	09 4c       	mov	r12,	r9	;
    4d80:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    4d84:	4d 49       	mov.b	r9,	r13	;
    4d86:	4d ec       	xor.b	r12,	r13	;
    4d88:	4d 89       	sub.b	r9,	r13	;
    4d8a:	79 40 09 00 	mov.b	#9,	r9	;
    4d8e:	49 9d       	cmp.b	r13,	r9	;
    4d90:	02 28       	jnc	$+6      	;abs 0x4d96
    4d92:	80 00 dc 5b 	mova	#23516,	r0	;0x05bdc
    4d96:	81 4c 26 00 	mov	r12,	38(r1)	; 0x0026
    4d9a:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4d9e:	0d 7d       	subc	r13,	r13	;
    4da0:	3d e3       	inv	r13		;
    4da2:	08 4e       	mov	r14,	r8	;
    4da4:	08 5a       	add	r10,	r8	;
    4da6:	09 4f       	mov	r15,	r9	;
    4da8:	09 6b       	addc	r11,	r9	;
    4daa:	0a 4c       	mov	r12,	r10	;
    4dac:	1a 51 02 00 	add	2(r1),	r10	;
    4db0:	17 41 04 00 	mov	4(r1),	r7	;
    4db4:	07 6d       	addc	r13,	r7	;
    4db6:	7e 40 03 00 	mov.b	#3,	r14	;
    4dba:	4f 43       	clr.b	r15		;
    4dbc:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    4dc0:	0c 55       	add	r5,	r12	;
    4dc2:	1d 41 0c 00 	mov	12(r1),	r13	;0x0000c
    4dc6:	0d 66       	addc	r6,	r13	;
    4dc8:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    4dcc:	81 4c 02 00 	mov	r12,	2(r1)	;
    4dd0:	7e 40 03 00 	mov.b	#3,	r14	;
    4dd4:	4f 43       	clr.b	r15		;
    4dd6:	0c 48       	mov	r8,	r12	;
    4dd8:	0d 49       	mov	r9,	r13	;
    4dda:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    4dde:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    4de2:	7e 40 03 00 	mov.b	#3,	r14	;
    4de6:	4f 43       	clr.b	r15		;
    4de8:	0c 4a       	mov	r10,	r12	;
    4dea:	0d 47       	mov	r7,	r13	;
    4dec:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    4df0:	05 4c       	mov	r12,	r5	;
    4df2:	16 41 18 00 	mov	24(r1),	r6	;0x00018
    4df6:	16 81 02 00 	sub	2(r1),	r6	;
    4dfa:	0c 46       	mov	r6,	r12	;
    4dfc:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    4e00:	06 ec       	xor	r12,	r6	;
    4e02:	0e 46       	mov	r6,	r14	;
    4e04:	0e 8c       	sub	r12,	r14	;
    4e06:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4e0a:	0f 7f       	subc	r15,	r15	;
    4e0c:	3f e3       	inv	r15		;
    4e0e:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    4e12:	1c 81 02 00 	sub	2(r1),	r12	;
    4e16:	0d 4c       	mov	r12,	r13	;
    4e18:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4e1c:	0c ed       	xor	r13,	r12	;
    4e1e:	0c 8d       	sub	r13,	r12	;
    4e20:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4e24:	0d 7d       	subc	r13,	r13	;
    4e26:	3d e3       	inv	r13		;
    4e28:	0c 5e       	add	r14,	r12	;
    4e2a:	0a 4f       	mov	r15,	r10	;
    4e2c:	0a 6d       	addc	r13,	r10	;
    4e2e:	81 4a 14 00 	mov	r10,	20(r1)	; 0x0014
    4e32:	1a 41 1c 00 	mov	28(r1),	r10	;0x0001c
    4e36:	1a 81 0a 00 	sub	10(r1),	r10	;0x0000a
    4e3a:	0d 4a       	mov	r10,	r13	;
    4e3c:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4e40:	0a ed       	xor	r13,	r10	;
    4e42:	0a 8d       	sub	r13,	r10	;
    4e44:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4e48:	0b 7b       	subc	r11,	r11	;
    4e4a:	3b e3       	inv	r11		;
    4e4c:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4e50:	1d 81 0a 00 	sub	10(r1),	r13	;0x0000a
    4e54:	0f 4d       	mov	r13,	r15	;
    4e56:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4e5a:	0d ef       	xor	r15,	r13	;
    4e5c:	0e 4d       	mov	r13,	r14	;
    4e5e:	0e 8f       	sub	r15,	r14	;
    4e60:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4e64:	0f 7f       	subc	r15,	r15	;
    4e66:	3f e3       	inv	r15		;
    4e68:	09 4a       	mov	r10,	r9	;
    4e6a:	09 5e       	add	r14,	r9	;
    4e6c:	08 4b       	mov	r11,	r8	;
    4e6e:	08 6f       	addc	r15,	r8	;
    4e70:	1d 41 06 00 	mov	6(r1),	r13	;
    4e74:	0d 85       	sub	r5,	r13	;
    4e76:	0e 4d       	mov	r13,	r14	;
    4e78:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4e7c:	0d ee       	xor	r14,	r13	;
    4e7e:	0a 4d       	mov	r13,	r10	;
    4e80:	0a 8e       	sub	r14,	r10	;
    4e82:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4e86:	0b 7b       	subc	r11,	r11	;
    4e88:	3b e3       	inv	r11		;
    4e8a:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4e8e:	0d 85       	sub	r5,	r13	;
    4e90:	0f 4d       	mov	r13,	r15	;
    4e92:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4e96:	0d ef       	xor	r15,	r13	;
    4e98:	0e 4d       	mov	r13,	r14	;
    4e9a:	0e 8f       	sub	r15,	r14	;
    4e9c:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4ea0:	0f 7f       	subc	r15,	r15	;
    4ea2:	3f e3       	inv	r15		;
    4ea4:	07 4a       	mov	r10,	r7	;
    4ea6:	07 5e       	add	r14,	r7	;
    4ea8:	0d 4b       	mov	r11,	r13	;
    4eaa:	0d 6f       	addc	r15,	r13	;
    4eac:	1e 41 22 00 	mov	34(r1),	r14	;0x00022
    4eb0:	1e 81 02 00 	sub	2(r1),	r14	;
    4eb4:	0f 4e       	mov	r14,	r15	;
    4eb6:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4eba:	0e ef       	xor	r15,	r14	;
    4ebc:	0a 4e       	mov	r14,	r10	;
    4ebe:	0a 8f       	sub	r15,	r10	;
    4ec0:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4ec4:	0b 7b       	subc	r11,	r11	;
    4ec6:	3b e3       	inv	r11		;
    4ec8:	1e 41 24 00 	mov	36(r1),	r14	;0x00024
    4ecc:	1e 81 0a 00 	sub	10(r1),	r14	;0x0000a
    4ed0:	0f 4e       	mov	r14,	r15	;
    4ed2:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4ed6:	0e ef       	xor	r15,	r14	;
    4ed8:	0e 8f       	sub	r15,	r14	;
    4eda:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4ede:	0f 7f       	subc	r15,	r15	;
    4ee0:	3f e3       	inv	r15		;
    4ee2:	09 5e       	add	r14,	r9	;
    4ee4:	08 6f       	addc	r15,	r8	;
    4ee6:	1e 41 26 00 	mov	38(r1),	r14	;0x00026
    4eea:	0e 85       	sub	r5,	r14	;
    4eec:	0f 4e       	mov	r14,	r15	;
    4eee:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4ef2:	0e ef       	xor	r15,	r14	;
    4ef4:	0e 8f       	sub	r15,	r14	;
    4ef6:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4efa:	0f 7f       	subc	r15,	r15	;
    4efc:	3f e3       	inv	r15		;
    4efe:	07 5e       	add	r14,	r7	;
    4f00:	06 4f       	mov	r15,	r6	;
    4f02:	06 6d       	addc	r13,	r6	;
    4f04:	7e 40 03 00 	mov.b	#3,	r14	;
    4f08:	4f 43       	clr.b	r15		;
    4f0a:	0c 5a       	add	r10,	r12	;
    4f0c:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4f10:	0d 6b       	addc	r11,	r13	;
    4f12:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    4f16:	0a 4c       	mov	r12,	r10	;
    4f18:	7e 40 03 00 	mov.b	#3,	r14	;
    4f1c:	4f 43       	clr.b	r15		;
    4f1e:	0c 49       	mov	r9,	r12	;
    4f20:	0d 48       	mov	r8,	r13	;
    4f22:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    4f26:	09 4c       	mov	r12,	r9	;
    4f28:	7e 40 03 00 	mov.b	#3,	r14	;
    4f2c:	4f 43       	clr.b	r15		;
    4f2e:	0c 47       	mov	r7,	r12	;
    4f30:	0d 46       	mov	r6,	r13	;
    4f32:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    4f36:	08 4c       	mov	r12,	r8	;
    4f38:	0c 4a       	mov	r10,	r12	;
    4f3a:	0d 4a       	mov	r10,	r13	;
    4f3c:	b0 12 0e 60 	call	#24590		;#0x600e
    4f40:	0a 4c       	mov	r12,	r10	;
    4f42:	0c 49       	mov	r9,	r12	;
    4f44:	0d 49       	mov	r9,	r13	;
    4f46:	b0 12 0e 60 	call	#24590		;#0x600e
    4f4a:	0a 5c       	add	r12,	r10	;
    4f4c:	0c 48       	mov	r8,	r12	;
    4f4e:	0d 48       	mov	r8,	r13	;
    4f50:	b0 12 0e 60 	call	#24590		;#0x600e
    4f54:	0a 5c       	add	r12,	r10	;
    4f56:	1c 41 02 00 	mov	2(r1),	r12	;
    4f5a:	0d 4c       	mov	r12,	r13	;
    4f5c:	b0 12 0e 60 	call	#24590		;#0x600e
    4f60:	07 4c       	mov	r12,	r7	;
    4f62:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    4f66:	0d 4c       	mov	r12,	r13	;
    4f68:	b0 12 0e 60 	call	#24590		;#0x600e
    4f6c:	07 5c       	add	r12,	r7	;
    4f6e:	0c 45       	mov	r5,	r12	;
    4f70:	0d 45       	mov	r5,	r13	;
    4f72:	b0 12 0e 60 	call	#24590		;#0x600e
    4f76:	07 5c       	add	r12,	r7	;
    4f78:	08 47       	mov	r7,	r8	;
    4f7a:	09 43       	clr	r9		;
    4f7c:	76 40 80 00 	mov.b	#128,	r6	;#0x0080
    4f80:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    4f84:	0c 97       	cmp	r7,	r12	;
    4f86:	01 28       	jnc	$+4      	;abs 0x4f8a
    4f88:	06 44       	mov	r4,	r6	;
    4f8a:	05 46       	mov	r6,	r5	;
    4f8c:	35 d0 40 00 	bis	#64,	r5	;#0x0040
    4f90:	0c 45       	mov	r5,	r12	;
    4f92:	0d 44       	mov	r4,	r13	;
    4f94:	0e 45       	mov	r5,	r14	;
    4f96:	0f 44       	mov	r4,	r15	;
    4f98:	b0 12 22 60 	call	#24610		;#0x6022
    4f9c:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f9e:	04 20       	jnz	$+10     	;abs 0x4fa8
    4fa0:	09 93       	cmp	#0,	r9	;r3 As==00
    4fa2:	05 20       	jnz	$+12     	;abs 0x4fae
    4fa4:	07 9c       	cmp	r12,	r7	;
    4fa6:	03 2c       	jc	$+8      	;abs 0x4fae
    4fa8:	05 46       	mov	r6,	r5	;
    4faa:	35 f0 bf ff 	and	#-65,	r5	;#0xffbf
    4fae:	06 45       	mov	r5,	r6	;
    4fb0:	36 d0 20 00 	bis	#32,	r6	;#0x0020
    4fb4:	0c 46       	mov	r6,	r12	;
    4fb6:	0d 44       	mov	r4,	r13	;
    4fb8:	0e 46       	mov	r6,	r14	;
    4fba:	0f 44       	mov	r4,	r15	;
    4fbc:	b0 12 22 60 	call	#24610		;#0x6022
    4fc0:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fc2:	04 20       	jnz	$+10     	;abs 0x4fcc
    4fc4:	09 93       	cmp	#0,	r9	;r3 As==00
    4fc6:	05 20       	jnz	$+12     	;abs 0x4fd2
    4fc8:	07 9c       	cmp	r12,	r7	;
    4fca:	03 2c       	jc	$+8      	;abs 0x4fd2
    4fcc:	06 45       	mov	r5,	r6	;
    4fce:	36 f0 df ff 	and	#-33,	r6	;#0xffdf
    4fd2:	05 46       	mov	r6,	r5	;
    4fd4:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4fd8:	0c 45       	mov	r5,	r12	;
    4fda:	0d 44       	mov	r4,	r13	;
    4fdc:	0e 45       	mov	r5,	r14	;
    4fde:	0f 44       	mov	r4,	r15	;
    4fe0:	b0 12 22 60 	call	#24610		;#0x6022
    4fe4:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fe6:	04 20       	jnz	$+10     	;abs 0x4ff0
    4fe8:	09 93       	cmp	#0,	r9	;r3 As==00
    4fea:	05 20       	jnz	$+12     	;abs 0x4ff6
    4fec:	07 9c       	cmp	r12,	r7	;
    4fee:	03 2c       	jc	$+8      	;abs 0x4ff6
    4ff0:	05 46       	mov	r6,	r5	;
    4ff2:	35 f0 ef ff 	and	#-17,	r5	;#0xffef
    4ff6:	06 45       	mov	r5,	r6	;
    4ff8:	36 d2       	bis	#8,	r6	;r2 As==11
    4ffa:	0c 46       	mov	r6,	r12	;
    4ffc:	0d 44       	mov	r4,	r13	;
    4ffe:	0e 46       	mov	r6,	r14	;
    5000:	0f 44       	mov	r4,	r15	;
    5002:	b0 12 22 60 	call	#24610		;#0x6022
    5006:	0d 93       	cmp	#0,	r13	;r3 As==00
    5008:	02 24       	jz	$+6      	;abs 0x500e
    500a:	80 00 fe 5a 	mova	#23294,	r0	;0x05afe
    500e:	09 93       	cmp	#0,	r9	;r3 As==00
    5010:	04 20       	jnz	$+10     	;abs 0x501a
    5012:	07 9c       	cmp	r12,	r7	;
    5014:	02 2c       	jc	$+6      	;abs 0x501a
    5016:	80 00 fe 5a 	mova	#23294,	r0	;0x05afe
    501a:	05 46       	mov	r6,	r5	;
    501c:	25 d2       	bis	#4,	r5	;r2 As==10
    501e:	0c 45       	mov	r5,	r12	;
    5020:	0d 44       	mov	r4,	r13	;
    5022:	0e 45       	mov	r5,	r14	;
    5024:	0f 44       	mov	r4,	r15	;
    5026:	b0 12 22 60 	call	#24610		;#0x6022
    502a:	0d 93       	cmp	#0,	r13	;r3 As==00
    502c:	02 24       	jz	$+6      	;abs 0x5032
    502e:	80 00 f6 5a 	mova	#23286,	r0	;0x05af6
    5032:	09 93       	cmp	#0,	r9	;r3 As==00
    5034:	04 20       	jnz	$+10     	;abs 0x503e
    5036:	07 9c       	cmp	r12,	r7	;
    5038:	02 2c       	jc	$+6      	;abs 0x503e
    503a:	80 00 f6 5a 	mova	#23286,	r0	;0x05af6
    503e:	06 45       	mov	r5,	r6	;
    5040:	26 d3       	bis	#2,	r6	;r3 As==10
    5042:	0c 46       	mov	r6,	r12	;
    5044:	0d 44       	mov	r4,	r13	;
    5046:	0e 46       	mov	r6,	r14	;
    5048:	0f 44       	mov	r4,	r15	;
    504a:	b0 12 22 60 	call	#24610		;#0x6022
    504e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5050:	02 24       	jz	$+6      	;abs 0x5056
    5052:	80 00 ee 5a 	mova	#23278,	r0	;0x05aee
    5056:	09 93       	cmp	#0,	r9	;r3 As==00
    5058:	04 20       	jnz	$+10     	;abs 0x5062
    505a:	07 9c       	cmp	r12,	r7	;
    505c:	02 2c       	jc	$+6      	;abs 0x5062
    505e:	80 00 ee 5a 	mova	#23278,	r0	;0x05aee
    5062:	05 46       	mov	r6,	r5	;
    5064:	15 d3       	bis	#1,	r5	;r3 As==01
    5066:	0c 45       	mov	r5,	r12	;
    5068:	0d 44       	mov	r4,	r13	;
    506a:	0e 45       	mov	r5,	r14	;
    506c:	0f 44       	mov	r4,	r15	;
    506e:	b0 12 22 60 	call	#24610		;#0x6022
    5072:	0d 93       	cmp	#0,	r13	;r3 As==00
    5074:	02 24       	jz	$+6      	;abs 0x507a
    5076:	80 00 b8 5a 	mova	#23224,	r0	;0x05ab8
    507a:	09 93       	cmp	#0,	r9	;r3 As==00
    507c:	04 20       	jnz	$+10     	;abs 0x5086
    507e:	07 9c       	cmp	r12,	r7	;
    5080:	02 2c       	jc	$+6      	;abs 0x5086
    5082:	80 00 b8 5a 	mova	#23224,	r0	;0x05ab8
    5086:	81 45 1e 00 	mov	r5,	30(r1)	; 0x001e
    508a:	0d 4a       	mov	r10,	r13	;
    508c:	0e 43       	clr	r14		;
    508e:	81 4d 06 00 	mov	r13,	6(r1)	;
    5092:	81 4e 08 00 	mov	r14,	8(r1)	;
    5096:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    509a:	0e 9a       	cmp	r10,	r14	;
    509c:	02 2c       	jc	$+6      	;abs 0x50a2
    509e:	80 00 d8 5a 	mova	#23256,	r0	;0x05ad8
    50a2:	39 40 ff 03 	mov	#1023,	r9	;#0x03ff
    50a6:	78 40 20 00 	mov.b	#32,	r8	;#0x0020
    50aa:	09 9a       	cmp	r10,	r9	;
    50ac:	02 28       	jnc	$+6      	;abs 0x50b2
    50ae:	80 00 d2 5b 	mova	#23506,	r0	;0x05bd2
    50b2:	09 44       	mov	r4,	r9	;
    50b4:	38 d0 10 00 	bis	#16,	r8	;#0x0010
    50b8:	0c 48       	mov	r8,	r12	;
    50ba:	0d 49       	mov	r9,	r13	;
    50bc:	0e 48       	mov	r8,	r14	;
    50be:	0f 49       	mov	r9,	r15	;
    50c0:	b0 12 22 60 	call	#24610		;#0x6022
    50c4:	0d 93       	cmp	#0,	r13	;r3 As==00
    50c6:	02 24       	jz	$+6      	;abs 0x50cc
    50c8:	80 00 e6 5a 	mova	#23270,	r0	;0x05ae6
    50cc:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    50d0:	02 20       	jnz	$+6      	;abs 0x50d6
    50d2:	80 00 7e 5e 	mova	#24190,	r0	;0x05e7e
    50d6:	06 48       	mov	r8,	r6	;
    50d8:	36 d2       	bis	#8,	r6	;r2 As==11
    50da:	0c 46       	mov	r6,	r12	;
    50dc:	0d 49       	mov	r9,	r13	;
    50de:	0e 46       	mov	r6,	r14	;
    50e0:	0f 49       	mov	r9,	r15	;
    50e2:	b0 12 22 60 	call	#24610		;#0x6022
    50e6:	0d 93       	cmp	#0,	r13	;r3 As==00
    50e8:	02 24       	jz	$+6      	;abs 0x50ee
    50ea:	80 00 b0 5a 	mova	#23216,	r0	;0x05ab0
    50ee:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    50f2:	04 20       	jnz	$+10     	;abs 0x50fc
    50f4:	0a 9c       	cmp	r12,	r10	;
    50f6:	02 2c       	jc	$+6      	;abs 0x50fc
    50f8:	80 00 b0 5a 	mova	#23216,	r0	;0x05ab0
    50fc:	07 46       	mov	r6,	r7	;
    50fe:	27 d2       	bis	#4,	r7	;r2 As==10
    5100:	0c 47       	mov	r7,	r12	;
    5102:	0d 49       	mov	r9,	r13	;
    5104:	0e 47       	mov	r7,	r14	;
    5106:	0f 49       	mov	r9,	r15	;
    5108:	b0 12 22 60 	call	#24610		;#0x6022
    510c:	0d 93       	cmp	#0,	r13	;r3 As==00
    510e:	02 24       	jz	$+6      	;abs 0x5114
    5110:	80 00 8c 5a 	mova	#23180,	r0	;0x05a8c
    5114:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    5118:	04 20       	jnz	$+10     	;abs 0x5122
    511a:	0a 9c       	cmp	r12,	r10	;
    511c:	02 2c       	jc	$+6      	;abs 0x5122
    511e:	80 00 8c 5a 	mova	#23180,	r0	;0x05a8c
    5122:	08 47       	mov	r7,	r8	;
    5124:	28 d3       	bis	#2,	r8	;r3 As==10
    5126:	0c 48       	mov	r8,	r12	;
    5128:	0d 49       	mov	r9,	r13	;
    512a:	0e 48       	mov	r8,	r14	;
    512c:	0f 49       	mov	r9,	r15	;
    512e:	b0 12 22 60 	call	#24610		;#0x6022
    5132:	0d 93       	cmp	#0,	r13	;r3 As==00
    5134:	02 24       	jz	$+6      	;abs 0x513a
    5136:	80 00 a8 5a 	mova	#23208,	r0	;0x05aa8
    513a:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    513e:	04 20       	jnz	$+10     	;abs 0x5148
    5140:	0a 9c       	cmp	r12,	r10	;
    5142:	02 2c       	jc	$+6      	;abs 0x5148
    5144:	80 00 a8 5a 	mova	#23208,	r0	;0x05aa8
    5148:	07 48       	mov	r8,	r7	;
    514a:	17 d3       	bis	#1,	r7	;r3 As==01
    514c:	0c 47       	mov	r7,	r12	;
    514e:	0d 49       	mov	r9,	r13	;
    5150:	0e 47       	mov	r7,	r14	;
    5152:	0f 49       	mov	r9,	r15	;
    5154:	b0 12 22 60 	call	#24610		;#0x6022
    5158:	0d 93       	cmp	#0,	r13	;r3 As==00
    515a:	05 20       	jnz	$+12     	;abs 0x5166
    515c:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    5160:	04 20       	jnz	$+10     	;abs 0x516a
    5162:	0a 9c       	cmp	r12,	r10	;
    5164:	02 2c       	jc	$+6      	;abs 0x516a
    5166:	07 48       	mov	r8,	r7	;
    5168:	17 c3       	bic	#1,	r7	;r3 As==01
    516a:	81 47 20 00 	mov	r7,	32(r1)	; 0x0020
    516e:	1a 41 0e 00 	mov	14(r1),	r10	;0x0000e
    5172:	9a 41 1e 00 	mov	30(r1),	0(r10)	;0x0001e
    5176:	00 00 
    5178:	9a 41 20 00 	mov	32(r1),	2(r10)	;0x00020
    517c:	02 00 
    517e:	2a 52       	add	#4,	r10	;r2 As==10
    5180:	81 4a 0e 00 	mov	r10,	14(r1)	; 0x000e
    5184:	3c 40 80 1c 	mov	#7296,	r12	;#0x1c80
    5188:	0c 9a       	cmp	r10,	r12	;
    518a:	02 24       	jz	$+6      	;abs 0x5190
    518c:	80 00 ce 4a 	mova	#19150,	r0	;0x04ace
    5190:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    5194:	b0 12 cc 40 	call	#16588		;#0x40cc
    5198:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    519c:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    51a0:	b0 12 20 41 	call	#16672		;#0x4120
    51a4:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    51a8:	b0 12 b0 40 	call	#16560		;#0x40b0
    51ac:	81 43 2a 00 	mov	#0,	42(r1)	;r3 As==00, 0x002a
    51b0:	81 43 2c 00 	mov	#0,	44(r1)	;r3 As==00, 0x002c
    51b4:	81 43 2e 00 	mov	#0,	46(r1)	;r3 As==00, 0x002e
    51b8:	91 42 82 1c 	mov	&0x1c82,18(r1)	;0x1c82, 0x0012
    51bc:	12 00 
    51be:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    51c2:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    51c6:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    51ca:	5c f3       	and.b	#1,	r12	;r3 As==01
    51cc:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    51d0:	5a 03       	rrum	#1,	r10	;
    51d2:	0d 93       	cmp	#0,	r13	;r3 As==00
    51d4:	02 20       	jnz	$+6      	;abs 0x51da
    51d6:	80 00 c0 58 	mova	#22720,	r0	;0x058c0
    51da:	0c 93       	cmp	#0,	r12	;r3 As==00
    51dc:	02 24       	jz	$+6      	;abs 0x51e2
    51de:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    51e2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    51e6:	0c 4a       	mov	r10,	r12	;
    51e8:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    51ec:	45 4c       	mov.b	r12,	r5	;
    51ee:	75 50 e2 ff 	add.b	#-30,	r5	;#0xffe2
    51f2:	85 11       	sxt	r5		;
    51f4:	08 4a       	mov	r10,	r8	;
    51f6:	58 03       	rrum	#1,	r8	;
    51f8:	1a b3       	bit	#1,	r10	;r3 As==01
    51fa:	02 24       	jz	$+6      	;abs 0x5200
    51fc:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    5200:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5204:	0c 48       	mov	r8,	r12	;
    5206:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    520a:	4a 4c       	mov.b	r12,	r10	;
    520c:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    5210:	8a 11       	sxt	r10		;
    5212:	09 48       	mov	r8,	r9	;
    5214:	59 03       	rrum	#1,	r9	;
    5216:	18 b3       	bit	#1,	r8	;r3 As==01
    5218:	02 24       	jz	$+6      	;abs 0x521e
    521a:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    521e:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5222:	0c 49       	mov	r9,	r12	;
    5224:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    5228:	44 4c       	mov.b	r12,	r4	;
    522a:	74 50 e2 ff 	add.b	#-30,	r4	;#0xffe2
    522e:	84 11       	sxt	r4		;
    5230:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5234:	0c 49       	mov	r9,	r12	;
    5236:	5c f3       	and.b	#1,	r12	;r3 As==01
    5238:	59 03       	rrum	#1,	r9	;
    523a:	0d 93       	cmp	#0,	r13	;r3 As==00
    523c:	02 20       	jnz	$+6      	;abs 0x5242
    523e:	80 00 16 59 	mova	#22806,	r0	;0x05916
    5242:	0c 93       	cmp	#0,	r12	;r3 As==00
    5244:	02 24       	jz	$+6      	;abs 0x524a
    5246:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    524a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    524e:	0c 49       	mov	r9,	r12	;
    5250:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    5254:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    5258:	8c 11       	sxt	r12		;
    525a:	81 4c 0e 00 	mov	r12,	14(r1)	; 0x000e
    525e:	08 49       	mov	r9,	r8	;
    5260:	58 03       	rrum	#1,	r8	;
    5262:	19 b3       	bit	#1,	r9	;r3 As==01
    5264:	02 24       	jz	$+6      	;abs 0x526a
    5266:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    526a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    526e:	0c 48       	mov	r8,	r12	;
    5270:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    5274:	47 4c       	mov.b	r12,	r7	;
    5276:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    527a:	87 11       	sxt	r7		;
    527c:	09 48       	mov	r8,	r9	;
    527e:	59 03       	rrum	#1,	r9	;
    5280:	18 b3       	bit	#1,	r8	;r3 As==01
    5282:	02 24       	jz	$+6      	;abs 0x5288
    5284:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5288:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    528c:	0c 49       	mov	r9,	r12	;
    528e:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    5292:	48 4c       	mov.b	r12,	r8	;
    5294:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    5298:	88 11       	sxt	r8		;
    529a:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    529e:	0c 49       	mov	r9,	r12	;
    52a0:	5c f3       	and.b	#1,	r12	;r3 As==01
    52a2:	59 03       	rrum	#1,	r9	;
    52a4:	0d 93       	cmp	#0,	r13	;r3 As==00
    52a6:	02 20       	jnz	$+6      	;abs 0x52ac
    52a8:	80 00 70 59 	mova	#22896,	r0	;0x05970
    52ac:	0c 93       	cmp	#0,	r12	;r3 As==00
    52ae:	02 24       	jz	$+6      	;abs 0x52b4
    52b0:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    52b4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52b8:	0c 49       	mov	r9,	r12	;
    52ba:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    52be:	46 4c       	mov.b	r12,	r6	;
    52c0:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    52c4:	86 11       	sxt	r6		;
    52c6:	0e 49       	mov	r9,	r14	;
    52c8:	5e 03       	rrum	#1,	r14	;
    52ca:	19 b3       	bit	#1,	r9	;r3 As==01
    52cc:	02 24       	jz	$+6      	;abs 0x52d2
    52ce:	3e e0 00 b4 	xor	#-19456,r14	;#0xb400
    52d2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52d6:	0c 4e       	mov	r14,	r12	;
    52d8:	81 4e 00 00 	mov	r14,	0(r1)	;
    52dc:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    52e0:	49 4c       	mov.b	r12,	r9	;
    52e2:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    52e6:	89 11       	sxt	r9		;
    52e8:	2e 41       	mov	@r1,	r14	;
    52ea:	0c 4e       	mov	r14,	r12	;
    52ec:	5c 03       	rrum	#1,	r12	;
    52ee:	81 4c 12 00 	mov	r12,	18(r1)	; 0x0012
    52f2:	1e b3       	bit	#1,	r14	;r3 As==01
    52f4:	03 24       	jz	$+8      	;abs 0x52fc
    52f6:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    52fa:	12 00 
    52fc:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5300:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5304:	b0 12 3e 5f 	call	#24382		;#0x5f3e
    5308:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    530c:	8c 11       	sxt	r12		;
    530e:	0e 45       	mov	r5,	r14	;
    5310:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5314:	4d 4e       	mov.b	r14,	r13	;
    5316:	4d e5       	xor.b	r5,	r13	;
    5318:	4d 8e       	sub.b	r14,	r13	;
    531a:	7e 40 09 00 	mov.b	#9,	r14	;
    531e:	4e 9d       	cmp.b	r13,	r14	;
    5320:	02 28       	jnc	$+6      	;abs 0x5326
    5322:	80 00 d4 59 	mova	#22996,	r0	;0x059d4
    5326:	81 45 14 00 	mov	r5,	20(r1)	; 0x0014
    532a:	0d 45       	mov	r5,	r13	;
    532c:	0e 45       	mov	r5,	r14	;
    532e:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5332:	81 4d 06 00 	mov	r13,	6(r1)	;
    5336:	81 4e 08 00 	mov	r14,	8(r1)	;
    533a:	0e 4a       	mov	r10,	r14	;
    533c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5340:	4d 4e       	mov.b	r14,	r13	;
    5342:	4d ea       	xor.b	r10,	r13	;
    5344:	4d 8e       	sub.b	r14,	r13	;
    5346:	7e 40 09 00 	mov.b	#9,	r14	;
    534a:	4e 9d       	cmp.b	r13,	r14	;
    534c:	02 28       	jnc	$+6      	;abs 0x5352
    534e:	80 00 f8 59 	mova	#23032,	r0	;0x059f8
    5352:	81 4a 16 00 	mov	r10,	22(r1)	; 0x0016
    5356:	0d 4a       	mov	r10,	r13	;
    5358:	0e 4a       	mov	r10,	r14	;
    535a:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    535e:	81 4d 02 00 	mov	r13,	2(r1)	;
    5362:	81 4e 04 00 	mov	r14,	4(r1)	;
    5366:	0e 44       	mov	r4,	r14	;
    5368:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    536c:	4d 44       	mov.b	r4,	r13	;
    536e:	4d ee       	xor.b	r14,	r13	;
    5370:	4d 8e       	sub.b	r14,	r13	;
    5372:	7a 40 09 00 	mov.b	#9,	r10	;
    5376:	4a 9d       	cmp.b	r13,	r10	;
    5378:	02 28       	jnc	$+6      	;abs 0x537e
    537a:	80 00 1c 5a 	mova	#23068,	r0	;0x05a1c
    537e:	0a 44       	mov	r4,	r10	;
    5380:	0b 44       	mov	r4,	r11	;
    5382:	4e 18 0b 11 	rpt #15 { rrax.w	r11		;
    5386:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    538a:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    538e:	1d 41 0e 00 	mov	14(r1),	r13	;0x0000e
    5392:	4d ee       	xor.b	r14,	r13	;
    5394:	4d 8e       	sub.b	r14,	r13	;
    5396:	81 43 10 00 	mov	#0,	16(r1)	;r3 As==00, 0x0010
    539a:	7e 40 09 00 	mov.b	#9,	r14	;
    539e:	4e 9d       	cmp.b	r13,	r14	;
    53a0:	12 2c       	jc	$+38     	;abs 0x53c6
    53a2:	91 41 0e 00 	mov	14(r1),	16(r1)	;0x0000e, 0x0010
    53a6:	10 00 
    53a8:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    53ac:	0d 4e       	mov	r14,	r13	;
    53ae:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    53b2:	81 4d 18 00 	mov	r13,	24(r1)	; 0x0018
    53b6:	81 4e 1a 00 	mov	r14,	26(r1)	; 0x001a
    53ba:	91 51 18 00 	rla	24(r1)		;#0x00018
    53be:	06 00 
    53c0:	91 61 1a 00 	rlc	26(r1)		;#0x0001a
    53c4:	08 00 
    53c6:	0e 47       	mov	r7,	r14	;
    53c8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    53cc:	4d 4e       	mov.b	r14,	r13	;
    53ce:	4d e7       	xor.b	r7,	r13	;
    53d0:	4d 8e       	sub.b	r14,	r13	;
    53d2:	45 43       	clr.b	r5		;
    53d4:	7e 40 09 00 	mov.b	#9,	r14	;
    53d8:	4e 9d       	cmp.b	r13,	r14	;
    53da:	0f 2c       	jc	$+32     	;abs 0x53fa
    53dc:	05 47       	mov	r7,	r5	;
    53de:	0d 47       	mov	r7,	r13	;
    53e0:	0e 47       	mov	r7,	r14	;
    53e2:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    53e6:	81 4d 18 00 	mov	r13,	24(r1)	; 0x0018
    53ea:	81 4e 1a 00 	mov	r14,	26(r1)	; 0x001a
    53ee:	91 51 18 00 	rla	24(r1)		;#0x00018
    53f2:	02 00 
    53f4:	91 61 1a 00 	rlc	26(r1)		;#0x0001a
    53f8:	04 00 
    53fa:	0e 48       	mov	r8,	r14	;
    53fc:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5400:	4d 4e       	mov.b	r14,	r13	;
    5402:	4d e8       	xor.b	r8,	r13	;
    5404:	4d 8e       	sub.b	r14,	r13	;
    5406:	81 43 0e 00 	mov	#0,	14(r1)	;r3 As==00, 0x000e
    540a:	7e 40 09 00 	mov.b	#9,	r14	;
    540e:	4e 9d       	cmp.b	r13,	r14	;
    5410:	08 2c       	jc	$+18     	;abs 0x5422
    5412:	81 48 0e 00 	mov	r8,	14(r1)	; 0x000e
    5416:	0e 48       	mov	r8,	r14	;
    5418:	0f 48       	mov	r8,	r15	;
    541a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    541e:	0a 5e       	add	r14,	r10	;
    5420:	0b 6f       	addc	r15,	r11	;
    5422:	0e 46       	mov	r6,	r14	;
    5424:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5428:	4d 4e       	mov.b	r14,	r13	;
    542a:	4d e6       	xor.b	r6,	r13	;
    542c:	4d 8e       	sub.b	r14,	r13	;
    542e:	7e 40 09 00 	mov.b	#9,	r14	;
    5432:	4e 9d       	cmp.b	r13,	r14	;
    5434:	02 28       	jnc	$+6      	;abs 0x543a
    5436:	80 00 a4 5b 	mova	#23460,	r0	;0x05ba4
    543a:	81 46 18 00 	mov	r6,	24(r1)	; 0x0018
    543e:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    5442:	07 77       	subc	r7,	r7	;
    5444:	37 e3       	inv	r7		;
    5446:	0e 49       	mov	r9,	r14	;
    5448:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    544c:	4d 4e       	mov.b	r14,	r13	;
    544e:	4d e9       	xor.b	r9,	r13	;
    5450:	4d 8e       	sub.b	r14,	r13	;
    5452:	7e 40 09 00 	mov.b	#9,	r14	;
    5456:	4e 9d       	cmp.b	r13,	r14	;
    5458:	02 28       	jnc	$+6      	;abs 0x545e
    545a:	80 00 98 5b 	mova	#23448,	r0	;0x05b98
    545e:	81 49 1e 00 	mov	r9,	30(r1)	; 0x001e
    5462:	0e 49       	mov	r9,	r14	;
    5464:	0f 49       	mov	r9,	r15	;
    5466:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    546a:	09 4c       	mov	r12,	r9	;
    546c:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    5470:	4d 49       	mov.b	r9,	r13	;
    5472:	4d ec       	xor.b	r12,	r13	;
    5474:	4d 89       	sub.b	r9,	r13	;
    5476:	79 40 09 00 	mov.b	#9,	r9	;
    547a:	49 9d       	cmp.b	r13,	r9	;
    547c:	02 28       	jnc	$+6      	;abs 0x5482
    547e:	80 00 8c 5b 	mova	#23436,	r0	;0x05b8c
    5482:	81 4c 1c 00 	mov	r12,	28(r1)	; 0x001c
    5486:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    548a:	0d 7d       	subc	r13,	r13	;
    548c:	3d e3       	inv	r13		;
    548e:	09 4e       	mov	r14,	r9	;
    5490:	19 51 02 00 	add	2(r1),	r9	;
    5494:	18 41 04 00 	mov	4(r1),	r8	;
    5498:	08 6f       	addc	r15,	r8	;
    549a:	0a 5c       	add	r12,	r10	;
    549c:	0b 6d       	addc	r13,	r11	;
    549e:	7e 40 03 00 	mov.b	#3,	r14	;
    54a2:	4f 43       	clr.b	r15		;
    54a4:	0c 46       	mov	r6,	r12	;
    54a6:	1c 51 06 00 	add	6(r1),	r12	;
    54aa:	1d 41 08 00 	mov	8(r1),	r13	;
    54ae:	0d 67       	addc	r7,	r13	;
    54b0:	81 4b 00 00 	mov	r11,	0(r1)	;
    54b4:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    54b8:	81 4c 06 00 	mov	r12,	6(r1)	;
    54bc:	7e 40 03 00 	mov.b	#3,	r14	;
    54c0:	4f 43       	clr.b	r15		;
    54c2:	0c 49       	mov	r9,	r12	;
    54c4:	0d 48       	mov	r8,	r13	;
    54c6:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    54ca:	06 4c       	mov	r12,	r6	;
    54cc:	7e 40 03 00 	mov.b	#3,	r14	;
    54d0:	4f 43       	clr.b	r15		;
    54d2:	0c 4a       	mov	r10,	r12	;
    54d4:	2b 41       	mov	@r1,	r11	;
    54d6:	0d 4b       	mov	r11,	r13	;
    54d8:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    54dc:	81 4c 02 00 	mov	r12,	2(r1)	;
    54e0:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    54e4:	1c 81 06 00 	sub	6(r1),	r12	;
    54e8:	0d 4c       	mov	r12,	r13	;
    54ea:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    54ee:	0c ed       	xor	r13,	r12	;
    54f0:	0c 8d       	sub	r13,	r12	;
    54f2:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    54f6:	0d 7d       	subc	r13,	r13	;
    54f8:	3d e3       	inv	r13		;
    54fa:	1a 41 10 00 	mov	16(r1),	r10	;0x00010
    54fe:	1a 81 06 00 	sub	6(r1),	r10	;
    5502:	0f 4a       	mov	r10,	r15	;
    5504:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5508:	0a ef       	xor	r15,	r10	;
    550a:	0e 4a       	mov	r10,	r14	;
    550c:	0e 8f       	sub	r15,	r14	;
    550e:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    5512:	0f 7f       	subc	r15,	r15	;
    5514:	3f e3       	inv	r15		;
    5516:	0c 5e       	add	r14,	r12	;
    5518:	0a 4d       	mov	r13,	r10	;
    551a:	0a 6f       	addc	r15,	r10	;
    551c:	81 4a 10 00 	mov	r10,	16(r1)	; 0x0010
    5520:	1a 41 16 00 	mov	22(r1),	r10	;0x00016
    5524:	0a 86       	sub	r6,	r10	;
    5526:	0d 4a       	mov	r10,	r13	;
    5528:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    552c:	0a ed       	xor	r13,	r10	;
    552e:	0e 4a       	mov	r10,	r14	;
    5530:	0e 8d       	sub	r13,	r14	;
    5532:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    5536:	0f 7f       	subc	r15,	r15	;
    5538:	3f e3       	inv	r15		;
    553a:	05 86       	sub	r6,	r5	;
    553c:	0d 45       	mov	r5,	r13	;
    553e:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5542:	05 ed       	xor	r13,	r5	;
    5544:	0a 45       	mov	r5,	r10	;
    5546:	0a 8d       	sub	r13,	r10	;
    5548:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    554c:	0b 7b       	subc	r11,	r11	;
    554e:	3b e3       	inv	r11		;
    5550:	08 4e       	mov	r14,	r8	;
    5552:	08 5a       	add	r10,	r8	;
    5554:	07 4f       	mov	r15,	r7	;
    5556:	07 6b       	addc	r11,	r7	;
    5558:	14 81 02 00 	sub	2(r1),	r4	;
    555c:	0d 44       	mov	r4,	r13	;
    555e:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5562:	04 ed       	xor	r13,	r4	;
    5564:	0a 44       	mov	r4,	r10	;
    5566:	0a 8d       	sub	r13,	r10	;
    5568:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    556c:	0b 7b       	subc	r11,	r11	;
    556e:	3b e3       	inv	r11		;
    5570:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    5574:	1e 81 02 00 	sub	2(r1),	r14	;
    5578:	0d 4e       	mov	r14,	r13	;
    557a:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    557e:	0e ed       	xor	r13,	r14	;
    5580:	0e 8d       	sub	r13,	r14	;
    5582:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    5586:	0f 7f       	subc	r15,	r15	;
    5588:	3f e3       	inv	r15		;
    558a:	09 4a       	mov	r10,	r9	;
    558c:	09 5e       	add	r14,	r9	;
    558e:	0d 4b       	mov	r11,	r13	;
    5590:	0d 6f       	addc	r15,	r13	;
    5592:	1a 41 18 00 	mov	24(r1),	r10	;0x00018
    5596:	1a 81 06 00 	sub	6(r1),	r10	;
    559a:	0e 4a       	mov	r10,	r14	;
    559c:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    55a0:	0a ee       	xor	r14,	r10	;
    55a2:	0a 8e       	sub	r14,	r10	;
    55a4:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    55a8:	0b 7b       	subc	r11,	r11	;
    55aa:	3b e3       	inv	r11		;
    55ac:	1e 41 1e 00 	mov	30(r1),	r14	;0x0001e
    55b0:	0e 86       	sub	r6,	r14	;
    55b2:	0f 4e       	mov	r14,	r15	;
    55b4:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    55b8:	0e ef       	xor	r15,	r14	;
    55ba:	0e 8f       	sub	r15,	r14	;
    55bc:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    55c0:	0f 7f       	subc	r15,	r15	;
    55c2:	3f e3       	inv	r15		;
    55c4:	08 5e       	add	r14,	r8	;
    55c6:	07 6f       	addc	r15,	r7	;
    55c8:	1e 41 1c 00 	mov	28(r1),	r14	;0x0001c
    55cc:	1e 81 02 00 	sub	2(r1),	r14	;
    55d0:	0f 4e       	mov	r14,	r15	;
    55d2:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    55d6:	0e ef       	xor	r15,	r14	;
    55d8:	0e 8f       	sub	r15,	r14	;
    55da:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    55de:	0f 7f       	subc	r15,	r15	;
    55e0:	3f e3       	inv	r15		;
    55e2:	09 5e       	add	r14,	r9	;
    55e4:	05 4f       	mov	r15,	r5	;
    55e6:	05 6d       	addc	r13,	r5	;
    55e8:	7e 40 03 00 	mov.b	#3,	r14	;
    55ec:	4f 43       	clr.b	r15		;
    55ee:	0c 5a       	add	r10,	r12	;
    55f0:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    55f4:	0d 6b       	addc	r11,	r13	;
    55f6:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    55fa:	0a 4c       	mov	r12,	r10	;
    55fc:	7e 40 03 00 	mov.b	#3,	r14	;
    5600:	4f 43       	clr.b	r15		;
    5602:	0c 48       	mov	r8,	r12	;
    5604:	0d 47       	mov	r7,	r13	;
    5606:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    560a:	08 4c       	mov	r12,	r8	;
    560c:	7e 40 03 00 	mov.b	#3,	r14	;
    5610:	4f 43       	clr.b	r15		;
    5612:	0c 49       	mov	r9,	r12	;
    5614:	0d 45       	mov	r5,	r13	;
    5616:	b0 12 c6 5f 	call	#24518		;#0x5fc6
    561a:	09 4c       	mov	r12,	r9	;
    561c:	0c 4a       	mov	r10,	r12	;
    561e:	0d 4a       	mov	r10,	r13	;
    5620:	b0 12 0e 60 	call	#24590		;#0x600e
    5624:	0a 4c       	mov	r12,	r10	;
    5626:	0c 48       	mov	r8,	r12	;
    5628:	0d 48       	mov	r8,	r13	;
    562a:	b0 12 0e 60 	call	#24590		;#0x600e
    562e:	0a 5c       	add	r12,	r10	;
    5630:	0c 49       	mov	r9,	r12	;
    5632:	0d 49       	mov	r9,	r13	;
    5634:	b0 12 0e 60 	call	#24590		;#0x600e
    5638:	0a 5c       	add	r12,	r10	;
    563a:	1c 41 06 00 	mov	6(r1),	r12	;
    563e:	0d 4c       	mov	r12,	r13	;
    5640:	b0 12 0e 60 	call	#24590		;#0x600e
    5644:	09 4c       	mov	r12,	r9	;
    5646:	0c 46       	mov	r6,	r12	;
    5648:	0d 46       	mov	r6,	r13	;
    564a:	b0 12 0e 60 	call	#24590		;#0x600e
    564e:	06 49       	mov	r9,	r6	;
    5650:	06 5c       	add	r12,	r6	;
    5652:	1c 41 02 00 	mov	2(r1),	r12	;
    5656:	0d 4c       	mov	r12,	r13	;
    5658:	b0 12 0e 60 	call	#24590		;#0x600e
    565c:	06 5c       	add	r12,	r6	;
    565e:	08 46       	mov	r6,	r8	;
    5660:	09 43       	clr	r9		;
    5662:	75 40 80 00 	mov.b	#128,	r5	;#0x0080
    5666:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    566a:	0c 96       	cmp	r6,	r12	;
    566c:	01 28       	jnc	$+4      	;abs 0x5670
    566e:	45 43       	clr.b	r5		;
    5670:	07 45       	mov	r5,	r7	;
    5672:	37 d0 40 00 	bis	#64,	r7	;#0x0040
    5676:	0c 47       	mov	r7,	r12	;
    5678:	4d 43       	clr.b	r13		;
    567a:	0e 47       	mov	r7,	r14	;
    567c:	4f 43       	clr.b	r15		;
    567e:	b0 12 22 60 	call	#24610		;#0x6022
    5682:	0d 93       	cmp	#0,	r13	;r3 As==00
    5684:	04 20       	jnz	$+10     	;abs 0x568e
    5686:	09 93       	cmp	#0,	r9	;r3 As==00
    5688:	05 20       	jnz	$+12     	;abs 0x5694
    568a:	06 9c       	cmp	r12,	r6	;
    568c:	03 2c       	jc	$+8      	;abs 0x5694
    568e:	07 45       	mov	r5,	r7	;
    5690:	37 f0 bf ff 	and	#-65,	r7	;#0xffbf
    5694:	05 47       	mov	r7,	r5	;
    5696:	35 d0 20 00 	bis	#32,	r5	;#0x0020
    569a:	0c 45       	mov	r5,	r12	;
    569c:	4d 43       	clr.b	r13		;
    569e:	0e 45       	mov	r5,	r14	;
    56a0:	4f 43       	clr.b	r15		;
    56a2:	b0 12 22 60 	call	#24610		;#0x6022
    56a6:	0d 93       	cmp	#0,	r13	;r3 As==00
    56a8:	04 20       	jnz	$+10     	;abs 0x56b2
    56aa:	09 93       	cmp	#0,	r9	;r3 As==00
    56ac:	05 20       	jnz	$+12     	;abs 0x56b8
    56ae:	06 9c       	cmp	r12,	r6	;
    56b0:	03 2c       	jc	$+8      	;abs 0x56b8
    56b2:	05 47       	mov	r7,	r5	;
    56b4:	35 f0 df ff 	and	#-33,	r5	;#0xffdf
    56b8:	07 45       	mov	r5,	r7	;
    56ba:	37 d0 10 00 	bis	#16,	r7	;#0x0010
    56be:	0c 47       	mov	r7,	r12	;
    56c0:	4d 43       	clr.b	r13		;
    56c2:	0e 47       	mov	r7,	r14	;
    56c4:	4f 43       	clr.b	r15		;
    56c6:	b0 12 22 60 	call	#24610		;#0x6022
    56ca:	0d 93       	cmp	#0,	r13	;r3 As==00
    56cc:	04 20       	jnz	$+10     	;abs 0x56d6
    56ce:	09 93       	cmp	#0,	r9	;r3 As==00
    56d0:	05 20       	jnz	$+12     	;abs 0x56dc
    56d2:	06 9c       	cmp	r12,	r6	;
    56d4:	03 2c       	jc	$+8      	;abs 0x56dc
    56d6:	07 45       	mov	r5,	r7	;
    56d8:	37 f0 ef ff 	and	#-17,	r7	;#0xffef
    56dc:	05 47       	mov	r7,	r5	;
    56de:	35 d2       	bis	#8,	r5	;r2 As==11
    56e0:	0c 45       	mov	r5,	r12	;
    56e2:	4d 43       	clr.b	r13		;
    56e4:	0e 45       	mov	r5,	r14	;
    56e6:	4f 43       	clr.b	r15		;
    56e8:	b0 12 22 60 	call	#24610		;#0x6022
    56ec:	0d 93       	cmp	#0,	r13	;r3 As==00
    56ee:	02 24       	jz	$+6      	;abs 0x56f4
    56f0:	80 00 52 5b 	mova	#23378,	r0	;0x05b52
    56f4:	09 93       	cmp	#0,	r9	;r3 As==00
    56f6:	04 20       	jnz	$+10     	;abs 0x5700
    56f8:	06 9c       	cmp	r12,	r6	;
    56fa:	02 2c       	jc	$+6      	;abs 0x5700
    56fc:	80 00 52 5b 	mova	#23378,	r0	;0x05b52
    5700:	07 45       	mov	r5,	r7	;
    5702:	27 d2       	bis	#4,	r7	;r2 As==10
    5704:	0c 47       	mov	r7,	r12	;
    5706:	4d 43       	clr.b	r13		;
    5708:	0e 47       	mov	r7,	r14	;
    570a:	4f 43       	clr.b	r15		;
    570c:	b0 12 22 60 	call	#24610		;#0x6022
    5710:	0d 93       	cmp	#0,	r13	;r3 As==00
    5712:	02 24       	jz	$+6      	;abs 0x5718
    5714:	80 00 4a 5b 	mova	#23370,	r0	;0x05b4a
    5718:	09 93       	cmp	#0,	r9	;r3 As==00
    571a:	04 20       	jnz	$+10     	;abs 0x5724
    571c:	06 9c       	cmp	r12,	r6	;
    571e:	02 2c       	jc	$+6      	;abs 0x5724
    5720:	80 00 4a 5b 	mova	#23370,	r0	;0x05b4a
    5724:	05 47       	mov	r7,	r5	;
    5726:	25 d3       	bis	#2,	r5	;r3 As==10
    5728:	0c 45       	mov	r5,	r12	;
    572a:	4d 43       	clr.b	r13		;
    572c:	0e 45       	mov	r5,	r14	;
    572e:	4f 43       	clr.b	r15		;
    5730:	b0 12 22 60 	call	#24610		;#0x6022
    5734:	0d 93       	cmp	#0,	r13	;r3 As==00
    5736:	02 24       	jz	$+6      	;abs 0x573c
    5738:	80 00 42 5b 	mova	#23362,	r0	;0x05b42
    573c:	09 93       	cmp	#0,	r9	;r3 As==00
    573e:	02 20       	jnz	$+6      	;abs 0x5744
    5740:	06 9c       	cmp	r12,	r6	;
    5742:	ff 29       	jnc	$+1024   	;abs 0x5b42
    5744:	07 45       	mov	r5,	r7	;
    5746:	17 d3       	bis	#1,	r7	;r3 As==01
    5748:	0c 47       	mov	r7,	r12	;
    574a:	4d 43       	clr.b	r13		;
    574c:	0e 47       	mov	r7,	r14	;
    574e:	4f 43       	clr.b	r15		;
    5750:	b0 12 22 60 	call	#24610		;#0x6022
    5754:	0d 93       	cmp	#0,	r13	;r3 As==00
    5756:	e3 21       	jnz	$+968    	;abs 0x5b1e
    5758:	09 93       	cmp	#0,	r9	;r3 As==00
    575a:	02 20       	jnz	$+6      	;abs 0x5760
    575c:	06 9c       	cmp	r12,	r6	;
    575e:	df 29       	jnc	$+960    	;abs 0x5b1e
    5760:	08 4a       	mov	r10,	r8	;
    5762:	09 43       	clr	r9		;
    5764:	3d 40 ff 0f 	mov	#4095,	r13	;#0x0fff
    5768:	0d 9a       	cmp	r10,	r13	;
    576a:	e1 29       	jnc	$+964    	;abs 0x5b2e
    576c:	3e 40 ff 03 	mov	#1023,	r14	;#0x03ff
    5770:	76 40 20 00 	mov.b	#32,	r6	;#0x0020
    5774:	0e 9a       	cmp	r10,	r14	;
    5776:	02 28       	jnc	$+6      	;abs 0x577c
    5778:	80 00 b4 5b 	mova	#23476,	r0	;0x05bb4
    577c:	45 43       	clr.b	r5		;
    577e:	36 d0 10 00 	bis	#16,	r6	;#0x0010
    5782:	0c 46       	mov	r6,	r12	;
    5784:	0d 45       	mov	r5,	r13	;
    5786:	0e 46       	mov	r6,	r14	;
    5788:	0f 45       	mov	r5,	r15	;
    578a:	b0 12 22 60 	call	#24610		;#0x6022
    578e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5790:	d5 21       	jnz	$+940    	;abs 0x5b3c
    5792:	09 93       	cmp	#0,	r9	;r3 As==00
    5794:	02 20       	jnz	$+6      	;abs 0x579a
    5796:	80 00 be 5b 	mova	#23486,	r0	;0x05bbe
    579a:	04 46       	mov	r6,	r4	;
    579c:	34 d2       	bis	#8,	r4	;r2 As==11
    579e:	0c 44       	mov	r4,	r12	;
    57a0:	0d 45       	mov	r5,	r13	;
    57a2:	0e 44       	mov	r4,	r14	;
    57a4:	0f 45       	mov	r5,	r15	;
    57a6:	b0 12 22 60 	call	#24610		;#0x6022
    57aa:	0d 93       	cmp	#0,	r13	;r3 As==00
    57ac:	b5 21       	jnz	$+876    	;abs 0x5b18
    57ae:	09 93       	cmp	#0,	r9	;r3 As==00
    57b0:	02 20       	jnz	$+6      	;abs 0x57b6
    57b2:	0a 9c       	cmp	r12,	r10	;
    57b4:	b1 29       	jnc	$+868    	;abs 0x5b18
    57b6:	06 44       	mov	r4,	r6	;
    57b8:	26 d2       	bis	#4,	r6	;r2 As==10
    57ba:	0c 46       	mov	r6,	r12	;
    57bc:	0d 45       	mov	r5,	r13	;
    57be:	0e 46       	mov	r6,	r14	;
    57c0:	0f 45       	mov	r5,	r15	;
    57c2:	b0 12 22 60 	call	#24610		;#0x6022
    57c6:	0d 93       	cmp	#0,	r13	;r3 As==00
    57c8:	a4 21       	jnz	$+842    	;abs 0x5b12
    57ca:	09 93       	cmp	#0,	r9	;r3 As==00
    57cc:	02 20       	jnz	$+6      	;abs 0x57d2
    57ce:	0a 9c       	cmp	r12,	r10	;
    57d0:	a0 29       	jnc	$+834    	;abs 0x5b12
    57d2:	04 46       	mov	r6,	r4	;
    57d4:	24 d3       	bis	#2,	r4	;r3 As==10
    57d6:	0c 44       	mov	r4,	r12	;
    57d8:	0d 45       	mov	r5,	r13	;
    57da:	0e 44       	mov	r4,	r14	;
    57dc:	0f 45       	mov	r5,	r15	;
    57de:	b0 12 22 60 	call	#24610		;#0x6022
    57e2:	0d 93       	cmp	#0,	r13	;r3 As==00
    57e4:	93 21       	jnz	$+808    	;abs 0x5b0c
    57e6:	09 93       	cmp	#0,	r9	;r3 As==00
    57e8:	02 20       	jnz	$+6      	;abs 0x57ee
    57ea:	0a 9c       	cmp	r12,	r10	;
    57ec:	8f 29       	jnc	$+800    	;abs 0x5b0c
    57ee:	06 44       	mov	r4,	r6	;
    57f0:	16 d3       	bis	#1,	r6	;r3 As==01
    57f2:	0c 46       	mov	r6,	r12	;
    57f4:	0d 45       	mov	r5,	r13	;
    57f6:	0e 46       	mov	r6,	r14	;
    57f8:	0f 45       	mov	r5,	r15	;
    57fa:	b0 12 22 60 	call	#24610		;#0x6022
    57fe:	0d 93       	cmp	#0,	r13	;r3 As==00
    5800:	82 21       	jnz	$+774    	;abs 0x5b06
    5802:	09 93       	cmp	#0,	r9	;r3 As==00
    5804:	02 20       	jnz	$+6      	;abs 0x580a
    5806:	0a 9c       	cmp	r12,	r10	;
    5808:	7e 29       	jnc	$+766    	;abs 0x5b06
    580a:	45 43       	clr.b	r5		;
    580c:	48 43       	clr.b	r8		;
    580e:	4a 43       	clr.b	r10		;
    5810:	0d 4a       	mov	r10,	r13	;
    5812:	5d 06       	rlam	#2,	r13	;
    5814:	1f 4d 00 1c 	mov	7168(r13),r15	;0x01c00
    5818:	1c 4d 02 1c 	mov	7170(r13),r12	;0x01c02
    581c:	3d 50 00 1c 	add	#7168,	r13	;#0x1c00
    5820:	0c 86       	sub	r6,	r12	;
    5822:	0e 4c       	mov	r12,	r14	;
    5824:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5828:	0c ee       	xor	r14,	r12	;
    582a:	0c 8e       	sub	r14,	r12	;
    582c:	0e 4a       	mov	r10,	r14	;
    582e:	5e 06       	rlam	#2,	r14	;
    5830:	1e 4e 40 1c 	mov	7232(r14),r14	;0x01c40
    5834:	1d 4d 42 00 	mov	66(r13),r13	;0x00042
    5838:	0d 86       	sub	r6,	r13	;
    583a:	09 4d       	mov	r13,	r9	;
    583c:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    5840:	0d e9       	xor	r9,	r13	;
    5842:	0d 89       	sub	r9,	r13	;
    5844:	0f 87       	sub	r7,	r15	;
    5846:	09 4f       	mov	r15,	r9	;
    5848:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    584c:	0f e9       	xor	r9,	r15	;
    584e:	0f 89       	sub	r9,	r15	;
    5850:	0e 87       	sub	r7,	r14	;
    5852:	09 4e       	mov	r14,	r9	;
    5854:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    5858:	0e e9       	xor	r9,	r14	;
    585a:	0e 89       	sub	r9,	r14	;
    585c:	0e 9f       	cmp	r15,	r14	;
    585e:	7d 35       	jge	$+764    	;abs 0x5b5a
    5860:	18 53       	inc	r8		;
    5862:	0d 9c       	cmp	r12,	r13	;
    5864:	7d 35       	jge	$+764    	;abs 0x5b60
    5866:	18 53       	inc	r8		;
    5868:	1a 53       	inc	r10		;
    586a:	3a 90 10 00 	cmp	#16,	r10	;#0x0010
    586e:	d0 23       	jnz	$-94     	;abs 0x5810
    5870:	91 53 2a 00 	inc	42(r1)		;
    5874:	05 98       	cmp	r8,	r5	;
    5876:	76 35       	jge	$+750    	;abs 0x5b64
    5878:	91 53 2c 00 	inc	44(r1)		;
    587c:	91 53 0a 00 	inc	10(r1)		;
    5880:	b1 90 40 00 	cmp	#64,	10(r1)	;#0x0040, 0x000a
    5884:	0a 00 
    5886:	76 25       	jz	$+750    	;abs 0x5b74
    5888:	b1 90 20 00 	cmp	#32,	10(r1)	;#0x0020, 0x000a
    588c:	0a 00 
    588e:	02 24       	jz	$+6      	;abs 0x5894
    5890:	80 00 c2 51 	mova	#20930,	r0	;0x051c2
    5894:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5898:	1c 42 80 1c 	mov	&0x1c80,r12	;0x1c80
    589c:	3c 53       	add	#-1,	r12	;r3 As==11
    589e:	0c cd       	bic	r13,	r12	;
    58a0:	4e 19 0c 10 	rpt #15 { rrux.w	r12		;
    58a4:	82 4c 80 1c 	mov	r12,	&0x1c80	;
    58a8:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    58ac:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    58b0:	5c f3       	and.b	#1,	r12	;r3 As==01
    58b2:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    58b6:	5a 03       	rrum	#1,	r10	;
    58b8:	0d 93       	cmp	#0,	r13	;r3 As==00
    58ba:	02 24       	jz	$+6      	;abs 0x58c0
    58bc:	80 00 da 51 	mova	#20954,	r0	;0x051da
    58c0:	0c 93       	cmp	#0,	r12	;r3 As==00
    58c2:	02 24       	jz	$+6      	;abs 0x58c8
    58c4:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    58c8:	45 4a       	mov.b	r10,	r5	;
    58ca:	75 f0 03 00 	and.b	#3,	r5	;
    58ce:	75 50 fe ff 	add.b	#-2,	r5	;#0xfffe
    58d2:	85 11       	sxt	r5		;
    58d4:	0d 4a       	mov	r10,	r13	;
    58d6:	5d 03       	rrum	#1,	r13	;
    58d8:	1a b3       	bit	#1,	r10	;r3 As==01
    58da:	02 24       	jz	$+6      	;abs 0x58e0
    58dc:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    58e0:	4a 4d       	mov.b	r13,	r10	;
    58e2:	7a f0 03 00 	and.b	#3,	r10	;
    58e6:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    58ea:	8a 11       	sxt	r10		;
    58ec:	09 4d       	mov	r13,	r9	;
    58ee:	59 03       	rrum	#1,	r9	;
    58f0:	1d b3       	bit	#1,	r13	;r3 As==01
    58f2:	02 24       	jz	$+6      	;abs 0x58f8
    58f4:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    58f8:	44 49       	mov.b	r9,	r4	;
    58fa:	74 f0 03 00 	and.b	#3,	r4	;
    58fe:	74 50 fe ff 	add.b	#-2,	r4	;#0xfffe
    5902:	84 11       	sxt	r4		;
    5904:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5908:	0c 49       	mov	r9,	r12	;
    590a:	5c f3       	and.b	#1,	r12	;r3 As==01
    590c:	59 03       	rrum	#1,	r9	;
    590e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5910:	02 24       	jz	$+6      	;abs 0x5916
    5912:	80 00 42 52 	mova	#21058,	r0	;0x05242
    5916:	0c 93       	cmp	#0,	r12	;r3 As==00
    5918:	02 24       	jz	$+6      	;abs 0x591e
    591a:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    591e:	4c 49       	mov.b	r9,	r12	;
    5920:	7c f0 03 00 	and.b	#3,	r12	;
    5924:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5928:	8c 11       	sxt	r12		;
    592a:	81 4c 0e 00 	mov	r12,	14(r1)	; 0x000e
    592e:	0d 49       	mov	r9,	r13	;
    5930:	5d 03       	rrum	#1,	r13	;
    5932:	19 b3       	bit	#1,	r9	;r3 As==01
    5934:	02 24       	jz	$+6      	;abs 0x593a
    5936:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    593a:	47 4d       	mov.b	r13,	r7	;
    593c:	77 f0 03 00 	and.b	#3,	r7	;
    5940:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5944:	87 11       	sxt	r7		;
    5946:	09 4d       	mov	r13,	r9	;
    5948:	59 03       	rrum	#1,	r9	;
    594a:	1d b3       	bit	#1,	r13	;r3 As==01
    594c:	02 24       	jz	$+6      	;abs 0x5952
    594e:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5952:	48 49       	mov.b	r9,	r8	;
    5954:	78 f0 03 00 	and.b	#3,	r8	;
    5958:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    595c:	88 11       	sxt	r8		;
    595e:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5962:	0c 49       	mov	r9,	r12	;
    5964:	5c f3       	and.b	#1,	r12	;r3 As==01
    5966:	59 03       	rrum	#1,	r9	;
    5968:	0d 93       	cmp	#0,	r13	;r3 As==00
    596a:	02 24       	jz	$+6      	;abs 0x5970
    596c:	80 00 ac 52 	mova	#21164,	r0	;0x052ac
    5970:	0c 93       	cmp	#0,	r12	;r3 As==00
    5972:	02 24       	jz	$+6      	;abs 0x5978
    5974:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5978:	46 49       	mov.b	r9,	r6	;
    597a:	76 f0 03 00 	and.b	#3,	r6	;
    597e:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5982:	86 11       	sxt	r6		;
    5984:	0d 49       	mov	r9,	r13	;
    5986:	5d 03       	rrum	#1,	r13	;
    5988:	19 b3       	bit	#1,	r9	;r3 As==01
    598a:	02 24       	jz	$+6      	;abs 0x5990
    598c:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5990:	49 4d       	mov.b	r13,	r9	;
    5992:	79 f0 03 00 	and.b	#3,	r9	;
    5996:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    599a:	89 11       	sxt	r9		;
    599c:	0e 4d       	mov	r13,	r14	;
    599e:	5e 03       	rrum	#1,	r14	;
    59a0:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    59a4:	1d b3       	bit	#1,	r13	;r3 As==01
    59a6:	03 24       	jz	$+8      	;abs 0x59ae
    59a8:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    59ac:	12 00 
    59ae:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    59b2:	7c f0 03 00 	and.b	#3,	r12	;
    59b6:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    59ba:	8c 11       	sxt	r12		;
    59bc:	0e 45       	mov	r5,	r14	;
    59be:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    59c2:	4d 4e       	mov.b	r14,	r13	;
    59c4:	4d e5       	xor.b	r5,	r13	;
    59c6:	4d 8e       	sub.b	r14,	r13	;
    59c8:	7e 40 09 00 	mov.b	#9,	r14	;
    59cc:	4e 9d       	cmp.b	r13,	r14	;
    59ce:	02 2c       	jc	$+6      	;abs 0x59d4
    59d0:	80 00 26 53 	mova	#21286,	r0	;0x05326
    59d4:	81 43 06 00 	mov	#0,	6(r1)	;r3 As==00
    59d8:	81 43 08 00 	mov	#0,	8(r1)	;r3 As==00
    59dc:	81 43 14 00 	mov	#0,	20(r1)	;r3 As==00, 0x0014
    59e0:	0e 4a       	mov	r10,	r14	;
    59e2:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    59e6:	4d 4e       	mov.b	r14,	r13	;
    59e8:	4d ea       	xor.b	r10,	r13	;
    59ea:	4d 8e       	sub.b	r14,	r13	;
    59ec:	7e 40 09 00 	mov.b	#9,	r14	;
    59f0:	4e 9d       	cmp.b	r13,	r14	;
    59f2:	02 2c       	jc	$+6      	;abs 0x59f8
    59f4:	80 00 52 53 	mova	#21330,	r0	;0x05352
    59f8:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    59fc:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5a00:	81 43 16 00 	mov	#0,	22(r1)	;r3 As==00, 0x0016
    5a04:	0e 44       	mov	r4,	r14	;
    5a06:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5a0a:	4d 44       	mov.b	r4,	r13	;
    5a0c:	4d ee       	xor.b	r14,	r13	;
    5a0e:	4d 8e       	sub.b	r14,	r13	;
    5a10:	7a 40 09 00 	mov.b	#9,	r10	;
    5a14:	4a 9d       	cmp.b	r13,	r10	;
    5a16:	02 2c       	jc	$+6      	;abs 0x5a1c
    5a18:	80 00 7e 53 	mova	#21374,	r0	;0x0537e
    5a1c:	4a 43       	clr.b	r10		;
    5a1e:	4b 43       	clr.b	r11		;
    5a20:	44 43       	clr.b	r4		;
    5a22:	30 40 86 53 	br	#0x5386		;
    5a26:	08 47       	mov	r7,	r8	;
    5a28:	28 c3       	bic	#2,	r8	;r3 As==10
    5a2a:	30 40 d4 49 	br	#0x49d4		;
    5a2e:	07 46       	mov	r6,	r7	;
    5a30:	27 c2       	bic	#4,	r7	;r2 As==10
    5a32:	30 40 ae 49 	br	#0x49ae		;
    5a36:	06 48       	mov	r8,	r6	;
    5a38:	36 c2       	bic	#8,	r6	;r2 As==11
    5a3a:	30 40 88 49 	br	#0x4988		;
    5a3e:	05 46       	mov	r6,	r5	;
    5a40:	15 c3       	bic	#1,	r5	;r3 As==01
    5a42:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    5a46:	0d 4a       	mov	r10,	r13	;
    5a48:	0e 43       	clr	r14		;
    5a4a:	81 4d 06 00 	mov	r13,	6(r1)	;
    5a4e:	81 4e 08 00 	mov	r14,	8(r1)	;
    5a52:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    5a56:	0e 9a       	cmp	r10,	r14	;
    5a58:	02 28       	jnc	$+6      	;abs 0x5a5e
    5a5a:	80 00 2e 49 	mova	#18734,	r0	;0x0492e
    5a5e:	3e 40 ff 23 	mov	#9215,	r14	;#0x23ff
    5a62:	0e 9a       	cmp	r10,	r14	;
    5a64:	68 2d       	jc	$+722    	;abs 0x5d36
    5a66:	78 40 70 00 	mov.b	#112,	r8	;#0x0070
    5a6a:	09 44       	mov	r4,	r9	;
    5a6c:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5a70:	30 40 62 49 	br	#0x4962		;
    5a74:	06 45       	mov	r5,	r6	;
    5a76:	26 c3       	bic	#2,	r6	;r3 As==10
    5a78:	30 40 ee 48 	br	#0x48ee		;
    5a7c:	05 46       	mov	r6,	r5	;
    5a7e:	25 c2       	bic	#4,	r5	;r2 As==10
    5a80:	30 40 ca 48 	br	#0x48ca		;
    5a84:	06 45       	mov	r5,	r6	;
    5a86:	36 c2       	bic	#8,	r6	;r2 As==11
    5a88:	30 40 a6 48 	br	#0x48a6		;
    5a8c:	07 46       	mov	r6,	r7	;
    5a8e:	27 c2       	bic	#4,	r7	;r2 As==10
    5a90:	08 47       	mov	r7,	r8	;
    5a92:	28 d3       	bis	#2,	r8	;r3 As==10
    5a94:	0c 48       	mov	r8,	r12	;
    5a96:	0d 49       	mov	r9,	r13	;
    5a98:	0e 48       	mov	r8,	r14	;
    5a9a:	0f 49       	mov	r9,	r15	;
    5a9c:	b0 12 22 60 	call	#24610		;#0x6022
    5aa0:	0d 93       	cmp	#0,	r13	;r3 As==00
    5aa2:	02 20       	jnz	$+6      	;abs 0x5aa8
    5aa4:	80 00 3a 51 	mova	#20794,	r0	;0x0513a
    5aa8:	08 47       	mov	r7,	r8	;
    5aaa:	28 c3       	bic	#2,	r8	;r3 As==10
    5aac:	30 40 48 51 	br	#0x5148		;
    5ab0:	06 48       	mov	r8,	r6	;
    5ab2:	36 c2       	bic	#8,	r6	;r2 As==11
    5ab4:	30 40 fc 50 	br	#0x50fc		;
    5ab8:	05 46       	mov	r6,	r5	;
    5aba:	15 c3       	bic	#1,	r5	;r3 As==01
    5abc:	81 45 1e 00 	mov	r5,	30(r1)	; 0x001e
    5ac0:	0d 4a       	mov	r10,	r13	;
    5ac2:	0e 43       	clr	r14		;
    5ac4:	81 4d 06 00 	mov	r13,	6(r1)	;
    5ac8:	81 4e 08 00 	mov	r14,	8(r1)	;
    5acc:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    5ad0:	0e 9a       	cmp	r10,	r14	;
    5ad2:	02 28       	jnc	$+6      	;abs 0x5ad8
    5ad4:	80 00 a2 50 	mova	#20642,	r0	;0x050a2
    5ad8:	3d 40 ff 23 	mov	#9215,	r13	;#0x23ff
    5adc:	0d 9a       	cmp	r10,	r13	;
    5ade:	77 2c       	jc	$+240    	;abs 0x5bce
    5ae0:	78 40 70 00 	mov.b	#112,	r8	;#0x0070
    5ae4:	09 44       	mov	r4,	r9	;
    5ae6:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5aea:	30 40 d6 50 	br	#0x50d6		;
    5aee:	06 45       	mov	r5,	r6	;
    5af0:	26 c3       	bic	#2,	r6	;r3 As==10
    5af2:	30 40 62 50 	br	#0x5062		;
    5af6:	05 46       	mov	r6,	r5	;
    5af8:	25 c2       	bic	#4,	r5	;r2 As==10
    5afa:	30 40 3e 50 	br	#0x503e		;
    5afe:	06 45       	mov	r5,	r6	;
    5b00:	36 c2       	bic	#8,	r6	;r2 As==11
    5b02:	30 40 1a 50 	br	#0x501a		;
    5b06:	06 44       	mov	r4,	r6	;
    5b08:	16 c3       	bic	#1,	r6	;r3 As==01
    5b0a:	7f 3e       	jmp	$-768    	;abs 0x580a
    5b0c:	04 46       	mov	r6,	r4	;
    5b0e:	24 c3       	bic	#2,	r4	;r3 As==10
    5b10:	6e 3e       	jmp	$-802    	;abs 0x57ee
    5b12:	06 44       	mov	r4,	r6	;
    5b14:	26 c2       	bic	#4,	r6	;r2 As==10
    5b16:	5d 3e       	jmp	$-836    	;abs 0x57d2
    5b18:	04 46       	mov	r6,	r4	;
    5b1a:	34 c2       	bic	#8,	r4	;r2 As==11
    5b1c:	4c 3e       	jmp	$-870    	;abs 0x57b6
    5b1e:	07 45       	mov	r5,	r7	;
    5b20:	17 c3       	bic	#1,	r7	;r3 As==01
    5b22:	08 4a       	mov	r10,	r8	;
    5b24:	09 43       	clr	r9		;
    5b26:	3d 40 ff 0f 	mov	#4095,	r13	;#0x0fff
    5b2a:	0d 9a       	cmp	r10,	r13	;
    5b2c:	1f 2e       	jc	$-960    	;abs 0x576c
    5b2e:	3c 40 ff 23 	mov	#9215,	r12	;#0x23ff
    5b32:	0c 9a       	cmp	r10,	r12	;
    5b34:	3d 2c       	jc	$+124    	;abs 0x5bb0
    5b36:	76 40 70 00 	mov.b	#112,	r6	;#0x0070
    5b3a:	45 43       	clr.b	r5		;
    5b3c:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    5b40:	2c 3e       	jmp	$-934    	;abs 0x579a
    5b42:	05 47       	mov	r7,	r5	;
    5b44:	25 c3       	bic	#2,	r5	;r3 As==10
    5b46:	30 40 44 57 	br	#0x5744		;
    5b4a:	07 45       	mov	r5,	r7	;
    5b4c:	27 c2       	bic	#4,	r7	;r2 As==10
    5b4e:	30 40 24 57 	br	#0x5724		;
    5b52:	05 47       	mov	r7,	r5	;
    5b54:	35 c2       	bic	#8,	r5	;r2 As==11
    5b56:	30 40 00 57 	br	#0x5700		;
    5b5a:	15 53       	inc	r5		;
    5b5c:	0d 9c       	cmp	r12,	r13	;
    5b5e:	83 3a       	jl	$-760    	;abs 0x5866
    5b60:	15 53       	inc	r5		;
    5b62:	82 3e       	jmp	$-762    	;abs 0x5868
    5b64:	91 53 2e 00 	inc	46(r1)		;
    5b68:	91 53 0a 00 	inc	10(r1)		;
    5b6c:	b1 90 40 00 	cmp	#64,	10(r1)	;#0x0040, 0x000a
    5b70:	0a 00 
    5b72:	8a 22       	jnz	$-746    	;abs 0x5888
    5b74:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5b78:	82 1c 
    5b7a:	b0 12 cc 40 	call	#16588		;#0x40cc
    5b7e:	b0 12 04 41 	call	#16644		;#0x4104
    5b82:	4c 43       	clr.b	r12		;
    5b84:	31 50 30 00 	add	#48,	r1	;#0x0030
    5b88:	64 17       	popm	#7,	r10	;16-bit words
    5b8a:	30 41       	ret			
    5b8c:	4c 43       	clr.b	r12		;
    5b8e:	4d 43       	clr.b	r13		;
    5b90:	81 43 1c 00 	mov	#0,	28(r1)	;r3 As==00, 0x001c
    5b94:	30 40 8e 54 	br	#0x548e		;
    5b98:	4e 43       	clr.b	r14		;
    5b9a:	4f 43       	clr.b	r15		;
    5b9c:	81 43 1e 00 	mov	#0,	30(r1)	;r3 As==00, 0x001e
    5ba0:	30 40 6a 54 	br	#0x546a		;
    5ba4:	46 43       	clr.b	r6		;
    5ba6:	47 43       	clr.b	r7		;
    5ba8:	81 43 18 00 	mov	#0,	24(r1)	;r3 As==00, 0x0018
    5bac:	30 40 46 54 	br	#0x5446		;
    5bb0:	76 40 60 00 	mov.b	#96,	r6	;#0x0060
    5bb4:	36 e0 20 00 	xor	#32,	r6	;#0x0020
    5bb8:	45 43       	clr.b	r5		;
    5bba:	30 40 7e 57 	br	#0x577e		;
    5bbe:	0a 9c       	cmp	r12,	r10	;
    5bc0:	02 28       	jnc	$+6      	;abs 0x5bc6
    5bc2:	80 00 9a 57 	mova	#22426,	r0	;0x0579a
    5bc6:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    5bca:	30 40 9a 57 	br	#0x579a		;
    5bce:	78 40 60 00 	mov.b	#96,	r8	;#0x0060
    5bd2:	38 e0 20 00 	xor	#32,	r8	;#0x0020
    5bd6:	09 44       	mov	r4,	r9	;
    5bd8:	30 40 b4 50 	br	#0x50b4		;
    5bdc:	4c 43       	clr.b	r12		;
    5bde:	4d 43       	clr.b	r13		;
    5be0:	81 44 26 00 	mov	r4,	38(r1)	; 0x0026
    5be4:	30 40 a2 4d 	br	#0x4da2		;
    5be8:	4e 43       	clr.b	r14		;
    5bea:	4f 43       	clr.b	r15		;
    5bec:	81 44 24 00 	mov	r4,	36(r1)	; 0x0024
    5bf0:	30 40 7e 4d 	br	#0x4d7e		;
    5bf4:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5bf8:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    5bfc:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    5c00:	30 40 5a 4d 	br	#0x4d5a		;
    5c04:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    5c08:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5c0c:	81 44 06 00 	mov	r4,	6(r1)	;
    5c10:	30 40 92 4c 	br	#0x4c92		;
    5c14:	4a 43       	clr.b	r10		;
    5c16:	4b 43       	clr.b	r11		;
    5c18:	81 44 1c 00 	mov	r4,	28(r1)	; 0x001c
    5c1c:	30 40 64 4c 	br	#0x4c64		;
    5c20:	45 43       	clr.b	r5		;
    5c22:	46 43       	clr.b	r6		;
    5c24:	81 44 18 00 	mov	r4,	24(r1)	; 0x0018
    5c28:	30 40 40 4c 	br	#0x4c40		;
    5c2c:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c2e:	02 24       	jz	$+6      	;abs 0x5c34
    5c30:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5c34:	48 49       	mov.b	r9,	r8	;
    5c36:	78 f0 03 00 	and.b	#3,	r8	;
    5c3a:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5c3e:	88 11       	sxt	r8		;
    5c40:	0c 49       	mov	r9,	r12	;
    5c42:	5c 03       	rrum	#1,	r12	;
    5c44:	19 b3       	bit	#1,	r9	;r3 As==01
    5c46:	02 24       	jz	$+6      	;abs 0x5c4c
    5c48:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5c4c:	49 4c       	mov.b	r12,	r9	;
    5c4e:	79 f0 03 00 	and.b	#3,	r9	;
    5c52:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5c56:	89 11       	sxt	r9		;
    5c58:	0e 4c       	mov	r12,	r14	;
    5c5a:	5e 03       	rrum	#1,	r14	;
    5c5c:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    5c60:	1c b3       	bit	#1,	r12	;r3 As==01
    5c62:	03 24       	jz	$+8      	;abs 0x5c6a
    5c64:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    5c68:	12 00 
    5c6a:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5c6e:	82 1c 
    5c70:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5c74:	7c f0 03 00 	and.b	#3,	r12	;
    5c78:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c7c:	8c 11       	sxt	r12		;
    5c7e:	30 40 1e 4c 	br	#0x4c1e		;
    5c82:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c84:	02 24       	jz	$+6      	;abs 0x5c8a
    5c86:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5c8a:	4c 49       	mov.b	r9,	r12	;
    5c8c:	7c f0 03 00 	and.b	#3,	r12	;
    5c90:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c94:	8c 11       	sxt	r12		;
    5c96:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    5c9a:	0c 49       	mov	r9,	r12	;
    5c9c:	5c 03       	rrum	#1,	r12	;
    5c9e:	19 b3       	bit	#1,	r9	;r3 As==01
    5ca0:	02 24       	jz	$+6      	;abs 0x5ca6
    5ca2:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5ca6:	4d 4c       	mov.b	r12,	r13	;
    5ca8:	7d f0 03 00 	and.b	#3,	r13	;
    5cac:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5cb0:	8d 11       	sxt	r13		;
    5cb2:	81 4d 10 00 	mov	r13,	16(r1)	; 0x0010
    5cb6:	09 4c       	mov	r12,	r9	;
    5cb8:	59 03       	rrum	#1,	r9	;
    5cba:	1c b3       	bit	#1,	r12	;r3 As==01
    5cbc:	02 24       	jz	$+6      	;abs 0x5cc2
    5cbe:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5cc2:	47 49       	mov.b	r9,	r7	;
    5cc4:	77 f0 03 00 	and.b	#3,	r7	;
    5cc8:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5ccc:	87 11       	sxt	r7		;
    5cce:	30 40 aa 4b 	br	#0x4baa		;
    5cd2:	0c 93       	cmp	#0,	r12	;r3 As==00
    5cd4:	02 24       	jz	$+6      	;abs 0x5cda
    5cd6:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5cda:	46 4a       	mov.b	r10,	r6	;
    5cdc:	76 f0 03 00 	and.b	#3,	r6	;
    5ce0:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5ce4:	86 11       	sxt	r6		;
    5ce6:	0c 4a       	mov	r10,	r12	;
    5ce8:	5c 03       	rrum	#1,	r12	;
    5cea:	1a b3       	bit	#1,	r10	;r3 As==01
    5cec:	02 24       	jz	$+6      	;abs 0x5cf2
    5cee:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5cf2:	4a 4c       	mov.b	r12,	r10	;
    5cf4:	7a f0 03 00 	and.b	#3,	r10	;
    5cf8:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    5cfc:	8a 11       	sxt	r10		;
    5cfe:	09 4c       	mov	r12,	r9	;
    5d00:	59 03       	rrum	#1,	r9	;
    5d02:	1c b3       	bit	#1,	r12	;r3 As==01
    5d04:	02 24       	jz	$+6      	;abs 0x5d0a
    5d06:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5d0a:	4c 49       	mov.b	r9,	r12	;
    5d0c:	7c f0 03 00 	and.b	#3,	r12	;
    5d10:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5d14:	8c 11       	sxt	r12		;
    5d16:	81 4c 06 00 	mov	r12,	6(r1)	;
    5d1a:	30 40 3e 4b 	br	#0x4b3e		;
    5d1e:	4c 43       	clr.b	r12		;
    5d20:	4d 43       	clr.b	r13		;
    5d22:	81 44 28 00 	mov	r4,	40(r1)	; 0x0028
    5d26:	30 40 2e 46 	br	#0x462e		;
    5d2a:	4e 43       	clr.b	r14		;
    5d2c:	4f 43       	clr.b	r15		;
    5d2e:	81 44 26 00 	mov	r4,	38(r1)	; 0x0026
    5d32:	30 40 0a 46 	br	#0x460a		;
    5d36:	78 40 60 00 	mov.b	#96,	r8	;#0x0060
    5d3a:	38 e0 20 00 	xor	#32,	r8	;#0x0020
    5d3e:	09 44       	mov	r4,	r9	;
    5d40:	30 40 40 49 	br	#0x4940		;
    5d44:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5d48:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    5d4c:	81 44 24 00 	mov	r4,	36(r1)	; 0x0024
    5d50:	30 40 e6 45 	br	#0x45e6		;
    5d54:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    5d58:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5d5c:	81 44 06 00 	mov	r4,	6(r1)	;
    5d60:	30 40 1e 45 	br	#0x451e		;
    5d64:	4a 43       	clr.b	r10		;
    5d66:	4b 43       	clr.b	r11		;
    5d68:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    5d6c:	30 40 f0 44 	br	#0x44f0		;
    5d70:	45 43       	clr.b	r5		;
    5d72:	46 43       	clr.b	r6		;
    5d74:	81 44 1c 00 	mov	r4,	28(r1)	; 0x001c
    5d78:	30 40 cc 44 	br	#0x44cc		;
    5d7c:	0c 93       	cmp	#0,	r12	;r3 As==00
    5d7e:	02 24       	jz	$+6      	;abs 0x5d84
    5d80:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5d84:	48 49       	mov.b	r9,	r8	;
    5d86:	78 f0 03 00 	and.b	#3,	r8	;
    5d8a:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5d8e:	88 11       	sxt	r8		;
    5d90:	0c 49       	mov	r9,	r12	;
    5d92:	5c 03       	rrum	#1,	r12	;
    5d94:	19 b3       	bit	#1,	r9	;r3 As==01
    5d96:	02 24       	jz	$+6      	;abs 0x5d9c
    5d98:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5d9c:	49 4c       	mov.b	r12,	r9	;
    5d9e:	79 f0 03 00 	and.b	#3,	r9	;
    5da2:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5da6:	89 11       	sxt	r9		;
    5da8:	0e 4c       	mov	r12,	r14	;
    5daa:	5e 03       	rrum	#1,	r14	;
    5dac:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    5db0:	1c b3       	bit	#1,	r12	;r3 As==01
    5db2:	03 24       	jz	$+8      	;abs 0x5dba
    5db4:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    5db8:	12 00 
    5dba:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5dbe:	82 1c 
    5dc0:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5dc4:	7c f0 03 00 	and.b	#3,	r12	;
    5dc8:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5dcc:	8c 11       	sxt	r12		;
    5dce:	30 40 aa 44 	br	#0x44aa		;
    5dd2:	0c 93       	cmp	#0,	r12	;r3 As==00
    5dd4:	02 24       	jz	$+6      	;abs 0x5dda
    5dd6:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5dda:	4c 49       	mov.b	r9,	r12	;
    5ddc:	7c f0 03 00 	and.b	#3,	r12	;
    5de0:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5de4:	8c 11       	sxt	r12		;
    5de6:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    5dea:	0c 49       	mov	r9,	r12	;
    5dec:	5c 03       	rrum	#1,	r12	;
    5dee:	19 b3       	bit	#1,	r9	;r3 As==01
    5df0:	02 24       	jz	$+6      	;abs 0x5df6
    5df2:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5df6:	4d 4c       	mov.b	r12,	r13	;
    5df8:	7d f0 03 00 	and.b	#3,	r13	;
    5dfc:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5e00:	8d 11       	sxt	r13		;
    5e02:	81 4d 10 00 	mov	r13,	16(r1)	; 0x0010
    5e06:	09 4c       	mov	r12,	r9	;
    5e08:	59 03       	rrum	#1,	r9	;
    5e0a:	1c b3       	bit	#1,	r12	;r3 As==01
    5e0c:	02 24       	jz	$+6      	;abs 0x5e12
    5e0e:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5e12:	47 49       	mov.b	r9,	r7	;
    5e14:	77 f0 03 00 	and.b	#3,	r7	;
    5e18:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5e1c:	87 11       	sxt	r7		;
    5e1e:	30 40 36 44 	br	#0x4436		;
    5e22:	0c 93       	cmp	#0,	r12	;r3 As==00
    5e24:	02 24       	jz	$+6      	;abs 0x5e2a
    5e26:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5e2a:	46 4a       	mov.b	r10,	r6	;
    5e2c:	76 f0 03 00 	and.b	#3,	r6	;
    5e30:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5e34:	86 11       	sxt	r6		;
    5e36:	0c 4a       	mov	r10,	r12	;
    5e38:	5c 03       	rrum	#1,	r12	;
    5e3a:	1a b3       	bit	#1,	r10	;r3 As==01
    5e3c:	02 24       	jz	$+6      	;abs 0x5e42
    5e3e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5e42:	4a 4c       	mov.b	r12,	r10	;
    5e44:	7a f0 03 00 	and.b	#3,	r10	;
    5e48:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    5e4c:	8a 11       	sxt	r10		;
    5e4e:	09 4c       	mov	r12,	r9	;
    5e50:	59 03       	rrum	#1,	r9	;
    5e52:	1c b3       	bit	#1,	r12	;r3 As==01
    5e54:	02 24       	jz	$+6      	;abs 0x5e5a
    5e56:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5e5a:	4c 49       	mov.b	r9,	r12	;
    5e5c:	7c f0 03 00 	and.b	#3,	r12	;
    5e60:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5e64:	8c 11       	sxt	r12		;
    5e66:	81 4c 06 00 	mov	r12,	6(r1)	;
    5e6a:	30 40 ca 43 	br	#0x43ca		;
    5e6e:	0a 9c       	cmp	r12,	r10	;
    5e70:	02 28       	jnc	$+6      	;abs 0x5e76
    5e72:	80 00 62 49 	mova	#18786,	r0	;0x04962
    5e76:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5e7a:	30 40 62 49 	br	#0x4962		;
    5e7e:	0a 9c       	cmp	r12,	r10	;
    5e80:	02 28       	jnc	$+6      	;abs 0x5e86
    5e82:	80 00 d6 50 	mova	#20694,	r0	;0x050d6
    5e86:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5e8a:	30 40 d6 50 	br	#0x50d6		;
    5e8e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5e90:	02 24       	jz	$+6      	;abs 0x5e96
    5e92:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5e96:	0d 4c       	mov	r12,	r13	;
    5e98:	5d 03       	rrum	#1,	r13	;
    5e9a:	1c b3       	bit	#1,	r12	;r3 As==01
    5e9c:	02 24       	jz	$+6      	;abs 0x5ea2
    5e9e:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5ea2:	0a 4d       	mov	r13,	r10	;
    5ea4:	5a 03       	rrum	#1,	r10	;
    5ea6:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5eaa:	1d b3       	bit	#1,	r13	;r3 As==01
    5eac:	02 20       	jnz	$+6      	;abs 0x5eb2
    5eae:	80 00 c6 4a 	mova	#19142,	r0	;0x04ac6
    5eb2:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5eb6:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5eba:	30 40 c6 4a 	br	#0x4ac6		;
    5ebe:	0d 93       	cmp	#0,	r13	;r3 As==00
    5ec0:	02 24       	jz	$+6      	;abs 0x5ec6
    5ec2:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5ec6:	0d 4c       	mov	r12,	r13	;
    5ec8:	5d 03       	rrum	#1,	r13	;
    5eca:	1c b3       	bit	#1,	r12	;r3 As==01
    5ecc:	02 24       	jz	$+6      	;abs 0x5ed2
    5ece:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5ed2:	0a 4d       	mov	r13,	r10	;
    5ed4:	5a 03       	rrum	#1,	r10	;
    5ed6:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5eda:	1d b3       	bit	#1,	r13	;r3 As==01
    5edc:	02 20       	jnz	$+6      	;abs 0x5ee2
    5ede:	80 00 52 43 	mova	#17234,	r0	;0x04352
    5ee2:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5ee6:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5eea:	30 40 52 43 	br	#0x4352		;
    5eee:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5ef2:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    5ef6:	30 40 c6 4a 	br	#0x4ac6		;
    5efa:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5efe:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    5f02:	30 40 52 43 	br	#0x4352		;

00005f06 <udivmodhi4>:
    5f06:	0f 4c       	mov	r12,	r15	;
    5f08:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011
    5f0c:	5b 43       	mov.b	#1,	r11	;r3 As==01
    5f0e:	0d 9f       	cmp	r15,	r13	;
    5f10:	05 2c       	jc	$+12     	;abs 0x5f1c
    5f12:	3c 53       	add	#-1,	r12	;r3 As==11
    5f14:	0c 93       	cmp	#0,	r12	;r3 As==00
    5f16:	05 24       	jz	$+12     	;abs 0x5f22
    5f18:	0d 93       	cmp	#0,	r13	;r3 As==00
    5f1a:	07 34       	jge	$+16     	;abs 0x5f2a
    5f1c:	4c 43       	clr.b	r12		;
    5f1e:	0b 93       	cmp	#0,	r11	;r3 As==00
    5f20:	07 20       	jnz	$+16     	;abs 0x5f30
    5f22:	0e 93       	cmp	#0,	r14	;r3 As==00
    5f24:	01 24       	jz	$+4      	;abs 0x5f28
    5f26:	0c 4f       	mov	r15,	r12	;
    5f28:	30 41       	ret			
    5f2a:	5d 02       	rlam	#1,	r13	;
    5f2c:	5b 02       	rlam	#1,	r11	;
    5f2e:	ef 3f       	jmp	$-32     	;abs 0x5f0e
    5f30:	0f 9d       	cmp	r13,	r15	;
    5f32:	02 28       	jnc	$+6      	;abs 0x5f38
    5f34:	0f 8d       	sub	r13,	r15	;
    5f36:	0c db       	bis	r11,	r12	;
    5f38:	5b 03       	rrum	#1,	r11	;
    5f3a:	5d 03       	rrum	#1,	r13	;
    5f3c:	f0 3f       	jmp	$-30     	;abs 0x5f1e

00005f3e <__mspabi_remu>:
    5f3e:	5e 43       	mov.b	#1,	r14	;r3 As==01
    5f40:	b0 12 06 5f 	call	#24326		;#0x5f06
    5f44:	30 41       	ret			

00005f46 <udivmodsi4>:
    5f46:	4a 15       	pushm	#5,	r10	;16-bit words
    5f48:	0a 4c       	mov	r12,	r10	;
    5f4a:	0b 4d       	mov	r13,	r11	;
    5f4c:	7c 40 21 00 	mov.b	#33,	r12	;#0x0021
    5f50:	58 43       	mov.b	#1,	r8	;r3 As==01
    5f52:	49 43       	clr.b	r9		;
    5f54:	0f 9b       	cmp	r11,	r15	;
    5f56:	04 28       	jnc	$+10     	;abs 0x5f60
    5f58:	0b 9f       	cmp	r15,	r11	;
    5f5a:	07 20       	jnz	$+16     	;abs 0x5f6a
    5f5c:	0e 9a       	cmp	r10,	r14	;
    5f5e:	05 2c       	jc	$+12     	;abs 0x5f6a
    5f60:	3c 53       	add	#-1,	r12	;r3 As==11
    5f62:	0c 93       	cmp	#0,	r12	;r3 As==00
    5f64:	2d 24       	jz	$+92     	;abs 0x5fc0
    5f66:	0f 93       	cmp	#0,	r15	;r3 As==00
    5f68:	0d 34       	jge	$+28     	;abs 0x5f84
    5f6a:	4c 43       	clr.b	r12		;
    5f6c:	4d 43       	clr.b	r13		;
    5f6e:	07 48       	mov	r8,	r7	;
    5f70:	07 d9       	bis	r9,	r7	;
    5f72:	07 93       	cmp	#0,	r7	;r3 As==00
    5f74:	14 20       	jnz	$+42     	;abs 0x5f9e
    5f76:	81 93 0c 00 	cmp	#0,	12(r1)	;r3 As==00, 0x000c
    5f7a:	02 24       	jz	$+6      	;abs 0x5f80
    5f7c:	0c 4a       	mov	r10,	r12	;
    5f7e:	0d 4b       	mov	r11,	r13	;
    5f80:	46 17       	popm	#5,	r10	;16-bit words
    5f82:	30 41       	ret			
    5f84:	06 4e       	mov	r14,	r6	;
    5f86:	07 4f       	mov	r15,	r7	;
    5f88:	06 5e       	add	r14,	r6	;
    5f8a:	07 6f       	addc	r15,	r7	;
    5f8c:	0e 46       	mov	r6,	r14	;
    5f8e:	0f 47       	mov	r7,	r15	;
    5f90:	06 48       	mov	r8,	r6	;
    5f92:	07 49       	mov	r9,	r7	;
    5f94:	06 58       	add	r8,	r6	;
    5f96:	07 69       	addc	r9,	r7	;
    5f98:	08 46       	mov	r6,	r8	;
    5f9a:	09 47       	mov	r7,	r9	;
    5f9c:	db 3f       	jmp	$-72     	;abs 0x5f54
    5f9e:	0b 9f       	cmp	r15,	r11	;
    5fa0:	08 28       	jnc	$+18     	;abs 0x5fb2
    5fa2:	0f 9b       	cmp	r11,	r15	;
    5fa4:	02 20       	jnz	$+6      	;abs 0x5faa
    5fa6:	0a 9e       	cmp	r14,	r10	;
    5fa8:	04 28       	jnc	$+10     	;abs 0x5fb2
    5faa:	0a 8e       	sub	r14,	r10	;
    5fac:	0b 7f       	subc	r15,	r11	;
    5fae:	0c d8       	bis	r8,	r12	;
    5fb0:	0d d9       	bis	r9,	r13	;
    5fb2:	12 c3       	clrc			
    5fb4:	09 10       	rrc	r9		;
    5fb6:	08 10       	rrc	r8		;
    5fb8:	12 c3       	clrc			
    5fba:	0f 10       	rrc	r15		;
    5fbc:	0e 10       	rrc	r14		;
    5fbe:	d7 3f       	jmp	$-80     	;abs 0x5f6e
    5fc0:	4c 43       	clr.b	r12		;
    5fc2:	4d 43       	clr.b	r13		;
    5fc4:	d8 3f       	jmp	$-78     	;abs 0x5f76

00005fc6 <__mspabi_divli>:
    5fc6:	2a 15       	pushm	#3,	r10	;16-bit words
    5fc8:	21 83       	decd	r1		;
    5fca:	4a 43       	clr.b	r10		;
    5fcc:	0d 93       	cmp	#0,	r13	;r3 As==00
    5fce:	07 34       	jge	$+16     	;abs 0x5fde
    5fd0:	48 43       	clr.b	r8		;
    5fd2:	49 43       	clr.b	r9		;
    5fd4:	08 8c       	sub	r12,	r8	;
    5fd6:	09 7d       	subc	r13,	r9	;
    5fd8:	0c 48       	mov	r8,	r12	;
    5fda:	0d 49       	mov	r9,	r13	;
    5fdc:	5a 43       	mov.b	#1,	r10	;r3 As==01
    5fde:	0f 93       	cmp	#0,	r15	;r3 As==00
    5fe0:	07 34       	jge	$+16     	;abs 0x5ff0
    5fe2:	48 43       	clr.b	r8		;
    5fe4:	49 43       	clr.b	r9		;
    5fe6:	08 8e       	sub	r14,	r8	;
    5fe8:	09 7f       	subc	r15,	r9	;
    5fea:	0e 48       	mov	r8,	r14	;
    5fec:	0f 49       	mov	r9,	r15	;
    5fee:	1a e3       	xor	#1,	r10	;r3 As==01
    5ff0:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    5ff4:	b0 12 46 5f 	call	#24390		;#0x5f46
    5ff8:	0a 93       	cmp	#0,	r10	;r3 As==00
    5ffa:	06 24       	jz	$+14     	;abs 0x6008
    5ffc:	49 43       	clr.b	r9		;
    5ffe:	4a 43       	clr.b	r10		;
    6000:	09 8c       	sub	r12,	r9	;
    6002:	0a 7d       	subc	r13,	r10	;
    6004:	0c 49       	mov	r9,	r12	;
    6006:	0d 4a       	mov	r10,	r13	;
    6008:	21 53       	incd	r1		;
    600a:	28 17       	popm	#3,	r10	;16-bit words
    600c:	30 41       	ret			

0000600e <__mulhi2>:
    600e:	02 12       	push	r2		;
    6010:	32 c2       	dint			
    6012:	03 43       	nop			
    6014:	82 4c c0 04 	mov	r12,	&0x04c0	;
    6018:	82 4d c8 04 	mov	r13,	&0x04c8	;
    601c:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    6020:	00 13       	reti			

00006022 <__mulsi2>:
    6022:	02 12       	push	r2		;
    6024:	32 c2       	dint			
    6026:	03 43       	nop			
    6028:	82 4c d0 04 	mov	r12,	&0x04d0	;
    602c:	82 4d d2 04 	mov	r13,	&0x04d2	;
    6030:	82 4e e0 04 	mov	r14,	&0x04e0	;
    6034:	82 4f e2 04 	mov	r15,	&0x04e2	;
    6038:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    603c:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    6040:	00 13       	reti			

00006042 <memcpy>:
    6042:	0f 4c       	mov	r12,	r15	;
    6044:	0e 5d       	add	r13,	r14	;
    6046:	0d 9e       	cmp	r14,	r13	;
    6048:	01 20       	jnz	$+4      	;abs 0x604c
    604a:	30 41       	ret			
    604c:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    6050:	1f 53       	inc	r15		;
    6052:	f9 3f       	jmp	$-12     	;abs 0x6046

00006054 <_exit>:
    6054:	ff 3f       	jmp	$+0      	;abs 0x6054
