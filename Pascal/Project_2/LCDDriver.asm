
_InitPortsIO:

;LCDDriver.mpas,9 :: 		begin
;LCDDriver.mpas,10 :: 		DDRD :=%11111111;
	LDI        R27, 255
	OUT        DDRD+0, R27
;LCDDriver.mpas,11 :: 		DDRB :=%00010011;
	LDI        R27, 19
	OUT        DDRB+0, R27
;LCDDriver.mpas,12 :: 		DDRC :=%00111000;
	LDI        R27, 56
	OUT        DDRC+0, R27
;LCDDriver.mpas,13 :: 		PORTC:=%00000011;
	LDI        R27, 3
	OUT        PORTC+0, R27
;LCDDriver.mpas,14 :: 		end;
L_end_InitPortsIO:
	RET
; end of _InitPortsIO

_WriteData:

;LCDDriver.mpas,17 :: 		begin
;LCDDriver.mpas,19 :: 		CBI PORTC,4
	CBI        PORTC+0, 4
;LCDDriver.mpas,20 :: 		CBI PORTC,3
	CBI        PORTC+0, 3
;LCDDriver.mpas,21 :: 		SBI PORTC,5
	SBI        PORTC+0, 5
;LCDDriver.mpas,22 :: 		OUT PORTD,R2
	OUT        PORTD+0, R2
;LCDDriver.mpas,23 :: 		CBI PORTC,5
	CBI        PORTC+0, 5
;LCDDriver.mpas,24 :: 		SBI PORTB,0
	SBI        PORTB+0, 0
;LCDDriver.mpas,26 :: 		delay_us(1);
	LDI        R16, 2
L__WriteData2:
	DEC        R16
	BRNE       L__WriteData2
	NOP
	NOP
;LCDDriver.mpas,27 :: 		end;
L_end_WriteData:
	RET
; end of _WriteData

_WriteCommand:

;LCDDriver.mpas,30 :: 		begin
;LCDDriver.mpas,32 :: 		CBI PORTB,0
	CBI        PORTB+0, 0
;LCDDriver.mpas,33 :: 		CBI PORTC,4
	CBI        PORTC+0, 4
;LCDDriver.mpas,34 :: 		SBI PORTC,3
	SBI        PORTC+0, 3
;LCDDriver.mpas,35 :: 		SBI PORTC,5
	SBI        PORTC+0, 5
;LCDDriver.mpas,36 :: 		OUT PORTD,R2
	OUT        PORTD+0, R2
;LCDDriver.mpas,37 :: 		CBI PORTC,5
	CBI        PORTC+0, 5
;LCDDriver.mpas,39 :: 		delay_us(1);
	LDI        R16, 2
L__WriteCommand5:
	DEC        R16
	BRNE       L__WriteCommand5
	NOP
	NOP
;LCDDriver.mpas,40 :: 		end;
L_end_WriteCommand:
	RET
; end of _WriteCommand

_SetByteAdrCursor:

;LCDDriver.mpas,43 :: 		begin
;LCDDriver.mpas,45 :: 		WriteCommand(%00001010);
	PUSH       R2
	PUSH       R2
	LDI        R27, 10
	MOV        R2, R27
	CALL       _WriteCommand+0
	POP        R2
;LCDDriver.mpas,46 :: 		WriteData(LowAdrByte);
	CALL       _WriteData+0
;LCDDriver.mpas,48 :: 		WriteCommand(%00001011);
	LDI        R27, 11
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,49 :: 		WriteData(HighAdrByte);
	MOV        R2, R3
	CALL       _WriteData+0
;LCDDriver.mpas,50 :: 		end;
L_end_SetByteAdrCursor:
	POP        R2
	RET
; end of _SetByteAdrCursor

_EnableLcd:

;LCDDriver.mpas,54 :: 		begin
;LCDDriver.mpas,56 :: 		SBI PORTB,1
	SBI        PORTB+0, 1
;LCDDriver.mpas,58 :: 		end;
L_end_EnableLcd:
	RET
; end of _EnableLcd

_InitSPI:

;LCDDriver.mpas,61 :: 		begin
;LCDDriver.mpas,63 :: 		SBI SPCR,6
	SBI        SPCR+0, 6
;LCDDriver.mpas,65 :: 		end;
L_end_InitSPI:
	RET
; end of _InitSPI

_InitLC7981:

;LCDDriver.mpas,70 :: 		begin
;LCDDriver.mpas,72 :: 		EnableLcd;
	PUSH       R2
	PUSH       R3
	CALL       _EnableLcd+0
;LCDDriver.mpas,74 :: 		WriteCommand(%00000000);
	CLR        R2
	CALL       _WriteCommand+0
;LCDDriver.mpas,75 :: 		WriteData(%00110010);
	LDI        R27, 50
	MOV        R2, R27
	CALL       _WriteData+0
;LCDDriver.mpas,77 :: 		WriteCommand(%00000001);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,78 :: 		WriteData(%00000111);
	LDI        R27, 7
	MOV        R2, R27
	CALL       _WriteData+0
;LCDDriver.mpas,80 :: 		WriteCommand(%00000010);
	LDI        R27, 2
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,81 :: 		WriteData(%00011101);
	LDI        R27, 29
	MOV        R2, R27
	CALL       _WriteData+0
;LCDDriver.mpas,83 :: 		WriteCommand(%00000011);
	LDI        R27, 3
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,84 :: 		WriteData(%01111111);
	LDI        R27, 127
	MOV        R2, R27
	CALL       _WriteData+0
;LCDDriver.mpas,86 :: 		WriteCommand(%00000100);
	LDI        R27, 4
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,87 :: 		WriteData(%00000000);
	CLR        R2
	CALL       _WriteData+0
;LCDDriver.mpas,90 :: 		WriteCommand(%00001000);
	LDI        R27, 8
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,91 :: 		WriteData(%00000000);
	CLR        R2
	CALL       _WriteData+0
;LCDDriver.mpas,93 :: 		WriteCommand(%00001001);
	LDI        R27, 9
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,94 :: 		WriteData(%00000000);
	CLR        R2
	CALL       _WriteData+0
;LCDDriver.mpas,96 :: 		SetByteAdrCursor(0,0);
	CLR        R3
	CLR        R2
	CALL       _SetByteAdrCursor+0
;LCDDriver.mpas,97 :: 		for i:=0 to 3840 do
; i start address is: 18 (R18)
	LDI        R18, 0
	LDI        R19, 0
; i end address is: 18 (R18)
L__InitLC798112:
;LCDDriver.mpas,99 :: 		WriteCommand(%00001100);
; i start address is: 18 (R18)
	PUSH       R19
	PUSH       R18
	LDI        R27, 12
	MOV        R2, R27
	CALL       _WriteCommand+0
;LCDDriver.mpas,100 :: 		WriteData(0);
	CLR        R2
	CALL       _WriteData+0
	POP        R18
	POP        R19
;LCDDriver.mpas,101 :: 		end;
	CPI        R19, 15
	BRNE       L__InitLC798134
	CPI        R18, 0
L__InitLC798134:
	BRNE       L__InitLC798135
	JMP        L__InitLC798115
L__InitLC798135:
	MOVW       R16, R18
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R18, R16
; i end address is: 18 (R18)
	JMP        L__InitLC798112
L__InitLC798115:
;LCDDriver.mpas,102 :: 		SetByteAdrCursor(0,0);
	CLR        R3
	CLR        R2
	CALL       _SetByteAdrCursor+0
;LCDDriver.mpas,103 :: 		end;
L_end_InitLC7981:
	POP        R3
	POP        R2
	RET
; end of _InitLC7981

_ReadSPI:

;LCDDriver.mpas,107 :: 		begin
;LCDDriver.mpas,109 :: 		WaitReception:
WaitReception:
;LCDDriver.mpas,111 :: 		sbis SPSR,SPIF
	SBIS       SPSR+0, 7
;LCDDriver.mpas,112 :: 		rjmp WaitReception
	RJMP       WaitReception
;LCDDriver.mpas,115 :: 		ReadSPI:=SPDR;
; Result start address is: 17 (R17)
	IN         R17, SPDR+0
;LCDDriver.mpas,116 :: 		end;
	MOV        R16, R17
; Result end address is: 17 (R17)
L_end_ReadSPI:
	RET
; end of _ReadSPI

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27

;LCDDriver.mpas,120 :: 		begin
;LCDDriver.mpas,121 :: 		InitPortsIO;
	PUSH       R2
	CALL       _InitPortsIO+0
;LCDDriver.mpas,122 :: 		InitLC7981;
	CALL       _InitLC7981+0
;LCDDriver.mpas,123 :: 		InitSPI;
	CALL       _InitSPI+0
;LCDDriver.mpas,124 :: 		while true do
L__main20:
;LCDDriver.mpas,126 :: 		if PINB3_bit=1 then
	IN         R27, PINB3_bit+0
	SBRS       R27, 3
	JMP        L__main25
;LCDDriver.mpas,128 :: 		WriteCommand(ReadSPI);
	CALL       _ReadSPI+0
	MOV        R2, R16
	CALL       _WriteCommand+0
;LCDDriver.mpas,129 :: 		WriteData(ReadSPI);
	CALL       _ReadSPI+0
	MOV        R2, R16
	CALL       _WriteData+0
;LCDDriver.mpas,130 :: 		end;
L__main25:
;LCDDriver.mpas,131 :: 		end;
	JMP        L__main20
;LCDDriver.mpas,132 :: 		end.
L_end_main:
L__main_end_loop:
	JMP        L__main_end_loop
; end of _main
