
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_addressing_modes.elf:     file format elf32-msp430


Disassembly of section .text:

0000400c <__crt0_start>:
    400c:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004010 <__crt0_movedata>:
    4010:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

00004014 <.Loc.116.1>:
    4014:	3d 40 00 40 	mov	#16384,	r13	;#0x4000

00004018 <.Loc.119.1>:
    4018:	0d 9c       	cmp	r12,	r13	;

0000401a <.Loc.120.1>:
    401a:	04 24       	jz	$+10     	;abs 0x4024

0000401c <.Loc.122.1>:
    401c:	3e 40 0a 00 	mov	#10,	r14	;#0x000a

00004020 <.Loc.124.1>:
    4020:	b0 12 be 41 	call	#16830		;#0x41be

00004024 <__crt0_call_main>:
    4024:	0c 43       	clr	r12		;

00004026 <.Loc.254.1>:
    4026:	b0 12 7a 41 	call	#16762		;#0x417a

0000402a <__crt0_call_exit>:
    402a:	b0 12 bc 41 	call	#16828		;#0x41bc

0000402e <clockSetup>:
    402e:	f2 40 a5 ff 	mov.b	#-91,	&0x0161	;#0xffa5
    4032:	61 01 

00004034 <.Loc.13.1>:
    4034:	82 43 62 01 	mov	#0,	&0x0162	;r3 As==00

00004038 <.Loc.15.1>:
    4038:	b2 40 33 01 	mov	#307,	&0x0164	;#0x0133
    403c:	64 01 

0000403e <.Loc.20.1>:
    403e:	b2 40 22 02 	mov	#546,	&0x0166	;#0x0222
    4042:	66 01 

00004044 <.Loc.21.1>:
    4044:	b2 40 48 00 	mov	#72,	&0x0162	;#0x0048
    4048:	62 01 

0000404a <.Loc.23.1>:
    404a:	0d 14       	pushm.a	#1,	r13	;20-bit words
    404c:	3d 40 10 00 	mov	#16,	r13	;#0x0010

00004050 <.L1^B1>:
    4050:	1d 83       	dec	r13		;
    4052:	fe 23       	jnz	$-2      	;abs 0x4050
    4054:	0d 16       	popm.a	#1,	r13	;20-bit words

00004056 <L0^A>:
    4056:	00 3c       	jmp	$+2      	;abs 0x4058

00004058 <.Loc.26.1>:
    4058:	82 43 66 01 	mov	#0,	&0x0166	;r3 As==00

0000405c <.Loc.29.1>:
    405c:	1c 42 68 01 	mov	&0x0168,r12	;0x0168
    4060:	3c c2       	bic	#8,	r12	;r2 As==11
    4062:	82 4c 68 01 	mov	r12,	&0x0168	;

00004066 <.Loc.30.1>:
    4066:	c2 43 61 01 	mov.b	#0,	&0x0161	;r3 As==00

0000406a <.Loc.31.1>:
    406a:	03 43       	nop			
    406c:	30 41       	ret			

0000406e <toggle_gpio>:
    406e:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4072:	7c e2       	xor.b	#8,	r12	;r2 As==11
    4074:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4078:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

0000407c <.Loc.33.1>:
    407c:	03 43       	nop			
    407e:	30 41       	ret			

00004080 <begin_event>:
    4080:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4082:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    4086:	3e 40 05 00 	mov	#5,	r14	;

0000408a <.L1^B2>:
    408a:	1d 83       	dec	r13		;
    408c:	0e 73       	sbc	r14		;
    408e:	fd 23       	jnz	$-4      	;abs 0x408a
    4090:	0d 93       	cmp	#0,	r13	;r3 As==00
    4092:	fb 23       	jnz	$-8      	;abs 0x408a
    4094:	1d 16       	popm.a	#2,	r14	;20-bit words

00004096 <.Loc.37.1>:
    4096:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    409a:	7c d2       	bis.b	#8,	r12	;r2 As==11
    409c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    40a0:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000040a4 <.Loc.38.1>:
    40a4:	03 43       	nop			
    40a6:	30 41       	ret			

000040a8 <end_event>:
    40a8:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    40ac:	7c c2       	bic.b	#8,	r12	;r2 As==11
    40ae:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    40b2:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000040b6 <.Loc.41.1>:
    40b6:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40b8:	3d 40 7c 5a 	mov	#23164,	r13	;#0x5a7c
    40bc:	3e 40 05 00 	mov	#5,	r14	;

000040c0 <.L1^B3>:
    40c0:	1d 83       	dec	r13		;
    40c2:	0e 73       	sbc	r14		;
    40c4:	fd 23       	jnz	$-4      	;abs 0x40c0
    40c6:	0d 93       	cmp	#0,	r13	;r3 As==00
    40c8:	fb 23       	jnz	$-8      	;abs 0x40c0
    40ca:	1d 16       	popm.a	#2,	r14	;20-bit words

000040cc <.Loc.42.1>:
    40cc:	03 43       	nop			
    40ce:	30 41       	ret			

000040d0 <begin_measurement_window>:
    40d0:	1e 14       	pushm.a	#2,	r14	;20-bit words
    40d2:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    40d6:	3e 40 30 01 	mov	#304,	r14	;#0x0130

000040da <.L1^B4>:
    40da:	1d 83       	dec	r13		;
    40dc:	0e 73       	sbc	r14		;
    40de:	fd 23       	jnz	$-4      	;abs 0x40da
    40e0:	0d 93       	cmp	#0,	r13	;r3 As==00
    40e2:	fb 23       	jnz	$-8      	;abs 0x40da
    40e4:	1d 16       	popm.a	#2,	r14	;20-bit words

000040e6 <.Loc.46.1>:
    40e6:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    40ea:	6c d2       	bis.b	#4,	r12	;r2 As==10
    40ec:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    40f0:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

000040f4 <.Loc.47.1>:
    40f4:	03 43       	nop			
    40f6:	30 41       	ret			

000040f8 <end_measurement_window>:
    40f8:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    40fc:	6c c2       	bic.b	#4,	r12	;r2 As==10
    40fe:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4102:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004106 <.Loc.50.1>:
    4106:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4108:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    410c:	3e 40 30 01 	mov	#304,	r14	;#0x0130

00004110 <.L1^B5>:
    4110:	1d 83       	dec	r13		;
    4112:	0e 73       	sbc	r14		;
    4114:	fd 23       	jnz	$-4      	;abs 0x4110
    4116:	0d 93       	cmp	#0,	r13	;r3 As==00
    4118:	fb 23       	jnz	$-8      	;abs 0x4110
    411a:	1d 16       	popm.a	#2,	r14	;20-bit words

0000411c <.Loc.51.1>:
    411c:	03 43       	nop			
    411e:	30 41       	ret			

00004120 <initialize>:
    4120:	b2 40 80 5a 	mov	#23168,	&0x015c	;#0x5a80
    4124:	5c 01 

00004126 <.Loc.130.1>:
    4126:	1c 42 30 01 	mov	&0x0130,r12	;0x0130
    412a:	1c c3       	bic	#1,	r12	;r3 As==01
    412c:	82 4c 30 01 	mov	r12,	&0x0130	;

00004130 <.Loc.132.1>:
    4130:	b0 12 2e 40 	call	#16430		;#0x402e

00004134 <.Loc.135.1>:
    4134:	5c 42 04 02 	mov.b	&0x0204,r12	;0x0204
    4138:	7c d0 0c 00 	bis.b	#12,	r12	;#0x000c
    413c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    4140:	c2 4c 04 02 	mov.b	r12,	&0x0204	;

00004144 <.Loc.136.1>:
    4144:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4148:	7c c2       	bic.b	#8,	r12	;r2 As==11
    414a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    414e:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004152 <.Loc.137.1>:
    4152:	5c 42 02 02 	mov.b	&0x0202,r12	;0x0202
    4156:	6c c2       	bic.b	#4,	r12	;r2 As==10
    4158:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    415c:	c2 4c 02 02 	mov.b	r12,	&0x0202	;

00004160 <.Loc.139.1>:
    4160:	1e 14       	pushm.a	#2,	r14	;20-bit words
    4162:	3d 40 fc 6c 	mov	#27900,	r13	;#0x6cfc
    4166:	3e 40 30 01 	mov	#304,	r14	;#0x0130

0000416a <.L1^B6>:
    416a:	1d 83       	dec	r13		;
    416c:	0e 73       	sbc	r14		;
    416e:	fd 23       	jnz	$-4      	;abs 0x416a
    4170:	0d 93       	cmp	#0,	r13	;r3 As==00
    4172:	fb 23       	jnz	$-8      	;abs 0x416a
    4174:	1d 16       	popm.a	#2,	r14	;20-bit words

00004176 <.Loc.149.1>:
    4176:	03 43       	nop			
    4178:	30 41       	ret			

0000417a <main>:
    417a:	21 82       	sub	#4,	r1	;r2 As==10

0000417c <.LCFI0>:
    417c:	b0 12 20 41 	call	#16672		;#0x4120

00004180 <.Loc.10.2>:
    4180:	b2 40 34 12 	mov	#4660,	&0x1c00	;#0x1234
    4184:	00 1c 

00004186 <.Loc.11.2>:
    4186:	b2 40 11 11 	mov	#4369,	&0x1c02	;#0x1111
    418a:	02 1c 

0000418c <.Loc.12.2>:
    418c:	b2 40 22 22 	mov	#8738,	&0x1c04	;#0x2222
    4190:	04 1c 

00004192 <.Loc.13.2>:
    4192:	b2 40 33 33 	mov	#13107,	&0x1c06	;#0x3333
    4196:	06 1c 

00004198 <.Loc.14.2>:
    4198:	b2 40 44 44 	mov	#17476,	&0x1c08	;#0x4444
    419c:	08 1c 

0000419e <.Loc.16.2>:
    419e:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00

000041a2 <.Loc.17.2>:
    41a2:	b1 40 02 1c 	mov	#7170,	0(r1)	;#0x1c02
    41a6:	00 00 

000041a8 <.Loc.22.2>:
    41a8:	1c 41 02 00 	mov	2(r1),	r12	;
    41ac:	1c 50 52 da 	add	0xda52,	r12	;PC rel. 0x1c00
    41b0:	81 4c 02 00 	mov	r12,	2(r1)	;

000041b4 <.Loc.50.2>:
    41b4:	1c 41 02 00 	mov	2(r1),	r12	;

000041b8 <.Loc.51.2>:
    41b8:	21 52       	add	#4,	r1	;r2 As==10

000041ba <.LCFI1>:
    41ba:	30 41       	ret			

000041bc <_exit>:
    41bc:	ff 3f       	jmp	$+0      	;abs 0x41bc

000041be <memmove>:
    41be:	1a 15       	pushm	#2,	r10	;16-bit words

000041c0 <L0^A>:
    41c0:	0f 4d       	mov	r13,	r15	;
    41c2:	0f 5e       	add	r14,	r15	;

000041c4 <.Loc.69.1>:
    41c4:	0d 9c       	cmp	r12,	r13	;
    41c6:	02 2c       	jc	$+6      	;abs 0x41cc

000041c8 <.Loc.69.1>:
    41c8:	0c 9f       	cmp	r15,	r12	;
    41ca:	07 28       	jnc	$+16     	;abs 0x41da

000041cc <.L2>:
    41cc:	0e 4c       	mov	r12,	r14	;

000041ce <.L4>:
    41ce:	0d 9f       	cmp	r15,	r13	;
    41d0:	0a 24       	jz	$+22     	;abs 0x41e6

000041d2 <.LVL3>:
    41d2:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;

000041d6 <.LVL4>:
    41d6:	1e 53       	inc	r14		;
    41d8:	fa 3f       	jmp	$-10     	;abs 0x41ce

000041da <.L3>:
    41da:	09 4e       	mov	r14,	r9	;
    41dc:	39 e3       	inv	r9		;

000041de <.Loc.74.1>:
    41de:	4d 43       	clr.b	r13		;

000041e0 <.L5>:
    41e0:	3d 53       	add	#-1,	r13	;r3 As==11

000041e2 <.LVL7>:
    41e2:	09 9d       	cmp	r13,	r9	;
    41e4:	02 20       	jnz	$+6      	;abs 0x41ea

000041e6 <.L9>:
    41e6:	19 17       	popm	#2,	r10	;16-bit words

000041e8 <.LCFI1>:
    41e8:	30 41       	ret			

000041ea <.L6>:
    41ea:	0b 4e       	mov	r14,	r11	;
    41ec:	0b 5d       	add	r13,	r11	;
    41ee:	0b 5c       	add	r12,	r11	;
    41f0:	0a 4f       	mov	r15,	r10	;
    41f2:	0a 5d       	add	r13,	r10	;

000041f4 <.LVL10>:
    41f4:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    41f8:	f3 3f       	jmp	$-24     	;abs 0x41e0
