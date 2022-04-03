#include <cstdio>

extern "C" double triangle_calculator();

int main()
{
    // printf("Running ASM program...\n");
    double return_code = 0;
    printf("Welcome to Amazing Triangles programmed by Katie Tran.\n\n");
    return_code = triangle_calculator();
    printf("%s%1.10lf%s\n","The driver received this number ",return_code," and will simply keep it.\n\nAn integer zero will now be sent to the operating system. Have a good day. Bye");

    return 0;
}
