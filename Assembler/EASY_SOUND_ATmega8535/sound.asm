.include "m8535def.inc"
.list
.macro Outi
    ldi R16,@1
    out @0,R16
.endm
.def buffer_frequency=R17
.def buffer_frequency2=R18
.def counter=R22
.cseg
.org 0
 rjmp	init		;Reset Handler 
 reti				;rjmp	EXT_INT0 	; IRQ0 Handler
 reti				;rjmp	EXT_INT1 	; IRQ1 Handler
 reti				;rjmp	TIM2_COMP 	; Timer2 Compare Handler
 reti				;rjmp	TIM2_OVF 	; Timer2 Overflow Handler
 reti				;rjmp	TIM1_CAPT 	; Timer1 Capture Handler
 reti				;rjmp 	TIM1_COMPA 	; Timer1 Compare A Handler
 reti				;rjmp	TIM1_COMPB 	; Timer1 Compare B Handler
 rjmp 	TIM1_OVF 	; Timer1 Overflow Handler
 reti               ;rjmp 	TIM0_OVF 	; Timer0 Overflow Handler
 reti				;rjmp 	SPI_STC 	; SPI Transfer Complete Handler
 reti				;rjmp 	USART_RXC 	; USART RX Complete Handler
 reti				;rjmp 	USART_UDRE 	; UDR Empty Handler
 reti				;rjmp 	USART_TXC	; USART TX Complete Handler
 reti				;rjmp ADC_            ADC Conversion Complete Handler
 reti				;rjmp 	EE_RDY		; EEPROM Ready Handler
 reti				;rjmp 	ANA_COMP	; Analog Comparator Handler
 reti				;rjmp 	TWSI		; Two-wire Serial Interface Handler
 reti				;rjmp 	EXT_INT2	; IRQ2 Handler
 reti				;rjmp 	TIM0_COMP	; Timer0 Compare Handler
 reti				;rjmp 	SPM_RDY		; 0b11101000

init:
    outi SPL,low(RAMEND)    
    outi SPH,high(RAMEND)    
	outi DDRA,0b00000001
	outi TCCR1B,0b00000100
	outi TIMSK,0b00000100
	ldi ZL,Low(frequency*2);Инициализация массива
    ldi ZH,High(frequency*2)
	ldi buffer_frequency,0xFF
	ldi buffer_frequency2,0xE3
	ldi R20,1
	clr R21
	sei
start:
rjmp start	
	                        ;Reset Handler 

TIM1_OVF:
	inc counter
	cpi counter,255
	breq clear_and_get_value_frequency
	out TCNT1H,buffer_frequency
	out TCNT1L,buffer_frequency2	
	eor R21,R20
	out PORTA,R21
reti
get_value_frequency:
	lpm
	mov buffer_frequency,R0
	adiw ZL,1
	lpm 
	mov buffer_frequency2,R0
	adiw ZL,1
	cpi buffer_frequency,0
	breq stop_timer
reti
clear_and_get_value_frequency:
	rcall get_value_frequency
	clr counter
reti
stop_timer:
	outi TIMSK,0
reti
frequency:
	.db 0xFF,0xD4
	.db 0xFF,0xD8
	.db 0xFF,0xDC
	.db 0xFF,0xDF
	.db 0xFF,0x00
	.db 0xFF,0x00
	.db 0x00,0x00
