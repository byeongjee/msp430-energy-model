MSP430 Family

Instruction Set

B.

Instruction Set Desciption

The  MSP430  Core  CPU  architecture  evolved  from  the  idea  of  using  a  reduced
instruction  set  with  highly  transparent  instruction  formats.  There  are  core  instructions
that  are  implemented  into  hardware,  and  emulated  instructions  that  use  the  hardware
construction and emulate instructions with high efficiency. The emulated instructions use
core instructions with the additional built-in constant generators CG1 and CG2. Both the
core  instructions  and  the  emulated  instructions  are  described  in  this  section.  The
mnemonics of the emulated instructions are used with the examples.

The words in program memory used by an instruction vary from 1 to 3 words, depending
on the combination of addressing modes.
Each instruction uses a minimum of one word (two bytes) in the program memory. The
indexed,  symbolic,  absolute  and  immediate  modes  need  one  additional  word  in  the
program memory. These four modes are available for the source operand. The indexed,
symbolic and absolute mode can be used for the destination operand.
The instruction combination for source and destination consumes one to three words of
code memory.

B

B-1

Instruction Set

MSP430 Family

B

B-2

MSP430 Family

Instruction Set

Instruction Set Overview

Status Bits

*

*

dst
ADC[.W];ADC.B
ADD[.W];ADD.B
src,dst
ADDC[.W];ADDC.B src,dst
src,dst
AND[.W];AND.B
src,dst
BIC[.W];BIC.B
src,dst
BIS[.W];BIS.B
src,dst
BIT[.W];BIT.B
dst
BR
dst
CALL
dst
Clear carry bit
Clear negative bit
Clear zero bit
src,dst

* CLR[.W];CLR.B
* CLRC
* CLRN
* CLRZ

CMP[.W];CMP.B

dst + C -> dst
src + dst -> dst
src + dst + C -> dst
src .and. dst -> dst
.not.src .and. dst -> dst
src .or. dst -> dst
src .and. dst
Branch to .......
PC+2 -> stack, dst -> PC
Clear destination

* DADC[.W];DADC.B dst

DADD[.W];DADD.B src,dst

* DEC[.W];DEC.B
dst
* DECD[.W];DECD.B dst
* DINT
EINT
*
INC[.W];INC.B
*

Disable interrupt
Enable interrupt
dst

dst - src
dst + C -> dst (decimal)
src + dst + C -> dst (decimal)
dst - 1 -> dst
dst - 2 -> dst

V N Z C
*
*
*
*
*
*
*
0
-
-
-
-
*
0
-
-
-
-
-
-
0
-
-
-
-
-
*
*
*
*
*
*
*
*
*
*
-
-
-
-

*
*
*
*
-
-
*
-
-
-
-
-
0
*
*
*
*
*
-
-

*
*
*
*
-
-
*
-
-
-
-
0
-
*
*
*
*
*
-
-

*

*

INCD[.W];INCD.B

dst

INV[.W];INV.B
JC/JHS
JEQ/JZ
JGE
JL
JMP
JN

JNC/JLO
JNE/JNZ

dst
Label
Label
Label
Label
Label
Label

Label
Label

*

Increment destination,
 dst +1 -> dst
Double-Increment destination,
*
dst+2->dst
*
Invert destination
-
Jump to Label if Carry-bit is set
Jump to Label if Zero-bit is set
-
Jump to Label if (N .XOR. V) = 0 -
Jump to Label if (N .XOR. V) = 1 -
Jump to Label unconditionally
-
Jump to Label if Negative-bit is
set
-
Jump to Label if Carry-bit is reset -
-
Jump to Label if Zero-bit is reset

*

*
*
-
-
-
-
-

-
-
-

*

*
*
-
-
-
-
-

-
-
-

*

*
*
-
-
-
-
-

-
-
-

Note: Marked instructions are emulated instructions

All  marked  instructions  (*)  are  emulated  instructions.  The  emulated  instructions
use  core  instructions  combined  with  the  architecture  and  implementation  of  the
CPU, for higher code efficiency and faster execution.

B

B-3

Instruction Set

MSP430 Family

Status Bits

MOV[.W];MOV.B

src,dst

* NOP
*

POP[.W];POP.B
dst
PUSH[.W];PUSH.B src
RETI

* RET

*
*
*
*

dst
dst
dst
dst
dst

* RLA[.W];RLA.B
* RLC[.W];RLC.B
RRA[.W];RRA.B
RRC[.W];RRC.B
SBC[.W];SBC.B
SETC
SETN
SETZ
SUB[.W];SUB.B
src,dst
SUBC[.W];SUBC.B src,dst
SWPB
SXT
TST[.W];TST.B
XOR[.W];XOR.B

dst
dst
dst
src,dst

*

 SP

 SP

 @SP

 SP, src ﬁ

 SP
 SZP

 PC, SP + 2 ﬁ

src -> dst
No operation
Item from stack, SP+2 ﬁ
SP - 2 ﬁ
Return from interrupt
 SR, SP + 2 ﬁ
TOS ﬁ
TOS ﬁ
 PC, SP + 2 ﬁ
Return from subroutine
TOS ﬁ
Rotate left arithmetically
Rotate left through carry
 ....LSB ﬁ
MSB ﬁ
 MSB ﬁ
C ﬁ
 .........LSB ﬁ
Subtract carry from destination
Set carry bit
Set negative bit
Set zero bit
dst + .not.src + 1 ﬁ
dst + .not.src + C ﬁ
swap bytes
Bit7 ﬁ
Test destination
src .xor. dst ﬁ

 Bit8 ........ Bit15

 dst
 dst

 MSB ﬁ

 C
 C

 dst

V N Z C
-
-
-
-
-
-
-
-
*
*

-
-
-
-
*

-
-
-
-
*

-

*
*
0
*
*
-
-
-
*
*
-
0
0
*

-

*
*
*
*
*
-
1
-
*
*
-
*
*
*

-

*
*
*
*
*
-
-
1
*
*
-
*
*
*

-

*
*
*
*
*
1
-
-
*
*
-
*
1
*

Note: Marked instructions

All  marked  instructions  (*)  are  emulated  instructions.  The  emulated  instructions
use  core  instructions  combined  with  the  architecture  and  implementation  of  the
CPU, for higher code efficiency and faster execution.

B

B-4

MSP430 Family

Instruction Set

Instruction Formats

Double operand instructions (core instructions)

The instruction format using double operands consists of four main fields, in total a 16bit
code:
• operational code field, 4bit
• source field, 6bit
• byte operation identifier, 1bit
• destination field, 5bit

[OP-Code]
[source register + As]
[BW]
[dest. register + Ad]

The  source  field  is  composed  of  two  addressing  bits  and  the    4bit  register  number
(0....15);  the  destination  field  is  composed  of  one  addressing  bit  and  the    4bit  register
number (0....15). The byte identifier B/W indicates whether the instruction is executed as
a byte (B/W=1) or as a word instruction (B/W=0)

  15

12   11

8   7         6   5    4

3

0

OP - Code

source register

Ad B/W As

dest. register

operational code field

ADD[.W]; ADD.B
ADDC[.W]; ADDC.B
AND[.W]; AND.B
BIC.B
BIC[.W];
BIS.B
BIS[.W];
BIT[.W];
BIT.B
CMP[.W]; CMP.B
DADD[.W]; DADD.B
MOV[.W]; MOV.B
SUB[.W]; SUB.B
SUBC[.W]; SUBC.B
XOR[.W]; XOR.B

src,dst
src,dst
src,dst
src,dst
src,dst
src,dst
src,dst
src,dst
src,dst
src,dst
src,dst
src,dst

src + dst -> dst
src + dst + C -> dst
src .and. dst -> dst
.not.src .and. dst -> dst
src .or. dst -> dst
src .and. dst
dst - src
src + dst + C -> dst (dec)
src -> dst
dst + .not.src + 1 -> dst
dst + .not.src + C -> dst
src .xor. dst -> dst

Status Bits

V N
*
*
*
*
*
0
-
-
-
-
*
0
*
*
*
*
-
-
*
*
*
*
*
*

Z
*
*
*
-
-
*
*
*
-
*
*
*

C
*
*
*
-
-
*
*
*
-
*
*
*

Note: Operations using Status Register SR for destination

All operations using Status Register SR for destination overwrite the contents of
SR with the result of that operation: the status bits are not affected as described in
that operation.

B

Example:  ADD #3,SR     ; Operation: (SR) + 3 --> SR

B-5

Instruction Set

MSP430 Family

Single operand instructions (core instructions)

The instruction format using a single operand consists of two main fields, in total 16bit:
• operational code field, 9bit with 4MSB equal '1h'
• byte operation identifier, 1bit
• destination field, 6bit

[BW]
[destination register + Ad]

The  destination  field  is  composed  of  two  addressing  bits  and  the  4bit  register  number
(0....15).  The  bit  position  of  the  destination  field  is  located  in  the  same  position  as  the
two  operand  instructions.  The  byte  identifier  B/W  indicates  whether  the  instruction  is
executed as a byte (B/W=1) or as a word instruction (B/W=0)

 15                         12   11      10    9                 7

6  5          4

 3                          0

0      0      0       1

X       X

X       X       X B/W

Ad

destination register

operational code field

destination field

 C
 C

 @SP

 MSB ﬁ

 MSB ﬁ

 SP, src ﬁ

 ...LSB ﬁ
 ........LSB ﬁ

MSB ﬁ
C ﬁ
SP - 2 ﬁ
swap bytes
PC+2 ﬁ
TOS ﬁ
TOS ﬁ
Bit7 -> Bit8 ........ Bit15

 @SP, dst ﬁ
 SR, SP + 2 ﬁ
 PC, SP + 2 ﬁ

 PC
 SP
 SP

Status Bits

N

Z

C

*
*
-
-
-
*

*

*
*
-
-
-
*

*

*
*
-
-
-
*

*

V

0
*
-
-
-
*

0

RRA[.W]; RRA.B
RRC[.W]; RRC.B
PUSH[.W]; PUSH.B
SWPB
CALL
RETI

SXT

dst
dst
dst
dst
dst

dst

B

B-6

MSP430 Family

Instruction Set

Conditional and unconditional Jumps (core instructions)

The instruction format for (un-)conditional jumps consists of two main fields, in total 16bit
:
• operational code (OP-Code) field, 6bit
• jump offset field, 10bit

The operational code field is composed of OP-Code (3bits), and 3 bits according to the
following conditions.

 15              13  12               10  9                                                                                     0

0       0       1 X      X      X

X     X      X      X     X     X      X      X     X      X

OP-Code

Jump-on .Code Sign

operational code field

Offset

Jump offset field

The conditional jumps allow jumps to addresses in the range -511 to +512 words relative
to  the  current  address.  The  assembler  computes  the  signed  offsets  and  inserts  them
into the opcode.

JC/JHS

JEQ/JZ

JGE

JL

JMP

JN

JNC/JLO

JNE/JNZ

Label

Label

Label

Label

Label

Label

Label

Label

Jump to Label if Carry-bit is set

Jump to Label if Zero-bit is set

Jump to Label if (N .XOR. V) = 0

Jump to Label if (N .XOR. V) = 1

Jump to Label unconditionally

Jump to Label if Negative-bit is set

Jump to Label if Carry-bit is reset

Jump to Label if Zero-bit is reset

Note: Conditional and unconditional Jumps

The conditional and unconditional Jumps do not effect the status bits.

A Jump which has been taken alters the PC with the offset:

PCnew=PCold + 2 + 2*offset.

B

A Jump which has not been taken continues the program with the ascending instruction.

B-7

Instruction Set

MSP430 Family

Emulation of instructions without ROM penalty

The  following  instructions  can  be  emulated  with  the  reduced  instruction  set,  without
additional  ROM  words.  The  assembler  accepts  the  mnemonic  of  the  emulated
instruction, and inserts the opcode of the suitable core instruction.

Note:

Emulation of the following instructions

The  emulation  of  the  following  instructions  is  possible  using  the  contents  of  R2
and R3:
The  register  R2(CG1)  contains  the  immediate  values  2  and  4;  the  register
R3(CG2) contains -1 or 0FFFFh, 0, +1 and +2 depending on the addressing bits
As.  The  assembler  sets  the  addressing  bits  according  to  the  immediate  value
used.

B

B-8

MSP430 Family

Instruction Set

Short form of emulated instructions

Mnemonic

Description

Statusbits

Emulation

V N Z C

Arithmetical instructions
*
dst Add carry to destination
ADC[.W]
*
dst Add carry to destination
ADC.B
DADC[.W] dst Add carry decimal to destination *
dst Add carry decimal to destination *
DADC.B
*
dst Decrement destination
DEC[.W]
*
DEC.B
dst Decrement destination
*
DECD[.W] dst Double-Decrement destination
*
dst Double-Decrement destination
DECD.B
*
dst
INC[.W]
*
INC.B
dst
*
INCD[.W] dst
*
dst
INCD.B
*
dst Subtract carry from destination
SBC[.W]
*
dst Subtract carry from destination
SBC.B

Increment destination
Increment destination
Increment destination
Increment destination

Logical instructions
INV[.W]
INV.B
RLA[.W]
RLA.B
RLC[.W]
RLC.B

Invert destination
dst
dst
Invert destination
dst Rotate left arithmetically
dst Rotate left arithmetically
dst Rotate left through carry
dst Rotate left through carry

Data instructions (common use)
CLR[.W]
CLR.B
CLRC
CLRN
CLRZ
POP
SETC
SETN
SETZ
TST[.W]
TST.B

Clear destination
Clear destination
Clear carry bit
Clear negative bit
Clear zero bit
Item from stack
Set carry bit
Set negative bit
Set zero bit
Test destination
Test destination

dst
dst

dst

dst Branch to .......

Program flow instructions
BR
DINT
EINT
NOP
RET

Disable interrupt
Enable interrupt
No operation
Return from subroutine

*
*
*
*
*
*

-
-
-
-
-
-
-
-
-
0
0

-
-
-
-
-

*
*
*
*
*
*
*
*
*
*
*
*
*
*

*
*
*
*
*
*

-
-
-
0
-
-
-
1
-
*
*

-
-
-
-
-

*
*
*
*
*
*
*
*
*
*
*
*
*
*

*
*
*
*
*
*

-
-
-
-
0
-
-
-
1
*
*

-
-
-
-
-

ADDC
#0,dst
*
ADDC.B #0,dst
*
* DADD
#0,dst
* DADD.B #0,dst
#1,dst
*
SUB
#1,dst
*
SUB.B
#2,dst
*
SUB
#2,dst
*
SUB.B
#1,dst
*
ADD
#1,dst
*
ADD.B
#2,dst
*
ADD
#2,dst
*
ADD.B
#0,dst
*
SUBC
SUBC.B #0,dst
*

*
*
*
*
*
*

XOR #0FFFFh,dst
XOR.B #0FFFFh,dst
dst,dst
ADD
dst,dst
ADD.B
ADDC
dst,dst
ADDC.B dst,dst

- MOV #0,dst
- MOV.B #0,dst
#1,SR
0 BIC
#4,SR
BIC
-
-
#2,SR
BIC
- MOV @SP+,dst
#1,SR
1 BIS
#4,SR
BIS
-
-
#2,SR
BIS
1 CMP #0,dst
1 CMP.B #0,dst

BIC
BIS

- MOV dst,PC
#8,SR
-
-
#8,SR
- MOV #0h,#0h
- MOV @SP+,PC

B-9

B

Instruction Set

MSP430 Family

Instruction set description - alphabetical order

This  section  catalogues  and  describes  all  core  and  emulated  instructions.  Some
examples are given for explanation and as application hints.
The suffix .W or no suffix in the instruction mnemonic will result in a word operation.
The suffix .B at the instruction mnemonic will result in a byte operation.

* ADC[.W]
* ADC.B

Syntax

Add carry to destination
Add carry to destination

ADC    dst     or    ADC.W    dst
ADC.B

dst

Operation

dst + C -> dst

Emulation

ADDC
ADDC.B

#0,dst

#0,dst

Description

The carry C is added to the destination operand. The previous contents
of the destination are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Set if dst was incremented from 0FFFFh to 0000, reset otherwise
Set if dst was incremented from 0FFh to 00, reset otherwise

V:  Set if an arithmetic overflow occurs, otherwise reset

Mode Bits

OscOff, CPUOff and GIE are not affected

The  16-bit  counter  pointed  to  by  R13  is  added  to  a  32-bit  counter
pointed to by R12.
ADD
ADC

@R13,0(R12)
2(R12)

; Add carry to MSD

; Add LSDs

The 8-bit counter pointed to by R13 is added to a 16-bit counter pointed
to by R12.
ADD.B
ADC.B

; Add LSDs
; Add carry to MSD

@R13,0(R12)
1(R12)

Example

Example

B

B-10

MSP430 Family

Instruction Set

ADD[.W]
ADD.B

Syntax

Add source to destination
Add source to destination

ADD
ADD.B

src,dst
src,dst

or

ADD.W

src,dst

Operation

src + dst -> dst

Description

The  source  operand  is  added  to  the  destination  operand.  The  source
operand is not affected, the previous contents of the destination are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Set if there is a carry from the result, cleared if not.
V:  Set if an arithmetic overflow occurs, otherwise reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

R5 is increased by 10. The 'Jump' to TONI is performed on a carry

ADD
JC
......

#10,R5
TONI

; Carry occurred
; No carry

Example

R5 is increased by 10. The 'Jump' to TONI is performed on a carry

ADD.B
JC
......

#10,R5
TONI

; Add 10 to Lowbyte of R5
; Carry occurred, if (R5) ‡  246 [0Ah+0F6h]
; No carry

B

B-11

Instruction Set

MSP430 Family

ADDC[.W]
ADDC.B

Syntax

Add source and carry to destination.
Add source and carry to destination.

ADDC
src,dst
ADDC.B src,dst

or

ADDC.W src,dst

Operation

src + dst + C -> dst

Description

The  source  operand  and  the  carry  C  are  added  to  the  destination
operand.  The  source  operand  is  not  affected,  the  previous  contents  of
the destination are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Set if there is a carry from the MSB of the result, reset if not
V:  Set if an arithmetic overflow occurs, otherwise reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The 32-bit counter pointed to by R13 is added to a 32-bit counter eleven
words (20/2 + 2/2) above pointer in R13.

ADD
@R13+,20(R13)
ADDC @R13+,20(R13)
...

; ADD LSDs with no carryin
; ADD MSDs with carry
; resulting from the LSDs

Example

The 24-bit counter pointed to by R13 is added to a 24-bit counter eleven
words above pointer in R13.

@R13+,10(R13)
ADD.B
ADDC.B @R13+,10(R13)
ADDC.B @R13+,10(R13)
...

; ADD LSDs with no carryin
; ADD medium Bits with carry
; ADD MSDs with carry
; resulting from the LSDs

B

B-12

MSP430 Family

Instruction Set

AND[.W]
AND.B

Syntax

source AND destination
source AND destination

AND
AND.B

src,dst
src,dst

or

AND.W src,dst

Operation

src .AND. dst -> dst

Description

The source operand and the destination operand are  logically  AND'ed.
The result is placed into the destination.

Status Bits

N:  Set if MSB of result is set, reset if not set
Z:  Set if result is zero, reset otherwise
C:  Set if result is not zero, reset otherwise ( = .NOT. Zero)
V:  Reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The  bits  set  in  R5  are  used  as  a  mask  (#0AA55h)  for  the  word
addressed by TOM. If the result is zero, a branch is taken to label TONI

MOV
AND
JZ
......
;
;
;
;
;
AND
JZ

#0AA55h,R5
R5,TOM
TONI

; Load mask into register R5
; mask word addressed by TOM with R5
;
; Result is not zero

or

#0AA55h,TOM
TONI

Example

The bits of mask #0A5h are logically AND'ed with the Lowbyte TOM. If
the result is zero, a branch is taken to label TONI

AND.B
JZ
......

#0A5h,TOM
TONI

; mask Lowbyte TOM with R5
;
; Result is not zero

B

B-13

Instruction Set

MSP430 Family

BIC[.W]
BIC.B

Syntax

Clear bits in destination
Clear bits in destination

BIC
BIC.B

src,dst
src,dst

or

BIC.W src,dst

Operation

.NOT.src .AND. dst -> dst

Description

The  inverted  source  operand  and  the  destination  operand  are  logically
AND'ed. The result is placed into the destination. The source operand is
not affected.

Status Bits

N:  Not affected
Z:   Not affected
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The 6 MSBs of the RAM word LEO are cleared.

BIC #0FC00h,LEO

; Clear 6 MSBs in MEM(LEO)

Example

The 5 MSBs of the RAM byte LEO are cleared.

BIC.B

#0F8h,LEO

; Clear 5 MSBs in Ram location LEO

Example

The Portpins P0 and P1 are cleared.

P0OUT .equ
.equ
P0_0
.equ
P0_1

011h
01h
02h

;Definition of the Portaddress

BIC.B

#P0_0+P0_1,&P0OUT ;Set P0.0 and P0.1 to low

B

B-14

MSP430 Family

Instruction Set

BIS[.W]
BIS.B

Syntax

Set bits in destination
Set bits in destination

BIS
BIS.B

src,dst
src,dst

or

BIS.W

src,dst

Operation

src .OR. dst -> dst

Description

The  source  operand  and  the  destination  operand  are  logically  OR'ed.
The  result  is  placed  into  the  destination.  The  source  operand  is  not
affected.

Status Bits

N:  Not affected
Z:   Not affected
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The 6 LSB's of the RAM word TOM are set.

BIS

#003Fh,TOM  ;  set the 6 LSB's in RAM location TOM

Example

Start an A/D-conversion

ASOC
ACTL

.equ
.equ

1
114h

; Start of Conversion bit
; ADC-Control Register

BIS

#ASOC,&ACTL

; Start A/D-conversion

Example

The 3 MSBs of the RAM byte TOM are set.

BIS.B

#0E0h,TOM

; set the 3 MSBs in RAM location TOM

Example

The Portpins P0 and P1 are set to high

P0OUT .equ
.equ
P0
.equ
P1

011h
01h
02h

BIS.B

#P0+P1,&P0OUT

B

B-15

Instruction Set

MSP430 Family

BIT[.W]
BIT.B

Test bits in destination
Test bits in destination

Syntax

BIT

src,dst

or

BIT.W src,dst

Operation

src .AND. dst

Description

The source operand and the destination operand are  logically  AND'ed.
The  result  affects  only  the  Status  Bits.  The  source  and  destination
operands are not affected.

Status Bits

N:  Set if MSB of result is set, reset if not set
Z:  Set if result is zero, reset otherwise
C:  Set if result is not zero, reset otherwise (.NOT. Zero)
V:  Reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

If bit 9 of R8 is set, a branch is taken to label TOM.

BIT
JNZ
...

#0200h,R8
TOM

; bit 9 of R8 set ?
; Yes, branch to TOM
; No, proceed

Example

Determine which A/D-Channel is configured by the MUX

ACTL

.equ

114h

; ADC Control Register

BIT
jnz

#4,&ACTL
END

; Is Channel 0 selected ?
; Yes, branch to END

Example

If bit 3 of R8 is set, a branch is taken to label TOM.
BIT.B
JC

#8,R8
TOM

B

B-16

MSP430 Family

Instruction Set

BIT

(continued)

Example

The  receive  bit  RCV  of  a  serial  communication  is  tested.  Since  while
using the BIT instruction to test a single bit the carry is equal to the state
of  the  tested  bit,  the  carry  is  ; used  by  the  subsequent  instruction:  the
read info is shifted into the register RECBUF.

;
; Serial communication with LSB is shifted first:

BIT.B
RRC

#RCV,RCCTL
RECBUF

......
......

xxxx

xxxx

xxxx

; xxxx
; Bit info into carry
; Carry -> MSB of RECBUF
; cxxx    xxxx
; repeat previous two instructions
; 8 times
; cccc    cccc
 ^
; ^
 LSB
; MSB

; Serial communication with MSB is shifted first:

BIT.B
RLC.B

#RCV,RCCTL
RECBUF

......
......

; Bit info into carry
; Carry -> LSB of RECBUF
; xxxx
xxxc
; repeat previous two instructions
; 8 times
; cccc
; |
; MSB

cccc
 LSB

B

B-17

Instruction Set

MSP430 Family

* BR, BRANCH

Branch to .......... destination

Syntax

Operation

BR dst

dst -> PC

Emulation

MOV dst,PC

Description

An  unconditional  branch  is  taken  to  an  address  anywhere  in  the  64  K
address space. All source addressing modes may be used. The branch
instruction is a word instruction.

Status Bits

Status bits are not affected

Examples

Examples for all addressing modes are given

BR

#EXEC

;Branch to label EXEC or direct branch (e.g. #0A4h)
; Core instruction  MOV  @PC+,PC

BR

EXEC

BR

&EXEC

BR

R5

BR

@R5

BR

@R5+

B

BR

X(R5)

B-18

; Branch to the address contained in EXEC
; Core instruction  MOV  X(PC),PC
; Indirect address

; Branch to the address contained in absolute
; address EXEC
; Core instruction  MOV  X(0),PC
; Indirect address

; Branch to the address contained in R5
; Core instruction  MOV  R5,PC
; Indirect R5

; Branch to the address contained in the word R5
; points to.
; Core instruction  MOV  @R5,PC
; Indirect, indirect R5

; Branch to the address contained in the word R5
; points to and increments pointer in R5 afterwards.
; The next time - S/W flow uses R5 pointer - it can
; alter the program execution due to access to
; next address in a table, pointed by R5
; Core instruction  MOV  @R5,PC
; Indirect, indirect R5 with autoincrement

; Branch to the address contained in the address
; pointed to  by R5 + X  (e.g. table with address
; starting at X). X can be an address or a label
; Core instruction MOV  X(R5),PC
; Indirect indirect R5 + X

MSP430 Family

Instruction Set

CALL

Syntax

Operation

Subroutine

CALL dst

dst
-> tmp
SP - 2  -> SP
PC
tmp

-> @SP
-> PC

dst is evaluated and stored

updated PC to TOS
saved dst to PC

Description

A subroutine call is made to an address anywhere in the 64-K-address
space.  All  addressing  modes  may  be  used.  The  return  address  (the
address of the following instruction) is stored on the stack. The call in-
struction is a word instruction.

Status Bits

Status bits are not affected

Example

Examples for all addressing modes are given

CALL #EXEC ; Call on label EXEC or immediate address (e.g.

CALL EXEC

 SP,  PC+2 ﬁ

; #0A4h)
; SP-2 ﬁ
; Call on the address contained in EXEC
; SP-2 ﬁ
; Indirect address

 @SP,  @PC+ ﬁ

 @SP,  X(PC) ﬁ

 SP,  PC+2 ﬁ

 PC

 PC

CALL &EXEC ; Call on the address contained in absolute address

CALL R5

CALL @R5

CALL @R5+

CALL X(R5)

 PC

 PC

 @SP,  R5 ﬁ

 SP,  PC+2 ﬁ

 SP,  PC+2 ﬁ

 @SP,  @R5 ﬁ

 @SP,  X(PC) ﬁ

; EXEC
; SP-2 ﬁ
; Indirect address
; Call on the address contained in R5
; SP-2 ﬁ
; Indirect R5
; Call on the address contained in the word R5
; points
; to
; SP-2 ﬁ
 SP,  PC+2 ﬁ
; Indirect, indirect R5
; Call on the address contained in the word R5 points
; to and increments pointer in R5. The next time -
; S/W flow uses R5 pointer - it can alter the
; program execution due to access to next address
; in a table, pointed ; to by R5
; SP-2 ﬁ
 SP,  PC+2 ﬁ
; Indirect, indirect R5 with autoincrement
; Call on the address contained in the address pointed
; to by R5 + X  (e.g. table with address starting at X)
; X can be an address or a label
; SP-2 ﬁ
 SP,  PC+2 ﬁ
; Indirect indirect R5 + X

 @SP,  X(R5) ﬁ

 @SP,  @R5 ﬁ

 PC

 PC

 PC

B

B-19

Instruction Set

MSP430 Family

* CLR[.W]
* CLR.B

Syntax

Clear destination
Clear destination

CLR
CLR.B

dst
dst

Operation

0 -> dst

Emulation

MOV
#0,dst
MOV.B #0,dst

or

CLR.W dst

Description

The destination operand is cleared.

Status Bits

Status bits are not affected

Example

RAM word TONI is cleared

CLR

TONI

; 0 -> TONI

Example

Register R5 is cleared

CLR

R5

Example

RAM byte TONI is cleared

CLR.B

TONI

; 0 -> TONI

B

B-20

MSP430 Family

Instruction Set

* CLRC

Syntax

Operation

Clear carry bit

CLRC

0 -> C

Emulation

BIC

#1,SR

Description

The Carry Bit C is cleared. The clear carry instruction is a word
instruction.

Status Bits

N:  Not affected
Z:  Not affected
C:  Cleared
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The 16bit decimal counter pointed to by R13 is added to a 32bit counter
pointed to by R12.

CLRC
DADD @R13,0(R12)

DADC

2(R12)

; C=0: Defines start
; add 16bit counter to Lowword of 32bit
; counter
; add carry to Highword of 32bit counter

B

B-21

Instruction Set

MSP430 Family

* CLRN

Clear Negative bit

Syntax

CLRN

Operation

 N

0 ﬁ
or
(.NOT.src .AND. dst -> dst)

Emulation

BIC

#4,SR

Description

The constant 04h is inverted (0FFFBh)  and the destination operand are
logically  AND'ed.  The  result  is  placed  into  the  destination.  The  clear
negative bit instruction is a word instruction.

Status Bits

N:  Reset to 0
Z:   Not affected
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The Negative bit in the status register is cleared. This avoids the special
treatment of the called subroutine with negative numbers.

CLRN
CALL
......
......
JN
......
......
......
RET

SUBR

SUBRET

SUBR

SUBRET

; If input is negative: do nothing and return

B

B-22

MSP430 Family

Instruction Set

* CLRZ

Clear Zero bit

Syntax

CLRZ

Operation

 Z

0 ﬁ
or
(.NOT.src .AND. dst -> dst)

Emulation

BIC

#2,SR

Description

The constant 02h is inverted (0FFFDh) and the destination operand are
logically  AND'ed.  The  result  is  placed  into  the  destination.  The  clear
zero bit instruction is a word instruction.

Status Bits

N:  Not affected
Z:   Reset to 0
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The Zero bit in the status register is cleared.

CLRZ

B

B-23

Instruction Set

MSP430 Family

CMP[.W]
CMP.B

Syntax

Operation

Description

Status Bits

compare source and destination
compare source and destination

CMP src,dst
CMP.B src,dst

or

CMP.W src,dst

dst + .NOT.src + 1
or
(dst - src)

The source operand is subtracted from the destination operand. This is
made  by  adding  of  the  1's  complement  of  the  source  operand  plus  1.
The two operands are not affected and, the result is not stored; only the
status bits are affected.

N:  Set if result is negative, reset if positive (src >= dst)
Z:  Set if result is zero, reset otherwise  (src = dst)
C:  Set if there is a carry from the MSB of the result, reset if not
V:  Set if an arithmetic overflow occurs, otherwise reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

R5  and  R6  are  compared.  If  they  are  equal,  the  program  continues  at
the label EQUAL

CMP R5,R6
JEQ

EQUAL

; R5 = R6 ?
; YES, JUMP

Example

Two RAM blocks are compared. If they not equal, the program branches
to the label ERROR

MOV #NUM,R5

L$1 CMP &BLOCK1,&BLOCK2
ERROR

JNZ
DEC R5
L$1
JNZ

;number of words to be compared
;Are Words equal ?
;No, branch to ERROR
;Are all words compared?
;No, another compare

Example

The RAM bytes addressed by EDE and TONI are compared. If they are
equal, the program continues at the label EQUAL

CMP.B EDE,TONI
JEQ

EQUAL

; MEM(EDE) = MEM(TONI) ?
; YES, JUMP

B

B-24

MSP430 Family

Instruction Set

CMP.B

(continued)

Example

Check two Keys, which are connected to the Portpin P0 and P1. If key1
is  pressed,  the  program  branches  to  the  label  MENU1;  if  key2  is
pressed, the program branches to MENU2.

P0IN
KEY1
KEY2

.EQU
.EQU
.EQU

CMP.B
JEQ
CMP.B
JEQ

010h
01h
02h

#KEY1,&P0IN
MENU1
#KEY2,&P0IN
MENU2

B

B-25

Instruction Set

MSP430 Family

* DADC[.W]
* DADC.B

Add carry decimally
Add carry decimally

Syntax

DADC
DADC.B dst

dst    o    DADC.W    src,dst

Operation

dst + C -> dst (decimally)

Emulation

DADD
#0,dst
DADD.B #0,dst

Description

The Carry Bit C is added decimally to the destination

Status Bits

N:  Set if MSB is 1
Z:  Set if dst is 0, reset otherwise
C:  Set if destination increments from 9999 to 0000, reset otherwise
Set if destination increments from 99 to 00, reset otherwise

V:  Undefined

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The  4-digit  decimal  number  contained  in  R5  is  added  to  an  8-digit
decimal number pointed to by R8

CLRC

DADD R5,0(R8)
DADC 2(R8)

; Reset carry
; next instruction's start condition is defined
; Add LSDs + C
; Add carry to MSD

Example

The  2-digit  decimal  number  contained  in  R5  is  added  to  an  4-digit
decimal number pointed to by R8

CLRC

DADD.B
DADC

R5,0(R8)
1(R8)

; Reset carry
; next instruction's start condition is
; defined
; Add LSDs + C
; Add carry to MSDs

B

B-26

MSP430 Family

Instruction Set

DADD[.W]
DADD.B

Syntax

source and carry added decimally to destination
source and carry added decimally to destination

DADD
src,dst
DADD.B src,dst

or

DADD.W src,dst

Operation

src + dst + C -> dst (decimally)

Description

Status Bits

The  source  operand  and  the  destination  operand  are  treated  as  four
binary  coded  decimals  (BCD)  with  positive  signs.  The  source  operand
and  the  carry  C  are  added  decimally  to  the  destination  operand.  The
source operand is not affected, the previous contents of the destination
are lost. The result is not defined for non-BCD numbers.

N:  Set if the MSB is 1, reset otherwise
Z:  Set if result is zero, reset otherwise
C:  Set if the result is greater than 9999.
Set if the result is greater than 99.

V:  Undefined

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The 8-digit-BCD-number contained in R5 and R6 is added decimally to
a 8-digit-BCD-number contained in R3 and R4 (R6 and R4 contain the
MSDs).

CLRC
DADD
DADD
JC

R5,R3
R6,R4
OVERFLOW

; CLEAR CARRY
; add LSDs
; add MSDs with carry
; If carry occurs go to error handling routine

Example

The 2-digit decimal counter in RAMbyte CNT is incremented by one.

CLRC
DADD.B

or

SETC
DADD.B

#1,CNT

; clear Carry
; increment decimal counter

#0,CNT

; ”  DADC.B        CNT

B

B-27

Instruction Set

MSP430 Family

* DEC[.W]
* DEC.B

Syntax

Decrement destination
Decrement destination

DEC
DEC.B

dst
dst

Operation

dst - 1 -> dst

Emulation
Emulation

SUB
SUB.B

#1,dst
#1,dst

or

DEC.W dst

Description

The  destination  operand  is  decremented  by  one.  The  original  contents
are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if dst contained 1, reset otherwise
C:  Reset if dst contained 0, set otherwise
V:  Set if an arithmetic overflow occurs, otherwise reset.
      Set if initial value of destination was 08000h, otherwise reset.
      Set if initial value of destination was 080h, otherwise reset.

Mode Bits

OscOff, CPUOff and GIE are not affected

B

B-28

MSP430 Family

Instruction Set

* DEC

(continued)

Example

R10 is decremented by 1

DEC R10

; Decrement R10

; Move a block of 255 bytes from memory location starting with EDE to memory location
; starting with TONI
;  Tables  should  not  overlap:  start  of  destination  address  TONI  must  not  be  within  the
range ; EDE to EDE+0FEh
;

L$1

MOV
MOV
MOV.B
DEC
JNZ

#EDE,R6
#255,R10
@R6+,TONI-EDE-1(R6)
R10
L$1

;

Do not transfer tables with the routine above with this overlap:

EDE

EDE+254

TONI

TONI+254

Example

Memory byte at address LEO is decremented by 1

DEC.B

LEO

; Decrement MEM(LEO)

; Move a block of 255 bytes from memory location starting with EDE to memory location
; starting with TONI
; Tables should not overlap: start of destination address TONI must not be within the
; range EDE to EDE+0FEh
;

L$1

MOV
MOV.B
MOV.B
DEC.B
JNZ

#EDE,R6
#255,LEO
@R6+,TONI-EDE-1(R6)
LEO
L$1

B

B-29

Instruction Set

MSP430 Family

* DECD[.W]
* DECD.B

Double-Decrement destination
Double-Decrement destination

Syntax

DECD
DECD.B dst

dst     or     DECD.W    dst

Operation

dst - 2 -> dst

Emulation
Emulation

SUB
SUB.B

#2,dst
#2,dst

Description

The  destination  operand  is  decremented  by  two.  The  original  contents
are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if dst contained 2, reset otherwise
C:  Reset if dst contained 0 or 1, set otherwise
V:  Set if an arithmetic overflow occurs, otherwise reset.
        Set  if  initial  value  of  destination  was  08001  or  08000h,  otherwise

reset.

      Set if initial value of destination was 081 or 080h, otherwise reset.

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

R10 is decremented by 2

DECD

R10

; Decrement R10 by two

; Move a block of 255 words from memory location starting with EDE to memory location
; starting with TONI
; Tables should not overlap: start of destination address TONI must not be within the
; range EDE to EDE+0FEh
;

MOV
MOV
L$1 MOV

DECD
JNZ

#EDE,R6
#510,R10
@R6+,TONI-EDE-2(R6)
R10
L$1

Example

Memory at location LEO is decremented by 2

DECD.B LEO

; Decrement MEM(LEO)

B

Decrement status byte STATUS by 2

DECD.B STATUS

B-30

MSP430 Family

Instruction Set

* DINT

Syntax

Operation

Disable (general) interrupts

DINT

 GIE

0 ﬁ
or
(0FFF7h .AND. SR ﬁ

 SR /

.NOT.src .AND. dst -> dst)

Emulation

BIC

#8,SR

Description

All interrupts are disabled.
The  constant  #08h  is  inverted  and  logically  AND'ed  with  the  status
register SR. The result is placed into the SR.

Status Bits

N:  Not affected
Z:  Not affected
C:  Not affected
V:  Not affected

Mode Bits

GIE is reset.
OscOff and CPUOff are not affected

Example

The general interrupt enable bit GIE in the status register is cleared to
allow  a  non  disrupted  move  of  a  32bit  counter.  This  ensures  that  the
counter is not modified during the move by any interrupt.

DINT

; All interrupt events using the GIE bit are

MOV COUNTHI,R5
MOV COUNTLO,R6
EINT

; disabled
; Copy counter

; All interrupt events using the GIE bit are
; enabled

Note: Disable Interrupt

The  instruction  following  the  disable  interrupt  instruction  DINT  is  executed  when
the  interrupt  request  becomes  active  during  execution  of  DINT.  If  any  code
sequence  needs  to  be  protected  from  being  interrupted,  the  DINT  instruction
should be executed at least one instruction before this sequence.

B

B-31

Instruction Set

MSP430 Family

* EINT

Syntax

Operation

Enable (general) interrupts

EINT

 GIE

1 ﬁ
or
(0008h .OR. SR -> SR  /  .NOT.src .OR. dst -> dst)

Emulation

BIS

#8,SR

Description

All interrupts are enabled.
The constant #08h and the status register SR are logically OR'ed. The
result is placed into the SR.

Status Bits

N:  Not affected
Z:  Not affected
C:  Not affected
V:  Not affected

Mode Bits

GIE is set.
OscOff and CPUOff are not affected

Example

The general interrupt enable bit GIE in the status register is set.

; Interrupt routine of port P0.2 to P0.7
; The interrupt level is the lowest in the system
; P0IN is the address of the register where all port bits are read. P0IFG is the address of
; the register where all interrupt events are latched.
;

MaskOK

PUSH.B
BIC.B
EINT

BIT
JEQ
......
BIC
......
INCD

RETI

&P0IN
@SP,&P0IFG ; Reset only accepted flags

#Mask,@SP
MaskOK

#Mask,@SP

SP

; Preset port 0 interrupt flags stored on stack
; other interrupts are allowed

; Flags are present identically to mask: Jump

; Housekeeping: Inverse to PUSH instruction
; at the start of interrupt subroutine. Corrects
; the  stack pointer.

B

Note:

Enable Interrupt

The instruction following the enable interrupt instruction EINT is executed anyway,
even if an interrupt service request is pending.

B-32

MSP430 Family

Instruction Set

* INC[.W]
* INC.B

Syntax

Increment destination

Increment destination

INC
INC.B

dst

or

INC.W dst

dst

Operation

dst + 1 -> dst

Emulation

ADD

#1,dst

Description

The  destination  operand  is  incremented  by  one.  The  original  contents
are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if dst contained 0FFFFh, reset otherwise
Set if dst contained 0FFh, reset otherwise
C:  Set if dst contained 0FFFFh, reset otherwise
Set if dst contained 0FFh, reset otherwise
V:  Set if dst contained 07FFFh, reset otherwise
Set if dst contained 07Fh, reset otherwise

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The item on the top of a software stack (not the system stack) for byte
data is removed.

SSP .EQU R4
;

INC

SSP ; Remove TOSS (top of SW stack) by increment
; Do not use INC.B since SSP is a word register

Example

The status byte of a process STATUS is incremented. When it is equal
to eleven, a branch to OVFL is taken.

INC.B STATUS
CMP.B #11,STATUS
OVFL
JEQ

B

B-33

Instruction Set

MSP430 Family

* INCD[.W]
* INCD.B

Double-Increment destination
Double-Increment destination

Syntax

INCD
dst
INCD.B dst

or

INCD.W dst

Operation

dst + 2 -> dst

Emulation
Emulation

Description

Status Bits

ADD
ADD.B

#2,dst
#2,dst

The  destination  operand  is  incremented  by  two.  The  original  contents
are lost.

N:  Set if result is negative, reset if positive
Z:  Set if dst contained 0FFFEh, reset otherwise
Set if dst contained 0FEh, reset otherwise

C:  Set if dst contained 0FFFEh or 0FFFFh, reset otherwise
Set if dst contained 0FEh or 0FFh, reset otherwise
V:  Set if dst contained 07FFEh or 07FFFh, reset otherwise
Set if dst contained 07Eh or 07Fh, reset otherwise

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The item on the top of the stack is removed without the use of a register.

.......
PUSH

INCD

RET

R5

SP

; R5 is the result of a calculation, which is stored
; in the system stack
; Remove TOS by double-increment from stack
; Do not use INCD.B, SP is a word aligned
; register

Example

The byte on the top of the stack is incremented by two.

INCD.B

0(SP)

; Byte on TOS is increment by two

B

B-34

MSP430 Family

Instruction Set

* INV[.W]
* INV.B

Syntax

Invert destination
Invert destination

INV
INV.B

dst
dst

Operation

.NOT.dst -> dst

Emulation
Emulation

XOR
XOR.B #0FFh,dst

#0FFFFh,dst

Description

The destination operand is inverted. The original contents are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if dst contained 0FFFFh, reset otherwise
Set if dst contained 0FFh, reset otherwise

C:  Set if result is not zero, reset otherwise ( = .NOT. Zero)
Set if result is not zero, reset otherwise ( = .NOT. Zero)

V:  Set if initial destination operand was negative, otherwise reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

Content of R5 is negated (two's complement).

MOV #00Aeh,R5
R5
INV
R5
INC

R5 = 000AEh
;
; Invert R5,
R5 = 0FF51h
; R5 is now negated, R5 = 0FF52h

Example

Content of memory byte LEO is negated.

MOV.B #0AEh,LEO ;
LEO
INV.B
LEO
INC.B

MEM(LEO) = 0AEh
; Invert LEO,
MEM(LEO) = 051h
; MEM(LEO) is negated, MEM(LEO) = 052h

B

B-35

Instruction Set

MSP430 Family

JC
JHS

Syntax

Jump if carry set
Jump if higher or same

JC
JHS

label
label

Operation

if C = 1: PC + 2*offset -> PC
if C = 0: execute following instruction

Description

The  Carry  Bit  C  of  the  Status  Register  is  tested.  If  it  is  set,  the  10-bit
signed  offset  contained  in  the  LSB's  of  the  instruction  is  added  to  the
Program Counter. If C is reset, the next instruction following the jump is
executed. JC (jump if carry/higher or same) is used for the comparison
of unsigned numbers (0 to 65536).

Status Bits

Status bits are not affected

Example

The signal of input P0IN.1 is used to define or control the program flow.

BIT
JC
......

#10h,&P0IN ; State of signal -> Carry
PROGA

; If carry=1 then execute program routine A
; Carry=0, execute program here

Example

R5 is compared to 15. If the content is higher or same branch to LABEL.

CMP #15,R5
JHS
LABEL
......

; Jump is taken if R5 ‡  15
; Continue here if R5 < 15

B

B-36

MSP430 Family

Instruction Set

JEQ, JZ

Jump if equal, Jump if zero

Syntax

JEQ

label,

JZ

label

Operation

if Z = 1:  PC + 2*offset -> PC
if Z = 0: execute following instruction

Description

The  Zero  Bit  Z  of  the  Status  Register  is  tested.  If  it  is  set,  the  10-bit
signed  offset  contained  in  the  LSB's  of  the  instruction  is  added  to  the
Program Counter. If Z is not set, the next instruction following the jump
is executed.

Status Bits

Status bits are not affected

Example

Jump to address TONI if R7 contains zero.

TST
JZ

R7
TONI

; Test R7
; if zero: JUMP

Example

Jump to address LEO if R6 is equal to the table contents.

CMP

R6,Table(R5)

JEQ
......

LEO

; Compare content of R6 with content of
; MEM(Table address + content of R5)
; Jump if both data are equal
; No, data are not equal, continue here

Example

Branch to LABEL if R5 is 0.

TST
JZ
......

R5
LABEL

B

B-37

Instruction Set

MSP430 Family

JGE

Syntax

Operation

Description

Jump if greater or equal

JGE

label

if (N .XOR. V) = 0 then jump to label: PC + 2*offset -> PC
if (N .XOR. V) = 1 then execute following instruction

The  negative  bit  N  and  the  overflow  bit  V  of  the  Status  Register  are
tested.  If  both  N  and  V  are  set  or  reset,  the  10-bit  signed  offset
contained  in  the  LSB's  of  the  instruction  is  added  to  the  Program
Counter.  If  only  one  is  set,  the  next  instruction  following  the  jump  is
executed.
This allows comparison of signed integers.

Status Bits

Status bits are not affected

Example

When the content of R6 is greater or equal the memory pointed to by R7
the program continues at label EDE.

@R7,R6
EDE

; R6 ‡  (R7)?, compare on signed numbers
; Yes, R6 ‡  (R7)
; No, proceed

CMP
JGE
......
......
......

B

B-38

MSP430 Family

Instruction Set

JL

Jump if less

Syntax

JL

label

Operation

if (N .XOR. V) = 1 then jump to label: PC + 2*offset -> PC
if (N .XOR. V) = 0 then execute following instruction

Description

The  negative  bit  N  and  the  overflow  bit  V  of  the  Status  Register  are
tested. If only one is set, the 10-bit signed offset contained in the LSB's
of the instruction is added to the Program Counter. If both N and V are
set or reset, the next instruction following the jump is executed.
This allows comparison of signed integers.

Status Bits

Status bits are not affected

Example

When  the  content  of  R6  is  less  than  the  memory  pointed  to  by  R7  the
program continues at label EDE.

@R7,R6
EDE

; R6 < (R7)?,  compare on signed numbers
; Yes, R6 < (R7)
; No, proceed

CMP
JL
......
......
......

B

B-39

Instruction Set

MSP430 Family

JMP

Syntax

Jump unconditionally

JMP

label

Operation

PC + 2*offset -> PC

Description

The  10-bit  signed  offset  contained  in  the  LSB's  of  the  instruction  is
added to the Program Counter.

Status Bits

Status bits are not affected

Hint

This 1word instruction replaces the BRANCH instruction in the range of
-511 to +512 words, relative to the current program counter.

B

B-40

MSP430 Family

Instruction Set

JN

Jump if negative

Syntax

JN

label

Operation

if N = 1: PC + 2*offset -> PC
if N = 0: execute following instruction

Description

The negative bit N of the Status Register is tested. If it is set, the 10-bit
signed  offset  contained  in  the  LSB's  of  the  instruction  is  added  to  the
Program Counter. If N is reset, the next instruction following the jump is
executed.

Status Bits

Status bits are not affected

Example

The  result  of  a  computation  in  R5  is  to  be  subtracted  from  COUNT.  If
the  result  is  negative,  COUNT  is  to  be  cleared  and  the  program
continues execution in another path.

SUB
JN
......
......
......
......
CLR
......
......
......

L$1

R5,COUNT
L$1

; COUNT - R5 -> COUNT
; If negative continue with COUNT=0at PC=L$1
; Continue with COUNT‡ 0

COUNT

B

B-41

Instruction Set

MSP430 Family

JNC
JLO

Syntax

Jump if carry not set
Jump if lower

JNC
JNC

label
label

Operation

if C = 0: PC + 2*offset -> PC
if C = 1: execute following instruction

Description

The Carry Bit C of the Status Register is tested. If it is reset, the 10-bit
signed  offset  contained  in  the  LSB's  of  the  instruction  is  added  to  the
Program  Counter.  If  C  is  set,  the  next  instruction  following  the  jump  is
executed.  JNC  (jump  if  no  carry/lower)  is  used  for  the  comparison  of
unsigned numbers (0 to 65536).

Status Bits

status bits are not affected

Example

The  result  in  R6  is  added  in  BUFFER.  If  an  overflow  occurs  an  error
handling routine at address ERROR is going to be used.

ERROR

CONT

ADD
JNC
......
......
......
......
......
......
......

R6,BUFFER
CONT

; BUFFER + R6 -> BUFFER
; No carry, jump to CONT
; Error handler start

; Continue with normal program flow

Example

Branch to STL2 if byte STATUS contains 1 or 0.

CMP.B #2,STATUS
JLO
......

STL2

; STATUS < 2
; STATUS ‡  2, continue here

B

B-42

MSP430 Family

Instruction Set

JNE, JNZ

Jump if not equal, Jump if not zero

Syntax

JNE

label,

JNZ label

Operation

if Z = 0: PC + 2*offset -> PC
if Z = 1: execute following instruction

Description

The  Zero  Bit  Z  of  the  Status  Register  is  tested.  If  it  is  reset,  the  10-bit
signed  offset  contained  in  the  LSB's  of  the  instruction  is  added  to  the
Program  Counter.  If  Z  is  set,  the  next  instruction  following  the  jump  is
executed.

Status Bits

Status bits are not affected

Example

Jump to address TONI if R7 and R8 have different contents

CMP R7,R8
TONI
JNE
......

; COMPARE R7 WITH R8
; if different: Jump
; if equal, continue

B

B-43

Instruction Set

MSP430 Family

MOV[.W]
MOV.B

Syntax

Move source to destination
Move source to destination

MOV      src,dst      or      MOV.W      src,dst
MOV.B src,dst

Operation

src -> dst

Description

The source operand is moved to the destination.
The  source  operand  is  not  affected,  the  previous  contents  of  the
destination are lost.

Status Bits

Status bits are not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The  contents  of  table  EDE  (word  data)  are  copied  to  table  TOM.  The
length of the tables should be 020h locations.

Loop

MOV #EDE,R10
MOV #020h,R9
MOV @R10+,TOM-EDE-2(R10)
DEC R9
JNZ
......
......
......

Loop

; Prepare pointer
; Prepare counter
; Use pointer in R10 for both tables
; Decrement counter
; Counter „  0, continue copying
; Copying completed

Example

The  contents  of  table  EDE  (byte  data)  are  copied  to  table  TOM.  The
length of the tables should be 020h locations.

Loop

MOV #EDE,R10
MOV #020h,R9
MOV.B  @R10+,TOM-EDE-1(R10) ; Use pointer in R10 for

; Prepare pointer
; Prepare counter

DEC R9
JNZ

Loop

......
......
......

; both tables
; Decrement counter
; Counter „  0, continue
; copying
; Copying completed

B

B-44

MSP430 Family

Instruction Set

* NOP

Syntax

Operation

No operation

NOP

None

Emulation

MOV

#0,#0

Description

No  operation  is  performed.  The  instruction  may  be  used  for  the
elimination  of  instructions  during  the  software  check  or  for  defined
waiting times.

Status Bits

Status bits are not affected

The NOP instruction is mainly used for two purposes:
•
•

hold one, two or three memory words
adjust software timing

Note: Other instructions can be used to emulate no operation

Other instructions can be used to emulate no-operation instruction, using different
numbers of cycles and different numbers of code words.

Examples:
MOV
0(R4),0(R4)
MOV @R4,0(R4)
#0,EDE(R4)
BIC
$+2
JMP
#0,R5
BIC

; 6 cycles, 3 words
; 5 cycles, 2 words
; 4 cycles, 2 words
; 2 cycles, 1 word
; 1 cycles, 1 word.

B

B-45

Instruction Set

MSP430 Family

* POP[.W]
* POP.B

Syntax

Operation

Emulation
Emulation

Description

Pop word from stack to destination
Pop byte from stack to destination

POP
POP.B

dst
dst

@SP   -> dst
SP + 2 -> SP

MOV     @SP+,dst      or      MOV.W      @SP+,dst
MOV.B @SP+,dst

The stack location pointed to by the Stack Pointer (TOS) is moved to the
destination. The Stack Pointer is incremented by two afterwards.

Status Bits

Status bits are not affected

Example

The contents of R7 and the Status Register are restored from the stack.

POP R7
SR
POP

; Restore R7
; Restore status register

Example

The content of RAM byte LEO is restored from the stack.

POP.B

LEO

; The Low byte of the stack is moved to LEO.

Example

The content of R7 is restored from the stack.

POP.B R7

; The Low byte of the stack is moved to R7,
; the High byte of R7 is 00h

Example

The  contents  of  the  memory  pointed  to  by  R7  and  the  Status  Register
are restored from the stack.

POP.B

0(R7)

POP

SR

; The Low byte of the stack is moved to the
; the byte which is pointed to by R7
: Example:  R7 = 203h
;
: Example:
;

Mem(R7) = Low Byte of system stack
 R7 = 20Ah
Mem(R7) = Low Byte of system stack

B

Note:

The system Stack Pointer

The system Stack Pointer  SP  is  always  incremented  by  two,  independent  of  the
byte suffix. This is mandatory since the system Stack Pointer is used not only by
POP instructions; it is also used by the RETI instruction.

B-46

MSP430 Family

Instruction Set

PUSH[.W]
PUSH.B

Syntax

Operation

Push word onto stack
Push byte onto stack

PUSH      src      or      PUSH.W      src
PUSH.B      src

SP - 2 ﬁ
src ﬁ

 SP
 @SP

Description

The  Stack  Pointer  is  decremented  by  two,  then  the  source  operand  is
moved to the RAM word addressed by the Stack Pointer (TOS).

Status Bits

N:  Not affected
Z:  Not affected
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The contents of the Status Register and R8 are saved on the stack.

PUSH
PUSH

SR
R8

; save status register
; save R8

Example

The content of the peripheral TCDAT is saved on the stack.

PUSH.B &TCDAT

; save data from 8bit peripheral module,
; address TCDAT, onto stack

Note:

The system Stack Pointer

The system Stack Pointer SP is always decremented by two, independent of the
byte suffix. This is mandatory since the system Stack Pointer is used not only by
PUSH instruction; it is also used by the interrupt routine service.

B

B-47

Instruction Set

MSP430 Family

* RET

Syntax

Operation

Return from subroutine

RET

@SPﬁ
SP + 2 ﬁ

 PC

 SP

Emulation

MOV

@SP+,PC

Description

The  return  address  pushed  onto  the  stack  by  a  CALL  instruction  is
moved  to  the  Program  Counter.  The  program  continues  at  the  code
address following the subroutine call.

Status Bits

Status bits are not affected

B

B-48

MSP430 Family

Instruction Set

RETI

Syntax

Operation

Description

Return from Interrupt

RETI

TOS
SP + 2
TOS
SP + 2

 SR
 SP
 PC
 SP

1. The  status  register  is  restored  to  the  value  at  the  beginning  of  the
interrupt service routine. This is performed by replacing the present
contents of SR with the contents of TOS memory. The stack pointer
SP is incremented by two.

2. The  program  counter  is  restored  to  the  value  at  the  beginning  of
interrupt  service.  This  is  the  consecutive  step  after  the  interrupted
program flow. Restore is performed by replacing present contents of
PC  with  the  contents  of  TOS  memory.  The  stack  pointer  SP  is
incremented.

Status Bits

N:
 restored from system stack
Z:  restored from system stack
C:  restored from system stack
V:  restored from system stack

Mode Bits

OscOff, CPUOff and GIE are restored from system stack

Example

Main program is interrupted

.........

PC - 6

PC - 4

PC - 2

PC

PC + 2

PC + 4

PC + 6

PC + 8

Interrupt request

Interrupt accepted
PC+2 is stored
onto stack

PC=PCi

.........

PCi +2

PCi +4

PCi+n-4

PCi+n-2

PCi+n

RETI

B

B-49

ﬁ
ﬁ
ﬁ
ﬁ
Instruction Set

MSP430 Family

* RLA[.W]
* RLA.B

Syntax

Rotate left arithmetically
Rotate left arithmetically

RLA
RLA.B

dst            or      RLA.W

dst

dst

Operation

C <- MSB <- MSB-1 ....  LSB+1 <- LSB <- 0

Emulation

ADD
ADD.B

dst,dst
dst,dst

Description

The destination operand is shifted left one position. The MSB is shifted
into the carry C, the LSB is filled with 0. The RLA instruction acts as a
signed multiplication with 2.
An overflow occurs if dst ‡  04000h and dst < 0C000h before operation is
performed: the result has changed sign.
word

15

0

C

byte

7

0

0

An  overflow  occurs  if  dst  ‡   040h  and  dst  <  0C0h  before  operation  is
performed: the result has changed sign.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Loaded from the MSB
V:  Set if an arithmetic overflow occurs -

the initial value is 04000h £  dst < 0C000h; otherwise it is reset
Set if an arithmetic overflow occurs:
the initial value is  040h £  dst < 0C0h; otherwise it is reset

Mode Bits

OscOff, CPUOff and GIE are not affected

B

B-50

MSP430 Family

Instruction Set

* RLA

(continued)

Example

R7 is multiplied by 4.

RLA
RLA

R7
R7

; Shift left R7  (x 2) - emulated by   ADD  R7,R7
; Shift left R7  (x 4) - emulated by   ADD  R7,R7

Example

Lowbyte of R7 is multiplied by 4.

RLA.B

R7

RLA.B

R7

; Shift left Lowbyte of R7  (x 2) - emulated by
; ADD.B  R7,R7
; Shift left Lowbyte of R7  (x 4) - emulated by
; ADD.B  R7,R7

Note: RLA substitution

The Assembler does not recognize the instruction
   RLA      @R5+
It must be substituted by
   ADD     @R5+,-2(R5)

nor

or

RLA.B      @R5+.

ADD.B     @R5+,-1(R5).

B

B-51

Instruction Set

MSP430 Family

* RLC[.W]
* RLC.B

Syntax

Rotate left through carry
Rotate left through carry

RLC
RLC.B

dst
dst

or

RLC.W

dst

Operation

C <- MSB <- MSB-1 ....  LSB+1 <- LSB <- C

Emulation

ADDC

dst,dst

Description

The  destination  operand  is  shifted  left  one  position.  The  carry  C  is
shifted into the LSB, the MSB is shifted into the carry C.

word

15

C

byte

7

0

0

Status Bits

Mode Bits

N: Set if result is negative, reset if positive
Z: Set if result is zero, reset otherwise
C: Loaded from the MSB
V: Set if arithmetic overflow occurs otherwise reset
    Set if 03FFFh < dstinitial < 0C000h, otherwise reset
    Set if 03Fh < dstinitial < 0C0h, otherwise reset
OscOff, CPUOff and GIE are not affected

B

B-52

MSP430 Family

Instruction Set

* RLC

(continued)

Example

R5 is shifted left one position.

RLC

R5

; (R5 x 2) + C -> R5

Example

The information of input P0IN.1 is to be shifted into LSB of R5.

BIT.B
RLC

#2,&P0IN
R5

; Information -> Carry
; Carry=P0in.1 -> LSB of R5

Example

Content of MEM(LEO) is shifted left one position.

RLC.B

LEO

; Mem(LEO) x 2 + C -> Mem(LEO)

Example

The information of input P0IN.1 is to be shifted into LSB of R5.

BIT.B
RLC.B

#2,&P0IN
R5

; Information -> Carry
; Carry=P0in.1 -> LSB of R5
; High byte of R5 is reset

Note: RLC and RLC.B emulation

The Assembler does not recognize the instruction

   RLC      @R5+.

It must be substituted by

   ADDC     @R5+,-2(R5).

B

B-53

Instruction Set

MSP430 Family

RRA[.W]
RRA.B

Syntax

Rotate right arithmetically
Rotate right arithmetically

RRA
RRA.B

dst

or

RRA.W

dst

dst

Operation

MSB -> MSB, MSB -> MSB-1, ...  LSB+1 -> LSB,  LSB -> C

Description

The destination operand is shifted right one position. The MSB is shifted
into the MSB, the MSB is shifted into the  MSB-1,  the  LSB+1  is  shifted
into the LSB.

word

15

C

byte

15

0

0

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Loaded from the LSB
V:  Reset

Mode Bits

OscOff, CPUOff and GIE are not affected

B

B-54

MSP430 Family

Instruction Set

RRA
Example

(continued)
R5 is shifted right one position. The MSB remains with the old value. It
operates equal to an arithmetic division by 2.

;
;

; OR
;

RRA

R5

; R5/2 -> R5

The value in R5 is multiplied by 0.75 (0.5 + 0.25)

PUSH
RRA
ADD
RRA
......
......

RRA
PUSH
RRA
ADD
......

R5
R5
@SP+,R5
R5

; hold R5 temporarily using stack
; R5 x 0.5  ->  R5
; R5 x 0.5 + R5 = 1.5 x R5  -> R5
; (1.5 x R5) x 0.5 = 0.75 x R5  -> R5

R5
R5
@SP
@SP+,R5

; R5 x 0.5  ->  R5
; R5 x 0.5  ->  TOS
; TOS x 0.5 = 0.5 x R5 x 0.5 = 0.25 x R5  -> TOS
; R5 x 0.5 + R5 x 0.25 = 0.75 x R5  -> R5

Example

The Lowbyte of R5 is shifted right one position. The MSB remains with
the old value. It operates equal to an arithmetic division by 2.

;
;

; OR
;

RRA.B R5

; R5/2 -> R5: Operation is on Low byte only
; High byte of R5 is reset

The value in R5 - Low byte only! - is multiplied by 0.75 (0.5 + 0.25)

PUSH.B R5
RRA.B R5
ADD.B  @SP+,R5
RRA.B R5
......

RRA.B R5
PUSH.B R5
RRA.B @SP
ADD.B @SP+,R5
......

; hold Low byte of R5 temporarily using stack
; R5 x 0.5  ->  R5
; R5 x 0.5 + R5 = 1.5 x R5  -> R5
; (1.5 x R5) x 0.5 = 0.75 x R5  -> R5

; R5 x 0.5  ->  R5
; R5 x 0.5  ->  TOS
;TOS x 0.5 = 0.5 x R5 x 0.5 = 0.25x R5  -> TOS
; R5 x 0.5 + R5 x 0.25 = 0.75 x R5  -> R5

B

B-55

Instruction Set

MSP430 Family

RRC[.W]
RRC.B

Syntax

Rotate right through carry
Rotate right through carry

RRC
RRC

dst
dst

or

RRC.W

dst

Operation

C -> MSB -> MSB-1 ....  LSB+1 -> LSB -> C

Description

The  destination  operand  is  shifted  right  one  position.  The  carry  C  is
shifted into the MSB, the LSB is shifted into the carry C.

word

15

C

byte

7

0

0

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Loaded from the LSB
V:  Set if initial destination is positive and initial Carry is set, otherwise

reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

R5 is shifted right one position. The MSB is loaded with 1.

SETC
RRC R5

; PREPARE CARRY FOR MSB
; R5/2 + 8000h -> R5

Example

R5 is shifted right one position. The MSB is loaded with 1.

SETC
RRC.B R5

; PREPARE CARRY FOR MSB
; R5/2 + 80h -> R5; Low byte of R5 is used

B

B-56

MSP430 Family

Instruction Set

* SBC[.W]
* SBC.B

Syntax

Operation

Emulation

Subtract borrow*) from destination
Subtract borrow*) from destination

SBC
SBC.B

dst  or SBC.W

dst

dst

dst + 0FFFFh + C -> dst
dst + 0FFh + C -> dst

SUBC
#0,dst
SUBC.B #0,dst

Description

The  carry  C  is  added  to  the  destination  operand  minus  one.  The
previous contents of the destination are lost.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Reset if dst was decremented from 0000 to 0FFFFh, set otherwise
Reset if dst was decremented from 00 to 0FFh, set otherwise

V:  Set if initially C=0 and dst=08000h
Set if initially C=0 and dst=080h

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The 16-bit counter pointed to by R13 is subtracted from a 32-bit counter
pointed to by R12.

SUB
SBC

@R13,0(R12)
2(R12)

; Subtract LSDs
; Subtract carry from MSD

Example

The  8bit  counter  pointed  to  by  R13  is  subtracted  from  a  16bit  counter
pointed to by R12.

SUB.B @R13,0(R12)
SBC.B

1(R12)

; Subtract LSDs
; Subtract carry from MSD

Note: Borrow is treated as a .NOT. carry

The borrow is treated as a .NOT. carry:   Borrow

   Yes
   No

Carry bit
       0
       1

B

B-57

Instruction Set

MSP430 Family

* SETC

Set carry bit

Syntax

Operation

SETC

1 -> C

Emulation

BIS

#1,SR

Description

The Carry Bit C is set, an operation which is often necessary.

Status Bits

N:  Not affected
Z:  Not affected
C:  Set
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

Emulation of the decimal subtraction:
Subtract R5 from R6 decimally
Assume that R5=3987 and R6=4137

DSUB

ADD

#6666h,R5

INV

R5

SETC
DADD

R5,R6

; Move content R5 from 0-9 to 6-0Fh
; R5 = 03987 + 6666 = 09FEDh
; Invert this(result back to 0-9)
; R5 = .NOT. R5 = 06012h
; Prepare carry = 1
; Emulate subtraction by adding of:
; (10000 - R5 - 1)
; R6 = R6 + R5 + 1
; R6 = 4137 + 06012 + 1 = 1 0150 = 0150

B

B-58

MSP430 Family

Instruction Set

* SETN

Syntax

Operation

Set Negative bit

SETN

1 -> N

Emulation

BIS

#4,SR

Description

The Negative bit N is set.

Status Bits

N:  Set
Z:  Not affected
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

B

B-59

Instruction Set

MSP430 Family

* SETZ

Syntax

Operation

Set Zero bit

SETZ

1 -> Z

Emulation

BIS

#2,SR

Description

The Zero bit Z is set.

Status Bits

N:  Not affected
Z:   Set
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

B

B-60

MSP430 Family

Instruction Set

SUB[.W]
SUB.B

Syntax

Operation

Description

Status Bits

subtract source from destination
subtract source from destination

SUB
SUB.B

src,dst

or SUB.W

src,dst

src,dst

dst + .NOT.src + 1 -> dst
or
[(dst - src -> dst)]

The source operand is subtracted from the destination operand. This is
made  by  adding  the  1's  complement  of  the  source  operand  and  the
constant 1. The source operand is not affected, the previous contents of
the destination are lost.

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Set if there is a carry from the MSB of the result, reset if not
      Set to 1 if no borrow, reset if borrow.
V:  Set if an arithmetic overflow occurs, otherwise reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

See example at the SBC instruction

Example

See example at the SBC.B instruction

Note: Borrow is treated as a .NOT. carry

The borrow is treated as a .NOT. carry:   Borrow

   Yes
   No

Carry bit
       0
       1

B

B-61

Instruction Set

MSP430 Family

SUBC[.W]SBB[.W]     subtract source and borrow/.NOT. carry from destination
SUBC.B,SBB.B
subtract source and borrow/.NOT. carry from destination

Syntax

Operation

Description

Status Bits

src,dst
SUBC
SBB
src,dst
SUBC.B src,dst

or SUBC.W src,dst
src,dst
or SBB.W
src,dst
or SBB.B

or

dst + .NOT.src + C -> dst
or
(dst - src - 1 + C -> dst)

The source operand is subtracted from the destination operand. This is
made  by  adding  of  the  1's  complement  of  the  source  operand  and  the
carry  C.  The  source  operand  is  not  affected,  the  previous  contents  of
the destination are lost.

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Set if there is a carry from the MSB of the result, reset if not
      Set to 1 if no borrow, reset if borrow.
V:  Set if an arithmetic overflow occurs, otherwise reset

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

Two floating point mantissas (24bits) are subtracted .
LSB's are in R13 resp. R10, MSB's are in R12 resp. R9.

SUB.W R13,R10
SUBC.B R12,R9

; 16bit part, LSB's
;   8bit part, MSB's

Example

The 16-bit counter pointed to by R13 is subtracted from a 16-bit counter
in R10 and R11(MSD).

@R13+,R10

SUB.B
SUBC.B @R13,R11
...

; Subtract LSDs without carry
; Subtract MSDs with carry
; resulting fron the LSDs

Note: Borrow is treated as a .NOT. carry

The borrow is treated as a .NOT. carry:   Borrow

   Yes
   No

Carry bit
       0
       1

B

B-62

MSP430 Family

Instruction Set

SWPB

Syntax

Swap bytes

SWPB

dst

Operation

bits 15 to 8 <-> bits 7 to 0

Description

The high and the low bytes of the destination operand are exchanged.

Status Bits

N:  Not affected
Z:   Not affected
C:  Not affected
V:  Not affected

Mode Bits

OscOff, CPUOff and GIE are not affected

15

8 7

0

Example

MOV #040BFh,R7
SWPB R7

; 0100000010111111 -> R7
; 1011111101000000 in R7

Example

The value in R5 is multiplied by 256. The result is stored in R5,R4

SWPB R5
MOV R5,R4
BIC
BIC

#0FF00h,R5
#00FFh,R4

;
;Copy the swapped value to R4
;Correct the result
;Correct the result

B

B-63

Instruction Set

MSP430 Family

SXT

Syntax

Extend Sign

SXT

dst

Operation

Bit 7 -> Bit 8 ......... Bit 15

Description

The sign of the Low byte is extended into the High byte.

Status Bits

N:  Set if result is negative, reset if positive
Z:  Set if result is zero, reset otherwise
C:  Set if result is not zero, reset otherwise (.NOT. Zero)
V:  Reset

Mode Bits

OscOff, CPUOff and GIE are not affected

15

8 7

0

Example

R7 is loaded with Timer/Counter value. The operation of the sign extend
instruction expands the bit8 to bit15 with the value of bit7.
R7 is added then to R6 where it is accumulated.

MOV.B &TCDAT,R7
R7
SXT
R7,R6
ADD

; TCDAT = 080h:  . . . .   . . . . 1000 0000
; R7 = 0FF80h:  1111 1111 1000 0000
; add value of EDE to 16bit ACCU

B

B-64

MSP430 Family

Instruction Set

* TST[.W]
* TST.B

Syntax

Operation

Emulation

Test destination
Test destination

TST
TST.B

dst
dst

dst + 0FFFFh + 1
dst + 0FFh + 1

CMP
#0,dst
CMP.B #0,dst

or

TST.W dst

Description

The  destination  operand  is  compared  to  zero.  The  status  bits  are  set
according to the result. The destination is not affected.

Status Bits

N:  Set if destination is negative, reset if positive
Z:  Set if destination contains zero, reset otherwise
C:  Set
V:  Reset.

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

R7 is tested.  If it is negative continue at R7NEG; if it is positive but not
zero continue at R7POS.

TST
JN
JZ

R7
R7NEG
R7ZERO

R7POS ......

R7NEG ......

R7ZERO ......

; Test R7
; R7 is negative
; R7 is zero
; R7 is positive but not zero

; R7 is negative

; R7 is zero

Example

Lowbyte  of  R7  is  tested.    If  it  is  negative  continue  at  R7NEG;  if  it  is
positive but not zero continue at R7POS.

TST.B R7
JN
JZ

R7NEG
R7ZERO

R7POS ......

R7NEG .....

R7ZERO ......

; Test Low byte of R7
; Low byte of R7 is negative
; Low byte of R7 is zero
; Low byte of R7 is positive but not zero

; Lowbyte of R7 is negative

; Lowbyte of R7 is zero

B

B-65

Instruction Set

MSP430 Family

XOR[.W]
XOR.B

Syntax

Exclusive OR of source with destination
Exclusive OR of source with destination

XOR src,dst
XOR.B

or

XOR.W

src,dst

src,dst

Operation

src .XOR. dst -> dst

Description

The source operand and the destination operand are OR'ed exclusively.
The  result  is  placed  into  the  destination.  The  source  operand  is  not
affected.

Status Bits

N:  Set if MSB of result is set, reset if not set
Z:  Set if result is zero, reset otherwise
C:  Set if result is not zero, reset otherwise ( = .NOT. Zero)
V:  Set if both operands are negative

Mode Bits

OscOff, CPUOff and GIE are not affected

Example

The bits set in R6 toggle the bits in the RAM word TONI.

XOR

R6,TONI

; Toggle bits of word TONI on the bits set in R6

Example

The bits set in R6 toggle the bits in the RAM byte TONI.

XOR.B R6,TONI

; Toggle bits in word TONI on bits
; set in Low byte of R6,

Example

Reset  bits  in  Lowbyte  of  R7  to  0  that  are  different  to  bits  in  RAM  byte
EDE.

XOR.B
INV.B

EDE,R7
R7

; Set different bit to '1s'
; Invert Lowbyte, Highbyte is 0h

B

B-66

MSP430 Family

Instruction Set

Macro instructions emulated with several instructions

The  following  table  shows  the  instructions  which  need  more  words  if  emulated  by  the
reduced instruction set. This is not of great concern, because they are rarely used. The
immediate values -1, 0, +1, 2, 4 and 8 are provided by the Constant Generator Registers
R2/CG1 and R3/CG2.

Emulated instruction

Instruction flow

Comment

ABS

dst

DSUB

src,dst

NEG

dst

RL

dst

RR

dst

L$1

L$0

TST
JN
...
...
...
INV
INC
JMP

ADD
INV
SETC
DADD

dst
L$0

dst
dst
L$1

; Absolute value of destination
; Destination is negative
; Destination is positive

; Convert negative destination
; to positive

#6666h,src
src

; Decimal subtraction
; Source is destroyed!

src,dst

; DST - SRC (dec)

INV
INC

dst
dst

ADD
ADDC

dst,dst
#0,dst

CLRC
RRC
JNC
BIS
...

L$1

dst
L$1
#8000h,dst

; Negation of destination

; Rotate left circularly

; Rotate right circularly

B

B-67

Instruction Set

MSP430 Family

B

B-68

