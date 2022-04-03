#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

extern "C" double manager();

int main()
{
  double return_code = -99.99;
  const char* month[12] = {"January", "February", "March", "April","May", "June", "July", "August","September", "October", "November", "December"};

  time_t t = time(NULL);
  struct tm tm = *localtime(&t);

  printf("Welcome to the Orange County Property Assessment Office on %s %d, %02d.\n", month[(tm.tm_mon + 1)],tm.tm_mday, tm.tm_year + 1900);
  printf("For assistance contact Katie Tran at katiet419@csu.fullerton.edu\n");

	return_code = manager();

	printf("%s%1.18lf%s\n","The Assessor’s Office received this number ",return_code," and will keep it.\n");
  printf("Next an integer 0 will be sent to the operating system as a signal of successful completion.");
	return 0;

}
