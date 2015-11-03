.include "m8def.inc"
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
	LDS @0,@1
.endm 
.equ SegmentPort=PortD
.equ ButtonStart=PinB0
.equ ButtonStop=PinB1
.equ ButtonDecMin=PinB2
.equ ButtonIncMin=PinB3
.equ Rele=PB4
.equ Beeper=PB5
.equ Cathode1=PB6
.equ Cathode2=PB7
.def SystemSettings=R29
.equ BeepEnable=1
.dseg
	Digit: .byte 2
	Count: .byte 1
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
	reti;rjmp ADC_ ; ADC Conversion Complete Handler
	reti;rjmp EE_RDY ; EEPROM Ready Handler
	reti;rjmp ANA_COMP ; Analog Comparator Handler
	reti;rjmp TWSI ; Two-wire Serial Interface Handler
	reti;rjmp SPM_RDY ;0b11101000

//-----------------------------------------------------------
StartProgram:
	;-----Init Stack-----
	OutTo SPL,Low (RAMEND)
    OutTo SPH,High(RAMEND)
	;---Init I/O Ports----
	OutTo DDRD, 0b11111111
	OutTo DDRB, 0b11110000
	OutTo PORTB,0b00001111
	OutTo TIMSK,0b00000001
	OutTo TCCR0,0b00000101
	OutTo TCCR1B,0b00000100
	;---------------------
	CLR R16
	STS Digit,R16
	STS Digit+1,R16
	STS Count,R16
	CLR R27
	CLR R28
	CLR R29
	;---------------------
	SEI
Main:	
	SBRC SystemSettings,0
	SBI PORTB,Beeper
	//Out digit to Segment1 
	OutTo SegmentPort,0
	CBI PortB,Cathode1
	LDS R19,Digit
	RCALL Decoder
	RCALL Delay
	SBI PortB,Cathode1
	//---------------------

	SBRC SystemSettings,0
	CBI PORTB,Beeper
	//Out digit to Segment1 
	OutTo SegmentPort,0
	CBI PortB,Cathode2
	LDS R19,Digit+1
	RCALL Decoder
	RCALL Delay
	SBI PortB,Cathode2
	//---------------------

rjmp Main

OnTimer0:
	ReadRAMTo R16,Count
	INC R16
	WriteRAM Count,R16
	CPI R16,0x10
	BRNE OutInterrupt
	SBRC R28,0
	RCALL IncBeepTime
	SBIS PINB,ButtonStop
	rcall OnClickStop
	SBIS PINB,ButtonStart
	rcall OnClickStart
	SBIS PINB,ButtonIncMin
	rcall OnClickIncMin
	SBIS PINB,ButtonDecMin
	rcall OnClickDecMin
	WriteRAMConst Count,0
  OutInterrupt:
 RETI

IncBeepTime:
	COM SystemSettings
	INC R27
	CPI R27,60
	BRNE OutModule
	CLR R27
	CLR R28	
	CLR R29
	CBI PORTB,Beeper
  OutModule:
 RET

OnTimer1:
	OutTo TCNT1L,0xEE
	OutTo TCNT1H,0x85
	INC R27
	CPI R27,60
	BRNE OutInterrupt
	CLR R27
	ReadRAMTo R16,Digit+1
	DEC R16
	WriteRAM Digit+1,R16
	RCALL NormalizeDigit
	ReadRAMTo R16,Digit+1
	ReadRAMTo R17,Digit
	ADD R16,R17
	CPI R16,0
	BRNE OutInterrupt
	OutTo TIMSK,0b00000001 
	CBI PORTB,Rele
	LDI SystemSettings,BeepEnable
	LDI R28,1
 RETI

OnClickStart:
	ReadRAMTo R16,Digit+1
	ReadRAMTo R17,Digit
	ADD R16,R17
	CPI R16,0
	BREQ OutInterrupt
	OutTo TIMSK,0b00000101
	SBI PORTB,Rele
 RET

OnClickStop:
	CBI PORTB,Beeper
	SBRC SystemSettings,0
	CLR SystemSettings
	SBRC R28,0
	CLR R28
	CBI PORTB,Rele
	IN R16,TIMSK
	SBRC R16,TOIE1
	RCALL ResetTime
 	OutTo TIMSK,0b00000001
 RET
ResetTime:
	WriteRamConst Digit,0
	WriteRamConst Digit+1,0
 RET

OnClickIncMin:
	IN R16,TIMSK
	SBRC R16,TOIE1
	RET
	LDS R16,Digit+1
	INC R16
	STS Digit+1,R16 
	RCALL NormalizeDigit
 RET

OnClickDecMin:
	IN R16,TIMSK
	SBRC R16,TOIE1
	RET
	LDS R16,Digit+1
	DEC R16
	STS Digit+1,R16 
	RCALL NormalizeDigit
 RET

Decoder:
	LDI ZL,Low(DcMatrix*2)  
	LDI ZH,High(DcMatrix*2)
	ADD ZL,R19
	LPM
	MOV R19,R0
	OUT SegmentPort,R19
 RET

Delay:
 	LDI  R30, $FF
WGLOOP4:  
	LDI  R31, $15
WGLOOP5:  
	DEC  R31
    BRNE WGLOOP5
    DEC  R30
    BRNE WGLOOP4
 RET

DcMatrix:
	.DB 0b00111111,0b00000110	;0,1
    .DB 0b01011011,0b01001111	;2,3
    .DB 0b01100110,0b01101101	;4,5
    .DB 0b01111101,0b00000111	;6,7
    .DB 0b01111111,0b01101111	;8,9

NormalizeDigit:
	ReadRAMTo R16,Digit+1
	ReadRAMTo R17,Digit  
	CPI R16,255
	BREQ DecTens
	CPI R16,10
	BREQ IncTens
	RJMP ExitModule
 DecTens:
    DEC R17
	LDI R16,9
	CPI R17,255
	BRNE ExitModule
	LDI R17,0
	LDI R16,0
    RJMP ExitModule
 IncTens:
    INC R17
	LDI R16,0
	CPI R17,10
	BRNE ExitModule
	LDI R17,9
	LDI R16,9
    RJMP ExitModule
ExitModule:
	STS Digit,R17
	STS Digit+1,R16
 RET



