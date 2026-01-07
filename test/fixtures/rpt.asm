
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_rpt_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_call_main>:
    4006:	0c 43       	clr	r12		;
    4008:	b0 12 30 42 	call	#16944		;#0x4230

0000400c <__crt0_call_exit>:
    400c:	b0 12 5e 42 	call	#16990		;#0x425e

00004010 <clockSetup>:
    4010:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4014:	61 01 
    4016:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    401a:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    401e:	64 01 
    4020:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4024:	66 01 
    4026:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    402a:	62 01 
    402c:	0d 14       	pushm.a	#1,	r13	;20-bit words
    402e:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    4032:	1d 83       	dec	r13		;
    4034:	fe 23       	jnz	$-2      	;abs 0x4032
    4036:	0d 16       	popm.a	#1,	r13	;20-bit words
    4038:	00 3c       	jmp	$+2      	;abs 0x403a
    403a:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    403e:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4042:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4046:	30 41       	ret			

00004048 <toggle_gpio>:
    4048:	f2 e2 02 02 	xor.b	#8,	&0x0202	;r2 As==11
    404c:	30 41       	ret			

0000404e <begin_event>:
    404e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4050:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4054:	3e 40 05 00 	mov	#5,	r14	;
    4058:	1d 83       	dec	r13		;
    405a:	0e 73       	sbc	r14		;
    405c:	fd 23       	jnz	$-4      	;abs 0x4058
    405e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4060:	fb 23       	jnz	$-8      	;abs 0x4058
    4062:	1d 16       	popm.a	#2,	r14	;20-bit words
    4064:	f2 d2 02 02 	bis.b	#8,	&0x0202	;r2 As==11
    4068:	30 41       	ret			

0000406a <end_event>:
    406a:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    406e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4070:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4074:	3e 40 05 00 	mov	#5,	r14	;
    4078:	1d 83       	dec	r13		;
    407a:	0e 73       	sbc	r14		;
    407c:	fd 23       	jnz	$-4      	;abs 0x4078
    407e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4080:	fb 23       	jnz	$-8      	;abs 0x4078
    4082:	1d 16       	popm.a	#2,	r14	;20-bit words
    4084:	30 41       	ret			

00004086 <begin_measurement_window>:
    4086:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4088:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    408c:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    4090:	1d 83       	dec	r13		;
    4092:	0e 73       	sbc	r14		;
    4094:	fd 23       	jnz	$-4      	;abs 0x4090
    4096:	0d 93       	cmp	#0,	r13	;r3 As==00
    4098:	fb 23       	jnz	$-8      	;abs 0x4090
    409a:	1d 16       	popm.a	#2,	r14	;20-bit words
    409c:	e2 d2 02 02 	bis.b	#4,	&0x0202	;r2 As==10
    40a0:	30 41       	ret			

000040a2 <end_measurement_window>:
    40a2:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    40a6:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40a8:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40ac:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    40b0:	1d 83       	dec	r13		;
    40b2:	0e 73       	sbc	r14		;
    40b4:	fd 23       	jnz	$-4      	;abs 0x40b0
    40b6:	0d 93       	cmp	#0,	r13	;r3 As==00
    40b8:	fb 23       	jnz	$-8      	;abs 0x40b0
    40ba:	1d 16       	popm.a	#2,	r14	;20-bit words
    40bc:	30 41       	ret			

000040be <delay>:
    40be:	0e 4c       	mov	r12,	r14	;
    40c0:	3e 53       	add	#-1,	r14	;r3 As==11
    40c2:	0f 4d       	mov	r13,	r15	;
    40c4:	3f 63       	addc	#-1,	r15	;r3 As==11
    40c6:	0c 4e       	mov	r14,	r12	;
    40c8:	0c df       	bis	r15,	r12	;
    40ca:	0c 93       	cmp	#0,	r12	;r3 As==00
    40cc:	07 24       	jz	$+16     	;abs 0x40dc
    40ce:	03 43       	nop			
    40d0:	3e 53       	add	#-1,	r14	;r3 As==11
    40d2:	3f 63       	addc	#-1,	r15	;r3 As==11
    40d4:	0c 4e       	mov	r14,	r12	;
    40d6:	0c df       	bis	r15,	r12	;
    40d8:	0c 93       	cmp	#0,	r12	;r3 As==00
    40da:	f9 23       	jnz	$-12     	;abs 0x40ce
    40dc:	30 41       	ret			

000040de <bench_empty_function>:
    40de:	03 43       	nop			
    40e0:	03 43       	nop			
    40e2:	03 43       	nop			
    40e4:	03 43       	nop			
    40e6:	03 43       	nop			
    40e8:	03 43       	nop			
    40ea:	03 43       	nop			
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
    4142:	30 41       	ret			

00004144 <bench_empty_interrupt>:
    4144:	02 12       	push	r2		;
    4146:	32 c2       	dint			
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
    41a4:	03 43       	nop			
    41a6:	03 43       	nop			
    41a8:	03 43       	nop			
    41aa:	03 43       	nop			
    41ac:	00 13       	reti			

000041ae <initialize>:
    41ae:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    41b2:	5c 01 
    41b4:	92 c3 30 01 	bic	#1,	&0x0130	;r3 As==01
    41b8:	3c 40 04 1c 	mov	#7172,	r12	;#0x1c04
    41bc:	3c 90 04 1c 	cmp	#7172,	r12	;#0x1c04
    41c0:	07 2c       	jc	$+16     	;abs 0x41d0
    41c2:	3e 40 04 1c 	mov	#7172,	r14	;#0x1c04
    41c6:	0e 8c       	sub	r12,	r14	;
    41c8:	3d 40 60 42 	mov	#16992,	r13	;#0x4260
    41cc:	b0 12 4c 42 	call	#16972		;#0x424c
    41d0:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    41d4:	61 01 
    41d6:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    41da:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    41de:	64 01 
    41e0:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    41e4:	66 01 
    41e6:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    41ea:	62 01 
    41ec:	0d 14       	pushm.a	#1,	r13	;20-bit words
    41ee:	3d 40 10 00 	mov	#16,	r13	;#0x0010
    41f2:	1d 83       	dec	r13		;
    41f4:	fe 23       	jnz	$-2      	;abs 0x41f2
    41f6:	0d 16       	popm.a	#1,	r13	;20-bit words
    41f8:	00 3c       	jmp	$+2      	;abs 0x41fa
    41fa:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    41fe:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4202:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4206:	f2 d0 0c 00 	bis.b	#12,	&0x0204	;#0x000c
    420a:	04 02 
    420c:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    4210:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    4214:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4216:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    421a:	3e 40 30 01 	mov	#304,	r14	;#0x0130
    421e:	1d 83       	dec	r13		;
    4220:	0e 73       	sbc	r14		;
    4222:	fd 23       	jnz	$-4      	;abs 0x421e
    4224:	0d 93       	cmp	#0,	r13	;r3 As==00
    4226:	fb 23       	jnz	$-8      	;abs 0x421e
    4228:	1d 16       	popm.a	#2,	r14	;20-bit words
    422a:	32 c0 07 01 	bic	#263,	r2	;#0x0107
    422e:	30 41       	ret			

00004230 <main>:
    4230:	21 83       	decd	r1		;
    4232:	b0 12 ae 41 	call	#16814		;#0x41ae
    4236:	b1 40 00 f0 	mov	#-4096,	0(r1)	;#0xf000
    423a:	00 00 
    423c:	2c 41       	mov	@r1,	r12	;
    423e:	42 18 0c 11 	rpt #3 { rrax.w	r12		;
    4242:	81 4c 00 00 	mov	r12,	0(r1)	;
    4246:	2c 41       	mov	@r1,	r12	;
    4248:	21 53       	incd	r1		;
    424a:	30 41       	ret			

0000424c <memcpy>:
    424c:	0f 4c       	mov	r12,	r15	;
    424e:	0e 5d       	add	r13,	r14	;
    4250:	0d 9e       	cmp	r14,	r13	;
    4252:	01 20       	jnz	$+4      	;abs 0x4256
    4254:	30 41       	ret			
    4256:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    425a:	1f 53       	inc	r15		;
    425c:	f9 3f       	jmp	$-12     	;abs 0x4250

0000425e <_exit>:
    425e:	ff 3f       	jmp	$+0      	;abs 0x425e
