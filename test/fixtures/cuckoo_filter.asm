
/Users/byeongjee/migration/probabilistic-energy-modeling/build/cuckoo_filter_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 02 02 	mov	#514,	r14	;#0x0202
    4010:	b0 12 0a 47 	call	#18186		;#0x470a

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 3c 42 	call	#16956		;#0x423c

0000401a <__crt0_call_exit>:
    401a:	b0 12 1c 47 	call	#18204		;#0x471c

0000401e <clockSetup>:
    401e:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4022:	61 01 
    4024:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    4028:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    402c:	64 01 
    402e:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4032:	66 01 
    4034:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    4038:	62 01 
    403a:	0d 14       	pushm.a	#1,	r13	;20-bit words
    403c:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    4040:	1d 83       	dec	r13		;
    4042:	fe 23       	jnz	$-2      	;abs 0x4040
    4044:	0d 16       	popm.a	#1,	r13	;20-bit words
    4046:	00 3c       	jmp	$+2      	;abs 0x4048
    4048:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    404c:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4050:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4054:	30 41       	ret			

00004056 <toggle_gpio>:
    4056:	f2 e2 02 02 	xor.b	#8,	&0x0202	;r2 As==11
    405a:	30 41       	ret			

0000405c <begin_event>:
    405c:	1e 14       	pushm.a	#2,	r14	;20-bit words
    405e:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4062:	3e 40 05 00 	mov	#5,	r14	;
    4066:	1d 83       	dec	r13		;
    4068:	0e 73       	sbc	r14		;
    406a:	fd 23       	jnz	$-4      	;abs 0x4066
    406c:	0d 93       	cmp	#0,	r13	;r3 As==00
    406e:	fb 23       	jnz	$-8      	;abs 0x4066
    4070:	1d 16       	popm.a	#2,	r14	;20-bit words
    4072:	f2 d2 02 02 	bis.b	#8,	&0x0202	;r2 As==11
    4076:	30 41       	ret			

00004078 <end_event>:
    4078:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    407c:	1e 14       	pushm.a	#2,	r14	;20-bit words
    407e:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4082:	3e 40 05 00 	mov	#5,	r14	;
    4086:	1d 83       	dec	r13		;
    4088:	0e 73       	sbc	r14		;
    408a:	fd 23       	jnz	$-4      	;abs 0x4086
    408c:	0d 93       	cmp	#0,	r13	;r3 As==00
    408e:	fb 23       	jnz	$-8      	;abs 0x4086
    4090:	1d 16       	popm.a	#2,	r14	;20-bit words
    4092:	30 41       	ret			

00004094 <begin_measurement_window>:
    4094:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4096:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    409a:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    409e:	1d 83       	dec	r13		;
    40a0:	0e 73       	sbc	r14		;
    40a2:	fd 23       	jnz	$-4      	;abs 0x409e
    40a4:	0d 93       	cmp	#0,	r13	;r3 As==00
    40a6:	fb 23       	jnz	$-8      	;abs 0x409e
    40a8:	1d 16       	popm.a	#2,	r14	;20-bit words
    40aa:	e2 d2 02 02 	bis.b	#4,	&0x0202	;r2 As==10
    40ae:	30 41       	ret			

000040b0 <end_measurement_window>:
    40b0:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    40b4:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40b6:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40ba:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    40be:	1d 83       	dec	r13		;
    40c0:	0e 73       	sbc	r14		;
    40c2:	fd 23       	jnz	$-4      	;abs 0x40be
    40c4:	0d 93       	cmp	#0,	r13	;r3 As==00
    40c6:	fb 23       	jnz	$-8      	;abs 0x40be
    40c8:	1d 16       	popm.a	#2,	r14	;20-bit words
    40ca:	30 41       	ret			

000040cc <delay>:
    40cc:	0e 4c       	mov	r12,	r14	;
    40ce:	3e 53       	add	#-1,	r14	;r3 As==11
    40d0:	0f 4d       	mov	r13,	r15	;
    40d2:	3f 63       	addc	#-1,	r15	;r3 As==11
    40d4:	0c 4e       	mov	r14,	r12	;
    40d6:	0c df       	bis	r15,	r12	;
    40d8:	0c 93       	cmp	#0,	r12	;r3 As==00
    40da:	07 24       	jz	$+16     	;abs 0x40ea
    40dc:	03 43       	nop			
    40de:	3e 53       	add	#-1,	r14	;r3 As==11
    40e0:	3f 63       	addc	#-1,	r15	;r3 As==11
    40e2:	0c 4e       	mov	r14,	r12	;
    40e4:	0c df       	bis	r15,	r12	;
    40e6:	0c 93       	cmp	#0,	r12	;r3 As==00
    40e8:	f9 23       	jnz	$-12     	;abs 0x40dc
    40ea:	30 41       	ret			

000040ec <bench_empty_function>:
    40ec:	03 43       	nop			
    40ee:	03 43       	nop			
    40f0:	03 43       	nop			
    40f2:	03 43       	nop			
    40f4:	03 43       	nop			
    40f6:	03 43       	nop			
    40f8:	03 43       	nop			
    40fa:	03 43       	nop			
    40fc:	03 43       	nop			
    40fe:	03 43       	nop			
    4100:	03 43       	nop			
    4102:	03 43       	nop			
    4104:	03 43       	nop			
    4106:	03 43       	nop			
    4108:	03 43       	nop			
    410a:	03 43       	nop			
    410c:	03 43       	nop			
    410e:	03 43       	nop			
    4110:	03 43       	nop			
    4112:	03 43       	nop			
    4114:	03 43       	nop			
    4116:	03 43       	nop			
    4118:	03 43       	nop			
    411a:	03 43       	nop			
    411c:	03 43       	nop			
    411e:	03 43       	nop			
    4120:	03 43       	nop			
    4122:	03 43       	nop			
    4124:	03 43       	nop			
    4126:	03 43       	nop			
    4128:	03 43       	nop			
    412a:	03 43       	nop			
    412c:	03 43       	nop			
    412e:	03 43       	nop			
    4130:	03 43       	nop			
    4132:	03 43       	nop			
    4134:	03 43       	nop			
    4136:	03 43       	nop			
    4138:	03 43       	nop			
    413a:	03 43       	nop			
    413c:	03 43       	nop			
    413e:	03 43       	nop			
    4140:	03 43       	nop			
    4142:	03 43       	nop			
    4144:	03 43       	nop			
    4146:	03 43       	nop			
    4148:	03 43       	nop			
    414a:	03 43       	nop			
    414c:	03 43       	nop			
    414e:	03 43       	nop			
    4150:	30 41       	ret			

00004152 <bench_empty_interrupt>:
    4152:	02 12       	push	r2		;
    4154:	32 c2       	dint			
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
    41a4:	03 43       	nop			
    41a6:	03 43       	nop			
    41a8:	03 43       	nop			
    41aa:	03 43       	nop			
    41ac:	03 43       	nop			
    41ae:	03 43       	nop			
    41b0:	03 43       	nop			
    41b2:	03 43       	nop			
    41b4:	03 43       	nop			
    41b6:	03 43       	nop			
    41b8:	03 43       	nop			
    41ba:	00 13       	reti			

000041bc <initialize>:
    41bc:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    41c0:	5c 01 
    41c2:	92 c3 30 01 	bic	#1,	&0x0130	;r3 As==01
    41c6:	3c 40 06 1e 	mov	#7686,	r12	;#0x1e06
    41ca:	3c 90 06 1e 	cmp	#7686,	r12	;#0x1e06
    41ce:	07 2c       	jc	$+16     	;abs 0x41de
    41d0:	3e 40 06 1e 	mov	#7686,	r14	;#0x1e06
    41d4:	0e 8c       	sub	r12,	r14	;
    41d6:	3d 40 1e 47 	mov	#18206,	r13	;#0x471e
    41da:	b0 12 f8 46 	call	#18168		;#0x46f8
    41de:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    41e2:	61 01 
    41e4:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    41e8:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    41ec:	64 01 
    41ee:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    41f2:	66 01 
    41f4:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    41f8:	62 01 
    41fa:	0d 14       	pushm.a	#1,	r13	;20-bit words
    41fc:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    4200:	1d 83       	dec	r13		;
    4202:	fe 23       	jnz	$-2      	;abs 0x4200
    4204:	0d 16       	popm.a	#1,	r13	;20-bit words
    4206:	00 3c       	jmp	$+2      	;abs 0x4208
    4208:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    420c:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4210:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4214:	f2 d0 0c 00 	bis.b	#12,	&0x0204	;#0x000c
    4218:	04 02 
    421a:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    421e:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    4222:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4224:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    4228:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    422c:	1d 83       	dec	r13		;
    422e:	0e 73       	sbc	r14		;
    4230:	fd 23       	jnz	$-4      	;abs 0x422c
    4232:	0d 93       	cmp	#0,	r13	;r3 As==00
    4234:	fb 23       	jnz	$-8      	;abs 0x422c
    4236:	1d 16       	popm.a	#2,	r14	;20-bit words
    4238:	30 41       	ret			

0000423a <print_filter>:
    423a:	30 41       	ret			

0000423c <main>:
    423c:	6a 15       	pushm	#7,	r10	;16-bit words
    423e:	31 80 36 00 	sub	#54,	r1	;#0x0036
    4242:	b0 12 bc 41 	call	#16828		;#0x41bc
    4246:	03 43       	nop			
    4248:	32 d2       	eint			
    424a:	03 43       	nop			
    424c:	b2 40 e1 ac 	mov	#-21279,&0x1c00	;#0xace1
    4250:	00 1c 
    4252:	3e 40 00 02 	mov	#512,	r14	;#0x0200
    4256:	4d 43       	clr.b	r13		;
    4258:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02
    425c:	b0 12 0a 47 	call	#18186		;#0x470a
    4260:	b0 12 94 40 	call	#16532		;#0x4094
    4264:	b0 12 5c 40 	call	#16476		;#0x405c
    4268:	91 42 00 1c 	mov	&0x1c00,8(r1)	;0x1c00
    426c:	08 00 
    426e:	77 40 80 00 	mov.b	#128,	r7	;#0x0080
    4272:	81 43 2a 00 	mov	#0,	42(r1)	;r3 As==00, 0x002a
    4276:	5b 43       	mov.b	#1,	r11	;r3 As==01
    4278:	9d 3d       	jmp	$+828    	;abs 0x45b4
    427a:	0d 4c       	mov	r12,	r13	;
    427c:	7d f0 ff 00 	and.b	#255,	r13	;#0x00ff
    4280:	3d 50 a5 b5 	add	#-19035,r13	;#0xb5a5
    4284:	81 4d 04 00 	mov	r13,	4(r1)	;
    4288:	4d 43       	clr.b	r13		;
    428a:	2d 63       	addc	#2,	r13	;r3 As==10
    428c:	81 4d 06 00 	mov	r13,	6(r1)	;
    4290:	1e 41 04 00 	mov	4(r1),	r14	;
    4294:	1f 41 06 00 	mov	6(r1),	r15	;
    4298:	0e 5e       	rla	r14		;
    429a:	0f 6f       	rlc	r15		;
    429c:	0e 5e       	rla	r14		;
    429e:	0f 6f       	rlc	r15		;
    42a0:	0e 5e       	rla	r14		;
    42a2:	0f 6f       	rlc	r15		;
    42a4:	0e 5e       	rla	r14		;
    42a6:	0f 6f       	rlc	r15		;
    42a8:	0e 5e       	rla	r14		;
    42aa:	0f 6f       	rlc	r15		;
    42ac:	08 4c       	mov	r12,	r8	;
    42ae:	47 19 08 10 	rpt #8 { rrux.w	r8		;
    42b2:	09 43       	clr	r9		;
    42b4:	0e 58       	add	r8,	r14	;
    42b6:	1e 51 04 00 	add	4(r1),	r14	;
    42ba:	0d 4c       	mov	r12,	r13	;
    42bc:	0d ee       	xor	r14,	r13	;
    42be:	7d f0 ff 00 	and.b	#255,	r13	;#0x00ff
    42c2:	0e 4d       	mov	r13,	r14	;
    42c4:	5e 02       	rlam	#1,	r14	;
    42c6:	0f 4e       	mov	r14,	r15	;
    42c8:	3f 50 02 1c 	add	#7170,	r15	;#0x1c02
    42cc:	19 4e 02 1c 	mov	7170(r14),r9	;0x01c02
    42d0:	09 93       	cmp	#0,	r9	;r3 As==00
    42d2:	02 20       	jnz	$+6      	;abs 0x42d8
    42d4:	80 00 ec 46 	mova	#18156,	r0	;0x046ec
    42d8:	1c 41 08 00 	mov	8(r1),	r12	;
    42dc:	5c f3       	and.b	#1,	r12	;r3 As==01
    42de:	1e 41 08 00 	mov	8(r1),	r14	;
    42e2:	5e 03       	rrum	#1,	r14	;
    42e4:	81 4e 08 00 	mov	r14,	8(r1)	;
    42e8:	0c 93       	cmp	#0,	r12	;r3 As==00
    42ea:	04 24       	jz	$+10     	;abs 0x42f4
    42ec:	3e e0 00 b4 	xor	#-19456,r14	;#0xb400
    42f0:	81 4e 08 00 	mov	r14,	8(r1)	;
    42f4:	b1 b0 80 00 	bit	#128,	8(r1)	;#0x0080
    42f8:	08 00 
    42fa:	03 24       	jz	$+8      	;abs 0x4302
    42fc:	09 45       	mov	r5,	r9	;
    42fe:	0f 44       	mov	r4,	r15	;
    4300:	0d 46       	mov	r6,	r13	;
    4302:	8f 4a 00 00 	mov	r10,	0(r15)	;
    4306:	4e 49       	mov.b	r9,	r14	;
    4308:	0f 43       	clr	r15		;
    430a:	0a 4e       	mov	r14,	r10	;
    430c:	3a 50 a5 b5 	add	#-19035,r10	;#0xb5a5
    4310:	81 4a 0a 00 	mov	r10,	10(r1)	; 0x000a
    4314:	0c 4f       	mov	r15,	r12	;
    4316:	2c 63       	addc	#2,	r12	;r3 As==10
    4318:	81 4c 0c 00 	mov	r12,	12(r1)	; 0x000c
    431c:	14 41 0a 00 	mov	10(r1),	r4	;0x0000a
    4320:	15 41 0c 00 	mov	12(r1),	r5	;0x0000c
    4324:	04 54       	rla	r4		;
    4326:	05 65       	rlc	r5		;
    4328:	04 54       	rla	r4		;
    432a:	05 65       	rlc	r5		;
    432c:	04 54       	rla	r4		;
    432e:	05 65       	rlc	r5		;
    4330:	04 54       	rla	r4		;
    4332:	05 65       	rlc	r5		;
    4334:	04 54       	rla	r4		;
    4336:	05 65       	rlc	r5		;
    4338:	0e 49       	mov	r9,	r14	;
    433a:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    433e:	0f 43       	clr	r15		;
    4340:	0e 5a       	add	r10,	r14	;
    4342:	0e 54       	add	r4,	r14	;
    4344:	7e f0 ff 00 	and.b	#255,	r14	;#0x00ff
    4348:	0d ee       	xor	r14,	r13	;
    434a:	0e 4d       	mov	r13,	r14	;
    434c:	5e 02       	rlam	#1,	r14	;
    434e:	1c 4e 02 1c 	mov	7170(r14),r12	;0x01c02
    4352:	8e 49 02 1c 	mov	r9,	7170(r14); 0x1c02
    4356:	0c 93       	cmp	#0,	r12	;r3 As==00
    4358:	cc 25       	jz	$+922    	;abs 0x46f2
    435a:	4e 4c       	mov.b	r12,	r14	;
    435c:	0f 43       	clr	r15		;
    435e:	0a 4e       	mov	r14,	r10	;
    4360:	3a 50 a5 b5 	add	#-19035,r10	;#0xb5a5
    4364:	81 4a 0e 00 	mov	r10,	14(r1)	; 0x000e
    4368:	0a 4f       	mov	r15,	r10	;
    436a:	2a 63       	addc	#2,	r10	;r3 As==10
    436c:	81 4a 10 00 	mov	r10,	16(r1)	; 0x0010
    4370:	18 41 0e 00 	mov	14(r1),	r8	;0x0000e
    4374:	19 41 10 00 	mov	16(r1),	r9	;0x00010
    4378:	08 58       	rla	r8		;
    437a:	09 69       	rlc	r9		;
    437c:	08 58       	rla	r8		;
    437e:	09 69       	rlc	r9		;
    4380:	08 58       	rla	r8		;
    4382:	09 69       	rlc	r9		;
    4384:	08 58       	rla	r8		;
    4386:	09 69       	rlc	r9		;
    4388:	08 58       	rla	r8		;
    438a:	09 69       	rlc	r9		;
    438c:	0e 4c       	mov	r12,	r14	;
    438e:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    4392:	0f 43       	clr	r15		;
    4394:	1e 51 0e 00 	add	14(r1),	r14	;0x0000e
    4398:	0e 58       	add	r8,	r14	;
    439a:	7e f0 ff 00 	and.b	#255,	r14	;#0x00ff
    439e:	0d ee       	xor	r14,	r13	;
    43a0:	0e 4d       	mov	r13,	r14	;
    43a2:	5e 02       	rlam	#1,	r14	;
    43a4:	1a 4e 02 1c 	mov	7170(r14),r10	;0x01c02
    43a8:	8e 4c 02 1c 	mov	r12,	7170(r14); 0x1c02
    43ac:	0a 93       	cmp	#0,	r10	;r3 As==00
    43ae:	a1 25       	jz	$+836    	;abs 0x46f2
    43b0:	4e 4a       	mov.b	r10,	r14	;
    43b2:	0f 43       	clr	r15		;
    43b4:	0c 4e       	mov	r14,	r12	;
    43b6:	3c 50 a5 b5 	add	#-19035,r12	;#0xb5a5
    43ba:	81 4c 12 00 	mov	r12,	18(r1)	; 0x0012
    43be:	0c 4f       	mov	r15,	r12	;
    43c0:	2c 63       	addc	#2,	r12	;r3 As==10
    43c2:	81 4c 14 00 	mov	r12,	20(r1)	; 0x0014
    43c6:	18 41 12 00 	mov	18(r1),	r8	;0x00012
    43ca:	19 41 14 00 	mov	20(r1),	r9	;0x00014
    43ce:	08 58       	rla	r8		;
    43d0:	09 69       	rlc	r9		;
    43d2:	08 58       	rla	r8		;
    43d4:	09 69       	rlc	r9		;
    43d6:	08 58       	rla	r8		;
    43d8:	09 69       	rlc	r9		;
    43da:	08 58       	rla	r8		;
    43dc:	09 69       	rlc	r9		;
    43de:	08 58       	rla	r8		;
    43e0:	09 69       	rlc	r9		;
    43e2:	0e 4a       	mov	r10,	r14	;
    43e4:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    43e8:	0f 43       	clr	r15		;
    43ea:	1e 51 12 00 	add	18(r1),	r14	;0x00012
    43ee:	0e 58       	add	r8,	r14	;
    43f0:	7e f0 ff 00 	and.b	#255,	r14	;#0x00ff
    43f4:	0d ee       	xor	r14,	r13	;
    43f6:	0e 4d       	mov	r13,	r14	;
    43f8:	5e 02       	rlam	#1,	r14	;
    43fa:	1c 4e 02 1c 	mov	7170(r14),r12	;0x01c02
    43fe:	8e 4a 02 1c 	mov	r10,	7170(r14); 0x1c02
    4402:	0c 93       	cmp	#0,	r12	;r3 As==00
    4404:	76 25       	jz	$+750    	;abs 0x46f2
    4406:	4e 4c       	mov.b	r12,	r14	;
    4408:	0f 43       	clr	r15		;
    440a:	0a 4e       	mov	r14,	r10	;
    440c:	3a 50 a5 b5 	add	#-19035,r10	;#0xb5a5
    4410:	81 4a 16 00 	mov	r10,	22(r1)	; 0x0016
    4414:	0a 4f       	mov	r15,	r10	;
    4416:	2a 63       	addc	#2,	r10	;r3 As==10
    4418:	81 4a 18 00 	mov	r10,	24(r1)	; 0x0018
    441c:	18 41 16 00 	mov	22(r1),	r8	;0x00016
    4420:	19 41 18 00 	mov	24(r1),	r9	;0x00018
    4424:	08 58       	rla	r8		;
    4426:	09 69       	rlc	r9		;
    4428:	08 58       	rla	r8		;
    442a:	09 69       	rlc	r9		;
    442c:	08 58       	rla	r8		;
    442e:	09 69       	rlc	r9		;
    4430:	08 58       	rla	r8		;
    4432:	09 69       	rlc	r9		;
    4434:	08 58       	rla	r8		;
    4436:	09 69       	rlc	r9		;
    4438:	0e 4c       	mov	r12,	r14	;
    443a:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    443e:	0f 43       	clr	r15		;
    4440:	1e 51 16 00 	add	22(r1),	r14	;0x00016
    4444:	0e 58       	add	r8,	r14	;
    4446:	7e f0 ff 00 	and.b	#255,	r14	;#0x00ff
    444a:	0d ee       	xor	r14,	r13	;
    444c:	0e 4d       	mov	r13,	r14	;
    444e:	5e 02       	rlam	#1,	r14	;
    4450:	1a 4e 02 1c 	mov	7170(r14),r10	;0x01c02
    4454:	8e 4c 02 1c 	mov	r12,	7170(r14); 0x1c02
    4458:	0a 93       	cmp	#0,	r10	;r3 As==00
    445a:	4b 25       	jz	$+664    	;abs 0x46f2
    445c:	4e 4a       	mov.b	r10,	r14	;
    445e:	0f 43       	clr	r15		;
    4460:	0c 4e       	mov	r14,	r12	;
    4462:	3c 50 a5 b5 	add	#-19035,r12	;#0xb5a5
    4466:	81 4c 1a 00 	mov	r12,	26(r1)	; 0x001a
    446a:	0c 4f       	mov	r15,	r12	;
    446c:	2c 63       	addc	#2,	r12	;r3 As==10
    446e:	81 4c 1c 00 	mov	r12,	28(r1)	; 0x001c
    4472:	18 41 1a 00 	mov	26(r1),	r8	;0x0001a
    4476:	19 41 1c 00 	mov	28(r1),	r9	;0x0001c
    447a:	08 58       	rla	r8		;
    447c:	09 69       	rlc	r9		;
    447e:	08 58       	rla	r8		;
    4480:	09 69       	rlc	r9		;
    4482:	08 58       	rla	r8		;
    4484:	09 69       	rlc	r9		;
    4486:	08 58       	rla	r8		;
    4488:	09 69       	rlc	r9		;
    448a:	08 58       	rla	r8		;
    448c:	09 69       	rlc	r9		;
    448e:	0e 4a       	mov	r10,	r14	;
    4490:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    4494:	0f 43       	clr	r15		;
    4496:	1e 51 1a 00 	add	26(r1),	r14	;0x0001a
    449a:	0e 58       	add	r8,	r14	;
    449c:	7e f0 ff 00 	and.b	#255,	r14	;#0x00ff
    44a0:	0d ee       	xor	r14,	r13	;
    44a2:	0e 4d       	mov	r13,	r14	;
    44a4:	5e 02       	rlam	#1,	r14	;
    44a6:	1c 4e 02 1c 	mov	7170(r14),r12	;0x01c02
    44aa:	8e 4a 02 1c 	mov	r10,	7170(r14); 0x1c02
    44ae:	0c 93       	cmp	#0,	r12	;r3 As==00
    44b0:	20 25       	jz	$+578    	;abs 0x46f2
    44b2:	4e 4c       	mov.b	r12,	r14	;
    44b4:	0f 43       	clr	r15		;
    44b6:	0a 4e       	mov	r14,	r10	;
    44b8:	3a 50 a5 b5 	add	#-19035,r10	;#0xb5a5
    44bc:	81 4a 1e 00 	mov	r10,	30(r1)	; 0x001e
    44c0:	0a 4f       	mov	r15,	r10	;
    44c2:	2a 63       	addc	#2,	r10	;r3 As==10
    44c4:	81 4a 20 00 	mov	r10,	32(r1)	; 0x0020
    44c8:	18 41 1e 00 	mov	30(r1),	r8	;0x0001e
    44cc:	19 41 20 00 	mov	32(r1),	r9	;0x00020
    44d0:	08 58       	rla	r8		;
    44d2:	09 69       	rlc	r9		;
    44d4:	08 58       	rla	r8		;
    44d6:	09 69       	rlc	r9		;
    44d8:	08 58       	rla	r8		;
    44da:	09 69       	rlc	r9		;
    44dc:	08 58       	rla	r8		;
    44de:	09 69       	rlc	r9		;
    44e0:	08 58       	rla	r8		;
    44e2:	09 69       	rlc	r9		;
    44e4:	0e 4c       	mov	r12,	r14	;
    44e6:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    44ea:	0f 43       	clr	r15		;
    44ec:	1e 51 1e 00 	add	30(r1),	r14	;0x0001e
    44f0:	0e 58       	add	r8,	r14	;
    44f2:	7e f0 ff 00 	and.b	#255,	r14	;#0x00ff
    44f6:	0d ee       	xor	r14,	r13	;
    44f8:	0e 4d       	mov	r13,	r14	;
    44fa:	5e 02       	rlam	#1,	r14	;
    44fc:	1a 4e 02 1c 	mov	7170(r14),r10	;0x01c02
    4500:	8e 4c 02 1c 	mov	r12,	7170(r14); 0x1c02
    4504:	0a 93       	cmp	#0,	r10	;r3 As==00
    4506:	f5 24       	jz	$+492    	;abs 0x46f2
    4508:	4e 4a       	mov.b	r10,	r14	;
    450a:	0f 43       	clr	r15		;
    450c:	0c 4e       	mov	r14,	r12	;
    450e:	3c 50 a5 b5 	add	#-19035,r12	;#0xb5a5
    4512:	81 4c 22 00 	mov	r12,	34(r1)	; 0x0022
    4516:	0c 4f       	mov	r15,	r12	;
    4518:	2c 63       	addc	#2,	r12	;r3 As==10
    451a:	81 4c 24 00 	mov	r12,	36(r1)	; 0x0024
    451e:	18 41 22 00 	mov	34(r1),	r8	;0x00022
    4522:	19 41 24 00 	mov	36(r1),	r9	;0x00024
    4526:	08 58       	rla	r8		;
    4528:	09 69       	rlc	r9		;
    452a:	08 58       	rla	r8		;
    452c:	09 69       	rlc	r9		;
    452e:	08 58       	rla	r8		;
    4530:	09 69       	rlc	r9		;
    4532:	08 58       	rla	r8		;
    4534:	09 69       	rlc	r9		;
    4536:	08 58       	rla	r8		;
    4538:	09 69       	rlc	r9		;
    453a:	0e 4a       	mov	r10,	r14	;
    453c:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    4540:	0f 43       	clr	r15		;
    4542:	1e 51 22 00 	add	34(r1),	r14	;0x00022
    4546:	0e 58       	add	r8,	r14	;
    4548:	7e f0 ff 00 	and.b	#255,	r14	;#0x00ff
    454c:	0d ee       	xor	r14,	r13	;
    454e:	0e 4d       	mov	r13,	r14	;
    4550:	5e 02       	rlam	#1,	r14	;
    4552:	1c 4e 02 1c 	mov	7170(r14),r12	;0x01c02
    4556:	8e 4a 02 1c 	mov	r10,	7170(r14); 0x1c02
    455a:	0c 93       	cmp	#0,	r12	;r3 As==00
    455c:	ca 24       	jz	$+406    	;abs 0x46f2
    455e:	4e 4c       	mov.b	r12,	r14	;
    4560:	0f 43       	clr	r15		;
    4562:	0a 4e       	mov	r14,	r10	;
    4564:	3a 50 a5 b5 	add	#-19035,r10	;#0xb5a5
    4568:	81 4a 26 00 	mov	r10,	38(r1)	; 0x0026
    456c:	0a 4f       	mov	r15,	r10	;
    456e:	2a 63       	addc	#2,	r10	;r3 As==10
    4570:	81 4a 28 00 	mov	r10,	40(r1)	; 0x0028
    4574:	1e 41 26 00 	mov	38(r1),	r14	;0x00026
    4578:	1f 41 28 00 	mov	40(r1),	r15	;0x00028
    457c:	0e 5e       	rla	r14		;
    457e:	0f 6f       	rlc	r15		;
    4580:	0e 5e       	rla	r14		;
    4582:	0f 6f       	rlc	r15		;
    4584:	0e 5e       	rla	r14		;
    4586:	0f 6f       	rlc	r15		;
    4588:	0e 5e       	rla	r14		;
    458a:	0f 6f       	rlc	r15		;
    458c:	0e 5e       	rla	r14		;
    458e:	0f 6f       	rlc	r15		;
    4590:	08 4c       	mov	r12,	r8	;
    4592:	47 19 08 10 	rpt #8 { rrux.w	r8		;
    4596:	09 43       	clr	r9		;
    4598:	18 51 26 00 	add	38(r1),	r8	;0x00026
    459c:	08 5e       	add	r14,	r8	;
    459e:	78 f0 ff 00 	and.b	#255,	r8	;#0x00ff
    45a2:	0d e8       	xor	r8,	r13	;
    45a4:	5d 02       	rlam	#1,	r13	;
    45a6:	8d 4c 02 1c 	mov	r12,	7170(r13); 0x1c02
    45aa:	91 43 2a 00 	mov	#1,	42(r1)	;r3 As==01, 0x002a
    45ae:	37 53       	add	#-1,	r7	;r3 As==11
    45b0:	07 93       	cmp	#0,	r7	;r3 As==00
    45b2:	34 24       	jz	$+106    	;abs 0x461c
    45b4:	1b 53       	inc	r11		;
    45b6:	0c 4b       	mov	r11,	r12	;
    45b8:	5c 0e       	rlam	#4,	r12	;
    45ba:	0b 5c       	add	r12,	r11	;
    45bc:	4c 4b       	mov.b	r11,	r12	;
    45be:	0d 43       	clr	r13		;
    45c0:	0a 4c       	mov	r12,	r10	;
    45c2:	3a 50 a5 b5 	add	#-19035,r10	;#0xb5a5
    45c6:	81 4a 00 00 	mov	r10,	0(r1)	;
    45ca:	0e 4d       	mov	r13,	r14	;
    45cc:	2e 63       	addc	#2,	r14	;r3 As==10
    45ce:	81 4e 02 00 	mov	r14,	2(r1)	;
    45d2:	2e 41       	mov	@r1,	r14	;
    45d4:	1f 41 02 00 	mov	2(r1),	r15	;
    45d8:	0e 5e       	rla	r14		;
    45da:	0f 6f       	rlc	r15		;
    45dc:	0e 5e       	rla	r14		;
    45de:	0f 6f       	rlc	r15		;
    45e0:	0e 5e       	rla	r14		;
    45e2:	0f 6f       	rlc	r15		;
    45e4:	0e 5e       	rla	r14		;
    45e6:	0f 6f       	rlc	r15		;
    45e8:	0e 5e       	rla	r14		;
    45ea:	0f 6f       	rlc	r15		;
    45ec:	0c 4b       	mov	r11,	r12	;
    45ee:	47 19 0c 10 	rpt #8 { rrux.w	r12		;
    45f2:	0d 43       	clr	r13		;
    45f4:	0c 5a       	add	r10,	r12	;
    45f6:	0c 5e       	add	r14,	r12	;
    45f8:	0a 4c       	mov	r12,	r10	;
    45fa:	06 4c       	mov	r12,	r6	;
    45fc:	76 f0 ff 00 	and.b	#255,	r6	;#0x00ff
    4600:	0d 46       	mov	r6,	r13	;
    4602:	5d 02       	rlam	#1,	r13	;
    4604:	04 4d       	mov	r13,	r4	;
    4606:	34 50 02 1c 	add	#7170,	r4	;#0x1c02
    460a:	15 4d 02 1c 	mov	7170(r13),r5	;0x01c02
    460e:	05 93       	cmp	#0,	r5	;r3 As==00
    4610:	34 22       	jnz	$-918    	;abs 0x427a
    4612:	8d 4c 02 1c 	mov	r12,	7170(r13); 0x1c02
    4616:	37 53       	add	#-1,	r7	;r3 As==11
    4618:	07 93       	cmp	#0,	r7	;r3 As==00
    461a:	cc 23       	jnz	$-102    	;abs 0x45b4
    461c:	81 93 2a 00 	cmp	#0,	42(r1)	;r3 As==00, 0x002a
    4620:	03 24       	jz	$+8      	;abs 0x4628
    4622:	92 41 08 00 	mov	8(r1),	&0x1c00	;
    4626:	00 1c 
    4628:	b0 12 78 40 	call	#16504		;#0x4078
    462c:	81 43 34 00 	mov	#0,	52(r1)	;r3 As==00, 0x0034
    4630:	b0 12 5c 40 	call	#16476		;#0x405c
    4634:	79 40 80 00 	mov.b	#128,	r9	;#0x0080
    4638:	5a 43       	mov.b	#1,	r10	;r3 As==01
    463a:	05 49       	mov	r9,	r5	;
    463c:	07 3c       	jmp	$+16     	;abs 0x464c
    463e:	5c 02       	rlam	#1,	r12	;
    4640:	14 9c 02 1c 	cmp	7170(r12),r4	;0x01c02
    4644:	45 24       	jz	$+140    	;abs 0x46d0
    4646:	35 53       	add	#-1,	r5	;r3 As==11
    4648:	05 93       	cmp	#0,	r5	;r3 As==00
    464a:	47 24       	jz	$+144    	;abs 0x46da
    464c:	1a 53       	inc	r10		;
    464e:	0c 4a       	mov	r10,	r12	;
    4650:	5c 0e       	rlam	#4,	r12	;
    4652:	0a 5c       	add	r12,	r10	;
    4654:	4c 4a       	mov.b	r10,	r12	;
    4656:	0d 43       	clr	r13		;
    4658:	06 4c       	mov	r12,	r6	;
    465a:	36 50 a5 b5 	add	#-19035,r6	;#0xb5a5
    465e:	07 4d       	mov	r13,	r7	;
    4660:	27 63       	addc	#2,	r7	;r3 As==10
    4662:	0c 46       	mov	r6,	r12	;
    4664:	0d 47       	mov	r7,	r13	;
    4666:	0c 5c       	rla	r12		;
    4668:	0d 6d       	rlc	r13		;
    466a:	0c 5c       	rla	r12		;
    466c:	0d 6d       	rlc	r13		;
    466e:	0c 5c       	rla	r12		;
    4670:	0d 6d       	rlc	r13		;
    4672:	0c 5c       	rla	r12		;
    4674:	0d 6d       	rlc	r13		;
    4676:	0c 5c       	rla	r12		;
    4678:	0d 6d       	rlc	r13		;
    467a:	0e 4a       	mov	r10,	r14	;
    467c:	47 19 0e 10 	rpt #8 { rrux.w	r14		;
    4680:	0f 43       	clr	r15		;
    4682:	0e 56       	add	r6,	r14	;
    4684:	0c 5e       	add	r14,	r12	;
    4686:	04 4c       	mov	r12,	r4	;
    4688:	7c f0 ff 00 	and.b	#255,	r12	;#0x00ff
    468c:	08 4c       	mov	r12,	r8	;
    468e:	38 50 a5 b5 	add	#-19035,r8	;#0xb5a5
    4692:	4c 43       	clr.b	r12		;
    4694:	09 4c       	mov	r12,	r9	;
    4696:	29 63       	addc	#2,	r9	;r3 As==10
    4698:	0e 48       	mov	r8,	r14	;
    469a:	0f 49       	mov	r9,	r15	;
    469c:	0e 5e       	rla	r14		;
    469e:	0f 6f       	rlc	r15		;
    46a0:	0e 5e       	rla	r14		;
    46a2:	0f 6f       	rlc	r15		;
    46a4:	0e 5e       	rla	r14		;
    46a6:	0f 6f       	rlc	r15		;
    46a8:	0e 5e       	rla	r14		;
    46aa:	0f 6f       	rlc	r15		;
    46ac:	0e 5e       	rla	r14		;
    46ae:	0f 6f       	rlc	r15		;
    46b0:	0c 44       	mov	r4,	r12	;
    46b2:	47 19 0c 10 	rpt #8 { rrux.w	r12		;
    46b6:	0d 43       	clr	r13		;
    46b8:	0c 5e       	add	r14,	r12	;
    46ba:	0c 58       	add	r8,	r12	;
    46bc:	0c e4       	xor	r4,	r12	;
    46be:	7c f0 ff 00 	and.b	#255,	r12	;#0x00ff
    46c2:	0d 44       	mov	r4,	r13	;
    46c4:	7d f0 ff 00 	and.b	#255,	r13	;#0x00ff
    46c8:	5d 02       	rlam	#1,	r13	;
    46ca:	14 9d 02 1c 	cmp	7170(r13),r4	;0x01c02
    46ce:	b7 23       	jnz	$-144    	;abs 0x463e
    46d0:	91 53 34 00 	inc	52(r1)		;
    46d4:	35 53       	add	#-1,	r5	;r3 As==11
    46d6:	05 93       	cmp	#0,	r5	;r3 As==00
    46d8:	b9 23       	jnz	$-140    	;abs 0x464c
    46da:	b0 12 78 40 	call	#16504		;#0x4078
    46de:	b0 12 b0 40 	call	#16560		;#0x40b0
    46e2:	4c 43       	clr.b	r12		;
    46e4:	31 50 36 00 	add	#54,	r1	;#0x0036
    46e8:	64 17       	popm	#7,	r10	;16-bit words
    46ea:	30 41       	ret			
    46ec:	8e 4c 02 1c 	mov	r12,	7170(r14); 0x1c02
    46f0:	5e 3f       	jmp	$-322    	;abs 0x45ae
    46f2:	91 43 2a 00 	mov	#1,	42(r1)	;r3 As==01, 0x002a
    46f6:	5b 3f       	jmp	$-328    	;abs 0x45ae

000046f8 <memcpy>:
    46f8:	0f 4c       	mov	r12,	r15	;
    46fa:	0e 5d       	add	r13,	r14	;
    46fc:	0d 9e       	cmp	r14,	r13	;
    46fe:	01 20       	jnz	$+4      	;abs 0x4702
    4700:	30 41       	ret			
    4702:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    4706:	1f 53       	inc	r15		;
    4708:	f9 3f       	jmp	$-12     	;abs 0x46fc

0000470a <memset>:
    470a:	0e 5c       	add	r12,	r14	;
    470c:	0f 4c       	mov	r12,	r15	;
    470e:	0f 9e       	cmp	r14,	r15	;
    4710:	01 20       	jnz	$+4      	;abs 0x4714
    4712:	30 41       	ret			
    4714:	1f 53       	inc	r15		;
    4716:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    471a:	f9 3f       	jmp	$-12     	;abs 0x470e

0000471c <_exit>:
    471c:	ff 3f       	jmp	$+0      	;abs 0x471c
