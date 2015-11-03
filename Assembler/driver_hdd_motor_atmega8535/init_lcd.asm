.equ E=7
.equ RW=6
.equ RS=5
.equ data=ddrc
.equ dd_rs=dda5
.equ dd_rw=dda6
.equ dd_e=dda7
.def out_info_lcd=r19
lcd_team:
	rcall    read_bf
    mov    r16, r19    ;������� �� ������ ������
    rcall    write_lcd
	rcall delay
ret
data_lcd:	
    rcall    read_bf
    mov    r16, out_info_lcd;�� ��� � r19 ����������� r16
    rcall    write_data
    rcall    delay
ret
write_lcd:;��������  �� ����� �������
    cbi    porta, rs
    cbi    porta, rw
    nop
    sbi    porta, e
    out    portc, r16
    cbi    porta, e
ret
init_port_lcd:
	ldi r16,255
    out data,r16
ret
write_data:;�������� �� ����� �������
    sbi    porta, rs
    cbi    porta, rw
    nop
    sbi    porta, e
    out    portc, r16
    cbi    porta, e
    cbi    porta, rs
ret
read_bf:  ;������ busy flag,���� �� �����  0,�� ���������� ������(���� ���������)
    outi	ddrc,0
	outi 	portc,255
    sbi     porta, rw
    sbi     porta, e
    nop
    in      r16, portc
    cbi     porta, e
    sbrs    r16, 7
    rjmp    read_bf
	cbi     porta, rw
    cbi     porta, e
    outi    ddrc,255
ret  
;***********************************************************************************************************************************************
;********************************************��������*******************************************************************************************    
    
delay:;�������� 0.0017c
	ldi r20,17
loop2:
	dec r20
	rcall ms
	cpi r20,0
	brne loop2
ret
ms:;0.0001
	ldi  R17, $02
WGLOOP0:  ldi  R18, $84
WGLOOP1:  dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
ret
