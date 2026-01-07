
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_addressing_modes_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

0000400c <__crt0_start>:
    400c:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004010 <__crt0_movedata>:
    4010:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    4014:	3d 40 00 40 	mov	#16384,	r13	;#0x4000
    4018:	0d 9c       	cmp	r12,	r13	;
    401a:	04 24       	jz	$+10     	;abs 0x4024
    401c:	3e 40 0a 00 	mov	#10,	r14	;#0x000a
    4020:	b0 12 60 40 	call	#16480		;#0x4060

00004024 <__crt0_call_main>:
    4024:	0c 43       	clr	r12		;
    4026:	b0 12 2e 40 	call	#16430		;#0x402e

0000402a <__crt0_call_exit>:
    402a:	b0 12 5e 40 	call	#16478		;#0x405e

0000402e <main>:
    402e:	b2 40 34 12 	mov	#4660,	&0x1c08	;#0x1234
    4032:	08 1c 
    4034:	3d 40 00 1c 	mov	#7168,	r13	;#0x1c00
    4038:	bd 40 11 11 	mov	#4369,	0(r13)	;#0x1111
    403c:	00 00 
    403e:	bd 40 22 22 	mov	#8738,	2(r13)	;#0x2222
    4042:	02 00 
    4044:	bd 40 33 33 	mov	#13107,	4(r13)	;#0x3333
    4048:	04 00 
    404a:	bd 40 44 44 	mov	#17476,	6(r13)	;#0x4444
    404e:	06 00 
    4050:	4c 43       	clr.b	r12		;
    4052:	1c 50 b4 db 	add	0xdbb4,	r12	;PC rel. 0x1c08
    4056:	3c 5d       	add	@r13+,	r12	;
    4058:	80 5c ae db 	add	r12,	0xdbae	; PC rel. 0x1c08
    405c:	30 41       	ret			

0000405e <_exit>:
    405e:	ff 3f       	jmp	$+0      	;abs 0x405e

00004060 <memmove>:
    4060:	1a 15       	pushm	#2,	r10	;16-bit words
    4062:	0f 4d       	mov	r13,	r15	;
    4064:	0f 5e       	add	r14,	r15	;
    4066:	0d 9c       	cmp	r12,	r13	;
    4068:	02 2c       	jc	$+6      	;abs 0x406e
    406a:	0c 9f       	cmp	r15,	r12	;
    406c:	07 28       	jnc	$+16     	;abs 0x407c
    406e:	0e 4c       	mov	r12,	r14	;
    4070:	0d 9f       	cmp	r15,	r13	;
    4072:	0a 24       	jz	$+22     	;abs 0x4088
    4074:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;
    4078:	1e 53       	inc	r14		;
    407a:	fa 3f       	jmp	$-10     	;abs 0x4070
    407c:	09 4e       	mov	r14,	r9	;
    407e:	39 e3       	inv	r9		;
    4080:	4d 43       	clr.b	r13		;
    4082:	3d 53       	add	#-1,	r13	;r3 As==11
    4084:	09 9d       	cmp	r13,	r9	;
    4086:	02 20       	jnz	$+6      	;abs 0x408c
    4088:	19 17       	popm	#2,	r10	;16-bit words
    408a:	30 41       	ret			
    408c:	0b 4e       	mov	r14,	r11	;
    408e:	0b 5d       	add	r13,	r11	;
    4090:	0b 5c       	add	r12,	r11	;
    4092:	0a 4f       	mov	r15,	r10	;
    4094:	0a 5d       	add	r13,	r10	;
    4096:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    409a:	f3 3f       	jmp	$-24     	;abs 0x4082
