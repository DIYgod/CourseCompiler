bison -d pl0.y
flex pl0.l
gcc -std=c99 lex.yy.c pl0.tab.c pl0.h
pause