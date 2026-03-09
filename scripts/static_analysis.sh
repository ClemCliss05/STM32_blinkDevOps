#!/bin/bash

set e

echo "Running static analysis with cppcheck..."

cppcheck \
--enable=all \
--inconclusive \
--std=c++17 \
-I drivers/CMSIS/Include \
-I drivers/CMSIS/Device/ST/STM32F0xx/Include \
src \
2> cppcheck-report.txt

echo "Cppcheck finished. Report saved to cppcheck-report.txt"