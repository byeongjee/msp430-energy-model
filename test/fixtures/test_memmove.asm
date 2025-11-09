
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_memmove.elf:     file format elf32-msp430


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
    4020:	b0 12 54 40 	call	#16468		;#0x4054

00004024 <__crt0_call_main>:
    4024:	0c 43       	clr	r12		;

00004026 <.Loc.254.1>:
    4026:	b0 12 2e 40 	call	#16430		;#0x402e

0000402a <__crt0_call_exit>:
    402a:	b0 12 52 40 	call	#16466		;#0x4052

0000402e <main>:
    402e:	b2 40 34 12 	mov	#4660,	&0x1c00	;#0x1234
    4032:	00 1c 

00004034 <.Loc.11.1>:
    4034:	b2 40 11 11 	mov	#4369,	&0x1c02	;#0x1111
    4038:	02 1c 

0000403a <.Loc.12.1>:
    403a:	b2 40 22 22 	mov	#8738,	&0x1c04	;#0x2222
    403e:	04 1c 

00004040 <.Loc.13.1>:
    4040:	b2 40 33 33 	mov	#13107,	&0x1c06	;#0x3333
    4044:	06 1c 

00004046 <.Loc.14.1>:
    4046:	b2 40 44 44 	mov	#17476,	&0x1c08	;#0x4444
    404a:	08 1c 

0000404c <.Loc.16.1>:
    404c:	1c 42 02 1c 	mov	&0x1c02,r12	;0x1c02

00004050 <.Loc.17.1>:
    4050:	30 41       	ret			

00004052 <_exit>:
    4052:	ff 3f       	jmp	$+0      	;abs 0x4052

00004054 <memmove>:
    4054:	1a 15       	pushm	#2,	r10	;16-bit words

00004056 <L0^A>:
    4056:	0f 4d       	mov	r13,	r15	;
    4058:	0f 5e       	add	r14,	r15	;

0000405a <.Loc.69.1>:
    405a:	0d 9c       	cmp	r12,	r13	;
    405c:	02 2c       	jc	$+6      	;abs 0x4062

0000405e <.Loc.69.1>:
    405e:	0c 9f       	cmp	r15,	r12	;
    4060:	07 28       	jnc	$+16     	;abs 0x4070

00004062 <.L2>:
    4062:	0e 4c       	mov	r12,	r14	;

00004064 <.L4>:
    4064:	0d 9f       	cmp	r15,	r13	;
    4066:	0a 24       	jz	$+22     	;abs 0x407c

00004068 <.LVL3>:
    4068:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;

0000406c <.LVL4>:
    406c:	1e 53       	inc	r14		;
    406e:	fa 3f       	jmp	$-10     	;abs 0x4064

00004070 <.L3>:
    4070:	09 4e       	mov	r14,	r9	;
    4072:	39 e3       	inv	r9		;

00004074 <.Loc.74.1>:
    4074:	4d 43       	clr.b	r13		;

00004076 <.L5>:
    4076:	3d 53       	add	#-1,	r13	;r3 As==11

00004078 <.LVL7>:
    4078:	09 9d       	cmp	r13,	r9	;
    407a:	02 20       	jnz	$+6      	;abs 0x4080

0000407c <.L9>:
    407c:	19 17       	popm	#2,	r10	;16-bit words

0000407e <.LCFI1>:
    407e:	30 41       	ret			

00004080 <.L6>:
    4080:	0b 4e       	mov	r14,	r11	;
    4082:	0b 5d       	add	r13,	r11	;
    4084:	0b 5c       	add	r12,	r11	;
    4086:	0a 4f       	mov	r15,	r10	;
    4088:	0a 5d       	add	r13,	r10	;

0000408a <.LVL10>:
    408a:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    408e:	f3 3f       	jmp	$-24     	;abs 0x4076
