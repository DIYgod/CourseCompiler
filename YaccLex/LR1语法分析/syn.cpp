/*��ֵ���SLR(1)�﷨��������
*ʵ�ֲ��ִ������ɸ��ݵ�����Ϣ������Ӵ�����Ϣ
*ʵ�ִʷ������﷨�������̵�չʾ
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MaxChar 4
#define WordMax 70
typedef struct
{
	char data[20][MaxChar];
	int top;
} SqStack;

extern bool lex(FILE * in, char * out);
bool Location(char input, char * state, int &x, int &y);
void InitStack(SqStack *&s);
bool Push(SqStack *&s, char * e);
bool Pop(SqStack *&s, char * &e);
bool GetTop(SqStack *s, char * &e);

//���������
char table[15][12][MaxChar] = {
		{ " ", "n", "+", "*", "(", ")", "#", "=", "v", "E", "T", "F" },
		{ "S00", " ", " ", " ", " ", " ", " ", " ", "S01", " ", " ", " " },
		{ "S01", " ", " ", " ", " ", " ", " ", "S02", " ", " ", " ", " " },
		{ "S02", "S07", " ", " ", "S06", " ", " ", " ", "S07", "S03", "S04", "S05" },
		{ "S03", " ", "S08", " ", " ", " ", "acc", " ", " ", " ", " ", " " },
		{ "S04", " ", "r2", "S09", " ", "r2", "r2", " ", " ", " ", " ", " " },
		{ "S05", " ", "r4", "r4", " ", "r4", "r4", " ", " ", " ", " ", " " },
		{ "S06", "S07", " ", " ", "S06", " ", " ", " ", "S07", "S10", "S04", "S05" },
		{ "S07", " ", "r6", "r6", " ", "r6", "r6", " ", " ", " ", " ", " " },
		{ "S08", "S07", " ", " ", "S06", " ", " ", " ", "S07", " ", "S11", "S05" },
		{ "S09", "S07", " ", " ", "S06", " ", " ", " ", "S07", " ", " ", "S12" },
		{ "S10", " ", "S08", " ", " ", "S13", " ", " ", " ", " ", " ", " " },
		{ "S11", " ", "r1", "S09", " ", "r1", "r1", " ", " ", " ", " ", " " },
		{ "S12", " ", "r3", "r3", " ", "r3", "r3", " ", " ", " ", " ", " " },
		{ "S13", " ", "r5", "r5", " ", "r5", "r5", " ", " ", " ", " ", " " }
};

int main(void)
{
	int i = 0;
	printf("SLR(1) analysis table:\n");			//���������
	for (int i = 0; i < 13; i++)
	{
		for (int j = 0; j < 10; j++)
			printf("%4s ", table[i][j]);
		printf("\n");
	}
	printf("\n\n");


	//�ʷ�����
	errno_t err;
	FILE *in;
	if (err = fopen_s(&in, "test.txt", "r"))
	{
		printf("Are you kiding me? I couldn't open the file!\n");
		return 0;
	}

	printf("Lexical analysis:\n");
	char inputString[100];				//���봮
	if (!lex(in, inputString))
	{
		printf("�﷨���������˳���������Ч�ַ�!");
		system("PAUSE");
		return 0;
	}

	printf("\n\nInput string:\n");		//������봮
	int inindex = 0;
	while (inputString[inindex - 1] != '#')
	{
		printf("%c", inputString[inindex]);
		if (inputString[inindex] == '-')
			inputString[inindex] = '+';
		else if (inputString[inindex] == '/')
			inputString[inindex] = '*';
		inindex++;
	}
	printf("\n\n\n");

	inindex = 0;

	//�﷨����
	printf("Parsing process:\n\n���˵����\n");
	printf("״̬ջ\n����ջ\t\t\t���봮\nAction\t\t\tGoto\n\n");
	char action[MaxChar];					//Action
	char goTo[MaxChar];						//Goto
	SqStack * stateStack;					//״̬ջ
	SqStack * symbolStack;					//����ջ
	InitStack(stateStack);
	InitStack(symbolStack);
	Push(stateStack, "S00");
	Push(symbolStack, "#");

	while (action[0] != 'a')
	{
		int x, y;													//��Action
		char * t;
		GetTop(stateStack, t);
		Location(inputString[inindex], t, x, y);
		strcpy_s(action, table[y][x]);

		if (action[0] == ' ')										//������,�ɸ��ݵ�����Ϣ������Ӵ�����Ϣ
		{
			printf("�﷨���������˳����﷨����\n");
			printf("������Ϣ��  x:%d, y:%d\n", x, y);
			if (y == 1)
				printf("���ܳ��ֵĴ��󣺸�ֵ�������Ա�ʶ����ͷ\n");
			else if (y == 2)
				printf("���ܳ��ֵĴ��󣺱���ֵ��ʶ����������еȺ�\n");
			else if (y == 11 && x == 6)
				printf("���ܳ��ֵĴ���ȱ��������\n");
			else if (y == 4 && x == 5)
				printf("���ܳ��ֵĴ���ȱ��������\n");
			else if (y == 8 || (y == 14 && x == 1) )
				printf("���ܳ��ֵĴ���ȱ�������\n");
			else if ((y == 10 && x == 2) || (y == 9))
				printf("���ܳ��ֵĴ���������ظ�\n");
			else
				printf("��δ�����������ݵ�����Ϣ���д���\n");

			system("PAUSE");
			return 1;
		}

		if (action[0] == 'S' || action[0] == 'a')					//��Goto
			strcpy_s(goTo, " ");
		else if (action[0] == 'r')
		{
			switch (action[1])
			{
			case '1': Location('E', stateStack->data[stateStack->top - 3], x, y); break;
			case '2': Location('E', stateStack->data[stateStack->top - 1], x, y); break;
			case '3': Location('T', stateStack->data[stateStack->top - 3], x, y); break;
			case '4': Location('T', stateStack->data[stateStack->top - 1], x, y); break;
			case '5': Location('F', stateStack->data[stateStack->top - 3], x, y); break;
			case '6': Location('F', stateStack->data[stateStack->top - 1], x, y); break;
			}
			strcpy_s(goTo, table[y][x]);
		}

		
		for (i = 0; i <= stateStack->top; i++)								//�����������
			printf("%s", stateStack->data[i]);
		printf("\n");
		for (i = 0; i <= symbolStack->top; i++)
			printf("%s", symbolStack->data[i]);
		printf("\t\t\t");
		for (i = inindex; inputString[i - 1] != '#'; i++)
			printf("%c", inputString[i]);
		printf("\n");
		printf("%s\t\t\t%s\n\n", action, goTo);

		char * pop;
		if (action[0] == 'a')
			printf("��ֵ�������ɹ�\n");
		else if (action[0] == 'S')
		{
			char input[MaxChar];
			input[0] = inputString[inindex];
			input[1] = '\0';
			Push(symbolStack, input);
			inindex++;
			Push(stateStack, action);
		}
		else if (action[0] == 'r')
		{
			switch (action[1])
			{
			case '1': Pop(stateStack, pop); Pop(stateStack, pop); Pop(stateStack, pop); Pop(symbolStack, pop); Pop(symbolStack, pop); Pop(symbolStack, pop); Push(symbolStack, "E"); break;
			case '2': Pop(stateStack, pop); Pop(symbolStack, pop); Push(symbolStack, "E"); break;
			case '3': Pop(stateStack, pop); Pop(stateStack, pop); Pop(stateStack, pop); Pop(symbolStack, pop); Pop(symbolStack, pop); Pop(symbolStack, pop); Push(symbolStack, "T"); break;
			case '4': Pop(stateStack, pop); Pop(symbolStack, pop); Push(symbolStack, "T"); break;
			case '5': Pop(stateStack, pop); Pop(stateStack, pop); Pop(stateStack, pop); Pop(symbolStack, pop); Pop(symbolStack, pop); Pop(symbolStack, pop); Push(symbolStack, "F"); break;
			case '6': Pop(stateStack, pop); Pop(symbolStack, pop); Push(symbolStack, "F"); break;
			}
			Push(stateStack, goTo);
		}
	}


	system("PAUSE");
	return 0;
}





//���ڷ������е�λ��
bool Location(char input, char * state, int &x, int &y)
{
	for (x = 0; x < 12; x++)
	{
		if (input == table[0][x][0])
			break;
	}
	y = state[2] - 48 + 10 * (state[1] - 48) + 1;

	if (x >= 12 || y >= 15 || y <= 0)
		return false;
	else
		return true;
}


//��ʼ��ջ
void InitStack(SqStack *&s)
{
	s = (SqStack *)malloc(sizeof(SqStack));
	s->top = -1;
}

//��ջ
bool Push(SqStack *&s, char * e)
{
	if (s->top == 20 - 1)
		return false;
	s->top++; 
	for (int i = 0; i < MaxChar; i++)
	{
		s->data[s->top][i] = e[i];
	}
	return true;
}

//��ջ
bool Pop(SqStack *&s, char * &e)
{
	if (s->top == -1)
		return false;
	e = s->data[s->top];
	s->top--;
	return true;
}

//ȡջ��Ԫ��
bool GetTop(SqStack *s, char * &e)
{
	if (s->top == -1)
		return false;
	e = s->data[s->top];
	return true;
}