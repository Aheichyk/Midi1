
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _send_count=R4
	.DEF _send_count_msb=R5
	.DEF _first_on=R7
	.DEF _cnt=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x1


__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Declare your global variables here
;
;// USART Transmitter buffer
;unsigned char tx_buffer[3];
;
;unsigned int send_count=0;
;unsigned char tmp[31];
;unsigned char first_on = 1;
;unsigned char cnt = 0;
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0010 {

	.CSEG
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0011     send_count++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0012 
; 0000 0013     if (send_count < 3) {
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x3
; 0000 0014         UDR = tx_buffer[send_count];
	LDI  R26,LOW(_tx_buffer)
	LDI  R27,HIGH(_tx_buffer)
	ADD  R26,R4
	ADC  R27,R5
	LD   R30,X
	OUT  0xC,R30
; 0000 0015     } else {
	RJMP _0x4
_0x3:
; 0000 0016         send_count = 0;
	CLR  R4
	CLR  R5
; 0000 0017     }
_0x4:
; 0000 0018 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;void send_key(unsigned char num, unsigned char input)
; 0000 001B {
_send_key:
; .FSTART _send_key
; 0000 001C     if (first_on) {
	ST   -Y,R26
;	num -> Y+1
;	input -> Y+0
	TST  R7
	BRNE _0x2000001
; 0000 001D         return;
; 0000 001E     }
; 0000 001F     //Wait end of transmit
; 0000 0020     while (!(UCSRA&(1<<UDRE)));
_0x6:
	SBIS 0xB,5
	RJMP _0x6
; 0000 0021 
; 0000 0022     if (!input) {
	LD   R30,Y
	CPI  R30,0
	BRNE _0x9
; 0000 0023         tx_buffer[0] = 0x90;
	LDI  R30,LOW(144)
	RCALL SUBOPT_0x0
; 0000 0024         tx_buffer[1] = num;
; 0000 0025         tx_buffer[2] = 0x60;
	LDI  R30,LOW(96)
	RJMP _0x55
; 0000 0026     } else {
_0x9:
; 0000 0027         tx_buffer[0] = 0x80;
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x0
; 0000 0028         tx_buffer[1] = num;
; 0000 0029         tx_buffer[2] = 0x00;
	LDI  R30,LOW(0)
_0x55:
	__PUTB1MN _tx_buffer,2
; 0000 002A     }
; 0000 002B 
; 0000 002C     send_count = 0;
	CLR  R4
	CLR  R5
; 0000 002D     UDR = tx_buffer[0];
	LDS  R30,_tx_buffer
	OUT  0xC,R30
; 0000 002E }
_0x2000001:
	ADIW R28,2
	RET
; .FEND
;
;void main(void)
; 0000 0031 {
_main:
; .FSTART _main
; 0000 0032 // Declare your local variables here
; 0000 0033 
; 0000 0034 // Input/Output Ports initialization
; 0000 0035 // Port B initialization
; 0000 0036 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0037 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0038 // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 0039 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	OUT  0x18,R30
; 0000 003A 
; 0000 003B // Port C initialization
; 0000 003C // Function: Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003D DDRC=(1<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(64)
	OUT  0x14,R30
; 0000 003E // State: Bit6=0 Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 003F PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 0040 
; 0000 0041 // Port D initialization
; 0000 0042 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0043 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0044 
; 0000 0045 // USART initialization
; 0000 0046 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0047 // USART Receiver: Off
; 0000 0048 // USART Transmitter: On
; 0000 0049 // USART Mode: Asynchronous
; 0000 004A // USART Baud Rate: 31250
; 0000 004B UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 004C UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(72)
	OUT  0xA,R30
; 0000 004D UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 004E UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 004F UBRRL=0x0F;
	LDI  R30,LOW(15)
	OUT  0x9,R30
; 0000 0050 
; 0000 0051 
; 0000 0052 
; 0000 0053 // Global enable interrupts
; 0000 0054 #asm("sei")
	sei
; 0000 0055 
; 0000 0056 while (1)
_0xB:
; 0000 0057       {
; 0000 0058       // Place your code here
; 0000 0059       if (cnt == 0) {
	TST  R6
	BRNE _0xE
; 0000 005A           PORTB = 0xFD;
	LDI  R30,LOW(253)
	RCALL SUBOPT_0x1
; 0000 005B           if (PINC.0 != tmp[0]) { delay_ms(1); if (PINC.0 != tmp[0]) {send_key(24,PINC.0); tmp[0] = PINC.0; }}
	RCALL SUBOPT_0x2
	BREQ _0xF
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x2
	BREQ _0x10
	LDI  R30,LOW(24)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	STS  _tmp,R30
_0x10:
; 0000 005C           if (PINC.1 != tmp[1]) { delay_ms(1); if (PINC.1 != tmp[1]) {send_key(25,PINC.1); tmp[1] = PINC.1; }}
_0xF:
	RCALL SUBOPT_0x7
	BREQ _0x11
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x7
	BREQ _0x12
	LDI  R30,LOW(25)
	RCALL SUBOPT_0x8
	__PUTB1MN _tmp,1
_0x12:
; 0000 005D           if (PINC.2 != tmp[2]) { delay_ms(1); if (PINC.2 != tmp[2]) {send_key(26,PINC.2); tmp[2] = PINC.2; }}
_0x11:
	RCALL SUBOPT_0x9
	BREQ _0x13
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x9
	BREQ _0x14
	LDI  R30,LOW(26)
	RCALL SUBOPT_0xA
	__PUTB1MN _tmp,2
_0x14:
; 0000 005E           if (PINC.3 != tmp[3]) { delay_ms(1); if (PINC.3 != tmp[3]) {send_key(27,PINC.3); tmp[3] = PINC.3; }}
_0x13:
	RCALL SUBOPT_0xB
	BREQ _0x15
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xB
	BREQ _0x16
	LDI  R30,LOW(27)
	RCALL SUBOPT_0xC
	__PUTB1MN _tmp,3
_0x16:
; 0000 005F           if (PINC.4 != tmp[4]) { delay_ms(1); if (PINC.4 != tmp[4]) {send_key(28,PINC.4); tmp[4] = PINC.4; }}
_0x15:
	RCALL SUBOPT_0xD
	BREQ _0x17
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xD
	BREQ _0x18
	LDI  R30,LOW(28)
	RCALL SUBOPT_0xE
	__PUTB1MN _tmp,4
_0x18:
; 0000 0060           if (PINC.5 != tmp[5]) { delay_ms(1); if (PINC.5 != tmp[5]) {send_key(29,PINC.5); tmp[5] = PINC.5; }}
_0x17:
	RCALL SUBOPT_0xF
	BREQ _0x19
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xF
	BREQ _0x1A
	LDI  R30,LOW(29)
	RCALL SUBOPT_0x10
	__PUTB1MN _tmp,5
_0x1A:
; 0000 0061       } else if (cnt == 1) {
_0x19:
	RJMP _0x1B
_0xE:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x1C
; 0000 0062           PORTB = 0xFB;
	LDI  R30,LOW(251)
	RCALL SUBOPT_0x1
; 0000 0063           if (PINC.0 != tmp[6]) { delay_ms(1); if (PINC.0 != tmp[6]) {send_key(30,PINC.0); tmp[6] = PINC.0; }}
	RCALL SUBOPT_0x11
	BREQ _0x1D
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x11
	BREQ _0x1E
	LDI  R30,LOW(30)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	__PUTB1MN _tmp,6
_0x1E:
; 0000 0064           if (PINC.1 != tmp[7]) { delay_ms(1); if (PINC.1 != tmp[7]) {send_key(31,PINC.1); tmp[7] = PINC.1; }}
_0x1D:
	RCALL SUBOPT_0x12
	BREQ _0x1F
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x12
	BREQ _0x20
	LDI  R30,LOW(31)
	RCALL SUBOPT_0x8
	__PUTB1MN _tmp,7
_0x20:
; 0000 0065           if (PINC.2 != tmp[8]) { delay_ms(1); if (PINC.2 != tmp[8]) {send_key(32,PINC.2); tmp[8] = PINC.2; }}
_0x1F:
	RCALL SUBOPT_0x13
	BREQ _0x21
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x13
	BREQ _0x22
	LDI  R30,LOW(32)
	RCALL SUBOPT_0xA
	__PUTB1MN _tmp,8
_0x22:
; 0000 0066           if (PINC.3 != tmp[9]) { delay_ms(1); if (PINC.3 != tmp[9]) {send_key(33,PINC.3); tmp[9] = PINC.3; }}
_0x21:
	RCALL SUBOPT_0x14
	BREQ _0x23
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x14
	BREQ _0x24
	LDI  R30,LOW(33)
	RCALL SUBOPT_0xC
	__PUTB1MN _tmp,9
_0x24:
; 0000 0067           if (PINC.4 != tmp[10]) { delay_ms(1); if (PINC.4 != tmp[10]) {send_key(34,PINC.4); tmp[10] = PINC.4; }}
_0x23:
	RCALL SUBOPT_0x15
	BREQ _0x25
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x15
	BREQ _0x26
	LDI  R30,LOW(34)
	RCALL SUBOPT_0xE
	__PUTB1MN _tmp,10
_0x26:
; 0000 0068           if (PINC.5 != tmp[11]) { delay_ms(1); if (PINC.5 != tmp[11]) {send_key(35,PINC.5); tmp[11] = PINC.5; }}
_0x25:
	RCALL SUBOPT_0x16
	BREQ _0x27
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x16
	BREQ _0x28
	LDI  R30,LOW(35)
	RCALL SUBOPT_0x10
	__PUTB1MN _tmp,11
_0x28:
; 0000 0069       } else if (cnt == 2) {
_0x27:
	RJMP _0x29
_0x1C:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x2A
; 0000 006A           PORTB = 0xF7;
	LDI  R30,LOW(247)
	RCALL SUBOPT_0x1
; 0000 006B           if (PINC.0 != tmp[12]) { delay_ms(1); if (PINC.0 != tmp[12]) {send_key(36,PINC.0); tmp[12] = PINC.0; }}
	RCALL SUBOPT_0x17
	BREQ _0x2B
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x17
	BREQ _0x2C
	LDI  R30,LOW(36)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	__PUTB1MN _tmp,12
_0x2C:
; 0000 006C           if (PINC.1 != tmp[13]) { delay_ms(1); if (PINC.1 != tmp[13]) {send_key(37,PINC.1); tmp[13] = PINC.1; }}
_0x2B:
	RCALL SUBOPT_0x18
	BREQ _0x2D
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x18
	BREQ _0x2E
	LDI  R30,LOW(37)
	RCALL SUBOPT_0x8
	__PUTB1MN _tmp,13
_0x2E:
; 0000 006D           if (PINC.2 != tmp[14]) { delay_ms(1); if (PINC.2 != tmp[14]) {send_key(38,PINC.2); tmp[14] = PINC.2; }}
_0x2D:
	RCALL SUBOPT_0x19
	BREQ _0x2F
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x19
	BREQ _0x30
	LDI  R30,LOW(38)
	RCALL SUBOPT_0xA
	__PUTB1MN _tmp,14
_0x30:
; 0000 006E           if (PINC.3 != tmp[15]) { delay_ms(1); if (PINC.3 != tmp[15]) {send_key(39,PINC.3); tmp[15] = PINC.3; }}
_0x2F:
	RCALL SUBOPT_0x1A
	BREQ _0x31
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1A
	BREQ _0x32
	LDI  R30,LOW(39)
	RCALL SUBOPT_0xC
	__PUTB1MN _tmp,15
_0x32:
; 0000 006F           if (PINC.4 != tmp[16]) { delay_ms(1); if (PINC.4 != tmp[16]) {send_key(40,PINC.4); tmp[16] = PINC.4; }}
_0x31:
	RCALL SUBOPT_0x1B
	BREQ _0x33
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1B
	BREQ _0x34
	LDI  R30,LOW(40)
	RCALL SUBOPT_0xE
	__PUTB1MN _tmp,16
_0x34:
; 0000 0070           if (PINC.5 != tmp[17]) { delay_ms(1); if (PINC.5 != tmp[17]) {send_key(41,PINC.5); tmp[17] = PINC.5; }}
_0x33:
	RCALL SUBOPT_0x1C
	BREQ _0x35
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1C
	BREQ _0x36
	LDI  R30,LOW(41)
	RCALL SUBOPT_0x10
	__PUTB1MN _tmp,17
_0x36:
; 0000 0071       } else if (cnt == 3) {
_0x35:
	RJMP _0x37
_0x2A:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x38
; 0000 0072           PORTB = 0xEF;
	LDI  R30,LOW(239)
	RCALL SUBOPT_0x1
; 0000 0073           if (PINC.0 != tmp[18]) { delay_ms(1); if (PINC.0 != tmp[18]) {send_key(42,PINC.0); tmp[18] = PINC.0; }}
	RCALL SUBOPT_0x1D
	BREQ _0x39
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x1D
	BREQ _0x3A
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	__PUTB1MN _tmp,18
_0x3A:
; 0000 0074           if (PINC.1 != tmp[19]) { delay_ms(1); if (PINC.1 != tmp[19]) {send_key(43,PINC.1); tmp[19] = PINC.1; }}
_0x39:
	RCALL SUBOPT_0x1E
	BREQ _0x3B
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1E
	BREQ _0x3C
	LDI  R30,LOW(43)
	RCALL SUBOPT_0x8
	__PUTB1MN _tmp,19
_0x3C:
; 0000 0075           if (PINC.2 != tmp[20]) { delay_ms(1); if (PINC.2 != tmp[20]) {send_key(44,PINC.2); tmp[20] = PINC.2; }}
_0x3B:
	RCALL SUBOPT_0x1F
	BREQ _0x3D
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1F
	BREQ _0x3E
	LDI  R30,LOW(44)
	RCALL SUBOPT_0xA
	__PUTB1MN _tmp,20
_0x3E:
; 0000 0076           if (PINC.3 != tmp[21]) { delay_ms(1); if (PINC.3 != tmp[21]) {send_key(45,PINC.3); tmp[21] = PINC.3; }}
_0x3D:
	RCALL SUBOPT_0x20
	BREQ _0x3F
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x20
	BREQ _0x40
	LDI  R30,LOW(45)
	RCALL SUBOPT_0xC
	__PUTB1MN _tmp,21
_0x40:
; 0000 0077           if (PINC.4 != tmp[22]) { delay_ms(1); if (PINC.4 != tmp[22]) {send_key(46,PINC.4); tmp[22] = PINC.4; }}
_0x3F:
	RCALL SUBOPT_0x21
	BREQ _0x41
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x21
	BREQ _0x42
	LDI  R30,LOW(46)
	RCALL SUBOPT_0xE
	__PUTB1MN _tmp,22
_0x42:
; 0000 0078           if (PINC.5 != tmp[23]) { delay_ms(1); if (PINC.5 != tmp[23]) {send_key(47,PINC.5); tmp[23] = PINC.5; }}
_0x41:
	RCALL SUBOPT_0x22
	BREQ _0x43
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x22
	BREQ _0x44
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x10
	__PUTB1MN _tmp,23
_0x44:
; 0000 0079       } else if (cnt == 4) {
_0x43:
	RJMP _0x45
_0x38:
	LDI  R30,LOW(4)
	CP   R30,R6
	BRNE _0x46
; 0000 007A           PORTB = 0xDF;
	LDI  R30,LOW(223)
	RCALL SUBOPT_0x1
; 0000 007B           if (PINC.0 != tmp[24]) { delay_ms(1); if (PINC.0 != tmp[24]) {send_key(48,PINC.0); tmp[24] = PINC.0; }}
	RCALL SUBOPT_0x23
	BREQ _0x47
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x23
	BREQ _0x48
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	__PUTB1MN _tmp,24
_0x48:
; 0000 007C           if (PINC.1 != tmp[25]) { delay_ms(1); if (PINC.1 != tmp[25]) {send_key(49,PINC.1); tmp[25] = PINC.1; }}
_0x47:
	RCALL SUBOPT_0x24
	BREQ _0x49
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x24
	BREQ _0x4A
	LDI  R30,LOW(49)
	RCALL SUBOPT_0x8
	__PUTB1MN _tmp,25
_0x4A:
; 0000 007D           if (PINC.2 != tmp[26]) { delay_ms(1); if (PINC.2 != tmp[26]) {send_key(50,PINC.2); tmp[26] = PINC.2; }}
_0x49:
	RCALL SUBOPT_0x25
	BREQ _0x4B
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x25
	BREQ _0x4C
	LDI  R30,LOW(50)
	RCALL SUBOPT_0xA
	__PUTB1MN _tmp,26
_0x4C:
; 0000 007E           if (PINC.3 != tmp[27]) { delay_ms(1); if (PINC.3 != tmp[27]) {send_key(51,PINC.3); tmp[27] = PINC.3; }}
_0x4B:
	RCALL SUBOPT_0x26
	BREQ _0x4D
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x26
	BREQ _0x4E
	LDI  R30,LOW(51)
	RCALL SUBOPT_0xC
	__PUTB1MN _tmp,27
_0x4E:
; 0000 007F           if (PINC.4 != tmp[28]) { delay_ms(1); if (PINC.4 != tmp[28]) {send_key(52,PINC.4); tmp[28] = PINC.4; }}
_0x4D:
	RCALL SUBOPT_0x27
	BREQ _0x4F
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x27
	BREQ _0x50
	LDI  R30,LOW(52)
	RCALL SUBOPT_0xE
	__PUTB1MN _tmp,28
_0x50:
; 0000 0080           if (PINC.5 != tmp[29]) { delay_ms(1); if (PINC.5 != tmp[29]) {send_key(53,PINC.5); tmp[29] = PINC.5; }}
_0x4F:
	RCALL SUBOPT_0x28
	BREQ _0x51
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x28
	BREQ _0x52
	LDI  R30,LOW(53)
	RCALL SUBOPT_0x10
	__PUTB1MN _tmp,29
_0x52:
; 0000 0081           first_on = 0;
_0x51:
	CLR  R7
; 0000 0082       }
; 0000 0083       cnt++;
_0x46:
_0x45:
_0x37:
_0x29:
_0x1B:
	INC  R6
; 0000 0084       if (cnt > 4) {
	LDI  R30,LOW(4)
	CP   R30,R6
	BRSH _0x53
; 0000 0085         cnt = 0;
	CLR  R6
; 0000 0086       }
; 0000 0087       }
_0x53:
	RJMP _0xB
; 0000 0088 }
_0x54:
	RJMP _0x54
; .FEND

	.DSEG
_tx_buffer:
	.BYTE 0x3
_tmp:
	.BYTE 0x1F

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	STS  _tx_buffer,R30
	LDD  R30,Y+1
	__PUTB1MN _tx_buffer,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	OUT  0x18,R30
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDS  R30,_tmp
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:56 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	RCALL _send_key
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x7:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	__GETB1MN _tmp,1
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	RCALL _send_key
	LDI  R30,0
	SBIC 0x13,1
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	__GETB1MN _tmp,2
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	RCALL _send_key
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	__GETB1MN _tmp,3
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	RCALL _send_key
	LDI  R30,0
	SBIC 0x13,3
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	__GETB1MN _tmp,4
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	RCALL _send_key
	LDI  R30,0
	SBIC 0x13,4
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xF:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	__GETB1MN _tmp,5
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x10:
	ST   -Y,R30
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	RCALL _send_key
	LDI  R30,0
	SBIC 0x13,5
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__GETB1MN _tmp,6
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	__GETB1MN _tmp,7
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	__GETB1MN _tmp,8
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	__GETB1MN _tmp,9
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	__GETB1MN _tmp,10
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x16:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	__GETB1MN _tmp,11
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__GETB1MN _tmp,12
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	__GETB1MN _tmp,13
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	__GETB1MN _tmp,14
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1A:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	__GETB1MN _tmp,15
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	__GETB1MN _tmp,16
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1C:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	__GETB1MN _tmp,17
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	__GETB1MN _tmp,18
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1E:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	__GETB1MN _tmp,19
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1F:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	__GETB1MN _tmp,20
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x20:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	__GETB1MN _tmp,21
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x21:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	__GETB1MN _tmp,22
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x22:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	__GETB1MN _tmp,23
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	__GETB1MN _tmp,24
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x24:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	__GETB1MN _tmp,25
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x25:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	__GETB1MN _tmp,26
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x26:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	__GETB1MN _tmp,27
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x27:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	__GETB1MN _tmp,28
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x28:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	__GETB1MN _tmp,29
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE: