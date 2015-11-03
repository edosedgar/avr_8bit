.include "m8def.inc"
//--------------------Macros---------------------
.macro OutTo
	ldi R16,@1
	out @0,R16
.endm
.macro WriteRAM
	STS @0,@1
.endm	
.macro WriteRAMConst
	LDI R16,@1
	STS @0,R16
.endm
.macro ReadRAMTo
	LDS @1,@0
.endm 
//-----------------------------------------------
.equ Siren        =PortB0
.equ CatodLeds9_16=PortB1
.equ CatodLeds1_8 =PortB2
.equ LedsPort     =PortD
//-----------Reserved place in RAM---------------
.dseg
	StatusLeds1_8          : .byte 1
	StatusLeds9_16         : .byte 1
	StatusSiren            : .byte 1
	StatusDetectorDoor1_8  : .byte 1
	StatusDetectorDoor9_13 : .byte 1
	StatusDetectorMove1_3  : .byte 1
	IsReset                : .byte 1
//-----------------------------------------------
.cseg
.org 0
//--------------Interrupt vector---------------------------

	RJMP StartProgram ; Reset Handler
	reti;rjmp EXT_INT0 ; IRQ0 Handler
	reti;rjmp EXT_INT1 ; IRQ1 Handler
	reti;rjmp TIM2_COMP ; Timer2 Compare Handler
	reti;rjmp TIM2_OVF ; Timer2 Overflow Handler
	reti;rjmp TIM1_CAPT ; Timer1 Capture Handler
	reti;rjmp TIM1_COMPA ; Timer1 Compare A Handler
	reti;rjmp TIM1_COMPB ; Timer1 Compare B Handler
	RJMP OnTimer1 ; Timer1 Overflow Handler
	RJMP OnTimer0 ; Timer0 Overflow Handler
	reti;rjmp SPI_STC ; SPI Transfer Complete Handler
	reti;rjmp USART_RXC ; USART RX Complete Handler
	reti;rjmp USART_UDRE ; UDR Empty Handler
	reti;rjmp USART_TXC ; USART TX Complete Handler
	RJMP OnADC ; ADC Conversion Complete Handler
	reti;rjmp EE_RDY ; EEPROM Ready Handler
	reti;rjmp ANA_COMP ; Analog Comparator Handler
	reti;rjmp TWSI ; Two-wire Serial Interface Handler
	reti;rjmp SPM_RDY ;0b11101000

//-----------------------------------------------------------
StartProgram:
	;-----Init Stack------
	OutTo SPL,Low (RAMEND)
    OutTo SPH,High(RAMEND)
	;---Init I/O Ports----
	OutTo DDRD, 0b11111111
	OutTo DDRB, 0b00000111
	OutTo DDRC, 0b00000000
	OutTo PortC,0b00011110	
	;-Init Timers and ADC-
	OutTo TIMSK,0b00000001
	OutTo TCCR0,0b00000101
	OutTo TCCR1B,0b00000100
	OutTo ADMUX,0b00100000
	OutTo ADCSRA,0b10101111
	;ADC Start
	SBI ADCSRA,ADSC
	;Init variables
	WriteRAMConst StatusLeds1_8,0         
	WriteRAMConst StatusLeds9_16,0
	WriteRAMConst StatusDetectorDoor1_8,0
	WriteRAMConst StatusDetectorDoor9_13,0
	WriteRAMConst StatusDetectorMove1_3,0
	WriteRAMConst IsReset,0
	;---------------------               
	SEI
Main:
	ReadRAMTo IsRESET,R25	
	CPI R25,1
	BREQ ResetSystem
	ReadRAMTo StatusDetectorDoor1_8,R24
	WriteRAM StatusLeds1_8,R24 		
	ReadRAMTo StatusDetectorDoor9_13,R25
	ReadRAMTo StatusDetectorMove1_3,R26
	LSL R26
	LSL R26
	LSL R26
	LSL R26
	LSL R26
	ADD R25,R26
	WriteRAM StatusLeds9_16,R25
	ADD R24,R25
	CPI R24,0
	BRNE SirenOn
	CBI PORTB,Siren
RJMP Main
;----------------------------------------------------------------
ResetSystem:
	OutTo PORTB,0
	OutTo PORTD,0
	WriteRAMConst StatusLeds1_8,0         
	WriteRAMConst StatusLeds9_16,0
	WriteRAMConst StatusDetectorDoor1_8,0
	WriteRAMConst StatusDetectorDoor9_13,0
	WriteRAMConst StatusDetectorMove1_3,0
	WriteRAMConst IsReset,0
	RJMP Main
SirenOn:
	SBI PORTB,Siren
	RJMP Main
;---------------------------Timer0-------------------------------
OnTimer0:
	;Choose leds column (e.g. 1 or 2)+
	COM R17
	CPI R17,255
	BREQ OnLeds1_8
	CPI R17,0
	BREQ OnLeds9_16
	;--------------------------------+
RETI
OnLeds1_8:
	;Chose 1 column for show StatusLeds1_8+
	CBI PortB,CatodLeds9_16
	SBI PortB,CatodLeds1_8
	ReadRAMTo StatusLeds1_8,R16
	OUT LedsPort,R16	
	;-------------------------------------+
RETI

OnLeds9_16:
	;Chose 1 column for show StatusLeds9_16+
	CBI PortB,CatodLeds1_8
	SBI PortB,CatodLeds9_16
	ReadRAMTo StatusLeds9_16,R16
	OUT LedsPort,R16
	;--------------------------------------+
RETi
;----------------------------------------------------------------
;---------------------------Timer1-------------------------------
OnTimer1:
	;Write status movement detector in StatusDetectorMove1_3+
	IN R16,PinC
	COM R16
	LDI R18,0b00011100
	AND R16,R18
	LSR R16
	LSR R16
	WriteRAM StatusDetectorMove1_3,R16
	;-------------------------------------------------------+
	;Check pressing Reset+
	IN R16,Pinc
	COM R16  
	LDI R18,0b00000010
	AND R16,R18
	LSR R16
	WriteRAM IsReset,R16
	;--------------------+		
RETI
;----------------------------ADC---------------------------------
OnADC:
	IN R16,ADCH	
	;----------------------------------
	LDI R19,229
	LDI R20,242
	LDI R21,0
	IdentificationNumberInterval:
		INC R21
		CP R16,R19
		BRSH Compare2
	ContinueCompare:
		LDI R22,18
		SUB R19,R22
		SUB R20,R22
		CPI R21,13
		BRNE IdentificationNumberInterval
	WriteRAMConst StatusDetectorDoor1_8,0
	WriteRAMConst StatusDetectorDoor9_13,0		
	;----------------------------------
	;ADC Start
Exit:
	SBI ADCSRA,ADSC
RETI
Compare2:
	CP R16,R20
	BRLO GiveNumberButton
	RJMP ContinueCompare
GiveNumberButton:
	;In R21 found number pressing button
	CPI R21,1
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b00000001
	RJMP Exit
Next1:
	CPI R21,2
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b00000010
	RJMP Exit
Next2:
	CPI R21,3
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b00000100
	RJMP Exit
Next3:
	CPI R21,4
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b00001000
	RJMP Exit
Next4:
	CPI R21,5
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b00010000
	RJMP Exit
Next5:
	CPI R21,6
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b00100000
	RJMP Exit
Next6:
	CPI R21,7
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b01000000
	RJMP Exit
Next7:
	CPI R21,8
	BRNE Next1
	WriteRAMConst StatusDetectorDoor1_8,0b10000000
	RJMP Exit
Next8:
	CPI R21,9
	BRNE Next1
	WriteRAMConst StatusDetectorDoor9_13,0b00000001
	RJMP Exit
Next9:
	CPI R21,10
	BRNE Next1
	WriteRAMConst StatusDetectorDoor9_13,0b00000010
	RJMP Exit
Next10:
	CPI R21,11
	BRNE Next1
	WriteRAMConst StatusDetectorDoor9_13,0b00000100
	RJMP Exit
Next11:
	CPI R21,12
	BRNE Next1
	WriteRAMConst StatusDetectorDoor9_13,0b00001000
	RJMP Exit
Next12:
	WriteRAMConst StatusDetectorDoor9_13,0b00010000
	RJMP Exit
;----------------------------------------------------------------


	
