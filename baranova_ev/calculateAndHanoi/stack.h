#define BUFFER 256

typedef struct Stack {
    char data;
    struct Stack *next;
} stack;

int isFull(stack *curr);

int isEmpty(stack **curr);

void push(stack **curr, char data);

char pop(stack **curr);

char top(stack **curr);

void stackPrint(stack *curr);