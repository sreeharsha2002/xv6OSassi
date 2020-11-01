#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "ps.h"

int main(int argc, char *argv[])
{
    if (argc < 1)
    {
        printf(1, "Invalidarguments");
    }
    else
    {
        struct procstatus *arr = malloc(100*sizeof(struct procstatus));

        int k=ps(arr);
        printf(1,"%d\n",k);
      //  printf(1, "PID   PRIORITY \tSTATE\t   R_TIME\tW_TIME\tN_RUN\tCUR_Q\tQ0  Q1  Q2  Q3  Q4\n");
        printf(1,"PID \t Priority \t State \t \t r_time \t w_time \t n_run \t cur_q \t q0 \t q1 \t q2 \t q3 \t q4 \n");
        for(int i=0;i<k;i++)
        {
           // printf(1,"%d\t%d\t%s\t %d\t%d\t%d\t%d\t%d  %d  %d  %d %d\n",arr[i].pid,arr[i].priority,arr[i].state,arr[i].rtime,arr[i].w_timeforrunning,arr[i].n_run,arr[i].cur_q,arr[i].q[0],arr[i].q[1],arr[i].q[2],arr[i].q[3],arr[i].q[4]);
           printf(1, "%d \t %d \t \t %s \t %d \t \t %d \t \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n", arr[i].pid, arr[i].priority, arr[i].state, arr[i].rtime, arr[i].w_timeforrunning, arr[i].n_run, arr[i].cur_q, arr[i].q[0], arr[i].q[1], arr[i].q[2], arr[i].q[3], arr[i].q[4]);
        //    printf(1,"%d\t",arr[i].pid);
        //    printf(1, "%d\t", arr[i].priority);
        //    printf(1, "%s", arr[i].state);
        //    printf(1, "\t%d\t", arr[i].rtime);
        //    printf(1, "%d\t", arr[i].w_timeforrunning);
        //    printf(1, "%d\t", arr[i].n_run);
        //    printf(1, "%d\t", arr[i].cur_q);
        //    printf(1, "%d    ", arr[i].q[0]);
        //    printf(1, "%d   ", arr[i].q[1]);
        //    printf(1, "%d   ", arr[i].q[2]);
        //    printf(1, "%d   ", arr[i].q[3]);
        //    printf(1, "%d\n", arr[i].q[4]);
         }
    }
    exit();
}