%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "pl0.tab.h"
	
	typedef struct {
	int value;
	char name[10];
} varIndex;
	
	void yyerror(char *);
	
	int addvar(char *);
	int count = 0;
	int varCount = -1;
	
	varIndex iVar[50];
%}

%% 

if|then|else {count++; printf("%d\t保留字\t%s\n", count, yytext); return *yytext;}
[A-Za-z]([A-Za-z0-9])* {yylval.id = addvar(yytext); count++; printf("%d\t标识符\t%s\n", count, yytext); return Var;}
[0-9]+ {yylval.id = atoi(yytext); count++; printf("%d\t常数\t%s\n", count, yytext); return Constant;}
[-+*\=<>] {count++; printf("%d\t运算符\t%s\n", count, yytext); return *yytext;}
[();] {count++; printf("%d\t界符\t%s\n", count, yytext); return *yytext;}
[\n] {return *yytext;}
[" "\t]+ {/*去空格*/}
[^-+*\=()<>;" "\t\nIdentfierConstant] {printf("\t\t%s\t", yytext); yyerror("无效字符");}

%%

int main(void) 
{
	yyin = fopen("test.txt", "r");
	yyparse();
	fclose(yyin);
	system("PAUSE");
	return 0;
}

int addvar(char *in)
{
	for(int i = 0; i <= varCount; i++)
	{
		if(!strcmp(iVar[i].name, in))
			return i;
	}
	varCount++;
	strcpy(iVar[varCount].name, in);
	iVar[varCount].value = 0;
	return varCount;
}

 int yywrap(void)
 { 
 	return 1; 
 }