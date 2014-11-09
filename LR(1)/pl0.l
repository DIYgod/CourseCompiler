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
	#include <string.h>
	#include "pl0.tab.h"
	#include "pl0.h"
	
	void yyerror(char *);
	
	int addvar(char *);
	int count = 0;
	int varCount = -1;
	
	varIndex iVar[50];
%}

%% 

[A-Za-z]([A-Za-z0-9])* {yylval = addvar(yytext); count++; printf("%d\t标识符\t%s\n", count, yytext); return Var;}
[0-9]+ {yylval = atoi(yytext); count++; printf("%d\t常数\t%s\n", count, yytext); return Constant;}
[-+*\=] {count++; printf("%d\t运算符\t%s\n", count, yytext); return *yytext;}
[()] {count++; printf("%d\t界符\t%s\n", count, yytext); return *yytext;}
[\n] {return *yytext;}
[" "\t]+ {/*去空格*/}
[^-+*\=()" "\t\nIdentfierConstant] {printf("\t\t%s\t", yytext); yyerror("无效字符");}

%%

int main(void) 
{
	yyin = fopen("test.txt", "r");
	yyparse();
	printf("查看所有变量：\n");
	for(int i = 0; i <= varCount; i++)
		printf("%s\t%d\n", iVar[i].name, iVar[i].value);
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