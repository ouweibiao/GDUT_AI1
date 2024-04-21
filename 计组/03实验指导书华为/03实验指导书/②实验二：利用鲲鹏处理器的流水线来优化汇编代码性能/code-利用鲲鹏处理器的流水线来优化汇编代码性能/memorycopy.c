#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define len 60000000
char src[len],dst[len];
long int len1=len;

extern void memorycopy(char *dst,char *src,long int len1);

int main()
{
    struct timespec t1,t2;
    int i,j;

for(i=0;i<len-1;i++)
{
src[i]='a';
}
src[i]=0;

clock_gettime(CLOCK_MONOTONIC,&t1);
memorycopy(dst,src,len1);
clock_gettime(CLOCK_MONOTONIC,&t2);

printf("memorycopy time is %11u ns\n",t2.tv_nsec-t1.tv_nsec);

    return 0;
}
