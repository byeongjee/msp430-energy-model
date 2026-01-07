
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_memmove_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

0000400c <__crt0_start>:
    400c:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004010 <__crt0_movedata>:
    4010:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    4014:	3d 40 00 40 	mov	#16384,	r13	;#0x4000
    4018:	0d 9c       	cmp	r12,	r13	;
    401a:	04 24       	jz	$+10     	;abs 0x4024
    401c:	3e 40 0a 00 	mov	#10,	r14	;#0x000a
    4020:	b0 12 56 40 	call	#16470		;#0x4056

00004024 <__crt0_call_main>:
    4024:	0c 43       	clr	r12		;
    4026:	b0 12 2e 40 	call	#16430		;#0x402e

0000402a <__crt0_call_exit>:
    402a:	b0 12 54 40 	call	#16468		;#0x4054

0000402e <main>:
    402e:	b2 40 34 12 	mov	#4660,	&0x1c08	;#0x1234
    4032:	08 1c 
    4034:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    4038:	bc 40 11 11 	mov	#4369,	0(r12)	;#0x1111
    403c:	00 00 
    403e:	bc 40 22 22 	mov	#8738,	2(r12)	;#0x2222
    4042:	02 00 
    4044:	bc 40 33 33 	mov	#13107,	4(r12)	;#0x3333
    4048:	04 00 
    404a:	bc 40 44 44 	mov	#17476,	6(r12)	;#0x4444
    404e:	06 00 
    4050:	2c 4c       	mov	@r12,	r12	;
    4052:	30 41       	ret			

00004054 <_exit>:
    4054:	ff 3f       	jmp	$+0      	;abs 0x4054

00004056 <memmove>:
    4056:	1a 15       	pushm	#2,	r10	;16-bit words
    4058:	0f 4d       	mov	r13,	r15	;
    405a:	0f 5e       	add	r14,	r15	;
    405c:	0d 9c       	cmp	r12,	r13	;
    405e:	02 2c       	jc	$+6      	;abs 0x4064
    4060:	0c 9f       	cmp	r15,	r12	;
    4062:	07 28       	jnc	$+16     	;abs 0x4072
    4064:	0e 4c       	mov	r12,	r14	;
    4066:	0d 9f       	cmp	r15,	r13	;
    4068:	0a 24       	jz	$+22     	;abs 0x407e
    406a:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;
    406e:	1e 53       	inc	r14		;
    4070:	fa 3f       	jmp	$-10     	;abs 0x4066
    4072:	09 4e       	mov	r14,	r9	;
    4074:	39 e3       	inv	r9		;
    4076:	4d 43       	clr.b	r13		;
    4078:	3d 53       	add	#-1,	r13	;r3 As==11
    407a:	09 9d       	cmp	r13,	r9	;
    407c:	02 20       	jnz	$+6      	;abs 0x4082
    407e:	19 17       	popm	#2,	r10	;16-bit words
    4080:	30 41       	ret			
    4082:	0b 4e       	mov	r14,	r11	;
    4084:	0b 5d       	add	r13,	r11	;
    4086:	0b 5c       	add	r12,	r11	;
    4088:	0a 4f       	mov	r15,	r10	;
    408a:	0a 5d       	add	r13,	r10	;
    408c:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    4090:	f3 3f       	jmp	$-24     	;abs 0x4078
