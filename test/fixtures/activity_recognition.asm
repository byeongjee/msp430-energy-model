
/Users/byeongjee/migration/probabilistic-energy-modeling/build/activity_recognition_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004064 <__crt0_start>:
    4064:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004068 <__crt0_call_main>:
    4068:	0c 43       	clr	r12		;
    406a:	b0 12 92 42 	call	#17042		;#0x4292

0000406e <__crt0_call_exit>:
    406e:	b0 12 3c 60 	call	#24636		;#0x603c

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
    422a:	3d 40 3e 60 	mov	#24638,	r13	;#0x603e
    422e:	b0 12 2a 60 	call	#24618		;#0x602a
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
    432a:	80 00 a6 5e 	mova	#24230,	r0	;0x05ea6
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
    434e:	80 00 e2 5e 	mova	#24290,	r0	;0x05ee2
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
    436e:	80 00 0a 5e 	mova	#24074,	r0	;0x05e0a
    4372:	0c 93       	cmp	#0,	r12	;r3 As==00
    4374:	02 24       	jz	$+6      	;abs 0x437a
    4376:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    437a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    437e:	0c 4a       	mov	r10,	r12	;
    4380:	b0 12 26 5f 	call	#24358		;#0x5f26
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
    439e:	b0 12 26 5f 	call	#24358		;#0x5f26
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
    43bc:	b0 12 26 5f 	call	#24358		;#0x5f26
    43c0:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    43c4:	8c 11       	sxt	r12		;
    43c6:	81 4c 06 00 	mov	r12,	6(r1)	;
    43ca:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    43ce:	0c 49       	mov	r9,	r12	;
    43d0:	5c f3       	and.b	#1,	r12	;r3 As==01
    43d2:	59 03       	rrum	#1,	r9	;
    43d4:	0d 93       	cmp	#0,	r13	;r3 As==00
    43d6:	02 20       	jnz	$+6      	;abs 0x43dc
    43d8:	80 00 ba 5d 	mova	#23994,	r0	;0x05dba
    43dc:	0c 93       	cmp	#0,	r12	;r3 As==00
    43de:	02 24       	jz	$+6      	;abs 0x43e4
    43e0:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    43e4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    43e8:	0c 49       	mov	r9,	r12	;
    43ea:	b0 12 26 5f 	call	#24358		;#0x5f26
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
    440a:	b0 12 26 5f 	call	#24358		;#0x5f26
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
    442a:	b0 12 26 5f 	call	#24358		;#0x5f26
    442e:	47 4c       	mov.b	r12,	r7	;
    4430:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4434:	87 11       	sxt	r7		;
    4436:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    443a:	0c 49       	mov	r9,	r12	;
    443c:	5c f3       	and.b	#1,	r12	;r3 As==01
    443e:	59 03       	rrum	#1,	r9	;
    4440:	0d 93       	cmp	#0,	r13	;r3 As==00
    4442:	02 20       	jnz	$+6      	;abs 0x4448
    4444:	80 00 64 5d 	mova	#23908,	r0	;0x05d64
    4448:	0c 93       	cmp	#0,	r12	;r3 As==00
    444a:	02 24       	jz	$+6      	;abs 0x4450
    444c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4450:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4454:	0c 49       	mov	r9,	r12	;
    4456:	b0 12 26 5f 	call	#24358		;#0x5f26
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
    4474:	b0 12 26 5f 	call	#24358		;#0x5f26
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
    44a0:	b0 12 26 5f 	call	#24358		;#0x5f26
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
    44be:	80 00 58 5d 	mova	#23896,	r0	;0x05d58
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
    44e0:	80 00 4c 5d 	mova	#23884,	r0	;0x05d4c
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
    4508:	80 00 3c 5d 	mova	#23868,	r0	;0x05d3c
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
    45ce:	80 00 2c 5d 	mova	#23852,	r0	;0x05d2c
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
    45fa:	80 00 12 5d 	mova	#23826,	r0	;0x05d12
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
    461e:	80 00 06 5d 	mova	#23814,	r0	;0x05d06
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
    4654:	b0 12 ae 5f 	call	#24494		;#0x5fae
    4658:	81 4c 02 00 	mov	r12,	2(r1)	;
    465c:	7e 40 03 00 	mov.b	#3,	r14	;
    4660:	4f 43       	clr.b	r15		;
    4662:	0c 48       	mov	r8,	r12	;
    4664:	0d 49       	mov	r9,	r13	;
    4666:	b0 12 ae 5f 	call	#24494		;#0x5fae
    466a:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    466e:	7e 40 03 00 	mov.b	#3,	r14	;
    4672:	4f 43       	clr.b	r15		;
    4674:	0c 4a       	mov	r10,	r12	;
    4676:	0d 47       	mov	r7,	r13	;
    4678:	b0 12 ae 5f 	call	#24494		;#0x5fae
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
    479e:	b0 12 ae 5f 	call	#24494		;#0x5fae
    47a2:	0a 4c       	mov	r12,	r10	;
    47a4:	7e 40 03 00 	mov.b	#3,	r14	;
    47a8:	4f 43       	clr.b	r15		;
    47aa:	0c 49       	mov	r9,	r12	;
    47ac:	0d 48       	mov	r8,	r13	;
    47ae:	b0 12 ae 5f 	call	#24494		;#0x5fae
    47b2:	09 4c       	mov	r12,	r9	;
    47b4:	7e 40 03 00 	mov.b	#3,	r14	;
    47b8:	4f 43       	clr.b	r15		;
    47ba:	0c 47       	mov	r7,	r12	;
    47bc:	0d 46       	mov	r6,	r13	;
    47be:	b0 12 ae 5f 	call	#24494		;#0x5fae
    47c2:	08 4c       	mov	r12,	r8	;
    47c4:	0c 4a       	mov	r10,	r12	;
    47c6:	0d 4a       	mov	r10,	r13	;
    47c8:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    47cc:	0a 4c       	mov	r12,	r10	;
    47ce:	0c 49       	mov	r9,	r12	;
    47d0:	0d 49       	mov	r9,	r13	;
    47d2:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    47d6:	0a 5c       	add	r12,	r10	;
    47d8:	0c 48       	mov	r8,	r12	;
    47da:	0d 48       	mov	r8,	r13	;
    47dc:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    47e0:	0a 5c       	add	r12,	r10	;
    47e2:	1c 41 02 00 	mov	2(r1),	r12	;
    47e6:	0d 4c       	mov	r12,	r13	;
    47e8:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    47ec:	07 4c       	mov	r12,	r7	;
    47ee:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    47f2:	0d 4c       	mov	r12,	r13	;
    47f4:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    47f8:	07 5c       	add	r12,	r7	;
    47fa:	0c 45       	mov	r5,	r12	;
    47fc:	0d 45       	mov	r5,	r13	;
    47fe:	b0 12 f6 5f 	call	#24566		;#0x5ff6
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
    4824:	b0 12 0a 60 	call	#24586		;#0x600a
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
    4848:	b0 12 0a 60 	call	#24586		;#0x600a
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
    486c:	b0 12 0a 60 	call	#24586		;#0x600a
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
    488e:	b0 12 0a 60 	call	#24586		;#0x600a
    4892:	0d 93       	cmp	#0,	r13	;r3 As==00
    4894:	02 24       	jz	$+6      	;abs 0x489a
    4896:	80 00 6c 5a 	mova	#23148,	r0	;0x05a6c
    489a:	09 93       	cmp	#0,	r9	;r3 As==00
    489c:	04 20       	jnz	$+10     	;abs 0x48a6
    489e:	07 9c       	cmp	r12,	r7	;
    48a0:	02 2c       	jc	$+6      	;abs 0x48a6
    48a2:	80 00 6c 5a 	mova	#23148,	r0	;0x05a6c
    48a6:	05 46       	mov	r6,	r5	;
    48a8:	25 d2       	bis	#4,	r5	;r2 As==10
    48aa:	0c 45       	mov	r5,	r12	;
    48ac:	0d 44       	mov	r4,	r13	;
    48ae:	0e 45       	mov	r5,	r14	;
    48b0:	0f 44       	mov	r4,	r15	;
    48b2:	b0 12 0a 60 	call	#24586		;#0x600a
    48b6:	0d 93       	cmp	#0,	r13	;r3 As==00
    48b8:	02 24       	jz	$+6      	;abs 0x48be
    48ba:	80 00 64 5a 	mova	#23140,	r0	;0x05a64
    48be:	09 93       	cmp	#0,	r9	;r3 As==00
    48c0:	04 20       	jnz	$+10     	;abs 0x48ca
    48c2:	07 9c       	cmp	r12,	r7	;
    48c4:	02 2c       	jc	$+6      	;abs 0x48ca
    48c6:	80 00 64 5a 	mova	#23140,	r0	;0x05a64
    48ca:	06 45       	mov	r5,	r6	;
    48cc:	26 d3       	bis	#2,	r6	;r3 As==10
    48ce:	0c 46       	mov	r6,	r12	;
    48d0:	0d 44       	mov	r4,	r13	;
    48d2:	0e 46       	mov	r6,	r14	;
    48d4:	0f 44       	mov	r4,	r15	;
    48d6:	b0 12 0a 60 	call	#24586		;#0x600a
    48da:	0d 93       	cmp	#0,	r13	;r3 As==00
    48dc:	02 24       	jz	$+6      	;abs 0x48e2
    48de:	80 00 5c 5a 	mova	#23132,	r0	;0x05a5c
    48e2:	09 93       	cmp	#0,	r9	;r3 As==00
    48e4:	04 20       	jnz	$+10     	;abs 0x48ee
    48e6:	07 9c       	cmp	r12,	r7	;
    48e8:	02 2c       	jc	$+6      	;abs 0x48ee
    48ea:	80 00 5c 5a 	mova	#23132,	r0	;0x05a5c
    48ee:	05 46       	mov	r6,	r5	;
    48f0:	15 d3       	bis	#1,	r5	;r3 As==01
    48f2:	0c 45       	mov	r5,	r12	;
    48f4:	0d 44       	mov	r4,	r13	;
    48f6:	0e 45       	mov	r5,	r14	;
    48f8:	0f 44       	mov	r4,	r15	;
    48fa:	b0 12 0a 60 	call	#24586		;#0x600a
    48fe:	0d 93       	cmp	#0,	r13	;r3 As==00
    4900:	02 24       	jz	$+6      	;abs 0x4906
    4902:	80 00 26 5a 	mova	#23078,	r0	;0x05a26
    4906:	09 93       	cmp	#0,	r9	;r3 As==00
    4908:	04 20       	jnz	$+10     	;abs 0x4912
    490a:	07 9c       	cmp	r12,	r7	;
    490c:	02 2c       	jc	$+6      	;abs 0x4912
    490e:	80 00 26 5a 	mova	#23078,	r0	;0x05a26
    4912:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    4916:	0d 4a       	mov	r10,	r13	;
    4918:	0e 43       	clr	r14		;
    491a:	81 4d 06 00 	mov	r13,	6(r1)	;
    491e:	81 4e 08 00 	mov	r14,	8(r1)	;
    4922:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    4926:	0e 9a       	cmp	r10,	r14	;
    4928:	02 2c       	jc	$+6      	;abs 0x492e
    492a:	80 00 46 5a 	mova	#23110,	r0	;0x05a46
    492e:	39 40 ff 03 	mov	#1023,	r9	;#0x03ff
    4932:	78 40 20 00 	mov.b	#32,	r8	;#0x0020
    4936:	09 9a       	cmp	r10,	r9	;
    4938:	02 28       	jnc	$+6      	;abs 0x493e
    493a:	80 00 22 5d 	mova	#23842,	r0	;0x05d22
    493e:	09 44       	mov	r4,	r9	;
    4940:	38 d0 10 00 	bis	#16,	r8	;#0x0010
    4944:	0c 48       	mov	r8,	r12	;
    4946:	0d 49       	mov	r9,	r13	;
    4948:	0e 48       	mov	r8,	r14	;
    494a:	0f 49       	mov	r9,	r15	;
    494c:	b0 12 0a 60 	call	#24586		;#0x600a
    4950:	0d 93       	cmp	#0,	r13	;r3 As==00
    4952:	02 24       	jz	$+6      	;abs 0x4958
    4954:	80 00 54 5a 	mova	#23124,	r0	;0x05a54
    4958:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    495c:	02 20       	jnz	$+6      	;abs 0x4962
    495e:	80 00 56 5e 	mova	#24150,	r0	;0x05e56
    4962:	06 48       	mov	r8,	r6	;
    4964:	36 d2       	bis	#8,	r6	;r2 As==11
    4966:	0c 46       	mov	r6,	r12	;
    4968:	0d 49       	mov	r9,	r13	;
    496a:	0e 46       	mov	r6,	r14	;
    496c:	0f 49       	mov	r9,	r15	;
    496e:	b0 12 0a 60 	call	#24586		;#0x600a
    4972:	0d 93       	cmp	#0,	r13	;r3 As==00
    4974:	02 24       	jz	$+6      	;abs 0x497a
    4976:	80 00 1e 5a 	mova	#23070,	r0	;0x05a1e
    497a:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    497e:	04 20       	jnz	$+10     	;abs 0x4988
    4980:	0a 9c       	cmp	r12,	r10	;
    4982:	02 2c       	jc	$+6      	;abs 0x4988
    4984:	80 00 1e 5a 	mova	#23070,	r0	;0x05a1e
    4988:	07 46       	mov	r6,	r7	;
    498a:	27 d2       	bis	#4,	r7	;r2 As==10
    498c:	0c 47       	mov	r7,	r12	;
    498e:	0d 49       	mov	r9,	r13	;
    4990:	0e 47       	mov	r7,	r14	;
    4992:	0f 49       	mov	r9,	r15	;
    4994:	b0 12 0a 60 	call	#24586		;#0x600a
    4998:	0d 93       	cmp	#0,	r13	;r3 As==00
    499a:	02 24       	jz	$+6      	;abs 0x49a0
    499c:	80 00 16 5a 	mova	#23062,	r0	;0x05a16
    49a0:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49a4:	04 20       	jnz	$+10     	;abs 0x49ae
    49a6:	0a 9c       	cmp	r12,	r10	;
    49a8:	02 2c       	jc	$+6      	;abs 0x49ae
    49aa:	80 00 16 5a 	mova	#23062,	r0	;0x05a16
    49ae:	08 47       	mov	r7,	r8	;
    49b0:	28 d3       	bis	#2,	r8	;r3 As==10
    49b2:	0c 48       	mov	r8,	r12	;
    49b4:	0d 49       	mov	r9,	r13	;
    49b6:	0e 48       	mov	r8,	r14	;
    49b8:	0f 49       	mov	r9,	r15	;
    49ba:	b0 12 0a 60 	call	#24586		;#0x600a
    49be:	0d 93       	cmp	#0,	r13	;r3 As==00
    49c0:	02 24       	jz	$+6      	;abs 0x49c6
    49c2:	80 00 0e 5a 	mova	#23054,	r0	;0x05a0e
    49c6:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    49ca:	04 20       	jnz	$+10     	;abs 0x49d4
    49cc:	0a 9c       	cmp	r12,	r10	;
    49ce:	02 2c       	jc	$+6      	;abs 0x49d4
    49d0:	80 00 0e 5a 	mova	#23054,	r0	;0x05a0e
    49d4:	07 48       	mov	r8,	r7	;
    49d6:	17 d3       	bis	#1,	r7	;r3 As==01
    49d8:	0c 47       	mov	r7,	r12	;
    49da:	0d 49       	mov	r9,	r13	;
    49dc:	0e 47       	mov	r7,	r14	;
    49de:	0f 49       	mov	r9,	r15	;
    49e0:	b0 12 0a 60 	call	#24586		;#0x600a
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
    4a24:	92 43 80 1c 	mov	#1,	&0x1c80	;r3 As==01
    4a28:	b0 12 b0 40 	call	#16560		;#0x40b0
    4a2c:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    4a30:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a34:	0d 4c       	mov	r12,	r13	;
    4a36:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a38:	5c 03       	rrum	#1,	r12	;
    4a3a:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a3c:	02 24       	jz	$+6      	;abs 0x4a42
    4a3e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a42:	0d 4c       	mov	r12,	r13	;
    4a44:	5d 03       	rrum	#1,	r13	;
    4a46:	1c b3       	bit	#1,	r12	;r3 As==01
    4a48:	02 24       	jz	$+6      	;abs 0x4a4e
    4a4a:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4a4e:	0c 4d       	mov	r13,	r12	;
    4a50:	5c 03       	rrum	#1,	r12	;
    4a52:	1d b3       	bit	#1,	r13	;r3 As==01
    4a54:	02 24       	jz	$+6      	;abs 0x4a5a
    4a56:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a5a:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a5e:	0d 4c       	mov	r12,	r13	;
    4a60:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a62:	5c 03       	rrum	#1,	r12	;
    4a64:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a66:	02 24       	jz	$+6      	;abs 0x4a6c
    4a68:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a6c:	0d 4c       	mov	r12,	r13	;
    4a6e:	5d 03       	rrum	#1,	r13	;
    4a70:	1c b3       	bit	#1,	r12	;r3 As==01
    4a72:	02 24       	jz	$+6      	;abs 0x4a78
    4a74:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4a78:	0c 4d       	mov	r13,	r12	;
    4a7a:	5c 03       	rrum	#1,	r12	;
    4a7c:	1d b3       	bit	#1,	r13	;r3 As==01
    4a7e:	02 24       	jz	$+6      	;abs 0x4a84
    4a80:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a84:	1e 42 80 1c 	mov	&0x1c80,r14	;0x1c80
    4a88:	0d 4c       	mov	r12,	r13	;
    4a8a:	5d f3       	and.b	#1,	r13	;r3 As==01
    4a8c:	5c 03       	rrum	#1,	r12	;
    4a8e:	0e 93       	cmp	#0,	r14	;r3 As==00
    4a90:	02 24       	jz	$+6      	;abs 0x4a96
    4a92:	80 00 76 5e 	mova	#24182,	r0	;0x05e76
    4a96:	0d 93       	cmp	#0,	r13	;r3 As==00
    4a98:	02 24       	jz	$+6      	;abs 0x4a9e
    4a9a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    4a9e:	0d 4c       	mov	r12,	r13	;
    4aa0:	5d 03       	rrum	#1,	r13	;
    4aa2:	1c b3       	bit	#1,	r12	;r3 As==01
    4aa4:	02 24       	jz	$+6      	;abs 0x4aaa
    4aa6:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    4aaa:	09 4d       	mov	r13,	r9	;
    4aac:	59 03       	rrum	#1,	r9	;
    4aae:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    4ab2:	1d b3       	bit	#1,	r13	;r3 As==01
    4ab4:	02 24       	jz	$+6      	;abs 0x4aba
    4ab6:	80 00 d6 5e 	mova	#24278,	r0	;0x05ed6
    4aba:	b1 40 40 1c 	mov	#7232,	14(r1)	;#0x1c40, 0x000e
    4abe:	0e 00 
    4ac0:	44 43       	clr.b	r4		;
    4ac2:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4ac6:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4aca:	5c f3       	and.b	#1,	r12	;r3 As==01
    4acc:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    4ad0:	5a 03       	rrum	#1,	r10	;
    4ad2:	0d 93       	cmp	#0,	r13	;r3 As==00
    4ad4:	02 20       	jnz	$+6      	;abs 0x4ada
    4ad6:	80 00 ba 5c 	mova	#23738,	r0	;0x05cba
    4ada:	0c 93       	cmp	#0,	r12	;r3 As==00
    4adc:	02 24       	jz	$+6      	;abs 0x4ae2
    4ade:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    4ae2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4ae6:	0c 4a       	mov	r10,	r12	;
    4ae8:	b0 12 26 5f 	call	#24358		;#0x5f26
    4aec:	46 4c       	mov.b	r12,	r6	;
    4aee:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    4af2:	86 11       	sxt	r6		;
    4af4:	08 4a       	mov	r10,	r8	;
    4af6:	58 03       	rrum	#1,	r8	;
    4af8:	1a b3       	bit	#1,	r10	;r3 As==01
    4afa:	02 24       	jz	$+6      	;abs 0x4b00
    4afc:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4b00:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b04:	0c 48       	mov	r8,	r12	;
    4b06:	b0 12 26 5f 	call	#24358		;#0x5f26
    4b0a:	4a 4c       	mov.b	r12,	r10	;
    4b0c:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    4b10:	8a 11       	sxt	r10		;
    4b12:	09 48       	mov	r8,	r9	;
    4b14:	59 03       	rrum	#1,	r9	;
    4b16:	18 b3       	bit	#1,	r8	;r3 As==01
    4b18:	02 24       	jz	$+6      	;abs 0x4b1e
    4b1a:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b1e:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b22:	0c 49       	mov	r9,	r12	;
    4b24:	b0 12 26 5f 	call	#24358		;#0x5f26
    4b28:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b2c:	8c 11       	sxt	r12		;
    4b2e:	81 4c 06 00 	mov	r12,	6(r1)	;
    4b32:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4b36:	0c 49       	mov	r9,	r12	;
    4b38:	5c f3       	and.b	#1,	r12	;r3 As==01
    4b3a:	59 03       	rrum	#1,	r9	;
    4b3c:	0d 93       	cmp	#0,	r13	;r3 As==00
    4b3e:	02 20       	jnz	$+6      	;abs 0x4b44
    4b40:	80 00 6a 5c 	mova	#23658,	r0	;0x05c6a
    4b44:	0c 93       	cmp	#0,	r12	;r3 As==00
    4b46:	02 24       	jz	$+6      	;abs 0x4b4c
    4b48:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b4c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b50:	0c 49       	mov	r9,	r12	;
    4b52:	b0 12 26 5f 	call	#24358		;#0x5f26
    4b56:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b5a:	8c 11       	sxt	r12		;
    4b5c:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    4b60:	08 49       	mov	r9,	r8	;
    4b62:	58 03       	rrum	#1,	r8	;
    4b64:	19 b3       	bit	#1,	r9	;r3 As==01
    4b66:	02 24       	jz	$+6      	;abs 0x4b6c
    4b68:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    4b6c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b70:	0c 48       	mov	r8,	r12	;
    4b72:	b0 12 26 5f 	call	#24358		;#0x5f26
    4b76:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4b7a:	8c 11       	sxt	r12		;
    4b7c:	81 4c 10 00 	mov	r12,	16(r1)	; 0x0010
    4b80:	09 48       	mov	r8,	r9	;
    4b82:	59 03       	rrum	#1,	r9	;
    4b84:	18 b3       	bit	#1,	r8	;r3 As==01
    4b86:	02 24       	jz	$+6      	;abs 0x4b8c
    4b88:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4b8c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4b90:	0c 49       	mov	r9,	r12	;
    4b92:	b0 12 26 5f 	call	#24358		;#0x5f26
    4b96:	47 4c       	mov.b	r12,	r7	;
    4b98:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    4b9c:	87 11       	sxt	r7		;
    4b9e:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    4ba2:	0c 49       	mov	r9,	r12	;
    4ba4:	5c f3       	and.b	#1,	r12	;r3 As==01
    4ba6:	59 03       	rrum	#1,	r9	;
    4ba8:	0d 93       	cmp	#0,	r13	;r3 As==00
    4baa:	02 20       	jnz	$+6      	;abs 0x4bb0
    4bac:	80 00 14 5c 	mova	#23572,	r0	;0x05c14
    4bb0:	0c 93       	cmp	#0,	r12	;r3 As==00
    4bb2:	02 24       	jz	$+6      	;abs 0x4bb8
    4bb4:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    4bb8:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4bbc:	0c 49       	mov	r9,	r12	;
    4bbe:	b0 12 26 5f 	call	#24358		;#0x5f26
    4bc2:	48 4c       	mov.b	r12,	r8	;
    4bc4:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    4bc8:	88 11       	sxt	r8		;
    4bca:	05 49       	mov	r9,	r5	;
    4bcc:	55 03       	rrum	#1,	r5	;
    4bce:	19 b3       	bit	#1,	r9	;r3 As==01
    4bd0:	02 24       	jz	$+6      	;abs 0x4bd6
    4bd2:	35 e0 00 b4 	xor	#-19456,r5	;#0xb400
    4bd6:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4bda:	0c 45       	mov	r5,	r12	;
    4bdc:	b0 12 26 5f 	call	#24358		;#0x5f26
    4be0:	49 4c       	mov.b	r12,	r9	;
    4be2:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    4be6:	89 11       	sxt	r9		;
    4be8:	0d 45       	mov	r5,	r13	;
    4bea:	5d 03       	rrum	#1,	r13	;
    4bec:	81 4d 12 00 	mov	r13,	18(r1)	; 0x0012
    4bf0:	15 b3       	bit	#1,	r5	;r3 As==01
    4bf2:	03 24       	jz	$+8      	;abs 0x4bfa
    4bf4:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    4bf8:	12 00 
    4bfa:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    4bfe:	82 1c 
    4c00:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4c04:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    4c08:	b0 12 26 5f 	call	#24358		;#0x5f26
    4c0c:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4c10:	8c 11       	sxt	r12		;
    4c12:	0e 46       	mov	r6,	r14	;
    4c14:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c18:	4d 4e       	mov.b	r14,	r13	;
    4c1a:	4d e6       	xor.b	r6,	r13	;
    4c1c:	4d 8e       	sub.b	r14,	r13	;
    4c1e:	7e 40 09 00 	mov.b	#9,	r14	;
    4c22:	4e 9d       	cmp.b	r13,	r14	;
    4c24:	02 28       	jnc	$+6      	;abs 0x4c2a
    4c26:	80 00 08 5c 	mova	#23560,	r0	;0x05c08
    4c2a:	81 46 18 00 	mov	r6,	24(r1)	; 0x0018
    4c2e:	05 46       	mov	r6,	r5	;
    4c30:	4e 18 06 11 	rpt #15 { rrax.w	r6		;
    4c34:	0e 4a       	mov	r10,	r14	;
    4c36:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c3a:	4d 4e       	mov.b	r14,	r13	;
    4c3c:	4d ea       	xor.b	r10,	r13	;
    4c3e:	4d 8e       	sub.b	r14,	r13	;
    4c40:	7e 40 09 00 	mov.b	#9,	r14	;
    4c44:	4e 9d       	cmp.b	r13,	r14	;
    4c46:	02 28       	jnc	$+6      	;abs 0x4c4c
    4c48:	80 00 fc 5b 	mova	#23548,	r0	;0x05bfc
    4c4c:	81 4a 1c 00 	mov	r10,	28(r1)	; 0x001c
    4c50:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4c54:	0b 7b       	subc	r11,	r11	;
    4c56:	3b e3       	inv	r11		;
    4c58:	1e 41 06 00 	mov	6(r1),	r14	;
    4c5c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c60:	1d 41 06 00 	mov	6(r1),	r13	;
    4c64:	4d ee       	xor.b	r14,	r13	;
    4c66:	4d 8e       	sub.b	r14,	r13	;
    4c68:	7e 40 09 00 	mov.b	#9,	r14	;
    4c6c:	4e 9d       	cmp.b	r13,	r14	;
    4c6e:	02 28       	jnc	$+6      	;abs 0x4c74
    4c70:	80 00 ec 5b 	mova	#23532,	r0	;0x05bec
    4c74:	1e 41 06 00 	mov	6(r1),	r14	;
    4c78:	0d 4e       	mov	r14,	r13	;
    4c7a:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4c7e:	81 4d 02 00 	mov	r13,	2(r1)	;
    4c82:	81 4e 04 00 	mov	r14,	4(r1)	;
    4c86:	1e 41 0a 00 	mov	10(r1),	r14	;0x0000a
    4c8a:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4c8e:	1d 41 0a 00 	mov	10(r1),	r13	;0x0000a
    4c92:	4d ee       	xor.b	r14,	r13	;
    4c94:	4d 8e       	sub.b	r14,	r13	;
    4c96:	81 44 14 00 	mov	r4,	20(r1)	; 0x0014
    4c9a:	7e 40 09 00 	mov.b	#9,	r14	;
    4c9e:	4e 9d       	cmp.b	r13,	r14	;
    4ca0:	0b 2c       	jc	$+24     	;abs 0x4cb8
    4ca2:	91 41 0a 00 	mov	10(r1),	20(r1)	;0x0000a, 0x0014
    4ca6:	14 00 
    4ca8:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4cac:	0e 4d       	mov	r13,	r14	;
    4cae:	0f 4d       	mov	r13,	r15	;
    4cb0:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4cb4:	05 5e       	add	r14,	r5	;
    4cb6:	06 6f       	addc	r15,	r6	;
    4cb8:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    4cbc:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4cc0:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4cc4:	4d ee       	xor.b	r14,	r13	;
    4cc6:	4d 8e       	sub.b	r14,	r13	;
    4cc8:	81 44 16 00 	mov	r4,	22(r1)	; 0x0016
    4ccc:	7e 40 09 00 	mov.b	#9,	r14	;
    4cd0:	4e 9d       	cmp.b	r13,	r14	;
    4cd2:	0b 2c       	jc	$+24     	;abs 0x4cea
    4cd4:	91 41 10 00 	mov	16(r1),	22(r1)	;0x00010, 0x0016
    4cd8:	16 00 
    4cda:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4cde:	0e 4d       	mov	r13,	r14	;
    4ce0:	0f 4d       	mov	r13,	r15	;
    4ce2:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4ce6:	0a 5e       	add	r14,	r10	;
    4ce8:	0b 6f       	addc	r15,	r11	;
    4cea:	0e 47       	mov	r7,	r14	;
    4cec:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4cf0:	4d 4e       	mov.b	r14,	r13	;
    4cf2:	4d e7       	xor.b	r7,	r13	;
    4cf4:	4d 8e       	sub.b	r14,	r13	;
    4cf6:	81 44 10 00 	mov	r4,	16(r1)	; 0x0010
    4cfa:	7e 40 09 00 	mov.b	#9,	r14	;
    4cfe:	4e 9d       	cmp.b	r13,	r14	;
    4d00:	10 2c       	jc	$+34     	;abs 0x4d22
    4d02:	81 47 10 00 	mov	r7,	16(r1)	; 0x0010
    4d06:	0d 47       	mov	r7,	r13	;
    4d08:	0e 47       	mov	r7,	r14	;
    4d0a:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4d0e:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    4d12:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    4d16:	91 51 0a 00 	rla	10(r1)		;#0x0000a
    4d1a:	02 00 
    4d1c:	91 61 0c 00 	rlc	12(r1)		;#0x0000c
    4d20:	04 00 
    4d22:	0e 48       	mov	r8,	r14	;
    4d24:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4d28:	4d 4e       	mov.b	r14,	r13	;
    4d2a:	4d e8       	xor.b	r8,	r13	;
    4d2c:	4d 8e       	sub.b	r14,	r13	;
    4d2e:	7e 40 09 00 	mov.b	#9,	r14	;
    4d32:	4e 9d       	cmp.b	r13,	r14	;
    4d34:	02 28       	jnc	$+6      	;abs 0x4d3a
    4d36:	80 00 dc 5b 	mova	#23516,	r0	;0x05bdc
    4d3a:	81 48 22 00 	mov	r8,	34(r1)	; 0x0022
    4d3e:	0d 48       	mov	r8,	r13	;
    4d40:	0e 48       	mov	r8,	r14	;
    4d42:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4d46:	81 4d 0a 00 	mov	r13,	10(r1)	; 0x000a
    4d4a:	81 4e 0c 00 	mov	r14,	12(r1)	; 0x000c
    4d4e:	0e 49       	mov	r9,	r14	;
    4d50:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    4d54:	4d 4e       	mov.b	r14,	r13	;
    4d56:	4d e9       	xor.b	r9,	r13	;
    4d58:	4d 8e       	sub.b	r14,	r13	;
    4d5a:	7e 40 09 00 	mov.b	#9,	r14	;
    4d5e:	4e 9d       	cmp.b	r13,	r14	;
    4d60:	02 28       	jnc	$+6      	;abs 0x4d66
    4d62:	80 00 d0 5b 	mova	#23504,	r0	;0x05bd0
    4d66:	81 49 24 00 	mov	r9,	36(r1)	; 0x0024
    4d6a:	0e 49       	mov	r9,	r14	;
    4d6c:	0f 49       	mov	r9,	r15	;
    4d6e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4d72:	09 4c       	mov	r12,	r9	;
    4d74:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    4d78:	4d 49       	mov.b	r9,	r13	;
    4d7a:	4d ec       	xor.b	r12,	r13	;
    4d7c:	4d 89       	sub.b	r9,	r13	;
    4d7e:	79 40 09 00 	mov.b	#9,	r9	;
    4d82:	49 9d       	cmp.b	r13,	r9	;
    4d84:	02 28       	jnc	$+6      	;abs 0x4d8a
    4d86:	80 00 c4 5b 	mova	#23492,	r0	;0x05bc4
    4d8a:	81 4c 26 00 	mov	r12,	38(r1)	; 0x0026
    4d8e:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4d92:	0d 7d       	subc	r13,	r13	;
    4d94:	3d e3       	inv	r13		;
    4d96:	08 4e       	mov	r14,	r8	;
    4d98:	08 5a       	add	r10,	r8	;
    4d9a:	09 4f       	mov	r15,	r9	;
    4d9c:	09 6b       	addc	r11,	r9	;
    4d9e:	0a 4c       	mov	r12,	r10	;
    4da0:	1a 51 02 00 	add	2(r1),	r10	;
    4da4:	17 41 04 00 	mov	4(r1),	r7	;
    4da8:	07 6d       	addc	r13,	r7	;
    4daa:	7e 40 03 00 	mov.b	#3,	r14	;
    4dae:	4f 43       	clr.b	r15		;
    4db0:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    4db4:	0c 55       	add	r5,	r12	;
    4db6:	1d 41 0c 00 	mov	12(r1),	r13	;0x0000c
    4dba:	0d 66       	addc	r6,	r13	;
    4dbc:	b0 12 ae 5f 	call	#24494		;#0x5fae
    4dc0:	81 4c 02 00 	mov	r12,	2(r1)	;
    4dc4:	7e 40 03 00 	mov.b	#3,	r14	;
    4dc8:	4f 43       	clr.b	r15		;
    4dca:	0c 48       	mov	r8,	r12	;
    4dcc:	0d 49       	mov	r9,	r13	;
    4dce:	b0 12 ae 5f 	call	#24494		;#0x5fae
    4dd2:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    4dd6:	7e 40 03 00 	mov.b	#3,	r14	;
    4dda:	4f 43       	clr.b	r15		;
    4ddc:	0c 4a       	mov	r10,	r12	;
    4dde:	0d 47       	mov	r7,	r13	;
    4de0:	b0 12 ae 5f 	call	#24494		;#0x5fae
    4de4:	05 4c       	mov	r12,	r5	;
    4de6:	16 41 18 00 	mov	24(r1),	r6	;0x00018
    4dea:	16 81 02 00 	sub	2(r1),	r6	;
    4dee:	0c 46       	mov	r6,	r12	;
    4df0:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    4df4:	06 ec       	xor	r12,	r6	;
    4df6:	0e 46       	mov	r6,	r14	;
    4df8:	0e 8c       	sub	r12,	r14	;
    4dfa:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4dfe:	0f 7f       	subc	r15,	r15	;
    4e00:	3f e3       	inv	r15		;
    4e02:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    4e06:	1c 81 02 00 	sub	2(r1),	r12	;
    4e0a:	0d 4c       	mov	r12,	r13	;
    4e0c:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4e10:	0c ed       	xor	r13,	r12	;
    4e12:	0c 8d       	sub	r13,	r12	;
    4e14:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4e18:	0d 7d       	subc	r13,	r13	;
    4e1a:	3d e3       	inv	r13		;
    4e1c:	0c 5e       	add	r14,	r12	;
    4e1e:	0a 4f       	mov	r15,	r10	;
    4e20:	0a 6d       	addc	r13,	r10	;
    4e22:	81 4a 14 00 	mov	r10,	20(r1)	; 0x0014
    4e26:	1a 41 1c 00 	mov	28(r1),	r10	;0x0001c
    4e2a:	1a 81 0a 00 	sub	10(r1),	r10	;0x0000a
    4e2e:	0d 4a       	mov	r10,	r13	;
    4e30:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4e34:	0a ed       	xor	r13,	r10	;
    4e36:	0a 8d       	sub	r13,	r10	;
    4e38:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4e3c:	0b 7b       	subc	r11,	r11	;
    4e3e:	3b e3       	inv	r11		;
    4e40:	1d 41 16 00 	mov	22(r1),	r13	;0x00016
    4e44:	1d 81 0a 00 	sub	10(r1),	r13	;0x0000a
    4e48:	0f 4d       	mov	r13,	r15	;
    4e4a:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4e4e:	0d ef       	xor	r15,	r13	;
    4e50:	0e 4d       	mov	r13,	r14	;
    4e52:	0e 8f       	sub	r15,	r14	;
    4e54:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4e58:	0f 7f       	subc	r15,	r15	;
    4e5a:	3f e3       	inv	r15		;
    4e5c:	09 4a       	mov	r10,	r9	;
    4e5e:	09 5e       	add	r14,	r9	;
    4e60:	08 4b       	mov	r11,	r8	;
    4e62:	08 6f       	addc	r15,	r8	;
    4e64:	1d 41 06 00 	mov	6(r1),	r13	;
    4e68:	0d 85       	sub	r5,	r13	;
    4e6a:	0e 4d       	mov	r13,	r14	;
    4e6c:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    4e70:	0d ee       	xor	r14,	r13	;
    4e72:	0a 4d       	mov	r13,	r10	;
    4e74:	0a 8e       	sub	r14,	r10	;
    4e76:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4e7a:	0b 7b       	subc	r11,	r11	;
    4e7c:	3b e3       	inv	r11		;
    4e7e:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    4e82:	0d 85       	sub	r5,	r13	;
    4e84:	0f 4d       	mov	r13,	r15	;
    4e86:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4e8a:	0d ef       	xor	r15,	r13	;
    4e8c:	0e 4d       	mov	r13,	r14	;
    4e8e:	0e 8f       	sub	r15,	r14	;
    4e90:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4e94:	0f 7f       	subc	r15,	r15	;
    4e96:	3f e3       	inv	r15		;
    4e98:	07 4a       	mov	r10,	r7	;
    4e9a:	07 5e       	add	r14,	r7	;
    4e9c:	0d 4b       	mov	r11,	r13	;
    4e9e:	0d 6f       	addc	r15,	r13	;
    4ea0:	1e 41 22 00 	mov	34(r1),	r14	;0x00022
    4ea4:	1e 81 02 00 	sub	2(r1),	r14	;
    4ea8:	0f 4e       	mov	r14,	r15	;
    4eaa:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4eae:	0e ef       	xor	r15,	r14	;
    4eb0:	0a 4e       	mov	r14,	r10	;
    4eb2:	0a 8f       	sub	r15,	r10	;
    4eb4:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    4eb8:	0b 7b       	subc	r11,	r11	;
    4eba:	3b e3       	inv	r11		;
    4ebc:	1e 41 24 00 	mov	36(r1),	r14	;0x00024
    4ec0:	1e 81 0a 00 	sub	10(r1),	r14	;0x0000a
    4ec4:	0f 4e       	mov	r14,	r15	;
    4ec6:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4eca:	0e ef       	xor	r15,	r14	;
    4ecc:	0e 8f       	sub	r15,	r14	;
    4ece:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4ed2:	0f 7f       	subc	r15,	r15	;
    4ed4:	3f e3       	inv	r15		;
    4ed6:	09 5e       	add	r14,	r9	;
    4ed8:	08 6f       	addc	r15,	r8	;
    4eda:	1e 41 26 00 	mov	38(r1),	r14	;0x00026
    4ede:	0e 85       	sub	r5,	r14	;
    4ee0:	0f 4e       	mov	r14,	r15	;
    4ee2:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    4ee6:	0e ef       	xor	r15,	r14	;
    4ee8:	0e 8f       	sub	r15,	r14	;
    4eea:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    4eee:	0f 7f       	subc	r15,	r15	;
    4ef0:	3f e3       	inv	r15		;
    4ef2:	07 5e       	add	r14,	r7	;
    4ef4:	06 4f       	mov	r15,	r6	;
    4ef6:	06 6d       	addc	r13,	r6	;
    4ef8:	7e 40 03 00 	mov.b	#3,	r14	;
    4efc:	4f 43       	clr.b	r15		;
    4efe:	0c 5a       	add	r10,	r12	;
    4f00:	1d 41 14 00 	mov	20(r1),	r13	;0x00014
    4f04:	0d 6b       	addc	r11,	r13	;
    4f06:	b0 12 ae 5f 	call	#24494		;#0x5fae
    4f0a:	0a 4c       	mov	r12,	r10	;
    4f0c:	7e 40 03 00 	mov.b	#3,	r14	;
    4f10:	4f 43       	clr.b	r15		;
    4f12:	0c 49       	mov	r9,	r12	;
    4f14:	0d 48       	mov	r8,	r13	;
    4f16:	b0 12 ae 5f 	call	#24494		;#0x5fae
    4f1a:	09 4c       	mov	r12,	r9	;
    4f1c:	7e 40 03 00 	mov.b	#3,	r14	;
    4f20:	4f 43       	clr.b	r15		;
    4f22:	0c 47       	mov	r7,	r12	;
    4f24:	0d 46       	mov	r6,	r13	;
    4f26:	b0 12 ae 5f 	call	#24494		;#0x5fae
    4f2a:	08 4c       	mov	r12,	r8	;
    4f2c:	0c 4a       	mov	r10,	r12	;
    4f2e:	0d 4a       	mov	r10,	r13	;
    4f30:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    4f34:	0a 4c       	mov	r12,	r10	;
    4f36:	0c 49       	mov	r9,	r12	;
    4f38:	0d 49       	mov	r9,	r13	;
    4f3a:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    4f3e:	0a 5c       	add	r12,	r10	;
    4f40:	0c 48       	mov	r8,	r12	;
    4f42:	0d 48       	mov	r8,	r13	;
    4f44:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    4f48:	0a 5c       	add	r12,	r10	;
    4f4a:	1c 41 02 00 	mov	2(r1),	r12	;
    4f4e:	0d 4c       	mov	r12,	r13	;
    4f50:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    4f54:	07 4c       	mov	r12,	r7	;
    4f56:	1c 41 0a 00 	mov	10(r1),	r12	;0x0000a
    4f5a:	0d 4c       	mov	r12,	r13	;
    4f5c:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    4f60:	07 5c       	add	r12,	r7	;
    4f62:	0c 45       	mov	r5,	r12	;
    4f64:	0d 45       	mov	r5,	r13	;
    4f66:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    4f6a:	07 5c       	add	r12,	r7	;
    4f6c:	08 47       	mov	r7,	r8	;
    4f6e:	09 43       	clr	r9		;
    4f70:	76 40 80 00 	mov.b	#128,	r6	;#0x0080
    4f74:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    4f78:	0c 97       	cmp	r7,	r12	;
    4f7a:	01 28       	jnc	$+4      	;abs 0x4f7e
    4f7c:	06 44       	mov	r4,	r6	;
    4f7e:	05 46       	mov	r6,	r5	;
    4f80:	35 d0 40 00 	bis	#64,	r5	;#0x0040
    4f84:	0c 45       	mov	r5,	r12	;
    4f86:	0d 44       	mov	r4,	r13	;
    4f88:	0e 45       	mov	r5,	r14	;
    4f8a:	0f 44       	mov	r4,	r15	;
    4f8c:	b0 12 0a 60 	call	#24586		;#0x600a
    4f90:	0d 93       	cmp	#0,	r13	;r3 As==00
    4f92:	04 20       	jnz	$+10     	;abs 0x4f9c
    4f94:	09 93       	cmp	#0,	r9	;r3 As==00
    4f96:	05 20       	jnz	$+12     	;abs 0x4fa2
    4f98:	07 9c       	cmp	r12,	r7	;
    4f9a:	03 2c       	jc	$+8      	;abs 0x4fa2
    4f9c:	05 46       	mov	r6,	r5	;
    4f9e:	35 f0 bf ff 	and	#-65,	r5	;#0xffbf
    4fa2:	06 45       	mov	r5,	r6	;
    4fa4:	36 d0 20 00 	bis	#32,	r6	;#0x0020
    4fa8:	0c 46       	mov	r6,	r12	;
    4faa:	0d 44       	mov	r4,	r13	;
    4fac:	0e 46       	mov	r6,	r14	;
    4fae:	0f 44       	mov	r4,	r15	;
    4fb0:	b0 12 0a 60 	call	#24586		;#0x600a
    4fb4:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fb6:	04 20       	jnz	$+10     	;abs 0x4fc0
    4fb8:	09 93       	cmp	#0,	r9	;r3 As==00
    4fba:	05 20       	jnz	$+12     	;abs 0x4fc6
    4fbc:	07 9c       	cmp	r12,	r7	;
    4fbe:	03 2c       	jc	$+8      	;abs 0x4fc6
    4fc0:	06 45       	mov	r5,	r6	;
    4fc2:	36 f0 df ff 	and	#-33,	r6	;#0xffdf
    4fc6:	05 46       	mov	r6,	r5	;
    4fc8:	35 d0 10 00 	bis	#16,	r5	;#0x0010
    4fcc:	0c 45       	mov	r5,	r12	;
    4fce:	0d 44       	mov	r4,	r13	;
    4fd0:	0e 45       	mov	r5,	r14	;
    4fd2:	0f 44       	mov	r4,	r15	;
    4fd4:	b0 12 0a 60 	call	#24586		;#0x600a
    4fd8:	0d 93       	cmp	#0,	r13	;r3 As==00
    4fda:	04 20       	jnz	$+10     	;abs 0x4fe4
    4fdc:	09 93       	cmp	#0,	r9	;r3 As==00
    4fde:	05 20       	jnz	$+12     	;abs 0x4fea
    4fe0:	07 9c       	cmp	r12,	r7	;
    4fe2:	03 2c       	jc	$+8      	;abs 0x4fea
    4fe4:	05 46       	mov	r6,	r5	;
    4fe6:	35 f0 ef ff 	and	#-17,	r5	;#0xffef
    4fea:	06 45       	mov	r5,	r6	;
    4fec:	36 d2       	bis	#8,	r6	;r2 As==11
    4fee:	0c 46       	mov	r6,	r12	;
    4ff0:	0d 44       	mov	r4,	r13	;
    4ff2:	0e 46       	mov	r6,	r14	;
    4ff4:	0f 44       	mov	r4,	r15	;
    4ff6:	b0 12 0a 60 	call	#24586		;#0x600a
    4ffa:	0d 93       	cmp	#0,	r13	;r3 As==00
    4ffc:	02 24       	jz	$+6      	;abs 0x5002
    4ffe:	80 00 e6 5a 	mova	#23270,	r0	;0x05ae6
    5002:	09 93       	cmp	#0,	r9	;r3 As==00
    5004:	04 20       	jnz	$+10     	;abs 0x500e
    5006:	07 9c       	cmp	r12,	r7	;
    5008:	02 2c       	jc	$+6      	;abs 0x500e
    500a:	80 00 e6 5a 	mova	#23270,	r0	;0x05ae6
    500e:	05 46       	mov	r6,	r5	;
    5010:	25 d2       	bis	#4,	r5	;r2 As==10
    5012:	0c 45       	mov	r5,	r12	;
    5014:	0d 44       	mov	r4,	r13	;
    5016:	0e 45       	mov	r5,	r14	;
    5018:	0f 44       	mov	r4,	r15	;
    501a:	b0 12 0a 60 	call	#24586		;#0x600a
    501e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5020:	02 24       	jz	$+6      	;abs 0x5026
    5022:	80 00 de 5a 	mova	#23262,	r0	;0x05ade
    5026:	09 93       	cmp	#0,	r9	;r3 As==00
    5028:	04 20       	jnz	$+10     	;abs 0x5032
    502a:	07 9c       	cmp	r12,	r7	;
    502c:	02 2c       	jc	$+6      	;abs 0x5032
    502e:	80 00 de 5a 	mova	#23262,	r0	;0x05ade
    5032:	06 45       	mov	r5,	r6	;
    5034:	26 d3       	bis	#2,	r6	;r3 As==10
    5036:	0c 46       	mov	r6,	r12	;
    5038:	0d 44       	mov	r4,	r13	;
    503a:	0e 46       	mov	r6,	r14	;
    503c:	0f 44       	mov	r4,	r15	;
    503e:	b0 12 0a 60 	call	#24586		;#0x600a
    5042:	0d 93       	cmp	#0,	r13	;r3 As==00
    5044:	02 24       	jz	$+6      	;abs 0x504a
    5046:	80 00 d6 5a 	mova	#23254,	r0	;0x05ad6
    504a:	09 93       	cmp	#0,	r9	;r3 As==00
    504c:	04 20       	jnz	$+10     	;abs 0x5056
    504e:	07 9c       	cmp	r12,	r7	;
    5050:	02 2c       	jc	$+6      	;abs 0x5056
    5052:	80 00 d6 5a 	mova	#23254,	r0	;0x05ad6
    5056:	05 46       	mov	r6,	r5	;
    5058:	15 d3       	bis	#1,	r5	;r3 As==01
    505a:	0c 45       	mov	r5,	r12	;
    505c:	0d 44       	mov	r4,	r13	;
    505e:	0e 45       	mov	r5,	r14	;
    5060:	0f 44       	mov	r4,	r15	;
    5062:	b0 12 0a 60 	call	#24586		;#0x600a
    5066:	0d 93       	cmp	#0,	r13	;r3 As==00
    5068:	02 24       	jz	$+6      	;abs 0x506e
    506a:	80 00 a0 5a 	mova	#23200,	r0	;0x05aa0
    506e:	09 93       	cmp	#0,	r9	;r3 As==00
    5070:	04 20       	jnz	$+10     	;abs 0x507a
    5072:	07 9c       	cmp	r12,	r7	;
    5074:	02 2c       	jc	$+6      	;abs 0x507a
    5076:	80 00 a0 5a 	mova	#23200,	r0	;0x05aa0
    507a:	81 45 1e 00 	mov	r5,	30(r1)	; 0x001e
    507e:	0d 4a       	mov	r10,	r13	;
    5080:	0e 43       	clr	r14		;
    5082:	81 4d 06 00 	mov	r13,	6(r1)	;
    5086:	81 4e 08 00 	mov	r14,	8(r1)	;
    508a:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    508e:	0e 9a       	cmp	r10,	r14	;
    5090:	02 2c       	jc	$+6      	;abs 0x5096
    5092:	80 00 c0 5a 	mova	#23232,	r0	;0x05ac0
    5096:	39 40 ff 03 	mov	#1023,	r9	;#0x03ff
    509a:	78 40 20 00 	mov.b	#32,	r8	;#0x0020
    509e:	09 9a       	cmp	r10,	r9	;
    50a0:	02 28       	jnc	$+6      	;abs 0x50a6
    50a2:	80 00 ba 5b 	mova	#23482,	r0	;0x05bba
    50a6:	09 44       	mov	r4,	r9	;
    50a8:	38 d0 10 00 	bis	#16,	r8	;#0x0010
    50ac:	0c 48       	mov	r8,	r12	;
    50ae:	0d 49       	mov	r9,	r13	;
    50b0:	0e 48       	mov	r8,	r14	;
    50b2:	0f 49       	mov	r9,	r15	;
    50b4:	b0 12 0a 60 	call	#24586		;#0x600a
    50b8:	0d 93       	cmp	#0,	r13	;r3 As==00
    50ba:	02 24       	jz	$+6      	;abs 0x50c0
    50bc:	80 00 ce 5a 	mova	#23246,	r0	;0x05ace
    50c0:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    50c4:	02 20       	jnz	$+6      	;abs 0x50ca
    50c6:	80 00 66 5e 	mova	#24166,	r0	;0x05e66
    50ca:	06 48       	mov	r8,	r6	;
    50cc:	36 d2       	bis	#8,	r6	;r2 As==11
    50ce:	0c 46       	mov	r6,	r12	;
    50d0:	0d 49       	mov	r9,	r13	;
    50d2:	0e 46       	mov	r6,	r14	;
    50d4:	0f 49       	mov	r9,	r15	;
    50d6:	b0 12 0a 60 	call	#24586		;#0x600a
    50da:	0d 93       	cmp	#0,	r13	;r3 As==00
    50dc:	02 24       	jz	$+6      	;abs 0x50e2
    50de:	80 00 98 5a 	mova	#23192,	r0	;0x05a98
    50e2:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    50e6:	04 20       	jnz	$+10     	;abs 0x50f0
    50e8:	0a 9c       	cmp	r12,	r10	;
    50ea:	02 2c       	jc	$+6      	;abs 0x50f0
    50ec:	80 00 98 5a 	mova	#23192,	r0	;0x05a98
    50f0:	07 46       	mov	r6,	r7	;
    50f2:	27 d2       	bis	#4,	r7	;r2 As==10
    50f4:	0c 47       	mov	r7,	r12	;
    50f6:	0d 49       	mov	r9,	r13	;
    50f8:	0e 47       	mov	r7,	r14	;
    50fa:	0f 49       	mov	r9,	r15	;
    50fc:	b0 12 0a 60 	call	#24586		;#0x600a
    5100:	0d 93       	cmp	#0,	r13	;r3 As==00
    5102:	02 24       	jz	$+6      	;abs 0x5108
    5104:	80 00 74 5a 	mova	#23156,	r0	;0x05a74
    5108:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    510c:	04 20       	jnz	$+10     	;abs 0x5116
    510e:	0a 9c       	cmp	r12,	r10	;
    5110:	02 2c       	jc	$+6      	;abs 0x5116
    5112:	80 00 74 5a 	mova	#23156,	r0	;0x05a74
    5116:	08 47       	mov	r7,	r8	;
    5118:	28 d3       	bis	#2,	r8	;r3 As==10
    511a:	0c 48       	mov	r8,	r12	;
    511c:	0d 49       	mov	r9,	r13	;
    511e:	0e 48       	mov	r8,	r14	;
    5120:	0f 49       	mov	r9,	r15	;
    5122:	b0 12 0a 60 	call	#24586		;#0x600a
    5126:	0d 93       	cmp	#0,	r13	;r3 As==00
    5128:	02 24       	jz	$+6      	;abs 0x512e
    512a:	80 00 90 5a 	mova	#23184,	r0	;0x05a90
    512e:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    5132:	04 20       	jnz	$+10     	;abs 0x513c
    5134:	0a 9c       	cmp	r12,	r10	;
    5136:	02 2c       	jc	$+6      	;abs 0x513c
    5138:	80 00 90 5a 	mova	#23184,	r0	;0x05a90
    513c:	07 48       	mov	r8,	r7	;
    513e:	17 d3       	bis	#1,	r7	;r3 As==01
    5140:	0c 47       	mov	r7,	r12	;
    5142:	0d 49       	mov	r9,	r13	;
    5144:	0e 47       	mov	r7,	r14	;
    5146:	0f 49       	mov	r9,	r15	;
    5148:	b0 12 0a 60 	call	#24586		;#0x600a
    514c:	0d 93       	cmp	#0,	r13	;r3 As==00
    514e:	05 20       	jnz	$+12     	;abs 0x515a
    5150:	81 93 08 00 	cmp	#0,	8(r1)	;r3 As==00
    5154:	04 20       	jnz	$+10     	;abs 0x515e
    5156:	0a 9c       	cmp	r12,	r10	;
    5158:	02 2c       	jc	$+6      	;abs 0x515e
    515a:	07 48       	mov	r8,	r7	;
    515c:	17 c3       	bic	#1,	r7	;r3 As==01
    515e:	81 47 20 00 	mov	r7,	32(r1)	; 0x0020
    5162:	1a 41 0e 00 	mov	14(r1),	r10	;0x0000e
    5166:	9a 41 1e 00 	mov	30(r1),	0(r10)	;0x0001e
    516a:	00 00 
    516c:	9a 41 20 00 	mov	32(r1),	2(r10)	;0x00020
    5170:	02 00 
    5172:	2a 52       	add	#4,	r10	;r2 As==10
    5174:	81 4a 0e 00 	mov	r10,	14(r1)	; 0x000e
    5178:	3c 40 80 1c 	mov	#7296,	r12	;#0x1c80
    517c:	0c 9a       	cmp	r10,	r12	;
    517e:	02 24       	jz	$+6      	;abs 0x5184
    5180:	80 00 c2 4a 	mova	#19138,	r0	;0x04ac2
    5184:	d2 c3 02 02 	bic.b	#1,	&0x0202	;r3 As==01
    5188:	b0 12 cc 40 	call	#16588		;#0x40cc
    518c:	82 43 80 1c 	mov	#0,	&0x1c80	;r3 As==00
    5190:	b0 12 b0 40 	call	#16560		;#0x40b0
    5194:	81 43 2a 00 	mov	#0,	42(r1)	;r3 As==00, 0x002a
    5198:	81 43 2c 00 	mov	#0,	44(r1)	;r3 As==00, 0x002c
    519c:	81 43 2e 00 	mov	#0,	46(r1)	;r3 As==00, 0x002e
    51a0:	91 42 82 1c 	mov	&0x1c82,18(r1)	;0x1c82, 0x0012
    51a4:	12 00 
    51a6:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    51aa:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    51ae:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    51b2:	5c f3       	and.b	#1,	r12	;r3 As==01
    51b4:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    51b8:	5a 03       	rrum	#1,	r10	;
    51ba:	0d 93       	cmp	#0,	r13	;r3 As==00
    51bc:	02 20       	jnz	$+6      	;abs 0x51c2
    51be:	80 00 a8 58 	mova	#22696,	r0	;0x058a8
    51c2:	0c 93       	cmp	#0,	r12	;r3 As==00
    51c4:	02 24       	jz	$+6      	;abs 0x51ca
    51c6:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    51ca:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    51ce:	0c 4a       	mov	r10,	r12	;
    51d0:	b0 12 26 5f 	call	#24358		;#0x5f26
    51d4:	45 4c       	mov.b	r12,	r5	;
    51d6:	75 50 e2 ff 	add.b	#-30,	r5	;#0xffe2
    51da:	85 11       	sxt	r5		;
    51dc:	08 4a       	mov	r10,	r8	;
    51de:	58 03       	rrum	#1,	r8	;
    51e0:	1a b3       	bit	#1,	r10	;r3 As==01
    51e2:	02 24       	jz	$+6      	;abs 0x51e8
    51e4:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    51e8:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    51ec:	0c 48       	mov	r8,	r12	;
    51ee:	b0 12 26 5f 	call	#24358		;#0x5f26
    51f2:	4a 4c       	mov.b	r12,	r10	;
    51f4:	7a 50 e2 ff 	add.b	#-30,	r10	;#0xffe2
    51f8:	8a 11       	sxt	r10		;
    51fa:	09 48       	mov	r8,	r9	;
    51fc:	59 03       	rrum	#1,	r9	;
    51fe:	18 b3       	bit	#1,	r8	;r3 As==01
    5200:	02 24       	jz	$+6      	;abs 0x5206
    5202:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5206:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    520a:	0c 49       	mov	r9,	r12	;
    520c:	b0 12 26 5f 	call	#24358		;#0x5f26
    5210:	44 4c       	mov.b	r12,	r4	;
    5212:	74 50 e2 ff 	add.b	#-30,	r4	;#0xffe2
    5216:	84 11       	sxt	r4		;
    5218:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    521c:	0c 49       	mov	r9,	r12	;
    521e:	5c f3       	and.b	#1,	r12	;r3 As==01
    5220:	59 03       	rrum	#1,	r9	;
    5222:	0d 93       	cmp	#0,	r13	;r3 As==00
    5224:	02 20       	jnz	$+6      	;abs 0x522a
    5226:	80 00 fe 58 	mova	#22782,	r0	;0x058fe
    522a:	0c 93       	cmp	#0,	r12	;r3 As==00
    522c:	02 24       	jz	$+6      	;abs 0x5232
    522e:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5232:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5236:	0c 49       	mov	r9,	r12	;
    5238:	b0 12 26 5f 	call	#24358		;#0x5f26
    523c:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    5240:	8c 11       	sxt	r12		;
    5242:	81 4c 0e 00 	mov	r12,	14(r1)	; 0x000e
    5246:	08 49       	mov	r9,	r8	;
    5248:	58 03       	rrum	#1,	r8	;
    524a:	19 b3       	bit	#1,	r9	;r3 As==01
    524c:	02 24       	jz	$+6      	;abs 0x5252
    524e:	38 e0 00 b4 	xor	#-19456,r8	;#0xb400
    5252:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5256:	0c 48       	mov	r8,	r12	;
    5258:	b0 12 26 5f 	call	#24358		;#0x5f26
    525c:	47 4c       	mov.b	r12,	r7	;
    525e:	77 50 e2 ff 	add.b	#-30,	r7	;#0xffe2
    5262:	87 11       	sxt	r7		;
    5264:	09 48       	mov	r8,	r9	;
    5266:	59 03       	rrum	#1,	r9	;
    5268:	18 b3       	bit	#1,	r8	;r3 As==01
    526a:	02 24       	jz	$+6      	;abs 0x5270
    526c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5270:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5274:	0c 49       	mov	r9,	r12	;
    5276:	b0 12 26 5f 	call	#24358		;#0x5f26
    527a:	48 4c       	mov.b	r12,	r8	;
    527c:	78 50 e2 ff 	add.b	#-30,	r8	;#0xffe2
    5280:	88 11       	sxt	r8		;
    5282:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5286:	0c 49       	mov	r9,	r12	;
    5288:	5c f3       	and.b	#1,	r12	;r3 As==01
    528a:	59 03       	rrum	#1,	r9	;
    528c:	0d 93       	cmp	#0,	r13	;r3 As==00
    528e:	02 20       	jnz	$+6      	;abs 0x5294
    5290:	80 00 58 59 	mova	#22872,	r0	;0x05958
    5294:	0c 93       	cmp	#0,	r12	;r3 As==00
    5296:	02 24       	jz	$+6      	;abs 0x529c
    5298:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    529c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52a0:	0c 49       	mov	r9,	r12	;
    52a2:	b0 12 26 5f 	call	#24358		;#0x5f26
    52a6:	46 4c       	mov.b	r12,	r6	;
    52a8:	76 50 e2 ff 	add.b	#-30,	r6	;#0xffe2
    52ac:	86 11       	sxt	r6		;
    52ae:	0e 49       	mov	r9,	r14	;
    52b0:	5e 03       	rrum	#1,	r14	;
    52b2:	19 b3       	bit	#1,	r9	;r3 As==01
    52b4:	02 24       	jz	$+6      	;abs 0x52ba
    52b6:	3e e0 00 b4 	xor	#-19456,r14	;#0xb400
    52ba:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52be:	0c 4e       	mov	r14,	r12	;
    52c0:	81 4e 00 00 	mov	r14,	0(r1)	;
    52c4:	b0 12 26 5f 	call	#24358		;#0x5f26
    52c8:	49 4c       	mov.b	r12,	r9	;
    52ca:	79 50 e2 ff 	add.b	#-30,	r9	;#0xffe2
    52ce:	89 11       	sxt	r9		;
    52d0:	2e 41       	mov	@r1,	r14	;
    52d2:	0c 4e       	mov	r14,	r12	;
    52d4:	5c 03       	rrum	#1,	r12	;
    52d6:	81 4c 12 00 	mov	r12,	18(r1)	; 0x0012
    52da:	1e b3       	bit	#1,	r14	;r3 As==01
    52dc:	03 24       	jz	$+8      	;abs 0x52e4
    52de:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    52e2:	12 00 
    52e4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    52e8:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    52ec:	b0 12 26 5f 	call	#24358		;#0x5f26
    52f0:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    52f4:	8c 11       	sxt	r12		;
    52f6:	0e 45       	mov	r5,	r14	;
    52f8:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    52fc:	4d 4e       	mov.b	r14,	r13	;
    52fe:	4d e5       	xor.b	r5,	r13	;
    5300:	4d 8e       	sub.b	r14,	r13	;
    5302:	7e 40 09 00 	mov.b	#9,	r14	;
    5306:	4e 9d       	cmp.b	r13,	r14	;
    5308:	02 28       	jnc	$+6      	;abs 0x530e
    530a:	80 00 bc 59 	mova	#22972,	r0	;0x059bc
    530e:	81 45 14 00 	mov	r5,	20(r1)	; 0x0014
    5312:	0d 45       	mov	r5,	r13	;
    5314:	0e 45       	mov	r5,	r14	;
    5316:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    531a:	81 4d 06 00 	mov	r13,	6(r1)	;
    531e:	81 4e 08 00 	mov	r14,	8(r1)	;
    5322:	0e 4a       	mov	r10,	r14	;
    5324:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5328:	4d 4e       	mov.b	r14,	r13	;
    532a:	4d ea       	xor.b	r10,	r13	;
    532c:	4d 8e       	sub.b	r14,	r13	;
    532e:	7e 40 09 00 	mov.b	#9,	r14	;
    5332:	4e 9d       	cmp.b	r13,	r14	;
    5334:	02 28       	jnc	$+6      	;abs 0x533a
    5336:	80 00 e0 59 	mova	#23008,	r0	;0x059e0
    533a:	81 4a 16 00 	mov	r10,	22(r1)	; 0x0016
    533e:	0d 4a       	mov	r10,	r13	;
    5340:	0e 4a       	mov	r10,	r14	;
    5342:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5346:	81 4d 02 00 	mov	r13,	2(r1)	;
    534a:	81 4e 04 00 	mov	r14,	4(r1)	;
    534e:	0e 44       	mov	r4,	r14	;
    5350:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5354:	4d 44       	mov.b	r4,	r13	;
    5356:	4d ee       	xor.b	r14,	r13	;
    5358:	4d 8e       	sub.b	r14,	r13	;
    535a:	7a 40 09 00 	mov.b	#9,	r10	;
    535e:	4a 9d       	cmp.b	r13,	r10	;
    5360:	02 28       	jnc	$+6      	;abs 0x5366
    5362:	80 00 04 5a 	mova	#23044,	r0	;0x05a04
    5366:	0a 44       	mov	r4,	r10	;
    5368:	0b 44       	mov	r4,	r11	;
    536a:	4e 18 0b 11 	rpt #15 { rrax.w	r11		;
    536e:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    5372:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5376:	1d 41 0e 00 	mov	14(r1),	r13	;0x0000e
    537a:	4d ee       	xor.b	r14,	r13	;
    537c:	4d 8e       	sub.b	r14,	r13	;
    537e:	81 43 10 00 	mov	#0,	16(r1)	;r3 As==00, 0x0010
    5382:	7e 40 09 00 	mov.b	#9,	r14	;
    5386:	4e 9d       	cmp.b	r13,	r14	;
    5388:	12 2c       	jc	$+38     	;abs 0x53ae
    538a:	91 41 0e 00 	mov	14(r1),	16(r1)	;0x0000e, 0x0010
    538e:	10 00 
    5390:	1e 41 10 00 	mov	16(r1),	r14	;0x00010
    5394:	0d 4e       	mov	r14,	r13	;
    5396:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    539a:	81 4d 18 00 	mov	r13,	24(r1)	; 0x0018
    539e:	81 4e 1a 00 	mov	r14,	26(r1)	; 0x001a
    53a2:	91 51 18 00 	rla	24(r1)		;#0x00018
    53a6:	06 00 
    53a8:	91 61 1a 00 	rlc	26(r1)		;#0x0001a
    53ac:	08 00 
    53ae:	0e 47       	mov	r7,	r14	;
    53b0:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    53b4:	4d 4e       	mov.b	r14,	r13	;
    53b6:	4d e7       	xor.b	r7,	r13	;
    53b8:	4d 8e       	sub.b	r14,	r13	;
    53ba:	45 43       	clr.b	r5		;
    53bc:	7e 40 09 00 	mov.b	#9,	r14	;
    53c0:	4e 9d       	cmp.b	r13,	r14	;
    53c2:	0f 2c       	jc	$+32     	;abs 0x53e2
    53c4:	05 47       	mov	r7,	r5	;
    53c6:	0d 47       	mov	r7,	r13	;
    53c8:	0e 47       	mov	r7,	r14	;
    53ca:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    53ce:	81 4d 18 00 	mov	r13,	24(r1)	; 0x0018
    53d2:	81 4e 1a 00 	mov	r14,	26(r1)	; 0x001a
    53d6:	91 51 18 00 	rla	24(r1)		;#0x00018
    53da:	02 00 
    53dc:	91 61 1a 00 	rlc	26(r1)		;#0x0001a
    53e0:	04 00 
    53e2:	0e 48       	mov	r8,	r14	;
    53e4:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    53e8:	4d 4e       	mov.b	r14,	r13	;
    53ea:	4d e8       	xor.b	r8,	r13	;
    53ec:	4d 8e       	sub.b	r14,	r13	;
    53ee:	81 43 0e 00 	mov	#0,	14(r1)	;r3 As==00, 0x000e
    53f2:	7e 40 09 00 	mov.b	#9,	r14	;
    53f6:	4e 9d       	cmp.b	r13,	r14	;
    53f8:	08 2c       	jc	$+18     	;abs 0x540a
    53fa:	81 48 0e 00 	mov	r8,	14(r1)	; 0x000e
    53fe:	0e 48       	mov	r8,	r14	;
    5400:	0f 48       	mov	r8,	r15	;
    5402:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5406:	0a 5e       	add	r14,	r10	;
    5408:	0b 6f       	addc	r15,	r11	;
    540a:	0e 46       	mov	r6,	r14	;
    540c:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5410:	4d 4e       	mov.b	r14,	r13	;
    5412:	4d e6       	xor.b	r6,	r13	;
    5414:	4d 8e       	sub.b	r14,	r13	;
    5416:	7e 40 09 00 	mov.b	#9,	r14	;
    541a:	4e 9d       	cmp.b	r13,	r14	;
    541c:	02 28       	jnc	$+6      	;abs 0x5422
    541e:	80 00 8c 5b 	mova	#23436,	r0	;0x05b8c
    5422:	81 46 18 00 	mov	r6,	24(r1)	; 0x0018
    5426:	36 b0 00 80 	bit	#-32768,r6	;#0x8000
    542a:	07 77       	subc	r7,	r7	;
    542c:	37 e3       	inv	r7		;
    542e:	0e 49       	mov	r9,	r14	;
    5430:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    5434:	4d 4e       	mov.b	r14,	r13	;
    5436:	4d e9       	xor.b	r9,	r13	;
    5438:	4d 8e       	sub.b	r14,	r13	;
    543a:	7e 40 09 00 	mov.b	#9,	r14	;
    543e:	4e 9d       	cmp.b	r13,	r14	;
    5440:	02 28       	jnc	$+6      	;abs 0x5446
    5442:	80 00 80 5b 	mova	#23424,	r0	;0x05b80
    5446:	81 49 1e 00 	mov	r9,	30(r1)	; 0x001e
    544a:	0e 49       	mov	r9,	r14	;
    544c:	0f 49       	mov	r9,	r15	;
    544e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5452:	09 4c       	mov	r12,	r9	;
    5454:	46 18 09 11 	rpt #7 { rrax.w	r9		;
    5458:	4d 49       	mov.b	r9,	r13	;
    545a:	4d ec       	xor.b	r12,	r13	;
    545c:	4d 89       	sub.b	r9,	r13	;
    545e:	79 40 09 00 	mov.b	#9,	r9	;
    5462:	49 9d       	cmp.b	r13,	r9	;
    5464:	02 28       	jnc	$+6      	;abs 0x546a
    5466:	80 00 74 5b 	mova	#23412,	r0	;0x05b74
    546a:	81 4c 1c 00 	mov	r12,	28(r1)	; 0x001c
    546e:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5472:	0d 7d       	subc	r13,	r13	;
    5474:	3d e3       	inv	r13		;
    5476:	09 4e       	mov	r14,	r9	;
    5478:	19 51 02 00 	add	2(r1),	r9	;
    547c:	18 41 04 00 	mov	4(r1),	r8	;
    5480:	08 6f       	addc	r15,	r8	;
    5482:	0a 5c       	add	r12,	r10	;
    5484:	0b 6d       	addc	r13,	r11	;
    5486:	7e 40 03 00 	mov.b	#3,	r14	;
    548a:	4f 43       	clr.b	r15		;
    548c:	0c 46       	mov	r6,	r12	;
    548e:	1c 51 06 00 	add	6(r1),	r12	;
    5492:	1d 41 08 00 	mov	8(r1),	r13	;
    5496:	0d 67       	addc	r7,	r13	;
    5498:	81 4b 00 00 	mov	r11,	0(r1)	;
    549c:	b0 12 ae 5f 	call	#24494		;#0x5fae
    54a0:	81 4c 06 00 	mov	r12,	6(r1)	;
    54a4:	7e 40 03 00 	mov.b	#3,	r14	;
    54a8:	4f 43       	clr.b	r15		;
    54aa:	0c 49       	mov	r9,	r12	;
    54ac:	0d 48       	mov	r8,	r13	;
    54ae:	b0 12 ae 5f 	call	#24494		;#0x5fae
    54b2:	06 4c       	mov	r12,	r6	;
    54b4:	7e 40 03 00 	mov.b	#3,	r14	;
    54b8:	4f 43       	clr.b	r15		;
    54ba:	0c 4a       	mov	r10,	r12	;
    54bc:	2b 41       	mov	@r1,	r11	;
    54be:	0d 4b       	mov	r11,	r13	;
    54c0:	b0 12 ae 5f 	call	#24494		;#0x5fae
    54c4:	81 4c 02 00 	mov	r12,	2(r1)	;
    54c8:	1c 41 14 00 	mov	20(r1),	r12	;0x00014
    54cc:	1c 81 06 00 	sub	6(r1),	r12	;
    54d0:	0d 4c       	mov	r12,	r13	;
    54d2:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    54d6:	0c ed       	xor	r13,	r12	;
    54d8:	0c 8d       	sub	r13,	r12	;
    54da:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    54de:	0d 7d       	subc	r13,	r13	;
    54e0:	3d e3       	inv	r13		;
    54e2:	1a 41 10 00 	mov	16(r1),	r10	;0x00010
    54e6:	1a 81 06 00 	sub	6(r1),	r10	;
    54ea:	0f 4a       	mov	r10,	r15	;
    54ec:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    54f0:	0a ef       	xor	r15,	r10	;
    54f2:	0e 4a       	mov	r10,	r14	;
    54f4:	0e 8f       	sub	r15,	r14	;
    54f6:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    54fa:	0f 7f       	subc	r15,	r15	;
    54fc:	3f e3       	inv	r15		;
    54fe:	0c 5e       	add	r14,	r12	;
    5500:	0a 4d       	mov	r13,	r10	;
    5502:	0a 6f       	addc	r15,	r10	;
    5504:	81 4a 10 00 	mov	r10,	16(r1)	; 0x0010
    5508:	1a 41 16 00 	mov	22(r1),	r10	;0x00016
    550c:	0a 86       	sub	r6,	r10	;
    550e:	0d 4a       	mov	r10,	r13	;
    5510:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5514:	0a ed       	xor	r13,	r10	;
    5516:	0e 4a       	mov	r10,	r14	;
    5518:	0e 8d       	sub	r13,	r14	;
    551a:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    551e:	0f 7f       	subc	r15,	r15	;
    5520:	3f e3       	inv	r15		;
    5522:	05 86       	sub	r6,	r5	;
    5524:	0d 45       	mov	r5,	r13	;
    5526:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    552a:	05 ed       	xor	r13,	r5	;
    552c:	0a 45       	mov	r5,	r10	;
    552e:	0a 8d       	sub	r13,	r10	;
    5530:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    5534:	0b 7b       	subc	r11,	r11	;
    5536:	3b e3       	inv	r11		;
    5538:	08 4e       	mov	r14,	r8	;
    553a:	08 5a       	add	r10,	r8	;
    553c:	07 4f       	mov	r15,	r7	;
    553e:	07 6b       	addc	r11,	r7	;
    5540:	14 81 02 00 	sub	2(r1),	r4	;
    5544:	0d 44       	mov	r4,	r13	;
    5546:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    554a:	04 ed       	xor	r13,	r4	;
    554c:	0a 44       	mov	r4,	r10	;
    554e:	0a 8d       	sub	r13,	r10	;
    5550:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    5554:	0b 7b       	subc	r11,	r11	;
    5556:	3b e3       	inv	r11		;
    5558:	1e 41 0e 00 	mov	14(r1),	r14	;0x0000e
    555c:	1e 81 02 00 	sub	2(r1),	r14	;
    5560:	0d 4e       	mov	r14,	r13	;
    5562:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5566:	0e ed       	xor	r13,	r14	;
    5568:	0e 8d       	sub	r13,	r14	;
    556a:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    556e:	0f 7f       	subc	r15,	r15	;
    5570:	3f e3       	inv	r15		;
    5572:	09 4a       	mov	r10,	r9	;
    5574:	09 5e       	add	r14,	r9	;
    5576:	0d 4b       	mov	r11,	r13	;
    5578:	0d 6f       	addc	r15,	r13	;
    557a:	1a 41 18 00 	mov	24(r1),	r10	;0x00018
    557e:	1a 81 06 00 	sub	6(r1),	r10	;
    5582:	0e 4a       	mov	r10,	r14	;
    5584:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5588:	0a ee       	xor	r14,	r10	;
    558a:	0a 8e       	sub	r14,	r10	;
    558c:	3a b0 00 80 	bit	#-32768,r10	;#0x8000
    5590:	0b 7b       	subc	r11,	r11	;
    5592:	3b e3       	inv	r11		;
    5594:	1e 41 1e 00 	mov	30(r1),	r14	;0x0001e
    5598:	0e 86       	sub	r6,	r14	;
    559a:	0f 4e       	mov	r14,	r15	;
    559c:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    55a0:	0e ef       	xor	r15,	r14	;
    55a2:	0e 8f       	sub	r15,	r14	;
    55a4:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    55a8:	0f 7f       	subc	r15,	r15	;
    55aa:	3f e3       	inv	r15		;
    55ac:	08 5e       	add	r14,	r8	;
    55ae:	07 6f       	addc	r15,	r7	;
    55b0:	1e 41 1c 00 	mov	28(r1),	r14	;0x0001c
    55b4:	1e 81 02 00 	sub	2(r1),	r14	;
    55b8:	0f 4e       	mov	r14,	r15	;
    55ba:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    55be:	0e ef       	xor	r15,	r14	;
    55c0:	0e 8f       	sub	r15,	r14	;
    55c2:	3e b0 00 80 	bit	#-32768,r14	;#0x8000
    55c6:	0f 7f       	subc	r15,	r15	;
    55c8:	3f e3       	inv	r15		;
    55ca:	09 5e       	add	r14,	r9	;
    55cc:	05 4f       	mov	r15,	r5	;
    55ce:	05 6d       	addc	r13,	r5	;
    55d0:	7e 40 03 00 	mov.b	#3,	r14	;
    55d4:	4f 43       	clr.b	r15		;
    55d6:	0c 5a       	add	r10,	r12	;
    55d8:	1d 41 10 00 	mov	16(r1),	r13	;0x00010
    55dc:	0d 6b       	addc	r11,	r13	;
    55de:	b0 12 ae 5f 	call	#24494		;#0x5fae
    55e2:	0a 4c       	mov	r12,	r10	;
    55e4:	7e 40 03 00 	mov.b	#3,	r14	;
    55e8:	4f 43       	clr.b	r15		;
    55ea:	0c 48       	mov	r8,	r12	;
    55ec:	0d 47       	mov	r7,	r13	;
    55ee:	b0 12 ae 5f 	call	#24494		;#0x5fae
    55f2:	08 4c       	mov	r12,	r8	;
    55f4:	7e 40 03 00 	mov.b	#3,	r14	;
    55f8:	4f 43       	clr.b	r15		;
    55fa:	0c 49       	mov	r9,	r12	;
    55fc:	0d 45       	mov	r5,	r13	;
    55fe:	b0 12 ae 5f 	call	#24494		;#0x5fae
    5602:	09 4c       	mov	r12,	r9	;
    5604:	0c 4a       	mov	r10,	r12	;
    5606:	0d 4a       	mov	r10,	r13	;
    5608:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    560c:	0a 4c       	mov	r12,	r10	;
    560e:	0c 48       	mov	r8,	r12	;
    5610:	0d 48       	mov	r8,	r13	;
    5612:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    5616:	0a 5c       	add	r12,	r10	;
    5618:	0c 49       	mov	r9,	r12	;
    561a:	0d 49       	mov	r9,	r13	;
    561c:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    5620:	0a 5c       	add	r12,	r10	;
    5622:	1c 41 06 00 	mov	6(r1),	r12	;
    5626:	0d 4c       	mov	r12,	r13	;
    5628:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    562c:	09 4c       	mov	r12,	r9	;
    562e:	0c 46       	mov	r6,	r12	;
    5630:	0d 46       	mov	r6,	r13	;
    5632:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    5636:	06 49       	mov	r9,	r6	;
    5638:	06 5c       	add	r12,	r6	;
    563a:	1c 41 02 00 	mov	2(r1),	r12	;
    563e:	0d 4c       	mov	r12,	r13	;
    5640:	b0 12 f6 5f 	call	#24566		;#0x5ff6
    5644:	06 5c       	add	r12,	r6	;
    5646:	08 46       	mov	r6,	r8	;
    5648:	09 43       	clr	r9		;
    564a:	75 40 80 00 	mov.b	#128,	r5	;#0x0080
    564e:	3c 40 ff 3f 	mov	#16383,	r12	;#0x3fff
    5652:	0c 96       	cmp	r6,	r12	;
    5654:	01 28       	jnc	$+4      	;abs 0x5658
    5656:	45 43       	clr.b	r5		;
    5658:	07 45       	mov	r5,	r7	;
    565a:	37 d0 40 00 	bis	#64,	r7	;#0x0040
    565e:	0c 47       	mov	r7,	r12	;
    5660:	4d 43       	clr.b	r13		;
    5662:	0e 47       	mov	r7,	r14	;
    5664:	4f 43       	clr.b	r15		;
    5666:	b0 12 0a 60 	call	#24586		;#0x600a
    566a:	0d 93       	cmp	#0,	r13	;r3 As==00
    566c:	04 20       	jnz	$+10     	;abs 0x5676
    566e:	09 93       	cmp	#0,	r9	;r3 As==00
    5670:	05 20       	jnz	$+12     	;abs 0x567c
    5672:	06 9c       	cmp	r12,	r6	;
    5674:	03 2c       	jc	$+8      	;abs 0x567c
    5676:	07 45       	mov	r5,	r7	;
    5678:	37 f0 bf ff 	and	#-65,	r7	;#0xffbf
    567c:	05 47       	mov	r7,	r5	;
    567e:	35 d0 20 00 	bis	#32,	r5	;#0x0020
    5682:	0c 45       	mov	r5,	r12	;
    5684:	4d 43       	clr.b	r13		;
    5686:	0e 45       	mov	r5,	r14	;
    5688:	4f 43       	clr.b	r15		;
    568a:	b0 12 0a 60 	call	#24586		;#0x600a
    568e:	0d 93       	cmp	#0,	r13	;r3 As==00
    5690:	04 20       	jnz	$+10     	;abs 0x569a
    5692:	09 93       	cmp	#0,	r9	;r3 As==00
    5694:	05 20       	jnz	$+12     	;abs 0x56a0
    5696:	06 9c       	cmp	r12,	r6	;
    5698:	03 2c       	jc	$+8      	;abs 0x56a0
    569a:	05 47       	mov	r7,	r5	;
    569c:	35 f0 df ff 	and	#-33,	r5	;#0xffdf
    56a0:	07 45       	mov	r5,	r7	;
    56a2:	37 d0 10 00 	bis	#16,	r7	;#0x0010
    56a6:	0c 47       	mov	r7,	r12	;
    56a8:	4d 43       	clr.b	r13		;
    56aa:	0e 47       	mov	r7,	r14	;
    56ac:	4f 43       	clr.b	r15		;
    56ae:	b0 12 0a 60 	call	#24586		;#0x600a
    56b2:	0d 93       	cmp	#0,	r13	;r3 As==00
    56b4:	04 20       	jnz	$+10     	;abs 0x56be
    56b6:	09 93       	cmp	#0,	r9	;r3 As==00
    56b8:	05 20       	jnz	$+12     	;abs 0x56c4
    56ba:	06 9c       	cmp	r12,	r6	;
    56bc:	03 2c       	jc	$+8      	;abs 0x56c4
    56be:	07 45       	mov	r5,	r7	;
    56c0:	37 f0 ef ff 	and	#-17,	r7	;#0xffef
    56c4:	05 47       	mov	r7,	r5	;
    56c6:	35 d2       	bis	#8,	r5	;r2 As==11
    56c8:	0c 45       	mov	r5,	r12	;
    56ca:	4d 43       	clr.b	r13		;
    56cc:	0e 45       	mov	r5,	r14	;
    56ce:	4f 43       	clr.b	r15		;
    56d0:	b0 12 0a 60 	call	#24586		;#0x600a
    56d4:	0d 93       	cmp	#0,	r13	;r3 As==00
    56d6:	02 24       	jz	$+6      	;abs 0x56dc
    56d8:	80 00 3a 5b 	mova	#23354,	r0	;0x05b3a
    56dc:	09 93       	cmp	#0,	r9	;r3 As==00
    56de:	04 20       	jnz	$+10     	;abs 0x56e8
    56e0:	06 9c       	cmp	r12,	r6	;
    56e2:	02 2c       	jc	$+6      	;abs 0x56e8
    56e4:	80 00 3a 5b 	mova	#23354,	r0	;0x05b3a
    56e8:	07 45       	mov	r5,	r7	;
    56ea:	27 d2       	bis	#4,	r7	;r2 As==10
    56ec:	0c 47       	mov	r7,	r12	;
    56ee:	4d 43       	clr.b	r13		;
    56f0:	0e 47       	mov	r7,	r14	;
    56f2:	4f 43       	clr.b	r15		;
    56f4:	b0 12 0a 60 	call	#24586		;#0x600a
    56f8:	0d 93       	cmp	#0,	r13	;r3 As==00
    56fa:	02 24       	jz	$+6      	;abs 0x5700
    56fc:	80 00 32 5b 	mova	#23346,	r0	;0x05b32
    5700:	09 93       	cmp	#0,	r9	;r3 As==00
    5702:	04 20       	jnz	$+10     	;abs 0x570c
    5704:	06 9c       	cmp	r12,	r6	;
    5706:	02 2c       	jc	$+6      	;abs 0x570c
    5708:	80 00 32 5b 	mova	#23346,	r0	;0x05b32
    570c:	05 47       	mov	r7,	r5	;
    570e:	25 d3       	bis	#2,	r5	;r3 As==10
    5710:	0c 45       	mov	r5,	r12	;
    5712:	4d 43       	clr.b	r13		;
    5714:	0e 45       	mov	r5,	r14	;
    5716:	4f 43       	clr.b	r15		;
    5718:	b0 12 0a 60 	call	#24586		;#0x600a
    571c:	0d 93       	cmp	#0,	r13	;r3 As==00
    571e:	02 24       	jz	$+6      	;abs 0x5724
    5720:	80 00 2a 5b 	mova	#23338,	r0	;0x05b2a
    5724:	09 93       	cmp	#0,	r9	;r3 As==00
    5726:	02 20       	jnz	$+6      	;abs 0x572c
    5728:	06 9c       	cmp	r12,	r6	;
    572a:	ff 29       	jnc	$+1024   	;abs 0x5b2a
    572c:	07 45       	mov	r5,	r7	;
    572e:	17 d3       	bis	#1,	r7	;r3 As==01
    5730:	0c 47       	mov	r7,	r12	;
    5732:	4d 43       	clr.b	r13		;
    5734:	0e 47       	mov	r7,	r14	;
    5736:	4f 43       	clr.b	r15		;
    5738:	b0 12 0a 60 	call	#24586		;#0x600a
    573c:	0d 93       	cmp	#0,	r13	;r3 As==00
    573e:	e3 21       	jnz	$+968    	;abs 0x5b06
    5740:	09 93       	cmp	#0,	r9	;r3 As==00
    5742:	02 20       	jnz	$+6      	;abs 0x5748
    5744:	06 9c       	cmp	r12,	r6	;
    5746:	df 29       	jnc	$+960    	;abs 0x5b06
    5748:	08 4a       	mov	r10,	r8	;
    574a:	09 43       	clr	r9		;
    574c:	3d 40 ff 0f 	mov	#4095,	r13	;#0x0fff
    5750:	0d 9a       	cmp	r10,	r13	;
    5752:	e1 29       	jnc	$+964    	;abs 0x5b16
    5754:	3e 40 ff 03 	mov	#1023,	r14	;#0x03ff
    5758:	76 40 20 00 	mov.b	#32,	r6	;#0x0020
    575c:	0e 9a       	cmp	r10,	r14	;
    575e:	02 28       	jnc	$+6      	;abs 0x5764
    5760:	80 00 9c 5b 	mova	#23452,	r0	;0x05b9c
    5764:	45 43       	clr.b	r5		;
    5766:	36 d0 10 00 	bis	#16,	r6	;#0x0010
    576a:	0c 46       	mov	r6,	r12	;
    576c:	0d 45       	mov	r5,	r13	;
    576e:	0e 46       	mov	r6,	r14	;
    5770:	0f 45       	mov	r5,	r15	;
    5772:	b0 12 0a 60 	call	#24586		;#0x600a
    5776:	0d 93       	cmp	#0,	r13	;r3 As==00
    5778:	d5 21       	jnz	$+940    	;abs 0x5b24
    577a:	09 93       	cmp	#0,	r9	;r3 As==00
    577c:	02 20       	jnz	$+6      	;abs 0x5782
    577e:	80 00 a6 5b 	mova	#23462,	r0	;0x05ba6
    5782:	04 46       	mov	r6,	r4	;
    5784:	34 d2       	bis	#8,	r4	;r2 As==11
    5786:	0c 44       	mov	r4,	r12	;
    5788:	0d 45       	mov	r5,	r13	;
    578a:	0e 44       	mov	r4,	r14	;
    578c:	0f 45       	mov	r5,	r15	;
    578e:	b0 12 0a 60 	call	#24586		;#0x600a
    5792:	0d 93       	cmp	#0,	r13	;r3 As==00
    5794:	b5 21       	jnz	$+876    	;abs 0x5b00
    5796:	09 93       	cmp	#0,	r9	;r3 As==00
    5798:	02 20       	jnz	$+6      	;abs 0x579e
    579a:	0a 9c       	cmp	r12,	r10	;
    579c:	b1 29       	jnc	$+868    	;abs 0x5b00
    579e:	06 44       	mov	r4,	r6	;
    57a0:	26 d2       	bis	#4,	r6	;r2 As==10
    57a2:	0c 46       	mov	r6,	r12	;
    57a4:	0d 45       	mov	r5,	r13	;
    57a6:	0e 46       	mov	r6,	r14	;
    57a8:	0f 45       	mov	r5,	r15	;
    57aa:	b0 12 0a 60 	call	#24586		;#0x600a
    57ae:	0d 93       	cmp	#0,	r13	;r3 As==00
    57b0:	a4 21       	jnz	$+842    	;abs 0x5afa
    57b2:	09 93       	cmp	#0,	r9	;r3 As==00
    57b4:	02 20       	jnz	$+6      	;abs 0x57ba
    57b6:	0a 9c       	cmp	r12,	r10	;
    57b8:	a0 29       	jnc	$+834    	;abs 0x5afa
    57ba:	04 46       	mov	r6,	r4	;
    57bc:	24 d3       	bis	#2,	r4	;r3 As==10
    57be:	0c 44       	mov	r4,	r12	;
    57c0:	0d 45       	mov	r5,	r13	;
    57c2:	0e 44       	mov	r4,	r14	;
    57c4:	0f 45       	mov	r5,	r15	;
    57c6:	b0 12 0a 60 	call	#24586		;#0x600a
    57ca:	0d 93       	cmp	#0,	r13	;r3 As==00
    57cc:	93 21       	jnz	$+808    	;abs 0x5af4
    57ce:	09 93       	cmp	#0,	r9	;r3 As==00
    57d0:	02 20       	jnz	$+6      	;abs 0x57d6
    57d2:	0a 9c       	cmp	r12,	r10	;
    57d4:	8f 29       	jnc	$+800    	;abs 0x5af4
    57d6:	06 44       	mov	r4,	r6	;
    57d8:	16 d3       	bis	#1,	r6	;r3 As==01
    57da:	0c 46       	mov	r6,	r12	;
    57dc:	0d 45       	mov	r5,	r13	;
    57de:	0e 46       	mov	r6,	r14	;
    57e0:	0f 45       	mov	r5,	r15	;
    57e2:	b0 12 0a 60 	call	#24586		;#0x600a
    57e6:	0d 93       	cmp	#0,	r13	;r3 As==00
    57e8:	82 21       	jnz	$+774    	;abs 0x5aee
    57ea:	09 93       	cmp	#0,	r9	;r3 As==00
    57ec:	02 20       	jnz	$+6      	;abs 0x57f2
    57ee:	0a 9c       	cmp	r12,	r10	;
    57f0:	7e 29       	jnc	$+766    	;abs 0x5aee
    57f2:	45 43       	clr.b	r5		;
    57f4:	48 43       	clr.b	r8		;
    57f6:	4a 43       	clr.b	r10		;
    57f8:	0d 4a       	mov	r10,	r13	;
    57fa:	5d 06       	rlam	#2,	r13	;
    57fc:	1f 4d 00 1c 	mov	7168(r13),r15	;0x01c00
    5800:	1c 4d 02 1c 	mov	7170(r13),r12	;0x01c02
    5804:	3d 50 00 1c 	add	#7168,	r13	;#0x1c00
    5808:	0c 86       	sub	r6,	r12	;
    580a:	0e 4c       	mov	r12,	r14	;
    580c:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5810:	0c ee       	xor	r14,	r12	;
    5812:	0c 8e       	sub	r14,	r12	;
    5814:	0e 4a       	mov	r10,	r14	;
    5816:	5e 06       	rlam	#2,	r14	;
    5818:	1e 4e 40 1c 	mov	7232(r14),r14	;0x01c40
    581c:	1d 4d 42 00 	mov	66(r13),r13	;0x00042
    5820:	0d 86       	sub	r6,	r13	;
    5822:	09 4d       	mov	r13,	r9	;
    5824:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    5828:	0d e9       	xor	r9,	r13	;
    582a:	0d 89       	sub	r9,	r13	;
    582c:	0f 87       	sub	r7,	r15	;
    582e:	09 4f       	mov	r15,	r9	;
    5830:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    5834:	0f e9       	xor	r9,	r15	;
    5836:	0f 89       	sub	r9,	r15	;
    5838:	0e 87       	sub	r7,	r14	;
    583a:	09 4e       	mov	r14,	r9	;
    583c:	4e 18 09 11 	rpt #15 { rrax.w	r9		;
    5840:	0e e9       	xor	r9,	r14	;
    5842:	0e 89       	sub	r9,	r14	;
    5844:	0e 9f       	cmp	r15,	r14	;
    5846:	7d 35       	jge	$+764    	;abs 0x5b42
    5848:	18 53       	inc	r8		;
    584a:	0d 9c       	cmp	r12,	r13	;
    584c:	7d 35       	jge	$+764    	;abs 0x5b48
    584e:	18 53       	inc	r8		;
    5850:	1a 53       	inc	r10		;
    5852:	3a 90 10 00 	cmp	#16,	r10	;#0x0010
    5856:	d0 23       	jnz	$-94     	;abs 0x57f8
    5858:	91 53 2a 00 	inc	42(r1)		;
    585c:	05 98       	cmp	r8,	r5	;
    585e:	76 35       	jge	$+750    	;abs 0x5b4c
    5860:	91 53 2c 00 	inc	44(r1)		;
    5864:	91 53 0a 00 	inc	10(r1)		;
    5868:	b1 90 40 00 	cmp	#64,	10(r1)	;#0x0040, 0x000a
    586c:	0a 00 
    586e:	76 25       	jz	$+750    	;abs 0x5b5c
    5870:	b1 90 20 00 	cmp	#32,	10(r1)	;#0x0020, 0x000a
    5874:	0a 00 
    5876:	02 24       	jz	$+6      	;abs 0x587c
    5878:	80 00 aa 51 	mova	#20906,	r0	;0x051aa
    587c:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5880:	1c 42 80 1c 	mov	&0x1c80,r12	;0x1c80
    5884:	3c 53       	add	#-1,	r12	;r3 As==11
    5886:	0c cd       	bic	r13,	r12	;
    5888:	4e 19 0c 10 	rpt #15 { rrux.w	r12		;
    588c:	82 4c 80 1c 	mov	r12,	&0x1c80	;
    5890:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    5894:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5898:	5c f3       	and.b	#1,	r12	;r3 As==01
    589a:	1a 41 12 00 	mov	18(r1),	r10	;0x00012
    589e:	5a 03       	rrum	#1,	r10	;
    58a0:	0d 93       	cmp	#0,	r13	;r3 As==00
    58a2:	02 24       	jz	$+6      	;abs 0x58a8
    58a4:	80 00 c2 51 	mova	#20930,	r0	;0x051c2
    58a8:	0c 93       	cmp	#0,	r12	;r3 As==00
    58aa:	02 24       	jz	$+6      	;abs 0x58b0
    58ac:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    58b0:	45 4a       	mov.b	r10,	r5	;
    58b2:	75 f0 03 00 	and.b	#3,	r5	;
    58b6:	75 50 fe ff 	add.b	#-2,	r5	;#0xfffe
    58ba:	85 11       	sxt	r5		;
    58bc:	0d 4a       	mov	r10,	r13	;
    58be:	5d 03       	rrum	#1,	r13	;
    58c0:	1a b3       	bit	#1,	r10	;r3 As==01
    58c2:	02 24       	jz	$+6      	;abs 0x58c8
    58c4:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    58c8:	4a 4d       	mov.b	r13,	r10	;
    58ca:	7a f0 03 00 	and.b	#3,	r10	;
    58ce:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    58d2:	8a 11       	sxt	r10		;
    58d4:	09 4d       	mov	r13,	r9	;
    58d6:	59 03       	rrum	#1,	r9	;
    58d8:	1d b3       	bit	#1,	r13	;r3 As==01
    58da:	02 24       	jz	$+6      	;abs 0x58e0
    58dc:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    58e0:	44 49       	mov.b	r9,	r4	;
    58e2:	74 f0 03 00 	and.b	#3,	r4	;
    58e6:	74 50 fe ff 	add.b	#-2,	r4	;#0xfffe
    58ea:	84 11       	sxt	r4		;
    58ec:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    58f0:	0c 49       	mov	r9,	r12	;
    58f2:	5c f3       	and.b	#1,	r12	;r3 As==01
    58f4:	59 03       	rrum	#1,	r9	;
    58f6:	0d 93       	cmp	#0,	r13	;r3 As==00
    58f8:	02 24       	jz	$+6      	;abs 0x58fe
    58fa:	80 00 2a 52 	mova	#21034,	r0	;0x0522a
    58fe:	0c 93       	cmp	#0,	r12	;r3 As==00
    5900:	02 24       	jz	$+6      	;abs 0x5906
    5902:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5906:	4c 49       	mov.b	r9,	r12	;
    5908:	7c f0 03 00 	and.b	#3,	r12	;
    590c:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5910:	8c 11       	sxt	r12		;
    5912:	81 4c 0e 00 	mov	r12,	14(r1)	; 0x000e
    5916:	0d 49       	mov	r9,	r13	;
    5918:	5d 03       	rrum	#1,	r13	;
    591a:	19 b3       	bit	#1,	r9	;r3 As==01
    591c:	02 24       	jz	$+6      	;abs 0x5922
    591e:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5922:	47 4d       	mov.b	r13,	r7	;
    5924:	77 f0 03 00 	and.b	#3,	r7	;
    5928:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    592c:	87 11       	sxt	r7		;
    592e:	09 4d       	mov	r13,	r9	;
    5930:	59 03       	rrum	#1,	r9	;
    5932:	1d b3       	bit	#1,	r13	;r3 As==01
    5934:	02 24       	jz	$+6      	;abs 0x593a
    5936:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    593a:	48 49       	mov.b	r9,	r8	;
    593c:	78 f0 03 00 	and.b	#3,	r8	;
    5940:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5944:	88 11       	sxt	r8		;
    5946:	1d 42 80 1c 	mov	&0x1c80,r13	;0x1c80
    594a:	0c 49       	mov	r9,	r12	;
    594c:	5c f3       	and.b	#1,	r12	;r3 As==01
    594e:	59 03       	rrum	#1,	r9	;
    5950:	0d 93       	cmp	#0,	r13	;r3 As==00
    5952:	02 24       	jz	$+6      	;abs 0x5958
    5954:	80 00 94 52 	mova	#21140,	r0	;0x05294
    5958:	0c 93       	cmp	#0,	r12	;r3 As==00
    595a:	02 24       	jz	$+6      	;abs 0x5960
    595c:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5960:	46 49       	mov.b	r9,	r6	;
    5962:	76 f0 03 00 	and.b	#3,	r6	;
    5966:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    596a:	86 11       	sxt	r6		;
    596c:	0d 49       	mov	r9,	r13	;
    596e:	5d 03       	rrum	#1,	r13	;
    5970:	19 b3       	bit	#1,	r9	;r3 As==01
    5972:	02 24       	jz	$+6      	;abs 0x5978
    5974:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5978:	49 4d       	mov.b	r13,	r9	;
    597a:	79 f0 03 00 	and.b	#3,	r9	;
    597e:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5982:	89 11       	sxt	r9		;
    5984:	0e 4d       	mov	r13,	r14	;
    5986:	5e 03       	rrum	#1,	r14	;
    5988:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    598c:	1d b3       	bit	#1,	r13	;r3 As==01
    598e:	03 24       	jz	$+8      	;abs 0x5996
    5990:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    5994:	12 00 
    5996:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    599a:	7c f0 03 00 	and.b	#3,	r12	;
    599e:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    59a2:	8c 11       	sxt	r12		;
    59a4:	0e 45       	mov	r5,	r14	;
    59a6:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    59aa:	4d 4e       	mov.b	r14,	r13	;
    59ac:	4d e5       	xor.b	r5,	r13	;
    59ae:	4d 8e       	sub.b	r14,	r13	;
    59b0:	7e 40 09 00 	mov.b	#9,	r14	;
    59b4:	4e 9d       	cmp.b	r13,	r14	;
    59b6:	02 2c       	jc	$+6      	;abs 0x59bc
    59b8:	80 00 0e 53 	mova	#21262,	r0	;0x0530e
    59bc:	81 43 06 00 	mov	#0,	6(r1)	;r3 As==00
    59c0:	81 43 08 00 	mov	#0,	8(r1)	;r3 As==00
    59c4:	81 43 14 00 	mov	#0,	20(r1)	;r3 As==00, 0x0014
    59c8:	0e 4a       	mov	r10,	r14	;
    59ca:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    59ce:	4d 4e       	mov.b	r14,	r13	;
    59d0:	4d ea       	xor.b	r10,	r13	;
    59d2:	4d 8e       	sub.b	r14,	r13	;
    59d4:	7e 40 09 00 	mov.b	#9,	r14	;
    59d8:	4e 9d       	cmp.b	r13,	r14	;
    59da:	02 2c       	jc	$+6      	;abs 0x59e0
    59dc:	80 00 3a 53 	mova	#21306,	r0	;0x0533a
    59e0:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    59e4:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    59e8:	81 43 16 00 	mov	#0,	22(r1)	;r3 As==00, 0x0016
    59ec:	0e 44       	mov	r4,	r14	;
    59ee:	46 18 0e 11 	rpt #7 { rrax.w	r14		;
    59f2:	4d 44       	mov.b	r4,	r13	;
    59f4:	4d ee       	xor.b	r14,	r13	;
    59f6:	4d 8e       	sub.b	r14,	r13	;
    59f8:	7a 40 09 00 	mov.b	#9,	r10	;
    59fc:	4a 9d       	cmp.b	r13,	r10	;
    59fe:	02 2c       	jc	$+6      	;abs 0x5a04
    5a00:	80 00 66 53 	mova	#21350,	r0	;0x05366
    5a04:	4a 43       	clr.b	r10		;
    5a06:	4b 43       	clr.b	r11		;
    5a08:	44 43       	clr.b	r4		;
    5a0a:	30 40 6e 53 	br	#0x536e		;
    5a0e:	08 47       	mov	r7,	r8	;
    5a10:	28 c3       	bic	#2,	r8	;r3 As==10
    5a12:	30 40 d4 49 	br	#0x49d4		;
    5a16:	07 46       	mov	r6,	r7	;
    5a18:	27 c2       	bic	#4,	r7	;r2 As==10
    5a1a:	30 40 ae 49 	br	#0x49ae		;
    5a1e:	06 48       	mov	r8,	r6	;
    5a20:	36 c2       	bic	#8,	r6	;r2 As==11
    5a22:	30 40 88 49 	br	#0x4988		;
    5a26:	05 46       	mov	r6,	r5	;
    5a28:	15 c3       	bic	#1,	r5	;r3 As==01
    5a2a:	81 45 18 00 	mov	r5,	24(r1)	; 0x0018
    5a2e:	0d 4a       	mov	r10,	r13	;
    5a30:	0e 43       	clr	r14		;
    5a32:	81 4d 06 00 	mov	r13,	6(r1)	;
    5a36:	81 4e 08 00 	mov	r14,	8(r1)	;
    5a3a:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    5a3e:	0e 9a       	cmp	r10,	r14	;
    5a40:	02 28       	jnc	$+6      	;abs 0x5a46
    5a42:	80 00 2e 49 	mova	#18734,	r0	;0x0492e
    5a46:	3e 40 ff 23 	mov	#9215,	r14	;#0x23ff
    5a4a:	0e 9a       	cmp	r10,	r14	;
    5a4c:	68 2d       	jc	$+722    	;abs 0x5d1e
    5a4e:	78 40 70 00 	mov.b	#112,	r8	;#0x0070
    5a52:	09 44       	mov	r4,	r9	;
    5a54:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5a58:	30 40 62 49 	br	#0x4962		;
    5a5c:	06 45       	mov	r5,	r6	;
    5a5e:	26 c3       	bic	#2,	r6	;r3 As==10
    5a60:	30 40 ee 48 	br	#0x48ee		;
    5a64:	05 46       	mov	r6,	r5	;
    5a66:	25 c2       	bic	#4,	r5	;r2 As==10
    5a68:	30 40 ca 48 	br	#0x48ca		;
    5a6c:	06 45       	mov	r5,	r6	;
    5a6e:	36 c2       	bic	#8,	r6	;r2 As==11
    5a70:	30 40 a6 48 	br	#0x48a6		;
    5a74:	07 46       	mov	r6,	r7	;
    5a76:	27 c2       	bic	#4,	r7	;r2 As==10
    5a78:	08 47       	mov	r7,	r8	;
    5a7a:	28 d3       	bis	#2,	r8	;r3 As==10
    5a7c:	0c 48       	mov	r8,	r12	;
    5a7e:	0d 49       	mov	r9,	r13	;
    5a80:	0e 48       	mov	r8,	r14	;
    5a82:	0f 49       	mov	r9,	r15	;
    5a84:	b0 12 0a 60 	call	#24586		;#0x600a
    5a88:	0d 93       	cmp	#0,	r13	;r3 As==00
    5a8a:	02 20       	jnz	$+6      	;abs 0x5a90
    5a8c:	80 00 2e 51 	mova	#20782,	r0	;0x0512e
    5a90:	08 47       	mov	r7,	r8	;
    5a92:	28 c3       	bic	#2,	r8	;r3 As==10
    5a94:	30 40 3c 51 	br	#0x513c		;
    5a98:	06 48       	mov	r8,	r6	;
    5a9a:	36 c2       	bic	#8,	r6	;r2 As==11
    5a9c:	30 40 f0 50 	br	#0x50f0		;
    5aa0:	05 46       	mov	r6,	r5	;
    5aa2:	15 c3       	bic	#1,	r5	;r3 As==01
    5aa4:	81 45 1e 00 	mov	r5,	30(r1)	; 0x001e
    5aa8:	0d 4a       	mov	r10,	r13	;
    5aaa:	0e 43       	clr	r14		;
    5aac:	81 4d 06 00 	mov	r13,	6(r1)	;
    5ab0:	81 4e 08 00 	mov	r14,	8(r1)	;
    5ab4:	3e 40 ff 0f 	mov	#4095,	r14	;#0x0fff
    5ab8:	0e 9a       	cmp	r10,	r14	;
    5aba:	02 28       	jnc	$+6      	;abs 0x5ac0
    5abc:	80 00 96 50 	mova	#20630,	r0	;0x05096
    5ac0:	3d 40 ff 23 	mov	#9215,	r13	;#0x23ff
    5ac4:	0d 9a       	cmp	r10,	r13	;
    5ac6:	77 2c       	jc	$+240    	;abs 0x5bb6
    5ac8:	78 40 70 00 	mov.b	#112,	r8	;#0x0070
    5acc:	09 44       	mov	r4,	r9	;
    5ace:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5ad2:	30 40 ca 50 	br	#0x50ca		;
    5ad6:	06 45       	mov	r5,	r6	;
    5ad8:	26 c3       	bic	#2,	r6	;r3 As==10
    5ada:	30 40 56 50 	br	#0x5056		;
    5ade:	05 46       	mov	r6,	r5	;
    5ae0:	25 c2       	bic	#4,	r5	;r2 As==10
    5ae2:	30 40 32 50 	br	#0x5032		;
    5ae6:	06 45       	mov	r5,	r6	;
    5ae8:	36 c2       	bic	#8,	r6	;r2 As==11
    5aea:	30 40 0e 50 	br	#0x500e		;
    5aee:	06 44       	mov	r4,	r6	;
    5af0:	16 c3       	bic	#1,	r6	;r3 As==01
    5af2:	7f 3e       	jmp	$-768    	;abs 0x57f2
    5af4:	04 46       	mov	r6,	r4	;
    5af6:	24 c3       	bic	#2,	r4	;r3 As==10
    5af8:	6e 3e       	jmp	$-802    	;abs 0x57d6
    5afa:	06 44       	mov	r4,	r6	;
    5afc:	26 c2       	bic	#4,	r6	;r2 As==10
    5afe:	5d 3e       	jmp	$-836    	;abs 0x57ba
    5b00:	04 46       	mov	r6,	r4	;
    5b02:	34 c2       	bic	#8,	r4	;r2 As==11
    5b04:	4c 3e       	jmp	$-870    	;abs 0x579e
    5b06:	07 45       	mov	r5,	r7	;
    5b08:	17 c3       	bic	#1,	r7	;r3 As==01
    5b0a:	08 4a       	mov	r10,	r8	;
    5b0c:	09 43       	clr	r9		;
    5b0e:	3d 40 ff 0f 	mov	#4095,	r13	;#0x0fff
    5b12:	0d 9a       	cmp	r10,	r13	;
    5b14:	1f 2e       	jc	$-960    	;abs 0x5754
    5b16:	3c 40 ff 23 	mov	#9215,	r12	;#0x23ff
    5b1a:	0c 9a       	cmp	r10,	r12	;
    5b1c:	3d 2c       	jc	$+124    	;abs 0x5b98
    5b1e:	76 40 70 00 	mov.b	#112,	r6	;#0x0070
    5b22:	45 43       	clr.b	r5		;
    5b24:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    5b28:	2c 3e       	jmp	$-934    	;abs 0x5782
    5b2a:	05 47       	mov	r7,	r5	;
    5b2c:	25 c3       	bic	#2,	r5	;r3 As==10
    5b2e:	30 40 2c 57 	br	#0x572c		;
    5b32:	07 45       	mov	r5,	r7	;
    5b34:	27 c2       	bic	#4,	r7	;r2 As==10
    5b36:	30 40 0c 57 	br	#0x570c		;
    5b3a:	05 47       	mov	r7,	r5	;
    5b3c:	35 c2       	bic	#8,	r5	;r2 As==11
    5b3e:	30 40 e8 56 	br	#0x56e8		;
    5b42:	15 53       	inc	r5		;
    5b44:	0d 9c       	cmp	r12,	r13	;
    5b46:	83 3a       	jl	$-760    	;abs 0x584e
    5b48:	15 53       	inc	r5		;
    5b4a:	82 3e       	jmp	$-762    	;abs 0x5850
    5b4c:	91 53 2e 00 	inc	46(r1)		;
    5b50:	91 53 0a 00 	inc	10(r1)		;
    5b54:	b1 90 40 00 	cmp	#64,	10(r1)	;#0x0040, 0x000a
    5b58:	0a 00 
    5b5a:	8a 22       	jnz	$-746    	;abs 0x5870
    5b5c:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5b60:	82 1c 
    5b62:	b0 12 cc 40 	call	#16588		;#0x40cc
    5b66:	b0 12 04 41 	call	#16644		;#0x4104
    5b6a:	4c 43       	clr.b	r12		;
    5b6c:	31 50 30 00 	add	#48,	r1	;#0x0030
    5b70:	64 17       	popm	#7,	r10	;16-bit words
    5b72:	30 41       	ret			
    5b74:	4c 43       	clr.b	r12		;
    5b76:	4d 43       	clr.b	r13		;
    5b78:	81 43 1c 00 	mov	#0,	28(r1)	;r3 As==00, 0x001c
    5b7c:	30 40 76 54 	br	#0x5476		;
    5b80:	4e 43       	clr.b	r14		;
    5b82:	4f 43       	clr.b	r15		;
    5b84:	81 43 1e 00 	mov	#0,	30(r1)	;r3 As==00, 0x001e
    5b88:	30 40 52 54 	br	#0x5452		;
    5b8c:	46 43       	clr.b	r6		;
    5b8e:	47 43       	clr.b	r7		;
    5b90:	81 43 18 00 	mov	#0,	24(r1)	;r3 As==00, 0x0018
    5b94:	30 40 2e 54 	br	#0x542e		;
    5b98:	76 40 60 00 	mov.b	#96,	r6	;#0x0060
    5b9c:	36 e0 20 00 	xor	#32,	r6	;#0x0020
    5ba0:	45 43       	clr.b	r5		;
    5ba2:	30 40 66 57 	br	#0x5766		;
    5ba6:	0a 9c       	cmp	r12,	r10	;
    5ba8:	02 28       	jnc	$+6      	;abs 0x5bae
    5baa:	80 00 82 57 	mova	#22402,	r0	;0x05782
    5bae:	36 e0 10 00 	xor	#16,	r6	;#0x0010
    5bb2:	30 40 82 57 	br	#0x5782		;
    5bb6:	78 40 60 00 	mov.b	#96,	r8	;#0x0060
    5bba:	38 e0 20 00 	xor	#32,	r8	;#0x0020
    5bbe:	09 44       	mov	r4,	r9	;
    5bc0:	30 40 a8 50 	br	#0x50a8		;
    5bc4:	4c 43       	clr.b	r12		;
    5bc6:	4d 43       	clr.b	r13		;
    5bc8:	81 44 26 00 	mov	r4,	38(r1)	; 0x0026
    5bcc:	30 40 96 4d 	br	#0x4d96		;
    5bd0:	4e 43       	clr.b	r14		;
    5bd2:	4f 43       	clr.b	r15		;
    5bd4:	81 44 24 00 	mov	r4,	36(r1)	; 0x0024
    5bd8:	30 40 72 4d 	br	#0x4d72		;
    5bdc:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5be0:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    5be4:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    5be8:	30 40 4e 4d 	br	#0x4d4e		;
    5bec:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    5bf0:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5bf4:	81 44 06 00 	mov	r4,	6(r1)	;
    5bf8:	30 40 86 4c 	br	#0x4c86		;
    5bfc:	4a 43       	clr.b	r10		;
    5bfe:	4b 43       	clr.b	r11		;
    5c00:	81 44 1c 00 	mov	r4,	28(r1)	; 0x001c
    5c04:	30 40 58 4c 	br	#0x4c58		;
    5c08:	45 43       	clr.b	r5		;
    5c0a:	46 43       	clr.b	r6		;
    5c0c:	81 44 18 00 	mov	r4,	24(r1)	; 0x0018
    5c10:	30 40 34 4c 	br	#0x4c34		;
    5c14:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c16:	02 24       	jz	$+6      	;abs 0x5c1c
    5c18:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5c1c:	48 49       	mov.b	r9,	r8	;
    5c1e:	78 f0 03 00 	and.b	#3,	r8	;
    5c22:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5c26:	88 11       	sxt	r8		;
    5c28:	0c 49       	mov	r9,	r12	;
    5c2a:	5c 03       	rrum	#1,	r12	;
    5c2c:	19 b3       	bit	#1,	r9	;r3 As==01
    5c2e:	02 24       	jz	$+6      	;abs 0x5c34
    5c30:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5c34:	49 4c       	mov.b	r12,	r9	;
    5c36:	79 f0 03 00 	and.b	#3,	r9	;
    5c3a:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5c3e:	89 11       	sxt	r9		;
    5c40:	0e 4c       	mov	r12,	r14	;
    5c42:	5e 03       	rrum	#1,	r14	;
    5c44:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    5c48:	1c b3       	bit	#1,	r12	;r3 As==01
    5c4a:	03 24       	jz	$+8      	;abs 0x5c52
    5c4c:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    5c50:	12 00 
    5c52:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5c56:	82 1c 
    5c58:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5c5c:	7c f0 03 00 	and.b	#3,	r12	;
    5c60:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c64:	8c 11       	sxt	r12		;
    5c66:	30 40 12 4c 	br	#0x4c12		;
    5c6a:	0c 93       	cmp	#0,	r12	;r3 As==00
    5c6c:	02 24       	jz	$+6      	;abs 0x5c72
    5c6e:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5c72:	4c 49       	mov.b	r9,	r12	;
    5c74:	7c f0 03 00 	and.b	#3,	r12	;
    5c78:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5c7c:	8c 11       	sxt	r12		;
    5c7e:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    5c82:	0c 49       	mov	r9,	r12	;
    5c84:	5c 03       	rrum	#1,	r12	;
    5c86:	19 b3       	bit	#1,	r9	;r3 As==01
    5c88:	02 24       	jz	$+6      	;abs 0x5c8e
    5c8a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5c8e:	4d 4c       	mov.b	r12,	r13	;
    5c90:	7d f0 03 00 	and.b	#3,	r13	;
    5c94:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5c98:	8d 11       	sxt	r13		;
    5c9a:	81 4d 10 00 	mov	r13,	16(r1)	; 0x0010
    5c9e:	09 4c       	mov	r12,	r9	;
    5ca0:	59 03       	rrum	#1,	r9	;
    5ca2:	1c b3       	bit	#1,	r12	;r3 As==01
    5ca4:	02 24       	jz	$+6      	;abs 0x5caa
    5ca6:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5caa:	47 49       	mov.b	r9,	r7	;
    5cac:	77 f0 03 00 	and.b	#3,	r7	;
    5cb0:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5cb4:	87 11       	sxt	r7		;
    5cb6:	30 40 9e 4b 	br	#0x4b9e		;
    5cba:	0c 93       	cmp	#0,	r12	;r3 As==00
    5cbc:	02 24       	jz	$+6      	;abs 0x5cc2
    5cbe:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5cc2:	46 4a       	mov.b	r10,	r6	;
    5cc4:	76 f0 03 00 	and.b	#3,	r6	;
    5cc8:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5ccc:	86 11       	sxt	r6		;
    5cce:	0c 4a       	mov	r10,	r12	;
    5cd0:	5c 03       	rrum	#1,	r12	;
    5cd2:	1a b3       	bit	#1,	r10	;r3 As==01
    5cd4:	02 24       	jz	$+6      	;abs 0x5cda
    5cd6:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5cda:	4a 4c       	mov.b	r12,	r10	;
    5cdc:	7a f0 03 00 	and.b	#3,	r10	;
    5ce0:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    5ce4:	8a 11       	sxt	r10		;
    5ce6:	09 4c       	mov	r12,	r9	;
    5ce8:	59 03       	rrum	#1,	r9	;
    5cea:	1c b3       	bit	#1,	r12	;r3 As==01
    5cec:	02 24       	jz	$+6      	;abs 0x5cf2
    5cee:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5cf2:	4c 49       	mov.b	r9,	r12	;
    5cf4:	7c f0 03 00 	and.b	#3,	r12	;
    5cf8:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5cfc:	8c 11       	sxt	r12		;
    5cfe:	81 4c 06 00 	mov	r12,	6(r1)	;
    5d02:	30 40 32 4b 	br	#0x4b32		;
    5d06:	4c 43       	clr.b	r12		;
    5d08:	4d 43       	clr.b	r13		;
    5d0a:	81 44 28 00 	mov	r4,	40(r1)	; 0x0028
    5d0e:	30 40 2e 46 	br	#0x462e		;
    5d12:	4e 43       	clr.b	r14		;
    5d14:	4f 43       	clr.b	r15		;
    5d16:	81 44 26 00 	mov	r4,	38(r1)	; 0x0026
    5d1a:	30 40 0a 46 	br	#0x460a		;
    5d1e:	78 40 60 00 	mov.b	#96,	r8	;#0x0060
    5d22:	38 e0 20 00 	xor	#32,	r8	;#0x0020
    5d26:	09 44       	mov	r4,	r9	;
    5d28:	30 40 40 49 	br	#0x4940		;
    5d2c:	81 43 0a 00 	mov	#0,	10(r1)	;r3 As==00, 0x000a
    5d30:	81 43 0c 00 	mov	#0,	12(r1)	;r3 As==00, 0x000c
    5d34:	81 44 24 00 	mov	r4,	36(r1)	; 0x0024
    5d38:	30 40 e6 45 	br	#0x45e6		;
    5d3c:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
    5d40:	81 43 04 00 	mov	#0,	4(r1)	;r3 As==00
    5d44:	81 44 06 00 	mov	r4,	6(r1)	;
    5d48:	30 40 1e 45 	br	#0x451e		;
    5d4c:	4a 43       	clr.b	r10		;
    5d4e:	4b 43       	clr.b	r11		;
    5d50:	81 44 22 00 	mov	r4,	34(r1)	; 0x0022
    5d54:	30 40 f0 44 	br	#0x44f0		;
    5d58:	45 43       	clr.b	r5		;
    5d5a:	46 43       	clr.b	r6		;
    5d5c:	81 44 1c 00 	mov	r4,	28(r1)	; 0x001c
    5d60:	30 40 cc 44 	br	#0x44cc		;
    5d64:	0c 93       	cmp	#0,	r12	;r3 As==00
    5d66:	02 24       	jz	$+6      	;abs 0x5d6c
    5d68:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5d6c:	48 49       	mov.b	r9,	r8	;
    5d6e:	78 f0 03 00 	and.b	#3,	r8	;
    5d72:	78 50 fe ff 	add.b	#-2,	r8	;#0xfffe
    5d76:	88 11       	sxt	r8		;
    5d78:	0c 49       	mov	r9,	r12	;
    5d7a:	5c 03       	rrum	#1,	r12	;
    5d7c:	19 b3       	bit	#1,	r9	;r3 As==01
    5d7e:	02 24       	jz	$+6      	;abs 0x5d84
    5d80:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5d84:	49 4c       	mov.b	r12,	r9	;
    5d86:	79 f0 03 00 	and.b	#3,	r9	;
    5d8a:	79 50 fe ff 	add.b	#-2,	r9	;#0xfffe
    5d8e:	89 11       	sxt	r9		;
    5d90:	0e 4c       	mov	r12,	r14	;
    5d92:	5e 03       	rrum	#1,	r14	;
    5d94:	81 4e 12 00 	mov	r14,	18(r1)	; 0x0012
    5d98:	1c b3       	bit	#1,	r12	;r3 As==01
    5d9a:	03 24       	jz	$+8      	;abs 0x5da2
    5d9c:	b1 e0 00 b4 	xor	#-19456,18(r1)	;#0xb400, 0x0012
    5da0:	12 00 
    5da2:	92 41 12 00 	mov	18(r1),	&0x1c82	;0x00012
    5da6:	82 1c 
    5da8:	1c 41 12 00 	mov	18(r1),	r12	;0x00012
    5dac:	7c f0 03 00 	and.b	#3,	r12	;
    5db0:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5db4:	8c 11       	sxt	r12		;
    5db6:	30 40 aa 44 	br	#0x44aa		;
    5dba:	0c 93       	cmp	#0,	r12	;r3 As==00
    5dbc:	02 24       	jz	$+6      	;abs 0x5dc2
    5dbe:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5dc2:	4c 49       	mov.b	r9,	r12	;
    5dc4:	7c f0 03 00 	and.b	#3,	r12	;
    5dc8:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5dcc:	8c 11       	sxt	r12		;
    5dce:	81 4c 0a 00 	mov	r12,	10(r1)	; 0x000a
    5dd2:	0c 49       	mov	r9,	r12	;
    5dd4:	5c 03       	rrum	#1,	r12	;
    5dd6:	19 b3       	bit	#1,	r9	;r3 As==01
    5dd8:	02 24       	jz	$+6      	;abs 0x5dde
    5dda:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5dde:	4d 4c       	mov.b	r12,	r13	;
    5de0:	7d f0 03 00 	and.b	#3,	r13	;
    5de4:	7d 50 fe ff 	add.b	#-2,	r13	;#0xfffe
    5de8:	8d 11       	sxt	r13		;
    5dea:	81 4d 10 00 	mov	r13,	16(r1)	; 0x0010
    5dee:	09 4c       	mov	r12,	r9	;
    5df0:	59 03       	rrum	#1,	r9	;
    5df2:	1c b3       	bit	#1,	r12	;r3 As==01
    5df4:	02 24       	jz	$+6      	;abs 0x5dfa
    5df6:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5dfa:	47 49       	mov.b	r9,	r7	;
    5dfc:	77 f0 03 00 	and.b	#3,	r7	;
    5e00:	77 50 fe ff 	add.b	#-2,	r7	;#0xfffe
    5e04:	87 11       	sxt	r7		;
    5e06:	30 40 36 44 	br	#0x4436		;
    5e0a:	0c 93       	cmp	#0,	r12	;r3 As==00
    5e0c:	02 24       	jz	$+6      	;abs 0x5e12
    5e0e:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5e12:	46 4a       	mov.b	r10,	r6	;
    5e14:	76 f0 03 00 	and.b	#3,	r6	;
    5e18:	76 50 fe ff 	add.b	#-2,	r6	;#0xfffe
    5e1c:	86 11       	sxt	r6		;
    5e1e:	0c 4a       	mov	r10,	r12	;
    5e20:	5c 03       	rrum	#1,	r12	;
    5e22:	1a b3       	bit	#1,	r10	;r3 As==01
    5e24:	02 24       	jz	$+6      	;abs 0x5e2a
    5e26:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5e2a:	4a 4c       	mov.b	r12,	r10	;
    5e2c:	7a f0 03 00 	and.b	#3,	r10	;
    5e30:	7a 50 fe ff 	add.b	#-2,	r10	;#0xfffe
    5e34:	8a 11       	sxt	r10		;
    5e36:	09 4c       	mov	r12,	r9	;
    5e38:	59 03       	rrum	#1,	r9	;
    5e3a:	1c b3       	bit	#1,	r12	;r3 As==01
    5e3c:	02 24       	jz	$+6      	;abs 0x5e42
    5e3e:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5e42:	4c 49       	mov.b	r9,	r12	;
    5e44:	7c f0 03 00 	and.b	#3,	r12	;
    5e48:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5e4c:	8c 11       	sxt	r12		;
    5e4e:	81 4c 06 00 	mov	r12,	6(r1)	;
    5e52:	30 40 ca 43 	br	#0x43ca		;
    5e56:	0a 9c       	cmp	r12,	r10	;
    5e58:	02 28       	jnc	$+6      	;abs 0x5e5e
    5e5a:	80 00 62 49 	mova	#18786,	r0	;0x04962
    5e5e:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5e62:	30 40 62 49 	br	#0x4962		;
    5e66:	0a 9c       	cmp	r12,	r10	;
    5e68:	02 28       	jnc	$+6      	;abs 0x5e6e
    5e6a:	80 00 ca 50 	mova	#20682,	r0	;0x050ca
    5e6e:	38 e0 10 00 	xor	#16,	r8	;#0x0010
    5e72:	30 40 ca 50 	br	#0x50ca		;
    5e76:	0d 93       	cmp	#0,	r13	;r3 As==00
    5e78:	02 24       	jz	$+6      	;abs 0x5e7e
    5e7a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5e7e:	0d 4c       	mov	r12,	r13	;
    5e80:	5d 03       	rrum	#1,	r13	;
    5e82:	1c b3       	bit	#1,	r12	;r3 As==01
    5e84:	02 24       	jz	$+6      	;abs 0x5e8a
    5e86:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5e8a:	0a 4d       	mov	r13,	r10	;
    5e8c:	5a 03       	rrum	#1,	r10	;
    5e8e:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5e92:	1d b3       	bit	#1,	r13	;r3 As==01
    5e94:	02 20       	jnz	$+6      	;abs 0x5e9a
    5e96:	80 00 ba 4a 	mova	#19130,	r0	;0x04aba
    5e9a:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5e9e:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5ea2:	30 40 ba 4a 	br	#0x4aba		;
    5ea6:	0d 93       	cmp	#0,	r13	;r3 As==00
    5ea8:	02 24       	jz	$+6      	;abs 0x5eae
    5eaa:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400
    5eae:	0d 4c       	mov	r12,	r13	;
    5eb0:	5d 03       	rrum	#1,	r13	;
    5eb2:	1c b3       	bit	#1,	r12	;r3 As==01
    5eb4:	02 24       	jz	$+6      	;abs 0x5eba
    5eb6:	3d e0 00 b4 	xor	#-19456,r13	;#0xb400
    5eba:	0a 4d       	mov	r13,	r10	;
    5ebc:	5a 03       	rrum	#1,	r10	;
    5ebe:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5ec2:	1d b3       	bit	#1,	r13	;r3 As==01
    5ec4:	02 20       	jnz	$+6      	;abs 0x5eca
    5ec6:	80 00 52 43 	mova	#17234,	r0	;0x04352
    5eca:	3a e0 00 b4 	xor	#-19456,r10	;#0xb400
    5ece:	81 4a 12 00 	mov	r10,	18(r1)	; 0x0012
    5ed2:	30 40 52 43 	br	#0x4352		;
    5ed6:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5eda:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    5ede:	30 40 ba 4a 	br	#0x4aba		;
    5ee2:	39 e0 00 b4 	xor	#-19456,r9	;#0xb400
    5ee6:	81 49 12 00 	mov	r9,	18(r1)	; 0x0012
    5eea:	30 40 52 43 	br	#0x4352		;

00005eee <udivmodhi4>:
    5eee:	0f 4c       	mov	r12,	r15	;
    5ef0:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011
    5ef4:	5b 43       	mov.b	#1,	r11	;r3 As==01
    5ef6:	0d 9f       	cmp	r15,	r13	;
    5ef8:	05 2c       	jc	$+12     	;abs 0x5f04
    5efa:	3c 53       	add	#-1,	r12	;r3 As==11
    5efc:	0c 93       	cmp	#0,	r12	;r3 As==00
    5efe:	05 24       	jz	$+12     	;abs 0x5f0a
    5f00:	0d 93       	cmp	#0,	r13	;r3 As==00
    5f02:	07 34       	jge	$+16     	;abs 0x5f12
    5f04:	4c 43       	clr.b	r12		;
    5f06:	0b 93       	cmp	#0,	r11	;r3 As==00
    5f08:	07 20       	jnz	$+16     	;abs 0x5f18
    5f0a:	0e 93       	cmp	#0,	r14	;r3 As==00
    5f0c:	01 24       	jz	$+4      	;abs 0x5f10
    5f0e:	0c 4f       	mov	r15,	r12	;
    5f10:	30 41       	ret			
    5f12:	5d 02       	rlam	#1,	r13	;
    5f14:	5b 02       	rlam	#1,	r11	;
    5f16:	ef 3f       	jmp	$-32     	;abs 0x5ef6
    5f18:	0f 9d       	cmp	r13,	r15	;
    5f1a:	02 28       	jnc	$+6      	;abs 0x5f20
    5f1c:	0f 8d       	sub	r13,	r15	;
    5f1e:	0c db       	bis	r11,	r12	;
    5f20:	5b 03       	rrum	#1,	r11	;
    5f22:	5d 03       	rrum	#1,	r13	;
    5f24:	f0 3f       	jmp	$-30     	;abs 0x5f06

00005f26 <__mspabi_remu>:
    5f26:	5e 43       	mov.b	#1,	r14	;r3 As==01
    5f28:	b0 12 ee 5e 	call	#24302		;#0x5eee
    5f2c:	30 41       	ret			

00005f2e <udivmodsi4>:
    5f2e:	4a 15       	pushm	#5,	r10	;16-bit words
    5f30:	0a 4c       	mov	r12,	r10	;
    5f32:	0b 4d       	mov	r13,	r11	;
    5f34:	7c 40 21 00 	mov.b	#33,	r12	;#0x0021
    5f38:	58 43       	mov.b	#1,	r8	;r3 As==01
    5f3a:	49 43       	clr.b	r9		;
    5f3c:	0f 9b       	cmp	r11,	r15	;
    5f3e:	04 28       	jnc	$+10     	;abs 0x5f48
    5f40:	0b 9f       	cmp	r15,	r11	;
    5f42:	07 20       	jnz	$+16     	;abs 0x5f52
    5f44:	0e 9a       	cmp	r10,	r14	;
    5f46:	05 2c       	jc	$+12     	;abs 0x5f52
    5f48:	3c 53       	add	#-1,	r12	;r3 As==11
    5f4a:	0c 93       	cmp	#0,	r12	;r3 As==00
    5f4c:	2d 24       	jz	$+92     	;abs 0x5fa8
    5f4e:	0f 93       	cmp	#0,	r15	;r3 As==00
    5f50:	0d 34       	jge	$+28     	;abs 0x5f6c
    5f52:	4c 43       	clr.b	r12		;
    5f54:	4d 43       	clr.b	r13		;
    5f56:	07 48       	mov	r8,	r7	;
    5f58:	07 d9       	bis	r9,	r7	;
    5f5a:	07 93       	cmp	#0,	r7	;r3 As==00
    5f5c:	14 20       	jnz	$+42     	;abs 0x5f86
    5f5e:	81 93 0c 00 	cmp	#0,	12(r1)	;r3 As==00, 0x000c
    5f62:	02 24       	jz	$+6      	;abs 0x5f68
    5f64:	0c 4a       	mov	r10,	r12	;
    5f66:	0d 4b       	mov	r11,	r13	;
    5f68:	46 17       	popm	#5,	r10	;16-bit words
    5f6a:	30 41       	ret			
    5f6c:	06 4e       	mov	r14,	r6	;
    5f6e:	07 4f       	mov	r15,	r7	;
    5f70:	06 5e       	add	r14,	r6	;
    5f72:	07 6f       	addc	r15,	r7	;
    5f74:	0e 46       	mov	r6,	r14	;
    5f76:	0f 47       	mov	r7,	r15	;
    5f78:	06 48       	mov	r8,	r6	;
    5f7a:	07 49       	mov	r9,	r7	;
    5f7c:	06 58       	add	r8,	r6	;
    5f7e:	07 69       	addc	r9,	r7	;
    5f80:	08 46       	mov	r6,	r8	;
    5f82:	09 47       	mov	r7,	r9	;
    5f84:	db 3f       	jmp	$-72     	;abs 0x5f3c
    5f86:	0b 9f       	cmp	r15,	r11	;
    5f88:	08 28       	jnc	$+18     	;abs 0x5f9a
    5f8a:	0f 9b       	cmp	r11,	r15	;
    5f8c:	02 20       	jnz	$+6      	;abs 0x5f92
    5f8e:	0a 9e       	cmp	r14,	r10	;
    5f90:	04 28       	jnc	$+10     	;abs 0x5f9a
    5f92:	0a 8e       	sub	r14,	r10	;
    5f94:	0b 7f       	subc	r15,	r11	;
    5f96:	0c d8       	bis	r8,	r12	;
    5f98:	0d d9       	bis	r9,	r13	;
    5f9a:	12 c3       	clrc			
    5f9c:	09 10       	rrc	r9		;
    5f9e:	08 10       	rrc	r8		;
    5fa0:	12 c3       	clrc			
    5fa2:	0f 10       	rrc	r15		;
    5fa4:	0e 10       	rrc	r14		;
    5fa6:	d7 3f       	jmp	$-80     	;abs 0x5f56
    5fa8:	4c 43       	clr.b	r12		;
    5faa:	4d 43       	clr.b	r13		;
    5fac:	d8 3f       	jmp	$-78     	;abs 0x5f5e

00005fae <__mspabi_divli>:
    5fae:	2a 15       	pushm	#3,	r10	;16-bit words
    5fb0:	21 83       	decd	r1		;
    5fb2:	4a 43       	clr.b	r10		;
    5fb4:	0d 93       	cmp	#0,	r13	;r3 As==00
    5fb6:	07 34       	jge	$+16     	;abs 0x5fc6
    5fb8:	48 43       	clr.b	r8		;
    5fba:	49 43       	clr.b	r9		;
    5fbc:	08 8c       	sub	r12,	r8	;
    5fbe:	09 7d       	subc	r13,	r9	;
    5fc0:	0c 48       	mov	r8,	r12	;
    5fc2:	0d 49       	mov	r9,	r13	;
    5fc4:	5a 43       	mov.b	#1,	r10	;r3 As==01
    5fc6:	0f 93       	cmp	#0,	r15	;r3 As==00
    5fc8:	07 34       	jge	$+16     	;abs 0x5fd8
    5fca:	48 43       	clr.b	r8		;
    5fcc:	49 43       	clr.b	r9		;
    5fce:	08 8e       	sub	r14,	r8	;
    5fd0:	09 7f       	subc	r15,	r9	;
    5fd2:	0e 48       	mov	r8,	r14	;
    5fd4:	0f 49       	mov	r9,	r15	;
    5fd6:	1a e3       	xor	#1,	r10	;r3 As==01
    5fd8:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    5fdc:	b0 12 2e 5f 	call	#24366		;#0x5f2e
    5fe0:	0a 93       	cmp	#0,	r10	;r3 As==00
    5fe2:	06 24       	jz	$+14     	;abs 0x5ff0
    5fe4:	49 43       	clr.b	r9		;
    5fe6:	4a 43       	clr.b	r10		;
    5fe8:	09 8c       	sub	r12,	r9	;
    5fea:	0a 7d       	subc	r13,	r10	;
    5fec:	0c 49       	mov	r9,	r12	;
    5fee:	0d 4a       	mov	r10,	r13	;
    5ff0:	21 53       	incd	r1		;
    5ff2:	28 17       	popm	#3,	r10	;16-bit words
    5ff4:	30 41       	ret			

00005ff6 <__mulhi2>:
    5ff6:	02 12       	push	r2		;
    5ff8:	32 c2       	dint			
    5ffa:	03 43       	nop			
    5ffc:	82 4c c0 04 	mov	r12,	&0x04c0	;
    6000:	82 4d c8 04 	mov	r13,	&0x04c8	;
    6004:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    6008:	00 13       	reti			

0000600a <__mulsi2>:
    600a:	02 12       	push	r2		;
    600c:	32 c2       	dint			
    600e:	03 43       	nop			
    6010:	82 4c d0 04 	mov	r12,	&0x04d0	;
    6014:	82 4d d2 04 	mov	r13,	&0x04d2	;
    6018:	82 4e e0 04 	mov	r14,	&0x04e0	;
    601c:	82 4f e2 04 	mov	r15,	&0x04e2	;
    6020:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    6024:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    6028:	00 13       	reti			

0000602a <memcpy>:
    602a:	0f 4c       	mov	r12,	r15	;
    602c:	0e 5d       	add	r13,	r14	;
    602e:	0d 9e       	cmp	r14,	r13	;
    6030:	01 20       	jnz	$+4      	;abs 0x6034
    6032:	30 41       	ret			
    6034:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    6038:	1f 53       	inc	r15		;
    603a:	f9 3f       	jmp	$-12     	;abs 0x602e

0000603c <_exit>:
    603c:	ff 3f       	jmp	$+0      	;abs 0x603c
