
/Users/byeongjee/migration/probabilistic-energy-modeling/build/test_rrc_rrax.elf:     file format elf32-msp430


Disassembly of section .text:

00004004 <__crt0_start>:
    4004:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00

00004008 <__crt0_movedata>:
    4008:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00

0000400c <.Loc.116.1>:
    400c:	3d 40 00 40 	mov	#16384,	r13	;#0x4000

00004010 <.Loc.119.1>:
    4010:	0d 9c       	cmp	r12,	r13	;

00004012 <.Loc.120.1>:
    4012:	04 24       	jz	$+10     	;abs 0x401c

00004014 <.Loc.122.1>:
    4014:	3e 40 02 00 	mov	#2,	r14	;

00004018 <.Loc.124.1>:
    4018:	b0 12 4a 40 	call	#16458		;#0x404a

0000401c <__crt0_call_main>:
    401c:	0c 43       	clr	r12		;

0000401e <.Loc.254.1>:
    401e:	b0 12 22 40 	call	#16418		;#0x4022

00004022 <main>:
    4022:	3e 40 01 80 	mov	#-32767,r14	;#0x8001
    4026:	12 c3       	clrc			
    4028:	0e 10       	rrc	r14		;
    402a:	12 d3       	setc			
    402c:	0e 10       	rrc	r14		;
    402e:	3c 40 00 1c 	mov	#7168,	r12	;#0x1c00
    4032:	fc 40 ff 00 	mov.b	#255,	0(r12)	;#0x00ff
    4036:	00 00 
    4038:	12 c3       	clrc			
    403a:	6c 10       	rrc.b	@r12		;
    403c:	6f 4c       	mov.b	@r12,	r15	;
    403e:	3d 43       	mov	#-1,	r13	;r3 As==11
    4040:	3c 43       	mov	#-1,	r12	;r3 As==11
    4042:	42 18 0c 11 	rpt #3 { rrax.w	r12		;
    4046:	00 3c       	jmp	$+2      	;abs 0x4048

00004048 <_exit>:
    4048:	ff 3f       	jmp	$+0      	;abs 0x4048

0000404a <memmove>:
    404a:	1a 15       	pushm	#2,	r10	;16-bit words

0000404c <.LCFI0>:
    404c:	0f 4d       	mov	r13,	r15	;
    404e:	0f 5e       	add	r14,	r15	;

00004050 <.Loc.69.1>:
    4050:	0d 9c       	cmp	r12,	r13	;
    4052:	02 2c       	jc	$+6      	;abs 0x4058

00004054 <.Loc.69.1>:
    4054:	0c 9f       	cmp	r15,	r12	;
    4056:	07 28       	jnc	$+16     	;abs 0x4066

00004058 <.L2>:
    4058:	0e 4c       	mov	r12,	r14	;

0000405a <.L4>:
    405a:	0d 9f       	cmp	r15,	r13	;
    405c:	0a 24       	jz	$+22     	;abs 0x4072

0000405e <.LVL3>:
    405e:	fe 4d 00 00 	mov.b	@r13+,	0(r14)	;

00004062 <.LVL4>:
    4062:	1e 53       	inc	r14		;
    4064:	fa 3f       	jmp	$-10     	;abs 0x405a

00004066 <.L3>:
    4066:	09 4e       	mov	r14,	r9	;
    4068:	39 e3       	inv	r9		;

0000406a <.Loc.74.1>:
    406a:	4d 43       	clr.b	r13		;

0000406c <.L5>:
    406c:	3d 53       	add	#-1,	r13	;r3 As==11

0000406e <.LVL7>:
    406e:	09 9d       	cmp	r13,	r9	;
    4070:	02 20       	jnz	$+6      	;abs 0x4076

00004072 <.L9>:
    4072:	19 17       	popm	#2,	r10	;16-bit words

00004074 <.LCFI1>:
    4074:	30 41       	ret			

00004076 <.L6>:
    4076:	0b 4e       	mov	r14,	r11	;
    4078:	0b 5d       	add	r13,	r11	;
    407a:	0b 5c       	add	r12,	r11	;
    407c:	0a 4f       	mov	r15,	r10	;
    407e:	0a 5d       	add	r13,	r10	;

00004080 <.LVL10>:
    4080:	eb 4a 00 00 	mov.b	@r10,	0(r11)	;
    4084:	f3 3f       	jmp	$-24     	;abs 0x406c
