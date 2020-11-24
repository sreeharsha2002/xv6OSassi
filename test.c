
#include "types.h"
#include "user.h"
void benchmark(int number_of_processes)
{
    int j;
    for (j = 0; j < number_of_processes; j++)
    {
        int pid = fork();
        if (pid < 0)
        {
            printf(1, "Fork failed\n");
            continue;
        }
        if (pid == 0)
        {
            volatile int i;
            for (volatile int k = 0; k < number_of_processes; k++)
            {
                if (k <= j)
                {
                    sleep(200); //io time
                }
                else
                {
                    for (i = 0; i < 100000000; i++)
                    {
                        ; //cpu time
                    }
                }
            }
            #ifdef NOPLOT
            printf(1, "Process: %d Finished %d pid\n", j,getpid());
            #endif 
            exit();
        }
        else
        {
            ;
            set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
        }
    }
    for (j = 0; j < number_of_processes + 5; j++)
    {
        wait();
    }
    exit();
}
void cpubound(int n)
{
    int pid;
    for(int i=0;i<n;i++)
    {
        if((pid=fork()) <0)
        {
            printf(1,"fork failed");
        }
        if(pid==0)
        {
            double z=0;
            for(double x=0;x<500000.0;x+=0.02)
            {
                z=(double)z+ 9.787*89.89;
            }
            #ifdef NOPLOT
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
            #endif
            exit();
        }
    }
    while (wait()!=-1)
    {
        
    }
    
}
void iobound(int n)
{
    int pid;
    for (int i = 0; i < n; i++)
    {
        if ((pid = fork()) < 0)
        {
            printf(1, "fork failed");
        }
        if (pid == 0)
        {
            for(int j=0;j<i;j++)
            {
                sleep(10*(n-i)+1);
            }
            #ifdef NOPLOT
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
            #endif
            exit();
        }
    }
    while (wait() != -1)
    {

    }
}
void cpuandio(int n)
{
    //for even doing io and for odd doing cpu
    int pid;
    for (int i = 0; i < n; i++)
    {
        if ((pid = fork()) < 0)
        {
            printf(1, "fork failed");
        }
        if (pid == 0)
        {
            if(getpid()%2==0)
            {
            for (int j = 0; j < i; j++)
            {
                sleep(8 * (n - i+1) + 1);
            }
            }
            else
            {
                double z = 0;
                for (double x = 0; x < 500000.0; x += 0.02)
                {
                    z = (double)z + 9.787 * 89.89;
                }
            }
            
            #ifdef NOPLOT
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
            #endif
            exit();
        }
    }
    while (wait() != -1)
    {

    }
}
void randomcpuandio(int n)
{
    int pid;
    for (int i = 0; i < n; i++)
    {
        if ((pid = fork()) < 0)
        {
            printf(1, "fork failed");
        }
        if (pid == 0)
        {
            double z = 0;
            int l=0;
            for (double x = 0; x < 500000.0; x += 0.02,l++)
            {
                z = (double)z + 9.787 * 89.89;
                if(i==0)
                {
                    if(l%100000==0)
                    {
                        sleep(1);
                    }
                }
            }

            #ifdef NOPLOT
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
            #endif
            exit();
        }
    }
    while (wait() != -1)
    {
    }
}
void latefcfs(int n)
{
    int pid;
    for (int i = 0; i < n; i++)
    {
        if ((pid = fork()) < 0)
        {
            printf(1, "fork failed");
        }
        if (pid == 0)
        {
            if ( i>n/2)
            {
                for (int j = 0; j < i; j++)
                {
                    sleep(8 * (n - i+1) + 1);
                }
            }
            else
            {
                double z = 0;
                for (double x = 0; x < 500000.0; x += 0.02)
                {
                    z = (double)z + 9.787 * 89.89;
                }
            }

            #ifdef NOPLOT
            printf(1, "Process: %d Finished %d pid\n", i, getpid());
            #endif
            exit();
        }
        else
        {
            if(i<n/2)
            {
                set_priority( ( 60-(20*i)%50 ),pid);
            }
        }
        
    }
    while (wait() != -1)
    {
    }
}
int main(int argc, char *argv[])
{
    if(argc<3)
    {
        printf(1,"invalid arguments");
        exit();
    }
    switch (atoi(argv[1]))
    {
    case 1:
        benchmark(atoi(argv[2]));
        break;
    case 2:
        cpubound(atoi(argv[2]));
        break;
    case 3:
        iobound(atoi(argv[2]));
        break;
    case 4:
        cpuandio(atoi(argv[2]));
        break;
    case 5:
        randomcpuandio(atoi(argv[2]));
        break;
    case 6:
        latefcfs(atoi(argv[2]));
        break;

    default:
        break;
    }

    // for (j = 0; j < ; j++)
    // {
    //     int pid = fork();
    //     if (pid < 0)
    //     {
    //         printf(1, "Fork failed\n");
    //         continue;
    //     }
    //     if (pid == 0)
    //     {
    //         volatile int i;
    //         for (volatile int k = 0; k < number_of_processes; k++)
    //         {
    //             if (k <= j)
    //             {
    //                 sleep(200); //io time
    //             }
    //             else
    //             {
    //                 for (i = 0; i < 100000000; i++)
    //                 {
    //                     ; //cpu time
    //                 }
    //             }
    //         }
    //         // printf(1, "Process: %d Finished %d pid\n", j,getpid());
    //         exit();
    //     }
    //     else
    //     {
    //         ;
    //         set_priority(100 - (20 + j), pid); // will only matter for PBS, comment it out if not implemented yet (better priorty for more IO intensive jobs)
    //     }
    // }
    // for (j = 0; j < number_of_processes + 5; j++)
    // {
    //     wait();
    // }
    exit();
}
