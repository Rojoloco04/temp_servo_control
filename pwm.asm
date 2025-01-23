jmp init

.org 0x2A
init:
; set PIND as all inputs for use with switches
clr r16
out DDRD, r16
; initialize the stack pointer
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16
; initializing PWM system
sbi DDRB, 3 ; PB3 as output
ldi r20, 9
out OCR0, r20 ; starting 1ms pulse width, necessary to avoid hazard?
ldi r16, 0b01101100
out TCCR0, r16 ; non-inverting mode, prescaler /64

; main body
start:
; continuously check for switch press
loop:
in r20, PIND
cpi r20, 0b11111110
breq SW0
cpi r20, 0b11111101
breq SW1
cpi r20, 0b11111011
breq SW2
cpi r20, 0b11110111
breq SW3
cpi r20, 0b11101111
breq SW4
cpi r20, 0b11011111
breq SW5
cpi r20, 0b10111111
breq SW6
rjmp loop

SW0: ; pulse width 1ms
rcall release
ldi r20, 9
out OCR0, r20
rjmp loop

SW1: ; pulse width 1.17ms
rcall release
ldi r20, 13
out OCR0, r20
rjmp loop

SW2: ; pulse width 1.33ms
rcall release
ldi r20, 18
out OCR0, r20
rjmp loop

SW3: ; pulse width 1.5ms
rcall release
ldi r20, 23
out OCR0, r20
rjmp loop

SW4: ; pulse width 1.67ms
rcall release
ldi r20, 28
out OCR0, r20
rjmp loop

SW5: ; pulse width 1.84ms
rcall release
ldi r20, 33
out OCR0, r20
rjmp loop

SW6: ; pulse width 2 ms
rcall release
ldi r20, 37
out OCR0, r20
rjmp loop

; procedures

; release: wait for button to be released to prevent button bounce
release:
push r24

delay:
ldi r24, 100
delayLoop:
dec r24
brne delayLoop

in r20, PIND
cpi r20, 0xFF
brne delay

pop r24
ret

end: 
rjmp end
