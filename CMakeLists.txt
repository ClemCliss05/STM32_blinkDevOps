cmake_minimum_required(VERSION 3.20)

project(STM32_blinkDevOps C CXX ASM)

# ------------------------------------------------------------------------------
# Set flags
# ------------------------------------------------------------------------------

set(PROJECT_NAME STM32_blinkDevOps)

set(LINKER_SCRIPT
    ${CMAKE_SOURCE_DIR}/linker/STM32F072RBTx_FLASH.ld
)

set(MCU_FLAGS
    -mcpu=cortex-m0
    -mthumb
)

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

add_executable(${PROJECT_NAME}.elf)

target_link_libraries(${PROJECT_NAME}.elf PRIVATE
    mcu_config
)

# ------------------------------------------------------------------------------
# Source files
# ------------------------------------------------------------------------------

target_sources(${PROJECT_NAME}.elf PRIVATE
    src/main.cpp
    startup/startup_stm32f072xb.s
    drivers/CMSIS/Device/ST/STM32F0xx/Source/system_stm32f0xx.c
)

# ------------------------------------------------------------------------------
# Include directories
# ------------------------------------------------------------------------------

target_include_directories(${PROJECT_NAME}.elf PRIVATE
    drivers/CMSIS/Include
    drivers/CMSIS/Device/ST/STM32F0xx/Include
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
    -Wall # enable all warnings
    -Wextra # enable extra warnings
    -Wpedantic # enforce strict ISO compliance

    -O2 # optimize for size and speed
    -ffunction-sections # place each function in its own section for better dead code elimination
    -fdata-sections # place each data item in its own section for better dead code elimination

    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions> # disable C++ exceptions
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti> # disable C++ RTTI (Run-Time Type Information)
)

# ------------------------------------------------------------------------------
# Link options
# ------------------------------------------------------------------------------

target_link_options(${PROJECT_NAME}.elf PRIVATE
    -T${LINKER_SCRIPT}

    -Wl,--gc-sections # enable garbage collection of unused sections to reduce binary size
    -Wl,-Map=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.map # Generate .map with linker

    --specs=nano.specs # use newlib-nano for smaller footprint
    --specs=nosys.specs # replace _write, _read, _sbrk functions with stubs
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

# ------------------------------------------------------------------------------
# Flash target
# ------------------------------------------------------------------------------

add_custom_target(flash
    COMMAND JLinkExe
        -device STM32F072RB
        -if SWD
        -speed 4000
        -autoconnect 1
        -CommanderScript ${CMAKE_SOURCE_DIR}/scripts/flash.jlink
)