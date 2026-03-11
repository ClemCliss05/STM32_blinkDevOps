#include "gpio.hpp"

namespace gpio {

void enable_port_a() {
    RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
}

void set_output(GPIO_TypeDef* port, uint8_t pin) {
    port->MODER |= (1 << (pin * 2));
}

void toggle(GPIO_TypeDef* port, uint8_t pin) {
    port->ODR ^= (1 << pin);
}

} // namespace gpio