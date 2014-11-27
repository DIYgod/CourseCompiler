/**
*
*----------Dragon be here!----------/
* 　　　┏┓　　　┏┓
* 　　┏┛┻━━━┛┻┓
* 　　┃　　　　　　　┃
* 　　┃　　　━　　　┃
* 　　┃　┳┛　┗┳　┃
* 　　┃　　　　　　　┃
* 　　┃　　　┻　　　┃
* 　　┃　　　　　　　┃
* 　　┗━┓　　　┏━┛
* 　　　　┃　　　┃神兽保佑
* 　　　　┃　　　┃代码无BUG！
* 　　　　┃　　　┗━━━┓
* 　　　　┃　　　　　　　┣┓
* 　　　　┃　　　　　　　┏┛
* 　　　　┗┓┓┏━┳┓┏┛
* 　　　　　┃┫┫　┃┫┫
* 　　　　　┗┻┛　┗┻┛
* ━━━━━━神兽出没━━━━━━
*/
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "pl0.h"

	
	int yylex(void);
	void yyerror(char *);
	
	extern varIndex iVar[50];
%}

%token Var Constant WhiteSpace
%right '='
%left '+' '-'
%left '*' '/'
%left '(' ')'

%%

program: 
	program Var '=' exp {iVar[$2].value = $4; printf("%s 赋值为 %d 成功！\n\n", iVar[$2].name, $4);}
	|program '\n'
	|
	;
	
exp:
	Constant {$$ = $1;}
	|Var {$$ = iVar[$1].value;}
	|'(' exp ')' {$$ = $2;}
	|exp '+' exp {$$ = $1 + $3;}
	|exp '-' exp {$$ = $1 - $3;}
	|exp '*' exp {$$ = $1 * $3;}
	|exp '/' exp {$$ = $1 / $3;}
	
%%

void yyerror(char *s)
{
	printf("%s\n", s);
}