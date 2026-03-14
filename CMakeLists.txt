cmake_minimum_required(VERSION 3.20)

project(STM32_blinkDevOps C CXX ASM)

# Language standards
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ------------------------------------------------------------------------------
# Project configuration
# ------------------------------------------------------------------------------

set(PROJECT_NAME STM32_blinkDevOps)

include(cmake/stm32_flags.cmake) # Include MCU-specific flags

set(LINKER_SCRIPT
    ${CMAKE_SOURCE_DIR}/linker/STM32F072RBTx_FLASH.ld
)

set(CMAKE_BUILD_TYPE Debug) # Use Debug for development to include debug symbols and disable optimizations

set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # Export compile commands for Clang-tidy

# ------------------------------------------------------------------------------
# MCU configuration library
# ------------------------------------------------------------------------------

add_library(mcu_config INTERFACE)

target_compile_options(mcu_config INTERFACE
    ${MCU_FLAGS}
)

target_link_options(mcu_config INTERFACE
    ${MCU_FLAGS}
)

# ------------------------------------------------------------------------------
# Firmware target
# ------------------------------------------------------------------------------

add_executable(${PROJECT_NAME}.elf
    src/main.cpp
    src/gpio.cpp
    startup/startup_stm32f072xb.s
    Drivers/CMSIS/Device/ST/STM32F0xx/Source/system_stm32f0xx.c
)

target_link_libraries(${PROJECT_NAME}.elf PRIVATE
    mcu_config
)

# ------------------------------------------------------------------------------
# Include directories
# ------------------------------------------------------------------------------

target_include_directories(${PROJECT_NAME}.elf PRIVATE
    include
    Drivers/CMSIS/Include
    Drivers/CMSIS/Device/ST/STM32F0xx/Include
)

# ------------------------------------------------------------------------------
# Preprocessor definitions
# ------------------------------------------------------------------------------

target_compile_definitions(${PROJECT_NAME}.elf PRIVATE
    STM32F072xB
)

# ------------------------------------------------------------------------------
# Compile options
# ------------------------------------------------------------------------------

target_compile_options(${PROJECT_NAME}.elf PRIVATE
    ${COMPILER_FLAGS}

    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions> # disable C++ exceptions
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti> # disable C++ RTTI (Run-Time Type Information)
)

# ------------------------------------------------------------------------------
# Link options
# ------------------------------------------------------------------------------

target_link_options(${PROJECT_NAME}.elf PRIVATE
    -T${LINKER_SCRIPT}

    ${LINKER_FLAGS}
)

# ------------------------------------------------------------------------------
# Post build: generate binary and hex
# ------------------------------------------------------------------------------

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    # binary
    COMMAND ${CMAKE_OBJCOPY} -O binary
            ${PROJECT_NAME}.elf
            ${PROJECT_NAME}.bin
    # hex
    COMMAND ${CMAKE_OBJCOPY} -O ihex
            ${PROJECT_NAME}.elf
            ${PROJECT_NAME}.hex
    # size
    COMMAND ${CMAKE_SIZE} 
            ${PROJECT_NAME}.elf
)