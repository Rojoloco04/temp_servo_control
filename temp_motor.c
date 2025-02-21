#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	unsigned char input;
	
	// initialization
	DDRA = 0x00; // PA0 as input (sensor)
	DDRB = 0x08; // PB3 as output (motor)
	DDRD = 0xFF; // PORTD as output (LEDs)
	
	// PWM
	OCR0 = 9; // initial value of OCR0
	TCCR0 = 0x6C; // non-inverting mode, prescaler /256 (for 4MHz MCU)
	
	// ADC
	ADMUX = 0xE0; // 2.56V Vref, single-ended, left-justified
	ADCSRA = 0xB4; // enable ADC with prescaler /64
	SFIOR = SFIOR & 0x1F; // free running mode
	
	// looping segment
	while(1){
		ADCSRA |= (1<<ADSC); // start conversion
		while((ADCSRA&(1<<ADIF))==0); // wait for end of conversion
		input = ADCH; // input is the ADC result for temperature
		
		PORTD = ~input; // output temperature to LEDs
		
		// rotate motor based on temperature
		if(input>=0 && input<=31)
			OCR0 = 9;
		else if(input>=32 && input <= 40)
			OCR0 = 13;
		else if(input>=41 && input <= 50)
			OCR0 = 18;
		else if(input>=51 && input <= 60)
			OCR0 = 23;
		else if(input>=61 && input <= 70)
			OCR0 = 28;
		else if(input>=71 && input <= 80)
			OCR0 = 33;
		else if(input>=81 && input <= 90)
			OCR0 = 37;
		else
			OCR0 = 9; // else, set motor to 0 degrees
		
		ADCSRA = ADCSRA | 0x10;
	 }
	 return 0;
}
