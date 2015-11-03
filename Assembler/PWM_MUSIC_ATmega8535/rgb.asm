.include "m8535def.inc"
.macro OutReg
    ldi R16,@1
    out @0,R16
.endm
.macro ADCStart
	sbi ADCSRA,ADSC
.endm
.macro ADCStop
	cbi ADCSRA,ADSC
.endm
.cseg
.org 0
 rjmp	InitSystem  ;Reset Handler 
 reti				;rjmp	EXT_INT0 	; IRQ0 Handler
 reti				;rjmp	EXT_INT1 	; IRQ1 Handler
 reti				;rjmp	TIM2_COMP 	; Timer2 Compare Handler
 reti				;rjmp	TIM2_OVF 	; Timer2 Overflow Handler
 reti				;rjmp	TIM1_CAPT 	; Timer1 Capture Handler
 reti				;rjmp 	TIM1_COMPA 	; Timer1 Compare A Handler
 reti				;rjmp	TIM1_COMPB 	; Timer1 Compare B Handler
 reti               ;rjmp 	TIM1_OVF 	; Timer1 Overflow Handler
 rjmp 	Timer0 	;                  Timer0 Overflow Handler
 reti				;rjmp 	SPI_STC 	; SPI Transfer Complete Handler
 reti				;rjmp 	USART_RXC 	; USART RX Complete Handler
 reti				;rjmp 	USART_UDRE 	; UDR Empty Handler
 reti				;rjmp 	USART_TXC	; USART TX Complete Handler
 rjmp   ADCRead       ;     ADC Conversion Complete Handler
 reti				;rjmp 	EE_RDY		; EEPROM Ready Handler
 reti				;rjmp 	ANA_COMP	; Analog Comparator Handler
 reti				;rjmp 	TWSI		; Two-wire Serial Interface Handler
 reti				;rjmp 	EXT_INT2	; IRQ2 Handler
 reti				;rjmp 	TIM0_COMP	; Timer0 Compare Handler
 reti				;rjmp 	SPM_RDY		; 0b11101000

InitSystem:
    OutReg SPL,low(RAMEND)    
    OutReg SPH,high(RAMEND)
	;Ports I/O 
	OutReg DDRB,254
	OutReg PORTB,1
	OutReg DDRD,255
	;PWM             
	OutReg TCCR0,0b01111001
	OutReg TIMSK,0b00000001
	;ADC 
	OutReg ADCSRA,(1<<ADEN) |(0<<ADSC) |(0<<ADATE)|(0<<ADIF)|(1<<ADIE)|(0<<ADPS2)|(0<<ADPS1)|(0<<ADPS0)
    OutReg ADMUX, (0<<REFS1)|(1<<REFS0)|(1<<ADLAR)|(0<<MUX4)|(0<<MUX3) |(0<<MUX2) |(0<<MUX1) |(0<<MUX0) 
	ADCStart
	sei
;---------------
main:
	sleep
	rjmp main
;---------------
Timer0:
	out OCR0,R16
reti
;---------------
ADCRead:
	in R16,ADCH
    ADCStart
reti
;---------------	





