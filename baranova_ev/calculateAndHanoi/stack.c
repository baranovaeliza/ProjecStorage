#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <limits.h>
#include "stack.h"

int isFull(stack *curr){
    stack *p;
    int count;
    p = curr;
    count = 0;
    while (p != NULL) {
        p = p->next;
        count ++;
    }
    return count==BUFFER;
}

int isEmpty(stack **curr){
    if (*curr == NULL){
        return 1;
    }
    return 0;
}

void push(stack **curr,char data){
    stack *tmp;
    tmp = NULL;
    if ((tmp = malloc(sizeof(stack))) == NULL) {
        perror("malloc");
        exit(1);
    }
    if (isFull(*curr)){
        perror("stack overflow");
        exit(1);
    }
    tmp->data = data;
    tmp->next = NULL;
    if (*curr == NULL) {
        *curr = tmp;
    } else {
        tmp->next = *curr;
        (*curr) = tmp;
    }
}

char pop(stack **curr) {
    char res;
    if (*curr == NULL) {
        return CHAR_MIN;
    }
    res = (*curr)->data;
    stack *new_first = (*curr)->next;
    free(*curr);
    *curr = new_first;
    return res ;
}

char top(stack **curr){
    return (*curr)->data;
}

void stackPrint(stack *curr) {
    stack *p;
    p = curr;
    if (isEmpty(&p))
        printf("it's empty!");
    while (p != NULL) {
        printf("%c ", p->data);
        p = p->next;
    }
    puts("");
}