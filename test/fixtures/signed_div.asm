
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_signed_div_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004004 <__crt0_start>:
    4004:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004008 <__crt0_init_bss>:
    4008:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02
    400c:	0d 43       	clr	r13		;
    400e:	3e 40 02 00 	mov	#2,	r14	;
    4012:	b0 12 e8 42 	call	#17128		;#0x42e8

00004016 <__crt0_movedata>:
    4016:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    401a:	3d 40 00 40 	mov	#16384,	r13	;#0x4000
    401e:	0d 9c       	cmp	r12,	r13	;
    4020:	04 24       	jz	$+10     	;abs 0x402a
    4022:	3e 40 02 00 	mov	#2,	r14	;
    4026:	b0 12 ac 42 	call	#17068		;#0x42ac

0000402a <__crt0_call_main>:
    402a:	0c 43       	clr	r12		;
    402c:	b0 12 54 42 	call	#16980		;#0x4254

00004030 <__crt0_call_exit>:
    4030:	b0 12 aa 42 	call	#17066		;#0x42aa

00004034 <clockSetup>:
    4034:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4038:	61 01 
    403a:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    403e:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    4042:	64 01 
    4044:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4048:	66 01 
    404a:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    404e:	62 01 
    4050:	0d 14       	pushm.a	#1,	r13	;20-bit words
    4052:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    4056:	1d 83       	dec	r13		;
    4058:	fe 23       	jnz	$-2      	;abs 0x4056
    405a:	0d 16       	popm.a	#1,	r13	;20-bit words
    405c:	00 3c       	jmp	$+2      	;abs 0x405e
    405e:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    4062:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4066:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    406a:	30 41       	ret			

0000406c <toggle_gpio>:
    406c:	f2 e2 02 02 	xor.b	#8,	&0x0202	;r2 As==11
    4070:	30 41       	ret			

00004072 <begin_event>:
    4072:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4074:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4078:	3e 40 05 00 	mov	#5,	r14	;
    407c:	1d 83       	dec	r13		;
    407e:	0e 73       	sbc	r14		;
    4080:	fd 23       	jnz	$-4      	;abs 0x407c
    4082:	0d 93       	cmp	#0,	r13	;r3 As==00
    4084:	fb 23       	jnz	$-8      	;abs 0x407c
    4086:	1d 16       	popm.a	#2,	r14	;20-bit words
    4088:	f2 d2 02 02 	bis.b	#8,	&0x0202	;r2 As==11
    408c:	30 41       	ret			

0000408e <end_event>:
    408e:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    4092:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4094:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4098:	3e 40 05 00 	mov	#5,	r14	;
    409c:	1d 83       	dec	r13		;
    409e:	0e 73       	sbc	r14		;
    40a0:	fd 23       	jnz	$-4      	;abs 0x409c
    40a2:	0d 93       	cmp	#0,	r13	;r3 As==00
    40a4:	fb 23       	jnz	$-8      	;abs 0x409c
    40a6:	1d 16       	popm.a	#2,	r14	;20-bit words
    40a8:	30 41       	ret			

000040aa <begin_measurement_window>:
    40aa:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40ac:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40b0:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    40b4:	1d 83       	dec	r13		;
    40b6:	0e 73       	sbc	r14		;
    40b8:	fd 23       	jnz	$-4      	;abs 0x40b4
    40ba:	0d 93       	cmp	#0,	r13	;r3 As==00
    40bc:	fb 23       	jnz	$-8      	;abs 0x40b4
    40be:	1d 16       	popm.a	#2,	r14	;20-bit words
    40c0:	e2 d2 02 02 	bis.b	#4,	&0x0202	;r2 As==10
    40c4:	30 41       	ret			

000040c6 <end_measurement_window>:
    40c6:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    40ca:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40cc:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40d0:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    40d4:	1d 83       	dec	r13		;
    40d6:	0e 73       	sbc	r14		;
    40d8:	fd 23       	jnz	$-4      	;abs 0x40d4
    40da:	0d 93       	cmp	#0,	r13	;r3 As==00
    40dc:	fb 23       	jnz	$-8      	;abs 0x40d4
    40de:	1d 16       	popm.a	#2,	r14	;20-bit words
    40e0:	30 41       	ret			

000040e2 <delay>:
    40e2:	0e 4c       	mov	r12,	r14	;
    40e4:	3e 53       	add	#-1,	r14	;r3 As==11
    40e6:	0f 4d       	mov	r13,	r15	;
    40e8:	3f 63       	addc	#-1,	r15	;r3 As==11
    40ea:	0c 4e       	mov	r14,	r12	;
    40ec:	0c df       	bis	r15,	r12	;
    40ee:	0c 93       	cmp	#0,	r12	;r3 As==00
    40f0:	07 24       	jz	$+16     	;abs 0x4100
    40f2:	03 43       	nop			
    40f4:	3e 53       	add	#-1,	r14	;r3 As==11
    40f6:	3f 63       	addc	#-1,	r15	;r3 As==11
    40f8:	0c 4e       	mov	r14,	r12	;
    40fa:	0c df       	bis	r15,	r12	;
    40fc:	0c 93       	cmp	#0,	r12	;r3 As==00
    40fe:	f9 23       	jnz	$-12     	;abs 0x40f2
    4100:	30 41       	ret			

00004102 <bench_empty_function>:
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
    4166:	30 41       	ret			

00004168 <bench_empty_interrupt>:
    4168:	02 12       	push	r2		;
    416a:	32 c2       	dint			
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
    41d0:	00 13       	reti			

000041d2 <initialize>:
    41d2:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    41d6:	5c 01 
    41d8:	92 c3 30 01 	bic	#1,	&0x0130	;r3 As==01
    41dc:	3c 40 08 1c 	mov	#7176,	r12	;#0x1c08
    41e0:	3c 90 08 1c 	cmp	#7176,	r12	;#0x1c08
    41e4:	07 2c       	jc	$+16     	;abs 0x41f4
    41e6:	3e 40 08 1c 	mov	#7176,	r14	;#0x1c08
    41ea:	0e 8c       	sub	r12,	r14	;
    41ec:	3d 40 fa 42 	mov	#17146,	r13	;#0x42fa
    41f0:	b0 12 98 42 	call	#17048		;#0x4298
    41f4:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    41f8:	61 01 
    41fa:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    41fe:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    4202:	64 01 
    4204:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4208:	66 01 
    420a:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    420e:	62 01 
    4210:	0d 14       	pushm.a	#1,	r13	;20-bit words
    4212:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    4216:	1d 83       	dec	r13		;
    4218:	fe 23       	jnz	$-2      	;abs 0x4216
    421a:	0d 16       	popm.a	#1,	r13	;20-bit words
    421c:	00 3c       	jmp	$+2      	;abs 0x421e
    421e:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    4222:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4226:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    422a:	f2 d0 0c 00 	bis.b	#12,	&0x0204	;#0x000c
    422e:	04 02 
    4230:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    4234:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    4238:	1e 14       	pushm.a	#2,	r14	;20-bit words
    423a:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    423e:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    4242:	1d 83       	dec	r13		;
    4244:	0e 73       	sbc	r14		;
    4246:	fd 23       	jnz	$-4      	;abs 0x4242
    4248:	0d 93       	cmp	#0,	r13	;r3 As==00
    424a:	fb 23       	jnz	$-8      	;abs 0x4242
    424c:	1d 16       	popm.a	#2,	r14	;20-bit words
    424e:	32 c0 07 01 	bic	#263,	r2	;#0x0107
    4252:	30 41       	ret			

00004254 <main>:
    4254:	b0 12 d2 41 	call	#16850		;#0x41d2
    4258:	b0 12 aa 40 	call	#16554		;#0x40aa
    425c:	b0 12 72 40 	call	#16498		;#0x4072
    4260:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4264:	3e 40 56 55 	mov	#21846,	r14	;#0x5556
    4268:	02 12       	push	r2		;
    426a:	32 c2       	dint			
    426c:	03 43       	nop			
    426e:	82 4e c2 04 	mov	r14,	&0x04c2	;
    4272:	82 4c c8 04 	mov	r12,	&0x04c8	;
    4276:	1e 42 ca 04 	mov	&0x04ca,r14	;0x04ca
    427a:	1f 42 cc 04 	mov	&0x04cc,r15	;0x04cc
    427e:	32 41       	pop	r2		;
    4280:	4e 18 0c 11 	rpt #15 { rrax.w	r12		;
    4284:	0d 4f       	mov	r15,	r13	;
    4286:	0d 8c       	sub	r12,	r13	;
    4288:	82 4d 02 1c 	mov	r13,	&0x1c02	;
    428c:	b0 12 8e 40 	call	#16526		;#0x408e
    4290:	b0 12 c6 40 	call	#16582		;#0x40c6
    4294:	4c 43       	clr.b	r12		;
    4296:	30 41       	ret			

00004298 <memcpy>:
    4298:	0f 4c       	mov	r12,	r15	;
    429a:	0e 5d       	add	r13,	r14	;
    429c:	0d 9e       	cmp	r14,	r13	;
    429e:	01 20       	jnz	$+4      	;abs 0x42a2
    42a0:	30 41       	ret			
    42a2:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    42a6:	1f 53       	inc	r15		;
    42a8:	f9 3f       	jmp	$-12     	;abs 0x429c

000042aa <_exit>:
    42aa:	ff 3f       	jmp	$+0      	;abs 0x42aa

000042ac <memmove>:
    42ac:	1a 15       	pushm	#2,	r10	;16-bit words
    42ae:	0f 4d       	mov	r13,	r15	;
    42b0:	0f 5e       	add	r14,	r15	;
    42b2:	0d 9c       	cmp	r12,	r13	;
    42b4:	02 2c       	jc	$+6      	;abs 0x42ba
    42b6:	0c 9f       	cmp	r15,	r12	;
    42b8:	07 28       	jnc	$+16     	;abs 0x42c8
    42ba:	0e 4c       	mov	r12,	r14	;
    42bc:	0d 9f       	cmp	r15,	r13	;
    42be:	0a 24       	jz	$+22     	;abs 0x42d4
    42c0:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;
    42c4:	1e 53       	inc	r14		;
    42c6:	fa 3f       	jmp	$-10     	;abs 0x42bc
    42c8:	09 4e       	mov	r14,	r9	;
    42ca:	39 e3       	inv	r9		;
    42cc:	4d 43       	clr.b	r13		;
    42ce:	3d 53       	add	#-1,	r13	;r3 As==11
    42d0:	09 9d       	cmp	r13,	r9	;
    42d2:	02 20       	jnz	$+6      	;abs 0x42d8
    42d4:	19 17       	popm	#2,	r10	;16-bit words
    42d6:	30 41       	ret			
    42d8:	0b 4e       	mov	r14,	r11	;
    42da:	0b 5d       	add	r13,	r11	;
    42dc:	0b 5c       	add	r12,	r11	;
    42de:	0a 4f       	mov	r15,	r10	;
    42e0:	0a 5d       	add	r13,	r10	;
    42e2:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    42e6:	f3 3f       	jmp	$-24     	;abs 0x42ce

000042e8 <memset>:
    42e8:	0e 5c       	add	r12,	r14	;
    42ea:	0f 4c       	mov	r12,	r15	;
    42ec:	0f 9e       	cmp	r14,	r15	;
    42ee:	01 20       	jnz	$+4      	;abs 0x42f2
    42f0:	30 41       	ret			
    42f2:	1f 53       	inc	r15		;
    42f4:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    42f8:	f9 3f       	jmp	$-12     	;abs 0x42ec
