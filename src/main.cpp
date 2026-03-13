#include "gpio.hpp"
#include "stm32f072xb.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

constexpr int led_pin = 5;
constexpr int delay_cycles = 500000;

void testCodeQL_buffOverFlow()
{
    char buf[8];
    strcpy(buf, "THIS STRING IS WAY TOO LONG");
}

auto main() -> int {

    // Test codeql analysis
    testCodeQL_buffOverFlow();

    gpio::enable_port_a();
    gpio::set_output(GPIOA, led_pin);

    while (true) {
        gpio::toggle(GPIOA, led_pin);

        for (volatile int i = 0; i < delay_cycles; ++i) {
        }
    }
}