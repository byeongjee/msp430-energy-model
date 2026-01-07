
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_br_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 04 00 	mov	#4,	r14	;
    4010:	b0 12 70 40 	call	#16496		;#0x4070

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 44 40 	call	#16452		;#0x4044

0000401a <__crt0_call_exit>:
    401a:	b0 12 6e 40 	call	#16494		;#0x406e

0000401e <test_br_instruction>:
    401e:	3c 40 2a 40 	mov	#16426,	r12	;#0x402a
    4022:	00 4c       	br	r12		;
    4024:	b2 40 63 00 	mov	#99,	&0x1c02	;#0x0063
    4028:	02 1c 
    402a:	b2 40 2a 00 	mov	#42,	&0x1c02	;#0x002a
    402e:	02 1c 
    4030:	3d 40 3c 40 	mov	#16444,	r13	;#0x403c
    4034:	00 4d       	br	r13		;
    4036:	b2 40 58 00 	mov	#88,	&0x1c00	;#0x0058
    403a:	00 1c 
    403c:	b2 40 54 00 	mov	#84,	&0x1c00	;#0x0054
    4040:	00 1c 
    4042:	30 41       	ret			

00004044 <main>:
    4044:	3c 40 50 40 	mov	#16464,	r12	;#0x4050
    4048:	00 4c       	br	r12		;
    404a:	b2 40 63 00 	mov	#99,	&0x1c02	;#0x0063
    404e:	02 1c 
    4050:	b2 40 2a 00 	mov	#42,	&0x1c02	;#0x002a
    4054:	02 1c 
    4056:	3d 40 62 40 	mov	#16482,	r13	;#0x4062
    405a:	00 4d       	br	r13		;
    405c:	b2 40 58 00 	mov	#88,	&0x1c00	;#0x0058
    4060:	00 1c 
    4062:	b2 40 54 00 	mov	#84,	&0x1c00	;#0x0054
    4066:	00 1c 
    4068:	1c 42 02 1c 	mov	&0x1c02,r12	;0x1c02
    406c:	30 41       	ret			

0000406e <_exit>:
    406e:	ff 3f       	jmp	$+0      	;abs 0x406e

00004070 <memset>:
    4070:	0e 5c       	add	r12,	r14	;
    4072:	0f 4c       	mov	r12,	r15	;
    4074:	0f 9e       	cmp	r14,	r15	;
    4076:	01 20       	jnz	$+4      	;abs 0x407a
    4078:	30 41       	ret			
    407a:	1f 53       	inc	r15		;
    407c:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4080:	f9 3f       	jmp	$-12     	;abs 0x4074
