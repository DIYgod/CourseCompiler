/**
*pl0词法分析程序
*从test.txt输入
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h> 
#define WordMax 10
#define KeyWordCount 13
#define KeyWordMax 10

typedef struct
{
	char data[KeyWordMax];
	int length;
} SqString;

bool is_Keyword(char *);
void DispStr(SqString s);

/*输出说明：
*	k 关键字
*	v 标识符
*	n 常数
*	+-/*= 自身
*识别成功则将其储存在out中
*忽略空格
*/
bool lex(FILE * in, char * out)
{
	char newchar;
	SqString word;
	int oindex = 0;

	printf("类型\t单词符号\n");

	newchar = getc(in);

	while (newchar != EOF)																/*读入字符，分析类型*/
	{
		if (newchar >= 'a' && newchar <= 'z')											/*检测关键词or标识符*/
		{
			int i = 0;
			do{
				if (i < WordMax)
				{
					word.data[i] = newchar;
					i++;
				}
				newchar = getc(in);
			} while ((newchar >= 'a' && newchar <= 'z') || (newchar >= '0' && newchar <= '9'));
			word.length = i;
			if (is_Keyword(word.data))
			{
				printf("关键词\t");
				DispStr(word);
				out[oindex] = 'k';
				oindex++;
				continue;
			}
			else
			{
				printf("标识符\t");
				DispStr(word);
				out[oindex] = 'v';
				oindex++;
				continue;
			}
		}

		else if (newchar == ' ' || newchar == '\n' || newchar == '\t')					/*检测空格*/
		{
			newchar = getc(in);
			continue;
		}

		else if (newchar >= '0' && newchar <= '9')
		{
			int i = 0;
			do{																			/*检测常数*/
				if (i < WordMax)
				{
					word.data[i] = newchar;
					i++;
				}
				newchar = getc(in);
			} while (newchar >= '0' && newchar <= '9');
			word.length = i;
			printf("常数\t");
			DispStr(word); 
			out[oindex] = 'n';
			oindex++;
			continue;
		}

		else if (newchar == '(' || newchar == ')')	/*检测界符*/
		{
			out[oindex] = newchar;
			oindex++;
			printf("界符\t%c\n", newchar);
			newchar = getc(in);
			continue;
		}

		else if (newchar == '+' || newchar == '-' || newchar == '*' || newchar == '/' || newchar == '=')		/*检测运算符*/
		{
			out[oindex] = newchar;
			oindex++;
			printf("运算符\t%c\n", newchar);
			newchar = getc(in);
			continue;
		}

		else																				/*无效字符*/
		{
			printf("无效字符\t%c\n输入说明：\n\t只能输入关键词 标识符 常数 +-*/=\n", newchar);
			return false;
		}
	}
	out[oindex] = '#';
	return true;
}

//判断是否为关键字
bool is_Keyword(char *word)
{
	char keyword[KeyWordCount][KeyWordMax] = { "begin", "call", "const", "do", "end", "if", "odd", "procedure", "read", "then", "var", "while", "write" };

	for (int i = 0; i < KeyWordCount; i++)
	{
		char *trueword = keyword[i];
		int length = strlen(trueword);
		int j;
		for (j = 0; j < length; j++){
			if (word[j] != trueword[j]) break;
		}
		if (j == length)
			return true;
	}
	return false;
}

//输出串
void DispStr(SqString s)
{
	int i = 0;
	if (s.length > 0)
	{
		for (i = 0; i < s.length; i++)
		{
			printf("%c", s.data[i]);
		}
		printf("\n");
	}
}