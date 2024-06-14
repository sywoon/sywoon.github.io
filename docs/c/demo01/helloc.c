
#include <stdio.h>


int main()
{
    const char* msg[] = {"Hello", "C++", "World", "from", "VS Code", "and the C++ extension!"};

    for (int i = 0; i < sizeof(msg)/sizeof(msg[0]); i++)
    {
        printf("%s ", msg[i]);
    }
    printf("\n");
}