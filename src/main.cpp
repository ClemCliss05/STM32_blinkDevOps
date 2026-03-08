#include "stm32f072xb.h"

int main()
{
    // enable GPIOA clock
    RCC->AHBENR |= RCC_AHBENR_GPIOAEN;

    // PA5 output
    GPIOA->MODER |= (1 << (5 * 2));

    while (1)
    {
        GPIOA->ODR ^= (1 << 5);

        for (volatile int i = 0; i < 500000; i++);
    }
}