
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_rra_vflag_cleaned.elf:     file format elf32-msp430


Disassembly of section .text:

00004002 <__crt0_start>:
    4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004006 <__crt0_init_bss>:
    4006:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    400a:	0d 43       	clr	r13		;
    400c:	3e 40 02 00 	mov	#2,	r14	;
    4010:	b0 12 44 40 	call	#16452		;#0x4044

00004014 <__crt0_call_main>:
    4014:	0c 43       	clr	r12		;
    4016:	b0 12 1e 40 	call	#16414		;#0x401e

0000401a <__crt0_call_exit>:
    401a:	b0 12 42 40 	call	#16450		;#0x4042

0000401e <main>:
    401e:	16 15       	pushm	#2,	r6	;16-bit words
    4020:	35 40 ff 7f 	mov	#32767,	r5	;#0x7fff
    4024:	15 53       	inc	r5		;
    4026:	36 40 00 80 	mov	#-32768,r6	;#0x8000
    402a:	06 11       	rra	r6		;
    402c:	04 38       	jl	$+10     	;abs 0x4036
    402e:	b2 40 ef be 	mov	#-16657,&0x1c00	;#0xbeef
    4032:	00 1c 
    4034:	03 3c       	jmp	$+8      	;abs 0x403c

00004036 <v_flag_correct>:
    4036:	b2 40 fe ca 	mov	#-13570,&0x1c00	;#0xcafe
    403a:	00 1c 

0000403c <done>:
    403c:	4c 43       	clr.b	r12		;
    403e:	15 17       	popm	#2,	r6	;16-bit words
    4040:	30 41       	ret			

00004042 <_exit>:
    4042:	ff 3f       	jmp	$+0      	;abs 0x4042

00004044 <memset>:
    4044:	0e 5c       	add	r12,	r14	;
    4046:	0f 4c       	mov	r12,	r15	;
    4048:	0f 9e       	cmp	r14,	r15	;
    404a:	01 20       	jnz	$+4      	;abs 0x404e
    404c:	30 41       	ret			
    404e:	1f 53       	inc	r15		;
    4050:	cf 4d ff ff 	mov.b	r13,	-1(r15)	; 0xffff
    4054:	f9 3f       	jmp	$-12     	;abs 0x4048
