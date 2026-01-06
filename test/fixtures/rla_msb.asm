
/Users/byeongjee/migration/probabilistic-energy-modeling/build/rla_msb_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 0a 00 	mov	#10,	r14	;#0x000a
    4010:	b0 12 6c 40 	call	#16492		;#0x406c

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 6a 40 	call	#16490		;#0x406a

0000401e <main>:
    401e:	7c 40 80 ff 	mov.b	#-128,	r12	;#0xff80
    4022:	4c 5c       	rla.b	r12		;
    4024:	c2 4c 09 1c 	mov.b	r12,	&0x1c09	;
    4028:	4c 42       	mov.b	r2,	r12	;
    402a:	5c f3       	and.b	#1,	r12	;r3 As==01
    402c:	c2 4c 07 1c 	mov.b	r12,	&0x1c07	;
    4030:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
    4034:	4c 5c       	rla.b	r12		;
    4036:	c2 4c 08 1c 	mov.b	r12,	&0x1c08	;
    403a:	4c 42       	mov.b	r2,	r12	;
    403c:	5c f3       	and.b	#1,	r12	;r3 As==01
    403e:	c2 4c 06 1c 	mov.b	r12,	&0x1c06	;
    4042:	3c 40 00 80 	mov	#-32768,r12	;#0x8000
    4046:	0c 5c       	rla	r12		;
    4048:	82 4c 04 1c 	mov	r12,	&0x1c04	;
    404c:	4c 42       	mov.b	r2,	r12	;
    404e:	5c f3       	and.b	#1,	r12	;r3 As==01
    4050:	c2 4c 01 1c 	mov.b	r12,	&0x1c01	;
    4054:	3c 40 00 40 	mov	#16384,	r12	;#0x4000
    4058:	0c 5c       	rla	r12		;
    405a:	82 4c 02 1c 	mov	r12,	&0x1c02	;
    405e:	4c 42       	mov.b	r2,	r12	;
    4060:	5c f3       	and.b	#1,	r12	;r3 As==01
    4062:	c2 4c 00 1c 	mov.b	r12,	&0x1c00	;
    4066:	4c 43       	clr.b	r12		;
    4068:	30 41       	ret			

0000406a <_exit>:
    406a:	ff 3f       	jmp	$+0      	;abs 0x406a

0000406c <memset>:
    406c:	0e 5c       	add	r12,	r14	;
    406e:	0f 4c       	mov	r12,	r15	;
    4070:	0f 9e       	cmp	r14,	r15	;
    4072:	01 20       	jnz	$+4      	;abs 0x4076
    4074:	30 41       	ret			
    4076:	1f 53       	inc	r15		;
    4078:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    407c:	f9 3f       	jmp	$-12     	;abs 0x4070
