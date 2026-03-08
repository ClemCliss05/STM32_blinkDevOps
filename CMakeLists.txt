cmake_minimum_required(VERSION 3.20)
project(STM32Blink C CXX ASM)


# 1) set flags
set(MCU_FLAGS
    -mcpu=cortex-m0
    -mthumb # Cortex-M0 architecture
)
set(LINKER_SCRIPT
    ${CMAKE_SOURCE_DIR}/linker/STM32F072RBTx_FLASH.ld
)
set(PROJECT_NAME
    stm32Blink
)


# 2) create executable
add_executable(${PROJECT_NAME}.elf)


# 3.1) specify source files
target_sources(${PROJECT_NAME}.elf PRIVATE
    src/main.cpp
    startup/startup_stm32f072xb.s
    drivers/CMSIS/Device/ST/STM32F0xx/Source/system_stm32f0xx.c
)
# 3.2) specify include directories
target_include_directories(${PROJECT_NAME}.elf PRIVATE
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Include
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Device/ST/STM32F0xx/Include
)
# 3.3) specify preprocessor definitions
target_compile_definitions(${PROJECT_NAME}.elf PRIVATE
    STM32F072xB
)


# 4.1) specify compile options
target_compile_options(${PROJECT_NAME}.elf PRIVATE
    ${MCU_FLAGS} # target-specific flags for ARM Cortex-M0
    -O2 # optimize for size and speed
    -ffunction-sections # place each function in its own section for better dead code elimination
    -fdata-sections # place each data item in its own section for better dead code elimination
    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions> # disable C++ exceptions
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti> # disable C++ RTTI (Run-Time Type Information)
)
# 4.2) specify link options
target_link_options(${PROJECT_NAME}.elf PRIVATE
    ${MCU_FLAGS}
    -T${LINKER_SCRIPT}
    -Wl,--gc-sections # enable garbage collection of unused sections to reduce binary size
    --specs=nano.specs # use newlib-nano for smaller footprint
    --specs=nosys.specs # replace _write, _read, _sbrk functions with stubs
)


# 5.1) Add a post-build step to convert the ELF file to a binary format
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
)
# 5.2) Add a custom target for flashing the binary using JLink
add_custom_target(flash
    COMMAND JLinkExe -device STM32F072RB
                     -if SWD
                     -speed 4000
                     -autoconnect 1
                     -CommanderScript ${CMAKE_SOURCE_DIR}/scripts/flash.jlink
)