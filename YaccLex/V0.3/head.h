#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
	int value;
	char name[10];
} varIndex;

typedef struct
{  
    char name[20];
    int id;
} yys; 

#define YYSTYPE yys

extern YYSTYPE yylval;
