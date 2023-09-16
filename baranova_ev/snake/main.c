#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include "snake.h"

int main(int argc, char *argv[]) {
    snakeHead = NULL;

    extern apples apple;
    extern node *snakeHead;
    extern char input;
    extern char board[WIDTH * HEIGHT];

    srand(time(NULL));
    apple.x = 8;
    apple.y = 8;
    add_head(&snakeHead, 20, 20, 'u');
    OffCanon();
    input = 'w';
    fcntl(0, F_SETFL, fcntl(0, F_GETFL, 0) | O_NONBLOCK);
    fprintf(stdout,"commands: \nq=quit\nmoves:\nw=up\na=left\ns=down\nd=right\n");
    sleep(5);
    while (input != 'q') {
        clear();
        initBoard();
        current();
        if (input == 'q') break;
        input = getc(stdin);
        switch (input) {
            case 'w':
                if (snakeHead->orient != 'd') {
                    snakeHead->orient = 'u';
                    break;
                }
                break;
            case 's':
                if (snakeHead->orient != 'u') {
                    snakeHead->orient = 'd';
                    break;
                }
                break;
            case 'd':
                if (snakeHead->orient != 'l') {
                    snakeHead->orient = 'r';
                    break;
                }
                break;
            case 'a':
                if (snakeHead->orient != 'r') {
                    snakeHead->orient = 'l';
                    break;
                }
                break;

        }
        clear();
        usleep(144000);
    }
    clear();
    OnCanon();
    return 0;
}