#!/bin/bash

#Program name: program_name

#Author: Katie Tran

#Clear any Previously compiled ouputs
rm *.o
rm *.out
rm *.lis

# you do this for each .asm file
echo "Assembling .asm file"
nasm -f elf64 -l asm_program.lis -o asm_program.o asm_program.asm

# You do this for each .c or .cpp files only difference is specifiying the version -std=c++17 or -std=c11
echo "compile .cpp using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o driver.o driver.cpp -std=c++17

# Include all the .o files mentioned in the assemble and compile commands
echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o example.out asm_program.o driver.cpp -std=c++17

echo "Running Program:"
./example.out

# For cleaner working directory, you can:
# rm *.lis
# rm *.o
# rm *.out

echo "Script file terminated."
