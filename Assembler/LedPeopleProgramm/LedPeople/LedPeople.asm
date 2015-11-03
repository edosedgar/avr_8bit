.include "m8def.inc"
.macro OutTo
	ldi R31,@1
	out @0,R31
.endm
//------------------
.macro LedRed
	OutTo DDRB,0
	OutTo PORTB,0
	OutTo DDRD,0
	OutTo PORTD,0
	SBI DDRB,@0
	SBI PORTB,@0
	SBI DDRD,@1
	CBI PORTD,@1
	rcall Delay500ms
.endm
.macro LedGreen
	OutTo DDRB,0
	OutTo PORTB,0
	OutTo DDRD,0
	OutTo PORTD,0
	SBI DDRB,@0
	CBI PORTB,@0
	SBI DDRD,@1
	SBI PORTD,@1
	rcall Delay500ms
.endm
.macro AllLedsOFF
	OutTo DDRB,0
	OutTo PORTB,0
	OutTo DDRD,0
	OutTo PORTD,0
.endm
//------------------
.equ Leg=1
.equ Body=0
.equ Hand=2
.equ Head=3
.equ Led1=PD0
.equ Led2=PD1
.equ Led3=PD2
.equ Led4=PD3
.equ Led5=PD4
.equ Led6=PD5
.equ Led7=PD6
.equ Led8=PD7
.equ HandButton=PINC2
.equ BodyButton=PINC1
.equ LegButton =PINC0
.org 0
//--------------Interrupt vector---------------------------

	rjmp StartProgram ; Reset Handler
	RETI;rjmp EXT_INT0 ; IRQ0 Handler
	RETI;rjmp EXT_INT1 ; IRQ1 Handler
	RETI;rjmp TIM2_COMP ; Timer2 Compare Handler
	RETI;rjmp TIM2_OVF ; Timer2 Overflow Handler
	RETI;rjmp TIM1_CAPT ; Timer1 Capture Handler
	RETI;rjmp TIM1_COMPA ; Timer1 Compare A Handler
	RETI;rjmp TIM1_COMPB ; Timer1 Compare B Handler
	RETI;rjmp OnTimer1 ; Timer1 Overflow Handler
	RETI;rjmp OnTimer0 ; Timer0 Overflow Handler
	RETI;rjmp SPI_STC ; SPI Transfer Complete Handler
	RETI;rjmp USART_RXC ; USART RX Complete Handler
	RETI;rjmp USART_UDRE ; UDR Empty Handler
	RETI;rjmp USART_TXC ; USART TX Complete Handler
	RETI;rjmp ADC_ ; ADC Conversion Complete Handler
	RETI;rjmp EE_RDY ; EEPROM Ready Handler
	RETI;rjmp ANA_COMP ; Analog Comparator Handler
	RETI;rjmp TWSI ; Two-wire Serial Interface Handler
	RETI;rjmp SPM_RDY ;0b11101000

//-----------------------------------------------------------
StartProgram:
	;-----Init Stack-----
	OutTo SPL,Low (RAMEND)
    OutTo SPH,High(RAMEND)
	;---Init I/O Ports----
	OutTo DDRC, 0b00000000
	OutTo PORTC,0b00000111
	;---------------------
Main:
	SBIS PINC,LegButton
	rcall ClickOnLeg
	SBIS PINC,BodyButton
	rcall ClickOnBody
	SBIS PINC,HandButton
	rcall ClickOnHand
rjmp Main


ClickOnLeg:
	LedRed Leg,Led1
	LedRed Leg,Led2
	LedRed Leg,Led3
	LedRed Leg,Led4
	LedRed Leg,Led5
	LedRed Leg,Led6
	LedRed Leg,Led7
	LedRed Leg,Led8

	LedRed Body,Led1
	LedRed Body,Led2
	LedRed Body,Led3
	LedRed Body,Led4
	LedRed Body,Led5
	LedRed Body,Led6
	LedRed Body,Led7
	LedRed Body,Led8
	AllLedsOFF
	rcall BrainHandlerSignal
	LedRed Body,Led8
	LedRed Body,Led7
	LedRed Body,Led6
	LedRed Body,Led5
	LedRed Body,Led4
	LedRed Body,Led3
	LedRed Body,Led2
	LedRed Body,Led1	

	LedRed Leg,Led8
	LedRed Leg,Led7
	LedRed Leg,Led6
	LedRed Leg,Led5
	LedRed Leg,Led4
	LedRed Leg,Led3
	LedRed Leg,Led2
	LedRed Leg,Led1
	AllLedsOFF
  RET

ClickOnBody:
	LedRed Body,Led1
	LedRed Body,Led2
	LedRed Body,Led3
	LedRed Body,Led4
	LedRed Body,Led5
	LedRed Body,Led6
	LedRed Body,Led7
	LedRed Body,Led8
	AllLedsOFF
	rcall BrainHandlerSignal
	LedRed Body,Led8
	LedRed Body,Led7
	LedRed Body,Led6
	LedRed Body,Led5
	LedRed Body,Led4
	LedRed Body,Led3
	LedRed Body,Led2
	LedRed Body,Led1
	AllLedsOFF
  RET

ClickOnHand:
	LedRed Hand,Led1
	LedRed Hand,Led2
	LedRed Hand,Led3
	LedRed Hand,Led4
	LedRed Hand,Led5
	LedRed Hand,Led6
	LedRed Hand,Led7
	LedRed Hand,Led8

	LedRed Head,Led1
	LedRed Head,Led2

	LedRed Body,Led7
	LedRed Body,Led8
	AllLedsOFF
	rcall BrainHandlerSignal
	LedRed Body,Led8
	LedRed Body,Led7

	LedRed Head,Led2
	LedRed Head,Led1	

	LedRed Hand,Led8
	LedRed Hand,Led7
	LedRed Hand,Led6
	LedRed Hand,Led5
	LedRed Hand,Led4
	LedRed Hand,Led3
	LedRed Hand,Led2
	LedRed Hand,Led1
	AllLedsOFF
  RET

BrainHandlerSignal:
	
  RET

Delay100ms:
          ldi  R16, $5F
WGLOOP4:  ldi  R17, $17
WGLOOP5:  ldi  R18, $79
WGLOOP6:  dec  R18
          brne WGLOOP6
          dec  R17
          brne WGLOOP5
          dec  R16
          brne WGLOOP4
  RET

Delay500ms:
          ldi  R16, $2F
WGLOOP0:  ldi  R17, $D3
WGLOOP1:  ldi  R18, $F1
WGLOOP2:  dec  R18
          brne WGLOOP2
          dec  R17
          brne WGLOOP1
          dec  R16
          brne WGLOOP0
; ----------------------------- 
; delaying 117 cycles:
          ldi  R16, $27
WGLOOP3:  dec  R16
          brne WGLOOP3
  RET



