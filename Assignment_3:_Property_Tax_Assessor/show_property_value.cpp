#include <cstdio>

extern "C" void display(double array[], int array_size);

// Display all elements of an array of floats
void display(double array[], int array_size) {

	for(int i = 0; i < array_size; i++) {
    printf("%.10lf\n", array[i]);
  }
}
