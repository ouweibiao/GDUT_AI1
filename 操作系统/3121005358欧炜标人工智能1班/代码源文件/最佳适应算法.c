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

int best_fit(int ID,int size)//�����Ӧ�㷨
{
    int surplus;//��¼�����ڴ��������ڴ�Ĳ�ֵ
    DuLinkList temp = (DuLinkList)malloc(sizeof(DuNode));
    DuNode *p = m_rid->next;
    DuNode *q = NULL;//��¼���λ��

    temp->data.ID = ID;
    temp->data.size = size;
    temp->data.isUsed = BUSY;

    while(p)//���������ҵ���һ�����õĿ������丳��q
    {
        if (p->data.isUsed==FREE && p->data.size >= size)
        {
            q = p;
            surplus = p->data.size - size;
            break;
        }

        p=p->next;
    }

    while(p)//�����������ҵ����ʵ�λ��
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

    if (q == NULL)//û���ҵ�λ��
        return 0;
    else//�ҵ����λ��
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

void alloc()//�����ڴ�
{
    int ID,size1;

    printf("��������ҵ�ţ�");
    scanf("%d", &ID);
    printf("�����������ڴ��С��");
    scanf("%d", &size1);

    if (ID<=0 || size1<=0)
        printf("������������ȷ����ҵ�ź�������ڴ��С");

    if(best_fit(ID,size1))
        printf("�����ڴ�ɹ���\n");
    else
        printf("�����ڴ�ʧ�ܣ�\n");
}

void freeNode()
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
    printf("�����Ӧ�㷨");
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

