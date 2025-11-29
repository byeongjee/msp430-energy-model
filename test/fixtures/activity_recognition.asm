
/Users/byeongjee/migration/probabilistic-energy-modeling/build/activity_recognition.elf:     file format elf32-msp430


Disassembly of section .text:

00004166 <__crt0_start>:
    4166:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

0000416a <__crt0_init_bss>:
    416a:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02

0000416e <.Loc.76.1>:
    416e:	0d 43       	clr	r13		;

00004170 <.Loc.77.1>:
    4170:	3e 40 82 00 	mov	#130,	r14	;#0x0082

00004174 <.Loc.81.1>:
    4174:	b0 12 04 67 	call	#26372		;#0x6704

00004178 <__crt0_movedata>:
    4178:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

0000417c <.Loc.116.1>:
    417c:	3d 40 62 41 	mov	#16738,	r13	;#0x4162

00004180 <.Loc.119.1>:
    4180:	0d 9c       	cmp	r12,	r13	;

00004182 <.Loc.120.1>:
    4182:	04 24       	jz	$+10     	;abs 0x418c

00004184 <.Loc.122.1>:
    4184:	3e 40 02 00 	mov	#2,	r14	;

00004188 <.Loc.124.1>:
    4188:	b0 12 c8 66 	call	#26312		;#0x66c8

0000418c <__crt0_call_main>:
    418c:	0c 43       	clr	r12		;

0000418e <.Loc.254.1>:
    418e:	b0 12 0a 43 	call	#17162		;#0x430a

00004192 <__crt0_call_exit>:
    4192:	b0 12 c6 66 	call	#26310		;#0x66c6

00004196 <clockSetup>:
    4196:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    419a:	61 01 

0000419c <.Loc.84.1>:
    419c:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00

000041a0 <.Loc.86.1>:
    41a0:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    41a4:	64 01 

000041a6 <.Loc.91.1>:
    41a6:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    41aa:	66 01 

000041ac <.Loc.92.1>:
    41ac:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    41b0:	62 01 

000041b2 <.Loc.94.1>:
    41b2:	0d 14       	pushm.a	#1,	r13	;20-bit words
    41b4:	3d 40 10 00 	mov	#16,	r13	;#0x0010

000041b8 <.L1^B1>:
    41b8:	1d 83       	dec	r13		;
    41ba:	fe 23       	jnz	$-2      	;abs 0x41b8
    41bc:	0d 16       	popm.a	#1,	r13	;20-bit words

000041be <L0^A>:
    41be:	00 3c       	jmp	$+2      	;abs 0x41c0

000041c0 <.Loc.97.1>:
    41c0:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00

000041c4 <.Loc.100.1>:
    41c4:	1c 42 68 01 	mov	&0x0168,r12	;0x0168
    41c8:	3c c2       	bic	#8,	r12	;r2 As==11
    41ca:	82 4c 68 01 	mov	r12,	&0x0168	;

000041ce <.Loc.101.1>:
    41ce:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00

000041d2 <.Loc.102.1>:
    41d2:	03 43       	nop			
    41d4:	30 41       	ret			

000041d6 <toggle_gpio>:
    41d6:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    41da:	7c e2       	xor.b	#8,	r12	;r2 As==11
    41dc:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    41e0:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000041e4 <.Loc.104.1>:
    41e4:	03 43       	nop			
    41e6:	30 41       	ret			

000041e8 <begin_event>:
    41e8:	1e 14       	pushm.a	#2,	r14	;20-bit words
    41ea:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    41ee:	3e 40 05 00 	mov	#5,	r14	;

000041f2 <.L1^B2>:
    41f2:	1d 83       	dec	r13		;
    41f4:	0e 73       	sbc	r14		;
    41f6:	fd 23       	jnz	$-4      	;abs 0x41f2
    41f8:	0d 93       	cmp	#0,	r13	;r3 As==00
    41fa:	fb 23       	jnz	$-8      	;abs 0x41f2
    41fc:	1d 16       	popm.a	#2,	r14	;20-bit words

000041fe <.Loc.108.1>:
    41fe:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4202:	7c d2       	bis.b	#8,	r12	;r2 As==11
    4204:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4208:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

0000420c <.Loc.109.1>:
    420c:	03 43       	nop			
    420e:	30 41       	ret			

00004210 <end_event>:
    4210:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4214:	7c c2       	bic.b	#8,	r12	;r2 As==11
    4216:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    421a:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

0000421e <.Loc.112.1>:
    421e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4220:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4224:	3e 40 05 00 	mov	#5,	r14	;

00004228 <.L1^B3>:
    4228:	1d 83       	dec	r13		;
    422a:	0e 73       	sbc	r14		;
    422c:	fd 23       	jnz	$-4      	;abs 0x4228
    422e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4230:	fb 23       	jnz	$-8      	;abs 0x4228
    4232:	1d 16       	popm.a	#2,	r14	;20-bit words

00004234 <.Loc.113.1>:
    4234:	03 43       	nop			
    4236:	30 41       	ret			

00004238 <begin_measurement_window>:
    4238:	1e 14       	pushm.a	#2,	r14	;20-bit words
    423a:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    423e:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004242 <.L1^B4>:
    4242:	1d 83       	dec	r13		;
    4244:	0e 73       	sbc	r14		;
    4246:	fd 23       	jnz	$-4      	;abs 0x4242
    4248:	0d 93       	cmp	#0,	r13	;r3 As==00
    424a:	fb 23       	jnz	$-8      	;abs 0x4242
    424c:	1d 16       	popm.a	#2,	r14	;20-bit words

0000424e <.Loc.117.1>:
    424e:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4252:	6c d2       	bis.b	#4,	r12	;r2 As==10
    4254:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4258:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

0000425c <.Loc.118.1>:
    425c:	03 43       	nop			
    425e:	30 41       	ret			

00004260 <end_measurement_window>:
    4260:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4264:	6c c2       	bic.b	#4,	r12	;r2 As==10
    4266:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    426a:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

0000426e <.Loc.121.1>:
    426e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4270:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    4274:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004278 <.L1^B5>:
    4278:	1d 83       	dec	r13		;
    427a:	0e 73       	sbc	r14		;
    427c:	fd 23       	jnz	$-4      	;abs 0x4278
    427e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4280:	fb 23       	jnz	$-8      	;abs 0x4278
    4282:	1d 16       	popm.a	#2,	r14	;20-bit words

00004284 <.Loc.122.1>:
    4284:	03 43       	nop			
    4286:	30 41       	ret			

00004288 <delay>:
    4288:	21 82       	sub	#4,	r1	;r2 As==10

0000428a <.LCFI0>:
    428a:	81 4c 00 00 	mov	r12,	0(r1)	;
    428e:	81 4d 02 00 	mov	r13,	2(r1)	;

00004292 <.Loc.125.1>:
    4292:	01 3c       	jmp	$+4      	;abs 0x4296

00004294 <.L9>:
    4294:	03 43       	nop			

00004296 <.L8>:
    4296:	b1 53 00 00 	add	#-1,	0(r1)	;r3 As==11
    429a:	b1 63 02 00 	addc	#-1,	2(r1)	;r3 As==11
    429e:	2c 41       	mov	@r1,	r12	;
    42a0:	1c d1 02 00 	bis	2(r1),	r12	;
    42a4:	0c 93       	cmp	#0,	r12	;r3 As==00
    42a6:	f6 23       	jnz	$-18     	;abs 0x4294

000042a8 <.Loc.128.1>:
    42a8:	03 43       	nop			
    42aa:	03 43       	nop			
    42ac:	21 52       	add	#4,	r1	;r2 As==10

000042ae <.LCFI1>:
    42ae:	30 41       	ret			

000042b0 <initialize>:
    42b0:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    42b4:	5c 01 

000042b6 <.Loc.207.1>:
    42b6:	1c 42 30 01 	mov	&0x0130,r12	;0x0130
    42ba:	1c c3       	bic	#1,	r12	;r3 As==01
    42bc:	82 4c 30 01 	mov	r12,	&0x0130	;

000042c0 <.Loc.209.1>:
    42c0:	b0 12 96 41 	call	#16790		;#0x4196

000042c4 <.Loc.212.1>:
    42c4:	5c 42 04 02 	mov.b	&0x0204,r12	;0x0204
    42c8:	7c d0 0c 00 	bis.b	#12,	r12	;#0x000c
    42cc:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    42d0:	c2 4c 04 02 	mov.b	r12,	&0x0204	;

000042d4 <.Loc.213.1>:
    42d4:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    42d8:	7c c2       	bic.b	#8,	r12	;r2 As==11
    42da:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    42de:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000042e2 <.Loc.214.1>:
    42e2:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    42e6:	6c c2       	bic.b	#4,	r12	;r2 As==10
    42e8:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    42ec:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000042f0 <.Loc.216.1>:
    42f0:	1e 14       	pushm.a	#2,	r14	;20-bit words
    42f2:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    42f6:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000042fa <.L1^B6>:
    42fa:	1d 83       	dec	r13		;
    42fc:	0e 73       	sbc	r14		;
    42fe:	fd 23       	jnz	$-4      	;abs 0x42fa
    4300:	0d 93       	cmp	#0,	r13	;r3 As==00
    4302:	fb 23       	jnz	$-8      	;abs 0x42fa
    4304:	1d 16       	popm.a	#2,	r14	;20-bit words

00004306 <.Loc.226.1>:
    4306:	03 43       	nop			
    4308:	30 41       	ret			

0000430a <main>:
    430a:	0a 15       	pushm	#1,	r10	;16-bit words

0000430c <.LCFI2>:
    430c:	31 80 46 01 	sub	#326,	r1	;#0x0146

00004310 <.LCFI3>:
    4310:	b0 12 b0 42 	call	#17072		;#0x42b0

00004314 <.Loc.297.2>:
    4314:	5c 42 04 02 	mov.b	&0x0204,r12	;0x0204
    4318:	7c d0 03 00 	bis.b	#3,	r12	;
    431c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4320:	c2 4c 04 02 	mov.b	r12,	&0x0204	;

00004324 <.Loc.298.2>:
    4324:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4328:	7c f0 fc ff 	and.b	#-4,	r12	;#0xfffc
    432c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4330:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004334 <.LBB234>:
    4334:	03 43       	nop			

00004336 <.LBE234>:
    4336:	03 43       	nop			
    4338:	32 d2       	eint			
    433a:	03 43       	nop			

0000433c <.Loc.304.2>:
    433c:	b0 12 38 42 	call	#16952		;#0x4238

00004340 <.Loc.311.2>:
    4340:	82 43 82 1c 	mov	#0,	&0x1c82	;r3 As==00

00004344 <.Loc.312.2>:
    4344:	b0 12 e8 41 	call	#16872		;#0x41e8
    4348:	b1 40 02 1c 	mov	#7170,	244(r1)	;#0x1c02, 0x00f4
    434c:	f4 00 

0000434e <.LBB236>:
    434e:	81 43 f2 00 	mov	#0,	242(r1)	;r3 As==00, 0x00f2

00004352 <.Loc.206.2>:
    4352:	e5 3c       	jmp	$+460    	;abs 0x451e

00004354 <.L33>:
    4354:	3c 40 46 01 	mov	#326,	r12	;#0x0146
    4358:	0c 51       	add	r1,	r12	;
    435a:	3c 50 e6 fe 	add	#-282,	r12	;#0xfee6
    435e:	81 4c f0 00 	mov	r12,	240(r1)	; 0x00f0

00004362 <.LBB240>:
    4362:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82

00004366 <.Loc.96.2>:
    4366:	0c 93       	cmp	#0,	r12	;r3 As==00
    4368:	6d 20       	jnz	$+220    	;abs 0x4444

0000436a <.LBB242>:
    436a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    436e:	5c f3       	and.b	#1,	r12	;r3 As==01

00004370 <.Loc.26.2>:
    4370:	0c 93       	cmp	#0,	r12	;r3 As==00
    4372:	08 24       	jz	$+18     	;abs 0x4384

00004374 <.Loc.27.2>:
    4374:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4378:	5c 03       	rrum	#1,	r12	;

0000437a <.Loc.27.2>:
    437a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

0000437e <.Loc.27.2>:
    437e:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4382:	05 3c       	jmp	$+12     	;abs 0x438e

00004384 <.L14>:
    4384:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4388:	5c 03       	rrum	#1,	r12	;
    438a:	82 4c 00 1c 	mov	r12,	&0x1c00	;

0000438e <.L15>:
    438e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004392 <.LBE242>:
    4392:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4396:	7c f0 03 00 	and.b	#3,	r12	;
    439a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

0000439e <.Loc.98.2>:
    439e:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    43a2:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    43a6:	4d 4c       	mov.b	r12,	r13	;
    43a8:	8d 11       	sxt	r13		;

000043aa <.Loc.98.2>:
    43aa:	1c 41 f0 00 	mov	240(r1),r12	;0x000f0
    43ae:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

000043b2 <.LBB244>:
    43b2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    43b6:	5c f3       	and.b	#1,	r12	;r3 As==01

000043b8 <.Loc.26.2>:
    43b8:	0c 93       	cmp	#0,	r12	;r3 As==00
    43ba:	08 24       	jz	$+18     	;abs 0x43cc

000043bc <.Loc.27.2>:
    43bc:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    43c0:	5c 03       	rrum	#1,	r12	;

000043c2 <.Loc.27.2>:
    43c2:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000043c6 <.Loc.27.2>:
    43c6:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    43ca:	05 3c       	jmp	$+12     	;abs 0x43d6

000043cc <.L17>:
    43cc:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    43d0:	5c 03       	rrum	#1,	r12	;
    43d2:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000043d6 <.L18>:
    43d6:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000043da <.LBE244>:
    43da:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    43de:	7c f0 03 00 	and.b	#3,	r12	;
    43e2:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

000043e6 <.Loc.99.2>:
    43e6:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    43ea:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    43ee:	4d 4c       	mov.b	r12,	r13	;
    43f0:	8d 11       	sxt	r13		;

000043f2 <.Loc.99.2>:
    43f2:	1c 41 f0 00 	mov	240(r1),r12	;0x000f0
    43f6:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

000043fa <.LBB246>:
    43fa:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    43fe:	5c f3       	and.b	#1,	r12	;r3 As==01

00004400 <.Loc.26.2>:
    4400:	0c 93       	cmp	#0,	r12	;r3 As==00
    4402:	08 24       	jz	$+18     	;abs 0x4414

00004404 <.Loc.27.2>:
    4404:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4408:	5c 03       	rrum	#1,	r12	;

0000440a <.Loc.27.2>:
    440a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

0000440e <.Loc.27.2>:
    440e:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4412:	05 3c       	jmp	$+12     	;abs 0x441e

00004414 <.L20>:
    4414:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4418:	5c 03       	rrum	#1,	r12	;
    441a:	82 4c 00 1c 	mov	r12,	&0x1c00	;

0000441e <.L21>:
    441e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004422 <.LBE246>:
    4422:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4426:	7c f0 03 00 	and.b	#3,	r12	;
    442a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

0000442e <.Loc.100.2>:
    442e:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    4432:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4436:	4d 4c       	mov.b	r12,	r13	;
    4438:	8d 11       	sxt	r13		;

0000443a <.Loc.100.2>:
    443a:	1c 41 f0 00 	mov	240(r1),r12	;0x000f0
    443e:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

00004442 <.Loc.107.2>:
    4442:	6c 3c       	jmp	$+218    	;abs 0x451c

00004444 <.L13>:
    4444:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4448:	5c f3       	and.b	#1,	r12	;r3 As==01

0000444a <.Loc.26.2>:
    444a:	0c 93       	cmp	#0,	r12	;r3 As==00
    444c:	08 24       	jz	$+18     	;abs 0x445e

0000444e <.Loc.27.2>:
    444e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4452:	5c 03       	rrum	#1,	r12	;

00004454 <.Loc.27.2>:
    4454:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004458 <.Loc.27.2>:
    4458:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    445c:	05 3c       	jmp	$+12     	;abs 0x4468

0000445e <.L24>:
    445e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4462:	5c 03       	rrum	#1,	r12	;
    4464:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004468 <.L25>:
    4468:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

0000446c <.LBE248>:
    446c:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4470:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004474 <.Loc.103.2>:
    4474:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4478:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    447c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4480:	4d 4c       	mov.b	r12,	r13	;
    4482:	8d 11       	sxt	r13		;

00004484 <.Loc.103.2>:
    4484:	1c 41 f0 00 	mov	240(r1),r12	;0x000f0
    4488:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

0000448c <.LBB250>:
    448c:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4490:	5c f3       	and.b	#1,	r12	;r3 As==01

00004492 <.Loc.26.2>:
    4492:	0c 93       	cmp	#0,	r12	;r3 As==00
    4494:	08 24       	jz	$+18     	;abs 0x44a6

00004496 <.Loc.27.2>:
    4496:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    449a:	5c 03       	rrum	#1,	r12	;

0000449c <.Loc.27.2>:
    449c:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000044a0 <.Loc.27.2>:
    44a0:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    44a4:	05 3c       	jmp	$+12     	;abs 0x44b0

000044a6 <.L27>:
    44a6:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    44aa:	5c 03       	rrum	#1,	r12	;
    44ac:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000044b0 <.L28>:
    44b0:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000044b4 <.LBE250>:
    44b4:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    44b8:	b0 12 fc 5d 	call	#24060		;#0x5dfc

000044bc <.Loc.104.2>:
    44bc:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    44c0:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    44c4:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    44c8:	4d 4c       	mov.b	r12,	r13	;
    44ca:	8d 11       	sxt	r13		;

000044cc <.Loc.104.2>:
    44cc:	1c 41 f0 00 	mov	240(r1),r12	;0x000f0
    44d0:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

000044d4 <.LBB252>:
    44d4:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    44d8:	5c f3       	and.b	#1,	r12	;r3 As==01

000044da <.Loc.26.2>:
    44da:	0c 93       	cmp	#0,	r12	;r3 As==00
    44dc:	08 24       	jz	$+18     	;abs 0x44ee

000044de <.Loc.27.2>:
    44de:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    44e2:	5c 03       	rrum	#1,	r12	;

000044e4 <.Loc.27.2>:
    44e4:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000044e8 <.Loc.27.2>:
    44e8:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    44ec:	05 3c       	jmp	$+12     	;abs 0x44f8

000044ee <.L30>:
    44ee:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    44f2:	5c 03       	rrum	#1,	r12	;
    44f4:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000044f8 <.L31>:
    44f8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000044fc <.LBE252>:
    44fc:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4500:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004504 <.Loc.105.2>:
    4504:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4508:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    450c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4510:	4d 4c       	mov.b	r12,	r13	;
    4512:	8d 11       	sxt	r13		;

00004514 <.Loc.105.2>:
    4514:	1c 41 f0 00 	mov	240(r1),r12	;0x000f0
    4518:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

0000451c <.L222>:
    451c:	03 43       	nop			

0000451e <.L12>:
    451e:	1c 41 f2 00 	mov	242(r1),r12	;0x000f2
    4522:	0d 4c       	mov	r12,	r13	;
    4524:	1d 53       	inc	r13		;
    4526:	81 4d f2 00 	mov	r13,	242(r1)	; 0x00f2

0000452a <.Loc.206.2>:
    452a:	6d 43       	mov.b	#2,	r13	;r3 As==10
    452c:	0d 9c       	cmp	r12,	r13	;
    452e:	12 2f       	jc	$-474    	;abs 0x4354

00004530 <.Loc.209.2>:
    4530:	03 43       	nop			

00004532 <.LBE238>:
    4532:	81 43 ee 00 	mov	#0,	238(r1)	;r3 As==00, 0x00ee

00004536 <.Loc.218.2>:
    4536:	30 40 dc 4b 	br	#0x4bdc		;

0000453a <.L76>:
    453a:	3e 40 46 01 	mov	#326,	r14	;#0x0146
    453e:	0e 51       	add	r1,	r14	;
    4540:	3e 50 f1 fe 	add	#-271,	r14	;#0xfef1
    4544:	81 4e ec 00 	mov	r14,	236(r1)	; 0x00ec

00004548 <.LBB254>:
    4548:	81 43 ea 00 	mov	#0,	234(r1)	;r3 As==00, 0x00ea

0000454c <.Loc.115.2>:
    454c:	fd 3c       	jmp	$+508    	;abs 0x4748

0000454e <.L56>:
    454e:	3f 40 46 01 	mov	#326,	r15	;#0x0146
    4552:	0f 51       	add	r1,	r15	;
    4554:	3f 50 e9 fe 	add	#-279,	r15	;#0xfee9
    4558:	81 4f e8 00 	mov	r15,	232(r1)	; 0x00e8

0000455c <.LBB256>:
    455c:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82

00004560 <.Loc.96.2>:
    4560:	0c 93       	cmp	#0,	r12	;r3 As==00
    4562:	6d 20       	jnz	$+220    	;abs 0x463e

00004564 <.LBB258>:
    4564:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4568:	5c f3       	and.b	#1,	r12	;r3 As==01

0000456a <.Loc.26.2>:
    456a:	0c 93       	cmp	#0,	r12	;r3 As==00
    456c:	08 24       	jz	$+18     	;abs 0x457e

0000456e <.Loc.27.2>:
    456e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4572:	5c 03       	rrum	#1,	r12	;

00004574 <.Loc.27.2>:
    4574:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004578 <.Loc.27.2>:
    4578:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    457c:	05 3c       	jmp	$+12     	;abs 0x4588

0000457e <.L37>:
    457e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4582:	5c 03       	rrum	#1,	r12	;
    4584:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004588 <.L38>:
    4588:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

0000458c <.LBE258>:
    458c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4590:	7c f0 03 00 	and.b	#3,	r12	;
    4594:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004598 <.Loc.98.2>:
    4598:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    459c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    45a0:	4d 4c       	mov.b	r12,	r13	;
    45a2:	8d 11       	sxt	r13		;

000045a4 <.Loc.98.2>:
    45a4:	1c 41 e8 00 	mov	232(r1),r12	;0x000e8
    45a8:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

000045ac <.LBB260>:
    45ac:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    45b0:	5c f3       	and.b	#1,	r12	;r3 As==01

000045b2 <.Loc.26.2>:
    45b2:	0c 93       	cmp	#0,	r12	;r3 As==00
    45b4:	08 24       	jz	$+18     	;abs 0x45c6

000045b6 <.Loc.27.2>:
    45b6:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    45ba:	5c 03       	rrum	#1,	r12	;

000045bc <.Loc.27.2>:
    45bc:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000045c0 <.Loc.27.2>:
    45c0:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    45c4:	05 3c       	jmp	$+12     	;abs 0x45d0

000045c6 <.L40>:
    45c6:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    45ca:	5c 03       	rrum	#1,	r12	;
    45cc:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000045d0 <.L41>:
    45d0:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000045d4 <.LBE260>:
    45d4:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    45d8:	7c f0 03 00 	and.b	#3,	r12	;
    45dc:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

000045e0 <.Loc.99.2>:
    45e0:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    45e4:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    45e8:	4d 4c       	mov.b	r12,	r13	;
    45ea:	8d 11       	sxt	r13		;

000045ec <.Loc.99.2>:
    45ec:	1c 41 e8 00 	mov	232(r1),r12	;0x000e8
    45f0:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

000045f4 <.LBB262>:
    45f4:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    45f8:	5c f3       	and.b	#1,	r12	;r3 As==01

000045fa <.Loc.26.2>:
    45fa:	0c 93       	cmp	#0,	r12	;r3 As==00
    45fc:	08 24       	jz	$+18     	;abs 0x460e

000045fe <.Loc.27.2>:
    45fe:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4602:	5c 03       	rrum	#1,	r12	;

00004604 <.Loc.27.2>:
    4604:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004608 <.Loc.27.2>:
    4608:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    460c:	05 3c       	jmp	$+12     	;abs 0x4618

0000460e <.L43>:
    460e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4612:	5c 03       	rrum	#1,	r12	;
    4614:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004618 <.L44>:
    4618:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

0000461c <.LBE262>:
    461c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4620:	7c f0 03 00 	and.b	#3,	r12	;
    4624:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004628 <.Loc.100.2>:
    4628:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    462c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4630:	4d 4c       	mov.b	r12,	r13	;
    4632:	8d 11       	sxt	r13		;

00004634 <.Loc.100.2>:
    4634:	1c 41 e8 00 	mov	232(r1),r12	;0x000e8
    4638:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

0000463c <.Loc.107.2>:
    463c:	6c 3c       	jmp	$+218    	;abs 0x4716

0000463e <.L36>:
    463e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4642:	5c f3       	and.b	#1,	r12	;r3 As==01

00004644 <.Loc.26.2>:
    4644:	0c 93       	cmp	#0,	r12	;r3 As==00
    4646:	08 24       	jz	$+18     	;abs 0x4658

00004648 <.Loc.27.2>:
    4648:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    464c:	5c 03       	rrum	#1,	r12	;

0000464e <.Loc.27.2>:
    464e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004652 <.Loc.27.2>:
    4652:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4656:	05 3c       	jmp	$+12     	;abs 0x4662

00004658 <.L47>:
    4658:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    465c:	5c 03       	rrum	#1,	r12	;
    465e:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004662 <.L48>:
    4662:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004666 <.LBE264>:
    4666:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    466a:	b0 12 fc 5d 	call	#24060		;#0x5dfc

0000466e <.Loc.103.2>:
    466e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4672:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4676:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    467a:	4d 4c       	mov.b	r12,	r13	;
    467c:	8d 11       	sxt	r13		;

0000467e <.Loc.103.2>:
    467e:	1c 41 e8 00 	mov	232(r1),r12	;0x000e8
    4682:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

00004686 <.LBB266>:
    4686:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    468a:	5c f3       	and.b	#1,	r12	;r3 As==01

0000468c <.Loc.26.2>:
    468c:	0c 93       	cmp	#0,	r12	;r3 As==00
    468e:	08 24       	jz	$+18     	;abs 0x46a0

00004690 <.Loc.27.2>:
    4690:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4694:	5c 03       	rrum	#1,	r12	;

00004696 <.Loc.27.2>:
    4696:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

0000469a <.Loc.27.2>:
    469a:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    469e:	05 3c       	jmp	$+12     	;abs 0x46aa

000046a0 <.L50>:
    46a0:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    46a4:	5c 03       	rrum	#1,	r12	;
    46a6:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000046aa <.L51>:
    46aa:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000046ae <.LBE266>:
    46ae:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    46b2:	b0 12 fc 5d 	call	#24060		;#0x5dfc

000046b6 <.Loc.104.2>:
    46b6:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    46ba:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    46be:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    46c2:	4d 4c       	mov.b	r12,	r13	;
    46c4:	8d 11       	sxt	r13		;

000046c6 <.Loc.104.2>:
    46c6:	1c 41 e8 00 	mov	232(r1),r12	;0x000e8
    46ca:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

000046ce <.LBB268>:
    46ce:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    46d2:	5c f3       	and.b	#1,	r12	;r3 As==01

000046d4 <.Loc.26.2>:
    46d4:	0c 93       	cmp	#0,	r12	;r3 As==00
    46d6:	08 24       	jz	$+18     	;abs 0x46e8

000046d8 <.Loc.27.2>:
    46d8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    46dc:	5c 03       	rrum	#1,	r12	;

000046de <.Loc.27.2>:
    46de:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000046e2 <.Loc.27.2>:
    46e2:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    46e6:	05 3c       	jmp	$+12     	;abs 0x46f2

000046e8 <.L53>:
    46e8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    46ec:	5c 03       	rrum	#1,	r12	;
    46ee:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000046f2 <.L54>:
    46f2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000046f6 <.LBE268>:
    46f6:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    46fa:	b0 12 fc 5d 	call	#24060		;#0x5dfc

000046fe <.Loc.105.2>:
    46fe:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4702:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4706:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    470a:	4d 4c       	mov.b	r12,	r13	;
    470c:	8d 11       	sxt	r13		;

0000470e <.Loc.105.2>:
    470e:	1c 41 e8 00 	mov	232(r1),r12	;0x000e8
    4712:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

00004716 <.L223>:
    4716:	03 43       	nop			

00004718 <.LBE256>:
    4718:	1d 41 ea 00 	mov	234(r1),r13	;0x000ea
    471c:	0c 4d       	mov	r13,	r12	;
    471e:	1c 53       	inc	r12		;
    4720:	81 4c ea 00 	mov	r12,	234(r1)	; 0x00ea

00004724 <.Loc.117.2>:
    4724:	0c 4d       	mov	r13,	r12	;
    4726:	5c 02       	rlam	#1,	r12	;
    4728:	0c 5d       	add	r13,	r12	;
    472a:	1d 41 ec 00 	mov	236(r1),r13	;0x000ec
    472e:	0d 5c       	add	r12,	r13	;

00004730 <.Loc.117.2>:
    4730:	0c 41       	mov	r1,	r12	;
    4732:	3c 50 2f 00 	add	#47,	r12	;#0x002f
    4736:	ed 4c 00 00 	mov.b	@r12,	0(r13)	;
    473a:	1c 53       	inc	r12		;
    473c:	ed 4c 01 00 	mov.b	@r12,	1(r13)	;
    4740:	1c 53       	inc	r12		;
    4742:	ed 4c 02 00 	mov.b	@r12,	2(r13)	;
    4746:	1c 53       	inc	r12		;

00004748 <.L35>:
    4748:	6c 43       	mov.b	#2,	r12	;r3 As==10
    474a:	1c 91 ea 00 	cmp	234(r1),r12	;0x000ea
    474e:	ff 2e       	jc	$-512    	;abs 0x454e

00004750 <.Loc.119.2>:
    4750:	03 43       	nop			
    4752:	3d 40 46 01 	mov	#326,	r13	;#0x0146
    4756:	0d 51       	add	r1,	r13	;
    4758:	3d 50 f1 fe 	add	#-271,	r13	;#0xfef1
    475c:	81 4d e6 00 	mov	r13,	230(r1)	; 0x00e6

00004760 <.LBB270>:
    4760:	81 43 e4 00 	mov	#0,	228(r1)	;r3 As==00, 0x00e4

00004764 <.Loc.123.2>:
    4764:	81 43 e4 00 	mov	#0,	228(r1)	;r3 As==00, 0x00e4

00004768 <.Loc.123.2>:
    4768:	44 3c       	jmp	$+138    	;abs 0x47f2

0000476a <.L61>:
    476a:	1d 41 e4 00 	mov	228(r1),r13	;0x000e4
    476e:	0c 4d       	mov	r13,	r12	;
    4770:	5c 02       	rlam	#1,	r12	;
    4772:	0c 5d       	add	r13,	r12	;

00004774 <.Loc.124.2>:
    4774:	1e 41 e6 00 	mov	230(r1),r14	;0x000e6
    4778:	0e 5c       	add	r12,	r14	;
    477a:	81 4e e2 00 	mov	r14,	226(r1)	; 0x00e2

0000477e <.Loc.127.2>:
    477e:	1c 41 e2 00 	mov	226(r1),r12	;0x000e2
    4782:	6c 4c       	mov.b	@r12,	r12	;
    4784:	8c 11       	sxt	r12		;

00004786 <.Loc.127.2>:
    4786:	0d 4c       	mov	r12,	r13	;
    4788:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    478c:	4c ed       	xor.b	r13,	r12	;
    478e:	4c 8d       	sub.b	r13,	r12	;
    4790:	4d 4c       	mov.b	r12,	r13	;

00004792 <.Loc.127.2>:
    4792:	7c 40 09 00 	mov.b	#9,	r12	;
    4796:	4c 9d       	cmp.b	r13,	r12	;
    4798:	04 28       	jnc	$+10     	;abs 0x47a2

0000479a <.Loc.128.2>:
    479a:	1c 41 e2 00 	mov	226(r1),r12	;0x000e2
    479e:	cc 43 00 00 	mov.b	#0,	0(r12)	;r3 As==00

000047a2 <.L58>:
    47a2:	1c 41 e2 00 	mov	226(r1),r12	;0x000e2
    47a6:	5c 4c 01 00 	mov.b	1(r12),	r12	;
    47aa:	8c 11       	sxt	r12		;

000047ac <.Loc.129.2>:
    47ac:	0d 4c       	mov	r12,	r13	;
    47ae:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    47b2:	4c ed       	xor.b	r13,	r12	;
    47b4:	4c 8d       	sub.b	r13,	r12	;
    47b6:	4d 4c       	mov.b	r12,	r13	;

000047b8 <.Loc.129.2>:
    47b8:	7c 40 09 00 	mov.b	#9,	r12	;
    47bc:	4c 9d       	cmp.b	r13,	r12	;
    47be:	04 28       	jnc	$+10     	;abs 0x47c8

000047c0 <.Loc.130.2>:
    47c0:	1c 41 e2 00 	mov	226(r1),r12	;0x000e2
    47c4:	cc 43 01 00 	mov.b	#0,	1(r12)	;r3 As==00

000047c8 <.L59>:
    47c8:	1c 41 e2 00 	mov	226(r1),r12	;0x000e2
    47cc:	5c 4c 02 00 	mov.b	2(r12),	r12	;
    47d0:	8c 11       	sxt	r12		;

000047d2 <.Loc.131.2>:
    47d2:	0d 4c       	mov	r12,	r13	;
    47d4:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    47d8:	4c ed       	xor.b	r13,	r12	;
    47da:	4c 8d       	sub.b	r13,	r12	;
    47dc:	4d 4c       	mov.b	r12,	r13	;

000047de <.Loc.131.2>:
    47de:	7c 40 09 00 	mov.b	#9,	r12	;
    47e2:	4c 9d       	cmp.b	r13,	r12	;
    47e4:	04 28       	jnc	$+10     	;abs 0x47ee

000047e6 <.Loc.132.2>:
    47e6:	1c 41 e2 00 	mov	226(r1),r12	;0x000e2
    47ea:	cc 43 02 00 	mov.b	#0,	2(r12)	;r3 As==00

000047ee <.L60>:
    47ee:	91 53 e4 00 	inc	228(r1)		;

000047f2 <.L57>:
    47f2:	6c 43       	mov.b	#2,	r12	;r3 As==10
    47f4:	1c 91 e4 00 	cmp	228(r1),r12	;0x000e4
    47f8:	b8 2f       	jc	$-142    	;abs 0x476a

000047fa <.Loc.134.2>:
    47fa:	03 43       	nop			
    47fc:	3f 40 46 01 	mov	#326,	r15	;#0x0146
    4800:	0f 51       	add	r1,	r15	;
    4802:	3f 50 ec fe 	add	#-276,	r15	;#0xfeec
    4806:	81 4f e0 00 	mov	r15,	224(r1)	; 0x00e0
    480a:	3c 40 46 01 	mov	#326,	r12	;#0x0146
    480e:	0c 51       	add	r1,	r12	;
    4810:	3c 50 f1 fe 	add	#-271,	r12	;#0xfef1
    4814:	81 4c de 00 	mov	r12,	222(r1)	; 0x00de

00004818 <.LBB273>:
    4818:	81 43 da 00 	mov	#0,	218(r1)	;r3 As==00, 0x00da
    481c:	81 43 dc 00 	mov	#0,	220(r1)	;r3 As==00, 0x00dc

00004820 <.Loc.137.2>:
    4820:	81 43 d6 00 	mov	#0,	214(r1)	;r3 As==00, 0x00d6
    4824:	81 43 d8 00 	mov	#0,	216(r1)	;r3 As==00, 0x00d8

00004828 <.Loc.137.2>:
    4828:	81 43 d2 00 	mov	#0,	210(r1)	;r3 As==00, 0x00d2
    482c:	81 43 d4 00 	mov	#0,	212(r1)	;r3 As==00, 0x00d4

00004830 <.Loc.138.2>:
    4830:	81 43 ce 00 	mov	#0,	206(r1)	;r3 As==00, 0x00ce
    4834:	81 43 d0 00 	mov	#0,	208(r1)	;r3 As==00, 0x00d0

00004838 <.Loc.138.2>:
    4838:	81 43 ca 00 	mov	#0,	202(r1)	;r3 As==00, 0x00ca
    483c:	81 43 cc 00 	mov	#0,	204(r1)	;r3 As==00, 0x00cc

00004840 <.Loc.138.2>:
    4840:	81 43 c6 00 	mov	#0,	198(r1)	;r3 As==00, 0x00c6
    4844:	81 43 c8 00 	mov	#0,	200(r1)	;r3 As==00, 0x00c8

00004848 <.Loc.142.2>:
    4848:	81 43 c4 00 	mov	#0,	196(r1)	;r3 As==00, 0x00c4

0000484c <.Loc.142.2>:
    484c:	4c 3c       	jmp	$+154    	;abs 0x48e6

0000484e <.L63>:
    484e:	1d 41 c4 00 	mov	196(r1),r13	;0x000c4
    4852:	0c 4d       	mov	r13,	r12	;
    4854:	5c 02       	rlam	#1,	r12	;
    4856:	0c 5d       	add	r13,	r12	;
    4858:	1c 51 de 00 	add	222(r1),r12	;0x000de

0000485c <.Loc.143.2>:
    485c:	6e 4c       	mov.b	@r12,	r14	;
    485e:	8e 11       	sxt	r14		;
    4860:	0c 4e       	mov	r14,	r12	;
    4862:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4866:	0d 7d       	subc	r13,	r13	;
    4868:	3d e3       	inv	r13		;

0000486a <.Loc.143.2>:
    486a:	0e 4c       	mov	r12,	r14	;
    486c:	0f 4d       	mov	r13,	r15	;
    486e:	1e 51 da 00 	add	218(r1),r14	;0x000da
    4872:	1f 61 dc 00 	addc	220(r1),r15	;0x000dc
    4876:	81 4e da 00 	mov	r14,	218(r1)	; 0x00da
    487a:	81 4f dc 00 	mov	r15,	220(r1)	; 0x00dc

0000487e <.Loc.144.2>:
    487e:	1d 41 c4 00 	mov	196(r1),r13	;0x000c4
    4882:	0c 4d       	mov	r13,	r12	;
    4884:	5c 02       	rlam	#1,	r12	;
    4886:	0c 5d       	add	r13,	r12	;
    4888:	1c 51 de 00 	add	222(r1),r12	;0x000de

0000488c <.Loc.144.2>:
    488c:	5e 4c 01 00 	mov.b	1(r12),	r14	;
    4890:	8e 11       	sxt	r14		;
    4892:	0c 4e       	mov	r14,	r12	;
    4894:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4898:	0d 7d       	subc	r13,	r13	;
    489a:	3d e3       	inv	r13		;

0000489c <.Loc.144.2>:
    489c:	0e 4c       	mov	r12,	r14	;
    489e:	0f 4d       	mov	r13,	r15	;
    48a0:	1e 51 d6 00 	add	214(r1),r14	;0x000d6
    48a4:	1f 61 d8 00 	addc	216(r1),r15	;0x000d8
    48a8:	81 4e d6 00 	mov	r14,	214(r1)	; 0x00d6
    48ac:	81 4f d8 00 	mov	r15,	216(r1)	; 0x00d8

000048b0 <.Loc.145.2>:
    48b0:	1d 41 c4 00 	mov	196(r1),r13	;0x000c4
    48b4:	0c 4d       	mov	r13,	r12	;
    48b6:	5c 02       	rlam	#1,	r12	;
    48b8:	0c 5d       	add	r13,	r12	;
    48ba:	1c 51 de 00 	add	222(r1),r12	;0x000de

000048be <.Loc.145.2>:
    48be:	5e 4c 02 00 	mov.b	2(r12),	r14	;
    48c2:	8e 11       	sxt	r14		;
    48c4:	0c 4e       	mov	r14,	r12	;
    48c6:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    48ca:	0d 7d       	subc	r13,	r13	;
    48cc:	3d e3       	inv	r13		;

000048ce <.Loc.145.2>:
    48ce:	0e 4c       	mov	r12,	r14	;
    48d0:	0f 4d       	mov	r13,	r15	;
    48d2:	1e 51 d2 00 	add	210(r1),r14	;0x000d2
    48d6:	1f 61 d4 00 	addc	212(r1),r15	;0x000d4
    48da:	81 4e d2 00 	mov	r14,	210(r1)	; 0x00d2
    48de:	81 4f d4 00 	mov	r15,	212(r1)	; 0x00d4

000048e2 <.Loc.142.2>:
    48e2:	91 53 c4 00 	inc	196(r1)		;

000048e6 <.L62>:
    48e6:	6c 43       	mov.b	#2,	r12	;r3 As==10
    48e8:	1c 91 c4 00 	cmp	196(r1),r12	;0x000c4
    48ec:	b0 37       	jge	$-158    	;abs 0x484e

000048ee <.Loc.147.2>:
    48ee:	1c 41 da 00 	mov	218(r1),r12	;0x000da
    48f2:	1d 41 dc 00 	mov	220(r1),r13	;0x000dc
    48f6:	7e 40 03 00 	mov.b	#3,	r14	;
    48fa:	4f 43       	clr.b	r15		;
    48fc:	b0 12 86 5e 	call	#24198		;#0x5e86
    4900:	81 4c da 00 	mov	r12,	218(r1)	; 0x00da
    4904:	81 4d dc 00 	mov	r13,	220(r1)	; 0x00dc

00004908 <.Loc.148.2>:
    4908:	1c 41 d6 00 	mov	214(r1),r12	;0x000d6
    490c:	1d 41 d8 00 	mov	216(r1),r13	;0x000d8
    4910:	7e 40 03 00 	mov.b	#3,	r14	;
    4914:	4f 43       	clr.b	r15		;
    4916:	b0 12 86 5e 	call	#24198		;#0x5e86
    491a:	81 4c d6 00 	mov	r12,	214(r1)	; 0x00d6
    491e:	81 4d d8 00 	mov	r13,	216(r1)	; 0x00d8

00004922 <.Loc.149.2>:
    4922:	1c 41 d2 00 	mov	210(r1),r12	;0x000d2
    4926:	1d 41 d4 00 	mov	212(r1),r13	;0x000d4
    492a:	7e 40 03 00 	mov.b	#3,	r14	;
    492e:	4f 43       	clr.b	r15		;
    4930:	b0 12 86 5e 	call	#24198		;#0x5e86
    4934:	81 4c d2 00 	mov	r12,	210(r1)	; 0x00d2
    4938:	81 4d d4 00 	mov	r13,	212(r1)	; 0x00d4

0000493c <.Loc.152.2>:
    493c:	81 43 c4 00 	mov	#0,	196(r1)	;r3 As==00, 0x00c4

00004940 <.Loc.152.2>:
    4940:	61 3c       	jmp	$+196    	;abs 0x4a04

00004942 <.L65>:
    4942:	1d 41 c4 00 	mov	196(r1),r13	;0x000c4
    4946:	0c 4d       	mov	r13,	r12	;
    4948:	5c 02       	rlam	#1,	r12	;
    494a:	0c 5d       	add	r13,	r12	;
    494c:	1c 51 de 00 	add	222(r1),r12	;0x000de

00004950 <.Loc.153.2>:
    4950:	6c 4c       	mov.b	@r12,	r12	;
    4952:	8c 11       	sxt	r12		;

00004954 <.Loc.153.2>:
    4954:	1d 41 da 00 	mov	218(r1),r13	;0x000da
    4958:	0c 8d       	sub	r13,	r12	;

0000495a <.Loc.153.2>:
    495a:	0d 4c       	mov	r12,	r13	;
    495c:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    4960:	0c ed       	xor	r13,	r12	;
    4962:	0c 8d       	sub	r13,	r12	;
    4964:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    4968:	0d 7d       	subc	r13,	r13	;
    496a:	3d e3       	inv	r13		;

0000496c <.Loc.153.2>:
    496c:	0e 4c       	mov	r12,	r14	;
    496e:	0f 4d       	mov	r13,	r15	;
    4970:	1e 51 ce 00 	add	206(r1),r14	;0x000ce
    4974:	1f 61 d0 00 	addc	208(r1),r15	;0x000d0
    4978:	81 4e ce 00 	mov	r14,	206(r1)	; 0x00ce
    497c:	81 4f d0 00 	mov	r15,	208(r1)	; 0x00d0

00004980 <.Loc.154.2>:
    4980:	1d 41 c4 00 	mov	196(r1),r13	;0x000c4
    4984:	0c 4d       	mov	r13,	r12	;
    4986:	5c 02       	rlam	#1,	r12	;
    4988:	0c 5d       	add	r13,	r12	;
    498a:	1c 51 de 00 	add	222(r1),r12	;0x000de

0000498e <.Loc.154.2>:
    498e:	5c 4c 01 00 	mov.b	1(r12),	r12	;
    4992:	8c 11       	sxt	r12		;

00004994 <.Loc.154.2>:
    4994:	1d 41 d6 00 	mov	214(r1),r13	;0x000d6
    4998:	0c 8d       	sub	r13,	r12	;

0000499a <.Loc.154.2>:
    499a:	0d 4c       	mov	r12,	r13	;
    499c:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    49a0:	0c ed       	xor	r13,	r12	;
    49a2:	0c 8d       	sub	r13,	r12	;
    49a4:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    49a8:	0d 7d       	subc	r13,	r13	;
    49aa:	3d e3       	inv	r13		;

000049ac <.Loc.154.2>:
    49ac:	0e 4c       	mov	r12,	r14	;
    49ae:	0f 4d       	mov	r13,	r15	;
    49b0:	1e 51 ca 00 	add	202(r1),r14	;0x000ca
    49b4:	1f 61 cc 00 	addc	204(r1),r15	;0x000cc
    49b8:	81 4e ca 00 	mov	r14,	202(r1)	; 0x00ca
    49bc:	81 4f cc 00 	mov	r15,	204(r1)	; 0x00cc

000049c0 <.Loc.155.2>:
    49c0:	1d 41 c4 00 	mov	196(r1),r13	;0x000c4
    49c4:	0c 4d       	mov	r13,	r12	;
    49c6:	5c 02       	rlam	#1,	r12	;
    49c8:	0c 5d       	add	r13,	r12	;
    49ca:	1c 51 de 00 	add	222(r1),r12	;0x000de

000049ce <.Loc.155.2>:
    49ce:	5c 4c 02 00 	mov.b	2(r12),	r12	;
    49d2:	8c 11       	sxt	r12		;

000049d4 <.Loc.155.2>:
    49d4:	1d 41 d2 00 	mov	210(r1),r13	;0x000d2
    49d8:	0c 8d       	sub	r13,	r12	;

000049da <.Loc.155.2>:
    49da:	0d 4c       	mov	r12,	r13	;
    49dc:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    49e0:	0c ed       	xor	r13,	r12	;
    49e2:	0c 8d       	sub	r13,	r12	;
    49e4:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    49e8:	0d 7d       	subc	r13,	r13	;
    49ea:	3d e3       	inv	r13		;

000049ec <.Loc.155.2>:
    49ec:	0e 4c       	mov	r12,	r14	;
    49ee:	0f 4d       	mov	r13,	r15	;
    49f0:	1e 51 c6 00 	add	198(r1),r14	;0x000c6
    49f4:	1f 61 c8 00 	addc	200(r1),r15	;0x000c8
    49f8:	81 4e c6 00 	mov	r14,	198(r1)	; 0x00c6
    49fc:	81 4f c8 00 	mov	r15,	200(r1)	; 0x00c8

00004a00 <.Loc.152.2>:
    4a00:	91 53 c4 00 	inc	196(r1)		;

00004a04 <.L64>:
    4a04:	6c 43       	mov.b	#2,	r12	;r3 As==10
    4a06:	1c 91 c4 00 	cmp	196(r1),r12	;0x000c4
    4a0a:	9b 37       	jge	$-200    	;abs 0x4942

00004a0c <.Loc.157.2>:
    4a0c:	1c 41 ce 00 	mov	206(r1),r12	;0x000ce
    4a10:	1d 41 d0 00 	mov	208(r1),r13	;0x000d0
    4a14:	7e 40 03 00 	mov.b	#3,	r14	;
    4a18:	4f 43       	clr.b	r15		;
    4a1a:	b0 12 86 5e 	call	#24198		;#0x5e86
    4a1e:	81 4c ce 00 	mov	r12,	206(r1)	; 0x00ce
    4a22:	81 4d d0 00 	mov	r13,	208(r1)	; 0x00d0

00004a26 <.Loc.158.2>:
    4a26:	1c 41 ca 00 	mov	202(r1),r12	;0x000ca
    4a2a:	1d 41 cc 00 	mov	204(r1),r13	;0x000cc
    4a2e:	7e 40 03 00 	mov.b	#3,	r14	;
    4a32:	4f 43       	clr.b	r15		;
    4a34:	b0 12 86 5e 	call	#24198		;#0x5e86
    4a38:	81 4c ca 00 	mov	r12,	202(r1)	; 0x00ca
    4a3c:	81 4d cc 00 	mov	r13,	204(r1)	; 0x00cc

00004a40 <.Loc.159.2>:
    4a40:	1c 41 c6 00 	mov	198(r1),r12	;0x000c6
    4a44:	1d 41 c8 00 	mov	200(r1),r13	;0x000c8
    4a48:	7e 40 03 00 	mov.b	#3,	r14	;
    4a4c:	4f 43       	clr.b	r15		;
    4a4e:	b0 12 86 5e 	call	#24198		;#0x5e86
    4a52:	81 4c c6 00 	mov	r12,	198(r1)	; 0x00c6
    4a56:	81 4d c8 00 	mov	r13,	200(r1)	; 0x00c8

00004a5a <.Loc.161.2>:
    4a5a:	1c 41 da 00 	mov	218(r1),r12	;0x000da
    4a5e:	1d 41 da 00 	mov	218(r1),r13	;0x000da
    4a62:	b0 12 b2 65 	call	#26034		;#0x65b2
    4a66:	0a 4c       	mov	r12,	r10	;
    4a68:	1c 41 d6 00 	mov	214(r1),r12	;0x000d6
    4a6c:	1d 41 d6 00 	mov	214(r1),r13	;0x000d6
    4a70:	b0 12 b2 65 	call	#26034		;#0x65b2
    4a74:	0a 5c       	add	r12,	r10	;

00004a76 <.Loc.161.2>:
    4a76:	1c 41 d2 00 	mov	210(r1),r12	;0x000d2
    4a7a:	1d 41 d2 00 	mov	210(r1),r13	;0x000d2
    4a7e:	b0 12 b2 65 	call	#26034		;#0x65b2

00004a82 <.Loc.161.2>:
    4a82:	0f 4a       	mov	r10,	r15	;
    4a84:	0f 5c       	add	r12,	r15	;
    4a86:	81 4f c2 00 	mov	r15,	194(r1)	; 0x00c2

00004a8a <.Loc.162.2>:
    4a8a:	1c 41 ce 00 	mov	206(r1),r12	;0x000ce
    4a8e:	1d 41 ce 00 	mov	206(r1),r13	;0x000ce
    4a92:	b0 12 b2 65 	call	#26034		;#0x65b2
    4a96:	0a 4c       	mov	r12,	r10	;
    4a98:	1c 41 ca 00 	mov	202(r1),r12	;0x000ca
    4a9c:	1d 41 ca 00 	mov	202(r1),r13	;0x000ca
    4aa0:	b0 12 b2 65 	call	#26034		;#0x65b2
    4aa4:	0a 5c       	add	r12,	r10	;

00004aa6 <.Loc.162.2>:
    4aa6:	1c 41 c6 00 	mov	198(r1),r12	;0x000c6
    4aaa:	1d 41 c6 00 	mov	198(r1),r13	;0x000c6
    4aae:	b0 12 b2 65 	call	#26034		;#0x65b2

00004ab2 <.Loc.162.2>:
    4ab2:	0d 4a       	mov	r10,	r13	;
    4ab4:	0d 5c       	add	r12,	r13	;
    4ab6:	81 4d c0 00 	mov	r13,	192(r1)	; 0x00c0

00004aba <.Loc.164.2>:
    4aba:	1e 41 c2 00 	mov	194(r1),r14	;0x000c2
    4abe:	0c 4e       	mov	r14,	r12	;
    4ac0:	0d 43       	clr	r13		;
    4ac2:	81 4c bc 00 	mov	r12,	188(r1)	; 0x00bc
    4ac6:	81 4d be 00 	mov	r13,	190(r1)	; 0x00be

00004aca <.LBB275>:
    4aca:	b1 40 00 80 	mov	#-32768,184(r1)	;#0x8000, 0x00b8
    4ace:	b8 00 
    4ad0:	81 43 ba 00 	mov	#0,	186(r1)	;r3 As==00, 0x00ba

00004ad4 <.Loc.72.2>:
    4ad4:	b1 40 00 80 	mov	#-32768,180(r1)	;#0x8000, 0x00b4
    4ad8:	b4 00 
    4ada:	81 43 b6 00 	mov	#0,	182(r1)	;r3 As==00, 0x00b6

00004ade <.L70>:
    4ade:	1e 41 b4 00 	mov	180(r1),r14	;0x000b4
    4ae2:	1f 41 b6 00 	mov	182(r1),r15	;0x000b6
    4ae6:	0c 4e       	mov	r14,	r12	;
    4ae8:	0d 4f       	mov	r15,	r13	;
    4aea:	b0 12 f6 65 	call	#26102		;#0x65f6

00004aee <.Loc.74.2>:
    4aee:	81 9d be 00 	cmp	r13,	190(r1)	; 0x00be
    4af2:	06 28       	jnc	$+14     	;abs 0x4b00
    4af4:	81 9d be 00 	cmp	r13,	190(r1)	; 0x00be
    4af8:	09 20       	jnz	$+20     	;abs 0x4b0c
    4afa:	81 9c bc 00 	cmp	r12,	188(r1)	; 0x00bc
    4afe:	06 2c       	jc	$+14     	;abs 0x4b0c

00004b00 <.L203>:
    4b00:	91 e1 b8 00 	xor	184(r1),180(r1)	;0x000b8, 0x00b4
    4b04:	b4 00 
    4b06:	91 e1 ba 00 	xor	186(r1),182(r1)	;0x000ba, 0x00b6
    4b0a:	b6 00 

00004b0c <.L66>:
    4b0c:	12 c3       	clrc			
    4b0e:	11 10 ba 00 	rrc	186(r1)	;000ba
    4b12:	11 10 b8 00 	rrc	184(r1)	;000b8

00004b16 <.Loc.77.2>:
    4b16:	1c 41 b8 00 	mov	184(r1),r12	;0x000b8
    4b1a:	1c d1 ba 00 	bis	186(r1),r12	;0x000ba
    4b1e:	0c 93       	cmp	#0,	r12	;r3 As==00
    4b20:	19 20       	jnz	$+52     	;abs 0x4b54

00004b22 <.Loc.78.2>:
    4b22:	1d 41 b4 00 	mov	180(r1),r13	;0x000b4

00004b26 <.LBE275>:
    4b26:	1c 41 e0 00 	mov	224(r1),r12	;0x000e0
    4b2a:	8c 4d 00 00 	mov	r13,	0(r12)	;

00004b2e <.Loc.165.2>:
    4b2e:	1f 41 c0 00 	mov	192(r1),r15	;0x000c0
    4b32:	0c 4f       	mov	r15,	r12	;
    4b34:	0d 43       	clr	r13		;
    4b36:	81 4c b0 00 	mov	r12,	176(r1)	; 0x00b0
    4b3a:	81 4d b2 00 	mov	r13,	178(r1)	; 0x00b2

00004b3e <.LBB278>:
    4b3e:	b1 40 00 80 	mov	#-32768,172(r1)	;#0x8000, 0x00ac
    4b42:	ac 00 
    4b44:	81 43 ae 00 	mov	#0,	174(r1)	;r3 As==00, 0x00ae

00004b48 <.Loc.72.2>:
    4b48:	b1 40 00 80 	mov	#-32768,168(r1)	;#0x8000, 0x00a8
    4b4c:	a8 00 
    4b4e:	81 43 aa 00 	mov	#0,	170(r1)	;r3 As==00, 0x00aa
    4b52:	07 3c       	jmp	$+16     	;abs 0x4b62

00004b54 <.L68>:
    4b54:	91 d1 b8 00 	bis	184(r1),180(r1)	;0x000b8, 0x00b4
    4b58:	b4 00 
    4b5a:	91 d1 ba 00 	bis	186(r1),182(r1)	;0x000ba, 0x00b6
    4b5e:	b6 00 

00004b60 <.Loc.74.2>:
    4b60:	be 3f       	jmp	$-130    	;abs 0x4ade

00004b62 <.L75>:
    4b62:	1e 41 a8 00 	mov	168(r1),r14	;0x000a8
    4b66:	1f 41 aa 00 	mov	170(r1),r15	;0x000aa
    4b6a:	0c 4e       	mov	r14,	r12	;
    4b6c:	0d 4f       	mov	r15,	r13	;
    4b6e:	b0 12 f6 65 	call	#26102		;#0x65f6

00004b72 <.Loc.74.2>:
    4b72:	81 9d b2 00 	cmp	r13,	178(r1)	; 0x00b2
    4b76:	06 28       	jnc	$+14     	;abs 0x4b84
    4b78:	81 9d b2 00 	cmp	r13,	178(r1)	; 0x00b2
    4b7c:	09 20       	jnz	$+20     	;abs 0x4b90
    4b7e:	81 9c b0 00 	cmp	r12,	176(r1)	; 0x00b0
    4b82:	06 2c       	jc	$+14     	;abs 0x4b90

00004b84 <.L205>:
    4b84:	91 e1 ac 00 	xor	172(r1),168(r1)	;0x000ac, 0x00a8
    4b88:	a8 00 
    4b8a:	91 e1 ae 00 	xor	174(r1),170(r1)	;0x000ae, 0x00aa
    4b8e:	aa 00 

00004b90 <.L71>:
    4b90:	12 c3       	clrc			
    4b92:	11 10 ae 00 	rrc	174(r1)	;000ae
    4b96:	11 10 ac 00 	rrc	172(r1)	;000ac

00004b9a <.Loc.77.2>:
    4b9a:	1c 41 ac 00 	mov	172(r1),r12	;0x000ac
    4b9e:	1c d1 ae 00 	bis	174(r1),r12	;0x000ae
    4ba2:	0c 93       	cmp	#0,	r12	;r3 As==00
    4ba4:	07 20       	jnz	$+16     	;abs 0x4bb4

00004ba6 <.Loc.78.2>:
    4ba6:	1d 41 a8 00 	mov	168(r1),r13	;0x000a8

00004baa <.LBE283>:
    4baa:	1c 41 e0 00 	mov	224(r1),r12	;0x000e0
    4bae:	8c 4d 02 00 	mov	r13,	2(r12)	;

00004bb2 <.Loc.166.2>:
    4bb2:	07 3c       	jmp	$+16     	;abs 0x4bc2

00004bb4 <.L73>:
    4bb4:	91 d1 ac 00 	bis	172(r1),168(r1)	;0x000ac, 0x00a8
    4bb8:	a8 00 
    4bba:	91 d1 ae 00 	bis	174(r1),170(r1)	;0x000ae, 0x00aa
    4bbe:	aa 00 

00004bc0 <.Loc.74.2>:
    4bc0:	d0 3f       	jmp	$-94     	;abs 0x4b62

00004bc2 <.L220>:
    4bc2:	1c 41 ee 00 	mov	238(r1),r12	;0x000ee
    4bc6:	5c 06       	rlam	#2,	r12	;
    4bc8:	1c 51 f4 00 	add	244(r1),r12	;0x000f4

00004bcc <.Loc.222.2>:
    4bcc:	9c 41 32 00 	mov	50(r1),	0(r12)	;0x00032
    4bd0:	00 00 
    4bd2:	9c 41 34 00 	mov	52(r1),	2(r12)	;0x00034
    4bd6:	02 00 

00004bd8 <.Loc.218.2>:
    4bd8:	91 53 ee 00 	inc	238(r1)		;

00004bdc <.L34>:
    4bdc:	7c 40 0f 00 	mov.b	#15,	r12	;#0x000f
    4be0:	1c 91 ee 00 	cmp	238(r1),r12	;0x000ee
    4be4:	02 28       	jnc	$+6      	;abs 0x4bea
    4be6:	80 00 3a 45 	mova	#17722,	r0	;0x0453a

00004bea <.Loc.230.2>:
    4bea:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4bee:	5c c3       	bic.b	#1,	r12	;r3 As==01
    4bf0:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4bf4:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004bf8 <.Loc.236.2>:
    4bf8:	03 43       	nop			

00004bfa <.LBE236>:
    4bfa:	b0 12 10 42 	call	#16912		;#0x4210

00004bfe <.Loc.315.2>:
    4bfe:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    4c02:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    4c06:	b0 12 88 42 	call	#17032		;#0x4288

00004c0a <.Loc.320.2>:
    4c0a:	92 43 82 1c 	mov	#1,	&0x1c82	;r3 As==01

00004c0e <.Loc.321.2>:
    4c0e:	b0 12 e8 41 	call	#16872		;#0x41e8
    4c12:	b1 40 42 1c 	mov	#7234,	322(r1)	;#0x1c42, 0x0142
    4c16:	42 01 

00004c18 <.LBB285>:
    4c18:	81 43 40 01 	mov	#0,	320(r1)	;r3 As==00, 0x0140

00004c1c <.Loc.206.2>:
    4c1c:	e5 3c       	jmp	$+460    	;abs 0x4de8

00004c1e <.L98>:
    4c1e:	3c 40 46 01 	mov	#326,	r12	;#0x0146
    4c22:	0c 51       	add	r1,	r12	;
    4c24:	3c 50 d2 fe 	add	#-302,	r12	;#0xfed2
    4c28:	81 4c 3e 01 	mov	r12,	318(r1)	; 0x013e

00004c2c <.LBB289>:
    4c2c:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82

00004c30 <.Loc.96.2>:
    4c30:	0c 93       	cmp	#0,	r12	;r3 As==00
    4c32:	6d 20       	jnz	$+220    	;abs 0x4d0e

00004c34 <.LBB291>:
    4c34:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4c38:	5c f3       	and.b	#1,	r12	;r3 As==01

00004c3a <.Loc.26.2>:
    4c3a:	0c 93       	cmp	#0,	r12	;r3 As==00
    4c3c:	08 24       	jz	$+18     	;abs 0x4c4e

00004c3e <.Loc.27.2>:
    4c3e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4c42:	5c 03       	rrum	#1,	r12	;

00004c44 <.Loc.27.2>:
    4c44:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004c48 <.Loc.27.2>:
    4c48:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4c4c:	05 3c       	jmp	$+12     	;abs 0x4c58

00004c4e <.L79>:
    4c4e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4c52:	5c 03       	rrum	#1,	r12	;
    4c54:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004c58 <.L80>:
    4c58:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004c5c <.LBE291>:
    4c5c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4c60:	7c f0 03 00 	and.b	#3,	r12	;
    4c64:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004c68 <.Loc.98.2>:
    4c68:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    4c6c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4c70:	4d 4c       	mov.b	r12,	r13	;
    4c72:	8d 11       	sxt	r13		;

00004c74 <.Loc.98.2>:
    4c74:	1c 41 3e 01 	mov	318(r1),r12	;0x0013e
    4c78:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

00004c7c <.LBB293>:
    4c7c:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4c80:	5c f3       	and.b	#1,	r12	;r3 As==01

00004c82 <.Loc.26.2>:
    4c82:	0c 93       	cmp	#0,	r12	;r3 As==00
    4c84:	08 24       	jz	$+18     	;abs 0x4c96

00004c86 <.Loc.27.2>:
    4c86:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4c8a:	5c 03       	rrum	#1,	r12	;

00004c8c <.Loc.27.2>:
    4c8c:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004c90 <.Loc.27.2>:
    4c90:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4c94:	05 3c       	jmp	$+12     	;abs 0x4ca0

00004c96 <.L82>:
    4c96:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4c9a:	5c 03       	rrum	#1,	r12	;
    4c9c:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004ca0 <.L83>:
    4ca0:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004ca4 <.LBE293>:
    4ca4:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4ca8:	7c f0 03 00 	and.b	#3,	r12	;
    4cac:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004cb0 <.Loc.99.2>:
    4cb0:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    4cb4:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4cb8:	4d 4c       	mov.b	r12,	r13	;
    4cba:	8d 11       	sxt	r13		;

00004cbc <.Loc.99.2>:
    4cbc:	1c 41 3e 01 	mov	318(r1),r12	;0x0013e
    4cc0:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

00004cc4 <.LBB295>:
    4cc4:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4cc8:	5c f3       	and.b	#1,	r12	;r3 As==01

00004cca <.Loc.26.2>:
    4cca:	0c 93       	cmp	#0,	r12	;r3 As==00
    4ccc:	08 24       	jz	$+18     	;abs 0x4cde

00004cce <.Loc.27.2>:
    4cce:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4cd2:	5c 03       	rrum	#1,	r12	;

00004cd4 <.Loc.27.2>:
    4cd4:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004cd8 <.Loc.27.2>:
    4cd8:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4cdc:	05 3c       	jmp	$+12     	;abs 0x4ce8

00004cde <.L85>:
    4cde:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4ce2:	5c 03       	rrum	#1,	r12	;
    4ce4:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004ce8 <.L86>:
    4ce8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004cec <.LBE295>:
    4cec:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4cf0:	7c f0 03 00 	and.b	#3,	r12	;
    4cf4:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004cf8 <.Loc.100.2>:
    4cf8:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    4cfc:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4d00:	4d 4c       	mov.b	r12,	r13	;
    4d02:	8d 11       	sxt	r13		;

00004d04 <.Loc.100.2>:
    4d04:	1c 41 3e 01 	mov	318(r1),r12	;0x0013e
    4d08:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

00004d0c <.Loc.107.2>:
    4d0c:	6c 3c       	jmp	$+218    	;abs 0x4de6

00004d0e <.L78>:
    4d0e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4d12:	5c f3       	and.b	#1,	r12	;r3 As==01

00004d14 <.Loc.26.2>:
    4d14:	0c 93       	cmp	#0,	r12	;r3 As==00
    4d16:	08 24       	jz	$+18     	;abs 0x4d28

00004d18 <.Loc.27.2>:
    4d18:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4d1c:	5c 03       	rrum	#1,	r12	;

00004d1e <.Loc.27.2>:
    4d1e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004d22 <.Loc.27.2>:
    4d22:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4d26:	05 3c       	jmp	$+12     	;abs 0x4d32

00004d28 <.L89>:
    4d28:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4d2c:	5c 03       	rrum	#1,	r12	;
    4d2e:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004d32 <.L90>:
    4d32:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004d36 <.LBE297>:
    4d36:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4d3a:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004d3e <.Loc.103.2>:
    4d3e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4d42:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4d46:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4d4a:	4d 4c       	mov.b	r12,	r13	;
    4d4c:	8d 11       	sxt	r13		;

00004d4e <.Loc.103.2>:
    4d4e:	1c 41 3e 01 	mov	318(r1),r12	;0x0013e
    4d52:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

00004d56 <.LBB299>:
    4d56:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4d5a:	5c f3       	and.b	#1,	r12	;r3 As==01

00004d5c <.Loc.26.2>:
    4d5c:	0c 93       	cmp	#0,	r12	;r3 As==00
    4d5e:	08 24       	jz	$+18     	;abs 0x4d70

00004d60 <.Loc.27.2>:
    4d60:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4d64:	5c 03       	rrum	#1,	r12	;

00004d66 <.Loc.27.2>:
    4d66:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004d6a <.Loc.27.2>:
    4d6a:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4d6e:	05 3c       	jmp	$+12     	;abs 0x4d7a

00004d70 <.L92>:
    4d70:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4d74:	5c 03       	rrum	#1,	r12	;
    4d76:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004d7a <.L93>:
    4d7a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004d7e <.LBE299>:
    4d7e:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4d82:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004d86 <.Loc.104.2>:
    4d86:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4d8a:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4d8e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4d92:	4d 4c       	mov.b	r12,	r13	;
    4d94:	8d 11       	sxt	r13		;

00004d96 <.Loc.104.2>:
    4d96:	1c 41 3e 01 	mov	318(r1),r12	;0x0013e
    4d9a:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

00004d9e <.LBB301>:
    4d9e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4da2:	5c f3       	and.b	#1,	r12	;r3 As==01

00004da4 <.Loc.26.2>:
    4da4:	0c 93       	cmp	#0,	r12	;r3 As==00
    4da6:	08 24       	jz	$+18     	;abs 0x4db8

00004da8 <.Loc.27.2>:
    4da8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4dac:	5c 03       	rrum	#1,	r12	;

00004dae <.Loc.27.2>:
    4dae:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004db2 <.Loc.27.2>:
    4db2:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4db6:	05 3c       	jmp	$+12     	;abs 0x4dc2

00004db8 <.L95>:
    4db8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4dbc:	5c 03       	rrum	#1,	r12	;
    4dbe:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004dc2 <.L96>:
    4dc2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004dc6 <.LBE301>:
    4dc6:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4dca:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004dce <.Loc.105.2>:
    4dce:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4dd2:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4dd6:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4dda:	4d 4c       	mov.b	r12,	r13	;
    4ddc:	8d 11       	sxt	r13		;

00004dde <.Loc.105.2>:
    4dde:	1c 41 3e 01 	mov	318(r1),r12	;0x0013e
    4de2:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

00004de6 <.L224>:
    4de6:	03 43       	nop			

00004de8 <.L77>:
    4de8:	1c 41 40 01 	mov	320(r1),r12	;0x00140
    4dec:	0d 4c       	mov	r12,	r13	;
    4dee:	1d 53       	inc	r13		;
    4df0:	81 4d 40 01 	mov	r13,	320(r1)	; 0x0140

00004df4 <.Loc.206.2>:
    4df4:	6d 43       	mov.b	#2,	r13	;r3 As==10
    4df6:	0d 9c       	cmp	r12,	r13	;
    4df8:	12 2f       	jc	$-474    	;abs 0x4c1e

00004dfa <.Loc.209.2>:
    4dfa:	03 43       	nop			

00004dfc <.LBE287>:
    4dfc:	81 43 3c 01 	mov	#0,	316(r1)	;r3 As==00, 0x013c

00004e00 <.Loc.218.2>:
    4e00:	30 40 a6 54 	br	#0x54a6		;

00004e04 <.L141>:
    4e04:	3e 40 46 01 	mov	#326,	r14	;#0x0146
    4e08:	0e 51       	add	r1,	r14	;
    4e0a:	3e 50 dd fe 	add	#-291,	r14	;#0xfedd
    4e0e:	81 4e 3a 01 	mov	r14,	314(r1)	; 0x013a

00004e12 <.LBB303>:
    4e12:	81 43 38 01 	mov	#0,	312(r1)	;r3 As==00, 0x0138

00004e16 <.Loc.115.2>:
    4e16:	fd 3c       	jmp	$+508    	;abs 0x5012

00004e18 <.L121>:
    4e18:	3f 40 46 01 	mov	#326,	r15	;#0x0146
    4e1c:	0f 51       	add	r1,	r15	;
    4e1e:	3f 50 d5 fe 	add	#-299,	r15	;#0xfed5
    4e22:	81 4f 36 01 	mov	r15,	310(r1)	; 0x0136

00004e26 <.LBB305>:
    4e26:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82

00004e2a <.Loc.96.2>:
    4e2a:	0c 93       	cmp	#0,	r12	;r3 As==00
    4e2c:	6d 20       	jnz	$+220    	;abs 0x4f08

00004e2e <.LBB307>:
    4e2e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4e32:	5c f3       	and.b	#1,	r12	;r3 As==01

00004e34 <.Loc.26.2>:
    4e34:	0c 93       	cmp	#0,	r12	;r3 As==00
    4e36:	08 24       	jz	$+18     	;abs 0x4e48

00004e38 <.Loc.27.2>:
    4e38:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4e3c:	5c 03       	rrum	#1,	r12	;

00004e3e <.Loc.27.2>:
    4e3e:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004e42 <.Loc.27.2>:
    4e42:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4e46:	05 3c       	jmp	$+12     	;abs 0x4e52

00004e48 <.L102>:
    4e48:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4e4c:	5c 03       	rrum	#1,	r12	;
    4e4e:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004e52 <.L103>:
    4e52:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004e56 <.LBE307>:
    4e56:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4e5a:	7c f0 03 00 	and.b	#3,	r12	;
    4e5e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004e62 <.Loc.98.2>:
    4e62:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    4e66:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4e6a:	4d 4c       	mov.b	r12,	r13	;
    4e6c:	8d 11       	sxt	r13		;

00004e6e <.Loc.98.2>:
    4e6e:	1c 41 36 01 	mov	310(r1),r12	;0x00136
    4e72:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

00004e76 <.LBB309>:
    4e76:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4e7a:	5c f3       	and.b	#1,	r12	;r3 As==01

00004e7c <.Loc.26.2>:
    4e7c:	0c 93       	cmp	#0,	r12	;r3 As==00
    4e7e:	08 24       	jz	$+18     	;abs 0x4e90

00004e80 <.Loc.27.2>:
    4e80:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4e84:	5c 03       	rrum	#1,	r12	;

00004e86 <.Loc.27.2>:
    4e86:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004e8a <.Loc.27.2>:
    4e8a:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4e8e:	05 3c       	jmp	$+12     	;abs 0x4e9a

00004e90 <.L105>:
    4e90:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4e94:	5c 03       	rrum	#1,	r12	;
    4e96:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004e9a <.L106>:
    4e9a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004e9e <.LBE309>:
    4e9e:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4ea2:	7c f0 03 00 	and.b	#3,	r12	;
    4ea6:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004eaa <.Loc.99.2>:
    4eaa:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    4eae:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4eb2:	4d 4c       	mov.b	r12,	r13	;
    4eb4:	8d 11       	sxt	r13		;

00004eb6 <.Loc.99.2>:
    4eb6:	1c 41 36 01 	mov	310(r1),r12	;0x00136
    4eba:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

00004ebe <.LBB311>:
    4ebe:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4ec2:	5c f3       	and.b	#1,	r12	;r3 As==01

00004ec4 <.Loc.26.2>:
    4ec4:	0c 93       	cmp	#0,	r12	;r3 As==00
    4ec6:	08 24       	jz	$+18     	;abs 0x4ed8

00004ec8 <.Loc.27.2>:
    4ec8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4ecc:	5c 03       	rrum	#1,	r12	;

00004ece <.Loc.27.2>:
    4ece:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004ed2 <.Loc.27.2>:
    4ed2:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4ed6:	05 3c       	jmp	$+12     	;abs 0x4ee2

00004ed8 <.L108>:
    4ed8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4edc:	5c 03       	rrum	#1,	r12	;
    4ede:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004ee2 <.L109>:
    4ee2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004ee6 <.LBE311>:
    4ee6:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4eea:	7c f0 03 00 	and.b	#3,	r12	;
    4eee:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00004ef2 <.Loc.100.2>:
    4ef2:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    4ef6:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4efa:	4d 4c       	mov.b	r12,	r13	;
    4efc:	8d 11       	sxt	r13		;

00004efe <.Loc.100.2>:
    4efe:	1c 41 36 01 	mov	310(r1),r12	;0x00136
    4f02:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

00004f06 <.Loc.107.2>:
    4f06:	6c 3c       	jmp	$+218    	;abs 0x4fe0

00004f08 <.L101>:
    4f08:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4f0c:	5c f3       	and.b	#1,	r12	;r3 As==01

00004f0e <.Loc.26.2>:
    4f0e:	0c 93       	cmp	#0,	r12	;r3 As==00
    4f10:	08 24       	jz	$+18     	;abs 0x4f22

00004f12 <.Loc.27.2>:
    4f12:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4f16:	5c 03       	rrum	#1,	r12	;

00004f18 <.Loc.27.2>:
    4f18:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004f1c <.Loc.27.2>:
    4f1c:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4f20:	05 3c       	jmp	$+12     	;abs 0x4f2c

00004f22 <.L112>:
    4f22:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4f26:	5c 03       	rrum	#1,	r12	;
    4f28:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004f2c <.L113>:
    4f2c:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004f30 <.LBE313>:
    4f30:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4f34:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004f38 <.Loc.103.2>:
    4f38:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4f3c:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4f40:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4f44:	4d 4c       	mov.b	r12,	r13	;
    4f46:	8d 11       	sxt	r13		;

00004f48 <.Loc.103.2>:
    4f48:	1c 41 36 01 	mov	310(r1),r12	;0x00136
    4f4c:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

00004f50 <.LBB315>:
    4f50:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4f54:	5c f3       	and.b	#1,	r12	;r3 As==01

00004f56 <.Loc.26.2>:
    4f56:	0c 93       	cmp	#0,	r12	;r3 As==00
    4f58:	08 24       	jz	$+18     	;abs 0x4f6a

00004f5a <.Loc.27.2>:
    4f5a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4f5e:	5c 03       	rrum	#1,	r12	;

00004f60 <.Loc.27.2>:
    4f60:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004f64 <.Loc.27.2>:
    4f64:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4f68:	05 3c       	jmp	$+12     	;abs 0x4f74

00004f6a <.L115>:
    4f6a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4f6e:	5c 03       	rrum	#1,	r12	;
    4f70:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004f74 <.L116>:
    4f74:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004f78 <.LBE315>:
    4f78:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4f7c:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004f80 <.Loc.104.2>:
    4f80:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4f84:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4f88:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4f8c:	4d 4c       	mov.b	r12,	r13	;
    4f8e:	8d 11       	sxt	r13		;

00004f90 <.Loc.104.2>:
    4f90:	1c 41 36 01 	mov	310(r1),r12	;0x00136
    4f94:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

00004f98 <.LBB317>:
    4f98:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4f9c:	5c f3       	and.b	#1,	r12	;r3 As==01

00004f9e <.Loc.26.2>:
    4f9e:	0c 93       	cmp	#0,	r12	;r3 As==00
    4fa0:	08 24       	jz	$+18     	;abs 0x4fb2

00004fa2 <.Loc.27.2>:
    4fa2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4fa6:	5c 03       	rrum	#1,	r12	;

00004fa8 <.Loc.27.2>:
    4fa8:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00004fac <.Loc.27.2>:
    4fac:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4fb0:	05 3c       	jmp	$+12     	;abs 0x4fbc

00004fb2 <.L118>:
    4fb2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4fb6:	5c 03       	rrum	#1,	r12	;
    4fb8:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00004fbc <.L119>:
    4fbc:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00004fc0 <.LBE317>:
    4fc0:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4fc4:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00004fc8 <.Loc.105.2>:
    4fc8:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4fcc:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    4fd0:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4fd4:	4d 4c       	mov.b	r12,	r13	;
    4fd6:	8d 11       	sxt	r13		;

00004fd8 <.Loc.105.2>:
    4fd8:	1c 41 36 01 	mov	310(r1),r12	;0x00136
    4fdc:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

00004fe0 <.L225>:
    4fe0:	03 43       	nop			

00004fe2 <.LBE305>:
    4fe2:	1d 41 38 01 	mov	312(r1),r13	;0x00138
    4fe6:	0c 4d       	mov	r13,	r12	;
    4fe8:	1c 53       	inc	r12		;
    4fea:	81 4c 38 01 	mov	r12,	312(r1)	; 0x0138

00004fee <.Loc.117.2>:
    4fee:	0c 4d       	mov	r13,	r12	;
    4ff0:	5c 02       	rlam	#1,	r12	;
    4ff2:	0c 5d       	add	r13,	r12	;
    4ff4:	1d 41 3a 01 	mov	314(r1),r13	;0x0013a
    4ff8:	0d 5c       	add	r12,	r13	;

00004ffa <.Loc.117.2>:
    4ffa:	0c 41       	mov	r1,	r12	;
    4ffc:	3c 50 1b 00 	add	#27,	r12	;#0x001b
    5000:	ed 4c 00 00 	mov.b	@r12,	0(r13)	;
    5004:	1c 53       	inc	r12		;
    5006:	ed 4c 01 00 	mov.b	@r12,	1(r13)	;
    500a:	1c 53       	inc	r12		;
    500c:	ed 4c 02 00 	mov.b	@r12,	2(r13)	;
    5010:	1c 53       	inc	r12		;

00005012 <.L100>:
    5012:	6c 43       	mov.b	#2,	r12	;r3 As==10
    5014:	1c 91 38 01 	cmp	312(r1),r12	;0x00138
    5018:	ff 2e       	jc	$-512    	;abs 0x4e18

0000501a <.Loc.119.2>:
    501a:	03 43       	nop			
    501c:	3d 40 46 01 	mov	#326,	r13	;#0x0146
    5020:	0d 51       	add	r1,	r13	;
    5022:	3d 50 dd fe 	add	#-291,	r13	;#0xfedd
    5026:	81 4d 34 01 	mov	r13,	308(r1)	; 0x0134

0000502a <.LBB319>:
    502a:	81 43 32 01 	mov	#0,	306(r1)	;r3 As==00, 0x0132

0000502e <.Loc.123.2>:
    502e:	81 43 32 01 	mov	#0,	306(r1)	;r3 As==00, 0x0132

00005032 <.Loc.123.2>:
    5032:	44 3c       	jmp	$+138    	;abs 0x50bc

00005034 <.L126>:
    5034:	1d 41 32 01 	mov	306(r1),r13	;0x00132
    5038:	0c 4d       	mov	r13,	r12	;
    503a:	5c 02       	rlam	#1,	r12	;
    503c:	0c 5d       	add	r13,	r12	;

0000503e <.Loc.124.2>:
    503e:	1e 41 34 01 	mov	308(r1),r14	;0x00134
    5042:	0e 5c       	add	r12,	r14	;
    5044:	81 4e 30 01 	mov	r14,	304(r1)	; 0x0130

00005048 <.Loc.127.2>:
    5048:	1c 41 30 01 	mov	304(r1),r12	;0x00130
    504c:	6c 4c       	mov.b	@r12,	r12	;
    504e:	8c 11       	sxt	r12		;

00005050 <.Loc.127.2>:
    5050:	0d 4c       	mov	r12,	r13	;
    5052:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    5056:	4c ed       	xor.b	r13,	r12	;
    5058:	4c 8d       	sub.b	r13,	r12	;
    505a:	4d 4c       	mov.b	r12,	r13	;

0000505c <.Loc.127.2>:
    505c:	7c 40 09 00 	mov.b	#9,	r12	;
    5060:	4c 9d       	cmp.b	r13,	r12	;
    5062:	04 28       	jnc	$+10     	;abs 0x506c

00005064 <.Loc.128.2>:
    5064:	1c 41 30 01 	mov	304(r1),r12	;0x00130
    5068:	cc 43 00 00 	mov.b	#0,	0(r12)	;r3 As==00

0000506c <.L123>:
    506c:	1c 41 30 01 	mov	304(r1),r12	;0x00130
    5070:	5c 4c 01 00 	mov.b	1(r12),	r12	;
    5074:	8c 11       	sxt	r12		;

00005076 <.Loc.129.2>:
    5076:	0d 4c       	mov	r12,	r13	;
    5078:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    507c:	4c ed       	xor.b	r13,	r12	;
    507e:	4c 8d       	sub.b	r13,	r12	;
    5080:	4d 4c       	mov.b	r12,	r13	;

00005082 <.Loc.129.2>:
    5082:	7c 40 09 00 	mov.b	#9,	r12	;
    5086:	4c 9d       	cmp.b	r13,	r12	;
    5088:	04 28       	jnc	$+10     	;abs 0x5092

0000508a <.Loc.130.2>:
    508a:	1c 41 30 01 	mov	304(r1),r12	;0x00130
    508e:	cc 43 01 00 	mov.b	#0,	1(r12)	;r3 As==00

00005092 <.L124>:
    5092:	1c 41 30 01 	mov	304(r1),r12	;0x00130
    5096:	5c 4c 02 00 	mov.b	2(r12),	r12	;
    509a:	8c 11       	sxt	r12		;

0000509c <.Loc.131.2>:
    509c:	0d 4c       	mov	r12,	r13	;
    509e:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    50a2:	4c ed       	xor.b	r13,	r12	;
    50a4:	4c 8d       	sub.b	r13,	r12	;
    50a6:	4d 4c       	mov.b	r12,	r13	;

000050a8 <.Loc.131.2>:
    50a8:	7c 40 09 00 	mov.b	#9,	r12	;
    50ac:	4c 9d       	cmp.b	r13,	r12	;
    50ae:	04 28       	jnc	$+10     	;abs 0x50b8

000050b0 <.Loc.132.2>:
    50b0:	1c 41 30 01 	mov	304(r1),r12	;0x00130
    50b4:	cc 43 02 00 	mov.b	#0,	2(r12)	;r3 As==00

000050b8 <.L125>:
    50b8:	91 53 32 01 	inc	306(r1)		;

000050bc <.L122>:
    50bc:	6c 43       	mov.b	#2,	r12	;r3 As==10
    50be:	1c 91 32 01 	cmp	306(r1),r12	;0x00132
    50c2:	b8 2f       	jc	$-142    	;abs 0x5034

000050c4 <.Loc.134.2>:
    50c4:	03 43       	nop			
    50c6:	3f 40 46 01 	mov	#326,	r15	;#0x0146
    50ca:	0f 51       	add	r1,	r15	;
    50cc:	3f 50 d8 fe 	add	#-296,	r15	;#0xfed8
    50d0:	81 4f 2e 01 	mov	r15,	302(r1)	; 0x012e
    50d4:	3c 40 46 01 	mov	#326,	r12	;#0x0146
    50d8:	0c 51       	add	r1,	r12	;
    50da:	3c 50 dd fe 	add	#-291,	r12	;#0xfedd
    50de:	81 4c 2c 01 	mov	r12,	300(r1)	; 0x012c

000050e2 <.LBB322>:
    50e2:	81 43 28 01 	mov	#0,	296(r1)	;r3 As==00, 0x0128
    50e6:	81 43 2a 01 	mov	#0,	298(r1)	;r3 As==00, 0x012a

000050ea <.Loc.137.2>:
    50ea:	81 43 24 01 	mov	#0,	292(r1)	;r3 As==00, 0x0124
    50ee:	81 43 26 01 	mov	#0,	294(r1)	;r3 As==00, 0x0126

000050f2 <.Loc.137.2>:
    50f2:	81 43 20 01 	mov	#0,	288(r1)	;r3 As==00, 0x0120
    50f6:	81 43 22 01 	mov	#0,	290(r1)	;r3 As==00, 0x0122

000050fa <.Loc.138.2>:
    50fa:	81 43 1c 01 	mov	#0,	284(r1)	;r3 As==00, 0x011c
    50fe:	81 43 1e 01 	mov	#0,	286(r1)	;r3 As==00, 0x011e

00005102 <.Loc.138.2>:
    5102:	81 43 18 01 	mov	#0,	280(r1)	;r3 As==00, 0x0118
    5106:	81 43 1a 01 	mov	#0,	282(r1)	;r3 As==00, 0x011a

0000510a <.Loc.138.2>:
    510a:	81 43 14 01 	mov	#0,	276(r1)	;r3 As==00, 0x0114
    510e:	81 43 16 01 	mov	#0,	278(r1)	;r3 As==00, 0x0116

00005112 <.Loc.142.2>:
    5112:	81 43 12 01 	mov	#0,	274(r1)	;r3 As==00, 0x0112

00005116 <.Loc.142.2>:
    5116:	4c 3c       	jmp	$+154    	;abs 0x51b0

00005118 <.L128>:
    5118:	1d 41 12 01 	mov	274(r1),r13	;0x00112
    511c:	0c 4d       	mov	r13,	r12	;
    511e:	5c 02       	rlam	#1,	r12	;
    5120:	0c 5d       	add	r13,	r12	;
    5122:	1c 51 2c 01 	add	300(r1),r12	;0x0012c

00005126 <.Loc.143.2>:
    5126:	6e 4c       	mov.b	@r12,	r14	;
    5128:	8e 11       	sxt	r14		;
    512a:	0c 4e       	mov	r14,	r12	;
    512c:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5130:	0d 7d       	subc	r13,	r13	;
    5132:	3d e3       	inv	r13		;

00005134 <.Loc.143.2>:
    5134:	0e 4c       	mov	r12,	r14	;
    5136:	0f 4d       	mov	r13,	r15	;
    5138:	1e 51 28 01 	add	296(r1),r14	;0x00128
    513c:	1f 61 2a 01 	addc	298(r1),r15	;0x0012a
    5140:	81 4e 28 01 	mov	r14,	296(r1)	; 0x0128
    5144:	81 4f 2a 01 	mov	r15,	298(r1)	; 0x012a

00005148 <.Loc.144.2>:
    5148:	1d 41 12 01 	mov	274(r1),r13	;0x00112
    514c:	0c 4d       	mov	r13,	r12	;
    514e:	5c 02       	rlam	#1,	r12	;
    5150:	0c 5d       	add	r13,	r12	;
    5152:	1c 51 2c 01 	add	300(r1),r12	;0x0012c

00005156 <.Loc.144.2>:
    5156:	5e 4c 01 00 	mov.b	1(r12),	r14	;
    515a:	8e 11       	sxt	r14		;
    515c:	0c 4e       	mov	r14,	r12	;
    515e:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5162:	0d 7d       	subc	r13,	r13	;
    5164:	3d e3       	inv	r13		;

00005166 <.Loc.144.2>:
    5166:	0e 4c       	mov	r12,	r14	;
    5168:	0f 4d       	mov	r13,	r15	;
    516a:	1e 51 24 01 	add	292(r1),r14	;0x00124
    516e:	1f 61 26 01 	addc	294(r1),r15	;0x00126
    5172:	81 4e 24 01 	mov	r14,	292(r1)	; 0x0124
    5176:	81 4f 26 01 	mov	r15,	294(r1)	; 0x0126

0000517a <.Loc.145.2>:
    517a:	1d 41 12 01 	mov	274(r1),r13	;0x00112
    517e:	0c 4d       	mov	r13,	r12	;
    5180:	5c 02       	rlam	#1,	r12	;
    5182:	0c 5d       	add	r13,	r12	;
    5184:	1c 51 2c 01 	add	300(r1),r12	;0x0012c

00005188 <.Loc.145.2>:
    5188:	5e 4c 02 00 	mov.b	2(r12),	r14	;
    518c:	8e 11       	sxt	r14		;
    518e:	0c 4e       	mov	r14,	r12	;
    5190:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5194:	0d 7d       	subc	r13,	r13	;
    5196:	3d e3       	inv	r13		;

00005198 <.Loc.145.2>:
    5198:	0e 4c       	mov	r12,	r14	;
    519a:	0f 4d       	mov	r13,	r15	;
    519c:	1e 51 20 01 	add	288(r1),r14	;0x00120
    51a0:	1f 61 22 01 	addc	290(r1),r15	;0x00122
    51a4:	81 4e 20 01 	mov	r14,	288(r1)	; 0x0120
    51a8:	81 4f 22 01 	mov	r15,	290(r1)	; 0x0122

000051ac <.Loc.142.2>:
    51ac:	91 53 12 01 	inc	274(r1)		;

000051b0 <.L127>:
    51b0:	6c 43       	mov.b	#2,	r12	;r3 As==10
    51b2:	1c 91 12 01 	cmp	274(r1),r12	;0x00112
    51b6:	b0 37       	jge	$-158    	;abs 0x5118

000051b8 <.Loc.147.2>:
    51b8:	1c 41 28 01 	mov	296(r1),r12	;0x00128
    51bc:	1d 41 2a 01 	mov	298(r1),r13	;0x0012a
    51c0:	7e 40 03 00 	mov.b	#3,	r14	;
    51c4:	4f 43       	clr.b	r15		;
    51c6:	b0 12 86 5e 	call	#24198		;#0x5e86
    51ca:	81 4c 28 01 	mov	r12,	296(r1)	; 0x0128
    51ce:	81 4d 2a 01 	mov	r13,	298(r1)	; 0x012a

000051d2 <.Loc.148.2>:
    51d2:	1c 41 24 01 	mov	292(r1),r12	;0x00124
    51d6:	1d 41 26 01 	mov	294(r1),r13	;0x00126
    51da:	7e 40 03 00 	mov.b	#3,	r14	;
    51de:	4f 43       	clr.b	r15		;
    51e0:	b0 12 86 5e 	call	#24198		;#0x5e86
    51e4:	81 4c 24 01 	mov	r12,	292(r1)	; 0x0124
    51e8:	81 4d 26 01 	mov	r13,	294(r1)	; 0x0126

000051ec <.Loc.149.2>:
    51ec:	1c 41 20 01 	mov	288(r1),r12	;0x00120
    51f0:	1d 41 22 01 	mov	290(r1),r13	;0x00122
    51f4:	7e 40 03 00 	mov.b	#3,	r14	;
    51f8:	4f 43       	clr.b	r15		;
    51fa:	b0 12 86 5e 	call	#24198		;#0x5e86
    51fe:	81 4c 20 01 	mov	r12,	288(r1)	; 0x0120
    5202:	81 4d 22 01 	mov	r13,	290(r1)	; 0x0122

00005206 <.Loc.152.2>:
    5206:	81 43 12 01 	mov	#0,	274(r1)	;r3 As==00, 0x0112

0000520a <.Loc.152.2>:
    520a:	61 3c       	jmp	$+196    	;abs 0x52ce

0000520c <.L130>:
    520c:	1d 41 12 01 	mov	274(r1),r13	;0x00112
    5210:	0c 4d       	mov	r13,	r12	;
    5212:	5c 02       	rlam	#1,	r12	;
    5214:	0c 5d       	add	r13,	r12	;
    5216:	1c 51 2c 01 	add	300(r1),r12	;0x0012c

0000521a <.Loc.153.2>:
    521a:	6c 4c       	mov.b	@r12,	r12	;
    521c:	8c 11       	sxt	r12		;

0000521e <.Loc.153.2>:
    521e:	1d 41 28 01 	mov	296(r1),r13	;0x00128
    5222:	0c 8d       	sub	r13,	r12	;

00005224 <.Loc.153.2>:
    5224:	0d 4c       	mov	r12,	r13	;
    5226:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    522a:	0c ed       	xor	r13,	r12	;
    522c:	0c 8d       	sub	r13,	r12	;
    522e:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5232:	0d 7d       	subc	r13,	r13	;
    5234:	3d e3       	inv	r13		;

00005236 <.Loc.153.2>:
    5236:	0e 4c       	mov	r12,	r14	;
    5238:	0f 4d       	mov	r13,	r15	;
    523a:	1e 51 1c 01 	add	284(r1),r14	;0x0011c
    523e:	1f 61 1e 01 	addc	286(r1),r15	;0x0011e
    5242:	81 4e 1c 01 	mov	r14,	284(r1)	; 0x011c
    5246:	81 4f 1e 01 	mov	r15,	286(r1)	; 0x011e

0000524a <.Loc.154.2>:
    524a:	1d 41 12 01 	mov	274(r1),r13	;0x00112
    524e:	0c 4d       	mov	r13,	r12	;
    5250:	5c 02       	rlam	#1,	r12	;
    5252:	0c 5d       	add	r13,	r12	;
    5254:	1c 51 2c 01 	add	300(r1),r12	;0x0012c

00005258 <.Loc.154.2>:
    5258:	5c 4c 01 00 	mov.b	1(r12),	r12	;
    525c:	8c 11       	sxt	r12		;

0000525e <.Loc.154.2>:
    525e:	1d 41 24 01 	mov	292(r1),r13	;0x00124
    5262:	0c 8d       	sub	r13,	r12	;

00005264 <.Loc.154.2>:
    5264:	0d 4c       	mov	r12,	r13	;
    5266:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    526a:	0c ed       	xor	r13,	r12	;
    526c:	0c 8d       	sub	r13,	r12	;
    526e:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5272:	0d 7d       	subc	r13,	r13	;
    5274:	3d e3       	inv	r13		;

00005276 <.Loc.154.2>:
    5276:	0e 4c       	mov	r12,	r14	;
    5278:	0f 4d       	mov	r13,	r15	;
    527a:	1e 51 18 01 	add	280(r1),r14	;0x00118
    527e:	1f 61 1a 01 	addc	282(r1),r15	;0x0011a
    5282:	81 4e 18 01 	mov	r14,	280(r1)	; 0x0118
    5286:	81 4f 1a 01 	mov	r15,	282(r1)	; 0x011a

0000528a <.Loc.155.2>:
    528a:	1d 41 12 01 	mov	274(r1),r13	;0x00112
    528e:	0c 4d       	mov	r13,	r12	;
    5290:	5c 02       	rlam	#1,	r12	;
    5292:	0c 5d       	add	r13,	r12	;
    5294:	1c 51 2c 01 	add	300(r1),r12	;0x0012c

00005298 <.Loc.155.2>:
    5298:	5c 4c 02 00 	mov.b	2(r12),	r12	;
    529c:	8c 11       	sxt	r12		;

0000529e <.Loc.155.2>:
    529e:	1d 41 20 01 	mov	288(r1),r13	;0x00120
    52a2:	0c 8d       	sub	r13,	r12	;

000052a4 <.Loc.155.2>:
    52a4:	0d 4c       	mov	r12,	r13	;
    52a6:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    52aa:	0c ed       	xor	r13,	r12	;
    52ac:	0c 8d       	sub	r13,	r12	;
    52ae:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    52b2:	0d 7d       	subc	r13,	r13	;
    52b4:	3d e3       	inv	r13		;

000052b6 <.Loc.155.2>:
    52b6:	0e 4c       	mov	r12,	r14	;
    52b8:	0f 4d       	mov	r13,	r15	;
    52ba:	1e 51 14 01 	add	276(r1),r14	;0x00114
    52be:	1f 61 16 01 	addc	278(r1),r15	;0x00116
    52c2:	81 4e 14 01 	mov	r14,	276(r1)	; 0x0114
    52c6:	81 4f 16 01 	mov	r15,	278(r1)	; 0x0116

000052ca <.Loc.152.2>:
    52ca:	91 53 12 01 	inc	274(r1)		;

000052ce <.L129>:
    52ce:	6c 43       	mov.b	#2,	r12	;r3 As==10
    52d0:	1c 91 12 01 	cmp	274(r1),r12	;0x00112
    52d4:	9b 37       	jge	$-200    	;abs 0x520c

000052d6 <.Loc.157.2>:
    52d6:	1c 41 1c 01 	mov	284(r1),r12	;0x0011c
    52da:	1d 41 1e 01 	mov	286(r1),r13	;0x0011e
    52de:	7e 40 03 00 	mov.b	#3,	r14	;
    52e2:	4f 43       	clr.b	r15		;
    52e4:	b0 12 86 5e 	call	#24198		;#0x5e86
    52e8:	81 4c 1c 01 	mov	r12,	284(r1)	; 0x011c
    52ec:	81 4d 1e 01 	mov	r13,	286(r1)	; 0x011e

000052f0 <.Loc.158.2>:
    52f0:	1c 41 18 01 	mov	280(r1),r12	;0x00118
    52f4:	1d 41 1a 01 	mov	282(r1),r13	;0x0011a
    52f8:	7e 40 03 00 	mov.b	#3,	r14	;
    52fc:	4f 43       	clr.b	r15		;
    52fe:	b0 12 86 5e 	call	#24198		;#0x5e86
    5302:	81 4c 18 01 	mov	r12,	280(r1)	; 0x0118
    5306:	81 4d 1a 01 	mov	r13,	282(r1)	; 0x011a

0000530a <.Loc.159.2>:
    530a:	1c 41 14 01 	mov	276(r1),r12	;0x00114
    530e:	1d 41 16 01 	mov	278(r1),r13	;0x00116
    5312:	7e 40 03 00 	mov.b	#3,	r14	;
    5316:	4f 43       	clr.b	r15		;
    5318:	b0 12 86 5e 	call	#24198		;#0x5e86
    531c:	81 4c 14 01 	mov	r12,	276(r1)	; 0x0114
    5320:	81 4d 16 01 	mov	r13,	278(r1)	; 0x0116

00005324 <.Loc.161.2>:
    5324:	1c 41 28 01 	mov	296(r1),r12	;0x00128
    5328:	1d 41 28 01 	mov	296(r1),r13	;0x00128
    532c:	b0 12 b2 65 	call	#26034		;#0x65b2
    5330:	0a 4c       	mov	r12,	r10	;
    5332:	1c 41 24 01 	mov	292(r1),r12	;0x00124
    5336:	1d 41 24 01 	mov	292(r1),r13	;0x00124
    533a:	b0 12 b2 65 	call	#26034		;#0x65b2
    533e:	0a 5c       	add	r12,	r10	;

00005340 <.Loc.161.2>:
    5340:	1c 41 20 01 	mov	288(r1),r12	;0x00120
    5344:	1d 41 20 01 	mov	288(r1),r13	;0x00120
    5348:	b0 12 b2 65 	call	#26034		;#0x65b2

0000534c <.Loc.161.2>:
    534c:	0f 4a       	mov	r10,	r15	;
    534e:	0f 5c       	add	r12,	r15	;
    5350:	81 4f 10 01 	mov	r15,	272(r1)	; 0x0110

00005354 <.Loc.162.2>:
    5354:	1c 41 1c 01 	mov	284(r1),r12	;0x0011c
    5358:	1d 41 1c 01 	mov	284(r1),r13	;0x0011c
    535c:	b0 12 b2 65 	call	#26034		;#0x65b2
    5360:	0a 4c       	mov	r12,	r10	;
    5362:	1c 41 18 01 	mov	280(r1),r12	;0x00118
    5366:	1d 41 18 01 	mov	280(r1),r13	;0x00118
    536a:	b0 12 b2 65 	call	#26034		;#0x65b2
    536e:	0a 5c       	add	r12,	r10	;

00005370 <.Loc.162.2>:
    5370:	1c 41 14 01 	mov	276(r1),r12	;0x00114
    5374:	1d 41 14 01 	mov	276(r1),r13	;0x00114
    5378:	b0 12 b2 65 	call	#26034		;#0x65b2

0000537c <.Loc.162.2>:
    537c:	0d 4a       	mov	r10,	r13	;
    537e:	0d 5c       	add	r12,	r13	;
    5380:	81 4d 0e 01 	mov	r13,	270(r1)	; 0x010e

00005384 <.Loc.164.2>:
    5384:	1e 41 10 01 	mov	272(r1),r14	;0x00110
    5388:	0c 4e       	mov	r14,	r12	;
    538a:	0d 43       	clr	r13		;
    538c:	81 4c 0a 01 	mov	r12,	266(r1)	; 0x010a
    5390:	81 4d 0c 01 	mov	r13,	268(r1)	; 0x010c

00005394 <.LBB324>:
    5394:	b1 40 00 80 	mov	#-32768,262(r1)	;#0x8000, 0x0106
    5398:	06 01 
    539a:	81 43 08 01 	mov	#0,	264(r1)	;r3 As==00, 0x0108

0000539e <.Loc.72.2>:
    539e:	b1 40 00 80 	mov	#-32768,258(r1)	;#0x8000, 0x0102
    53a2:	02 01 
    53a4:	81 43 04 01 	mov	#0,	260(r1)	;r3 As==00, 0x0104

000053a8 <.L135>:
    53a8:	1e 41 02 01 	mov	258(r1),r14	;0x00102
    53ac:	1f 41 04 01 	mov	260(r1),r15	;0x00104
    53b0:	0c 4e       	mov	r14,	r12	;
    53b2:	0d 4f       	mov	r15,	r13	;
    53b4:	b0 12 f6 65 	call	#26102		;#0x65f6

000053b8 <.Loc.74.2>:
    53b8:	81 9d 0c 01 	cmp	r13,	268(r1)	; 0x010c
    53bc:	06 28       	jnc	$+14     	;abs 0x53ca
    53be:	81 9d 0c 01 	cmp	r13,	268(r1)	; 0x010c
    53c2:	09 20       	jnz	$+20     	;abs 0x53d6
    53c4:	81 9c 0a 01 	cmp	r12,	266(r1)	; 0x010a
    53c8:	06 2c       	jc	$+14     	;abs 0x53d6

000053ca <.L209>:
    53ca:	91 e1 06 01 	xor	262(r1),258(r1)	;0x00106, 0x0102
    53ce:	02 01 
    53d0:	91 e1 08 01 	xor	264(r1),260(r1)	;0x00108, 0x0104
    53d4:	04 01 

000053d6 <.L131>:
    53d6:	12 c3       	clrc			
    53d8:	11 10 08 01 	rrc	264(r1)	;00108
    53dc:	11 10 06 01 	rrc	262(r1)	;00106

000053e0 <.Loc.77.2>:
    53e0:	1c 41 06 01 	mov	262(r1),r12	;0x00106
    53e4:	1c d1 08 01 	bis	264(r1),r12	;0x00108
    53e8:	0c 93       	cmp	#0,	r12	;r3 As==00
    53ea:	19 20       	jnz	$+52     	;abs 0x541e

000053ec <.Loc.78.2>:
    53ec:	1d 41 02 01 	mov	258(r1),r13	;0x00102

000053f0 <.LBE324>:
    53f0:	1c 41 2e 01 	mov	302(r1),r12	;0x0012e
    53f4:	8c 4d 00 00 	mov	r13,	0(r12)	;

000053f8 <.Loc.165.2>:
    53f8:	1f 41 0e 01 	mov	270(r1),r15	;0x0010e
    53fc:	0c 4f       	mov	r15,	r12	;
    53fe:	0d 43       	clr	r13		;
    5400:	81 4c fe 00 	mov	r12,	254(r1)	; 0x00fe
    5404:	81 4d 00 01 	mov	r13,	256(r1)	; 0x0100

00005408 <.LBB327>:
    5408:	b1 40 00 80 	mov	#-32768,250(r1)	;#0x8000, 0x00fa
    540c:	fa 00 
    540e:	81 43 fc 00 	mov	#0,	252(r1)	;r3 As==00, 0x00fc

00005412 <.Loc.72.2>:
    5412:	b1 40 00 80 	mov	#-32768,246(r1)	;#0x8000, 0x00f6
    5416:	f6 00 
    5418:	81 43 f8 00 	mov	#0,	248(r1)	;r3 As==00, 0x00f8
    541c:	07 3c       	jmp	$+16     	;abs 0x542c

0000541e <.L133>:
    541e:	91 d1 06 01 	bis	262(r1),258(r1)	;0x00106, 0x0102
    5422:	02 01 
    5424:	91 d1 08 01 	bis	264(r1),260(r1)	;0x00108, 0x0104
    5428:	04 01 

0000542a <.Loc.74.2>:
    542a:	be 3f       	jmp	$-130    	;abs 0x53a8

0000542c <.L140>:
    542c:	1e 41 f6 00 	mov	246(r1),r14	;0x000f6
    5430:	1f 41 f8 00 	mov	248(r1),r15	;0x000f8
    5434:	0c 4e       	mov	r14,	r12	;
    5436:	0d 4f       	mov	r15,	r13	;
    5438:	b0 12 f6 65 	call	#26102		;#0x65f6

0000543c <.Loc.74.2>:
    543c:	81 9d 00 01 	cmp	r13,	256(r1)	; 0x0100
    5440:	06 28       	jnc	$+14     	;abs 0x544e
    5442:	81 9d 00 01 	cmp	r13,	256(r1)	; 0x0100
    5446:	09 20       	jnz	$+20     	;abs 0x545a
    5448:	81 9c fe 00 	cmp	r12,	254(r1)	; 0x00fe
    544c:	06 2c       	jc	$+14     	;abs 0x545a

0000544e <.L211>:
    544e:	91 e1 fa 00 	xor	250(r1),246(r1)	;0x000fa, 0x00f6
    5452:	f6 00 
    5454:	91 e1 fc 00 	xor	252(r1),248(r1)	;0x000fc, 0x00f8
    5458:	f8 00 

0000545a <.L136>:
    545a:	12 c3       	clrc			
    545c:	11 10 fc 00 	rrc	252(r1)	;000fc
    5460:	11 10 fa 00 	rrc	250(r1)	;000fa

00005464 <.Loc.77.2>:
    5464:	1c 41 fa 00 	mov	250(r1),r12	;0x000fa
    5468:	1c d1 fc 00 	bis	252(r1),r12	;0x000fc
    546c:	0c 93       	cmp	#0,	r12	;r3 As==00
    546e:	07 20       	jnz	$+16     	;abs 0x547e

00005470 <.Loc.78.2>:
    5470:	1d 41 f6 00 	mov	246(r1),r13	;0x000f6

00005474 <.LBE332>:
    5474:	1c 41 2e 01 	mov	302(r1),r12	;0x0012e
    5478:	8c 4d 02 00 	mov	r13,	2(r12)	;

0000547c <.Loc.166.2>:
    547c:	07 3c       	jmp	$+16     	;abs 0x548c

0000547e <.L138>:
    547e:	91 d1 fa 00 	bis	250(r1),246(r1)	;0x000fa, 0x00f6
    5482:	f6 00 
    5484:	91 d1 fc 00 	bis	252(r1),248(r1)	;0x000fc, 0x00f8
    5488:	f8 00 

0000548a <.Loc.74.2>:
    548a:	d0 3f       	jmp	$-94     	;abs 0x542c

0000548c <.L221>:
    548c:	1c 41 3c 01 	mov	316(r1),r12	;0x0013c
    5490:	5c 06       	rlam	#2,	r12	;
    5492:	1c 51 42 01 	add	322(r1),r12	;0x00142

00005496 <.Loc.222.2>:
    5496:	9c 41 1e 00 	mov	30(r1),	0(r12)	;0x0001e
    549a:	00 00 
    549c:	9c 41 20 00 	mov	32(r1),	2(r12)	;0x00020
    54a0:	02 00 

000054a2 <.Loc.218.2>:
    54a2:	91 53 3c 01 	inc	316(r1)		;

000054a6 <.L99>:
    54a6:	7c 40 0f 00 	mov.b	#15,	r12	;#0x000f
    54aa:	1c 91 3c 01 	cmp	316(r1),r12	;0x0013c
    54ae:	02 28       	jnc	$+6      	;abs 0x54b4
    54b0:	80 00 04 4e 	mova	#19972,	r0	;0x04e04

000054b4 <.Loc.230.2>:
    54b4:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    54b8:	5c c3       	bic.b	#1,	r12	;r3 As==01
    54ba:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    54be:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000054c2 <.Loc.236.2>:
    54c2:	03 43       	nop			

000054c4 <.LBE285>:
    54c4:	b0 12 10 42 	call	#16912		;#0x4210

000054c8 <.Loc.324.2>:
    54c8:	3c 40 00 24 	mov	#9216,	r12	;#0x2400
    54cc:	7d 40 f4 00 	mov.b	#244,	r13	;#0x00f4
    54d0:	b0 12 88 42 	call	#17032		;#0x4288

000054d4 <.Loc.329.2>:
    54d4:	82 43 82 1c 	mov	#0,	&0x1c82	;r3 As==00

000054d8 <.Loc.331.2>:
    54d8:	b0 12 e8 41 	call	#16872		;#0x41e8

000054dc <.LBB334>:
    54dc:	81 43 44 01 	mov	#0,	324(r1)	;r3 As==00, 0x0144

000054e0 <.Loc.332.2>:
    54e0:	30 40 3e 5d 	br	#0x5d3e		;

000054e4 <.L199>:
    54e4:	b1 40 02 1c 	mov	#7170,	166(r1)	;#0x1c02, 0x00a6
    54e8:	a6 00 

000054ea <.LBB335>:
    54ea:	81 43 12 00 	mov	#0,	18(r1)	;r3 As==00, 0x0012
    54ee:	81 43 14 00 	mov	#0,	20(r1)	;r3 As==00, 0x0014
    54f2:	81 43 16 00 	mov	#0,	22(r1)	;r3 As==00, 0x0016

000054f6 <.Loc.247.2>:
    54f6:	81 43 a4 00 	mov	#0,	164(r1)	;r3 As==00, 0x00a4

000054fa <.Loc.247.2>:
    54fa:	30 40 2a 5d 	br	#0x5d2a		;

000054fe <.L198>:
    54fe:	b1 90 20 00 	cmp	#32,	164(r1)	;#0x0020, 0x00a4
    5502:	a4 00 
    5504:	0c 20       	jnz	$+26     	;abs 0x551e

00005506 <.Loc.251.2>:
    5506:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82
    550a:	0d 43       	clr	r13		;
    550c:	0d 8c       	sub	r12,	r13	;
    550e:	0c dd       	bis	r13,	r12	;
    5510:	3c e3       	inv	r12		;
    5512:	4e 19 0c 10 	rpt #15 { rrux.w	r12		;
    5516:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

0000551a <.Loc.251.2>:
    551a:	82 4c 82 1c 	mov	r12,	&0x1c82	;

0000551e <.L144>:
    551e:	3c 40 46 01 	mov	#326,	r12	;#0x0146
    5522:	0c 51       	add	r1,	r12	;
    5524:	3c 50 c3 fe 	add	#-317,	r12	;#0xfec3
    5528:	81 4c a2 00 	mov	r12,	162(r1)	; 0x00a2

0000552c <.LBB337>:
    552c:	81 43 a0 00 	mov	#0,	160(r1)	;r3 As==00, 0x00a0

00005530 <.Loc.115.2>:
    5530:	fc 3c       	jmp	$+506    	;abs 0x572a

00005532 <.L166>:
    5532:	3d 40 46 01 	mov	#326,	r13	;#0x0146
    5536:	0d 51       	add	r1,	r13	;
    5538:	3d 50 bb fe 	add	#-325,	r13	;#0xfebb
    553c:	81 4d 9e 00 	mov	r13,	158(r1)	; 0x009e

00005540 <.LBB339>:
    5540:	1c 42 82 1c 	mov	&0x1c82,r12	;0x1c82

00005544 <.Loc.96.2>:
    5544:	0c 93       	cmp	#0,	r12	;r3 As==00
    5546:	6d 20       	jnz	$+220    	;abs 0x5622

00005548 <.LBB341>:
    5548:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    554c:	5c f3       	and.b	#1,	r12	;r3 As==01

0000554e <.Loc.26.2>:
    554e:	0c 93       	cmp	#0,	r12	;r3 As==00
    5550:	08 24       	jz	$+18     	;abs 0x5562

00005552 <.Loc.27.2>:
    5552:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5556:	5c 03       	rrum	#1,	r12	;

00005558 <.Loc.27.2>:
    5558:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

0000555c <.Loc.27.2>:
    555c:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    5560:	05 3c       	jmp	$+12     	;abs 0x556c

00005562 <.L147>:
    5562:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5566:	5c 03       	rrum	#1,	r12	;
    5568:	82 4c 00 1c 	mov	r12,	&0x1c00	;

0000556c <.L148>:
    556c:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00005570 <.LBE341>:
    5570:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    5574:	7c f0 03 00 	and.b	#3,	r12	;
    5578:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

0000557c <.Loc.98.2>:
    557c:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5580:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    5584:	4d 4c       	mov.b	r12,	r13	;
    5586:	8d 11       	sxt	r13		;

00005588 <.Loc.98.2>:
    5588:	1c 41 9e 00 	mov	158(r1),r12	;0x0009e
    558c:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

00005590 <.LBB343>:
    5590:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5594:	5c f3       	and.b	#1,	r12	;r3 As==01

00005596 <.Loc.26.2>:
    5596:	0c 93       	cmp	#0,	r12	;r3 As==00
    5598:	08 24       	jz	$+18     	;abs 0x55aa

0000559a <.Loc.27.2>:
    559a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    559e:	5c 03       	rrum	#1,	r12	;

000055a0 <.Loc.27.2>:
    55a0:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000055a4 <.Loc.27.2>:
    55a4:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    55a8:	05 3c       	jmp	$+12     	;abs 0x55b4

000055aa <.L150>:
    55aa:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    55ae:	5c 03       	rrum	#1,	r12	;
    55b0:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000055b4 <.L151>:
    55b4:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000055b8 <.LBE343>:
    55b8:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    55bc:	7c f0 03 00 	and.b	#3,	r12	;
    55c0:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

000055c4 <.Loc.99.2>:
    55c4:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    55c8:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    55cc:	4d 4c       	mov.b	r12,	r13	;
    55ce:	8d 11       	sxt	r13		;

000055d0 <.Loc.99.2>:
    55d0:	1c 41 9e 00 	mov	158(r1),r12	;0x0009e
    55d4:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

000055d8 <.LBB345>:
    55d8:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    55dc:	5c f3       	and.b	#1,	r12	;r3 As==01

000055de <.Loc.26.2>:
    55de:	0c 93       	cmp	#0,	r12	;r3 As==00
    55e0:	08 24       	jz	$+18     	;abs 0x55f2

000055e2 <.Loc.27.2>:
    55e2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    55e6:	5c 03       	rrum	#1,	r12	;

000055e8 <.Loc.27.2>:
    55e8:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000055ec <.Loc.27.2>:
    55ec:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    55f0:	05 3c       	jmp	$+12     	;abs 0x55fc

000055f2 <.L153>:
    55f2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    55f6:	5c 03       	rrum	#1,	r12	;
    55f8:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000055fc <.L154>:
    55fc:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00005600 <.LBE345>:
    5600:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    5604:	7c f0 03 00 	and.b	#3,	r12	;
    5608:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

0000560c <.Loc.100.2>:
    560c:	7c 50 fe ff 	add.b	#-2,	r12	;#0xfffe
    5610:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    5614:	4d 4c       	mov.b	r12,	r13	;
    5616:	8d 11       	sxt	r13		;

00005618 <.Loc.100.2>:
    5618:	1c 41 9e 00 	mov	158(r1),r12	;0x0009e
    561c:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

00005620 <.Loc.107.2>:
    5620:	6c 3c       	jmp	$+218    	;abs 0x56fa

00005622 <.L146>:
    5622:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5626:	5c f3       	and.b	#1,	r12	;r3 As==01

00005628 <.Loc.26.2>:
    5628:	0c 93       	cmp	#0,	r12	;r3 As==00
    562a:	08 24       	jz	$+18     	;abs 0x563c

0000562c <.Loc.27.2>:
    562c:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5630:	5c 03       	rrum	#1,	r12	;

00005632 <.Loc.27.2>:
    5632:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

00005636 <.Loc.27.2>:
    5636:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    563a:	05 3c       	jmp	$+12     	;abs 0x5646

0000563c <.L157>:
    563c:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5640:	5c 03       	rrum	#1,	r12	;
    5642:	82 4c 00 1c 	mov	r12,	&0x1c00	;

00005646 <.L158>:
    5646:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

0000564a <.LBE347>:
    564a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    564e:	b0 12 fc 5d 	call	#24060		;#0x5dfc

00005652 <.Loc.103.2>:
    5652:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    5656:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    565a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    565e:	4d 4c       	mov.b	r12,	r13	;
    5660:	8d 11       	sxt	r13		;

00005662 <.Loc.103.2>:
    5662:	1c 41 9e 00 	mov	158(r1),r12	;0x0009e
    5666:	cc 4d 00 00 	mov.b	r13,	0(r12)	;

0000566a <.LBB349>:
    566a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    566e:	5c f3       	and.b	#1,	r12	;r3 As==01

00005670 <.Loc.26.2>:
    5670:	0c 93       	cmp	#0,	r12	;r3 As==00
    5672:	08 24       	jz	$+18     	;abs 0x5684

00005674 <.Loc.27.2>:
    5674:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5678:	5c 03       	rrum	#1,	r12	;

0000567a <.Loc.27.2>:
    567a:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

0000567e <.Loc.27.2>:
    567e:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    5682:	05 3c       	jmp	$+12     	;abs 0x568e

00005684 <.L160>:
    5684:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    5688:	5c 03       	rrum	#1,	r12	;
    568a:	82 4c 00 1c 	mov	r12,	&0x1c00	;

0000568e <.L161>:
    568e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

00005692 <.LBE349>:
    5692:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    5696:	b0 12 fc 5d 	call	#24060		;#0x5dfc

0000569a <.Loc.104.2>:
    569a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    569e:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    56a2:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    56a6:	4d 4c       	mov.b	r12,	r13	;
    56a8:	8d 11       	sxt	r13		;

000056aa <.Loc.104.2>:
    56aa:	1c 41 9e 00 	mov	158(r1),r12	;0x0009e
    56ae:	cc 4d 01 00 	mov.b	r13,	1(r12)	;

000056b2 <.LBB351>:
    56b2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    56b6:	5c f3       	and.b	#1,	r12	;r3 As==01

000056b8 <.Loc.26.2>:
    56b8:	0c 93       	cmp	#0,	r12	;r3 As==00
    56ba:	08 24       	jz	$+18     	;abs 0x56cc

000056bc <.Loc.27.2>:
    56bc:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    56c0:	5c 03       	rrum	#1,	r12	;

000056c2 <.Loc.27.2>:
    56c2:	3c e0 00 b4 	xor	#-19456,r12	;#0xb400

000056c6 <.Loc.27.2>:
    56c6:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    56ca:	05 3c       	jmp	$+12     	;abs 0x56d6

000056cc <.L163>:
    56cc:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    56d0:	5c 03       	rrum	#1,	r12	;
    56d2:	82 4c 00 1c 	mov	r12,	&0x1c00	;

000056d6 <.L164>:
    56d6:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

000056da <.LBE351>:
    56da:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    56de:	b0 12 fc 5d 	call	#24060		;#0x5dfc

000056e2 <.Loc.105.2>:
    56e2:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    56e6:	7c 50 e2 ff 	add.b	#-30,	r12	;#0xffe2
    56ea:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    56ee:	4d 4c       	mov.b	r12,	r13	;
    56f0:	8d 11       	sxt	r13		;

000056f2 <.Loc.105.2>:
    56f2:	1c 41 9e 00 	mov	158(r1),r12	;0x0009e
    56f6:	cc 4d 02 00 	mov.b	r13,	2(r12)	;

000056fa <.L226>:
    56fa:	03 43       	nop			

000056fc <.LBE339>:
    56fc:	1d 41 a0 00 	mov	160(r1),r13	;0x000a0
    5700:	0e 4d       	mov	r13,	r14	;
    5702:	1e 53       	inc	r14		;
    5704:	81 4e a0 00 	mov	r14,	160(r1)	; 0x00a0

00005708 <.Loc.117.2>:
    5708:	0c 4d       	mov	r13,	r12	;
    570a:	5c 02       	rlam	#1,	r12	;
    570c:	0c 5d       	add	r13,	r12	;
    570e:	1d 41 a2 00 	mov	162(r1),r13	;0x000a2
    5712:	0d 5c       	add	r12,	r13	;

00005714 <.Loc.117.2>:
    5714:	0c 41       	mov	r1,	r12	;
    5716:	1c 53       	inc	r12		;
    5718:	ed 4c 00 00 	mov.b	@r12,	0(r13)	;
    571c:	1c 53       	inc	r12		;
    571e:	ed 4c 01 00 	mov.b	@r12,	1(r13)	;
    5722:	1c 53       	inc	r12		;
    5724:	ed 4c 02 00 	mov.b	@r12,	2(r13)	;
    5728:	1c 53       	inc	r12		;

0000572a <.L145>:
    572a:	6c 43       	mov.b	#2,	r12	;r3 As==10
    572c:	1c 91 a0 00 	cmp	160(r1),r12	;0x000a0
    5730:	00 2f       	jc	$-510    	;abs 0x5532

00005732 <.Loc.119.2>:
    5732:	03 43       	nop			
    5734:	3f 40 46 01 	mov	#326,	r15	;#0x0146
    5738:	0f 51       	add	r1,	r15	;
    573a:	3f 50 c3 fe 	add	#-317,	r15	;#0xfec3
    573e:	81 4f 9c 00 	mov	r15,	156(r1)	; 0x009c

00005742 <.LBB353>:
    5742:	81 43 9a 00 	mov	#0,	154(r1)	;r3 As==00, 0x009a

00005746 <.Loc.123.2>:
    5746:	81 43 9a 00 	mov	#0,	154(r1)	;r3 As==00, 0x009a

0000574a <.Loc.123.2>:
    574a:	44 3c       	jmp	$+138    	;abs 0x57d4

0000574c <.L171>:
    574c:	1d 41 9a 00 	mov	154(r1),r13	;0x0009a
    5750:	0c 4d       	mov	r13,	r12	;
    5752:	5c 02       	rlam	#1,	r12	;
    5754:	0c 5d       	add	r13,	r12	;

00005756 <.Loc.124.2>:
    5756:	1d 41 9c 00 	mov	156(r1),r13	;0x0009c
    575a:	0d 5c       	add	r12,	r13	;
    575c:	81 4d 98 00 	mov	r13,	152(r1)	; 0x0098

00005760 <.Loc.127.2>:
    5760:	1c 41 98 00 	mov	152(r1),r12	;0x00098
    5764:	6c 4c       	mov.b	@r12,	r12	;
    5766:	8c 11       	sxt	r12		;

00005768 <.Loc.127.2>:
    5768:	0d 4c       	mov	r12,	r13	;
    576a:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    576e:	4c ed       	xor.b	r13,	r12	;
    5770:	4c 8d       	sub.b	r13,	r12	;
    5772:	4d 4c       	mov.b	r12,	r13	;

00005774 <.Loc.127.2>:
    5774:	7c 40 09 00 	mov.b	#9,	r12	;
    5778:	4c 9d       	cmp.b	r13,	r12	;
    577a:	04 28       	jnc	$+10     	;abs 0x5784

0000577c <.Loc.128.2>:
    577c:	1c 41 98 00 	mov	152(r1),r12	;0x00098
    5780:	cc 43 00 00 	mov.b	#0,	0(r12)	;r3 As==00

00005784 <.L168>:
    5784:	1c 41 98 00 	mov	152(r1),r12	;0x00098
    5788:	5c 4c 01 00 	mov.b	1(r12),	r12	;
    578c:	8c 11       	sxt	r12		;

0000578e <.Loc.129.2>:
    578e:	0d 4c       	mov	r12,	r13	;
    5790:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    5794:	4c ed       	xor.b	r13,	r12	;
    5796:	4c 8d       	sub.b	r13,	r12	;
    5798:	4d 4c       	mov.b	r12,	r13	;

0000579a <.Loc.129.2>:
    579a:	7c 40 09 00 	mov.b	#9,	r12	;
    579e:	4c 9d       	cmp.b	r13,	r12	;
    57a0:	04 28       	jnc	$+10     	;abs 0x57aa

000057a2 <.Loc.130.2>:
    57a2:	1c 41 98 00 	mov	152(r1),r12	;0x00098
    57a6:	cc 43 01 00 	mov.b	#0,	1(r12)	;r3 As==00

000057aa <.L169>:
    57aa:	1c 41 98 00 	mov	152(r1),r12	;0x00098
    57ae:	5c 4c 02 00 	mov.b	2(r12),	r12	;
    57b2:	8c 11       	sxt	r12		;

000057b4 <.Loc.131.2>:
    57b4:	0d 4c       	mov	r12,	r13	;
    57b6:	46 18 0d 11 	rpt #7 { rrax.w	r13		;
    57ba:	4c ed       	xor.b	r13,	r12	;
    57bc:	4c 8d       	sub.b	r13,	r12	;
    57be:	4d 4c       	mov.b	r12,	r13	;

000057c0 <.Loc.131.2>:
    57c0:	7c 40 09 00 	mov.b	#9,	r12	;
    57c4:	4c 9d       	cmp.b	r13,	r12	;
    57c6:	04 28       	jnc	$+10     	;abs 0x57d0

000057c8 <.Loc.132.2>:
    57c8:	1c 41 98 00 	mov	152(r1),r12	;0x00098
    57cc:	cc 43 02 00 	mov.b	#0,	2(r12)	;r3 As==00

000057d0 <.L170>:
    57d0:	91 53 9a 00 	inc	154(r1)		;

000057d4 <.L167>:
    57d4:	6c 43       	mov.b	#2,	r12	;r3 As==10
    57d6:	1c 91 9a 00 	cmp	154(r1),r12	;0x0009a
    57da:	b8 2f       	jc	$-142    	;abs 0x574c

000057dc <.Loc.134.2>:
    57dc:	03 43       	nop			
    57de:	3e 40 46 01 	mov	#326,	r14	;#0x0146
    57e2:	0e 51       	add	r1,	r14	;
    57e4:	3e 50 be fe 	add	#-322,	r14	;#0xfebe
    57e8:	81 4e 96 00 	mov	r14,	150(r1)	; 0x0096
    57ec:	3f 40 46 01 	mov	#326,	r15	;#0x0146
    57f0:	0f 51       	add	r1,	r15	;
    57f2:	3f 50 c3 fe 	add	#-317,	r15	;#0xfec3
    57f6:	81 4f 94 00 	mov	r15,	148(r1)	; 0x0094

000057fa <.LBB356>:
    57fa:	81 43 90 00 	mov	#0,	144(r1)	;r3 As==00, 0x0090
    57fe:	81 43 92 00 	mov	#0,	146(r1)	;r3 As==00, 0x0092

00005802 <.Loc.137.2>:
    5802:	81 43 8c 00 	mov	#0,	140(r1)	;r3 As==00, 0x008c
    5806:	81 43 8e 00 	mov	#0,	142(r1)	;r3 As==00, 0x008e

0000580a <.Loc.137.2>:
    580a:	81 43 88 00 	mov	#0,	136(r1)	;r3 As==00, 0x0088
    580e:	81 43 8a 00 	mov	#0,	138(r1)	;r3 As==00, 0x008a

00005812 <.Loc.138.2>:
    5812:	81 43 84 00 	mov	#0,	132(r1)	;r3 As==00, 0x0084
    5816:	81 43 86 00 	mov	#0,	134(r1)	;r3 As==00, 0x0086

0000581a <.Loc.138.2>:
    581a:	81 43 80 00 	mov	#0,	128(r1)	;r3 As==00, 0x0080
    581e:	81 43 82 00 	mov	#0,	130(r1)	;r3 As==00, 0x0082

00005822 <.Loc.138.2>:
    5822:	81 43 7c 00 	mov	#0,	124(r1)	;r3 As==00, 0x007c
    5826:	81 43 7e 00 	mov	#0,	126(r1)	;r3 As==00, 0x007e

0000582a <.Loc.142.2>:
    582a:	81 43 7a 00 	mov	#0,	122(r1)	;r3 As==00, 0x007a

0000582e <.Loc.142.2>:
    582e:	4c 3c       	jmp	$+154    	;abs 0x58c8

00005830 <.L173>:
    5830:	1d 41 7a 00 	mov	122(r1),r13	;0x0007a
    5834:	0c 4d       	mov	r13,	r12	;
    5836:	5c 02       	rlam	#1,	r12	;
    5838:	0c 5d       	add	r13,	r12	;
    583a:	1c 51 94 00 	add	148(r1),r12	;0x00094

0000583e <.Loc.143.2>:
    583e:	6e 4c       	mov.b	@r12,	r14	;
    5840:	8e 11       	sxt	r14		;
    5842:	0c 4e       	mov	r14,	r12	;
    5844:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    5848:	0d 7d       	subc	r13,	r13	;
    584a:	3d e3       	inv	r13		;

0000584c <.Loc.143.2>:
    584c:	0e 4c       	mov	r12,	r14	;
    584e:	0f 4d       	mov	r13,	r15	;
    5850:	1e 51 90 00 	add	144(r1),r14	;0x00090
    5854:	1f 61 92 00 	addc	146(r1),r15	;0x00092
    5858:	81 4e 90 00 	mov	r14,	144(r1)	; 0x0090
    585c:	81 4f 92 00 	mov	r15,	146(r1)	; 0x0092

00005860 <.Loc.144.2>:
    5860:	1d 41 7a 00 	mov	122(r1),r13	;0x0007a
    5864:	0c 4d       	mov	r13,	r12	;
    5866:	5c 02       	rlam	#1,	r12	;
    5868:	0c 5d       	add	r13,	r12	;
    586a:	1c 51 94 00 	add	148(r1),r12	;0x00094

0000586e <.Loc.144.2>:
    586e:	5e 4c 01 00 	mov.b	1(r12),	r14	;
    5872:	8e 11       	sxt	r14		;
    5874:	0c 4e       	mov	r14,	r12	;
    5876:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    587a:	0d 7d       	subc	r13,	r13	;
    587c:	3d e3       	inv	r13		;

0000587e <.Loc.144.2>:
    587e:	0e 4c       	mov	r12,	r14	;
    5880:	0f 4d       	mov	r13,	r15	;
    5882:	1e 51 8c 00 	add	140(r1),r14	;0x0008c
    5886:	1f 61 8e 00 	addc	142(r1),r15	;0x0008e
    588a:	81 4e 8c 00 	mov	r14,	140(r1)	; 0x008c
    588e:	81 4f 8e 00 	mov	r15,	142(r1)	; 0x008e

00005892 <.Loc.145.2>:
    5892:	1d 41 7a 00 	mov	122(r1),r13	;0x0007a
    5896:	0c 4d       	mov	r13,	r12	;
    5898:	5c 02       	rlam	#1,	r12	;
    589a:	0c 5d       	add	r13,	r12	;
    589c:	1c 51 94 00 	add	148(r1),r12	;0x00094

000058a0 <.Loc.145.2>:
    58a0:	5e 4c 02 00 	mov.b	2(r12),	r14	;
    58a4:	8e 11       	sxt	r14		;
    58a6:	0c 4e       	mov	r14,	r12	;
    58a8:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    58ac:	0d 7d       	subc	r13,	r13	;
    58ae:	3d e3       	inv	r13		;

000058b0 <.Loc.145.2>:
    58b0:	0e 4c       	mov	r12,	r14	;
    58b2:	0f 4d       	mov	r13,	r15	;
    58b4:	1e 51 88 00 	add	136(r1),r14	;0x00088
    58b8:	1f 61 8a 00 	addc	138(r1),r15	;0x0008a
    58bc:	81 4e 88 00 	mov	r14,	136(r1)	; 0x0088
    58c0:	81 4f 8a 00 	mov	r15,	138(r1)	; 0x008a

000058c4 <.Loc.142.2>:
    58c4:	91 53 7a 00 	inc	122(r1)		;

000058c8 <.L172>:
    58c8:	6c 43       	mov.b	#2,	r12	;r3 As==10
    58ca:	1c 91 7a 00 	cmp	122(r1),r12	;0x0007a
    58ce:	b0 37       	jge	$-158    	;abs 0x5830

000058d0 <.Loc.147.2>:
    58d0:	1c 41 90 00 	mov	144(r1),r12	;0x00090
    58d4:	1d 41 92 00 	mov	146(r1),r13	;0x00092
    58d8:	7e 40 03 00 	mov.b	#3,	r14	;
    58dc:	4f 43       	clr.b	r15		;
    58de:	b0 12 86 5e 	call	#24198		;#0x5e86
    58e2:	81 4c 90 00 	mov	r12,	144(r1)	; 0x0090
    58e6:	81 4d 92 00 	mov	r13,	146(r1)	; 0x0092

000058ea <.Loc.148.2>:
    58ea:	1c 41 8c 00 	mov	140(r1),r12	;0x0008c
    58ee:	1d 41 8e 00 	mov	142(r1),r13	;0x0008e
    58f2:	7e 40 03 00 	mov.b	#3,	r14	;
    58f6:	4f 43       	clr.b	r15		;
    58f8:	b0 12 86 5e 	call	#24198		;#0x5e86
    58fc:	81 4c 8c 00 	mov	r12,	140(r1)	; 0x008c
    5900:	81 4d 8e 00 	mov	r13,	142(r1)	; 0x008e

00005904 <.Loc.149.2>:
    5904:	1c 41 88 00 	mov	136(r1),r12	;0x00088
    5908:	1d 41 8a 00 	mov	138(r1),r13	;0x0008a
    590c:	7e 40 03 00 	mov.b	#3,	r14	;
    5910:	4f 43       	clr.b	r15		;
    5912:	b0 12 86 5e 	call	#24198		;#0x5e86
    5916:	81 4c 88 00 	mov	r12,	136(r1)	; 0x0088
    591a:	81 4d 8a 00 	mov	r13,	138(r1)	; 0x008a

0000591e <.Loc.152.2>:
    591e:	81 43 7a 00 	mov	#0,	122(r1)	;r3 As==00, 0x007a

00005922 <.Loc.152.2>:
    5922:	61 3c       	jmp	$+196    	;abs 0x59e6

00005924 <.L175>:
    5924:	1d 41 7a 00 	mov	122(r1),r13	;0x0007a
    5928:	0c 4d       	mov	r13,	r12	;
    592a:	5c 02       	rlam	#1,	r12	;
    592c:	0c 5d       	add	r13,	r12	;
    592e:	1c 51 94 00 	add	148(r1),r12	;0x00094

00005932 <.Loc.153.2>:
    5932:	6c 4c       	mov.b	@r12,	r12	;
    5934:	8c 11       	sxt	r12		;

00005936 <.Loc.153.2>:
    5936:	1d 41 90 00 	mov	144(r1),r13	;0x00090
    593a:	0c 8d       	sub	r13,	r12	;

0000593c <.Loc.153.2>:
    593c:	0d 4c       	mov	r12,	r13	;
    593e:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5942:	0c ed       	xor	r13,	r12	;
    5944:	0c 8d       	sub	r13,	r12	;
    5946:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    594a:	0d 7d       	subc	r13,	r13	;
    594c:	3d e3       	inv	r13		;

0000594e <.Loc.153.2>:
    594e:	0e 4c       	mov	r12,	r14	;
    5950:	0f 4d       	mov	r13,	r15	;
    5952:	1e 51 84 00 	add	132(r1),r14	;0x00084
    5956:	1f 61 86 00 	addc	134(r1),r15	;0x00086
    595a:	81 4e 84 00 	mov	r14,	132(r1)	; 0x0084
    595e:	81 4f 86 00 	mov	r15,	134(r1)	; 0x0086

00005962 <.Loc.154.2>:
    5962:	1d 41 7a 00 	mov	122(r1),r13	;0x0007a
    5966:	0c 4d       	mov	r13,	r12	;
    5968:	5c 02       	rlam	#1,	r12	;
    596a:	0c 5d       	add	r13,	r12	;
    596c:	1c 51 94 00 	add	148(r1),r12	;0x00094

00005970 <.Loc.154.2>:
    5970:	5c 4c 01 00 	mov.b	1(r12),	r12	;
    5974:	8c 11       	sxt	r12		;

00005976 <.Loc.154.2>:
    5976:	1d 41 8c 00 	mov	140(r1),r13	;0x0008c
    597a:	0c 8d       	sub	r13,	r12	;

0000597c <.Loc.154.2>:
    597c:	0d 4c       	mov	r12,	r13	;
    597e:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5982:	0c ed       	xor	r13,	r12	;
    5984:	0c 8d       	sub	r13,	r12	;
    5986:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    598a:	0d 7d       	subc	r13,	r13	;
    598c:	3d e3       	inv	r13		;

0000598e <.Loc.154.2>:
    598e:	0e 4c       	mov	r12,	r14	;
    5990:	0f 4d       	mov	r13,	r15	;
    5992:	1e 51 80 00 	add	128(r1),r14	;0x00080
    5996:	1f 61 82 00 	addc	130(r1),r15	;0x00082
    599a:	81 4e 80 00 	mov	r14,	128(r1)	; 0x0080
    599e:	81 4f 82 00 	mov	r15,	130(r1)	; 0x0082

000059a2 <.Loc.155.2>:
    59a2:	1d 41 7a 00 	mov	122(r1),r13	;0x0007a
    59a6:	0c 4d       	mov	r13,	r12	;
    59a8:	5c 02       	rlam	#1,	r12	;
    59aa:	0c 5d       	add	r13,	r12	;
    59ac:	1c 51 94 00 	add	148(r1),r12	;0x00094

000059b0 <.Loc.155.2>:
    59b0:	5c 4c 02 00 	mov.b	2(r12),	r12	;
    59b4:	8c 11       	sxt	r12		;

000059b6 <.Loc.155.2>:
    59b6:	1d 41 88 00 	mov	136(r1),r13	;0x00088
    59ba:	0c 8d       	sub	r13,	r12	;

000059bc <.Loc.155.2>:
    59bc:	0d 4c       	mov	r12,	r13	;
    59be:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    59c2:	0c ed       	xor	r13,	r12	;
    59c4:	0c 8d       	sub	r13,	r12	;
    59c6:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    59ca:	0d 7d       	subc	r13,	r13	;
    59cc:	3d e3       	inv	r13		;

000059ce <.Loc.155.2>:
    59ce:	0e 4c       	mov	r12,	r14	;
    59d0:	0f 4d       	mov	r13,	r15	;
    59d2:	1e 51 7c 00 	add	124(r1),r14	;0x0007c
    59d6:	1f 61 7e 00 	addc	126(r1),r15	;0x0007e
    59da:	81 4e 7c 00 	mov	r14,	124(r1)	; 0x007c
    59de:	81 4f 7e 00 	mov	r15,	126(r1)	; 0x007e

000059e2 <.Loc.152.2>:
    59e2:	91 53 7a 00 	inc	122(r1)		;

000059e6 <.L174>:
    59e6:	6c 43       	mov.b	#2,	r12	;r3 As==10
    59e8:	1c 91 7a 00 	cmp	122(r1),r12	;0x0007a
    59ec:	9b 37       	jge	$-200    	;abs 0x5924

000059ee <.Loc.157.2>:
    59ee:	1c 41 84 00 	mov	132(r1),r12	;0x00084
    59f2:	1d 41 86 00 	mov	134(r1),r13	;0x00086
    59f6:	7e 40 03 00 	mov.b	#3,	r14	;
    59fa:	4f 43       	clr.b	r15		;
    59fc:	b0 12 86 5e 	call	#24198		;#0x5e86
    5a00:	81 4c 84 00 	mov	r12,	132(r1)	; 0x0084
    5a04:	81 4d 86 00 	mov	r13,	134(r1)	; 0x0086

00005a08 <.Loc.158.2>:
    5a08:	1c 41 80 00 	mov	128(r1),r12	;0x00080
    5a0c:	1d 41 82 00 	mov	130(r1),r13	;0x00082
    5a10:	7e 40 03 00 	mov.b	#3,	r14	;
    5a14:	4f 43       	clr.b	r15		;
    5a16:	b0 12 86 5e 	call	#24198		;#0x5e86
    5a1a:	81 4c 80 00 	mov	r12,	128(r1)	; 0x0080
    5a1e:	81 4d 82 00 	mov	r13,	130(r1)	; 0x0082

00005a22 <.Loc.159.2>:
    5a22:	1c 41 7c 00 	mov	124(r1),r12	;0x0007c
    5a26:	1d 41 7e 00 	mov	126(r1),r13	;0x0007e
    5a2a:	7e 40 03 00 	mov.b	#3,	r14	;
    5a2e:	4f 43       	clr.b	r15		;
    5a30:	b0 12 86 5e 	call	#24198		;#0x5e86
    5a34:	81 4c 7c 00 	mov	r12,	124(r1)	; 0x007c
    5a38:	81 4d 7e 00 	mov	r13,	126(r1)	; 0x007e

00005a3c <.Loc.161.2>:
    5a3c:	1c 41 90 00 	mov	144(r1),r12	;0x00090
    5a40:	1d 41 90 00 	mov	144(r1),r13	;0x00090
    5a44:	b0 12 b2 65 	call	#26034		;#0x65b2
    5a48:	0a 4c       	mov	r12,	r10	;
    5a4a:	1c 41 8c 00 	mov	140(r1),r12	;0x0008c
    5a4e:	1d 41 8c 00 	mov	140(r1),r13	;0x0008c
    5a52:	b0 12 b2 65 	call	#26034		;#0x65b2
    5a56:	0a 5c       	add	r12,	r10	;

00005a58 <.Loc.161.2>:
    5a58:	1c 41 88 00 	mov	136(r1),r12	;0x00088
    5a5c:	1d 41 88 00 	mov	136(r1),r13	;0x00088
    5a60:	b0 12 b2 65 	call	#26034		;#0x65b2

00005a64 <.Loc.161.2>:
    5a64:	0f 4a       	mov	r10,	r15	;
    5a66:	0f 5c       	add	r12,	r15	;
    5a68:	81 4f 78 00 	mov	r15,	120(r1)	; 0x0078

00005a6c <.Loc.162.2>:
    5a6c:	1c 41 84 00 	mov	132(r1),r12	;0x00084
    5a70:	1d 41 84 00 	mov	132(r1),r13	;0x00084
    5a74:	b0 12 b2 65 	call	#26034		;#0x65b2
    5a78:	0a 4c       	mov	r12,	r10	;
    5a7a:	1c 41 80 00 	mov	128(r1),r12	;0x00080
    5a7e:	1d 41 80 00 	mov	128(r1),r13	;0x00080
    5a82:	b0 12 b2 65 	call	#26034		;#0x65b2
    5a86:	0a 5c       	add	r12,	r10	;

00005a88 <.Loc.162.2>:
    5a88:	1c 41 7c 00 	mov	124(r1),r12	;0x0007c
    5a8c:	1d 41 7c 00 	mov	124(r1),r13	;0x0007c
    5a90:	b0 12 b2 65 	call	#26034		;#0x65b2

00005a94 <.Loc.162.2>:
    5a94:	0d 4a       	mov	r10,	r13	;
    5a96:	0d 5c       	add	r12,	r13	;
    5a98:	81 4d 76 00 	mov	r13,	118(r1)	; 0x0076

00005a9c <.Loc.164.2>:
    5a9c:	1e 41 78 00 	mov	120(r1),r14	;0x00078
    5aa0:	0c 4e       	mov	r14,	r12	;
    5aa2:	0d 43       	clr	r13		;
    5aa4:	81 4c 72 00 	mov	r12,	114(r1)	; 0x0072
    5aa8:	81 4d 74 00 	mov	r13,	116(r1)	; 0x0074

00005aac <.LBB358>:
    5aac:	b1 40 00 80 	mov	#-32768,110(r1)	;#0x8000, 0x006e
    5ab0:	6e 00 
    5ab2:	81 43 70 00 	mov	#0,	112(r1)	;r3 As==00, 0x0070

00005ab6 <.Loc.72.2>:
    5ab6:	b1 40 00 80 	mov	#-32768,106(r1)	;#0x8000, 0x006a
    5aba:	6a 00 
    5abc:	81 43 6c 00 	mov	#0,	108(r1)	;r3 As==00, 0x006c

00005ac0 <.L180>:
    5ac0:	1e 41 6a 00 	mov	106(r1),r14	;0x0006a
    5ac4:	1f 41 6c 00 	mov	108(r1),r15	;0x0006c
    5ac8:	0c 4e       	mov	r14,	r12	;
    5aca:	0d 4f       	mov	r15,	r13	;
    5acc:	b0 12 f6 65 	call	#26102		;#0x65f6

00005ad0 <.Loc.74.2>:
    5ad0:	81 9d 74 00 	cmp	r13,	116(r1)	; 0x0074
    5ad4:	06 28       	jnc	$+14     	;abs 0x5ae2
    5ad6:	81 9d 74 00 	cmp	r13,	116(r1)	; 0x0074
    5ada:	09 20       	jnz	$+20     	;abs 0x5aee
    5adc:	81 9c 72 00 	cmp	r12,	114(r1)	; 0x0072
    5ae0:	06 2c       	jc	$+14     	;abs 0x5aee

00005ae2 <.L214>:
    5ae2:	91 e1 6e 00 	xor	110(r1),106(r1)	;0x0006e, 0x006a
    5ae6:	6a 00 
    5ae8:	91 e1 70 00 	xor	112(r1),108(r1)	;0x00070, 0x006c
    5aec:	6c 00 

00005aee <.L176>:
    5aee:	12 c3       	clrc			
    5af0:	11 10 70 00 	rrc	112(r1)	;00070
    5af4:	11 10 6e 00 	rrc	110(r1)	;0006e

00005af8 <.Loc.77.2>:
    5af8:	1c 41 6e 00 	mov	110(r1),r12	;0x0006e
    5afc:	1c d1 70 00 	bis	112(r1),r12	;0x00070
    5b00:	0c 93       	cmp	#0,	r12	;r3 As==00
    5b02:	19 20       	jnz	$+52     	;abs 0x5b36

00005b04 <.Loc.78.2>:
    5b04:	1d 41 6a 00 	mov	106(r1),r13	;0x0006a

00005b08 <.LBE358>:
    5b08:	1c 41 96 00 	mov	150(r1),r12	;0x00096
    5b0c:	8c 4d 00 00 	mov	r13,	0(r12)	;

00005b10 <.Loc.165.2>:
    5b10:	1f 41 76 00 	mov	118(r1),r15	;0x00076
    5b14:	0c 4f       	mov	r15,	r12	;
    5b16:	0d 43       	clr	r13		;
    5b18:	81 4c 66 00 	mov	r12,	102(r1)	; 0x0066
    5b1c:	81 4d 68 00 	mov	r13,	104(r1)	; 0x0068

00005b20 <.LBB361>:
    5b20:	b1 40 00 80 	mov	#-32768,98(r1)	;#0x8000, 0x0062
    5b24:	62 00 
    5b26:	81 43 64 00 	mov	#0,	100(r1)	;r3 As==00, 0x0064

00005b2a <.Loc.72.2>:
    5b2a:	b1 40 00 80 	mov	#-32768,94(r1)	;#0x8000, 0x005e
    5b2e:	5e 00 
    5b30:	81 43 60 00 	mov	#0,	96(r1)	;r3 As==00, 0x0060
    5b34:	07 3c       	jmp	$+16     	;abs 0x5b44

00005b36 <.L178>:
    5b36:	91 d1 6e 00 	bis	110(r1),106(r1)	;0x0006e, 0x006a
    5b3a:	6a 00 
    5b3c:	91 d1 70 00 	bis	112(r1),108(r1)	;0x00070, 0x006c
    5b40:	6c 00 

00005b42 <.Loc.74.2>:
    5b42:	be 3f       	jmp	$-130    	;abs 0x5ac0

00005b44 <.L185>:
    5b44:	1e 41 5e 00 	mov	94(r1),	r14	;0x0005e
    5b48:	1f 41 60 00 	mov	96(r1),	r15	;0x00060
    5b4c:	0c 4e       	mov	r14,	r12	;
    5b4e:	0d 4f       	mov	r15,	r13	;
    5b50:	b0 12 f6 65 	call	#26102		;#0x65f6

00005b54 <.Loc.74.2>:
    5b54:	81 9d 68 00 	cmp	r13,	104(r1)	; 0x0068
    5b58:	06 28       	jnc	$+14     	;abs 0x5b66
    5b5a:	81 9d 68 00 	cmp	r13,	104(r1)	; 0x0068
    5b5e:	09 20       	jnz	$+20     	;abs 0x5b72
    5b60:	81 9c 66 00 	cmp	r12,	102(r1)	; 0x0066
    5b64:	06 2c       	jc	$+14     	;abs 0x5b72

00005b66 <.L216>:
    5b66:	91 e1 62 00 	xor	98(r1),	94(r1)	;0x00062, 0x005e
    5b6a:	5e 00 
    5b6c:	91 e1 64 00 	xor	100(r1),96(r1)	;0x00064, 0x0060
    5b70:	60 00 

00005b72 <.L181>:
    5b72:	12 c3       	clrc			
    5b74:	11 10 64 00 	rrc	100(r1)	;00064
    5b78:	11 10 62 00 	rrc	98(r1)		;00062

00005b7c <.Loc.77.2>:
    5b7c:	1c 41 62 00 	mov	98(r1),	r12	;0x00062
    5b80:	1c d1 64 00 	bis	100(r1),r12	;0x00064
    5b84:	0c 93       	cmp	#0,	r12	;r3 As==00
    5b86:	18 20       	jnz	$+50     	;abs 0x5bb8

00005b88 <.Loc.78.2>:
    5b88:	1d 41 5e 00 	mov	94(r1),	r13	;0x0005e

00005b8c <.LBE366>:
    5b8c:	1c 41 96 00 	mov	150(r1),r12	;0x00096
    5b90:	8c 4d 02 00 	mov	r13,	2(r12)	;

00005b94 <.Loc.166.2>:
    5b94:	03 43       	nop			
    5b96:	3c 40 46 01 	mov	#326,	r12	;#0x0146
    5b9a:	0c 51       	add	r1,	r12	;
    5b9c:	3c 50 be fe 	add	#-322,	r12	;#0xfebe
    5ba0:	81 4c 5c 00 	mov	r12,	92(r1)	; 0x005c
    5ba4:	91 41 a6 00 	mov	166(r1),90(r1)	;0x000a6, 0x005a
    5ba8:	5a 00 

00005baa <.LBB369>:
    5baa:	81 43 58 00 	mov	#0,	88(r1)	;r3 As==00, 0x0058

00005bae <.Loc.170.2>:
    5bae:	81 43 56 00 	mov	#0,	86(r1)	;r3 As==00, 0x0056

00005bb2 <.Loc.175.2>:
    5bb2:	81 43 54 00 	mov	#0,	84(r1)	;r3 As==00, 0x0054

00005bb6 <.Loc.175.2>:
    5bb6:	95 3c       	jmp	$+300    	;abs 0x5ce2

00005bb8 <.L183>:
    5bb8:	91 d1 62 00 	bis	98(r1),	94(r1)	;0x00062, 0x005e
    5bbc:	5e 00 
    5bbe:	91 d1 64 00 	bis	100(r1),96(r1)	;0x00064, 0x0060
    5bc2:	60 00 

00005bc4 <.Loc.74.2>:
    5bc4:	bf 3f       	jmp	$-128    	;abs 0x5b44

00005bc6 <.L193>:
    5bc6:	1c 41 54 00 	mov	84(r1),	r12	;0x00054
    5bca:	5c 06       	rlam	#2,	r12	;
    5bcc:	1d 41 5a 00 	mov	90(r1),	r13	;0x0005a
    5bd0:	0d 5c       	add	r12,	r13	;
    5bd2:	81 4d 52 00 	mov	r13,	82(r1)	; 0x0052

00005bd6 <.Loc.178.2>:
    5bd6:	1c 41 52 00 	mov	82(r1),	r12	;0x00052
    5bda:	2e 4c       	mov	@r12,	r14	;

00005bdc <.Loc.178.2>:
    5bdc:	1c 41 5c 00 	mov	92(r1),	r12	;0x0005c
    5be0:	2d 4c       	mov	@r12,	r13	;

00005be2 <.Loc.178.2>:
    5be2:	0c 4e       	mov	r14,	r12	;
    5be4:	0c 8d       	sub	r13,	r12	;

00005be6 <.Loc.178.2>:
    5be6:	0d 4c       	mov	r12,	r13	;
    5be8:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5bec:	0c ed       	xor	r13,	r12	;
    5bee:	0c 8d       	sub	r13,	r12	;

00005bf0 <.Loc.177.2>:
    5bf0:	0e 4c       	mov	r12,	r14	;
    5bf2:	0f 4c       	mov	r12,	r15	;
    5bf4:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5bf8:	81 4e 4e 00 	mov	r14,	78(r1)	; 0x004e
    5bfc:	81 4f 50 00 	mov	r15,	80(r1)	; 0x0050

00005c00 <.Loc.180.2>:
    5c00:	1c 41 52 00 	mov	82(r1),	r12	;0x00052
    5c04:	1e 4c 02 00 	mov	2(r12),	r14	;

00005c08 <.Loc.180.2>:
    5c08:	1c 41 5c 00 	mov	92(r1),	r12	;0x0005c
    5c0c:	1d 4c 02 00 	mov	2(r12),	r13	;

00005c10 <.Loc.180.2>:
    5c10:	0c 4e       	mov	r14,	r12	;
    5c12:	0c 8d       	sub	r13,	r12	;

00005c14 <.Loc.180.2>:
    5c14:	0d 4c       	mov	r12,	r13	;
    5c16:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5c1a:	0c ed       	xor	r13,	r12	;
    5c1c:	0c 8d       	sub	r13,	r12	;

00005c1e <.Loc.179.2>:
    5c1e:	0d 4c       	mov	r12,	r13	;
    5c20:	0e 4c       	mov	r12,	r14	;
    5c22:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5c26:	81 4d 4a 00 	mov	r13,	74(r1)	; 0x004a
    5c2a:	81 4e 4c 00 	mov	r14,	76(r1)	; 0x004c

00005c2e <.Loc.182.2>:
    5c2e:	1c 41 54 00 	mov	84(r1),	r12	;0x00054
    5c32:	3c 50 10 00 	add	#16,	r12	;#0x0010
    5c36:	5c 06       	rlam	#2,	r12	;
    5c38:	1e 41 5a 00 	mov	90(r1),	r14	;0x0005a
    5c3c:	0e 5c       	add	r12,	r14	;
    5c3e:	81 4e 52 00 	mov	r14,	82(r1)	; 0x0052

00005c42 <.Loc.184.2>:
    5c42:	1c 41 52 00 	mov	82(r1),	r12	;0x00052
    5c46:	2e 4c       	mov	@r12,	r14	;

00005c48 <.Loc.184.2>:
    5c48:	1c 41 5c 00 	mov	92(r1),	r12	;0x0005c
    5c4c:	2d 4c       	mov	@r12,	r13	;

00005c4e <.Loc.184.2>:
    5c4e:	0c 4e       	mov	r14,	r12	;
    5c50:	0c 8d       	sub	r13,	r12	;

00005c52 <.Loc.184.2>:
    5c52:	0d 4c       	mov	r12,	r13	;
    5c54:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5c58:	0c ed       	xor	r13,	r12	;
    5c5a:	0c 8d       	sub	r13,	r12	;

00005c5c <.Loc.183.2>:
    5c5c:	0d 4c       	mov	r12,	r13	;
    5c5e:	0e 4c       	mov	r12,	r14	;
    5c60:	4e 18 0e 11 	rpt #15 { rrax.w	r14		;
    5c64:	81 4d 46 00 	mov	r13,	70(r1)	; 0x0046
    5c68:	81 4e 48 00 	mov	r14,	72(r1)	; 0x0048

00005c6c <.Loc.186.2>:
    5c6c:	1c 41 52 00 	mov	82(r1),	r12	;0x00052
    5c70:	1e 4c 02 00 	mov	2(r12),	r14	;

00005c74 <.Loc.186.2>:
    5c74:	1c 41 5c 00 	mov	92(r1),	r12	;0x0005c
    5c78:	1d 4c 02 00 	mov	2(r12),	r13	;

00005c7c <.Loc.186.2>:
    5c7c:	0c 4e       	mov	r14,	r12	;
    5c7e:	0c 8d       	sub	r13,	r12	;

00005c80 <.Loc.186.2>:
    5c80:	0d 4c       	mov	r12,	r13	;
    5c82:	4e 18 0d 11 	rpt #15 { rrax.w	r13		;
    5c86:	0c ed       	xor	r13,	r12	;
    5c88:	0c 8d       	sub	r13,	r12	;

00005c8a <.Loc.185.2>:
    5c8a:	0e 4c       	mov	r12,	r14	;
    5c8c:	0f 4c       	mov	r12,	r15	;
    5c8e:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5c92:	81 4e 42 00 	mov	r14,	66(r1)	; 0x0042
    5c96:	81 4f 44 00 	mov	r15,	68(r1)	; 0x0044

00005c9a <.Loc.188.2>:
    5c9a:	91 91 50 00 	cmp	80(r1),	72(r1)	;0x00050, 0x0048
    5c9e:	48 00 
    5ca0:	08 38       	jl	$+18     	;abs 0x5cb2
    5ca2:	91 91 48 00 	cmp	72(r1),	80(r1)	;0x00048, 0x0050
    5ca6:	50 00 
    5ca8:	07 20       	jnz	$+16     	;abs 0x5cb8
    5caa:	91 91 4e 00 	cmp	78(r1),	70(r1)	;0x0004e, 0x0046
    5cae:	46 00 
    5cb0:	03 2c       	jc	$+8      	;abs 0x5cb8

00005cb2 <.L218>:
    5cb2:	91 53 58 00 	inc	88(r1)		;
    5cb6:	02 3c       	jmp	$+6      	;abs 0x5cbc

00005cb8 <.L187>:
    5cb8:	91 53 56 00 	inc	86(r1)		;

00005cbc <.L189>:
    5cbc:	91 91 4c 00 	cmp	76(r1),	68(r1)	;0x0004c, 0x0044
    5cc0:	44 00 
    5cc2:	08 38       	jl	$+18     	;abs 0x5cd4
    5cc4:	91 91 44 00 	cmp	68(r1),	76(r1)	;0x00044, 0x004c
    5cc8:	4c 00 
    5cca:	07 20       	jnz	$+16     	;abs 0x5cda
    5ccc:	91 91 4a 00 	cmp	74(r1),	66(r1)	;0x0004a, 0x0042
    5cd0:	42 00 
    5cd2:	03 2c       	jc	$+8      	;abs 0x5cda

00005cd4 <.L219>:
    5cd4:	91 53 58 00 	inc	88(r1)		;
    5cd8:	02 3c       	jmp	$+6      	;abs 0x5cde

00005cda <.L190>:
    5cda:	91 53 56 00 	inc	86(r1)		;

00005cde <.L192>:
    5cde:	91 53 54 00 	inc	84(r1)		;

00005ce2 <.L186>:
    5ce2:	7c 40 0f 00 	mov.b	#15,	r12	;#0x000f
    5ce6:	1c 91 54 00 	cmp	84(r1),	r12	;0x00054
    5cea:	6d 37       	jge	$-292    	;abs 0x5bc6

00005cec <.Loc.199.2>:
    5cec:	5c 43       	mov.b	#1,	r12	;r3 As==01
    5cee:	91 91 58 00 	cmp	88(r1),	86(r1)	;0x00058, 0x0056
    5cf2:	56 00 
    5cf4:	01 38       	jl	$+4      	;abs 0x5cf8
    5cf6:	4c 43       	clr.b	r12		;

00005cf8 <.L194>:
    5cf8:	3c f0 ff 00 	and	#255,	r12	;#0x00ff

00005cfc <.LBE374>:
    5cfc:	81 4c 40 00 	mov	r12,	64(r1)	; 0x0040

00005d00 <.Loc.259.2>:
    5d00:	1c 41 12 00 	mov	18(r1),	r12	;0x00012

00005d04 <.Loc.259.2>:
    5d04:	1c 53       	inc	r12		;
    5d06:	81 4c 12 00 	mov	r12,	18(r1)	; 0x0012

00005d0a <.Loc.260.2>:
    5d0a:	91 93 40 00 	cmp	#1,	64(r1)	;r3 As==01, 0x0040
    5d0e:	06 20       	jnz	$+14     	;abs 0x5d1c

00005d10 <.Loc.261.2>:
    5d10:	1c 41 14 00 	mov	20(r1),	r12	;0x00014

00005d14 <.Loc.261.2>:
    5d14:	1c 53       	inc	r12		;
    5d16:	81 4c 14 00 	mov	r12,	20(r1)	; 0x0014
    5d1a:	05 3c       	jmp	$+12     	;abs 0x5d26

00005d1c <.L196>:
    5d1c:	1c 41 16 00 	mov	22(r1),	r12	;0x00016

00005d20 <.Loc.267.2>:
    5d20:	1c 53       	inc	r12		;
    5d22:	81 4c 16 00 	mov	r12,	22(r1)	; 0x0016

00005d26 <.L197>:
    5d26:	91 53 a4 00 	inc	164(r1)		;

00005d2a <.L143>:
    5d2a:	7c 40 3f 00 	mov.b	#63,	r12	;#0x003f
    5d2e:	1c 91 a4 00 	cmp	164(r1),r12	;0x000a4
    5d32:	02 28       	jnc	$+6      	;abs 0x5d38
    5d34:	80 00 fe 54 	mova	#21758,	r0	;0x054fe

00005d38 <.Loc.287.2>:
    5d38:	03 43       	nop			

00005d3a <.LBE335>:
    5d3a:	91 53 44 01 	inc	324(r1)		;

00005d3e <.L142>:
    5d3e:	7c 40 09 00 	mov.b	#9,	r12	;
    5d42:	1c 91 44 01 	cmp	324(r1),r12	;0x00144
    5d46:	02 38       	jl	$+6      	;abs 0x5d4c
    5d48:	80 00 e4 54 	mova	#21732,	r0	;0x054e4

00005d4c <.LBE334>:
    5d4c:	b0 12 10 42 	call	#16912		;#0x4210

00005d50 <.Loc.340.2>:
    5d50:	b0 12 60 42 	call	#16992		;#0x4260

00005d54 <.Loc.342.2>:
    5d54:	4c 43       	clr.b	r12		;

00005d56 <.Loc.343.2>:
    5d56:	31 50 46 01 	add	#326,	r1	;#0x0146

00005d5a <L0^A>:
    5d5a:	0a 17       	popm	#1,	r10	;16-bit words

00005d5c <.LCFI5>:
    5d5c:	30 41       	ret			

00005d5e <udivmodhi4>:
    5d5e:	0f 4c       	mov	r12,	r15	;

00005d60 <.LVL1>:
    5d60:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011

00005d64 <.LVL2>:
    5d64:	5b 43       	mov.b	#1,	r11	;r3 As==01

00005d66 <.L2>:
    5d66:	0d 9f       	cmp	r15,	r13	;
    5d68:	05 2c       	jc	$+12     	;abs 0x5d74
    5d6a:	3c 53       	add	#-1,	r12	;r3 As==11

00005d6c <.Loc.38.1>:
    5d6c:	0c 93       	cmp	#0,	r12	;r3 As==00
    5d6e:	05 24       	jz	$+12     	;abs 0x5d7a

00005d70 <.Loc.38.1>:
    5d70:	0d 93       	cmp	#0,	r13	;r3 As==00
    5d72:	07 34       	jge	$+16     	;abs 0x5d82

00005d74 <.L10>:
    5d74:	4c 43       	clr.b	r12		;

00005d76 <.L6>:
    5d76:	0b 93       	cmp	#0,	r11	;r3 As==00
    5d78:	07 20       	jnz	$+16     	;abs 0x5d88

00005d7a <.L4>:
    5d7a:	0e 93       	cmp	#0,	r14	;r3 As==00
    5d7c:	01 24       	jz	$+4      	;abs 0x5d80
    5d7e:	0c 4f       	mov	r15,	r12	;

00005d80 <.L1>:
    5d80:	30 41       	ret			

00005d82 <.L5>:
    5d82:	5d 02       	rlam	#1,	r13	;

00005d84 <.Loc.41.1>:
    5d84:	5b 02       	rlam	#1,	r11	;
    5d86:	ef 3f       	jmp	$-32     	;abs 0x5d66

00005d88 <.L8>:
    5d88:	0f 9d       	cmp	r13,	r15	;
    5d8a:	02 28       	jnc	$+6      	;abs 0x5d90

00005d8c <.Loc.47.1>:
    5d8c:	0f 8d       	sub	r13,	r15	;

00005d8e <.Loc.48.1>:
    5d8e:	0c db       	bis	r11,	r12	;

00005d90 <.L7>:
    5d90:	5b 03       	rrum	#1,	r11	;

00005d92 <.Loc.51.1>:
    5d92:	5d 03       	rrum	#1,	r13	;
    5d94:	f0 3f       	jmp	$-30     	;abs 0x5d76

00005d96 <__mspabi_divi>:
    5d96:	0a 15       	pushm	#1,	r10	;16-bit words

00005d98 <.LCFI0>:
    5d98:	4a 43       	clr.b	r10		;

00005d9a <L0^A>:
    5d9a:	0c 93       	cmp	#0,	r12	;r3 As==00
    5d9c:	04 34       	jge	$+10     	;abs 0x5da6

00005d9e <.Loc.66.1>:
    5d9e:	4e 43       	clr.b	r14		;
    5da0:	0e 8c       	sub	r12,	r14	;
    5da2:	0c 4e       	mov	r14,	r12	;

00005da4 <.LVL16>:
    5da4:	5a 43       	mov.b	#1,	r10	;r3 As==01

00005da6 <.L18>:
    5da6:	0d 93       	cmp	#0,	r13	;r3 As==00
    5da8:	04 34       	jge	$+10     	;abs 0x5db2

00005daa <.Loc.72.1>:
    5daa:	4e 43       	clr.b	r14		;
    5dac:	0e 8d       	sub	r13,	r14	;
    5dae:	0d 4e       	mov	r14,	r13	;

00005db0 <.LVL18>:
    5db0:	1a e3       	xor	#1,	r10	;r3 As==01

00005db2 <.L19>:
    5db2:	4e 43       	clr.b	r14		;
    5db4:	b0 12 5e 5d 	call	#23902		;#0x5d5e

00005db8 <.LVL20>:
    5db8:	0a 93       	cmp	#0,	r10	;r3 As==00
    5dba:	03 24       	jz	$+8      	;abs 0x5dc2

00005dbc <.LVL21>:
    5dbc:	4d 43       	clr.b	r13		;
    5dbe:	0d 8c       	sub	r12,	r13	;
    5dc0:	0c 4d       	mov	r13,	r12	;

00005dc2 <.L17>:
    5dc2:	0a 17       	popm	#1,	r10	;16-bit words

00005dc4 <.LCFI1>:
    5dc4:	30 41       	ret			

00005dc6 <__mspabi_remi>:
    5dc6:	0a 15       	pushm	#1,	r10	;16-bit words

00005dc8 <.LCFI2>:
    5dc8:	4a 43       	clr.b	r10		;

00005dca <.Loc.90.1>:
    5dca:	0c 93       	cmp	#0,	r12	;r3 As==00
    5dcc:	04 34       	jge	$+10     	;abs 0x5dd6

00005dce <.Loc.92.1>:
    5dce:	4e 43       	clr.b	r14		;
    5dd0:	0e 8c       	sub	r12,	r14	;
    5dd2:	0c 4e       	mov	r14,	r12	;

00005dd4 <.LVL25>:
    5dd4:	5a 43       	mov.b	#1,	r10	;r3 As==01

00005dd6 <.L26>:
    5dd6:	0f 4d       	mov	r13,	r15	;
    5dd8:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;
    5ddc:	0d ef       	xor	r15,	r13	;

00005dde <.LVL27>:
    5dde:	5e 43       	mov.b	#1,	r14	;r3 As==01
    5de0:	0d 8f       	sub	r15,	r13	;
    5de2:	b0 12 5e 5d 	call	#23902		;#0x5d5e

00005de6 <.LVL28>:
    5de6:	0a 93       	cmp	#0,	r10	;r3 As==00
    5de8:	03 24       	jz	$+8      	;abs 0x5df0

00005dea <.LVL29>:
    5dea:	4d 43       	clr.b	r13		;
    5dec:	0d 8c       	sub	r12,	r13	;
    5dee:	0c 4d       	mov	r13,	r12	;

00005df0 <.L25>:
    5df0:	0a 17       	popm	#1,	r10	;16-bit words

00005df2 <.LCFI3>:
    5df2:	30 41       	ret			

00005df4 <__mspabi_divu>:
    5df4:	4e 43       	clr.b	r14		;
    5df6:	b0 12 5e 5d 	call	#23902		;#0x5d5e

00005dfa <.LVL32>:
    5dfa:	30 41       	ret			

00005dfc <__mspabi_remu>:
    5dfc:	5e 43       	mov.b	#1,	r14	;r3 As==01
    5dfe:	b0 12 5e 5d 	call	#23902		;#0x5d5e

00005e02 <.LVL34>:
    5e02:	30 41       	ret			

00005e04 <__mspabi_divllu>:
    5e04:	ef 3c       	jmp	$+480    	;abs 0x5fe4

00005e06 <udivmodsi4>:
    5e06:	4a 15       	pushm	#5,	r10	;16-bit words

00005e08 <.LCFI0>:
    5e08:	0a 4c       	mov	r12,	r10	;
    5e0a:	0b 4d       	mov	r13,	r11	;

00005e0c <.LVL1>:
    5e0c:	7c 40 21 00 	mov.b	#33,	r12	;#0x0021

00005e10 <.LVL2>:
    5e10:	58 43       	mov.b	#1,	r8	;r3 As==01
    5e12:	49 43       	clr.b	r9		;

00005e14 <.L2>:
    5e14:	0f 9b       	cmp	r11,	r15	;
    5e16:	04 28       	jnc	$+10     	;abs 0x5e20
    5e18:	0b 9f       	cmp	r15,	r11	;
    5e1a:	07 20       	jnz	$+16     	;abs 0x5e2a
    5e1c:	0e 9a       	cmp	r10,	r14	;
    5e1e:	05 2c       	jc	$+12     	;abs 0x5e2a

00005e20 <.L15>:
    5e20:	3c 53       	add	#-1,	r12	;r3 As==11

00005e22 <.Loc.38.1>:
    5e22:	0c 93       	cmp	#0,	r12	;r3 As==00
    5e24:	2d 24       	jz	$+92     	;abs 0x5e80

00005e26 <.Loc.38.1>:
    5e26:	0f 93       	cmp	#0,	r15	;r3 As==00
    5e28:	0d 34       	jge	$+28     	;abs 0x5e44

00005e2a <.L13>:
    5e2a:	4c 43       	clr.b	r12		;
    5e2c:	4d 43       	clr.b	r13		;

00005e2e <.L8>:
    5e2e:	07 48       	mov	r8,	r7	;
    5e30:	07 d9       	bis	r9,	r7	;
    5e32:	07 93       	cmp	#0,	r7	;r3 As==00
    5e34:	14 20       	jnz	$+42     	;abs 0x5e5e

00005e36 <.L5>:
    5e36:	81 93 0c 00 	cmp	#0,	12(r1)	;r3 As==00, 0x000c
    5e3a:	02 24       	jz	$+6      	;abs 0x5e40
    5e3c:	0c 4a       	mov	r10,	r12	;
    5e3e:	0d 4b       	mov	r11,	r13	;

00005e40 <.L1>:
    5e40:	46 17       	popm	#5,	r10	;16-bit words

00005e42 <.LCFI1>:
    5e42:	30 41       	ret			

00005e44 <.L6>:
    5e44:	06 4e       	mov	r14,	r6	;
    5e46:	07 4f       	mov	r15,	r7	;
    5e48:	06 5e       	add	r14,	r6	;
    5e4a:	07 6f       	addc	r15,	r7	;
    5e4c:	0e 46       	mov	r6,	r14	;

00005e4e <.LVL7>:
    5e4e:	0f 47       	mov	r7,	r15	;

00005e50 <.LVL8>:
    5e50:	06 48       	mov	r8,	r6	;
    5e52:	07 49       	mov	r9,	r7	;
    5e54:	06 58       	add	r8,	r6	;
    5e56:	07 69       	addc	r9,	r7	;
    5e58:	08 46       	mov	r6,	r8	;

00005e5a <.LVL9>:
    5e5a:	09 47       	mov	r7,	r9	;

00005e5c <.LVL10>:
    5e5c:	db 3f       	jmp	$-72     	;abs 0x5e14

00005e5e <.L11>:
    5e5e:	0b 9f       	cmp	r15,	r11	;
    5e60:	08 28       	jnc	$+18     	;abs 0x5e72
    5e62:	0f 9b       	cmp	r11,	r15	;
    5e64:	02 20       	jnz	$+6      	;abs 0x5e6a
    5e66:	0a 9e       	cmp	r14,	r10	;
    5e68:	04 28       	jnc	$+10     	;abs 0x5e72

00005e6a <.L16>:
    5e6a:	0a 8e       	sub	r14,	r10	;
    5e6c:	0b 7f       	subc	r15,	r11	;

00005e6e <.Loc.48.1>:
    5e6e:	0c d8       	bis	r8,	r12	;

00005e70 <.LVL13>:
    5e70:	0d d9       	bis	r9,	r13	;

00005e72 <.L9>:
    5e72:	12 c3       	clrc			
    5e74:	09 10       	rrc	r9		;
    5e76:	08 10       	rrc	r8		;

00005e78 <.Loc.51.1>:
    5e78:	12 c3       	clrc			
    5e7a:	0f 10       	rrc	r15		;
    5e7c:	0e 10       	rrc	r14		;
    5e7e:	d7 3f       	jmp	$-80     	;abs 0x5e2e

00005e80 <.L14>:
    5e80:	4c 43       	clr.b	r12		;
    5e82:	4d 43       	clr.b	r13		;
    5e84:	d8 3f       	jmp	$-78     	;abs 0x5e36

00005e86 <__mspabi_divli>:
    5e86:	2a 15       	pushm	#3,	r10	;16-bit words

00005e88 <.LCFI3>:
    5e88:	21 83       	decd	r1		;

00005e8a <.LCFI4>:
    5e8a:	4a 43       	clr.b	r10		;

00005e8c <L0^A>:
    5e8c:	0d 93       	cmp	#0,	r13	;r3 As==00
    5e8e:	07 34       	jge	$+16     	;abs 0x5e9e

00005e90 <.Loc.66.1>:
    5e90:	48 43       	clr.b	r8		;
    5e92:	49 43       	clr.b	r9		;
    5e94:	08 8c       	sub	r12,	r8	;
    5e96:	09 7d       	subc	r13,	r9	;
    5e98:	0c 48       	mov	r8,	r12	;

00005e9a <.LVL20>:
    5e9a:	0d 49       	mov	r9,	r13	;

00005e9c <.LVL21>:
    5e9c:	5a 43       	mov.b	#1,	r10	;r3 As==01

00005e9e <.L21>:
    5e9e:	0f 93       	cmp	#0,	r15	;r3 As==00
    5ea0:	07 34       	jge	$+16     	;abs 0x5eb0

00005ea2 <.Loc.72.1>:
    5ea2:	48 43       	clr.b	r8		;
    5ea4:	49 43       	clr.b	r9		;
    5ea6:	08 8e       	sub	r14,	r8	;
    5ea8:	09 7f       	subc	r15,	r9	;
    5eaa:	0e 48       	mov	r8,	r14	;

00005eac <.LVL23>:
    5eac:	0f 49       	mov	r9,	r15	;

00005eae <.LVL24>:
    5eae:	1a e3       	xor	#1,	r10	;r3 As==01

00005eb0 <.L23>:
    5eb0:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    5eb4:	b0 12 06 5e 	call	#24070		;#0x5e06

00005eb8 <.LVL26>:
    5eb8:	0a 93       	cmp	#0,	r10	;r3 As==00
    5eba:	06 24       	jz	$+14     	;abs 0x5ec8

00005ebc <.LVL27>:
    5ebc:	49 43       	clr.b	r9		;
    5ebe:	4a 43       	clr.b	r10		;
    5ec0:	09 8c       	sub	r12,	r9	;
    5ec2:	0a 7d       	subc	r13,	r10	;
    5ec4:	0c 49       	mov	r9,	r12	;

00005ec6 <.LVL28>:
    5ec6:	0d 4a       	mov	r10,	r13	;

00005ec8 <.L20>:
    5ec8:	21 53       	incd	r1		;

00005eca <.LCFI5>:
    5eca:	28 17       	popm	#3,	r10	;16-bit words

00005ecc <.LCFI6>:
    5ecc:	30 41       	ret			

00005ece <__mspabi_remli>:
    5ece:	4a 15       	pushm	#5,	r10	;16-bit words

00005ed0 <.LCFI7>:
    5ed0:	21 83       	decd	r1		;

00005ed2 <.LCFI8>:
    5ed2:	08 4c       	mov	r12,	r8	;
    5ed4:	09 4d       	mov	r13,	r9	;
    5ed6:	0a 4e       	mov	r14,	r10	;
    5ed8:	06 4f       	mov	r15,	r6	;

00005eda <.LVL31>:
    5eda:	47 43       	clr.b	r7		;

00005edc <.Loc.90.1>:
    5edc:	0d 93       	cmp	#0,	r13	;r3 As==00
    5ede:	07 34       	jge	$+16     	;abs 0x5eee

00005ee0 <.Loc.92.1>:
    5ee0:	4c 43       	clr.b	r12		;

00005ee2 <.LVL32>:
    5ee2:	4d 43       	clr.b	r13		;
    5ee4:	0c 88       	sub	r8,	r12	;
    5ee6:	0d 79       	subc	r9,	r13	;
    5ee8:	08 4c       	mov	r12,	r8	;
    5eea:	09 4d       	mov	r13,	r9	;

00005eec <.LVL33>:
    5eec:	57 43       	mov.b	#1,	r7	;r3 As==01

00005eee <.L31>:
    5eee:	0c 4a       	mov	r10,	r12	;
    5ef0:	0d 46       	mov	r6,	r13	;
    5ef2:	7e 40 1f 00 	mov.b	#31,	r14	;#0x001f
    5ef6:	b0 12 c0 5f 	call	#24512		;#0x5fc0
    5efa:	0e 4c       	mov	r12,	r14	;
    5efc:	0e ea       	xor	r10,	r14	;
    5efe:	0f 4d       	mov	r13,	r15	;
    5f00:	0f e6       	xor	r6,	r15	;
    5f02:	91 43 00 00 	mov	#1,	0(r1)	;r3 As==01
    5f06:	0e 8c       	sub	r12,	r14	;
    5f08:	0f 7d       	subc	r13,	r15	;
    5f0a:	0c 48       	mov	r8,	r12	;
    5f0c:	0d 49       	mov	r9,	r13	;
    5f0e:	b0 12 06 5e 	call	#24070		;#0x5e06

00005f12 <.LVL36>:
    5f12:	07 93       	cmp	#0,	r7	;r3 As==00
    5f14:	06 24       	jz	$+14     	;abs 0x5f22

00005f16 <.LVL37>:
    5f16:	4e 43       	clr.b	r14		;
    5f18:	4f 43       	clr.b	r15		;
    5f1a:	0e 8c       	sub	r12,	r14	;
    5f1c:	0f 7d       	subc	r13,	r15	;
    5f1e:	0c 4e       	mov	r14,	r12	;

00005f20 <.LVL38>:
    5f20:	0d 4f       	mov	r15,	r13	;

00005f22 <.L30>:
    5f22:	21 53       	incd	r1		;

00005f24 <.LCFI9>:
    5f24:	46 17       	popm	#5,	r10	;16-bit words

00005f26 <.LCFI10>:
    5f26:	30 41       	ret			

00005f28 <__mspabi_divlu>:
    5f28:	21 83       	decd	r1		;

00005f2a <.LCFI11>:
    5f2a:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
    5f2e:	b0 12 06 5e 	call	#24070		;#0x5e06

00005f32 <.LVL41>:
    5f32:	21 53       	incd	r1		;

00005f34 <.LCFI12>:
    5f34:	30 41       	ret			

00005f36 <__mspabi_remul>:
    5f36:	21 83       	decd	r1		;

00005f38 <.LCFI13>:
    5f38:	91 43 00 00 	mov	#1,	0(r1)	;r3 As==01
    5f3c:	b0 12 06 5e 	call	#24070		;#0x5e06

00005f40 <.LVL43>:
    5f40:	21 53       	incd	r1		;

00005f42 <.LCFI14>:
    5f42:	30 41       	ret			

00005f44 <__mspabi_srai_15>:
    5f44:	0c 11       	rra	r12		;

00005f46 <__mspabi_srai_14>:
    5f46:	0c 11       	rra	r12		;

00005f48 <__mspabi_srai_13>:
    5f48:	0c 11       	rra	r12		;

00005f4a <__mspabi_srai_12>:
    5f4a:	0c 11       	rra	r12		;

00005f4c <__mspabi_srai_11>:
    5f4c:	0c 11       	rra	r12		;

00005f4e <__mspabi_srai_10>:
    5f4e:	0c 11       	rra	r12		;

00005f50 <__mspabi_srai_9>:
    5f50:	0c 11       	rra	r12		;

00005f52 <__mspabi_srai_8>:
    5f52:	0c 11       	rra	r12		;

00005f54 <__mspabi_srai_7>:
    5f54:	0c 11       	rra	r12		;

00005f56 <__mspabi_srai_6>:
    5f56:	0c 11       	rra	r12		;

00005f58 <__mspabi_srai_5>:
    5f58:	0c 11       	rra	r12		;

00005f5a <__mspabi_srai_4>:
    5f5a:	0c 11       	rra	r12		;

00005f5c <__mspabi_srai_3>:
    5f5c:	0c 11       	rra	r12		;

00005f5e <__mspabi_srai_2>:
    5f5e:	0c 11       	rra	r12		;

00005f60 <__mspabi_srai_1>:
    5f60:	0c 11       	rra	r12		;
    5f62:	30 41       	ret			

00005f64 <.L1^B1>:
    5f64:	3d 53       	add	#-1,	r13	;r3 As==11
    5f66:	0c 11       	rra	r12		;

00005f68 <__mspabi_srai>:
    5f68:	0d 93       	cmp	#0,	r13	;r3 As==00
    5f6a:	fc 23       	jnz	$-6      	;abs 0x5f64
    5f6c:	30 41       	ret			

00005f6e <.L1^B2>:
    5f6e:	ad 0f ff ff 	adda	#1048575,r13	;0xfffff
    5f72:	00 18 4c 11 	rrax.a	r12		;

00005f76 <__gnu_mspabi_srap>:
    5f76:	0d 93       	cmp	#0,	r13	;r3 As==00
    5f78:	fa 23       	jnz	$-10     	;abs 0x5f6e
    5f7a:	30 41       	ret			

00005f7c <__mspabi_sral_15>:
    5f7c:	0d 11       	rra	r13		;
    5f7e:	0c 10       	rrc	r12		;

00005f80 <__mspabi_sral_14>:
    5f80:	0d 11       	rra	r13		;
    5f82:	0c 10       	rrc	r12		;

00005f84 <__mspabi_sral_13>:
    5f84:	0d 11       	rra	r13		;
    5f86:	0c 10       	rrc	r12		;

00005f88 <__mspabi_sral_12>:
    5f88:	0d 11       	rra	r13		;
    5f8a:	0c 10       	rrc	r12		;

00005f8c <__mspabi_sral_11>:
    5f8c:	0d 11       	rra	r13		;
    5f8e:	0c 10       	rrc	r12		;

00005f90 <__mspabi_sral_10>:
    5f90:	0d 11       	rra	r13		;
    5f92:	0c 10       	rrc	r12		;

00005f94 <__mspabi_sral_9>:
    5f94:	0d 11       	rra	r13		;
    5f96:	0c 10       	rrc	r12		;

00005f98 <__mspabi_sral_8>:
    5f98:	0d 11       	rra	r13		;
    5f9a:	0c 10       	rrc	r12		;

00005f9c <__mspabi_sral_7>:
    5f9c:	0d 11       	rra	r13		;
    5f9e:	0c 10       	rrc	r12		;

00005fa0 <__mspabi_sral_6>:
    5fa0:	0d 11       	rra	r13		;
    5fa2:	0c 10       	rrc	r12		;

00005fa4 <__mspabi_sral_5>:
    5fa4:	0d 11       	rra	r13		;
    5fa6:	0c 10       	rrc	r12		;

00005fa8 <__mspabi_sral_4>:
    5fa8:	0d 11       	rra	r13		;
    5faa:	0c 10       	rrc	r12		;

00005fac <__mspabi_sral_3>:
    5fac:	0d 11       	rra	r13		;
    5fae:	0c 10       	rrc	r12		;

00005fb0 <__mspabi_sral_2>:
    5fb0:	0d 11       	rra	r13		;
    5fb2:	0c 10       	rrc	r12		;

00005fb4 <__mspabi_sral_1>:
    5fb4:	0d 11       	rra	r13		;
    5fb6:	0c 10       	rrc	r12		;
    5fb8:	30 41       	ret			

00005fba <.L1^B3>:
    5fba:	3e 53       	add	#-1,	r14	;r3 As==11
    5fbc:	0d 11       	rra	r13		;
    5fbe:	0c 10       	rrc	r12		;

00005fc0 <__mspabi_sral>:
    5fc0:	0e 93       	cmp	#0,	r14	;r3 As==00
    5fc2:	fb 23       	jnz	$-8      	;abs 0x5fba
    5fc4:	30 41       	ret			

00005fc6 <__mspabi_srall>:
    5fc6:	0f 4b       	mov	r11,	r15	;
    5fc8:	0b 4c       	mov	r12,	r11	;
    5fca:	0e 4a       	mov	r10,	r14	;
    5fcc:	0d 49       	mov	r9,	r13	;
    5fce:	0c 48       	mov	r8,	r12	;
    5fd0:	0b 93       	cmp	#0,	r11	;r3 As==00
    5fd2:	01 20       	jnz	$+4      	;abs 0x5fd6
    5fd4:	30 41       	ret			

00005fd6 <.L1^B4>:
    5fd6:	0f 11       	rra	r15		;
    5fd8:	0e 10       	rrc	r14		;
    5fda:	0d 10       	rrc	r13		;
    5fdc:	0c 10       	rrc	r12		;
    5fde:	3b 53       	add	#-1,	r11	;r3 As==11
    5fe0:	fa 23       	jnz	$-10     	;abs 0x5fd6
    5fe2:	30 41       	ret			

00005fe4 <__mspabi_divull>:
    5fe4:	6a 15       	pushm	#7,	r10	;16-bit words

00005fe6 <.LCFI0>:
    5fe6:	04 41       	mov	r1,	r4	;

00005fe8 <.LCFI1>:
    5fe8:	31 80 18 00 	sub	#24,	r1	;#0x0018
    5fec:	84 48 fa ff 	mov	r8,	-6(r4)	; 0xfffa
    5ff0:	84 49 fe ff 	mov	r9,	-2(r4)	; 0xfffe
    5ff4:	84 4a fc ff 	mov	r10,	-4(r4)	; 0xfffc
    5ff8:	84 4b f8 ff 	mov	r11,	-8(r4)	; 0xfff8
    5ffc:	08 4c       	mov	r12,	r8	;

00005ffe <.LVL1>:
    5ffe:	09 4d       	mov	r13,	r9	;
    6000:	0a 4e       	mov	r14,	r10	;
    6002:	07 4f       	mov	r15,	r7	;

00006004 <.LBB4>:
    6004:	0b 9f       	cmp	r15,	r11	;
    6006:	de 29       	jnc	$+958    	;abs 0x63c4
    6008:	0f 9b       	cmp	r11,	r15	;
    600a:	0f 20       	jnz	$+32     	;abs 0x602a
    600c:	84 9e fc ff 	cmp	r14,	-4(r4)	; 0xfffc
    6010:	d9 29       	jnc	$+948    	;abs 0x63c4
    6012:	1e 94 fc ff 	cmp	-4(r4),	r14	;
    6016:	09 20       	jnz	$+20     	;abs 0x602a
    6018:	84 9d fe ff 	cmp	r13,	-2(r4)	; 0xfffe
    601c:	d3 29       	jnc	$+936    	;abs 0x63c4
    601e:	1d 94 fe ff 	cmp	-2(r4),	r13	;
    6022:	03 20       	jnz	$+8      	;abs 0x602a
    6024:	84 9c fa ff 	cmp	r12,	-6(r4)	; 0xfffa
    6028:	cd 29       	jnc	$+924    	;abs 0x63c4

0000602a <.L48>:
    602a:	35 40 56 65 	mov	#25942,	r5	;#0x6556
    602e:	0c 48       	mov	r8,	r12	;

00006030 <.LVL3>:
    6030:	0d 49       	mov	r9,	r13	;
    6032:	0e 4a       	mov	r10,	r14	;
    6034:	0f 47       	mov	r7,	r15	;
    6036:	85 12       	call	r5		;

00006038 <.LVL4>:
    6038:	06 4c       	mov	r12,	r6	;

0000603a <.LVL5>:
    603a:	1c 44 fa ff 	mov	-6(r4),	r12	;
    603e:	1d 44 fe ff 	mov	-2(r4),	r13	;
    6042:	1e 44 fc ff 	mov	-4(r4),	r14	;
    6046:	1f 44 f8 ff 	mov	-8(r4),	r15	;
    604a:	85 12       	call	r5		;

0000604c <.LVL6>:
    604c:	0e 46       	mov	r6,	r14	;
    604e:	0f 46       	mov	r6,	r15	;
    6050:	4e 18 0f 11 	rpt #15 { rrax.w	r15		;

00006054 <.LVL7>:
    6054:	3c b0 00 80 	bit	#-32768,r12	;#0x8000
    6058:	0d 7d       	subc	r13,	r13	;
    605a:	3d e3       	inv	r13		;

0000605c <.LVL8>:
    605c:	05 4e       	mov	r14,	r5	;
    605e:	06 4f       	mov	r15,	r6	;
    6060:	05 8c       	sub	r12,	r5	;
    6062:	06 7d       	subc	r13,	r6	;
    6064:	84 45 f4 ff 	mov	r5,	-12(r4)	; 0xfff4
    6068:	84 46 f6 ff 	mov	r6,	-10(r4)	; 0xfff6

0000606c <.LVL9>:
    606c:	84 45 ea ff 	mov	r5,	-22(r4)	; 0xffea

00006070 <.Loc.966.1>:
    6070:	0b 47       	mov	r7,	r11	;
    6072:	1c 44 f4 ff 	mov	-12(r4),r12	;0xfffffff4

00006076 <.LVL10>:
    6076:	b0 12 54 64 	call	#25684		;#0x6454

0000607a <.LVL11>:
    607a:	84 4c e8 ff 	mov	r12,	-24(r4)	; 0xffe8
    607e:	84 4d f2 ff 	mov	r13,	-14(r4)	; 0xfff2
    6082:	05 4e       	mov	r14,	r5	;
    6084:	07 4f       	mov	r15,	r7	;

00006086 <.LVL12>:
    6086:	84 9f f8 ff 	cmp	r15,	-8(r4)	; 0xfff8
    608a:	63 29       	jnc	$+712    	;abs 0x6352
    608c:	1f 94 f8 ff 	cmp	-8(r4),	r15	;
    6090:	0f 20       	jnz	$+32     	;abs 0x60b0
    6092:	84 9e fc ff 	cmp	r14,	-4(r4)	; 0xfffc
    6096:	5d 29       	jnc	$+700    	;abs 0x6352
    6098:	1e 94 fc ff 	cmp	-4(r4),	r14	;
    609c:	09 20       	jnz	$+20     	;abs 0x60b0
    609e:	84 9d fe ff 	cmp	r13,	-2(r4)	; 0xfffe
    60a2:	57 29       	jnc	$+688    	;abs 0x6352
    60a4:	1d 94 fe ff 	cmp	-2(r4),	r13	;
    60a8:	03 20       	jnz	$+8      	;abs 0x60b0
    60aa:	84 9c fa ff 	cmp	r12,	-6(r4)	; 0xfffa
    60ae:	51 29       	jnc	$+676    	;abs 0x6352

000060b0 <.L49>:
    60b0:	1f 44 fa ff 	mov	-6(r4),	r15	;
    60b4:	1f 84 e8 ff 	sub	-24(r4),r15	;0xffffffe8
    60b8:	5e 43       	mov.b	#1,	r14	;r3 As==01
    60ba:	84 9f fa ff 	cmp	r15,	-6(r4)	; 0xfffa
    60be:	01 28       	jnc	$+4      	;abs 0x60c2
    60c0:	4e 43       	clr.b	r14		;

000060c2 <.L6>:
    60c2:	1c 44 fe ff 	mov	-2(r4),	r12	;

000060c6 <.LVL13>:
    60c6:	1c 84 f2 ff 	sub	-14(r4),r12	;0xfffffff2
    60ca:	5d 43       	mov.b	#1,	r13	;r3 As==01

000060cc <.LVL14>:
    60cc:	84 9c fe ff 	cmp	r12,	-2(r4)	; 0xfffe
    60d0:	01 28       	jnc	$+4      	;abs 0x60d4
    60d2:	4d 43       	clr.b	r13		;

000060d4 <.L7>:
    60d4:	09 4c       	mov	r12,	r9	;
    60d6:	09 8e       	sub	r14,	r9	;
    60d8:	5e 43       	mov.b	#1,	r14	;r3 As==01
    60da:	0c 99       	cmp	r9,	r12	;
    60dc:	01 28       	jnc	$+4      	;abs 0x60e0
    60de:	4e 43       	clr.b	r14		;

000060e0 <.L8>:
    60e0:	0d de       	bis	r14,	r13	;
    60e2:	1e 44 fc ff 	mov	-4(r4),	r14	;
    60e6:	0e 85       	sub	r5,	r14	;
    60e8:	5c 43       	mov.b	#1,	r12	;r3 As==01
    60ea:	84 9e fc ff 	cmp	r14,	-4(r4)	; 0xfffc
    60ee:	01 28       	jnc	$+4      	;abs 0x60f2
    60f0:	4c 43       	clr.b	r12		;

000060f2 <.L9>:
    60f2:	0a 4e       	mov	r14,	r10	;
    60f4:	0a 8d       	sub	r13,	r10	;
    60f6:	5d 43       	mov.b	#1,	r13	;r3 As==01
    60f8:	0e 9a       	cmp	r10,	r14	;
    60fa:	01 28       	jnc	$+4      	;abs 0x60fe
    60fc:	4d 43       	clr.b	r13		;

000060fe <.L10>:
    60fe:	0c dd       	bis	r13,	r12	;
    6100:	1b 44 f8 ff 	mov	-8(r4),	r11	;
    6104:	0b 87       	sub	r7,	r11	;
    6106:	84 4f fa ff 	mov	r15,	-6(r4)	; 0xfffa

0000610a <.LVL15>:
    610a:	84 49 fe ff 	mov	r9,	-2(r4)	; 0xfffe
    610e:	84 4a fc ff 	mov	r10,	-4(r4)	; 0xfffc
    6112:	0b 8c       	sub	r12,	r11	;
    6114:	84 4b f8 ff 	mov	r11,	-8(r4)	; 0xfff8

00006118 <.LVL16>:
    6118:	58 43       	mov.b	#1,	r8	;r3 As==01
    611a:	49 43       	clr.b	r9		;

0000611c <.LVL17>:
    611c:	4a 43       	clr.b	r10		;

0000611e <.LVL18>:
    611e:	4b 43       	clr.b	r11		;

00006120 <.LVL19>:
    6120:	1c 44 ea ff 	mov	-22(r4),r12	;0xffffffea
    6124:	b0 12 54 64 	call	#25684		;#0x6454

00006128 <.LVL20>:
    6128:	06 4c       	mov	r12,	r6	;
    612a:	84 4d f0 ff 	mov	r13,	-16(r4)	; 0xfff0
    612e:	84 4e ee ff 	mov	r14,	-18(r4)	; 0xffee
    6132:	84 4f ec ff 	mov	r15,	-20(r4)	; 0xffec

00006136 <.L4>:
    6136:	1c 44 f4 ff 	mov	-12(r4),r12	;0xfffffff4
    613a:	1c d4 f6 ff 	bis	-10(r4),r12	;0xfffffff6
    613e:	0c 93       	cmp	#0,	r12	;r3 As==00
    6140:	fd 24       	jz	$+508    	;abs 0x633c

00006142 <.Loc.981.1>:
    6142:	18 44 e8 ff 	mov	-24(r4),r8	;0xffffffe8
    6146:	19 44 f2 ff 	mov	-14(r4),r9	;0xfffffff2
    614a:	0a 45       	mov	r5,	r10	;
    614c:	0b 47       	mov	r7,	r11	;
    614e:	5c 43       	mov.b	#1,	r12	;r3 As==01
    6150:	b0 12 36 65 	call	#25910		;#0x6536
    6154:	84 4c f2 ff 	mov	r12,	-14(r4)	; 0xfff2

00006158 <.LVL23>:
    6158:	05 4d       	mov	r13,	r5	;
    615a:	07 4e       	mov	r14,	r7	;

0000615c <.L35>:
    615c:	84 9f f8 ff 	cmp	r15,	-8(r4)	; 0xfff8
    6160:	00 29       	jnc	$+514    	;abs 0x6362
    6162:	1f 94 f8 ff 	cmp	-8(r4),	r15	;
    6166:	10 20       	jnz	$+34     	;abs 0x6188
    6168:	84 97 fc ff 	cmp	r7,	-4(r4)	; 0xfffc
    616c:	fa 28       	jnc	$+502    	;abs 0x6362
    616e:	17 94 fc ff 	cmp	-4(r4),	r7	;
    6172:	0a 20       	jnz	$+22     	;abs 0x6188
    6174:	84 95 fe ff 	cmp	r5,	-2(r4)	; 0xfffe
    6178:	f4 28       	jnc	$+490    	;abs 0x6362
    617a:	15 94 fe ff 	cmp	-2(r4),	r5	;
    617e:	04 20       	jnz	$+10     	;abs 0x6188
    6180:	94 94 f2 ff 	cmp	-14(r4),-6(r4)	;0xfffffff2, 0xfffa
    6184:	fa ff 
    6186:	ed 28       	jnc	$+476    	;abs 0x6362

00006188 <.L50>:
    6188:	1c 44 fa ff 	mov	-6(r4),	r12	;
    618c:	1c 84 f2 ff 	sub	-14(r4),r12	;0xfffffff2
    6190:	5a 43       	mov.b	#1,	r10	;r3 As==01
    6192:	84 9c fa ff 	cmp	r12,	-6(r4)	; 0xfffa
    6196:	01 28       	jnc	$+4      	;abs 0x619a
    6198:	4a 43       	clr.b	r10		;

0000619a <.L14>:
    619a:	1d 44 fe ff 	mov	-2(r4),	r13	;
    619e:	0d 85       	sub	r5,	r13	;
    61a0:	5e 43       	mov.b	#1,	r14	;r3 As==01
    61a2:	84 9d fe ff 	cmp	r13,	-2(r4)	; 0xfffe
    61a6:	01 28       	jnc	$+4      	;abs 0x61aa
    61a8:	4e 43       	clr.b	r14		;

000061aa <.L15>:
    61aa:	09 4d       	mov	r13,	r9	;
    61ac:	09 8a       	sub	r10,	r9	;
    61ae:	5a 43       	mov.b	#1,	r10	;r3 As==01
    61b0:	0d 99       	cmp	r9,	r13	;
    61b2:	01 28       	jnc	$+4      	;abs 0x61b6
    61b4:	4a 43       	clr.b	r10		;

000061b6 <.L16>:
    61b6:	0e da       	bis	r10,	r14	;
    61b8:	1a 44 fc ff 	mov	-4(r4),	r10	;
    61bc:	0a 87       	sub	r7,	r10	;
    61be:	5d 43       	mov.b	#1,	r13	;r3 As==01
    61c0:	84 9a fc ff 	cmp	r10,	-4(r4)	; 0xfffc
    61c4:	01 28       	jnc	$+4      	;abs 0x61c8
    61c6:	4d 43       	clr.b	r13		;

000061c8 <.L17>:
    61c8:	08 4a       	mov	r10,	r8	;
    61ca:	08 8e       	sub	r14,	r8	;
    61cc:	5e 43       	mov.b	#1,	r14	;r3 As==01
    61ce:	0a 98       	cmp	r8,	r10	;
    61d0:	01 28       	jnc	$+4      	;abs 0x61d4
    61d2:	4e 43       	clr.b	r14		;

000061d4 <.L18>:
    61d4:	0d de       	bis	r14,	r13	;
    61d6:	1b 44 f8 ff 	mov	-8(r4),	r11	;
    61da:	0b 8f       	sub	r15,	r11	;
    61dc:	0b 8d       	sub	r13,	r11	;

000061de <.Loc.989.1>:
    61de:	0a 4c       	mov	r12,	r10	;
    61e0:	5a 02       	rlam	#1,	r10	;
    61e2:	5d 43       	mov.b	#1,	r13	;r3 As==01
    61e4:	0a 9c       	cmp	r12,	r10	;
    61e6:	01 28       	jnc	$+4      	;abs 0x61ea
    61e8:	4d 43       	clr.b	r13		;

000061ea <.L19>:
    61ea:	0e 49       	mov	r9,	r14	;
    61ec:	5e 02       	rlam	#1,	r14	;
    61ee:	5c 43       	mov.b	#1,	r12	;r3 As==01
    61f0:	0e 99       	cmp	r9,	r14	;
    61f2:	01 28       	jnc	$+4      	;abs 0x61f6
    61f4:	4c 43       	clr.b	r12		;

000061f6 <.L20>:
    61f6:	0d 5e       	add	r14,	r13	;
    61f8:	59 43       	mov.b	#1,	r9	;r3 As==01
    61fa:	0d 9e       	cmp	r14,	r13	;
    61fc:	01 28       	jnc	$+4      	;abs 0x6200
    61fe:	49 43       	clr.b	r9		;

00006200 <.L21>:
    6200:	0c d9       	bis	r9,	r12	;
    6202:	09 48       	mov	r8,	r9	;
    6204:	59 02       	rlam	#1,	r9	;
    6206:	5e 43       	mov.b	#1,	r14	;r3 As==01
    6208:	09 98       	cmp	r8,	r9	;
    620a:	01 28       	jnc	$+4      	;abs 0x620e
    620c:	4e 43       	clr.b	r14		;

0000620e <.L22>:
    620e:	0c 59       	add	r9,	r12	;
    6210:	58 43       	mov.b	#1,	r8	;r3 As==01
    6212:	0c 99       	cmp	r9,	r12	;
    6214:	01 28       	jnc	$+4      	;abs 0x6218
    6216:	48 43       	clr.b	r8		;

00006218 <.L23>:
    6218:	0e d8       	bis	r8,	r14	;
    621a:	5b 02       	rlam	#1,	r11	;
    621c:	0e 5b       	add	r11,	r14	;

0000621e <.Loc.989.1>:
    621e:	08 4a       	mov	r10,	r8	;
    6220:	18 53       	inc	r8		;
    6222:	59 43       	mov.b	#1,	r9	;r3 As==01
    6224:	3a 93       	cmp	#-1,	r10	;r3 As==11
    6226:	01 2c       	jc	$+4      	;abs 0x622a
    6228:	49 43       	clr.b	r9		;

0000622a <.L24>:
    622a:	09 5d       	add	r13,	r9	;
    622c:	5a 43       	mov.b	#1,	r10	;r3 As==01
    622e:	09 9d       	cmp	r13,	r9	;
    6230:	01 28       	jnc	$+4      	;abs 0x6234
    6232:	4a 43       	clr.b	r10		;

00006234 <.L26>:
    6234:	0a 5c       	add	r12,	r10	;
    6236:	5b 43       	mov.b	#1,	r11	;r3 As==01
    6238:	0a 9c       	cmp	r12,	r10	;
    623a:	01 28       	jnc	$+4      	;abs 0x623e
    623c:	4b 43       	clr.b	r11		;

0000623e <.L28>:
    623e:	84 48 fa ff 	mov	r8,	-6(r4)	; 0xfffa

00006242 <.LVL25>:
    6242:	84 49 fe ff 	mov	r9,	-2(r4)	; 0xfffe
    6246:	84 4a fc ff 	mov	r10,	-4(r4)	; 0xfffc
    624a:	0b 5e       	add	r14,	r11	;
    624c:	84 4b f8 ff 	mov	r11,	-8(r4)	; 0xfff8

00006250 <.L29>:
    6250:	b4 53 f4 ff 	add	#-1,	-12(r4)	;r3 As==11, 0xfff4
    6254:	b4 63 f6 ff 	addc	#-1,	-10(r4)	;r3 As==11, 0xfff6

00006258 <.Loc.993.1>:
    6258:	1c 44 f4 ff 	mov	-12(r4),r12	;0xfffffff4
    625c:	1c d4 f6 ff 	bis	-10(r4),r12	;0xfffffff6
    6260:	0c 93       	cmp	#0,	r12	;r3 As==00
    6262:	7c 23       	jnz	$-262    	;abs 0x615c

00006264 <.Loc.997.1>:
    6264:	15 44 fa ff 	mov	-6(r4),	r5	;

00006268 <.LVL28>:
    6268:	05 56       	add	r6,	r5	;
    626a:	84 45 f4 ff 	mov	r5,	-12(r4)	; 0xfff4

0000626e <.LVL29>:
    626e:	55 43       	mov.b	#1,	r5	;r3 As==01
    6270:	84 96 f4 ff 	cmp	r6,	-12(r4)	; 0xfff4
    6274:	01 28       	jnc	$+4      	;abs 0x6278
    6276:	45 43       	clr.b	r5		;

00006278 <.L36>:
    6278:	1c 44 f0 ff 	mov	-16(r4),r12	;0xfffffff0
    627c:	1c 54 fe ff 	add	-2(r4),	r12	;
    6280:	56 43       	mov.b	#1,	r6	;r3 As==01

00006282 <.LVL30>:
    6282:	1c 94 f0 ff 	cmp	-16(r4),r12	;0xfffffff0
    6286:	01 28       	jnc	$+4      	;abs 0x628a
    6288:	46 43       	clr.b	r6		;

0000628a <.L37>:
    628a:	05 5c       	add	r12,	r5	;
    628c:	5d 43       	mov.b	#1,	r13	;r3 As==01
    628e:	05 9c       	cmp	r12,	r5	;
    6290:	01 28       	jnc	$+4      	;abs 0x6294
    6292:	4d 43       	clr.b	r13		;

00006294 <.L38>:
    6294:	06 dd       	bis	r13,	r6	;
    6296:	1c 44 ee ff 	mov	-18(r4),r12	;0xffffffee
    629a:	1c 54 fc ff 	add	-4(r4),	r12	;
    629e:	57 43       	mov.b	#1,	r7	;r3 As==01
    62a0:	1c 94 ee ff 	cmp	-18(r4),r12	;0xffffffee
    62a4:	01 28       	jnc	$+4      	;abs 0x62a8
    62a6:	47 43       	clr.b	r7		;

000062a8 <.L39>:
    62a8:	06 5c       	add	r12,	r6	;
    62aa:	5d 43       	mov.b	#1,	r13	;r3 As==01
    62ac:	06 9c       	cmp	r12,	r6	;
    62ae:	01 28       	jnc	$+4      	;abs 0x62b2
    62b0:	4d 43       	clr.b	r13		;

000062b2 <.L40>:
    62b2:	07 dd       	bis	r13,	r7	;
    62b4:	1f 44 ec ff 	mov	-20(r4),r15	;0xffffffec
    62b8:	1f 54 f8 ff 	add	-8(r4),	r15	;
    62bc:	07 5f       	add	r15,	r7	;

000062be <.LVL31>:
    62be:	18 44 fa ff 	mov	-6(r4),	r8	;
    62c2:	19 44 fe ff 	mov	-2(r4),	r9	;
    62c6:	1a 44 fc ff 	mov	-4(r4),	r10	;
    62ca:	1b 44 f8 ff 	mov	-8(r4),	r11	;
    62ce:	1c 44 ea ff 	mov	-22(r4),r12	;0xffffffea
    62d2:	b0 12 36 65 	call	#25910		;#0x6536

000062d6 <.Loc.999.1>:
    62d6:	08 4c       	mov	r12,	r8	;
    62d8:	09 4d       	mov	r13,	r9	;
    62da:	0a 4e       	mov	r14,	r10	;
    62dc:	0b 4f       	mov	r15,	r11	;
    62de:	1c 44 ea ff 	mov	-22(r4),r12	;0xffffffea
    62e2:	b0 12 54 64 	call	#25684		;#0x6454

000062e6 <.Loc.999.1>:
    62e6:	1b 44 f4 ff 	mov	-12(r4),r11	;0xfffffff4
    62ea:	0b 8c       	sub	r12,	r11	;
    62ec:	5a 43       	mov.b	#1,	r10	;r3 As==01
    62ee:	84 9b f4 ff 	cmp	r11,	-12(r4)	; 0xfff4
    62f2:	01 28       	jnc	$+4      	;abs 0x62f6
    62f4:	4a 43       	clr.b	r10		;

000062f6 <.L41>:
    62f6:	0c 45       	mov	r5,	r12	;
    62f8:	0c 8d       	sub	r13,	r12	;
    62fa:	59 43       	mov.b	#1,	r9	;r3 As==01
    62fc:	05 9c       	cmp	r12,	r5	;
    62fe:	01 28       	jnc	$+4      	;abs 0x6302
    6300:	49 43       	clr.b	r9		;

00006302 <.L42>:
    6302:	0d 4c       	mov	r12,	r13	;
    6304:	0d 8a       	sub	r10,	r13	;
    6306:	5a 43       	mov.b	#1,	r10	;r3 As==01
    6308:	0c 9d       	cmp	r13,	r12	;
    630a:	01 28       	jnc	$+4      	;abs 0x630e
    630c:	4a 43       	clr.b	r10		;

0000630e <.L43>:
    630e:	09 da       	bis	r10,	r9	;
    6310:	08 46       	mov	r6,	r8	;
    6312:	08 8e       	sub	r14,	r8	;
    6314:	5a 43       	mov.b	#1,	r10	;r3 As==01
    6316:	06 98       	cmp	r8,	r6	;
    6318:	01 28       	jnc	$+4      	;abs 0x631c
    631a:	4a 43       	clr.b	r10		;

0000631c <.L44>:
    631c:	0e 48       	mov	r8,	r14	;
    631e:	0e 89       	sub	r9,	r14	;
    6320:	5c 43       	mov.b	#1,	r12	;r3 As==01
    6322:	08 9e       	cmp	r14,	r8	;
    6324:	01 28       	jnc	$+4      	;abs 0x6328
    6326:	4c 43       	clr.b	r12		;

00006328 <.L45>:
    6328:	0a dc       	bis	r12,	r10	;
    632a:	07 8f       	sub	r15,	r7	;

0000632c <.LVL34>:
    632c:	06 4b       	mov	r11,	r6	;
    632e:	84 4d f0 ff 	mov	r13,	-16(r4)	; 0xfff0
    6332:	84 4e ee ff 	mov	r14,	-18(r4)	; 0xffee
    6336:	07 8a       	sub	r10,	r7	;
    6338:	84 47 ec ff 	mov	r7,	-20(r4)	; 0xffec

0000633c <.L1>:
    633c:	0c 46       	mov	r6,	r12	;
    633e:	1d 44 f0 ff 	mov	-16(r4),r13	;0xfffffff0
    6342:	1e 44 ee ff 	mov	-18(r4),r14	;0xffffffee
    6346:	1f 44 ec ff 	mov	-20(r4),r15	;0xffffffec
    634a:	31 50 18 00 	add	#24,	r1	;#0x0018
    634e:	64 17       	popm	#7,	r10	;16-bit words

00006350 <.LCFI2>:
    6350:	30 41       	ret			

00006352 <.L47>:
    6352:	46 43       	clr.b	r6		;
    6354:	84 43 f0 ff 	mov	#0,	-16(r4)	;r3 As==00, 0xfff0
    6358:	84 43 ee ff 	mov	#0,	-18(r4)	;r3 As==00, 0xffee
    635c:	84 43 ec ff 	mov	#0,	-20(r4)	;r3 As==00, 0xffec
    6360:	ea 3e       	jmp	$-554    	;abs 0x6136

00006362 <.L12>:
    6362:	1e 44 fa ff 	mov	-6(r4),	r14	;
    6366:	5e 02       	rlam	#1,	r14	;
    6368:	59 43       	mov.b	#1,	r9	;r3 As==01
    636a:	1e 94 fa ff 	cmp	-6(r4),	r14	;
    636e:	01 28       	jnc	$+4      	;abs 0x6372
    6370:	49 43       	clr.b	r9		;

00006372 <.L30>:
    6372:	1c 44 fe ff 	mov	-2(r4),	r12	;
    6376:	5c 02       	rlam	#1,	r12	;
    6378:	5a 43       	mov.b	#1,	r10	;r3 As==01
    637a:	1c 94 fe ff 	cmp	-2(r4),	r12	;
    637e:	01 28       	jnc	$+4      	;abs 0x6382
    6380:	4a 43       	clr.b	r10		;

00006382 <.L31>:
    6382:	09 5c       	add	r12,	r9	;
    6384:	5d 43       	mov.b	#1,	r13	;r3 As==01
    6386:	09 9c       	cmp	r12,	r9	;
    6388:	01 28       	jnc	$+4      	;abs 0x638c
    638a:	4d 43       	clr.b	r13		;

0000638c <.L32>:
    638c:	0a dd       	bis	r13,	r10	;
    638e:	1d 44 fc ff 	mov	-4(r4),	r13	;
    6392:	5d 02       	rlam	#1,	r13	;
    6394:	5c 43       	mov.b	#1,	r12	;r3 As==01
    6396:	1d 94 fc ff 	cmp	-4(r4),	r13	;
    639a:	01 28       	jnc	$+4      	;abs 0x639e
    639c:	4c 43       	clr.b	r12		;

0000639e <.L33>:
    639e:	0a 5d       	add	r13,	r10	;
    63a0:	58 43       	mov.b	#1,	r8	;r3 As==01
    63a2:	0a 9d       	cmp	r13,	r10	;
    63a4:	01 28       	jnc	$+4      	;abs 0x63a8
    63a6:	48 43       	clr.b	r8		;

000063a8 <.L34>:
    63a8:	0c d8       	bis	r8,	r12	;
    63aa:	1b 44 f8 ff 	mov	-8(r4),	r11	;
    63ae:	5b 02       	rlam	#1,	r11	;
    63b0:	84 4e fa ff 	mov	r14,	-6(r4)	; 0xfffa

000063b4 <.LVL38>:
    63b4:	84 49 fe ff 	mov	r9,	-2(r4)	; 0xfffe
    63b8:	84 4a fc ff 	mov	r10,	-4(r4)	; 0xfffc
    63bc:	0c 5b       	add	r11,	r12	;
    63be:	84 4c f8 ff 	mov	r12,	-8(r4)	; 0xfff8

000063c2 <.LVL39>:
    63c2:	46 3f       	jmp	$-370    	;abs 0x6250

000063c4 <.L46>:
    63c4:	46 43       	clr.b	r6		;
    63c6:	84 43 f0 ff 	mov	#0,	-16(r4)	;r3 As==00, 0xfff0
    63ca:	84 43 ee ff 	mov	#0,	-18(r4)	;r3 As==00, 0xffee
    63ce:	84 43 ec ff 	mov	#0,	-20(r4)	;r3 As==00, 0xffec

000063d2 <.LBE7>:
    63d2:	b4 3f       	jmp	$-150    	;abs 0x633c

000063d4 <__mspabi_slli_15>:
    63d4:	0c 5c       	rla	r12		;

000063d6 <__mspabi_slli_14>:
    63d6:	0c 5c       	rla	r12		;

000063d8 <__mspabi_slli_13>:
    63d8:	0c 5c       	rla	r12		;

000063da <__mspabi_slli_12>:
    63da:	0c 5c       	rla	r12		;

000063dc <__mspabi_slli_11>:
    63dc:	0c 5c       	rla	r12		;

000063de <__mspabi_slli_10>:
    63de:	0c 5c       	rla	r12		;

000063e0 <__mspabi_slli_9>:
    63e0:	0c 5c       	rla	r12		;

000063e2 <__mspabi_slli_8>:
    63e2:	0c 5c       	rla	r12		;

000063e4 <__mspabi_slli_7>:
    63e4:	0c 5c       	rla	r12		;

000063e6 <__mspabi_slli_6>:
    63e6:	0c 5c       	rla	r12		;

000063e8 <__mspabi_slli_5>:
    63e8:	0c 5c       	rla	r12		;

000063ea <__mspabi_slli_4>:
    63ea:	0c 5c       	rla	r12		;

000063ec <__mspabi_slli_3>:
    63ec:	0c 5c       	rla	r12		;

000063ee <__mspabi_slli_2>:
    63ee:	0c 5c       	rla	r12		;

000063f0 <__mspabi_slli_1>:
    63f0:	0c 5c       	rla	r12		;
    63f2:	30 41       	ret			

000063f4 <.L1^B1>:
    63f4:	3d 53       	add	#-1,	r13	;r3 As==11
    63f6:	0c 5c       	rla	r12		;

000063f8 <__mspabi_slli>:
    63f8:	0d 93       	cmp	#0,	r13	;r3 As==00
    63fa:	fc 23       	jnz	$-6      	;abs 0x63f4
    63fc:	30 41       	ret			

000063fe <.L1^B2>:
    63fe:	ad 0f ff ff 	adda	#1048575,r13	;0xfffff
    6402:	ec 0c       	adda	r12,	r12	;

00006404 <__gnu_mspabi_sllp>:
    6404:	0d 93       	cmp	#0,	r13	;r3 As==00
    6406:	fb 23       	jnz	$-8      	;abs 0x63fe
    6408:	30 41       	ret			

0000640a <__mspabi_slll_15>:
    640a:	0c 5c       	rla	r12		;
    640c:	0d 6d       	rlc	r13		;

0000640e <__mspabi_slll_14>:
    640e:	0c 5c       	rla	r12		;
    6410:	0d 6d       	rlc	r13		;

00006412 <__mspabi_slll_13>:
    6412:	0c 5c       	rla	r12		;
    6414:	0d 6d       	rlc	r13		;

00006416 <__mspabi_slll_12>:
    6416:	0c 5c       	rla	r12		;
    6418:	0d 6d       	rlc	r13		;

0000641a <__mspabi_slll_11>:
    641a:	0c 5c       	rla	r12		;
    641c:	0d 6d       	rlc	r13		;

0000641e <__mspabi_slll_10>:
    641e:	0c 5c       	rla	r12		;
    6420:	0d 6d       	rlc	r13		;

00006422 <__mspabi_slll_9>:
    6422:	0c 5c       	rla	r12		;
    6424:	0d 6d       	rlc	r13		;

00006426 <__mspabi_slll_8>:
    6426:	0c 5c       	rla	r12		;
    6428:	0d 6d       	rlc	r13		;

0000642a <__mspabi_slll_7>:
    642a:	0c 5c       	rla	r12		;
    642c:	0d 6d       	rlc	r13		;

0000642e <__mspabi_slll_6>:
    642e:	0c 5c       	rla	r12		;
    6430:	0d 6d       	rlc	r13		;

00006432 <__mspabi_slll_5>:
    6432:	0c 5c       	rla	r12		;
    6434:	0d 6d       	rlc	r13		;

00006436 <__mspabi_slll_4>:
    6436:	0c 5c       	rla	r12		;
    6438:	0d 6d       	rlc	r13		;

0000643a <__mspabi_slll_3>:
    643a:	0c 5c       	rla	r12		;
    643c:	0d 6d       	rlc	r13		;

0000643e <__mspabi_slll_2>:
    643e:	0c 5c       	rla	r12		;
    6440:	0d 6d       	rlc	r13		;

00006442 <__mspabi_slll_1>:
    6442:	0c 5c       	rla	r12		;
    6444:	0d 6d       	rlc	r13		;
    6446:	30 41       	ret			

00006448 <.L1^B3>:
    6448:	3e 53       	add	#-1,	r14	;r3 As==11
    644a:	0c 5c       	rla	r12		;
    644c:	0d 6d       	rlc	r13		;

0000644e <__mspabi_slll>:
    644e:	0e 93       	cmp	#0,	r14	;r3 As==00
    6450:	fb 23       	jnz	$-8      	;abs 0x6448
    6452:	30 41       	ret			

00006454 <__mspabi_sllll>:
    6454:	0f 4b       	mov	r11,	r15	;
    6456:	0b 4c       	mov	r12,	r11	;
    6458:	0e 4a       	mov	r10,	r14	;
    645a:	0d 49       	mov	r9,	r13	;
    645c:	0c 48       	mov	r8,	r12	;
    645e:	0b 93       	cmp	#0,	r11	;r3 As==00
    6460:	01 20       	jnz	$+4      	;abs 0x6464
    6462:	30 41       	ret			

00006464 <.L1^B4>:
    6464:	0c 5c       	rla	r12		;
    6466:	0d 6d       	rlc	r13		;
    6468:	0e 6e       	rlc	r14		;
    646a:	0f 6f       	rlc	r15		;
    646c:	3b 53       	add	#-1,	r11	;r3 As==11
    646e:	fa 23       	jnz	$-10     	;abs 0x6464
    6470:	30 41       	ret			

00006472 <__mspabi_srli_15>:
    6472:	12 c3       	clrc			
    6474:	0c 10       	rrc	r12		;

00006476 <__mspabi_srli_14>:
    6476:	12 c3       	clrc			
    6478:	0c 10       	rrc	r12		;

0000647a <__mspabi_srli_13>:
    647a:	12 c3       	clrc			
    647c:	0c 10       	rrc	r12		;

0000647e <__mspabi_srli_12>:
    647e:	12 c3       	clrc			
    6480:	0c 10       	rrc	r12		;

00006482 <__mspabi_srli_11>:
    6482:	12 c3       	clrc			
    6484:	0c 10       	rrc	r12		;

00006486 <__mspabi_srli_10>:
    6486:	12 c3       	clrc			
    6488:	0c 10       	rrc	r12		;

0000648a <__mspabi_srli_9>:
    648a:	12 c3       	clrc			
    648c:	0c 10       	rrc	r12		;

0000648e <__mspabi_srli_8>:
    648e:	12 c3       	clrc			
    6490:	0c 10       	rrc	r12		;

00006492 <__mspabi_srli_7>:
    6492:	12 c3       	clrc			
    6494:	0c 10       	rrc	r12		;

00006496 <__mspabi_srli_6>:
    6496:	12 c3       	clrc			
    6498:	0c 10       	rrc	r12		;

0000649a <__mspabi_srli_5>:
    649a:	12 c3       	clrc			
    649c:	0c 10       	rrc	r12		;

0000649e <__mspabi_srli_4>:
    649e:	12 c3       	clrc			
    64a0:	0c 10       	rrc	r12		;

000064a2 <__mspabi_srli_3>:
    64a2:	12 c3       	clrc			
    64a4:	0c 10       	rrc	r12		;

000064a6 <__mspabi_srli_2>:
    64a6:	12 c3       	clrc			
    64a8:	0c 10       	rrc	r12		;

000064aa <__mspabi_srli_1>:
    64aa:	12 c3       	clrc			
    64ac:	0c 10       	rrc	r12		;
    64ae:	30 41       	ret			

000064b0 <.L1^B1>:
    64b0:	3d 53       	add	#-1,	r13	;r3 As==11
    64b2:	12 c3       	clrc			
    64b4:	0c 10       	rrc	r12		;

000064b6 <__mspabi_srli>:
    64b6:	0d 93       	cmp	#0,	r13	;r3 As==00
    64b8:	fb 23       	jnz	$-8      	;abs 0x64b0
    64ba:	30 41       	ret			

000064bc <.L1^B2>:
    64bc:	ad 0f ff ff 	adda	#1048575,r13	;0xfffff
    64c0:	12 c3       	clrc			
    64c2:	00 18 4c 10 	rrcx.a	r12		;

000064c6 <__gnu_mspabi_srlp>:
    64c6:	0d 93       	cmp	#0,	r13	;r3 As==00
    64c8:	f9 23       	jnz	$-12     	;abs 0x64bc
    64ca:	30 41       	ret			

000064cc <__mspabi_srll_15>:
    64cc:	12 c3       	clrc			
    64ce:	0d 10       	rrc	r13		;
    64d0:	0c 10       	rrc	r12		;

000064d2 <__mspabi_srll_14>:
    64d2:	12 c3       	clrc			
    64d4:	0d 10       	rrc	r13		;
    64d6:	0c 10       	rrc	r12		;

000064d8 <__mspabi_srll_13>:
    64d8:	12 c3       	clrc			
    64da:	0d 10       	rrc	r13		;
    64dc:	0c 10       	rrc	r12		;

000064de <__mspabi_srll_12>:
    64de:	12 c3       	clrc			
    64e0:	0d 10       	rrc	r13		;
    64e2:	0c 10       	rrc	r12		;

000064e4 <__mspabi_srll_11>:
    64e4:	12 c3       	clrc			
    64e6:	0d 10       	rrc	r13		;
    64e8:	0c 10       	rrc	r12		;

000064ea <__mspabi_srll_10>:
    64ea:	12 c3       	clrc			
    64ec:	0d 10       	rrc	r13		;
    64ee:	0c 10       	rrc	r12		;

000064f0 <__mspabi_srll_9>:
    64f0:	12 c3       	clrc			
    64f2:	0d 10       	rrc	r13		;
    64f4:	0c 10       	rrc	r12		;

000064f6 <__mspabi_srll_8>:
    64f6:	12 c3       	clrc			
    64f8:	0d 10       	rrc	r13		;
    64fa:	0c 10       	rrc	r12		;

000064fc <__mspabi_srll_7>:
    64fc:	12 c3       	clrc			
    64fe:	0d 10       	rrc	r13		;
    6500:	0c 10       	rrc	r12		;

00006502 <__mspabi_srll_6>:
    6502:	12 c3       	clrc			
    6504:	0d 10       	rrc	r13		;
    6506:	0c 10       	rrc	r12		;

00006508 <__mspabi_srll_5>:
    6508:	12 c3       	clrc			
    650a:	0d 10       	rrc	r13		;
    650c:	0c 10       	rrc	r12		;

0000650e <__mspabi_srll_4>:
    650e:	12 c3       	clrc			
    6510:	0d 10       	rrc	r13		;
    6512:	0c 10       	rrc	r12		;

00006514 <__mspabi_srll_3>:
    6514:	12 c3       	clrc			
    6516:	0d 10       	rrc	r13		;
    6518:	0c 10       	rrc	r12		;

0000651a <__mspabi_srll_2>:
    651a:	12 c3       	clrc			
    651c:	0d 10       	rrc	r13		;
    651e:	0c 10       	rrc	r12		;

00006520 <__mspabi_srll_1>:
    6520:	12 c3       	clrc			
    6522:	0d 10       	rrc	r13		;
    6524:	0c 10       	rrc	r12		;
    6526:	30 41       	ret			

00006528 <.L1^B3>:
    6528:	3e 53       	add	#-1,	r14	;r3 As==11
    652a:	12 c3       	clrc			
    652c:	0d 10       	rrc	r13		;
    652e:	0c 10       	rrc	r12		;

00006530 <__mspabi_srll>:
    6530:	0e 93       	cmp	#0,	r14	;r3 As==00
    6532:	fa 23       	jnz	$-10     	;abs 0x6528
    6534:	30 41       	ret			

00006536 <__mspabi_srlll>:
    6536:	0f 4b       	mov	r11,	r15	;
    6538:	0b 4c       	mov	r12,	r11	;
    653a:	0e 4a       	mov	r10,	r14	;
    653c:	0d 49       	mov	r9,	r13	;
    653e:	0c 48       	mov	r8,	r12	;
    6540:	0b 93       	cmp	#0,	r11	;r3 As==00
    6542:	01 20       	jnz	$+4      	;abs 0x6546
    6544:	30 41       	ret			

00006546 <.L1^B4>:
    6546:	12 c3       	clrc			
    6548:	0f 10       	rrc	r15		;
    654a:	0e 10       	rrc	r14		;
    654c:	0d 10       	rrc	r13		;
    654e:	0c 10       	rrc	r12		;
    6550:	3b 53       	add	#-1,	r11	;r3 As==11
    6552:	f9 23       	jnz	$-12     	;abs 0x6546
    6554:	30 41       	ret			

00006556 <__clzdi2>:
    6556:	2a 15       	pushm	#3,	r10	;16-bit words

00006558 <.LCFI0>:
    6558:	0a 4c       	mov	r12,	r10	;

0000655a <.Loc.721.1>:
    655a:	0c 4e       	mov	r14,	r12	;

0000655c <.LVL1>:
    655c:	0e df       	bis	r15,	r14	;
    655e:	0e 93       	cmp	#0,	r14	;r3 As==00
    6560:	0c 24       	jz	$+26     	;abs 0x657a

00006562 <.Loc.726.1>:
    6562:	0d 4f       	mov	r15,	r13	;

00006564 <.LVL2>:
    6564:	4a 43       	clr.b	r10		;

00006566 <.L4>:
    6566:	0d 93       	cmp	#0,	r13	;r3 As==00
    6568:	0c 20       	jnz	$+26     	;abs 0x6582
    656a:	7e 42       	mov.b	#8,	r14	;r2 As==11
    656c:	4f 43       	clr.b	r15		;
    656e:	79 40 ff 00 	mov.b	#255,	r9	;#0x00ff
    6572:	09 9c       	cmp	r12,	r9	;
    6574:	10 28       	jnc	$+34     	;abs 0x6596
    6576:	4e 43       	clr.b	r14		;
    6578:	0d 3c       	jmp	$+28     	;abs 0x6594

0000657a <.L2>:
    657a:	0c 4a       	mov	r10,	r12	;

0000657c <.LVL5>:
    657c:	7a 40 20 00 	mov.b	#32,	r10	;#0x0020
    6580:	f2 3f       	jmp	$-26     	;abs 0x6566

00006582 <.L5>:
    6582:	7e 40 18 00 	mov.b	#24,	r14	;#0x0018
    6586:	4f 43       	clr.b	r15		;
    6588:	79 40 ff 00 	mov.b	#255,	r9	;#0x00ff
    658c:	09 9d       	cmp	r13,	r9	;
    658e:	03 28       	jnc	$+8      	;abs 0x6596
    6590:	7e 40 10 00 	mov.b	#16,	r14	;#0x0010

00006594 <.L15>:
    6594:	4f 43       	clr.b	r15		;

00006596 <.L7>:
    6596:	78 40 20 00 	mov.b	#32,	r8	;#0x0020
    659a:	49 43       	clr.b	r9		;
    659c:	08 8e       	sub	r14,	r8	;
    659e:	09 7f       	subc	r15,	r9	;
    65a0:	b0 12 30 65 	call	#25904		;#0x6530

000065a4 <.LVL8>:
    65a4:	5c 4c 00 40 	mov.b	16384(r12),r12	;0x04000
    65a8:	0a 8c       	sub	r12,	r10	;
    65aa:	0c 4a       	mov	r10,	r12	;

000065ac <.LBE4>:
    65ac:	0c 58       	add	r8,	r12	;
    65ae:	28 17       	popm	#3,	r10	;16-bit words

000065b0 <.LCFI1>:
    65b0:	30 41       	ret			

000065b2 <__mulhi2>:
    65b2:	02 12       	push	r2		;
    65b4:	32 c2       	dint			

000065b6 <L0^A>:
    65b6:	03 43       	nop			
    65b8:	82 4c c0 04 	mov	r12,	&0x04c0	;
    65bc:	82 4d c8 04 	mov	r13,	&0x04c8	;
    65c0:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    65c4:	00 13       	reti			

000065c6 <__mulhisi2>:
    65c6:	02 12       	push	r2		;
    65c8:	32 c2       	dint			
    65ca:	03 43       	nop			
    65cc:	82 4c c2 04 	mov	r12,	&0x04c2	;
    65d0:	82 4d c8 04 	mov	r13,	&0x04c8	;
    65d4:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    65d8:	1d 42 cc 04 	mov	&0x04cc,r13	;0x04cc
    65dc:	00 13       	reti			

000065de <__umulhisi2>:
    65de:	02 12       	push	r2		;
    65e0:	32 c2       	dint			
    65e2:	03 43       	nop			
    65e4:	82 4c c0 04 	mov	r12,	&0x04c0	;
    65e8:	82 4d c8 04 	mov	r13,	&0x04c8	;
    65ec:	1c 42 ca 04 	mov	&0x04ca,r12	;0x04ca
    65f0:	1d 42 cc 04 	mov	&0x04cc,r13	;0x04cc
    65f4:	00 13       	reti			

000065f6 <__mulsi2>:
    65f6:	02 12       	push	r2		;
    65f8:	32 c2       	dint			
    65fa:	03 43       	nop			
    65fc:	82 4c d0 04 	mov	r12,	&0x04d0	;
    6600:	82 4d d2 04 	mov	r13,	&0x04d2	;
    6604:	82 4e e0 04 	mov	r14,	&0x04e0	;
    6608:	82 4f e2 04 	mov	r15,	&0x04e2	;
    660c:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    6610:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    6614:	00 13       	reti			

00006616 <__mulsidi2>:
    6616:	02 12       	push	r2		;
    6618:	32 c2       	dint			
    661a:	03 43       	nop			
    661c:	82 4c d4 04 	mov	r12,	&0x04d4	;
    6620:	82 4d d6 04 	mov	r13,	&0x04d6	;
    6624:	82 4e e0 04 	mov	r14,	&0x04e0	;
    6628:	82 4f e2 04 	mov	r15,	&0x04e2	;
    662c:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    6630:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    6634:	1e 42 e8 04 	mov	&0x04e8,r14	;0x04e8
    6638:	1f 42 ea 04 	mov	&0x04ea,r15	;0x04ea
    663c:	00 13       	reti			

0000663e <__umulsidi2>:
    663e:	02 12       	push	r2		;
    6640:	32 c2       	dint			
    6642:	03 43       	nop			
    6644:	82 4c d0 04 	mov	r12,	&0x04d0	;
    6648:	82 4d d2 04 	mov	r13,	&0x04d2	;
    664c:	82 4e e0 04 	mov	r14,	&0x04e0	;
    6650:	82 4f e2 04 	mov	r15,	&0x04e2	;
    6654:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    6658:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    665c:	1e 42 e8 04 	mov	&0x04e8,r14	;0x04e8
    6660:	1f 42 ea 04 	mov	&0x04ea,r15	;0x04ea
    6664:	00 13       	reti			

00006666 <__muldi3>:
    6666:	02 12       	push	r2		;
    6668:	32 c2       	dint			
    666a:	03 43       	nop			
    666c:	4a 15       	pushm	#5,	r10	;16-bit words
    666e:	82 48 d0 04 	mov	r8,	&0x04d0	;
    6672:	82 49 d2 04 	mov	r9,	&0x04d2	;
    6676:	82 4e e0 04 	mov	r14,	&0x04e0	;
    667a:	82 4f e2 04 	mov	r15,	&0x04e2	;
    667e:	16 42 e4 04 	mov	&0x04e4,r6	;0x04e4
    6682:	17 42 e6 04 	mov	&0x04e6,r7	;0x04e6
    6686:	82 4a d0 04 	mov	r10,	&0x04d0	;
    668a:	82 4b d2 04 	mov	r11,	&0x04d2	;
    668e:	82 4c e0 04 	mov	r12,	&0x04e0	;
    6692:	82 4d e2 04 	mov	r13,	&0x04e2	;
    6696:	16 52 e4 04 	add	&0x04e4,r6	;0x04e4
    669a:	17 62 e6 04 	addc	&0x04e6,r7	;0x04e6
    669e:	82 48 d0 04 	mov	r8,	&0x04d0	;
    66a2:	82 49 d2 04 	mov	r9,	&0x04d2	;
    66a6:	82 4c e0 04 	mov	r12,	&0x04e0	;
    66aa:	82 4d e2 04 	mov	r13,	&0x04e2	;
    66ae:	1c 42 e4 04 	mov	&0x04e4,r12	;0x04e4
    66b2:	1d 42 e6 04 	mov	&0x04e6,r13	;0x04e6
    66b6:	1e 42 e8 04 	mov	&0x04e8,r14	;0x04e8
    66ba:	1f 42 ea 04 	mov	&0x04ea,r15	;0x04ea
    66be:	0e 56       	add	r6,	r14	;
    66c0:	0f 67       	addc	r7,	r15	;
    66c2:	46 17       	popm	#5,	r10	;16-bit words
    66c4:	00 13       	reti			

000066c6 <_exit>:
    66c6:	ff 3f       	jmp	$+0      	;abs 0x66c6

000066c8 <memmove>:
    66c8:	1a 15       	pushm	#2,	r10	;16-bit words

000066ca <L0^A>:
    66ca:	0f 4d       	mov	r13,	r15	;
    66cc:	0f 5e       	add	r14,	r15	;

000066ce <.Loc.69.1>:
    66ce:	0d 9c       	cmp	r12,	r13	;
    66d0:	02 2c       	jc	$+6      	;abs 0x66d6

000066d2 <.Loc.69.1>:
    66d2:	0c 9f       	cmp	r15,	r12	;
    66d4:	07 28       	jnc	$+16     	;abs 0x66e4

000066d6 <.L2>:
    66d6:	0e 4c       	mov	r12,	r14	;

000066d8 <.L4>:
    66d8:	0d 9f       	cmp	r15,	r13	;
    66da:	0a 24       	jz	$+22     	;abs 0x66f0

000066dc <.LVL3>:
    66dc:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;

000066e0 <.LVL4>:
    66e0:	1e 53       	inc	r14		;
    66e2:	fa 3f       	jmp	$-10     	;abs 0x66d8

000066e4 <.L3>:
    66e4:	09 4e       	mov	r14,	r9	;
    66e6:	39 e3       	inv	r9		;

000066e8 <.Loc.74.1>:
    66e8:	4d 43       	clr.b	r13		;

000066ea <.L5>:
    66ea:	3d 53       	add	#-1,	r13	;r3 As==11

000066ec <.LVL7>:
    66ec:	09 9d       	cmp	r13,	r9	;
    66ee:	02 20       	jnz	$+6      	;abs 0x66f4

000066f0 <.L9>:
    66f0:	19 17       	popm	#2,	r10	;16-bit words

000066f2 <.LCFI1>:
    66f2:	30 41       	ret			

000066f4 <.L6>:
    66f4:	0b 4e       	mov	r14,	r11	;
    66f6:	0b 5d       	add	r13,	r11	;
    66f8:	0b 5c       	add	r12,	r11	;
    66fa:	0a 4f       	mov	r15,	r10	;
    66fc:	0a 5d       	add	r13,	r10	;

000066fe <.LVL10>:
    66fe:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    6702:	f3 3f       	jmp	$-24     	;abs 0x66ea

00006704 <memset>:
    6704:	0e 5c       	add	r12,	r14	;

00006706 <.LVL2>:
    6706:	0f 4c       	mov	r12,	r15	;

00006708 <L0^A>:
    6708:	0f 9e       	cmp	r14,	r15	;
    670a:	01 20       	jnz	$+4      	;abs 0x670e

0000670c <.Loc.104.1>:
    670c:	30 41       	ret			

0000670e <.L3>:
    670e:	1f 53       	inc	r15		;

00006710 <.LVL4>:
    6710:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    6714:	f9 3f       	jmp	$-12     	;abs 0x6708
