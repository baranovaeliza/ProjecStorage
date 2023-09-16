#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#include <math.h>
#include "stackassociated.h"

char calculate(stack **curr, const char *exp) {
    int i;
    int n1;
    int n2;
    while (*exp != '\0') {
        if (isdigit(*exp)) {
            push(curr, *exp);
        } else {
            n1 = pop(curr) - 48;
            n2 = pop(curr) - 48;
            switch (*exp) {
                case '+':
                    push(curr, (char) (n1 + n2 + 48));
                    break;
                case '-':
                    push(curr, (char) (n1 - n2 + 48));
                    break;
                case '*':
                    push(curr, (char) (n1 * n2 + 48));
                    break;
                case '/':
                    push(curr, (char) (n1 / n2 + 48));
                    break;
            }
        }
        exp++;
    }
    return pop(curr);
}

void moveDisk(stack **curr1, stack **curr2) {
    int pin1TopDisk;
    int pin2TopDisk;
    pin1TopDisk = pop(curr1) - 48;
    pin2TopDisk = pop(curr2) - 48;

    if (pin1TopDisk == (CHAR_MIN - 48)) {
        push(curr1, (char) (pin2TopDisk + 48));
    } else if (pin2TopDisk == (CHAR_MIN - 48)) {
        push(curr2, (char) (pin1TopDisk + 48));
    } else if (pin1TopDisk > pin2TopDisk) {
        push(curr1, (char) (pin1TopDisk + 48));
        push(curr1, (char) (pin2TopDisk + 48));
    } else {
        push(curr2, (char) (pin2TopDisk + 48));
        push(curr2, (char) (pin1TopDisk + 48));
    }
}

void Hanoi(int n, int nMoves, stack **curr1, stack **curr2, stack **curr3) {
    int i, j;

    for (i = n; i >= 1; i--)
        push(curr1, (char) (i + 48));

    printf("starting state \n");
    stackPrint(*curr1);
    stackPrint(*curr2);
    stackPrint(*curr3);
    puts("");

    for (j = 1; j <= nMoves; j++) {
        if (j % 3 == 1)
            moveDisk(curr1, curr3);

        else if (j % 3 == 2)
            moveDisk(curr1, curr2);

        else if (j % 3 == 0)
            moveDisk(curr2, curr3);
        printf("move %d\n", j);
        stackPrint(*curr1);
        stackPrint(*curr2);
        stackPrint(*curr3);
        puts("");
    }
}