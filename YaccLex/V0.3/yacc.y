%{
	#include "head.h"

	
	int yylex(void);
	void yyerror(char *);
	char inter[30][5][10] = { {"(1)"},{"(2)"},{"(3)"},{"(4)"},{"(5)"},{"(6)"},{"(7)"},{"(8)"},{"(9)"},{"(10)"},{"(11)"},{"(12)"},{"(13)"},{"(14)"},{"(15)"},{"(16)"},{"(17)"},{"(18)"},{"(19)"},{"(20)"},{"(21)"},{"(22)"},{"(23)"},{"(24)"},{"(25)"},{"(26)"},{"(27)"},{"(28)"},{"(29)"},{"(30)"} };				//保存四元式
	int interstep = 0;			//四元式的当前步骤数
	int interassign1;			//assignment1的四元式步骤数
	int tempvarcount = 0;			//四元式临时变量数
	int boolfirststep = 0;			//布尔表达式四元式第一步步骤数
	int boollaststep = 0;			//布尔表达式四元式最后一步步骤数
	extern varIndex iVar[50];
%}

%token<id> Var 
%token<id> Constant
%type<name> exp
%type<booltype> bool
%right 'or'
%right 'and'
%right '='
%left '+' '-'
%left '*' '/'
%left '(' ')'

%%
program: 
	'if' '(' bool ')' 'then' assignment1 'else' assignment2 
		{
			printf("\n\n\nIntermediate code:\n");
			for (int i = 0; i < 20; i++)
			{
				for (int j = 0; j < 5; j++)
					printf("%s\t", inter[i][j]);
				printf("\n");
				if(strlen(inter[i][4])== 0)
					break;
			}
		}
	;
	
bool:
	'(' bool ')'
		{
			boolfirststep = $2.firststep;
			boollaststep = $2.laststep;
			$$.firststep = $2.firststep;
			$$.laststep = $2.laststep;
		}
	|bool 'and' bool
		{
			boolfirststep = $1.firststep;
			boollaststep = $3.laststep;
			$$.firststep = $1.firststep;
			$$.laststep = $3.laststep;
			for(int i = $1.firststep; i <= $1.laststep; i++)
			{
				if(!strcmp(inter[i][4], "true"))
				{
					strcpy(inter[i][4], inter[$3.firststep][0]);
				}
			}
		}
	|bool 'or' bool
		{
			boolfirststep = $1.firststep;
			boollaststep = $3.laststep;
			$$.firststep = $1.firststep;
			$$.laststep = $3.laststep;
			for(int i = $1.firststep; i <= $1.laststep; i++)
			{
				if(!strcmp(inter[i][4], "false"))
				{
					strcpy(inter[i][4], inter[$3.firststep][0]);
				}
			}
		}
	|Var '<' Var
		{
			boolfirststep = interstep;
			$$.firststep = interstep;
			strcpy(inter[interstep][1], "<"); 
			strcpy(inter[interstep][2], iVar[$1].name);
			strcpy(inter[interstep][3], iVar[$3].name);
			strcpy(inter[interstep][4], "true");
			interstep++;
			strcpy(inter[interstep][4], "false");
			boollaststep = interstep;
			$$.laststep = interstep;
			interstep++;
		}
		
	|Var '>' Var
		{
			boolfirststep = interstep;
			$$.firststep = interstep;
			strcpy(inter[interstep][1], ">"); 
			strcpy(inter[interstep][2], iVar[$1].name); 
			strcpy(inter[interstep][3], iVar[$3].name);
			strcpy(inter[interstep][4], "true");
			interstep++;
			strcpy(inter[interstep][4], "false");
			boollaststep = interstep;
			$$.laststep = interstep;
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
		}
	|
		{
			
			for(int i = boolfirststep; i <= boollaststep; i++)
			{
				if(!strcmp(inter[i][4], "true"))
				{
					strcpy(inter[i][4], inter[interstep][0]);
				}
			}
		}
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
		{
			for(int i = boolfirststep; i <= boollaststep; i++)
			{
				if(!strcmp(inter[i][4], "false"))
				{
					strcpy(inter[i][4], inter[interstep][0]);
				}
			}
		}
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
