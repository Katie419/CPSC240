#!/bin/bash

#Title: BASH compile for C++

rm *.o
rm *.out

echo "Compiling files... "

echo "Assembling code.asm file"
nasm -f elf64 -o compute_triangle.o compute_triangle.asm

echo "compile driver.cpp using gcc compiler standard 2017"
g++ -c -m64 -std=c++17 -fno-pie -no-pie -o driver.o driver.cpp

echo "Link object files using the gcc Linker standard 2017"
g++ -m64 -std=c++17 -fno-pie -no-pie -o application.out compute_triangle.o driver.o

echo "Running program."
./application.out
