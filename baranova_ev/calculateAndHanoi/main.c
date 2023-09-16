#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <math.h>
#include "stackassociated.h"


int main(int argc, char *argv[]) {
    stack *pin1,*pin2,*pin3;
    int nMoves,n;
    stack *calc;
    char *exp = "231*+";
    	
	long long int j;
	for (j = 0;j<100000000;j++) printf("%lld",j);
	
    printf("expression to calculate: %s\n",exp);
    printf("result: %c \n", calculate(&calc,exp));
    /* количество дисков */
    n = 4;
    nMoves = (int)(pow(2,n))-1;
    pin1 = NULL;
    pin2 = NULL;
    pin3 = NULL;
    /* каждый раз на экран выводится текущее состояние
     * каждого стержня*/
    Hanoi(n,nMoves,&pin1,&pin2,&pin3);
    return 0;
}
