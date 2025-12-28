
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_pop.elf:     file format elf32-msp430


Disassembly of section .text:

00004004 <__crt0_start>:
    4004:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004008 <__crt0_init_bss>:
    4008:	3c 40 02 1c 	mov	#7170,	r12	;#0x1c02

0000400c <.Loc.76.1>:
    400c:	0d 43       	clr	r13		;

0000400e <.Loc.77.1>:
    400e:	3e 40 02 00 	mov	#2,	r14	;

00004012 <.Loc.81.1>:
    4012:	b0 12 c6 40 	call	#16582		;#0x40c6

00004016 <__crt0_movedata>:
    4016:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

0000401a <.Loc.116.1>:
    401a:	3d 40 00 40 	mov	#16384,	r13	;#0x4000

0000401e <.Loc.119.1>:
    401e:	0d 9c       	cmp	r12,	r13	;

00004020 <.Loc.120.1>:
    4020:	04 24       	jz	$+10     	;abs 0x402a

00004022 <.Loc.122.1>:
    4022:	3e 40 02 00 	mov	#2,	r14	;

00004026 <.Loc.124.1>:
    4026:	b0 12 8a 40 	call	#16522		;#0x408a

0000402a <__crt0_call_main>:
    402a:	0c 43       	clr	r12		;

0000402c <.Loc.254.1>:
    402c:	b0 12 34 40 	call	#16436		;#0x4034

00004030 <__crt0_call_exit>:
    4030:	b0 12 88 40 	call	#16520		;#0x4088

00004034 <main>:
    4034:	1d 42 00 1c 	mov	&0x1c00,r13	;0x1c00
    4038:	7c 40 64 00 	mov.b	#100,	r12	;#0x0064
    403c:	b0 12 80 40 	call	#16512		;#0x4080
    4040:	82 4c 02 1c 	mov	r12,	&0x1c02	;
    4044:	4c 43       	clr.b	r12		;
    4046:	30 41       	ret			

00004048 <udivmodhi4>:
    4048:	0f 4c       	mov	r12,	r15	;

0000404a <.LVL1>:
    404a:	7c 40 11 00 	mov.b	#17,	r12	;#0x0011

0000404e <.LVL2>:
    404e:	5b 43       	mov.b	#1,	r11	;r3 As==01

00004050 <.L2>:
    4050:	0d 9f       	cmp	r15,	r13	;
    4052:	05 2c       	jc	$+12     	;abs 0x405e
    4054:	3c 53       	add	#-1,	r12	;r3 As==11

00004056 <.Loc.38.1>:
    4056:	0c 93       	cmp	#0,	r12	;r3 As==00
    4058:	05 24       	jz	$+12     	;abs 0x4064

0000405a <.Loc.38.1>:
    405a:	0d 93       	cmp	#0,	r13	;r3 As==00
    405c:	07 34       	jge	$+16     	;abs 0x406c

0000405e <.L10>:
    405e:	4c 43       	clr.b	r12		;

00004060 <.L6>:
    4060:	0b 93       	cmp	#0,	r11	;r3 As==00
    4062:	07 20       	jnz	$+16     	;abs 0x4072

00004064 <.L4>:
    4064:	0e 93       	cmp	#0,	r14	;r3 As==00
    4066:	01 24       	jz	$+4      	;abs 0x406a
    4068:	0c 4f       	mov	r15,	r12	;

0000406a <.L1>:
    406a:	30 41       	ret			

0000406c <.L5>:
    406c:	5d 02       	rlam	#1,	r13	;

0000406e <.Loc.41.1>:
    406e:	5b 02       	rlam	#1,	r11	;
    4070:	ef 3f       	jmp	$-32     	;abs 0x4050

00004072 <.L8>:
    4072:	0f 9d       	cmp	r13,	r15	;
    4074:	02 28       	jnc	$+6      	;abs 0x407a

00004076 <.Loc.47.1>:
    4076:	0f 8d       	sub	r13,	r15	;

00004078 <.Loc.48.1>:
    4078:	0c db       	bis	r11,	r12	;

0000407a <.L7>:
    407a:	5b 03       	rrum	#1,	r11	;

0000407c <.Loc.51.1>:
    407c:	5d 03       	rrum	#1,	r13	;
    407e:	f0 3f       	jmp	$-30     	;abs 0x4060

00004080 <__mspabi_divu>:
    4080:	4e 43       	clr.b	r14		;
    4082:	
00004084 <L0^A>:
    4084:	48 40       	mov.b	r0,	r8	;

00004086 <.LVL32>:
    4086:	30 41       	ret			

00004088 <_exit>:
    4088:	ff 3f       	jmp	$+0      	;abs 0x4088

0000408a <memmove>:
    408a:	1a 15       	pushm	#2,	r10	;16-bit words

0000408c <L0^A>:
    408c:	0f 4d       	mov	r13,	r15	;
    408e:	0f 5e       	add	r14,	r15	;

00004090 <.Loc.69.1>:
    4090:	0d 9c       	cmp	r12,	r13	;
    4092:	02 2c       	jc	$+6      	;abs 0x4098

00004094 <.Loc.69.1>:
    4094:	0c 9f       	cmp	r15,	r12	;
    4096:	07 28       	jnc	$+16     	;abs 0x40a6

00004098 <.L2>:
    4098:	0e 4c       	mov	r12,	r14	;

0000409a <.L4>:
    409a:	0d 9f       	cmp	r15,	r13	;
    409c:	0a 24       	jz	$+22     	;abs 0x40b2

0000409e <.LVL3>:
    409e:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;

000040a2 <.LVL4>:
    40a2:	1e 53       	inc	r14		;
    40a4:	fa 3f       	jmp	$-10     	;abs 0x409a

000040a6 <.L3>:
    40a6:	09 4e       	mov	r14,	r9	;
    40a8:	39 e3       	inv	r9		;

000040aa <.Loc.74.1>:
    40aa:	4d 43       	clr.b	r13		;

000040ac <.L5>:
    40ac:	3d 53       	add	#-1,	r13	;r3 As==11

000040ae <.LVL7>:
    40ae:	09 9d       	cmp	r13,	r9	;
    40b0:	02 20       	jnz	$+6      	;abs 0x40b6

000040b2 <.L9>:
    40b2:	19 17       	popm	#2,	r10	;16-bit words

000040b4 <.LCFI1>:
    40b4:	30 41       	ret			

000040b6 <.L6>:
    40b6:	0b 4e       	mov	r14,	r11	;
    40b8:	0b 5d       	add	r13,	r11	;
    40ba:	0b 5c       	add	r12,	r11	;
    40bc:	0a 4f       	mov	r15,	r10	;
    40be:	0a 5d       	add	r13,	r10	;

000040c0 <.LVL10>:
    40c0:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    40c4:	f3 3f       	jmp	$-24     	;abs 0x40ac

000040c6 <memset>:
    40c6:	0e 5c       	add	r12,	r14	;

000040c8 <.LVL2>:
    40c8:	0f 4c       	mov	r12,	r15	;

000040ca <L0^A>:
    40ca:	0f 9e       	cmp	r14,	r15	;
    40cc:	01 20       	jnz	$+4      	;abs 0x40d0

000040ce <.Loc.104.1>:
    40ce:	30 41       	ret			

000040d0 <.L3>:
    40d0:	1f 53       	inc	r15		;

000040d2 <.LVL4>:
    40d2:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    40d6:	f9 3f       	jmp	$-12     	;abs 0x40ca
