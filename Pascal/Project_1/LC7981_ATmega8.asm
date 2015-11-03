
_InitPortsIO:

;LC7981_ATmega8.mpas,8 :: 		begin
;LC7981_ATmega8.mpas,9 :: 		DDRD :=%11111111;
	LDI        R27, 255
	OUT        DDRD+0, R27
;LC7981_ATmega8.mpas,10 :: 		DDRB :=%00010011;
	LDI        R27, 19
	OUT        DDRB+0, R27
;LC7981_ATmega8.mpas,11 :: 		DDRC :=%00111000;
	LDI        R27, 56
	OUT        DDRC+0, R27
;LC7981_ATmega8.mpas,12 :: 		PORTC:=%00000011;
	LDI        R27, 3
	OUT        PORTC+0, R27
;LC7981_ATmega8.mpas,13 :: 		end;
L_end_InitPortsIO:
	RET
; end of _InitPortsIO

_WriteData:

;LC7981_ATmega8.mpas,16 :: 		begin
;LC7981_ATmega8.mpas,18 :: 		CBI PORTC,4
	CBI        PORTC+0, 4
;LC7981_ATmega8.mpas,19 :: 		CBI PORTC,3
	CBI        PORTC+0, 3
;LC7981_ATmega8.mpas,20 :: 		SBI PORTC,5
	SBI        PORTC+0, 5
;LC7981_ATmega8.mpas,21 :: 		OUT PORTD,R2
	OUT        PORTD+0, R2
;LC7981_ATmega8.mpas,22 :: 		CBI PORTC,5
	CBI        PORTC+0, 5
;LC7981_ATmega8.mpas,23 :: 		SBI PORTB,0
	SBI        PORTB+0, 0
;LC7981_ATmega8.mpas,25 :: 		delay_us(1);
	LDI        R16, 2
L__WriteData2:
	DEC        R16
	BRNE       L__WriteData2
	NOP
	NOP
;LC7981_ATmega8.mpas,26 :: 		end;
L_end_WriteData:
	RET
; end of _WriteData

_WriteCommand:

;LC7981_ATmega8.mpas,29 :: 		begin
;LC7981_ATmega8.mpas,31 :: 		CBI PORTB,0
	CBI        PORTB+0, 0
;LC7981_ATmega8.mpas,32 :: 		CBI PORTC,4
	CBI        PORTC+0, 4
;LC7981_ATmega8.mpas,33 :: 		SBI PORTC,3
	SBI        PORTC+0, 3
;LC7981_ATmega8.mpas,34 :: 		SBI PORTC,5
	SBI        PORTC+0, 5
;LC7981_ATmega8.mpas,35 :: 		OUT PORTD,R2
	OUT        PORTD+0, R2
;LC7981_ATmega8.mpas,36 :: 		CBI PORTC,5
	CBI        PORTC+0, 5
;LC7981_ATmega8.mpas,38 :: 		delay_us(1);
	LDI        R16, 2
L__WriteCommand5:
	DEC        R16
	BRNE       L__WriteCommand5
	NOP
	NOP
;LC7981_ATmega8.mpas,39 :: 		end;
L_end_WriteCommand:
	RET
; end of _WriteCommand

_SetByteAdrCursor:

;LC7981_ATmega8.mpas,42 :: 		begin
;LC7981_ATmega8.mpas,44 :: 		WriteCommand(%00001010);
	PUSH       R2
	PUSH       R2
	LDI        R27, 10
	MOV        R2, R27
	CALL       _WriteCommand+0
	POP        R2
;LC7981_ATmega8.mpas,45 :: 		WriteData(LowAdrByte);
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,47 :: 		WriteCommand(%00001011);
	LDI        R27, 11
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,48 :: 		WriteData(HighAdrByte);
	MOV        R2, R3
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,49 :: 		end;
L_end_SetByteAdrCursor:
	POP        R2
	RET
; end of _SetByteAdrCursor

_ClrScr:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 2
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;LC7981_ATmega8.mpas,54 :: 		begin
;LC7981_ATmega8.mpas,55 :: 		SetByteAdrCursor(0,0);
	PUSH       R2
	PUSH       R3
	CLR        R3
	CLR        R2
	CALL       _SetByteAdrCursor+0
;LC7981_ATmega8.mpas,56 :: 		for i:=0 to 3840 do
	LDI        R27, 0
	STD        Y+0, R27
	STD        Y+1, R27
L__ClrScr10:
;LC7981_ATmega8.mpas,58 :: 		WriteCommand(%00001100);
	LDI        R27, 12
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,59 :: 		WriteData(0);
	CLR        R2
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,60 :: 		end;
	LDD        R16, Y+0
	LDD        R17, Y+1
	CPI        R17, 15
	BRNE       L__ClrScr91
	CPI        R16, 0
L__ClrScr91:
	BRNE       L__ClrScr92
	JMP        L__ClrScr13
L__ClrScr92:
	LDD        R16, Y+0
	LDD        R17, Y+1
	SUBI       R16, 255
	SBCI       R17, 255
	STD        Y+0, R16
	STD        Y+1, R17
	JMP        L__ClrScr10
L__ClrScr13:
;LC7981_ATmega8.mpas,61 :: 		SetByteAdrCursor(0,0);
	CLR        R3
	CLR        R2
	CALL       _SetByteAdrCursor+0
;LC7981_ATmega8.mpas,62 :: 		end;
L_end_ClrScr:
	POP        R3
	POP        R2
	ADIW       R28, 1
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _ClrScr

_EnableLcd:

;LC7981_ATmega8.mpas,65 :: 		begin
;LC7981_ATmega8.mpas,67 :: 		SBI PORTB,1
	SBI        PORTB+0, 1
;LC7981_ATmega8.mpas,69 :: 		end;
L_end_EnableLcd:
	RET
; end of _EnableLcd

_InitLC7981:

;LC7981_ATmega8.mpas,72 :: 		begin
;LC7981_ATmega8.mpas,74 :: 		EnableLcd;
	PUSH       R2
	CALL       _EnableLcd+0
;LC7981_ATmega8.mpas,76 :: 		WriteCommand(%00000000);
	CLR        R2
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,77 :: 		WriteData(%00110010);
	LDI        R27, 50
	MOV        R2, R27
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,79 :: 		WriteCommand(%00000001);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,80 :: 		WriteData(%00000111);
	LDI        R27, 7
	MOV        R2, R27
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,82 :: 		WriteCommand(%00000010);
	LDI        R27, 2
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,83 :: 		WriteData(%00011101);
	LDI        R27, 29
	MOV        R2, R27
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,85 :: 		WriteCommand(%00000011);
	LDI        R27, 3
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,86 :: 		WriteData(%01111111);
	LDI        R27, 127
	MOV        R2, R27
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,88 :: 		WriteCommand(%00000100);
	LDI        R27, 4
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,89 :: 		WriteData(%00000000);
	CLR        R2
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,92 :: 		WriteCommand(%00001000);
	LDI        R27, 8
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,93 :: 		WriteData(%00000000);
	CLR        R2
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,95 :: 		WriteCommand(%00001001);
	LDI        R27, 9
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,96 :: 		WriteData(%00000000);
	CLR        R2
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,98 :: 		ClrScr;
	CALL       _ClrScr+0
;LC7981_ATmega8.mpas,99 :: 		end;
L_end_InitLC7981:
	POP        R2
	RET
; end of _InitLC7981

_InitSPI:

;LC7981_ATmega8.mpas,102 :: 		begin
;LC7981_ATmega8.mpas,104 :: 		SBI SPCR,6
	SBI        SPCR+0, 6
;LC7981_ATmega8.mpas,106 :: 		end;
L_end_InitSPI:
	RET
; end of _InitSPI

_SPIOff:

;LC7981_ATmega8.mpas,109 :: 		begin
;LC7981_ATmega8.mpas,111 :: 		CBI SPCR,6
	CBI        SPCR+0, 6
;LC7981_ATmega8.mpas,113 :: 		end;
L_end_SPIOff:
	RET
; end of _SPIOff

_ReadSPI:

;LC7981_ATmega8.mpas,116 :: 		begin
;LC7981_ATmega8.mpas,118 :: 		WaitReception:
WaitReception:
;LC7981_ATmega8.mpas,120 :: 		sbis SPSR,SPIF
	SBIS       SPSR+0, 7
;LC7981_ATmega8.mpas,121 :: 		rjmp WaitReception
	RJMP       WaitReception
;LC7981_ATmega8.mpas,124 :: 		ReadSPI:=SPDR;
; Result start address is: 17 (R17)
	IN         R17, SPDR+0
;LC7981_ATmega8.mpas,125 :: 		end;
	MOV        R16, R17
; Result end address is: 17 (R17)
L_end_ReadSPI:
	RET
; end of _ReadSPI

_SetPixel:

;LC7981_ATmega8.mpas,130 :: 		begin
;LC7981_ATmega8.mpas,132 :: 		AdrByte:=(30*(y-1))+((x-1) div 8);
	PUSH       R2
	PUSH       R3
	MOV        R16, R3
	LDI        R17, 0
	SUBI       R16, 1
	SBCI       R17, 0
	LDI        R20, 30
	LDI        R21, 0
	CALL       _HWMul_16x16+0
	MOV        R22, R2
	LDI        R23, 0
	SUBI       R22, 1
	SBCI       R23, 0
	MOVW       R18, R22
	LSR        R19
	ROR        R18
	LSR        R19
	ROR        R18
	LSR        R19
	ROR        R18
	MOVW       R20, R18
	ADD        R20, R16
	ADC        R21, R17
;LC7981_ATmega8.mpas,133 :: 		AdrBit:=((x-1) mod 8);
	MOVW       R16, R22
	ANDI       R16, 7
	ANDI       R17, 0
; AdrBit start address is: 22 (R22)
	MOVW       R22, R16
;LC7981_ATmega8.mpas,134 :: 		LowAdrByte:=(AdrByte shl 8) shr 8;
	MOV        R17, R20
	CLR        R16
	MOV        R18, R17
	LDI        R19, 0
;LC7981_ATmega8.mpas,135 :: 		HighAdrByte:=AdrByte shr 8;
	MOV        R16, R21
	LDI        R17, 0
;LC7981_ATmega8.mpas,136 :: 		SetByteAdrCursor(LowAdrByte,HighAdrByte);
	MOV        R3, R16
	MOV        R2, R18
	CALL       _SetByteAdrCursor+0
;LC7981_ATmega8.mpas,139 :: 		0://white
	LDI        R27, 0
	CP         R4, R27
	BREQ       L__SetPixel99
	JMP        L__SetPixel24
L__SetPixel99:
;LC7981_ATmega8.mpas,141 :: 		WriteCommand(%00001110);
	LDI        R27, 14
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,142 :: 		WriteData(AdrBit);
	MOV        R2, R22
; AdrBit end address is: 22 (R22)
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,143 :: 		end;
	JMP        L__SetPixel21
L__SetPixel24:
;LC7981_ATmega8.mpas,144 :: 		1://black
; AdrBit start address is: 22 (R22)
	LDI        R27, 1
	CP         R4, R27
	BREQ       L__SetPixel100
	JMP        L__SetPixel27
L__SetPixel100:
;LC7981_ATmega8.mpas,146 :: 		WriteCommand(%00001111);
	LDI        R27, 15
	MOV        R2, R27
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,147 :: 		WriteData(AdrBit);
	MOV        R2, R22
; AdrBit end address is: 22 (R22)
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,148 :: 		end;
	JMP        L__SetPixel21
L__SetPixel27:
L__SetPixel21:
;LC7981_ATmega8.mpas,150 :: 		end;
L_end_SetPixel:
	POP        R3
	POP        R2
	RET
; end of _SetPixel

_DrawRectangle:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 1
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;LC7981_ATmega8.mpas,155 :: 		begin
;LC7981_ATmega8.mpas,156 :: 		for i:=x1 to x1+width-1 do SetPixel(i,y1,color);
; i start address is: 17 (R17)
	MOV        R17, R2
; i end address is: 17 (R17)
L__DrawRectangle29:
; i start address is: 17 (R17)
	MOV        R16, R2
	ADD        R16, R4
	SUBI       R16, 1
	STD        Y+0, R16
	CP         R16, R17
	BRSH       L__DrawRectangle102
	JMP        L__DrawRectangle33
L__DrawRectangle102:
	PUSH       R17
	PUSH       R4
	PUSH       R2
	MOV        R4, R6
	MOV        R2, R17
	CALL       _SetPixel+0
	POP        R2
	POP        R4
	POP        R17
	LDD        R16, Y+0
	CP         R17, R16
	BRNE       L__DrawRectangle103
	JMP        L__DrawRectangle33
L__DrawRectangle103:
	MOV        R16, R17
	SUBI       R16, 255
	MOV        R17, R16
; i end address is: 17 (R17)
	JMP        L__DrawRectangle29
L__DrawRectangle33:
;LC7981_ATmega8.mpas,157 :: 		for i:=y1 to y1+height-1 do SetPixel(x1+width-1,i,color);
; i start address is: 17 (R17)
	MOV        R17, R3
; i end address is: 17 (R17)
L__DrawRectangle34:
; i start address is: 17 (R17)
	MOV        R16, R3
	ADD        R16, R5
	SUBI       R16, 1
	STD        Y+0, R16
	CP         R16, R17
	BRSH       L__DrawRectangle104
	JMP        L__DrawRectangle38
L__DrawRectangle104:
	MOV        R16, R2
	ADD        R16, R4
	SUBI       R16, 1
	PUSH       R17
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOV        R4, R6
	MOV        R3, R17
	MOV        R2, R16
	CALL       _SetPixel+0
	POP        R2
	POP        R3
	POP        R4
	POP        R17
	LDD        R16, Y+0
	CP         R17, R16
	BRNE       L__DrawRectangle105
	JMP        L__DrawRectangle38
L__DrawRectangle105:
	MOV        R16, R17
	SUBI       R16, 255
	MOV        R17, R16
; i end address is: 17 (R17)
	JMP        L__DrawRectangle34
L__DrawRectangle38:
;LC7981_ATmega8.mpas,158 :: 		for i:=x1+width-1 downto x1 do SetPixel(i,y1+height-1,color);
	MOV        R16, R2
	ADD        R16, R4
	SUBI       R16, 1
; i start address is: 17 (R17)
	MOV        R17, R16
; i end address is: 17 (R17)
L__DrawRectangle39:
; i start address is: 17 (R17)
	CP         R17, R2
	BRSH       L__DrawRectangle106
	JMP        L__DrawRectangle43
L__DrawRectangle106:
	MOV        R16, R3
	ADD        R16, R5
	SUBI       R16, 1
	PUSH       R17
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOV        R4, R6
	MOV        R3, R16
	MOV        R2, R17
	CALL       _SetPixel+0
	POP        R2
	POP        R3
	POP        R4
	POP        R17
	CP         R17, R2
	BRNE       L__DrawRectangle107
	JMP        L__DrawRectangle43
L__DrawRectangle107:
	MOV        R16, R17
	SUBI       R16, 1
	MOV        R17, R16
; i end address is: 17 (R17)
	JMP        L__DrawRectangle39
L__DrawRectangle43:
;LC7981_ATmega8.mpas,159 :: 		for i:=y1+height-1 downto y1 do SetPixel(x1,i,color);
	MOV        R16, R3
	ADD        R16, R5
	SUBI       R16, 1
; i start address is: 17 (R17)
	MOV        R17, R16
; i end address is: 17 (R17)
L__DrawRectangle44:
; i start address is: 17 (R17)
	CP         R17, R3
	BRSH       L__DrawRectangle108
	JMP        L__DrawRectangle48
L__DrawRectangle108:
	PUSH       R17
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOV        R4, R6
	MOV        R3, R17
	CALL       _SetPixel+0
	POP        R2
	POP        R3
	POP        R4
	POP        R17
	CP         R17, R3
	BRNE       L__DrawRectangle109
	JMP        L__DrawRectangle48
L__DrawRectangle109:
	MOV        R16, R17
	SUBI       R16, 1
	MOV        R17, R16
; i end address is: 17 (R17)
	JMP        L__DrawRectangle44
L__DrawRectangle48:
;LC7981_ATmega8.mpas,160 :: 		end;
L_end_DrawRectangle:
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _DrawRectangle

_DrawFillRectangle:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 3
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;LC7981_ATmega8.mpas,165 :: 		begin
;LC7981_ATmega8.mpas,166 :: 		for i:=y1 to y1+height do
; i start address is: 18 (R18)
	MOV        R18, R3
; i end address is: 18 (R18)
L__DrawFillRectangle50:
; i start address is: 18 (R18)
	MOV        R16, R3
	ADD        R16, R5
	STD        Y+2, R16
	CP         R16, R18
	BRSH       L__DrawFillRectangle111
	JMP        L__DrawFillRectangle54
L__DrawFillRectangle111:
;LC7981_ATmega8.mpas,168 :: 		for j:=x1 to x1+width do
	STD        Y+0, R2
; i end address is: 18 (R18)
L__DrawFillRectangle55:
; i start address is: 18 (R18)
	MOV        R17, R2
	ADD        R17, R4
	STD        Y+1, R17
	LDD        R16, Y+0
	CP         R17, R16
	BRSH       L__DrawFillRectangle112
	JMP        L__DrawFillRectangle59
L__DrawFillRectangle112:
;LC7981_ATmega8.mpas,170 :: 		SetPixel(j,i,color);
	PUSH       R18
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOV        R4, R6
	MOV        R3, R18
	LDD        R2, Y+0
	CALL       _SetPixel+0
	POP        R2
	POP        R3
	POP        R4
	POP        R18
;LC7981_ATmega8.mpas,171 :: 		end;
	LDD        R17, Y+0
	LDD        R16, Y+1
	CP         R17, R16
	BRNE       L__DrawFillRectangle113
	JMP        L__DrawFillRectangle59
L__DrawFillRectangle113:
	LDD        R16, Y+0
	SUBI       R16, 255
	STD        Y+0, R16
	JMP        L__DrawFillRectangle55
L__DrawFillRectangle59:
;LC7981_ATmega8.mpas,172 :: 		end;
	LDD        R16, Y+2
	CP         R18, R16
	BRNE       L__DrawFillRectangle114
	JMP        L__DrawFillRectangle54
L__DrawFillRectangle114:
	MOV        R16, R18
	SUBI       R16, 255
	MOV        R18, R16
; i end address is: 18 (R18)
	JMP        L__DrawFillRectangle50
L__DrawFillRectangle54:
;LC7981_ATmega8.mpas,173 :: 		end;
L_end_DrawFillRectangle:
	ADIW       R28, 2
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _DrawFillRectangle

_EndPaint:

;LC7981_ATmega8.mpas,176 :: 		begin
;LC7981_ATmega8.mpas,178 :: 		CBI PORTB,3
	CBI        PORTB+0, 3
;LC7981_ATmega8.mpas,179 :: 		CBI DDRB,3
	CBI        DDRB+0, 3
;LC7981_ATmega8.mpas,181 :: 		InitSPI;
	CALL       _InitSPI+0
;LC7981_ATmega8.mpas,182 :: 		end;
L_end_EndPaint:
	RET
; end of _EndPaint

_StartPaint:

;LC7981_ATmega8.mpas,184 :: 		begin
;LC7981_ATmega8.mpas,185 :: 		SPIOff;
	CALL       _SPIOff+0
;LC7981_ATmega8.mpas,187 :: 		SBI DDRB,3
	SBI        DDRB+0, 3
;LC7981_ATmega8.mpas,188 :: 		SBI PORTB,3
	SBI        PORTB+0, 3
;LC7981_ATmega8.mpas,190 :: 		end;
L_end_StartPaint:
	RET
; end of _StartPaint

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27

;LC7981_ATmega8.mpas,194 :: 		begin
;LC7981_ATmega8.mpas,195 :: 		InitPortsIO;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	CALL       _InitPortsIO+0
;LC7981_ATmega8.mpas,196 :: 		InitLC7981;
	CALL       _InitLC7981+0
;LC7981_ATmega8.mpas,197 :: 		LCDBuffer[1]:=45;
	LDI        R27, 45
	STS        _LCDBuffer+0, R27
;LC7981_ATmega8.mpas,198 :: 		InitSPI;
	CALL       _InitSPI+0
;LC7981_ATmega8.mpas,199 :: 		while true do
L__main64:
;LC7981_ATmega8.mpas,201 :: 		if PINB3_BIT=1 then
	IN         R27, PINB3_bit+0
	SBRS       R27, 3
	JMP        L__main69
;LC7981_ATmega8.mpas,203 :: 		SPIBuffer:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer+0, R16
;LC7981_ATmega8.mpas,204 :: 		if SPIBuffer=0x66 then
	CPI        R16, 102
	BREQ       L__main118
	JMP        L__main72
L__main118:
;LC7981_ATmega8.mpas,206 :: 		StartPaint;
	CALL       _StartPaint+0
;LC7981_ATmega8.mpas,207 :: 		ClrScr;
	CALL       _ClrScr+0
;LC7981_ATmega8.mpas,208 :: 		EndPaint;
	CALL       _EndPaint+0
;LC7981_ATmega8.mpas,209 :: 		end;
L__main72:
;LC7981_ATmega8.mpas,210 :: 		if SPIBuffer=0x55 then
	LDS        R16, _SPIBuffer+0
	CPI        R16, 85
	BREQ       L__main119
	JMP        L__main75
L__main119:
;LC7981_ATmega8.mpas,212 :: 		SPIBuffer1:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer1+0, R16
;LC7981_ATmega8.mpas,213 :: 		SPIBuffer2:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer2+0, R16
;LC7981_ATmega8.mpas,214 :: 		SPIBuffer3:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer3+0, R16
;LC7981_ATmega8.mpas,215 :: 		SPIBuffer4:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer4+0, R16
;LC7981_ATmega8.mpas,216 :: 		SPIBuffer5:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer5+0, R16
;LC7981_ATmega8.mpas,217 :: 		StartPaint;
	CALL       _StartPaint+0
;LC7981_ATmega8.mpas,218 :: 		DrawFillRectangle(SPIBuffer1,SPIBuffer2,SPIBuffer3,SPIBuffer4,SPIBuffer5);
	LDS        R6, _SPIBuffer5+0
	LDS        R5, _SPIBuffer4+0
	LDS        R4, _SPIBuffer3+0
	LDS        R3, _SPIBuffer2+0
	LDS        R2, _SPIBuffer1+0
	CALL       _DrawFillRectangle+0
;LC7981_ATmega8.mpas,219 :: 		EndPaint;
	CALL       _EndPaint+0
;LC7981_ATmega8.mpas,220 :: 		end;
L__main75:
;LC7981_ATmega8.mpas,221 :: 		if SPIBuffer=0x44 then
	LDS        R16, _SPIBuffer+0
	CPI        R16, 68
	BREQ       L__main120
	JMP        L__main78
L__main120:
;LC7981_ATmega8.mpas,223 :: 		SPIBuffer1:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer1+0, R16
;LC7981_ATmega8.mpas,224 :: 		SPIBuffer2:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer2+0, R16
;LC7981_ATmega8.mpas,225 :: 		SPIBuffer3:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer3+0, R16
;LC7981_ATmega8.mpas,226 :: 		SPIBuffer4:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer4+0, R16
;LC7981_ATmega8.mpas,227 :: 		SPIBuffer5:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer5+0, R16
;LC7981_ATmega8.mpas,228 :: 		StartPaint;
	CALL       _StartPaint+0
;LC7981_ATmega8.mpas,229 :: 		DrawRectangle(SPIBuffer1,SPIBuffer2,SPIBuffer3,SPIBuffer4,SPIBuffer5);
	LDS        R6, _SPIBuffer5+0
	LDS        R5, _SPIBuffer4+0
	LDS        R4, _SPIBuffer3+0
	LDS        R3, _SPIBuffer2+0
	LDS        R2, _SPIBuffer1+0
	CALL       _DrawRectangle+0
;LC7981_ATmega8.mpas,230 :: 		EndPaint;
	CALL       _EndPaint+0
;LC7981_ATmega8.mpas,231 :: 		end;
L__main78:
;LC7981_ATmega8.mpas,232 :: 		if SPIBuffer=0x33 then
	LDS        R16, _SPIBuffer+0
	CPI        R16, 51
	BREQ       L__main121
	JMP        L__main81
L__main121:
;LC7981_ATmega8.mpas,234 :: 		SPIBuffer1:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer1+0, R16
;LC7981_ATmega8.mpas,235 :: 		SPIBuffer2:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer2+0, R16
;LC7981_ATmega8.mpas,236 :: 		SPIBuffer3:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer3+0, R16
;LC7981_ATmega8.mpas,237 :: 		StartPaint;
	CALL       _StartPaint+0
;LC7981_ATmega8.mpas,238 :: 		SetPixel(SPIBuffer1,SPIBuffer2,SPIBuffer3);
	LDS        R4, _SPIBuffer3+0
	LDS        R3, _SPIBuffer2+0
	LDS        R2, _SPIBuffer1+0
	CALL       _SetPixel+0
;LC7981_ATmega8.mpas,239 :: 		EndPaint;
	CALL       _EndPaint+0
;LC7981_ATmega8.mpas,240 :: 		end;
L__main81:
;LC7981_ATmega8.mpas,241 :: 		if SPIBuffer=0x22 then
	LDS        R16, _SPIBuffer+0
	CPI        R16, 34
	BREQ       L__main122
	JMP        L__main84
L__main122:
;LC7981_ATmega8.mpas,243 :: 		SPIBuffer1:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer1+0, R16
;LC7981_ATmega8.mpas,244 :: 		SPIBuffer2:=ReadSPI;
	CALL       _ReadSPI+0
	STS        _SPIBuffer2+0, R16
;LC7981_ATmega8.mpas,245 :: 		StartPaint;
	CALL       _StartPaint+0
;LC7981_ATmega8.mpas,246 :: 		WriteCommand(SPIBuffer1);
	LDS        R2, _SPIBuffer1+0
	CALL       _WriteCommand+0
;LC7981_ATmega8.mpas,247 :: 		WriteData(SPIBuffer2);
	LDS        R2, _SPIBuffer2+0
	CALL       _WriteData+0
;LC7981_ATmega8.mpas,248 :: 		EndPaint;
	CALL       _EndPaint+0
;LC7981_ATmega8.mpas,249 :: 		end;
L__main84:
;LC7981_ATmega8.mpas,250 :: 		end;
L__main69:
;LC7981_ATmega8.mpas,251 :: 		end;
	JMP        L__main64
;LC7981_ATmega8.mpas,252 :: 		end.
L_end_main:
L__main_end_loop:
	JMP        L__main_end_loop
; end of _main
