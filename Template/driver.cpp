#include <stdio.h>
#include <stdint.h>

// #include <cstdio> // <stdio.h> works too!

// extern double if program is supposed to return a number
extern "C" double asm_program();

int main()
{// if we are returning a number
	double return_code = -99.99;
	return_code = asm_program();
	printf("%s%1.18lf%s\n","The driver received return code ",return_code,".\nThe driver will now return 0 to the OS.  Bye.");

	return 0;

	// this will also work
	// printf("This is your message\n");
	// printf("The main program will now call the asm_program function\n");
	// if we are returning a string
	// char *result_code = asm_program();
	// printf("\nString returned is: %s\n", string_returned);
	// printf("\nThis string was returned from assembly!\n");
	// printf("\nZero will be returned to the OS.\n");
	// return 0;
}
