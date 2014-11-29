:octocat: Compiler
=======

赋值语句语法分析的两种实现—LR(1)分析法和Yacc Lex自动构造工具

编译原理课程实践
------------

对于常用高级语言（如Pascal、C语言）的源程序从左到右进行扫描，把其中赋值语句用所学过的语法分析方法进行语法分析，判断语句的语法是否正确，如果错误指出错误类型，输出分析过程。

使用Yacc Lex自动构造工具的实现
-------

+ 编译说明：
```
	flex lex.l
	bison -d yacc.y
	删除 yacc.tab.h 第56行: extern YYSTYPE yylval;
	gcc -std=c99 head.h lex.yy.c yacc.tab.c
	./a.out
```
+ 文件说明：
```
	lex.l:                lex程序文件。
	yacc.y:               yacc程序文件。
	head.h:               lex.l和yacc.y共同使用的头文件。
	lex.yy.c:             用lex编译lex.l后生成的C文件。
	yacc.tab.c:           用yacc编译yacc.y后生成的C文件。
	yacc.tab.h:           用yacc编译yacc.y后生成的C头文件，内含%token、YYSTYPE、yylval等定义，供lex.yy.c和yacc.tab.c使用。
	test.txt:             被解析的文本示例。
```
+ 版本说明： 
```
	V0.1 词法分析  V0.2 增加语法分析  V0.3 增加语义分析
```
+ 更新日志：
```
	Update 2014.11.28  实现语义分析
	Update 2014.11.29  移植到Linux；实现多条赋值语句的语义分析
	Update 2014.11.29  实现对带 "or" "and" 的布尔表达式的语义分析
```
+ 语义分析效果

输入：
```
if (a>b and c<a or c<d and c>a)
then 
	a=3+(7*8);
	c=a+b; 
else 
	b=4+7*9;
	test1=9*1+3;
```
输出：
![image](http://raw.github.com/DIYgod/Compiler/master/YaccLex/SemanticAnalysis.png)

LR(1)分析法的实现
-------

+ 文件说明：
```
	lex.cpp 进行词法分析
	syn.cpp 调用 lex.cpp 并进行语法分析
	test.txt 被解析的文本示例
```
+ 更新日志：
```
	Update 2014.11.24  对语法分析模块略改动，实现自定义文法
```


Blog
-------
+ [Anotherhome](http://www.anotherhome.net)
