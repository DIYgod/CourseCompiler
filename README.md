:octocat: Compiler
=======

赋值语句语法分析的两种实现—LR(1)分析法和Yacc Lex自动构造工具

编译原理课程实践
------------

对于常用高级语言（如Pascal、C语言）的源程序从左到右进行扫描，把其中赋值语句用所学过的语法分析方法进行语法分析，判断语句的语法是否正确，如果错误指出错误类型，输出分析过程。

使用Yacc Lex自动构造工具的实现
-------

+ `pl0.h` 为Yacc的源文件，生成`pl0.tab.c` `pl0.tab.h`

+ `pl0.l` 为Lex的源文件，生成`lex.yy.c`

+ `pl0.tab.c` `lex.yy.c` `pl0.h`联合编译出`a.exe`

+ 从`test.txt`输入

+ 版本说明： V1.0 词法分析  V2.0 增加语法分析  V3.0 增加语义分析

+ Update 2014.11.28  实现语义分析！！！



LR(1)分析法的实现
-------

+ lex.cpp 进行词法分析

+ syn.cpp 调用 lex.cpp 并进行语法分析

+ 从test.txt输入

+ 实现错误处理，可根据调试信息自行添加错误信息

+ 实现词法分析语法分析过程的展示

+ Update 2014.11.24  对语法分析模块略改动，实现自定义文法



Blog
-------
+ <a href="http://www.anotherhome.net/">Anotherhome</a>
