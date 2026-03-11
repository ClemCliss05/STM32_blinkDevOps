#!/bin/bash

set -e

BUILD_DIR=build
ELF_FILE=$BUILD_DIR/STM32_blinkDevOps.elf

build() {
    cmake -B $BUILD_DIR \
    -DCMAKE_TOOLCHAIN_FILE=toolchain/arm-gcc-toolchain.cmake

    cmake --build $BUILD_DIR
}

flash() {

    JLinkExe \
    -device STM32F072RB \
    -if SWD \
    -speed 4000 \
    -autoconnect 1 \
    -CommanderScript scripts/flash.jlink
}

clean() {
    rm -rf $BUILD_DIR
}

case "$1" in
    flash)
        build
        flash
        ;;
    clean)
        clean
        ;;
    *)
        build
        ;;
esac