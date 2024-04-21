#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define FREE 0
#define BUSY 1
#define Max_length 640

typedef struct freearea//空闲区的结构体
{
    int ID;//分区号
    int size;//分区大小
    int address;//分区地址
    bool isUsed;//使用状态，0为未占用，1为已占用
} freearea;

typedef struct DuNode//首尾不互连的双向链表结点
{
    freearea data;//数据域
    struct DuNode *prior;//指针域
    struct DuNode *next;
} DuNode, *DuLinkList;

DuLinkList m_rid;
DuLinkList m_last;

void init()//空闲区队列初始化
{
    m_rid = (DuLinkList)malloc(sizeof(DuNode));
    m_last = (DuLinkList)malloc(sizeof(DuNode));

    m_rid->prior = NULL;
    m_rid->next = m_last;

    m_last->prior = m_rid;
    m_last->next = NULL;

    m_rid->data.size = 0;
    m_rid->data.isUsed = BUSY; 

    m_last->data.address = 0;
    m_last->data.size = Max_length;
    m_last->data.ID = 0;
    m_last->data.isUsed = 0;
}

int best_fit(int ID,int size)//最佳适应算法
{
    int surplus;//记录可用内存与需求内存的差值
    DuLinkList temp = (DuLinkList)malloc(sizeof(DuNode));
    DuNode *p = m_rid->next;
    DuNode *q = NULL;//记录最佳位置

    temp->data.ID = ID;
    temp->data.size = size;
    temp->data.isUsed = BUSY;

    while(p)//遍历链表，找到第一个可用的空闲区间赋给q
    {
        if (p->data.isUsed==FREE && p->data.size >= size)
        {
            q = p;
            surplus = p->data.size - size;
            break;
        }

        p=p->next;
    }

    while(p)//继续遍历，找到合适的位置
    {
        if (p->data.isUsed == FREE && p->data.size == size) 
        {
            p->data.isUsed = BUSY;
            p->data.ID = ID;

            return 1;
        }

        if (p->data.isUsed == FREE && p->data.size > size) 
        {
            if (surplus > p->data.size - size)
            {
                surplus = p->data.size-size;
                q = p;
            }
        }

        p=p->next;
    }

    if (q == NULL)//没有找到位置
        return 0;
    else//找到最佳位置
    {
        temp->next = q;
        temp->prior = q->prior;
        temp->data.address = q->data.address;

        q->prior->next = temp;
        q->prior = temp;

        q->data.size = surplus;
        q->data.address += size;

        return 1;
    }
}

void alloc()//分配内存
{
    int ID,size1;

    printf("请输入作业号：");
    scanf("%d", &ID);
    printf("请输入所需内存大小：");
    scanf("%d", &size1);

    if (ID<=0 || size1<=0)
        printf("错误！请输入正确的作业号和请求的内存大小");

    if(best_fit(ID,size1))
        printf("分配内存成功！\n");
    else
        printf("分配内存失败！\n");
}

void freeNode()
{
    int ID;
    DuNode *p = m_rid->next;

    printf("输入需要释放内存的作业号：");
    scanf("%d", &ID);

    while (p)
    {
        if (p->data.ID == ID)
        {
            p->data.ID = 0;
            p->data.isUsed = FREE;

            if (!p->prior->data.isUsed && p->next->data.isUsed) 
            {
                p->prior->data.size += p->data.size;
                p->prior->next = p->next;
                p->next->prior = p->prior;
            }

            if (!p->next->data.isUsed && p->prior->data.isUsed) 
            {
                p->data.size += p->next->data.size;

                if(p->next->next)
                {
                    p->next->next->prior=p;
                    p->next = p->next->next;
                }
                else
                    p->next = p->next->next;
            }

            if(!p->prior->data.isUsed && !p->next->data.isUsed) 
            {
                p->prior->data.size += p->data.size + p->next->data.size;
                if(p->next->next)
                {
                    p->next->next->prior = p->prior;
                    p->prior->next = p->next->next;
                }
                else
                    p->prior->next = p->next->next;
            }

            printf("释放内存成功！\n");
            break;
        }

        p = p->next;

        if(!p)
            printf("内存中没有该需要释放内存的作业！");
    }
}

void show()
{
    printf("------------------");
    printf("内存分配情况");
    printf("------------------\n");

    DuNode *p = m_rid->next;

    while(p)
    {
        printf("分区号：");
        if (p->data.ID==FREE)
            printf("FREE\n");
        else
            printf("%d \n", p->data.ID);

        printf("起始地址：%d\n", p->data.address);
        printf("内存大小：%d\n", p->data.size);
        printf("分区状态：");

        if (p->data.isUsed==FREE)
            printf("空闲\n");
        else
            printf("已分配\n");

        printf("------------------\n");

        p=p->next;
    }
}

int main()
{
    printf("------------------");
    printf("最佳适应算法");
    printf("------------------\n");

    init();

    int tag = 1;

    while(tag < 3 && tag > 0)
    {
        printf("输入要进行的操作");
        printf("（1-分配内存，2-内存释放，其他-退出程序）：");
        scanf("%d", &tag);

        switch(tag)
        {
        case 1:
            alloc();
            show();
            break;
        case 2:
            freeNode();
            show();
            break;
        default:
            printf("程序已退出！");
        }
    }
}

