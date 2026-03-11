# JLink flash script for STM32F072RB
r # Reset
loadfile build/STM32_blinkDevOps.elf # flash
r 
g # go to main function --> run
exit