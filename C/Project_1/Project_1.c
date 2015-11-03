#include <avr/io.h> 
#include <avr/iom8.h> 
#include <util/delay.h>
#include <avr/interrupt.h>


#define CS  (PB0) 
#define RES (PB1)
#define RS  (PC3)
#define RW  (PC4)
#define E   (PC5) 

unsigned int ADC_Result;
unsigned int LVLBat;
unsigned int tempy;
/*---------------------*/

void InitPortsIO()
{ 
    DDRD =0b11111111;
    PORTD=0b11111111;
    DDRB =0b00111111;
    DDRC =0b00111000;
    PORTC=0b00000110;
}
/*---------------------*/
void InitADC()
{
	ADCSRA=(1<<ADEN)|(0<<ADSC)|(1<<ADFR)|(0<<ADIF)|(1<<ADIE)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
    ADMUX=(0<<REFS1)|(1<<REFS0)|(1<<ADLAR)|(0<<MUX3)|(0<<MUX2)|(0<<MUX1)|(0<<MUX0);
	ADCSRA|=_BV(ADSC);
}
/*---------------------*/
void WriteData(int dat)
{
	PORTC&=~(_BV(RW)) ;//0
    PORTC&=~(_BV(RS)); //0
    PORTC|=  _BV(E);   //1
    PORTD=dat;
    PORTC&=~(_BV(E));  //0
    PORTB|=  _BV(CS);  //1
    _delay_us(5);
}
/*---------------------*/
void WriteCommand(int dat)
{
	PORTB&=~(_BV(CS)); //0
    PORTC&=~(_BV(RW)); //0
    PORTC|=  _BV(RS);  //1
	PORTC|=  _BV(E);   //1
    PORTD=dat;
    PORTC&=~(_BV(E));  //0
    _delay_us(5);
}
/*---------------------*/
void ResetControllerLcd()
{
	PORTB&=~(_BV(RES));//0
	_delay_ms(1);
	PORTB|=  _BV(RES); //1
	PORTB|=  _BV(CS);  //1
}
/*---------------------*/
void ClrScr()
{
	unsigned int i;
	for (i=0;i<3840;i++)
	{
          WriteCommand(0b00001100);
          WriteData(0);
	}
}
/*---------------------*/

void InitLcdController()
{
	ResetControllerLcd();
//1)Mode Control
    WriteCommand(0b00000000);
    WriteData(0b00110010);
//2)Set Character Pitch
    WriteCommand(0b00000001);
    WriteData(0b00000111);
//3)Set Number of Characters
    WriteCommand(0b00000010);
    WriteData(0b00011101);
//4)Set Number of Time Divisions (Inverse of Display Duty Ratio)
    WriteCommand(0b00000011);
    WriteData(0b01111111);
//5)Set Cursor Position
    WriteCommand(0b00000100);
    WriteData(0b00000000);
//6)Set Display Start Low Order Address
    //low order address
    WriteCommand(0b00001000);
    WriteData(0b00000000);
    //high order address
    WriteCommand(0b00001001);
    WriteData(0b00000000);
//7)Set Cursor Address (Low Order) (RAM Write Low Order Address):
    //low order address cursor
    WriteCommand(0b00001010);
    WriteData(0b00000000);
    //high order address cursor
    WriteCommand(0b00001011);
    WriteData(0b00000000);
//Clear Display
	ClrScr();
    //low order address cursor
    WriteCommand(0b00001010);
    WriteData(0b00000000);
    //high order address cursor
    WriteCommand(0b00001011);
    WriteData(0b00000000);
}
/*---------------------*/
void SetByteAdrCursor(int LowAdrByte,int HighAdrByte)
{
	//low order address cursor
    WriteCommand(0b00001010);
    WriteData(LowAdrByte);
    //high order address cursor
    WriteCommand(0b00001011);
    WriteData(HighAdrByte);
}
/*---------------------*/
void SetPixel(int x,int y,int color)
{
	unsigned int AdrByte;
	unsigned int AdrBit;
	unsigned int LowAdrByte;
	unsigned int HighAdrByte;
	//Controller LC7981 do horizontal paint
	AdrByte=(30*(y-1))+((x-1) / 8);
	AdrBit=((x-1) % 8);
	LowAdrByte=AdrByte;
	HighAdrByte=AdrByte >> 8;
	SetByteAdrCursor(LowAdrByte,HighAdrByte );
	//SetBit
	switch (color)
	{
		case 0://white pixel
             WriteCommand(0b00001110);
             WriteData(AdrBit);
			 break;
		case 1://black pixel
             WriteCommand(0b00001111);
             WriteData(AdrBit);
			 break;
	}
}
/*---------------------*/
void DrawRectangle(int x1,int y1,int width,int height,int color)
{
	unsigned int i;
	for (i=x1;i<x1+width-1;i++)
	{
		SetPixel(i,y1,color);
	}
    for (i=y1;i<y1+height-1;i++)
	{
		SetPixel(x1+width-1,i,color);
	}
    for (i=x1+width-1;i>x1;i--)
	{
	 	SetPixel(i,y1+height-1,color);
	}
    for (i=y1+height-1;i>y1;i--)
	{
		SetPixel(x1,i,color);
	}
}
/*---------------------*/
void DrawFillRectangle(int x1,int y1,int width,int height,int color)
{
	unsigned int i;
	unsigned int j;
	for (i=y1;i<y1+height;i++)
	{
		for (j=x1;j<x1+width;j++)
		{
			SetPixel(j,i,color);
		}
	}
}
/*---------------------*/
ISR(ADC_vect)
{
	ADC_Result=ADCH;
	LVLBat=ADC_Result/80;
	ADCSRA|=_BV(ADSC);
}
/*---------------------*/
void RefreshPower(int xb,int yb,int lvl)
{	
	DrawFillRectangle(1+xb,3+yb,1,7,1);
    DrawRectangle(2+xb,1+yb,18,11,1);
	switch (lvl)
	{
		case 0:
			DrawFillRectangle(3+xb,2+yb,15,9,0);
			break;
		case 1:
			DrawFillRectangle(14+xb,3+yb,4,7,1);
			DrawFillRectangle(3+xb,2+yb,10,9,0);	
			break;
		case 2:
			DrawFillRectangle(14+xb,3+yb,4,7,1);
			DrawFillRectangle(9+xb,3+yb,4,7,1);
			DrawFillRectangle(3+xb,2+yb,5,9,0);
			break;
		case 3:
			DrawFillRectangle(4+xb,3+yb,4,7,1);
			DrawFillRectangle(9+xb,3+yb,4,7,1);
			DrawFillRectangle(14+xb,3+yb,4,7,1);		
			break;
	};
}
/*---------------------*/
void ProgressBar(int xb2,int yb2,int num)
{
	unsigned int i;
	unsigned int counter;
	counter=3;
    DrawRectangle(1+xb2,1+yb2,(5*num)+3,11,1);
	for (i=0;i<num;i++)
	{
		DrawFillRectangle(counter+xb2,3+yb2,4,7,1);
		counter=counter+5;
		_delay_ms(100);
	}
	DrawFillRectangle(1+xb2,1+yb2,(5*num)+3,11,0);
}
/*---------------------*/
void ShowForm(int x1,int y1,int width,int height)
{
	x1=x1+2;
	y1=x1+2;
	width=width+8;
	height=height+8;
	DrawRectangle(x1-2,y1-2,width+4,height+4,0);
	DrawRectangle(x1,y1,width,height,1);
	DrawRectangle(x1-1,y1-1,width+2,height+2,1);
	DrawRectangle(x1+1,y1+1,width-2,height-2,0);
	DrawRectangle(x1+1,y1+1,width-2,5,0);
	DrawFillRectangle(x1+2,y1+2,width-4,3,1);
	DrawRectangle(x1+2,y1+6,width-4,height-8,1);
	DrawFillRectangle(x1+3,y1+7,width-6,height-10,0);
}
/***************************************************/
int main()
{	
	InitADC();
	InitPortsIO();
	InitLcdController();
	sei();
	DrawRectangle(1,1,240,128,1);
	DrawRectangle(1,1,240,17,1);
	ProgressBar(3,3,45);	
	DrawFillRectangle(3,19,236,108,1);
	ShowForm(25,25,150,80);	
	ProgressBar(3,3,20);
	while (1)
	{
		RefreshPower(215,3,LVLBat);	
		_delay_ms(500);
	}	
}
/***************************************************/
