#include "gpio.hpp"
#include "stm32f072xb.h"

constexpr int LED_PIN = 5;

auto main() -> int {
    gpio::enable_port_a();
    gpio::set_output(GPIOA, LED_PIN);

    while (true) {
        gpio::toggle(GPIOA, LED_PIN);

        for (volatile int i = 0; i < 500000; ++i) {
        }
    }
}