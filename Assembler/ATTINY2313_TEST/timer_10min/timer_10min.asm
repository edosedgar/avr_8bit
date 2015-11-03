/*
 * Электронные часы
 * на 7-сегметных индикаторах.
 * Автор:Казиахмедов Эдгар. 
 * Возраст:14 лет. опрос кнопки с помощью команды sbis
 */ 
.include "tn2313def.inc"
.macro Outi
;макрос вывода в регистр
	ldi r16,@1
	out @0,r16
.endm
.def	buffer=R20
.def    ones=r29
.def	twos=r28
.equ    buzzer=pa1
.equ	led1=pa0
.equ	led2=pd2
.equ	led3=pd3
.equ	led4=pd4
.equ	key1=pind5
.equ	key2=pind6
.dseg
Number: .byte 3
.cseg
.org 0  /*вектор прерываний*/  
 rjmp RESET ; Reset Handler
 reti;rjmp INT0 ; External Interrupt0 Handler
 reti;rjmp INT1 ; External Interrupt1 Handler
 reti;rjmp TIM1_CAPT ; Timer1 Capture Handler
 reti;rjmp TIM1_COMPA ; Timer1 CompareA Handler
 rjmp TIM1_OVF ; Timer1 Overflow Handler
 rjmp TIM0_OVF ; Timer0 Overflow Handler
 reti;rjmp USART0_RXC ; USART0 RX Complete Handler
 reti;rjmp USART0_DRE ; USART0,UDR Empty Handler
 reti;rjmp USART0_TXC ; USART0 TX Complete Handler
 reti;rjmp ANA_COMP ; Analog Comparator Handler
 reti;rjmp PCINT ; Pin Change Interrupt
 reti;rjmp TIMER1_COMPB ; Timer1 Compare B Handler
 reti;rjmp TIMER0_COMPA ; Timer0 Compare A Handler
 reti;rjmp TIMER0_COMPB ; Timer0 Compare B Handler
 reti;rjmp USI_START ; USI Start Handler
 reti;rjmp USI_OVERFLOW ; USI Overflow Handler
 reti;rjmp EE_READY ; EEPROM Ready Handler
 reti;rjmp WDT_OVERFLOW ; Watchdog Overflow Handler

 RESET: ; Reset Handler
 init:
	outi SPL,low(RAMEND)
	outi DDRB,0B11111111
	outi PORTB,0B11111111
	outi DDRD,0B00011111
	outi PORTD,0B01100000
	outi DDRA,0B0000011
	outi TCCR1B,0b00000100
	outi timsk,0b00000010
	outi tccr0b,0b00000101
	outi TCNT1H,0xee
	outi TCNT1L,0x85			
	ldi ones,11;переменная к 1 сегменту
	ldi twos,11;переменная к 2 сегменту
;****************************************
;*  ЗАГРУЗКА НАЧАЛЬНЫХ ЗНАЧЕНИЙ В RAM   *
;****************************************
	mov buffer,ones
    sts NUMBER,buffer;1 сегмент 
    mov buffer,twos
    sts NUMBER+1,buffer;2 сегмент
;*********************************
	sei
;НАЧАЛО ПРОГРАММЫ
start:;принцип заключается в том что достается из ram значение и выводится на порт,и образуется динамическая индикация
			outi portb,0
			sbi portd,0
			lds buffer,number;извлекаем из RAM то ,что выведим на сегмент
			rcall decoder;декодируем двоичное число в 7-сегментное
			rcall delay;задержка для динамической индикации
			cbi portd,0
			;********************
			
			outi portb,0
			sbi portd,1
			lds buffer,number+1
			rcall decoder
			rcall delay
			cbi portd,1
rjmp start
;*****************************
TIM1_OVF:
	outi TCNT1H,0xee
	outi TCNT1L,0x85
	inc twos
	rcall out_disp
	cpi twos,10
	breq two
reti
two:
	clr twos
	rcall out_disp
	inc ones
	rcall out_disp
	cpi ones,10
	breq three
reti
three:
	clr ones
	rcall out_disp
reti
TIM0_OVF:
	rcall out_hello
	outi timsk,0b10000000
reti
Decoder:
;Преобразование двоичного числа
;в код 7-сегментного индикатора
              ldi ZL,Low(DcMatrix*2)   ;Инициализация массива
			  ldi ZH,High(DcMatrix*2)			  

			  ldi r21,0
              add ZL,buffer            ;к 0-му адресу массива
			  adc zh,r21
		
              lpm                     ;Загрузка значения
              mov buffer,R0
			  out PORTB,buffer
ret
DcMatrix:
;Массив - таблица истинности декодера
              .db 0b00100001,0b01111101	;0,1
              .db 0b00010011,0b00011001	;2,3
              .db 0b01001101,0b10001001	;4,5
              .db 0b10000001,0b00111101	;6,7
              .db 0b00000001,0b00001001	;8,9
			  .db 0b11111111,0b11011111 ; ,-
			  .db 0b00000101,0b10100011 ;A,C
			  .db 0b10000011,0b10000111 ;E,F
			  .db 0b10100001,0b11100011 ;G,L
			  .db 0b01000101,0            ;H
;*********************************
delay:
;Задержка 0.005 с
 ldi  R30, $1F
WGLOOP4:  ldi  R31, $55
WGLOOP5:  dec  R31
          brne WGLOOP5
          dec  R30
          brne WGLOOP4
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
ret
;==========================================
zader:
;Задержка 0.6 с
          ldi  R17, $25
WGLOOP0:  ldi  R18, $B8
WGLOOP1:  ldi  R19, $EA
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
reti
; ============================= 
out_disp:
	mov buffer,ones
    sts NUMBER,buffer;1 сегмент 
    mov buffer,twos
    sts NUMBER+1,buffer;2 сегмент
reti
out_hello:
	ldi ones,18
	ldi twos,14
	rcall out_disp
	rjmp zader
	/*ldi ones,14
	ldi twos,17
	rcall out_disp
	rcall zader
	ldi ones,17
	ldi twos,17
	rcall out_disp
	rcall zader
	ldi ones,17
	ldi twos,0
	rcall out_disp
	rcall zaDER
	ldi ones,0
	ldi twos,10
	rcall out_disp
	rcall ZADER
	ldi ones,10
	ldi twos,10
	rcall out_disp
	rcall zader*/
	clr ones
	clr twos
	rcall out_disp
reti
	
