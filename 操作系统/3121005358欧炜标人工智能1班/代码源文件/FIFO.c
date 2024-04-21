#include <stdio.h>
#include <stdlib.h>

float count = 0; //缺页次数

typedef struct Data //数据域
{
    int pageNum; //装进的用户虚存页号
    int blockNum; //块号
} Data;

typedef struct BlockNode //单向循环链表
{
    Data data;
    struct BlockNode *next;
} Block, *BlockList;

//定义内存块
BlockList block1;
BlockList block2;
BlockList block3;
BlockList block4;
Block *p;

void initialize() //初始化
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

int FIFO(int pageNum, int virAddr) //先进先出页面置换算法
{
    BlockList q = p; //存储p原来的位置

	int i;
    for(i = 0; i < 4; i++) //判断块中内存是否均已加载数据并且指令是否已在内存中
    {
        if(p->data.pageNum == -1) //块为空闲
        {
            p->data.pageNum = pageNum;
            count++; //缺页次数+1
            printf("指令未装入内存！页面置换完成！\n用户指令第%d页第%d条的物理地址为：第%d块第%d条 \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));
            p = block1; //指向最先被分配的块1;

            return 1;
        }

        if(p->data.pageNum == pageNum)
        {
            printf("指令已在内存中！\n用户指令第%d页第%d条的物理地址为：第%d块第%d条 \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));
            p = q;//页面没有发生置换，指针指向原最老的页面

            return 1;
        }

        p = p->next;
    }

    p->data.pageNum = pageNum;
    count++;
    printf("指令未装入内存且内存块已满！页面置换完成！\n用户指令第%d页第%d条的物理地址为：第%d块第%d条 \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));

    p = p->next; //指向最老的页面

    return 1;
}

void calculate() //生成页地址流并计算缺页率
{
	int i; 
    for(i = 0; i < 320; )
    {
        int m = rand() % 320;
        printf("指令地址为：%d \n", (m + 1));
        FIFO(((m + 1) / 10), m + 1);
        i++;

        int m1 = rand() % (m - 1);
        printf("指令地址为：%d \n", m1);
        FIFO((m1 / 10), m1);
        i++;

        printf("指令地址为：%d \n", (m1 + 1));
        FIFO(((m1 + 1) / 10), m1 + 1);
        i++;

        int m2 = rand() % (319 - m1 - 1) + m1 + 2;
        printf("指令地址为：%d \n", m2);
        FIFO((m2 / 10), m2);
        i++;

        printf("指令地址为：%d \n", (m2 + 1));
        FIFO(((m2 + 1) / 10), m2 + 1);
        i++;
    }

    printf("\n");
    printf("缺页次数：%.0f\n", count);
    printf("计算得到的缺页率为：%.4f \n", count / 320);
}

int main()
{
    printf("----------先进先出页面置换算法----------\n\n");

    initialize();
    calculate();

    return 0;
}

