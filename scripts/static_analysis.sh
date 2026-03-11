#!/bin/bash

set e

echo "Running static analysis with cppcheck..."

mkdir -p build
cppcheck \
--enable=all \
--inconclusive \
--std=c++17 \
--force \
--error-exitcode=1 \
-Iinclude \
-Isrc \
--suppress=missingIncludeSystem \
src include
2> build/cppcheck-report.txt

echo "Cppcheck finished. Report saved to cppcheck-report.txt"