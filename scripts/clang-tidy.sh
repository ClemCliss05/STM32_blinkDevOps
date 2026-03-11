#!/bin/bash

echo "Running linting with clang-tidy..."

clang-tidy \
src/*.cpp \
-p build

echo "Clang-tidy finished."