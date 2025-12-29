
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_lfsr_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004004 <__crt0_start>:
    4004:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004008 <__crt0_init_bss>:
    4008:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02
    400c:	0d 43       	clr	r13		;
    400e:	3e 40 0a 00 	mov	#10,	r14	;#0x000a
    4012:	b0 12 12 41 	call	#16658		;#0x4112

00004016 <__crt0_movedata>:
    4016:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    401a:	3d 40 00 40 	mov	#16384,	r13	;#0x4000
    401e:	0d 9c       	cmp	r12,	r13	;
    4020:	04 24       	jz	$+10     	;abs 0x402a
    4022:	3e 40 02 00 	mov	#2,	r14	;
    4026:	b0 12 d6 40 	call	#16598		;#0x40d6

0000402a <__crt0_call_main>:
    402a:	0c 43       	clr	r12		;
    402c:	b0 12 52 40 	call	#16466		;#0x4052

00004030 <__crt0_call_exit>:
    4030:	b0 12 d4 40 	call	#16596		;#0x40d4

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
    406a:	92 42 00 1c 	mov	&0x1c00,&0x1c0a	;0x1c00
    406e:	0a 1c 
    4070:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4074:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4078:	5c 03       	rrum	#1,	r12	;
    407a:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    407e:	1d b3       	bit	#1,	r13	;r3 As==01
    4080:	03 24       	jz	$+8      	;abs 0x4088
    4082:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    4086:	00 1c 
    4088:	92 42 00 1c 	mov	&0x1c00,&0x1c08	;0x1c00
    408c:	08 1c 
    408e:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4092:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    4096:	5c 03       	rrum	#1,	r12	;
    4098:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    409c:	1d b3       	bit	#1,	r13	;r3 As==01
    409e:	03 24       	jz	$+8      	;abs 0x40a6
    40a0:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    40a4:	00 1c 
    40a6:	92 42 00 1c 	mov	&0x1c00,&0x1c06	;0x1c00
    40aa:	06 1c 
    40ac:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    40b0:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    40b4:	5c 03       	rrum	#1,	r12	;
    40b6:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    40ba:	1d b3       	bit	#1,	r13	;r3 As==01
    40bc:	03 24       	jz	$+8      	;abs 0x40c4
    40be:	b2 e0 00 b4 	xor	#-19456,&0x1c00	;#0xb400
    40c2:	00 1c 
    40c4:	92 42 00 1c 	mov	&0x1c00,&0x1c04	;0x1c00
    40c8:	04 1c 
    40ca:	92 42 00 1c 	mov	&0x1c00,&0x1c02	;0x1c00
    40ce:	02 1c 
    40d0:	4c 43       	clr.b	r12		;
    40d2:	30 41       	ret			

000040d4 <_exit>:
    40d4:	ff 3f       	jmp	$+0      	;abs 0x40d4

000040d6 <memmove>:
    40d6:	1a 15       	pushm	#2,	r10	;16-bit words
    40d8:	0f 4d       	mov	r13,	r15	;
    40da:	0f 5e       	add	r14,	r15	;
    40dc:	0d 9c       	cmp	r12,	r13	;
    40de:	02 2c       	jc	$+6      	;abs 0x40e4
    40e0:	0c 9f       	cmp	r15,	r12	;
    40e2:	07 28       	jnc	$+16     	;abs 0x40f2
    40e4:	0e 4c       	mov	r12,	r14	;
    40e6:	0d 9f       	cmp	r15,	r13	;
    40e8:	0a 24       	jz	$+22     	;abs 0x40fe
    40ea:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;
    40ee:	1e 53       	inc	r14		;
    40f0:	fa 3f       	jmp	$-10     	;abs 0x40e6
    40f2:	09 4e       	mov	r14,	r9	;
    40f4:	39 e3       	inv	r9		;
    40f6:	4d 43       	clr.b	r13		;
    40f8:	3d 53       	add	#-1,	r13	;r3 As==11
    40fa:	09 9d       	cmp	r13,	r9	;
    40fc:	02 20       	jnz	$+6      	;abs 0x4102
    40fe:	19 17       	popm	#2,	r10	;16-bit words
    4100:	30 41       	ret			
    4102:	0b 4e       	mov	r14,	r11	;
    4104:	0b 5d       	add	r13,	r11	;
    4106:	0b 5c       	add	r12,	r11	;
    4108:	0a 4f       	mov	r15,	r10	;
    410a:	0a 5d       	add	r13,	r10	;
    410c:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    4110:	f3 3f       	jmp	$-24     	;abs 0x40f8

00004112 <memset>:
    4112:	0e 5c       	add	r12,	r14	;
    4114:	0f 4c       	mov	r12,	r15	;
    4116:	0f 9e       	cmp	r14,	r15	;
    4118:	01 20       	jnz	$+4      	;abs 0x411c
    411a:	30 41       	ret			
    411c:	1f 53       	inc	r15		;
    411e:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4122:	f9 3f       	jmp	$-12     	;abs 0x4116
