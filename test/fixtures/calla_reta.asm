
/Users/byeongjee/migration/probabilistic-energy-modeling/build/calla_reta_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 0a 00 	mov	#10,	r14	;#0x000a
    4010:	b0 12 b0 42 	call	#17072		;#0x42b0

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 44 42 	call	#16964		;#0x4244

0000401a <__crt0_call_exit>:
    401a:	b0 12 ae 42 	call	#17070		;#0x42ae

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
    41c6:	3c 40 0e 1c 	mov	#7182,	r12	;#0x1c0e
    41ca:	3c 90 0e 1c 	cmp	#7182,	r12	;#0x1c0e
    41ce:	07 2c       	jc	$+16     	;abs 0x41de
    41d0:	3e 40 0e 1c 	mov	#7182,	r14	;#0x1c0e
    41d4:	0e 8c       	sub	r12,	r14	;
    41d6:	3d 40 c2 42 	mov	#17090,	r13	;#0x42c2
    41da:	b0 12 9c 42 	call	#17052		;#0x429c
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
    4238:	32 c0 07 01 	bic	#263,	r2	;#0x0107
    423c:	30 41       	ret			

0000423e <add_ten_reta>:
    423e:	3c 50 0a 00 	add	#10,	r12	;#0x000a
    4242:	10 01       	reta			;

00004244 <main>:
    4244:	21 83       	decd	r1		;
    4246:	b0 12 bc 41 	call	#16828		;#0x41bc
    424a:	b1 40 64 00 	mov	#100,	0(r1)	;#0x0064
    424e:	00 00 
    4250:	b0 12 94 40 	call	#16532		;#0x4094
    4254:	b0 12 5c 40 	call	#16476		;#0x405c
    4258:	0c 41       	mov	r1,	r12	;
    425a:	82 4c 04 1c 	mov	r12,	&0x1c04	;
    425e:	2b 41       	mov	@r1,	r11	;
    4260:	0c 4b       	mov	r11,	r12	;
    4262:	b0 13 3e 42 	calla	#16958		;0x0423e
    4266:	0b 4c       	mov	r12,	r11	;
    4268:	82 4b 08 1c 	mov	r11,	&0x1c08	;
    426c:	0c 41       	mov	r1,	r12	;
    426e:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4272:	b0 12 78 40 	call	#16504		;#0x4078
    4276:	b0 12 5c 40 	call	#16476		;#0x405c
    427a:	b1 40 c8 00 	mov	#200,	0(r1)	;#0x00c8
    427e:	00 00 
    4280:	2b 41       	mov	@r1,	r11	;
    4282:	0c 4b       	mov	r11,	r12	;
    4284:	b0 13 3e 42 	calla	#16958		;0x0423e
    4288:	0b 4c       	mov	r12,	r11	;
    428a:	82 4b 06 1c 	mov	r11,	&0x1c06	;
    428e:	b0 12 78 40 	call	#16504		;#0x4078
    4292:	b0 12 b0 40 	call	#16560		;#0x40b0
    4296:	4c 43       	clr.b	r12		;
    4298:	21 53       	incd	r1		;
    429a:	30 41       	ret			

0000429c <memcpy>:
    429c:	0f 4c       	mov	r12,	r15	;
    429e:	0e 5d       	add	r13,	r14	;
    42a0:	0d 9e       	cmp	r14,	r13	;
    42a2:	01 20       	jnz	$+4      	;abs 0x42a6
    42a4:	30 41       	ret			
    42a6:	ff 4d 00 00 	mov.b	@r13+,	0(r15)	;
    42aa:	1f 53       	inc	r15		;
    42ac:	f9 3f       	jmp	$-12     	;abs 0x42a0

000042ae <_exit>:
    42ae:	ff 3f       	jmp	$+0      	;abs 0x42ae

000042b0 <memset>:
    42b0:	0e 5c       	add	r12,	r14	;
    42b2:	0f 4c       	mov	r12,	r15	;
    42b4:	0f 9e       	cmp	r14,	r15	;
    42b6:	01 20       	jnz	$+4      	;abs 0x42ba
    42b8:	30 41       	ret			
    42ba:	1f 53       	inc	r15		;
    42bc:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    42c0:	f9 3f       	jmp	$-12     	;abs 0x42b4
