#include <stdio.h>
#include <stdlib.h>

float count = 0; //缺页次数
int instrAddr[320]; //指令地址流数组
int pageAddr[320]; //页地址流数组

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

void initialize() //初始化
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

    block1->next = block2;
    block2->next = block3;
    block3->next = block4;
    block4->next = block1;
	int i; 
    for(i = 0; i < 320; ) //初始化地址流
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

//pos为所调用页在地址流中的位置
int Optimal(int pageNum, int virAddr, int pos) //最佳置换算法
{
    Block *p = block1;
	int i;
    for(i = 0; i < 4; i++) //遍历所有内存块，若不进行任何操作则遍历结束时候仍指向block1
    {
        if(p->data.pageNum == -1) //块为空闲
        {
            p->data.pageNum = pageNum;
            count++; //缺页次数+1
            printf("调入的第%d条", pos);
            printf("指令地址：%d \n", virAddr);
            printf("指令未装入内存！页面置换完成！\n用户指令第%d页第%d条的物理地址为：第%d块第%d条 \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));

            return 1;
        }

        if(p->data.pageNum == pageNum)
        {
            printf("调入的第%d条", pos);
            printf("指令地址：%d \n", virAddr);
            printf("指令已在内存中！\n用户指令第%d页第%d条的物理地址为：第%d块第%d条 \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));

            return 1;
        }

        p = p->next;
    }

    //页面置换
    int allBlockPageNum[4]; //记录已装入内存的页地址

    for(i = 0; i < 4; i++)
    {
        allBlockPageNum[i] = p->data.pageNum;
        p = p->next;
    }

    int nextAddr[4]; //记录已装入内存的页地址下次在指令流中出现的位置

    for(i = 0; i < 4; i++)
    {	
    	int j;
        for(j = pos; j < 320; j++)
        {
            if(allBlockPageNum[i] == pageAddr[j]) //找到第一个位置即停止
            {
                nextAddr[i] = j;
                break;
            }
        }
    }

    int temp = 0; //页地址
    int blockPos; //内存块的地址

    for(i = 0; i < 4; i++) //选出距离最远的页地址在内存块中对应的位置
    {
        if(nextAddr[i] > temp)
        {
            temp = nextAddr[i];
            blockPos = i;
        }
    }

    for(i = 0; i < 4; i++)
    {
        if(p->data.blockNum == blockPos)
        {
            p->data.pageNum = pageNum;
            count++;

            printf("调入的第%d条", pos);
            printf("指令地址：%d \n", virAddr);
            printf("指令未装入内存且内存块已满！页面置换完成！\n用户指令第%d页第%d条的物理地址为：第%d块第%d条 \n\n", pageNum, (virAddr % 10), p->data.blockNum, (virAddr % 10));
        }

        p = p->next;
    }

    return 1;
}

void calculate() //计算缺页率
{
	int i;
    for(i = 0; i < 320; i++)
    {
        Optimal(pageAddr[i], instrAddr[i], i);
    }

    printf("\n");
    printf("缺页次数：%.0f\n", count);
    printf("计算得到的缺页率为：%.4f \n", count / 320);
}

int main()
{
    printf("----------最佳置换算法----------\n\n");

    initialize();
    calculate();

    return 0;
}

