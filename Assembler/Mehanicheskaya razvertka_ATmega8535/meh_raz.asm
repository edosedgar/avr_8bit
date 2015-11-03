.include "m8535def.inc"
.macro Outi
	ldi temp,@1
	out @0,temp
.endm
.def temp=R16
.def counter=R21
.def buffer=r20
.equ blue=portd
.equ red=portb
.equ green=portc
.cseg
.org 0    
 rjmp RESET ; Reset Handler
 reti;rjmp EXT_INT0 ; IRQ0 Handler
 reti;rjmp EXT_INT1 ; IRQ1 Handler
 reti;rjmp TIM2_COMP ; Timer2 Compare Handler
 reti;rjmp TIM2_OVF ; Timer2 Overflow Handler
 reti;rjmp TIM1_CAPT ; Timer1 Capture Handler
 reti;rjmp TIM1_COMPA ; Timer1 Compare A Handler
 reti;rjmp TIM1_COMPB ; Timer1 Compare B Handler
 reti;rjmp TIM1_OVF ; Timer1 Overflow Handler
 reti;rjmp TIM0_OVF ; Timer0 Overflow Handler
 reti;rjmp SPI_STC ; SPI Transfer Complete Handler
 reti;rjmp USART_RXC ; USART RX Complete Handler
 reti;rjmp USART_UDRE ; UDR Empty Handler
 reti;rjmp USART_TXC ; USART TX Complete Handler
 reti;rjmp ADC_ ; ADC Conversion Complete Handler
 reti;rjmp EE_RDY ; EEPROM Ready Handler
 reti;rjmp ANA_COMP ; Analog Comparator Handler
 reti;rjmp TWSI ; Two-wire Serial Interface Handler
 reti;rjmp EXT_INT2 ; IRQ2 Handler
 reti;rjmp TIM0_COMP ; Timer0 Compare Handler
 reti;rjmp SPM_RDY ;0b11101000

 RESET: ; Reset Handler
 init:
	outi SPL,low(RAMEND)    
    outi SPH,high(RAMEND)
	outi ddrd,255
	outi ddrb,255
	outi ddrc,255
 start:
 	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	LDI BUFFER,255
	RCALL BLUE_P
	LDI BUFFER,145
	RCALL BLUE_P
	LDI BUFFER,145
	RCALL BLUE_P
	LDI BUFFER,145
	RCALL BLUE_P
	LDI BUFFER,255
	RCALL BLUE_P
	RCALL CLR_P
	rcall delay2
	rcall delay2

	LDI BUFFER,255
	OUT BLUE,BUFFER
	LDI BUFFER,255
	OUT RED,BUFFER
	RCALL DELAY2
	LDI BUFFER,137
	OUT BLUE,BUFFER
	LDI BUFFER,137
	OUT RED,BUFFER
	RCALL DELAY2
	LDI BUFFER,137
	OUT BLUE,BUFFER
	LDI BUFFER,137
	OUT RED,BUFFER
	RCALL DELAY2
	LDI BUFFER,137
	OUT BLUE,BUFFER
	LDI BUFFER,137
	OUT RED,BUFFER
	RCALL DELAY2
	LDI BUFFER,137
	OUT BLUE,BUFFER
	LDI BUFFER,137
	OUT RED,BUFFER
	RCALL DELAY2
	rcall clr_p
	rcall delay2
	rcall delay2

	LDI BUFFER,63
	RCALL RED_P
	LDI BUFFER,72
	RCALL RED_P
	LDI BUFFER,136
	RCALL RED_P
	LDI BUFFER,72
	RCALL RED_P
	LDI BUFFER,63
	RCALL RED_P
	RCALL CLR_P
	rcall delay2
	rcall delay2


	
	LDI BUFFER,1
	OUT green,BUFFER
	LDI BUFFER,192
	OUT red,BUFFER
	RCALL DELAY2
	LDI BUFFER,1
	OUT green,BUFFER
	LDI BUFFER,128
	OUT red,BUFFER
	RCALL DELAY2
	LDI BUFFER,255
	OUT green,BUFFER
	LDI BUFFER,255
	OUT red,BUFFER
	RCALL DELAY2
	LDI BUFFER,1
	OUT green,BUFFER
	LDI BUFFER,128
	OUT red,BUFFER
	RCALL DELAY2
	LDI BUFFER,1
	OUT green,BUFFER
	LDI BUFFER,192
	OUT red,BUFFER
	RCALL DELAY2
	rcall clr_p
	rcall delay2
	rcall delay2


	LDI BUFFER,255
	RCALL GREEN_P
	LDI BUFFER,137
	RCALL GREEN_P
	LDI BUFFER,137
	RCALL GREEN_P
	LDI BUFFER,137
	RCALL GREEN_P
	LDI BUFFER,118
	RCALL GREEN_P
	RCALL CLR_P
	rcall delay2
	rcall delay2

		
	LDI BUFFER,126
	OUT green,BUFFER
	LDI BUFFER,126
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,129
	OUT green,BUFFER
	LDI BUFFER,129
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,129
	OUT green,BUFFER
	LDI BUFFER,129
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,129
	OUT green,BUFFER
	LDI BUFFER,129
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,126
	OUT green,BUFFER
	LDI BUFFER,126
	OUT BLUE,BUFFER
	RCALL DELAY2
	rcall clr_p
	rcall delay2
	rcall delay2

	LDI BUFFER,129
	OUT green,BUFFER
	LDI BUFFER,129
		OUT RED,BUFFER
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,66
	OUT green,BUFFER
	LDI BUFFER,66
		OUT RED,BUFFER
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,60
	OUT green,BUFFER
	LDI BUFFER,60
		OUT RED,BUFFER
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,66
	OUT green,BUFFER
	LDI BUFFER,66
		OUT RED,BUFFER
	OUT BLUE,BUFFER
	RCALL DELAY2
	LDI BUFFER,129
	OUT green,BUFFER
	LDI BUFFER,129
		OUT RED,BUFFER
	OUT BLUE,BUFFER
	RCALL DELAY2
	rcall clr_p
	rcall delay2
	rcall delay2




	rjmp start
clr_p:
	outi red,0
	outi green,0
	outi blue,0
ret	
BLUE_P:
	out portd,buffer
	rcall delay2
ret
RED_P:
	out portb,buffer
	rcall delay2
ret
GREEN_P:
;	rcall invert_buffer
	out portc,buffer
	rcall delay2
ret
delay:
	ldi  R17, $1F
WGLOOP4:  ldi  R18, $55
WGLOOP5:  dec  R18
          brne WGLOOP5
          dec  R17
          brne WGLOOP4
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
		  ;rcall clr_p
ret
delay2:
	ldi  R17, $1F
WGLOOP0:  ldi  R18, $55
WGLOOP1:  dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
ret

invert_buffer:
	ldi r25,8
cycle:
	dec r25
	std z+1,buffer
	cpi r25,0
	brne cycle
ret
