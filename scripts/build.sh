#!/bin/bash

set -e

cmake -B build \
-DCMAKE_TOOLCHAIN_FILE=toolchain/arm-gcc-toolchain.cmake

cmake --build build