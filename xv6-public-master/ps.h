struct procstatus {
   
    int pid;                    // Process ID
    
    char state[15];             //state
    
    int rtime;                  //run time
    
    int priority;               //default priority of the process is 60
    int w_timeforrunning;       //Time for which the process has been waiting (reseting this to 0 whenever the process gets to run on CPU or if a change in the queue takes place (in the case of MLFQ scheduler))
    int n_run;                  //Number of times the process was picked by the scheduler
    int cur_q;                  //Current queue
    int q[5];                   //​ Number of ticks the process has received at each of the 5 queues
};