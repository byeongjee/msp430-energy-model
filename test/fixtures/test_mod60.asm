
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_mod60_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004004 <__crt0_start>:
    4004:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004008 <__crt0_init_bss>:
    4008:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02
    400c:	0d 43       	clr	r13		;
    400e:	3e 40 06 00 	mov	#6,	r14	;
    4012:	b0 12 d6 40 	call	#16598		;#0x40d6

00004016 <__crt0_movedata>:
    4016:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    401a:	3d 40 00 40 	mov	#16384,	r13	;#0x4000
    401e:	0d 9c       	cmp	r12,	r13	;
    4020:	04 24       	jz	$+10     	;abs 0x402a
    4022:	3e 40 02 00 	mov	#2,	r14	;
    4026:	b0 12 9a 40 	call	#16538		;#0x409a

0000402a <__crt0_call_main>:
    402a:	0c 43       	clr	r12		;
    402c:	b0 12 34 40 	call	#16436		;#0x4034

00004030 <__crt0_call_exit>:
    4030:	b0 12 98 40 	call	#16536		;#0x4098

00004034 <main>:
    4034:	7d 40 3c 00 	mov.b	#60,	r13	;#0x003c
    4038:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00
    403c:	b0 12 90 40 	call	#16528		;#0x4090
    4040:	3c 50 e2 ff 	add	#-30,	r12	;#0xffe2
    4044:	82 4c 06 1c 	mov	r12,	&0x1c06	;
    4048:	b2 40 ec ff 	mov	#-20,	&0x1c04	;#0xffec
    404c:	04 1c 
    404e:	b2 40 1d 00 	mov	#29,	&0x1c02	;#0x001d
    4052:	02 1c 
    4054:	4c 43       	clr.b	r12		;
    4056:	30 41       	ret			

00004058 <udivmodhi4>:
    4058:	0f 4c       	mov	r12,	r15	;
    405a:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011
    405e:	5b 43       	mov.b	#1,	r11	;r3 As==01
    4060:	0d 9f       	cmp	r15,	r13	;
    4062:	05 2c       	jc	$+12     	;abs 0x406e
    4064:	3c 53       	add	#-1,	r12	;r3 As==11
    4066:	0c 93       	cmp	#0,	r12	;r3 As==00
    4068:	05 24       	jz	$+12     	;abs 0x4074
    406a:	0d 93       	cmp	#0,	r13	;r3 As==00
    406c:	07 34       	jge	$+16     	;abs 0x407c
    406e:	4c 43       	clr.b	r12		;
    4070:	0b 93       	cmp	#0,	r11	;r3 As==00
    4072:	07 20       	jnz	$+16     	;abs 0x4082
    4074:	0e 93       	cmp	#0,	r14	;r3 As==00
    4076:	01 24       	jz	$+4      	;abs 0x407a
    4078:	0c 4f       	mov	r15,	r12	;
    407a:	30 41       	ret			
    407c:	5d 02       	rlam	#1,	r13	;
    407e:	5b 02       	rlam	#1,	r11	;
    4080:	ef 3f       	jmp	$-32     	;abs 0x4060
    4082:	0f 9d       	cmp	r13,	r15	;
    4084:	02 28       	jnc	$+6      	;abs 0x408a
    4086:	0f 8d       	sub	r13,	r15	;
    4088:	0c db       	bis	r11,	r12	;
    408a:	5b 03       	rrum	#1,	r11	;
    408c:	5d 03       	rrum	#1,	r13	;
    408e:	f0 3f       	jmp	$-30     	;abs 0x4070

00004090 <__mspabi_remu>:
    4090:	5e 43       	mov.b	#1,	r14	;r3 As==01
    4092:	b0 12 58 40 	call	#16472		;#0x4058
    4096:	30 41       	ret			

00004098 <_exit>:
    4098:	ff 3f       	jmp	$+0      	;abs 0x4098

0000409a <memmove>:
    409a:	1a 15       	pushm	#2,	r10	;16-bit words
    409c:	0f 4d       	mov	r13,	r15	;
    409e:	0f 5e       	add	r14,	r15	;
    40a0:	0d 9c       	cmp	r12,	r13	;
    40a2:	02 2c       	jc	$+6      	;abs 0x40a8
    40a4:	0c 9f       	cmp	r15,	r12	;
    40a6:	07 28       	jnc	$+16     	;abs 0x40b6
    40a8:	0e 4c       	mov	r12,	r14	;
    40aa:	0d 9f       	cmp	r15,	r13	;
    40ac:	0a 24       	jz	$+22     	;abs 0x40c2
    40ae:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;
    40b2:	1e 53       	inc	r14		;
    40b4:	fa 3f       	jmp	$-10     	;abs 0x40aa
    40b6:	09 4e       	mov	r14,	r9	;
    40b8:	39 e3       	inv	r9		;
    40ba:	4d 43       	clr.b	r13		;
    40bc:	3d 53       	add	#-1,	r13	;r3 As==11
    40be:	09 9d       	cmp	r13,	r9	;
    40c0:	02 20       	jnz	$+6      	;abs 0x40c6
    40c2:	19 17       	popm	#2,	r10	;16-bit words
    40c4:	30 41       	ret			
    40c6:	0b 4e       	mov	r14,	r11	;
    40c8:	0b 5d       	add	r13,	r11	;
    40ca:	0b 5c       	add	r12,	r11	;
    40cc:	0a 4f       	mov	r15,	r10	;
    40ce:	0a 5d       	add	r13,	r10	;
    40d0:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    40d4:	f3 3f       	jmp	$-24     	;abs 0x40bc

000040d6 <memset>:
    40d6:	0e 5c       	add	r12,	r14	;
    40d8:	0f 4c       	mov	r12,	r15	;
    40da:	0f 9e       	cmp	r14,	r15	;
    40dc:	01 20       	jnz	$+4      	;abs 0x40e0
    40de:	30 41       	ret			
    40e0:	1f 53       	inc	r15		;
    40e2:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    40e6:	f9 3f       	jmp	$-12     	;abs 0x40da
