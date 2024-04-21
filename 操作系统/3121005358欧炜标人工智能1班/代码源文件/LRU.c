#include <stdio.h>
#include <stdlib.h>

float count = 0; //ȱҳ����
int instrAddr[320]; //ָ���ַ������
int pageAddr[320]; //ҳ��ַ������

typedef struct Data //������
{
    int pageNum; //װ�����û����ҳ��
    int blockNum; //���
    int t; //���ϴα�����������������ʱ��
} Data;

typedef struct BlockNode //����ѭ������
{
    Data data;
    struct BlockNode *next;
} Block, *BlockList;

//�����ڴ��
BlockList block1;
BlockList block2;
BlockList block3;
BlockList block4;

void initialize() //��ʼ��
{
    block1 = (BlockList)malloc(sizeof(Block));
    block2 = (BlockList)malloc(sizeof(Block));
    block3 = (BlockList)malloc(sizeof(Block));
    block4 = (BlockList)malloc(sizeof(Block));

    block1->data.pageNum = -1;
    block2->data.pageNum = -1;
    block3->data.pageNum = -1;
    block4->data.pageNum = -1;

    block1->data.blockNum = 0;
    block2->data.blockNum = 1;
    block3->data.blockNum = 2;
    block4->data.blockNum = 3;

    block1->data.t = 0;
    block2->data.t = 0;
    block3->data.t = 0;
    block4->data.t = 0;

    block1->next = block2;
    block2->next = block3;
    block3->next = block4;
    block4->next = block1;

	int i;
    for(i = 0; i < 320; ) //��ʼ����ַ��
    {
        int m = rand() % 320;
        instrAddr[i] = m + 1;
        pageAddr[i] = instrAddr[i] / 10;
        i++;

        int m1 = rand() % (m - 1);
        instrAddr[i] = m1;
        pageAddr[i] = m1 / 10;
        i++;

        instrAddr[i] = m1 + 1;
        pageAddr[i] = instrAddr[i] / 10;
        i++;

        int m2 = rand() % (319 - m1 - 1) + m1 + 2;
        instrAddr[i] = m2;
        pageAddr[i] = m2 / 10;
        i++;

        instrAddr[i] = m2 + 1;
        pageAddr[i] = instrAddr[i] / 10;
        i++;
    }
}

int LRU(int pageNum, int virAddr)
{
    Block *p = block1;

	int i;
    for(i = 0; i < 4; i++) //���������ڴ�飬���������κβ������������ʱ����ָ��block1
    {
        if(p->data.pageNum == -1) //��Ϊ����
        {
            p->data.pageNum = pageNum;
            count++; //ȱҳ����+1
            printf("ָ���ַ��%d \n", virAddr);
            printf("ָ��δװ���ڴ棡ҳ���û���ɣ�\n�û�ָ���%dҳ��%d���������ַΪ����%d���%d�� \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));

            //�����п龭����ʱ��+1���ٽ���ǰ���ʿ��ʱ����0
            int i;
			for(i = 0; i < 4; i++)
            {
                p->data.t++;
                p = p->next;
            }

            p->data.t = 0;

            return 1;
        }

        if(p->data.pageNum == pageNum)
        {
            printf("ָ���ַ��%d \n", virAddr);
            printf("ָ�������ڴ��У�\n�û�ָ���%dҳ��%d���������ַΪ����%d���%d�� \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));
			
			int i;
            for(i = 0; i < 4; i++)
            {
                p->data.t++;
                p = p->next;
            }

            p->data.t = 0;

            return 1;
        }

        p = p->next;
    }

    //ҳ���û�
    int largestT = -1;

    for(i = 0; i < 4; i++) //
    {
        if(p->data.t > largestT)
        {
            largestT = p->data.t;
        }

        p = p->next;
    }

    for(i = 0; i < 4; i++)
    {
        if(p->data.t == largestT)
        {
        	int j;
            for(j = 0; j < 4; j++)
            {
                p->data.t++;
                p = p->next;
            }

            p->data.pageNum = pageNum;
            count++;
            p->data.t = 0;

            printf("ָ���ַ��%d \n", virAddr);
            printf("ָ��δװ���ڴ����ڴ��������ҳ���û���ɣ�\n�û�ָ���%dҳ��%d���������ַΪ����%d���%d�� \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));

            return 1;
        }

        p = p->next;
    }

    return 1;
}

void calculate() //����ȱҳ��
{
	int i; 
    for(i = 0; i < 320; i++)
    {
        LRU(pageAddr[i], instrAddr[i]);
    }

    printf("\n");
    printf("ȱҳ������%.0f\n", count);
    printf("����õ���ȱҳ��Ϊ��%.4f \n", count / 320);
}

int main()
{
    printf("----------������δʹ���û��㷨----------\n\n");

    initialize();
    calculate();

    return 0;
}

