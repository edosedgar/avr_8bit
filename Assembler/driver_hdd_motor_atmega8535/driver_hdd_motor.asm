.include "m8535def.inc"
.macro Outi;макрос вывода в регистр
    ldi temp,@1
    out @0,temp
.endm
.def low_reg=R17
.def phase=R18
.def high_reg=R19
.def temp=R30
.def counter=R20
.def button=R21
.equ red=2
.equ yellow=3
.equ green=1
.equ led_port=portd
.cseg
.org 0
 rjmp	RESET 		;Reset Handler 
 reti				;rjmp	EXT_INT0 	; IRQ0 Handler
 reti				;rjmp	EXT_INT1 	; IRQ1 Handler
 reti				;rjmp	TIM2_COMP 	; Timer2 Compare Handler
 reti				;rjmp	TIM2_OVF 	; Timer2 Overflow Handler
 reti				;rjmp	TIM1_CAPT 	; Timer1 Capture Handler
 reti				;rjmp 	TIM1_COMPA 	; Timer1 Compare A Handler
 reti				;rjmp	TIM1_COMPB 	; Timer1 Compare B Handler
 rjmp 	TIM1_OVF 	;Timer1 Overflow Handler
 rjmp 	TIM0_OVF 	;Timer0 Overflow Handler
 reti				;rjmp 	SPI_STC 	; SPI Transfer Complete Handler
 reti				;rjmp 	USART_RXC 	; USART RX Complete Handler
 reti				;rjmp 	USART_UDRE 	; UDR Empty Handler
 reti				;rjmp 	USART_TXC	; USART TX Complete Handler
 reti				;rjmp   ADC_        ; ADC Conversion Complete Handler
 reti				;rjmp 	EE_RDY		; EEPROM Ready Handler
 reti				;rjmp 	ANA_COMP	; Analog Comparator Handler
 reti				;rjmp 	TWSI		; Two-wire Serial Interface Handler
 reti               ;rjmp 	EXT_INT2	; IRQ2 Handler
 reti				;rjmp 	TIM0_COMP	; Timer0 Compare Handler
 reti				;rjmp 	SPM_RDY		; 0b11101000

RESET:			                        ; Reset Handler
 
init:; инициализаци€ переферии, переменных, портов
    outi SPH,high(RAMEND)    
    outi SPL,low(RAMEND)
    outi DDRB,0b00000000
	outi PORTB,255
    outi DDRD,0b00000111   
	outi DDRA,0b00000111
	outi TCCR1B,0b00000010
	outi TCCR0,0b00000100
	outi TIMSK,0b00000101
	ldi high_reg,210
	ldi low_reg,0
	ldi phase,1
	outi TCNT0,0
	outi TCNT1H,0
	outi TCNT1L,0
	sei
start:
	rcall button_handler
	sbis PINB,0
	rcall button_inc
rjmp start
TIM0_OVF:;“аймер,увеличивающий скорость вращени€ двигател€.
	inc low_reg;переменна€,отвечающа€ за состо€ние младшего регистра TCNT1L 
	cpi low_reg,255;проверка,если переменна€ больше 255,то старший разр€д(TCNT1H) увеличиваетс€ на 1
	breq inc_high_reg
reti
TIM1_OVF:;“аймер,крут€щий двигатель со скоростью,котора€ задаетс€ таймером 0.
	out PORTA,phase;вывод в PORTA,включенную фазу
	rcall shift_phase;сдвиг фазы
	inc counter;инкремент счетчика,отвечающего за включенную фазу двигател€		
	out TCNT1L,low_reg;вывод переменной low_reg в регистр TCNT1L
	out TCNT1H,high_reg;вывод переменной high_reg в регистр TCNT1H
reti							
shift_phase:
	cpi counter,0
	breq phase_1
	cpi counter,1
	breq phase_2
	cpi counter,2
	breq phase_3
	cpi counter,3
	breq phase_4
	cpi counter,4
	breq phase_5
	cpi counter,5
	breq phase_6
ret

inc_high_reg:
	inc high_reg
reti

phase_1:
	ldi phase,1
reti
phase_2:
	ldi phase,3
reti
phase_3:
	ldi phase,2
reti
phase_4:
	ldi phase,6
reti
phase_5:
	ldi phase,4
reti
phase_6:
	ldi phase,5
	clr counter
reti


button_inc:
	inc button
	cpi button,3
	breq rst_button
cycle:
	rcall delay
	sbis pinb,0
	rjmp cycle
ret
	
button_handler:	
	cpi button,1
	breq stop_timer0
	cpi button,2
	breq start_timer0
ret

stop_timer0:
	outi timsk,0b00000100
	outi led_port,yellow
ret
start_timer0:
	outi timsk,0b00000101
	outi led_port,green
ret
rst_button:
	clr button
rjmp cycle

delay:
	ldi  R22, $F1
WGLOOP0:  ldi  R23, $0E
WGLOOP1:  ldi  R24, $9D
WGLOOP2:  dec  R24
          brne WGLOOP2
          dec  R23
          brne WGLOOP1
          dec  R22
          brne WGLOOP0
; ----------------------------- 
; delaying 1 cycle:
          nop
ret
