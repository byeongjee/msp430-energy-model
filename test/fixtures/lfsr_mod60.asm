
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_lfsr_mod60_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004004 <__crt0_start>:
    4004:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004008 <__crt0_init_bss>:
    4008:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02
    400c:	0d 43       	clr	r13		;
    400e:	3e 40 10 00 	mov	#16,	r14	;#0x0010
    4012:	b0 12 34 42 	call	#16948		;#0x4234

00004016 <__crt0_movedata>:
    4016:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    401a:	3d 40 00 40 	mov	#16384,	r13	;#0x4000
    401e:	0d 9c       	cmp	r12,	r13	;
    4020:	04 24       	jz	$+10     	;abs 0x402a
    4022:	3e 40 02 00 	mov	#2,	r14	;
    4026:	b0 12 f8 41 	call	#16888		;#0x41f8

0000402a <__crt0_call_main>:
    402a:	0c 43       	clr	r12		;
    402c:	b0 12 52 40 	call	#16466		;#0x4052

00004030 <__crt0_call_exit>:
    4030:	b0 12 f6 41 	call	#16886		;#0x41f6

00004034 <simple_rand>:
    4034:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4038:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    403c:	5c 03       	rrum	#1,	r12	;
    403e:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4042:	1d b3       	bit	#1,	r13	;r3 As==01
    4044:	03 24       	jz	$+8      	;abs 0x404c
    4046:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    404a:	00 1c 
    404c:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4050:	30 41       	ret			

00004052 <main>:
    4052:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4056:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    405a:	5c 03       	rrum	#1,	r12	;
    405c:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4060:	1d b3       	bit	#1,	r13	;r3 As==01
    4062:	03 24       	jz	$+8      	;abs 0x406a
    4064:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    4068:	00 1c 
    406a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    406e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4072:	b0 12 ee 41 	call	#16878		;#0x41ee
    4076:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    407a:	82 4c 02 1c 	mov	r12,	&0x1c02	;
    407e:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4082:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4086:	5c 03       	rrum	#1,	r12	;
    4088:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    408c:	1d b3       	bit	#1,	r13	;r3 As==01
    408e:	03 24       	jz	$+8      	;abs 0x4096
    4090:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    4094:	00 1c 
    4096:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    409a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    409e:	b0 12 ee 41 	call	#16878		;#0x41ee
    40a2:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    40a6:	82 4c 04 1c 	mov	r12,	&0x1c04	;
    40aa:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    40ae:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    40b2:	5c 03       	rrum	#1,	r12	;
    40b4:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    40b8:	1d b3       	bit	#1,	r13	;r3 As==01
    40ba:	03 24       	jz	$+8      	;abs 0x40c2
    40bc:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    40c0:	00 1c 
    40c2:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    40c6:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    40ca:	b0 12 ee 41 	call	#16878		;#0x41ee
    40ce:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    40d2:	82 4c 06 1c 	mov	r12,	&0x1c06	;
    40d6:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    40da:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    40de:	5c 03       	rrum	#1,	r12	;
    40e0:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    40e4:	1d b3       	bit	#1,	r13	;r3 As==01
    40e6:	03 24       	jz	$+8      	;abs 0x40ee
    40e8:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    40ec:	00 1c 
    40ee:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    40f2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    40f6:	b0 12 ee 41 	call	#16878		;#0x41ee
    40fa:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    40fe:	82 4c 08 1c 	mov	r12,	&0x1c08	;
    4102:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4106:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    410a:	5c 03       	rrum	#1,	r12	;
    410c:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4110:	1d b3       	bit	#1,	r13	;r3 As==01
    4112:	03 24       	jz	$+8      	;abs 0x411a
    4114:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    4118:	00 1c 
    411a:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    411e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4122:	b0 12 ee 41 	call	#16878		;#0x41ee
    4126:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    412a:	82 4c 0a 1c 	mov	r12,	&0x1c0a	;
    412e:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4132:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4136:	5c 03       	rrum	#1,	r12	;
    4138:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    413c:	1d b3       	bit	#1,	r13	;r3 As==01
    413e:	03 24       	jz	$+8      	;abs 0x4146
    4140:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    4144:	00 1c 
    4146:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    414a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    414e:	b0 12 ee 41 	call	#16878		;#0x41ee
    4152:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    4156:	82 4c 0c 1c 	mov	r12,	&0x1c0c	;
    415a:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    415e:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4162:	5c 03       	rrum	#1,	r12	;
    4164:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4168:	1d b3       	bit	#1,	r13	;r3 As==01
    416a:	03 24       	jz	$+8      	;abs 0x4172
    416c:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    4170:	00 1c 
    4172:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4176:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    417a:	b0 12 ee 41 	call	#16878		;#0x41ee
    417e:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    4182:	82 4c 0e 1c 	mov	r12,	&0x1c0e	;
    4186:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    418a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    418e:	5c 03       	rrum	#1,	r12	;
    4190:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    4194:	1d b3       	bit	#1,	r13	;r3 As==01
    4196:	03 24       	jz	$+8      	;abs 0x419e
    4198:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    419c:	00 1c 
    419e:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    41a2:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    41a6:	b0 12 ee 41 	call	#16878		;#0x41ee
    41aa:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    41ae:	82 4c 10 1c 	mov	r12,	&0x1c10	;
    41b2:	4c 43       	clr.b	r12		;
    41b4:	30 41       	ret			

000041b6 <udivmodhi4>:
    41b6:	0f 4c       	mov	r12,	r15	;
    41b8:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011
    41bc:	5b 43       	mov.b	#1,	r11	;r3 As==01
    41be:	0d 9f       	cmp	r15,	r13	;
    41c0:	05 2c       	jc	$+12     	;abs 0x41cc
    41c2:	3c 53       	add	#-1,	r12	;r3 As==11
    41c4:	0c 93       	cmp	#0,	r12	;r3 As==00
    41c6:	05 24       	jz	$+12     	;abs 0x41d2
    41c8:	0d 93       	cmp	#0,	r13	;r3 As==00
    41ca:	07 34       	jge	$+16     	;abs 0x41da
    41cc:	4c 43       	clr.b	r12		;
    41ce:	0b 93       	cmp	#0,	r11	;r3 As==00
    41d0:	07 20       	jnz	$+16     	;abs 0x41e0
    41d2:	0e 93       	cmp	#0,	r14	;r3 As==00
    41d4:	01 24       	jz	$+4      	;abs 0x41d8
    41d6:	0c 4f       	mov	r15,	r12	;
    41d8:	30 41       	ret			
    41da:	5d 02       	rlam	#1,	r13	;
    41dc:	5b 02       	rlam	#1,	r11	;
    41de:	ef 3f       	jmp	$-32     	;abs 0x41be
    41e0:	0f 9d       	cmp	r13,	r15	;
    41e2:	02 28       	jnc	$+6      	;abs 0x41e8
    41e4:	0f 8d       	sub	r13,	r15	;
    41e6:	0c db       	bis	r11,	r12	;
    41e8:	5b 03       	rrum	#1,	r11	;
    41ea:	5d 03       	rrum	#1,	r13	;
    41ec:	f0 3f       	jmp	$-30     	;abs 0x41ce

000041ee <__mspabi_remu>:
    41ee:	5e 43       	mov.b	#1,	r14	;r3 As==01
    41f0:	b0 12 b6 41 	call	#16822		;#0x41b6
    41f4:	30 41       	ret			

000041f6 <_exit>:
    41f6:	ff 3f       	jmp	$+0      	;abs 0x41f6

000041f8 <memmove>:
    41f8:	1a 15       	pushm	#2,	r10	;16-bit words
    41fa:	0f 4d       	mov	r13,	r15	;
    41fc:	0f 5e       	add	r14,	r15	;
    41fe:	0d 9c       	cmp	r12,	r13	;
    4200:	02 2c       	jc	$+6      	;abs 0x4206
    4202:	0c 9f       	cmp	r15,	r12	;
    4204:	07 28       	jnc	$+16     	;abs 0x4214
    4206:	0e 4c       	mov	r12,	r14	;
    4208:	0d 9f       	cmp	r15,	r13	;
    420a:	0a 24       	jz	$+22     	;abs 0x4220
    420c:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;
    4210:	1e 53       	inc	r14		;
    4212:	fa 3f       	jmp	$-10     	;abs 0x4208
    4214:	09 4e       	mov	r14,	r9	;
    4216:	39 e3       	inv	r9		;
    4218:	4d 43       	clr.b	r13		;
    421a:	3d 53       	add	#-1,	r13	;r3 As==11
    421c:	09 9d       	cmp	r13,	r9	;
    421e:	02 20       	jnz	$+6      	;abs 0x4224
    4220:	19 17       	popm	#2,	r10	;16-bit words
    4222:	30 41       	ret			
    4224:	0b 4e       	mov	r14,	r11	;
    4226:	0b 5d       	add	r13,	r11	;
    4228:	0b 5c       	add	r12,	r11	;
    422a:	0a 4f       	mov	r15,	r10	;
    422c:	0a 5d       	add	r13,	r10	;
    422e:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    4232:	f3 3f       	jmp	$-24     	;abs 0x421a

00004234 <memset>:
    4234:	0e 5c       	add	r12,	r14	;
    4236:	0f 4c       	mov	r12,	r15	;
    4238:	0f 9e       	cmp	r14,	r15	;
    423a:	01 20       	jnz	$+4      	;abs 0x423e
    423c:	30 41       	ret			
    423e:	1f 53       	inc	r15		;
    4240:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4244:	f9 3f       	jmp	$-12     	;abs 0x4238
