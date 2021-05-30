/*
 * Code.c
 *
 * Created: 4/8/2021 8:24:17 PM
 * Author : Zarif
 */ 

#define F_CPU 1000000 // Clock Frequency

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>

int mode_type = 0;

/*Interrupt Service Routine for INT0*/
ISR(INT0_vect)
{
	mode_type ^= 1;		/* Toggle PORTC */
	_delay_ms(50);  	/* Software debouncing control delay */
	
}

int main(void)
{
    /* Replace with your application code */
	
	DDRA = 0xFF;
	DDRB = 0xFF;
	DDRD = 0;	// input	
	
	unsigned char col[] = {0b00000000,0b11111011,0b11111011,0b11011011,0b11011011,0b11011111,0b11011111,0b00000000};
		
	int nc = 8;
	int k = 0;
	
	GICR = 1<<INT0;		/* Enable INT0*/
	MCUCR = 1<<ISC01 ;  /* Trigger INT0 on falling edge */
	sei();	
	
    while (1) 
    {
		
		if(mode_type==0)
		{
			// stable
			for(int i=0;i<nc;i++){
						
				PORTA = (1<<((i-k+nc)%nc));
				PORTB  = ~col[i];
				_delay_ms(5);
			}
		}
		else
		{
			// rotate
					
			for(int count = 0; count<10; count++)
			{
				for(int i=0;i<nc;i++){
							
					PORTA = (1<<((i-k+nc)%nc));
					PORTB  = ~col[i];
					_delay_ms(5);
				}
			}
					
			k = (k+1)%nc;
		}
    }
}

