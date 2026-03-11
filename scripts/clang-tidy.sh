#!/bin/bash

set -e

echo "Configuring CMake..."

cmake -B build -DCMAKE_TOOLCHAIN_FILE=toolchain/arm-gcc-toolchain.cmake

echo "Running linting with clang-tidy..."

run-clang-tidy -p build -quiet

echo "Clang-tidy finished."