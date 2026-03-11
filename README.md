# STM32 Blink – CMake Firmware

Minimal STM32F072 blink firmware using a modern CMake build system.

## Hardware

- MCU: STM32F072RB
- Board: Nucleo-F072RB
- Debugger: J-Link

## Toolchain

ARM GCC Toolchain:  
arm-none-eabi-gcc

## Build

cmake -B build -DCMAKE_TOOLCHAIN_FILE=toolchain/arm-gcc-toolchain.cmake  
cmake --build build

## Output

build/  
 ├── stm32Blink.elf  
 └── stm32Blink.bin

 ## Flash

Example using J-Link:  
 ./scripts/flash_jlink.sh

 ## Project Structure

- Drivers/     CMSIS and device headers  
- src/         firmware source  
- startup/     startup assembly  
- linker/      linker script  
- toolchain/   cross compilation toolchain  
- cmake/       custom cmake modules

## Goals

This project is used to learn:

- embedded C++
- CMake
- DevOps / DevSecOps workflows
- firmware CI/CD