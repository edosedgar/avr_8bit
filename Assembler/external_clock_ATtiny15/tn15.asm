.include "tn15def.inc"
.MACRO OutTo
	LDI R16,@1
	OUT @0,R16
.ENDM
.CSEG
.ORG 0
;========================================================
	RJMP SystemInit ; Reset handler
	RJMP EXT_INT0   ; IRQ0 handler
	RETI;RJMP PIN_CHANGE ; Pin change handler
 	RETI;RJMP TIM1_CMP ; Timer1 compare match
 	RETI;RJMP TIM1_OVF ; Timer1 overflow handler
 	RJMP TIM0_OVF ; Timer0 overflow handler
 	RETI;RJMP EE_RDY ; EEPROM Ready handler
 	RETI;RJMP ANA_COMP ; Analog Comparator handler
 	RETI;RJMP ADC_
;========================================================
SystemInit:
	;Setup external interrupt
	OutTo GIFR, 0b01000000
	OutTo MCUCR, 0b00000011
	OutTO GIMSK, 0b01000000
	;Setup timers
	OutTo TIMSK, 0b00000010
	OutTo TCCR0, 0b00000110
	;Setup ports I/O
	OutTo DDRB,0b00011011
	OutTo PortB, 0b00000100	
	CLR R17
	SEI
	RJMP Main
;========================================================
Main:
	
	RJMP Main
;========================================================
TIM0_OVF:
	SBIC PortB,1
	RJMP SetLed
	SBI PortB,1
	RETI
SetLed:
	CBI PortB,1
	RETI
;========================================================
EXT_INT0:
	INC R17
	CPI R17,1
	BREQ Step1
	CPI R17,2
	BREQ Step2
	CPI R17,3
	BREQ Step3	
	CPI R17,4
	BREQ Step4
	CPI R17,5
	BREQ Step5
	CPI R17,6
	BREQ Step6
	RETI
Step1:
	SBI PortB,0
	CBI PortB,4
	CBI PortB,3
	RETI

Step2:
	SBI PortB,0
	SBI PortB,4
	CBI PortB,3
	RETI

Step3:
	CBI PortB,0
	SBI PortB,4
	CBI PortB,3
	RETI
Step4:
	CBI PortB,0
	SBI PortB,4
	SBI PortB,3
	RETI

Step5:
	CBI PortB,0
	CBI PortB,4
	SBI PortB,3
	RETI

Step6:
	SBI PortB,0
	CBI PortB,4
	SBI PortB,3
	CLR R17
	RETI
