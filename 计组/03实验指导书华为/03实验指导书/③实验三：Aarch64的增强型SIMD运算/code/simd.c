#include <stdio.h>
#include <arm_neon.h>
static void matrix_mul_asm(uint16_t **aa,uint16_t **bb,uint16_t **cc)
{
	uint16_t *a=(uint16_t *)aa;
	uint16_t *b=(uint16_t *)bb;
	uint16_t *c=(uint16_t *)cc;

	__asm__ __volatile__ (
		"ld4 {v0.4h-v3.4h},[%0]\n"
		"ld4 {v4.4h,v5.4h,v6.4h,v7.4h},[%1]\n"

		"mul v3.4h,v3.4h,v7.4h\n"
		"mul v2.4h,v2.4h,v6.4h\n"
		"mul v1.4h,v1.4h,v5.4h\n"
		"mul v0.4h,v0.4h,v4.4h\n"

		"st4 {v0.4h,v1.4h,v2.4h,v3.4h},[%2]\n"

		:"+r"(a),"+r"(b),"+r"(c)
		:
		:"cc","memory","v0","v1","v2","v3","v4","v5","v6","v7"

	);
}

int main()
{
	uint16_t aa[4][4]={
		{1,2,3,4},
		{5,6,7,8},
		{3,6,8,1},
		{2,6,7,1}
	};

	uint16_t bb[4][4]={
		{1,3,5,7},
		{2,4,6,8},
		{2,5,7,9},
		{5,2,7,1}
	};

	uint16_t cc[4][4]={0};
	int i,j;

       matrix_mul_asm((uint16_t **)aa,(uint16_t **)bb,(uint16_t **)cc);

for(i=0;i<4;i++)
for(j=0;j<4;j++)
printf("out is %11u \n",cc[i][j]);

return 0;
}