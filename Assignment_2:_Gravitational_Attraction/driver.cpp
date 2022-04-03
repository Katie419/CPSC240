#include <stdio.h>
#include <stdint.h>

extern "C" double gravity();

int main()
{
	double return_code = -99.99;                              

	printf("Welcome to Gravitational Attraction maintained by Katie Tran\n");
	return_code = gravity();
	printf("The main driver received this number %.9lf and will simply keep it.",return_code);
	printf("The driver will now send integer 0 to the operating system.  Have a nice day.  Bye.");
	return 0;

}
