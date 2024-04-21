#include<stdio.h>
#define MAX 10
struct task_struct
{
    char name[10];           /*进程名称*/


    float arrivetime;         /*到达时间*/
    float starttime;     /*开始运行时间*/
    float runtime;          /*运行时间*/
    float finishtime;      /*运行结束时间*/


    int runflag;          /*调度标志*/
    int startflag;     //是否为第一次开始调度
} tasks[MAX];
int counter; /*实际进程个数*/
int pinput();
int timecounter=0;
int poutput(); /*调度结果输出*/
int time();
int charge();//判断是否所有的进程都被执行过


int time()
{
    float temp=0;//用来记录时间片已用长度
    int i;
    int j=0;
    int k=0;


    struct task_struct  copy_task[MAX];//备份
    for(i=0; i<counter; i++)
    {
        copy_task[j++]=tasks[i];//对进程的初始化信息备份
    }


    temp=tasks[0].arrivetime;//temp=第一个进程的到达时间
    while(charge())//while条件，charge为0跳出（说明进程都已经全部执行完毕），为1进入（进程还未执行完毕，继续执行）
    {
        for(i=0; i<counter; i++)
        {
            if(tasks[i].arrivetime>temp)//如果第i个的到达时间大于第一个的到达时间，则将第i个的到达时间与temp交换，更新temp的记录，但是第一次运行的时候不走这一步
            {
                temp=tasks[i].arrivetime;
            }
            if(tasks[i].runflag==0)//第i个进程还未结束
            {
                if(tasks[i].startflag==0)  //该条件成立则说明，该进程是第一次执行，记录开始执行时间
                {
                    tasks[i].starttime=temp;//第一个进程的到达时间为temp
                    tasks[i].startflag=1;//运行完上一步后记录该进程已经不是第一次运行了
                }
                if(tasks[i].runtime/timecounter>1)//，运行时间除以时间片长度，说明至少有两倍的时间片未执行
                {
                    tasks[i].runtime=tasks[i].runtime-timecounter;//剩余运行时间就等于原来运行时间减去一个时间片长度
                    temp=temp+timecounter;//temp继续记录已用的时间片长度
                }
                else if(tasks[i].runtime-timecounter==0)//即运行时间除以时间片长度为1，该进程剩下的刚好是一个时间片长度，说明该进程只需在运行一一步就可以运行完毕
                {
                    temp=temp+timecounter;//temp加上最后一个时间片长度就为该进程的结束时间
                    tasks[i].finishtime=temp;
                    tasks[i].runflag=1;//标记该进程已经执行完毕
                    tasks[i].runtime=copy_task[i].runtime;//为了计算周转时间，运行时间从备份里面还原到最开始的运行时间
                }
                else//仅剩下不足一倍的时间片，则剩余运行时间除以时间片长度<1
                {
                    temp=temp+tasks[i].runtime;//剩余运行时间不够一个时间片长度，则结束时间等于temp加上该进程的运行时间
                    tasks[i].finishtime=temp;
                    tasks[i].runflag=1;//标记该进程已经运行完毕
                    tasks[i].runtime=copy_task[i].runtime;
                }
            }
        }
    }
 return 0;
}


int charge()//判断是否全部进程都执行完毕
{
    int k;
    int superflag=0;//判断是否全部的进程都执行完毕
    for(k=0; k<counter; k++)
    {
        if(tasks[k].runflag==0)//只要
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


int pinput() /*进程参数输入*/
{
    int i;
    printf("请输入进程个数:\n");
    scanf("%d",&counter);
    printf("请输入时间片长度:\n");
    scanf("%d",&timecounter);
    for(i=0; i<counter; i++)
    {
        printf("******************************************\n");
 printf("请输入进程名称、到达时间、服务时间：（中间用空格隔开）\n");
 scanf("%s%f%f",tasks[i].name,&tasks[i].arrivetime,&tasks[i].runtime);


        tasks[i].starttime=0;
        tasks[i].finishtime=0;
        tasks[i].runflag=0;  //运行是否结束
        tasks[i].startflag=0;//是否首次被执行
    }
    return 0;
}


int poutput() /*调度结果输出*/
{
    int i;
    float zztime=0,dqzztime=0,f1,f2,w=0;
    printf("进程名 到达时间 服务时间 完成时间 周转时间 带权周转时间\n");
    for(i=0; i<counter; i++)
    {
        f1=tasks[i].finishtime-tasks[i].arrivetime;
        f2=f1 / (float)tasks[i].runtime;
        zztime+=f1;
        dqzztime+=f2;
        printf("%s\t%5.3f\t%5.3f\t%5.3f\t  %5.3f\t   %5.3f\n",tasks[i].name,tasks[i].arrivetime,tasks[i].runtime,tasks[i].finishtime,f1,f2);
    }
    printf("平均周转时间=%5.2f\n",zztime/counter);
    printf("平均带权周转时间=%5.2f\n",dqzztime/counter);
	return 0;
}


void main()
{


    pinput();
    printf("时间片轮转算法。\n\n");
    time();
    poutput();
}

