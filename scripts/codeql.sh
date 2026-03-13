#!/bin/bash
set -e

DB=build/codeql-db

echo "Configuring project"

cmake -B build \
-DCMAKE_TOOLCHAIN_FILE=toolchain/arm-gcc-toolchain.cmake \
-DCMAKE_EXPORT_COMPILE_COMMANDS=ON

echo "Cleaning database"
rm -rf $DB

echo "Creating CodeQL database"

codeql database create $DB \
--language=cpp \
--command="cmake --build build -j2"

echo "Running security analysis"

codeql database analyze $DB \
codeql/cpp-queries:codeql-suites/cpp-security-extended.qls \
--threads=1 \
--ram=1500 \
--format=sarif-latest \
--output=build/codeql-results.sarif

echo "Analysis finished"