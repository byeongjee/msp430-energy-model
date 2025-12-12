
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_cache.elf:     file format elf32-msp430


Disassembly of section .text:

00004010 <__crt0_start>:
    4010:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;

00004016 <.Loc.254.1>:
    4016:	b0 12 e6 41 	call	#16870		;#0x41e6

0000401a <__crt0_call_exit>:
    401a:	b0 12 00 42 	call	#16896		;#0x4200

0000401e <L0^A>:
	...

00004020 <clockSetup>:
    4020:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4024:	61 01 
    4026:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    402a:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    402e:	64 01 
    4030:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4034:	66 01 
    4036:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    403a:	62 01 
    403c:	0d 14       	pushm.a	#1,	r13	;20-bit words
    403e:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004042 <.L1^B1>:
    4042:	1d 83       	dec	r13		;
    4044:	fe 23       	jnz	$-2      	;abs 0x4042
    4046:	0d 16       	popm.a	#1,	r13	;20-bit words

00004048 <L0^A>:
    4048:	00 3c       	jmp	$+2      	;abs 0x404a
    404a:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    404e:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4052:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4056:	30 41       	ret			

00004058 <toggle_gpio>:
    4058:	f2 e2 02 02 	xor.b	#8,	&0x0202	;r2 As==11
    405c:	30 41       	ret			

0000405e <begin_event>:
    405e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4060:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4064:	3e 40 05 00 	mov	#5,	r14	;

00004068 <.L1^B2>:
    4068:	1d 83       	dec	r13		;
    406a:	0e 73       	sbc	r14		;
    406c:	fd 23       	jnz	$-4      	;abs 0x4068
    406e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4070:	fb 23       	jnz	$-8      	;abs 0x4068
    4072:	1d 16       	popm.a	#2,	r14	;20-bit words
    4074:	f2 d2 02 02 	bis.b	#8,	&0x0202	;r2 As==11
    4078:	30 41       	ret			

0000407a <end_event>:
    407a:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    407e:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4080:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4084:	3e 40 05 00 	mov	#5,	r14	;

00004088 <.L1^B3>:
    4088:	1d 83       	dec	r13		;
    408a:	0e 73       	sbc	r14		;
    408c:	fd 23       	jnz	$-4      	;abs 0x4088
    408e:	0d 93       	cmp	#0,	r13	;r3 As==00
    4090:	fb 23       	jnz	$-8      	;abs 0x4088
    4092:	1d 16       	popm.a	#2,	r14	;20-bit words
    4094:	30 41       	ret			

00004096 <begin_measurement_window>:
    4096:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4098:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    409c:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000040a0 <.L1^B4>:
    40a0:	1d 83       	dec	r13		;
    40a2:	0e 73       	sbc	r14		;
    40a4:	fd 23       	jnz	$-4      	;abs 0x40a0
    40a6:	0d 93       	cmp	#0,	r13	;r3 As==00
    40a8:	fb 23       	jnz	$-8      	;abs 0x40a0
    40aa:	1d 16       	popm.a	#2,	r14	;20-bit words
    40ac:	e2 d2 02 02 	bis.b	#4,	&0x0202	;r2 As==10
    40b0:	30 41       	ret			

000040b2 <end_measurement_window>:
    40b2:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    40b6:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40b8:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40bc:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000040c0 <.L1^B5>:
    40c0:	1d 83       	dec	r13		;
    40c2:	0e 73       	sbc	r14		;
    40c4:	fd 23       	jnz	$-4      	;abs 0x40c0
    40c6:	0d 93       	cmp	#0,	r13	;r3 As==00
    40c8:	fb 23       	jnz	$-8      	;abs 0x40c0
    40ca:	1d 16       	popm.a	#2,	r14	;20-bit words
    40cc:	30 41       	ret			

000040ce <delay>:
    40ce:	0e 4c       	mov	r12,	r14	;
    40d0:	3e 53       	add	#-1,	r14	;r3 As==11
    40d2:	0f 4d       	mov	r13,	r15	;
    40d4:	3f 63       	addc	#-1,	r15	;r3 As==11
    40d6:	0c 4e       	mov	r14,	r12	;
    40d8:	0c df       	bis	r15,	r12	;
    40da:	0c 93       	cmp	#0,	r12	;r3 As==00
    40dc:	07 24       	jz	$+16     	;abs 0x40ec

000040de <.L11>:
    40de:	03 43       	nop			
    40e0:	3e 53       	add	#-1,	r14	;r3 As==11
    40e2:	3f 63       	addc	#-1,	r15	;r3 As==11
    40e4:	0c 4e       	mov	r14,	r12	;
    40e6:	0c df       	bis	r15,	r12	;
    40e8:	0c 93       	cmp	#0,	r12	;r3 As==00
    40ea:	f9 23       	jnz	$-12     	;abs 0x40de

000040ec <.L8>:
    40ec:	30 41       	ret			

000040ee <bench_empty_function>:
    40ee:	30 41       	ret			

000040f0 <bench_empty_interrupt>:
    40f0:	02 12       	push	r2		;
    40f2:	32 c2       	dint			
    40f4:	03 43       	nop			
    40f6:	00 13       	reti			

000040f8 <initialize>:
    40f8:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    40fc:	5c 01 
    40fe:	92 c3 30 01 	bic	#1,	&0x0130	;r3 As==01
    4102:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4106:	61 01 
    4108:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00
    410c:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    4110:	64 01 
    4112:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4116:	66 01 
    4118:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    411c:	62 01 
    411e:	0d 14       	pushm.a	#1,	r13	;20-bit words
    4120:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004124 <.L1^B6>:
    4124:	1d 83       	dec	r13		;
    4126:	fe 23       	jnz	$-2      	;abs 0x4124
    4128:	0d 16       	popm.a	#1,	r13	;20-bit words

0000412a <L0^A>:
    412a:	00 3c       	jmp	$+2      	;abs 0x412c
    412c:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00
    4130:	b2 c2 68 01 	bic	#8,	&0x0168	;r2 As==11
    4134:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00
    4138:	f2 d0 0c 00 	bis.b	#12,	&0x0204	;#0x000c
    413c:	04 02 
    413e:	f2 c2 02 02 	bic.b	#8,	&0x0202	;r2 As==11
    4142:	e2 c2 02 02 	bic.b	#4,	&0x0202	;r2 As==10
    4146:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4148:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    414c:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004150 <.L1^B7>:
    4150:	1d 83       	dec	r13		;
    4152:	0e 73       	sbc	r14		;
    4154:	fd 23       	jnz	$-4      	;abs 0x4150
    4156:	0d 93       	cmp	#0,	r13	;r3 As==00
    4158:	fb 23       	jnz	$-8      	;abs 0x4150
    415a:	1d 16       	popm.a	#2,	r14	;20-bit words
    415c:	30 41       	ret			

0000415e <icache_cycle_same_set>:
    415e:	b0 12 5e 40 	call	#16478		;#0x405e
    4162:	1a 3c       	jmp	$+54     	;abs 0x4198
	...

00004170 <blockA_same>:
    4170:	03 43       	nop			
    4172:	1c 83       	dec	r12		;
    4174:	05 20       	jnz	$+12     	;abs 0x4180
    4176:	14 3c       	jmp	$+42     	;abs 0x41a0
	...

00004180 <blockB_same>:
    4180:	03 43       	nop			
    4182:	03 43       	nop			
    4184:	03 43       	nop			
    4186:	04 3c       	jmp	$+10     	;abs 0x4190
	...

00004190 <blockC_same>:
    4190:	03 43       	nop			
    4192:	03 43       	nop			
    4194:	03 43       	nop			
    4196:	ec 3f       	jmp	$-38     	;abs 0x4170

00004198 <.L1^B8>:
    4198:	2c 43       	mov	#2,	r12	;r3 As==10
    419a:	ea 3f       	jmp	$-42     	;abs 0x4170
    419c:	00 00       	beq			
	...

000041a0 <.L2^B1>:
    41a0:	03 43       	nop			
    41a2:	03 43       	nop			
    41a4:	03 43       	nop			
    41a6:	03 43       	nop			
    41a8:	b0 12 7a 40 	call	#16506		;#0x407a
    41ac:	30 41       	ret			

000041ae <icache_cycle_split_set>:
    41ae:	b0 12 5e 40 	call	#16478		;#0x405e
    41b2:	0e 3c       	jmp	$+30     	;abs 0x41d0
    41b4:	00 00       	beq			
	...

000041b8 <blockA_split>:
    41b8:	03 43       	nop			
    41ba:	1c 83       	dec	r12		;
    41bc:	01 20       	jnz	$+4      	;abs 0x41c0
    41be:	0c 3c       	jmp	$+26     	;abs 0x41d8

000041c0 <blockB_split>:
    41c0:	03 43       	nop			
    41c2:	03 43       	nop			
    41c4:	03 43       	nop			
    41c6:	00 3c       	jmp	$+2      	;abs 0x41c8

000041c8 <blockC_split>:
    41c8:	03 43       	nop			
    41ca:	03 43       	nop			
    41cc:	03 43       	nop			
    41ce:	f4 3f       	jmp	$-22     	;abs 0x41b8

000041d0 <.L1^B9>:
    41d0:	2c 43       	mov	#2,	r12	;r3 As==10
    41d2:	f2 3f       	jmp	$-26     	;abs 0x41b8
    41d4:	00 00       	beq			
	...

000041d8 <.L2^B2>:
    41d8:	03 43       	nop			
    41da:	03 43       	nop			
    41dc:	03 43       	nop			
    41de:	03 43       	nop			
    41e0:	b0 12 7a 40 	call	#16506		;#0x407a
    41e4:	30 41       	ret			

000041e6 <main>:
    41e6:	b0 12 f8 40 	call	#16632		;#0x40f8
    41ea:	b0 12 96 40 	call	#16534		;#0x4096
    41ee:	b0 12 5e 41 	call	#16734		;#0x415e
    41f2:	b0 12 ae 41 	call	#16814		;#0x41ae
    41f6:	b0 12 b2 40 	call	#16562		;#0x40b2
    41fa:	4c 43       	clr.b	r12		;
    41fc:	30 41       	ret			
	...

00004200 <_exit>:
    4200:	ff 3f       	jmp	$+0      	;abs 0x4200
