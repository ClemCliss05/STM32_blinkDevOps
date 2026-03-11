set(MCU_FLAGS
    -mcpu=cortex-m0
    -mthumb
)

set(COMPILER_FLAGS
    -Wall # enable all warnings
    -Wextra # enable extra warnings
    -Wpedantic # enforce strict ISO compliance

    -O2 # optimize for size and speed
    -g3 # include debug symbols
    -ffunction-sections # place each function in its own section for better dead code elimination
    -fdata-sections # place each data item in its own section for better dead code elimination
)

set(LINKER_FLAGS
    -Wl,--gc-sections # enable garbage collection of unused sections to reduce binary size
    -Wl,-Map=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.map # Generate .map with linker

    --specs=nano.specs # use newlib-nano for smaller footprint
    --specs=nosys.specs # replace _write, _read, _sbrk functions with stubs
)