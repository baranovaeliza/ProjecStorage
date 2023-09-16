#include <termios.h>

#define  WIDTH 40
#define HEIGHT 20

typedef struct Node {
    int x;
    int y;
    char orient; /* направление головы: вправо (r), влево (l),
 * вниз (d), вверх(u)*/
    struct Node *next;
} node;

typedef struct Apple {
    int x;
    int y;
} apples;

void add_head(node **head, int x, int y, char orient);

int getX(node *node);

int getY(node *node);


apples apple;
node *snakeHead;
char input;
char board[WIDTH * HEIGHT];
struct termios orig_termios;


void OffCanon();

void OnCanon();

void initBoard();

void viewBoard();

void snakeSymbol(node *head);

void current();

void clear();

int generateAppleY(node *head);

int generateAppleX(node *head);

void checkCrushing(node *head);