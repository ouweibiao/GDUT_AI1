#include<stdio.h>
#define MAX 10
struct task_struct
{
    char name[10];           /*��������*/


    float arrivetime;         /*����ʱ��*/
    float starttime;     /*��ʼ����ʱ��*/
    float runtime;          /*����ʱ��*/
    float finishtime;      /*���н���ʱ��*/


    int runflag;          /*���ȱ�־*/
    int startflag;     //�Ƿ�Ϊ��һ�ο�ʼ����
} tasks[MAX];
int counter; /*ʵ�ʽ��̸���*/
int pinput();
int timecounter=0;
int poutput(); /*���Ƚ�����*/
int time();
int charge();//�ж��Ƿ����еĽ��̶���ִ�й�


int time()
{
    float temp=0;//������¼ʱ��Ƭ���ó���
    int i;
    int j=0;
    int k=0;


    struct task_struct  copy_task[MAX];//����
    for(i=0; i<counter; i++)
    {
        copy_task[j++]=tasks[i];//�Խ��̵ĳ�ʼ����Ϣ����
    }


    temp=tasks[0].arrivetime;//temp=��һ�����̵ĵ���ʱ��
    while(charge())//while������chargeΪ0������˵�����̶��Ѿ�ȫ��ִ����ϣ���Ϊ1���루���̻�δִ����ϣ�����ִ�У�
    {
        for(i=0; i<counter; i++)
        {
            if(tasks[i].arrivetime>temp)//�����i���ĵ���ʱ����ڵ�һ���ĵ���ʱ�䣬�򽫵�i���ĵ���ʱ����temp����������temp�ļ�¼�����ǵ�һ�����е�ʱ������һ��
            {
                temp=tasks[i].arrivetime;
            }
            if(tasks[i].runflag==0)//��i�����̻�δ����
            {
                if(tasks[i].startflag==0)  //������������˵�����ý����ǵ�һ��ִ�У���¼��ʼִ��ʱ��
                {
                    tasks[i].starttime=temp;//��һ�����̵ĵ���ʱ��Ϊtemp
                    tasks[i].startflag=1;//��������һ�����¼�ý����Ѿ����ǵ�һ��������
                }
                if(tasks[i].runtime/timecounter>1)//������ʱ�����ʱ��Ƭ���ȣ�˵��������������ʱ��Ƭδִ��
                {
                    tasks[i].runtime=tasks[i].runtime-timecounter;//ʣ������ʱ��͵���ԭ������ʱ���ȥһ��ʱ��Ƭ����
                    temp=temp+timecounter;//temp������¼���õ�ʱ��Ƭ����
                }
                else if(tasks[i].runtime-timecounter==0)//������ʱ�����ʱ��Ƭ����Ϊ1���ý���ʣ�µĸպ���һ��ʱ��Ƭ���ȣ�˵���ý���ֻ��������һһ���Ϳ����������
                {
                    temp=temp+timecounter;//temp�������һ��ʱ��Ƭ���Ⱦ�Ϊ�ý��̵Ľ���ʱ��
                    tasks[i].finishtime=temp;
                    tasks[i].runflag=1;//��Ǹý����Ѿ�ִ�����
                    tasks[i].runtime=copy_task[i].runtime;//Ϊ�˼�����תʱ�䣬����ʱ��ӱ������滹ԭ���ʼ������ʱ��
                }
                else//��ʣ�²���һ����ʱ��Ƭ����ʣ������ʱ�����ʱ��Ƭ����<1
                {
                    temp=temp+tasks[i].runtime;//ʣ������ʱ�䲻��һ��ʱ��Ƭ���ȣ������ʱ�����temp���ϸý��̵�����ʱ��
                    tasks[i].finishtime=temp;
                    tasks[i].runflag=1;//��Ǹý����Ѿ��������
                    tasks[i].runtime=copy_task[i].runtime;
                }
            }
        }
    }
 return 0;
}


int charge()//�ж��Ƿ�ȫ�����̶�ִ�����
{
    int k;
    int superflag=0;//�ж��Ƿ�ȫ���Ľ��̶�ִ�����
    for(k=0; k<counter; k++)
    {
        if(tasks[k].runflag==0)//ֻҪ
        {
            superflag=1;
            return superflag;
            break;
        }
        else
        {
            superflag=0;
        }
    }
    return superflag;
}


int pinput() /*���̲�������*/
{
    int i;
    printf("��������̸���:\n");
    scanf("%d",&counter);
    printf("������ʱ��Ƭ����:\n");
    scanf("%d",&timecounter);
    for(i=0; i<counter; i++)
    {
        printf("******************************************\n");
 printf("������������ơ�����ʱ�䡢����ʱ�䣺���м��ÿո������\n");
 scanf("%s%f%f",tasks[i].name,&tasks[i].arrivetime,&tasks[i].runtime);


        tasks[i].starttime=0;
        tasks[i].finishtime=0;
        tasks[i].runflag=0;  //�����Ƿ����
        tasks[i].startflag=0;//�Ƿ��״α�ִ��
    }
    return 0;
}


int poutput() /*���Ƚ�����*/
{
    int i;
    float zztime=0,dqzztime=0,f1,f2,w=0;
    printf("������ ����ʱ�� ����ʱ�� ���ʱ�� ��תʱ�� ��Ȩ��תʱ��\n");
    for(i=0; i<counter; i++)
    {
        f1=tasks[i].finishtime-tasks[i].arrivetime;
        f2=f1 / (float)tasks[i].runtime;
        zztime+=f1;
        dqzztime+=f2;
        printf("%s\t%5.3f\t%5.3f\t%5.3f\t  %5.3f\t   %5.3f\n",tasks[i].name,tasks[i].arrivetime,tasks[i].runtime,tasks[i].finishtime,f1,f2);
    }
    printf("ƽ����תʱ��=%5.2f\n",zztime/counter);
    printf("ƽ����Ȩ��תʱ��=%5.2f\n",dqzztime/counter);
	return 0;
}


void main()
{


    pinput();
    printf("ʱ��Ƭ��ת�㷨��\n\n");
    time();
    poutput();
}

