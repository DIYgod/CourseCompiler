Parsing
=======

赋值语句语法分析的两种实现—LR(1)分析法和Yacc Lex自动构造工具

&nbsp;

<span style="font-size: 12pt;"><strong>Yacc Lex自动构造工具的实现:</strong></span>

pl0.h 为Yacc的源文件，生成pl0.tab.c

pl0.l 为Lex的源文件，生成lex.yy.c

pl0.tab.c lex.yy.c pl0.h联合编译出a.exe

从test.txt输入

<span style="font-size: 12pt;"><strong>LR(1)分析法的实现:</strong></span>

lex.cpp 进行词法分析

syn.cpp 调用 lex.cpp 并进行语法分析

从test.txt输入

&nbsp;

博客：<a href="http://www.anotherhome.net/">Anotherhome</a>
