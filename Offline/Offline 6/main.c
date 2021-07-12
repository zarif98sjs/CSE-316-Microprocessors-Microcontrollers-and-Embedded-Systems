
#ifndef F_CPU
#define F_CPU 16000000UL // 16 MHz clock speed
#endif


#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#include <avr/io.h>
#include <stdlib.h>
#include <util/delay.h>
#include "lcd.h"


#include <avr/io.h>

static char outstr[15];

int main(void)
{
	unsigned char hi,lo;
	unsigned int res;
	
	DDRD = 0xFF;
	DDRC = 0xFF;
	
	ADMUX  = 0b00100010;
	ADCSRA = 0b10000101;

	Lcd4_Init();
	
	while(1)
	{
		Lcd4_Set_Cursor(1,1);
		
		ADCSRA |= (1<<ADSC);
		
		while(ADCSRA & (1<<ADSC)) {;}
			
		lo = ADCL;
		hi = ADCH;
		
		res = hi;
		res = res << 8;
		res |= lo;
		res = res >> 6;
		
		float volt = res * 3.5 / 1024; 
		
		dtostrf(volt,7, 2, outstr);
		Lcd4_Write_String("Voltage:");
		Lcd4_Write_String(outstr);
		
	}
}