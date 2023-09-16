#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <string.h>
#include "snake.h"

void add_head(node **head, int x, int y, char orient) {
    node *tmp;
    tmp = NULL;
    if ((tmp = malloc(sizeof(node))) == NULL) {
        perror("malloc");
        exit(1);
    }
    tmp->x = x;
    tmp->y = y;
    tmp->orient = orient;
    tmp->next = NULL;
    if (*head == NULL) {
        *head = tmp;
    } else {
        tmp->next = *head;
        (*head) = tmp;
    }
}

int getX(node *head) {
    return head->x;
}

int getY(node *head) {
    return head->y;
}

void OffCanon() {
    struct termios raw;

    tcgetattr(STDIN_FILENO, &orig_termios);
    raw = orig_termios;
    raw.c_lflag &= ~(ECHO | ICANON);
    tcsetattr(STDIN_FILENO, TCSANOW, &raw);
}

void OnCanon() {
    struct termios raw;

    tcgetattr(STDIN_FILENO, &orig_termios);
    raw = orig_termios;
    raw.c_lflag |= (ECHO | ICANON);
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void initBoard() {
    memset(board, '_', WIDTH * HEIGHT);
}

void viewBoard() {
    int i;
    for (i = 0; i < HEIGHT; i++) {
        fwrite(&board[i * WIDTH], WIDTH, 1, stdout);
        fputc('\n', stdout);
    }
}

void snakeSymbol(node *head) {
    node *tmp1;
    tmp1 = head;

    while (tmp1 != NULL) {
        if (tmp1->next != NULL) {
            switch (tmp1->orient) {
                case 'u':
                    tmp1->next->x = getX(tmp1);
                    tmp1->next->y = getY(tmp1) + 1;
                    break;
                case 'd':
                    tmp1->next->x = getX(tmp1);
                    tmp1->next->y = getY(tmp1) - 1;
                    break;
                case 'r':
                    tmp1->next->x = getX(tmp1) - 1;
                    tmp1->next->y = getY(tmp1);
                    break;
                case 'l':
                    tmp1->next->x = getX(tmp1) + 1;
                    tmp1->next->y = getY(tmp1);
                    break;
            }
        }

        if (tmp1 != head) {
            node *tmp2;
            tmp2 = head;
            while (tmp2 != NULL) {
                if (tmp2->next == tmp1) {

                    if (tmp2->y < tmp1->y) tmp1->orient = 'u';
                    if (tmp2->y > tmp1->y) tmp1->orient = 'd';
                    if (tmp2->x > tmp1->x) tmp1->orient = 'r';
                    if (tmp2->x < tmp1->x) tmp1->orient = 'l';
                }
                tmp2 = tmp2->next;
            }
        }

        board[(tmp1->y * WIDTH) + tmp1->x] = '#';
        tmp1 = tmp1->next;
    }
}



void current() {
    if (input != 'q') {
        if (snakeHead->orient == 'u') snakeHead->y--;
        else if (snakeHead->orient == 'd') snakeHead->y++;
        else if (snakeHead->orient == 'r') snakeHead->x++;
        else if (snakeHead->orient == 'l') snakeHead->x--;

        board[(apple.y * WIDTH) + apple.x] = 'o';

        snakeSymbol(snakeHead);
        viewBoard();
        if (snakeHead->x == apple.x && snakeHead->y == apple.y){

            switch(snakeHead->orient){
                case 'u':
                    add_head(&snakeHead,snakeHead->x,snakeHead->y-1,snakeHead->orient);
                    break;
                case 'd':
                    add_head(&snakeHead,snakeHead->x,snakeHead->y+1,snakeHead->orient);
                    break;
                case 'r':
                    add_head(&snakeHead,snakeHead->x+1,snakeHead->y,snakeHead->orient);
                    break;
                case 'l':
                    add_head(&snakeHead,snakeHead->x-1,snakeHead->y,snakeHead->orient);
                    break;
            }

            apple.x = generateAppleX(snakeHead);
            apple.y = generateAppleY(snakeHead);
        }

        checkCrushing(snakeHead);

        if ((snakeHead->x >= WIDTH) || (snakeHead->x <0) ||
                (snakeHead->y >= HEIGHT) || (snakeHead->y < 0)) input = 'q';
    }
}

int generateAppleX(node *head){
    int flag = -1;
    int x;
    while (flag == -1){
        node *tmp;
        tmp = head;
        x = rand() % WIDTH;
        while (tmp != NULL){
            if (x == tmp->x) break;
            else flag = 0;
            tmp = tmp->next;
        }
    }
    return x;
}

int generateAppleY(node *head){
    int flag = -1;
    int y;
    while (flag == -1){
        node *tmp;
        tmp = head;
        y = rand() % HEIGHT;
        while (tmp != NULL){
            if (y == tmp->y) break;
            else flag = 0;
            tmp = tmp->next;
        }
    }
    return y;
}

void clear(){
    fprintf(stdout, "\033[2J");
    fprintf(stdout, "\033[H");
}

void checkCrushing(node *head){
    node *tmp;
    tmp = head;
    while(tmp != NULL){
        if(tmp != head){
            if (head->x == tmp->x && head->y == tmp->y){
                input = 'q';
                break;
            }
        }
        tmp = tmp-> next;
    }
}



