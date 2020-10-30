#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char *argv[])
{
    if(argc<2)
    {
        printf(1,"Invalidarguments");
    }
    else
    {
        int pid=fork();
        if(pid==0)
        {
            if(exec(argv[1],argv+1)<0)
            {
                printf(1,"exec failed");
                exit();
            }
        }
        else
        {
            int *wtime=(int*)malloc(sizeof(int));
            int *rtime=(int*)malloc(sizeof(int));
            if(waitx(wtime,rtime)==-1)
            {
                printf(1,"error in time thing");
            }
            //printf(1,"w %p r %p",wtime,rtime);
            printf(1,"wait time %d , run time %d\n",*wtime,*rtime);
        }
        
    }
    exit();

}