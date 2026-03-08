# JLink flash script for STM32F072RB
r # Reset
loadfile build/stm32Blink.elf # flash
r 
g # go to main function --> run
exit