/* globalCalling.c*/
#include <stdio.h>
extern void strcpy1(char *d, const char *s);
int main()
{
    const char *srcstring="Source string";
    char dststring[]="Destination string";

    printf("Original Status: %s   %s\n",srcstring,dststring);
   strcpy1(dststring,srcstring);
   printf("Modified Status: %s   %s\n",srcstring,dststring);   
    return 0;
}

