.include "m8535def.inc"
.macro Outi;макрос вывода в регистр
	ldi temp,@1
	out @0,temp
.endm
.def temp=R16
.def counter_value_pwm=R17
.def loop=r18
.def cycle=r19
.equ blue=0
.equ red=1
.equ green=2
.cseg
.org 0 
;вектор прерываний  
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
	outi SPL,low(RAMEND)  ;уделяем место в конце ОЗУ  
    outi SPH,high(RAMEND) ;для стэка=)
	outi DDRD,7;устанавливаем первые 3 разряда в 1
;*********************************************************************
;*****************НАЧАЛО ПРОГРАММЫ************************************
;*********************************************************************
blue_red:;уменьшаем яркость синего,увеличиваем красного
 	inc counter_value_pwm;коэффициэнт заполнения(скважность сигнала)
 		cycle_for_freq_led1_2:;цикл для увеличения частоты мерцания светодиода
			inc cycle;счетчик количества циклов
			mov loop,counter_value_pwm;передаем loop значение скважности
			cbi portd,blue
			sbi portd,red
			rcall delay;задержка,которая задается значение переменной loop
			sbi portd,blue
			cbi portd,red
			mov loop,counter_value_pwm;передаем loop значение скважности
			com loop;инвертирование переменной loop
			rcall delay;задержка,которая задается значение переменной loop
		cpi cycle,255;цикл выполнятеся 255 раз;
		brne cycle_for_freq_led1_2;-----------;
	cpi counter_value_pwm,254
	brne blue_red
	;ИНИЦИАЛИЗАЦИЯ ДЛЯ СЛЕДУЩЕГО РЕЖИМА
	clr counter_value_pwm
	cbi portd,blue
	sbi portd,red
	ldi loop,255
	rcall delay_100ms
	clr cycle
	;**********************************
red_green:;уменьшаем яркость красного,увеличиваем зеленого	
 	inc counter_value_pwm;коэффициэнт заполнения(скважность сигнала)
		cycle_for_freq_led2_3:;цикл для увеличения частоты мерцания светодиода
			inc cycle;счетчик количества циклов
			mov loop,counter_value_pwm;передаем loop значение скважности
			cbi portd,red
			sbi portd,green
			rcall delay;задержка,которая задается значение переменной loop
			sbi portd,red
			cbi portd,green
			mov loop,counter_value_pwm;передаем loop значение скважности
			com loop;инвертирование переменной loop
			rcall delay;задержка,которая задается значение переменной loop
		cpi cycle,255;цикл выполнятеся 255 раз|
		brne cycle_for_freq_led2_3;-----------|
	cpi counter_value_pwm,254
	brne red_green
	;ИНИЦИАЛИЗАЦИЯ ДЛЯ СЛЕДУЩЕГО РЕЖИМА
	clr counter_value_pwm
	cbi portd,red
	sbi portd,green
	ldi loop,255
	rcall delay_100ms
	clr cycle
	;**********************************
green_blue:;уменьшаем яркость зеленого,увеличиваем синего
	inc counter_value_pwm;коэффициэнт заполнения(скважность сигнала)
		cycle_for_freq_led3_1:;цикл для увеличения частоты мерцания светодиода
			inc cycle;счетчик количества циклов
			mov loop,counter_value_pwm;передаем loop значение скважности
			cbi portd,green
			sbi portd,blue
			rcall delay;задержка,которая задается значение переменной loop
			sbi portd,green
			cbi portd,blue
			mov loop,counter_value_pwm;передаем loop значение скважности
			com loop;инвертирование переменной loop
			rcall delay;задержка,которая задается значение переменной loop
		cpi cycle,255;цикл выполнятеся 255 раз|
		brne cycle_for_freq_led3_1;-----------|
	cpi counter_value_pwm,254
	brne green_blue
	;ИНИЦИАЛИЗАЦИЯ ДЛЯ СЛЕДУЩЕГО РЕЖИМА
	clr counter_value_pwm
	cbi portd,green
	sbi portd,blue
	ldi loop,255
	rcall delay_100ms
	clr cycle
	;**********************************
rjmp blue_red;начинаем все заново=)
delay:;задержка(обязательна)
	dec loop
	rcall delay_1ms
	cpi loop,0
	brne delay
ret
delay_100ms:
	ldi  R20, $2F
WGLOOP0:  ldi  R21, $D3
WGLOOP1:  ldi  R22, $F1
WGLOOP2:  dec  R22
          brne WGLOOP2
          dec  R21
          brne WGLOOP1
          dec  R20
          brne WGLOOP0
; ----------------------------- 
; delaying 117 cycles:
          ldi  R20, $27
WGLOOP3:  dec  R20
          brne WGLOOP3
ret
delay_1ms:
	ldi  R20, $0A
WGLOOP4:  dec  R20
          brne WGLOOP4
ret
