.macro Outi
    ldi r16,@1
    out @0,r16
.endm
.macro clr_lcd
	rcall    read_bf
    ldi    r16, 0b00000001;�������� �������
    rcall    write_lcd
	rcall    delay
.endm
.macro write_symbol;r19
    rcall    read_bf;������ �������
	ldi      r16,@0
    rcall    write_data
	rcall 	 delay
.endm
.macro cell_number;r20
	rcall    read_bf  ;������� �� ������ ������
	ldi r17,0b10000000
	ldi r16,@0
	add r16,r17
    rcall    write_lcd
	rcall    delay
.endm
.macro init_lcd
	rcall init_port_lcd
    rcall    delay
    rcall    read_bf
    ldi    r16, 0b00111000;8 ������ �����,2 ������,������ ������
    rcall    write_lcd
    rcall    delay

    rcall    read_bf
    ldi    r16, 0b00000100;����������������� ������,��� ������ ������
    rcall    write_lcd
	rcall    delay

    rcall    read_bf
    ldi    r16, 0b00010100;����� ������� ������
    rcall    write_lcd
	rcall    delay

    rcall    read_bf
    ldi    r16, 0b00001100;�������� �������,������� ������
    rcall    write_lcd
	rcall    delay

	rcall    read_bf
    ldi    r16, 0b00000001;�������� �������
    rcall    write_lcd
	rcall    delay
.endm
;***********************************************************
