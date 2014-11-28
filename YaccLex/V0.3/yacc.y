%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "head.h"

	
	int yylex(void);
	void yyerror(char *);
	char inter[20][5][10] = { {"(1)"},{"(2)"},{"(3)"},{"(4)"},{"(5)"},{"(6)"},{"(7)"},{"(8)"},{"(9)"},{"(10)"},{"(11)"},{"(12)"},{"(13)"},{"(14)"},{"(15)"},{"(16)"},{"(17)"},{"(18)"},{"(19)"},{"(20)"} };				//保存四元式
	int interstep = 0;			//四元式的步骤数
	int interassign1;			//assignment1的四元式步骤数
	int tempvarcount = 0;			//临时变量数
	
	extern varIndex iVar[50];
%}

%token<id> Var 
%token<id> Constant 
%token 'if'
%token 'then'
%token 'else'
%type<name> exp
%right '='
%left '+' '-'
%left '*' '/'
%left '(' ')'

%%
program: 
	'if' bool 'then' assignment1 'else' assignment2 
		{
			printf("\n\n\nIntermediate code:\n");
			for (int i = 0; i < 20; i++)
			{
				for (int j = 0; j < 5; j++)
					printf("%s\t", inter[i][j]);
				printf("\n");
				if(strlen(inter[i][1])== 0)
					break;
			}
		}
	;
	
bool:
	Var '<' Var	
		{
			strcpy(inter[interstep][1], "<"); 
			strcpy(inter[interstep][2], iVar[$1].name); 
			strcpy(inter[interstep][3], iVar[$3].name);
			interstep++;
		}
		
	|Var '>' Var
		{
			strcpy(inter[interstep][1], ">"); 
			strcpy(inter[interstep][2], iVar[$1].name); 
			strcpy(inter[interstep][3], iVar[$3].name);
			interstep++;
		}
	;
	
assignment1:
	assignment1 Var '=' exp ';'
		{
			interassign1 = interstep;
			strcpy(inter[interstep][1], "=");
			strcpy(inter[interstep][2], iVar[$2].name);
			strcpy(inter[interstep][3], $4);
			strcpy(inter[interstep][4], inter[interstep + 1][0]);
			interstep++;
			strcpy(inter[0][4], inter[interstep][0]);
		}
	| 
	;
	
assignment2:
	assignment2 Var '=' exp ';'
		{
			strcpy(inter[interstep][1], "=");
			strcpy(inter[interstep][2], iVar[$2].name);
			strcpy(inter[interstep][3], $4);
			strcpy(inter[interstep][4], inter[interstep + 1][0]);
			strcpy(inter[interassign1][4], inter[interstep + 1][0]);
			interstep++;
		}
	| 
	;
	
exp:
	Var {strcpy($$, iVar[$1].name);}
	|Constant {sprintf($$, "%d" , $1);}
	|'(' exp ')' {strcpy($$, $2);}
	|exp '+' exp 
		{
			strcpy(inter[interstep][1], "+");
			strcpy(inter[interstep][2], $1);
			strcpy(inter[interstep][3], $3);
			inter[interstep][4][0] = 't';
			inter[interstep][4][1] = '0' + tempvarcount;
			inter[interstep][4][2] = '\0';
			tempvarcount++;
			strcpy($$, inter[interstep][4]);
			interstep++;
		}
	|exp '-' exp
		{
			strcpy(inter[interstep][1], "-");
			strcpy(inter[interstep][2], $1);
			strcpy(inter[interstep][3], $3);
			inter[interstep][4][0] = 't';
			inter[interstep][4][1] = '0' + tempvarcount;
			inter[interstep][4][2] = '\0';
			tempvarcount++;
			strcpy($$, inter[interstep][4]);
			interstep++;
		}
	|exp '*' exp
		{
			strcpy(inter[interstep][1], "*");
			strcpy(inter[interstep][2], $1);
			strcpy(inter[interstep][3], $3);
			inter[interstep][4][0] = 't';
			inter[interstep][4][1] = '0' + tempvarcount;
			inter[interstep][4][2] = '\0';
			tempvarcount++;
			strcpy($$, inter[interstep][4]);
			interstep++;
		}
	|exp '/' exp
		{
			strcpy(inter[interstep][1], "/");
			strcpy(inter[interstep][2], $1);
			strcpy(inter[interstep][3], $3);
			inter[interstep][4][0] = 't';
			inter[interstep][4][1] = '0' + tempvarcount;
			inter[interstep][4][2] = '\0';
			tempvarcount++;
			strcpy($$, inter[interstep][4]);
			interstep++;
		}
	;

%%

void yyerror(char *s)
{
	printf("%s\n", s);
}
