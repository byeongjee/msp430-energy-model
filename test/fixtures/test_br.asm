
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_br.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

0000400a <.Loc.76.1>:
    400a:	0d 43       	clr	r13		;

0000400c <.Loc.77.1>:
    400c:	3e 40 04 00 	mov	#4,	r14	;

00004010 <.Loc.81.1>:
    4010:	b0 12 52 40 	call	#16466		;#0x4052

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;

00004016 <.Loc.254.1>:
    4016:	b0 12 46 40 	call	#16454		;#0x4046

0000401a <__crt0_call_exit>:
    401a:	b0 12 50 40 	call	#16464		;#0x4050

0000401e <test_br_instruction>:
    401e:	3c 40 2a 40 	mov	#16426,	r12	;#0x402a
    4022:	00 4c       	br	r12		;
    4024:	b2 40 63 00 	mov	#99,	&0x1c00	;#0x0063
    4028:	00 1c 

0000402a <label1>:
    402a:	b2 40 2a 00 	mov	#42,	&0x1c00	;#0x002a
    402e:	00 1c 
    4030:	3d 40 3c 40 	mov	#16444,	r13	;#0x403c
    4034:	00 4d       	br	r13		;
    4036:	b2 40 58 00 	mov	#88,	&0x1c02	;#0x0058
    403a:	02 1c 

0000403c <label2>:
    403c:	b2 40 54 00 	mov	#84,	&0x1c02	;#0x0054
    4040:	02 1c 

00004042 <.Loc.37.1>:
    4042:	03 43       	nop			
    4044:	30 41       	ret			

00004046 <main>:
    4046:	b0 12 1e 40 	call	#16414		;#0x401e

0000404a <.Loc.47.1>:
    404a:	1c 42 00 1c 	mov	&0x1c00,r12	;0x1c00

0000404e <.Loc.48.1>:
    404e:	30 41       	ret			

00004050 <_exit>:
    4050:	ff 3f       	jmp	$+0      	;abs 0x4050

00004052 <memset>:
    4052:	0e 5c       	add	r12,	r14	;

00004054 <L0^A>:
    4054:	0f 4c       	mov	r12,	r15	;

00004056 <.L2>:
    4056:	0f 9e       	cmp	r14,	r15	;
    4058:	01 20       	jnz	$+4      	;abs 0x405c

0000405a <.Loc.104.1>:
    405a:	30 41       	ret			

0000405c <.L3>:
    405c:	1f 53       	inc	r15		;

0000405e <.LVL4>:
    405e:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4062:	f9 3f       	jmp	$-12     	;abs 0x4056
