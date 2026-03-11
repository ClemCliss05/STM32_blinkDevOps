#!/bin/bash

echo "Running formatting with clang-format..."

clang-format -i src/*.cpp include/*.hpp

echo "Clang-format finished."