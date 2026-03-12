#!/bin/bash

set -e

echo "Configuring CMake..."

cmake -B build -DCMAKE_TOOLCHAIN_FILE=toolchain/arm-gcc-toolchain.cmake

echo "Running linting with clang-tidy..."

FILES=$(find src include -name "*.c" -o -name "*.cpp")

for file in $FILES
do
    clang-tidy -p build "$file"
done

echo "Clang-tidy finished."