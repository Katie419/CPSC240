#!/bin/bash

#Program name: program_name

#Author: Katie Tran

#Clear any Previously compiled ouputs
rm *.o
rm *.out
rm *.lis

# you do this for each .asm file
echo "Assembling manager.asm file"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assembling get_assessed_values.asm"
nasm -f elf64 -l get_assessed_values.lis -o get_assessed_values.o get_assessed_values.asm

echo "Assembling sum_value.asm"
nasm -f elf64 -l sum_value.lis -o sum_value.o sum_value.asm

echo "compile isfloat.cpp"
g++ -c -Wall -m64 -no-pie -o isfloat.o isfloat.cpp -std=c++17

echo "compile show_property_value.cpp"
g++ -c -Wall -m64 -no-pie -o show_property_value.o show_property_value.cpp -std=c++17

# You do this for each .c or .cpp files only difference is specifiying the version -std=c++17 or -std=c11
echo "compile assessor.cpp using gcc compiler standard 2017"
g++ -c -Wall -m64 -no-pie -o assessor.o assessor.cpp -std=c++17

echo "compile .cpp using gcc compiler standard 2017"
g++ -c -Wall -m64 -no-pie -fno-pie -o isfloat.o isfloat.cpp

# Include all the .o files mentioned in the assemble and compile commands
echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o result.out manager.o get_assessed_values.o sum_value.o isfloat.o show_property_value.o assessor.o -std=c++17

echo "Running Program:"
./result.out

# For cleaner working directory, you can:
# rm *.lis
# rm *.o
# rm *.out
