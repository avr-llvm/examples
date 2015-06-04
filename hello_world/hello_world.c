
#include <avr/io.h>
#include <util/delay.h>

const int DELAY_MS = 1000;

int do_something(int a) {
    return 2*a;
}

int main() {
    DDRB |= _BV(PB5);

    while(1) {
        PORTB |= _BV(PB5);

        _delay_ms(DELAY_MS);

        PORTB &= ~_BV(PB5);

        _delay_ms(DELAY_MS);
    }

    return 0;
}
