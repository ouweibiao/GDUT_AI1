#include <stdio.h>
#include <stdlib.h>

float count = 0; //ȱҳ����

typedef struct Data //������
{
    int pageNum; //װ�����û����ҳ��
    int blockNum; //���
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
Block *p;

void initialize() //��ʼ��
{
    block1 = (BlockList)malloc(sizeof(Block));
    block2 = (BlockList)malloc(sizeof(Block));
    block3 = (BlockList)malloc(sizeof(Block));
    block4 = (BlockList)malloc(sizeof(Block));
    p = block1;

    block1->data.pageNum = -1;
    block2->data.pageNum = -1;
    block3->data.pageNum = -1;
    block4->data.pageNum = -1;

    block1->data.blockNum = 0;
    block2->data.blockNum = 1;
    block3->data.blockNum = 2;
    block4->data.blockNum = 3;

    block1->next = block2;
    block2->next = block3;
    block3->next = block4;
    block4->next = block1;
}

int FIFO(int pageNum, int virAddr) //�Ƚ��ȳ�ҳ���û��㷨
{
    BlockList q = p; //�洢pԭ����λ��

	int i;
    for(i = 0; i < 4; i++) //�жϿ����ڴ��Ƿ���Ѽ������ݲ���ָ���Ƿ������ڴ���
    {
        if(p->data.pageNum == -1) //��Ϊ����
        {
            p->data.pageNum = pageNum;
            count++; //ȱҳ����+1
            printf("ָ��δװ���ڴ棡ҳ���û���ɣ�\n�û�ָ���%dҳ��%d���������ַΪ����%d���%d�� \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));
            p = block1; //ָ�����ȱ�����Ŀ�1;

            return 1;
        }

        if(p->data.pageNum == pageNum)
        {
            printf("ָ�������ڴ��У�\n�û�ָ���%dҳ��%d���������ַΪ����%d���%d�� \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));
            p = q;//ҳ��û�з����û���ָ��ָ��ԭ���ϵ�ҳ��

            return 1;
        }

        p = p->next;
    }

    p->data.pageNum = pageNum;
    count++;
    printf("ָ��δװ���ڴ����ڴ��������ҳ���û���ɣ�\n�û�ָ���%dҳ��%d���������ַΪ����%d���%d�� \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));

    p = p->next; //ָ�����ϵ�ҳ��

    return 1;
}

void calculate() //����ҳ��ַ��������ȱҳ��
{
	int i; 
    for(i = 0; i < 320; )
    {
        int m = rand() % 320;
        printf("ָ���ַΪ��%d \n", (m + 1));
        FIFO(((m + 1) / 10), m + 1);
        i++;

        int m1 = rand() % (m - 1);
        printf("ָ���ַΪ��%d \n", m1);
        FIFO((m1 / 10), m1);
        i++;

        printf("ָ���ַΪ��%d \n", (m1 + 1));
        FIFO(((m1 + 1) / 10), m1 + 1);
        i++;

        int m2 = rand() % (319 - m1 - 1) + m1 + 2;
        printf("ָ���ַΪ��%d \n", m2);
        FIFO((m2 / 10), m2);
        i++;

        printf("ָ���ַΪ��%d \n", (m2 + 1));
        FIFO(((m2 + 1) / 10), m2 + 1);
        i++;
    }

    printf("\n");
    printf("ȱҳ������%.0f\n", count);
    printf("����õ���ȱҳ��Ϊ��%.4f \n", count / 320);
}

int main()
{
    printf("----------�Ƚ��ȳ�ҳ���û��㷨----------\n\n");

    initialize();
    calculate();

    return 0;
}

