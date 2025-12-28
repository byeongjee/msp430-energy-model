
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_pop_simple.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

0000400a <.Loc.76.1>:
    400a:	0d 43       	clr	r13		;

0000400c <.Loc.77.1>:
    400c:	3e 40 02 00 	mov	#2,	r14	;

00004010 <.Loc.81.1>:
    4010:	b0 12 32 40 	call	#16434		;#0x4032

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;

00004016 <.Loc.254.1>:
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 30 40 	call	#16432		;#0x4030

0000401e <main>:
    401e:	3f 40 34 12 	mov	#4660,	r15	;#0x1234
    4022:	0f 12       	push	r15		;
    4024:	3e 41       	pop	r14		;
    4026:	0c 4e       	mov	r14,	r12	;
    4028:	82 4c 00 1c 	mov	r12,	&0x1c00	;
    402c:	4c 43       	clr.b	r12		;
    402e:	30 41       	ret			

00004030 <_exit>:
    4030:	ff 3f       	jmp	$+0      	;abs 0x4030

00004032 <memset>:
    4032:	0e 5c       	add	r12,	r14	;

00004034 <L0^A>:
    4034:	0f 4c       	mov	r12,	r15	;

00004036 <.L2>:
    4036:	0f 9e       	cmp	r14,	r15	;
    4038:	01 20       	jnz	$+4      	;abs 0x403c

0000403a <.Loc.104.1>:
    403a:	30 41       	ret			

0000403c <.L3>:
    403c:	1f 53       	inc	r15		;

0000403e <.LVL4>:
    403e:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4042:	f9 3f       	jmp	$-12     	;abs 0x4036
