#!/bin/bash

set e

echo "Running static analysis with cppcheck..."

mkdir -p build
cppcheck \
--enable=warning,style,performance,portability \
--inconclusive \
--std=c++17 \
--error-exitcode=1 \
--suppress=missingIncludeSystem \
-I src \
-I include \
src include

2> build/cppcheck-report.txt | 

echo "Cppcheck finished. Report saved to cppcheck-report.txt"