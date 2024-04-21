#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define FREE 0
#define BUSY 1
#define Max_length 640

typedef struct freearea//�������Ľṹ��
{
    int ID;//������
    int size;//������С
    int address;//������ַ
    bool isUsed;//ʹ��״̬��0Ϊδռ�ã�1Ϊ��ռ��
} freearea;

typedef struct DuNode//��β��������˫��������
{
    freearea data;//������
    struct DuNode *prior;//ָ����
    struct DuNode *next;
} DuNode, *DuLinkList;

DuLinkList m_rid;
DuLinkList m_last;

void init()//���������г�ʼ��
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

int first_fit(int ID,int size) 
{
    DuLinkList temp = (DuLinkList)malloc(sizeof(DuNode));
    DuNode *p = m_rid->next;

    temp->data.ID=ID;
    temp->data.size=size;
    temp->data.isUsed=BUSY;

    while(p)
    {
        if(p->data.ID == ID) 
        {
            printf("����ҵ�Ŷ�Ӧ����ҵ�Ѿ����ڴ��У�");

            return 0;
        }

        if (p->data.isUsed==FREE && p->data.size==size)//�����С�պ�����
        {
            p->data.isUsed=BUSY;
            p->data.ID=ID;

            return 1;
        }

        if (p->data.isUsed==FREE && p->data.size>size) 
        {
            temp->next=p;
            temp->prior=p->prior;
            temp->data.address=p->data.address;

            p->prior->next=temp;
            p->prior=temp;
            p->data.address=temp->data.address+temp->data.size;
            p->data.size-=size;

            return 1;
        }

        p=p->next;
    }

    return 0;
}

void alloc()//�����ڴ�
{
    int ID,size1;

    printf("��������ҵ�ţ�");
    scanf("%d", &ID);
    printf("�����������ڴ��С��");
    scanf("%d", &size1);

    if (ID<=0 || size1<=0)
        printf("������������ȷ����ҵ�ź�������ڴ��С");

    if(first_fit(ID,size1))
        printf("�����ڴ�ɹ���\n");
    else
        printf("�����ڴ�ʧ�ܣ�\n");
}

void freeNode()//�ͷ��ڴ�
{
    int ID;
    DuNode *p = m_rid->next;

    printf("������Ҫ�ͷ��ڴ����ҵ�ţ�");
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

            printf("�ͷ��ڴ�ɹ���\n");
            break;
        }

        p = p->next;

        if(!p)
            printf("�ڴ���û�и���Ҫ�ͷ��ڴ����ҵ��");
    }
}

void show()
{
    printf("------------------");
    printf("�ڴ�������");
    printf("------------------\n");

    DuNode *p = m_rid->next;

    while(p)
    {
        printf("�����ţ�");
        if (p->data.ID==FREE)
            printf("FREE\n");
        else
            printf("%d \n", p->data.ID);

        printf("��ʼ��ַ��%d\n", p->data.address);
        printf("�ڴ��С��%d\n", p->data.size);
        printf("����״̬��");

        if (p->data.isUsed==FREE)
            printf("����\n");
        else
            printf("�ѷ���\n");

        printf("------------------\n");

        p=p->next;
    }
}

int main()
{
    printf("------------------");
    printf("�״���Ӧ�㷨");
    printf("------------------\n");

    init();

    int tag = 1;

    while(tag < 3 && tag > 0)
    {
        printf("����Ҫ���еĲ���");
        printf("��1-�����ڴ棬2-�ڴ��ͷţ�����-�˳����򣩣�");
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
            printf("�������˳���");
        }
    }
}

