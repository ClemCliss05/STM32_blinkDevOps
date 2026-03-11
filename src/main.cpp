#include "gpio.hpp"

int main() {

    gpio::enable_port_a();
    gpio::set_output(GPIOA, 5);

    while (1) {

        gpio::toggle(GPIOA, 5);

        for (volatile int i = 0; i < 500000; i++)
            ;
    }
}