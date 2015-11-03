.include "m8def.inc"
.macro OutTo
	ldi Temp,@1
	out @0,Temp
.endm
.def temp=R16
.def DataLcd=r18
.def CommandLcd=r19
.def SPIBuffer=r20
.equ CS=PB0
.equ RES=PB1
.equ RS=PC3
.equ RW=PC4
.equ E=PC5
.equ Clk=PINB5
.equ Data=PINB4
.cseg
.org 0
 rjmp StartSystem ; Reset Handler
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
 reti;rjmp SPM_RDY ;0b11101000

StartSystem:
	OutTo SPL,low (RAMEND)
    OutTo SPH,high(RAMEND)
	;=====================
	OutTo DDRD, 0b11111111
	OutTo DDRB, 0b00010011
	OutTo DDRC, 0b00111000
	OutTo PORTC,0b00000011
	OutTo SPCR, 0b01000000
	;PB5 (SCK )
	;PB4 (MISO)Slave out
	;PB3 (MOSI)Slave in
	;PB2 (SS  )
;***************************************************
	;0)Reset
	cbi PORTB,RES
	rcall Delay
	sbi PORTB,RES
	sbi PORTB,CS
	;1)Mode Control
	ldi temp,0b00000000
	rcall WriteCommand
	ldi temp,0b00110010
	rcall WriteData
	;------------------------
	;2)Set Character Pitch
	ldi temp,0b00000001
	rcall WriteCommand
	ldi temp,0b00000111
	rcall WriteData
	;------------------------
	;3)Set Number of Characters
	ldi temp,0b00000010
	rcall WriteCommand
	ldi temp,0b00011101
	rcall WriteData
	;------------------------
	;4)Set Number of Time Divisions (Inverse of Display Duty Ratio)
	ldi temp,0b00000011
	rcall WriteCommand
	ldi temp,0b01111111;1001111
	rcall WriteData
	;------------------------
	;5)Set Cursor Position
	ldi temp,0b00000100
	rcall WriteCommand
	ldi temp,0b00000000
	rcall WriteData
	;------------------------
	;6)Set Display Start Low Order Address
	ldi temp,0b00001000
	rcall WriteCommand
	ldi temp,0b00000000;low order address)
	rcall WriteData
	ldi temp,0b00001001
	rcall WriteCommand
	ldi temp,0b00000000;high order address)
	rcall WriteData
	;-----------------------	
	;7)Set Cursor Address (Low Order) (RAM Write Low Order Address):
	ldi temp,0b00001010
	rcall WriteCommand
	ldi temp,0b00000000;low order address cursor)
	rcall WriteData
	ldi temp,0b00001011
	rcall WriteCommand
	ldi temp,0b00000000;high order address cursor)
	rcall WriteData
	;8)Clear Displays
	ldi r18,128	
	Loop1:
		dec r18	
		ldi r19,30
		Loop2:
			dec r19
			ldi temp,0x0C
			rcall WriteCommand
			ldi temp,0x00
			rcall WriteData
		cpi r19,0
		brne Loop2
	cpi r18,0
	brne Loop1
	;7)Set Cursor Address (Low Order) (RAM Write Low Order Address):
	ldi temp,0b00001010
	rcall WriteCommand
	ldi temp,0b00000000;low order address cursor)
	rcall WriteData
	ldi temp,0b00001011
	rcall WriteCommand
	ldi temp,0b00000000;high order address cursor)
	rcall WriteData
;************************************
	;PB5 (SCK )
	;PB4 (MISO)Slave out
	;PB3 (MOSI)Slave in
	;PB2 (SS  )
Main:
	sbis PINC,1
	rcall ReadCommand
	;sbis PINC,0
	;rcall ReadData
rjmp Main
;***************************************
WriteData:;передача данных
	cbi PORTC,RW
	cbi PORTC,RS
	sbi PORTC,E
	out PORTD,temp
	cbi PORTC,E
	sbi PORTB,CS
	rcall Delay	
ret
;****************************************
WriteCommand:;передача команд
	cbi PORTB,CS
	cbi PORTC,RW
	sbi PORTC,RS
	sbi PORTC,E
	out PORTD,temp
	cbi PORTC,E
	rcall Delay
ret
;***************************************
Delay:
	ldi  R17, $1A
WGLOOP0:  
	dec  R17
    brne WGLOOP0
    nop
    nop
ret
;********************************************************************************************************************
;********************************************************************************************************************
;********************************************************************************************************************
ReadCommand:

	rcall ReadSPI
	mov Temp,SPIBuffer
	rcall WriteCommand

ret
ReadData:

	rcall ReadSPI
	mov Temp,SPIBuffer
	rcall WriteData

ret
ReadSPI:
;	Wait for reception complete
	sbis SPSR,SPIF
	rjmp ReadSPI
;	Read received data and return
	in SPIBuffer,SPDR
ret
;********************************************************************************************************************
;********************************************************************************************************************
;********************************************************************************************************************


