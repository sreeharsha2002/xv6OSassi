#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "ps.h"
int maxarr[]={1,2,4,8,16};          //max ticks array in queue
struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->rtime=0;
  p->etime=0;
  p->iotime=0;
  p->ctime=ticks;              //initialising ctime to current ticks
  p->lastexecuted=ticks;         //initialsing lastexecuted to current ticks
  p->priority=60;                 //default priority
  
  p->n_run=0;
  p->cur_q=-1;                   //for other schedulers initialisation to -1 as of no use
  #ifdef MLFQ
    p->cur_q=0;                 //if scheduler is mlfq all the processes are 0th queue intially
  #endif
  p->currentslice=0;
  p->q[0]=0;
  p->q[1]=0;
  p->q[2]=0;
  p->q[3]=0;
  p->q[4]=0;
#ifdef YESPLOT
  cprintf("%d %d %d\n", ticks, p->pid, p->cur_q);           //for plotting graph
#endif

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->etime = ticks; //endtime for a process
  #ifdef YESPLOT
  cprintf("%d %d %d\n", ticks, curproc->pid, curproc->cur_q);
  #endif
  // if(curproc->pid==3)
  //   cprintf("%d",curproc->etime-curproc->ctime);
  curproc->state = ZOMBIE;
  
  curproc->cur_q=-1;
  sched();
  panic("zombie exit");
}



void updatetimes(void)
{
  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->state==RUNNING)
    {
      p->rtime++;                        //updating runtime
      p->lastexecuted=ticks;           
      p->currentslice++;
      if(p->cur_q!=-1)
      {
        p->q[p->cur_q]++;
      }
    }
    else if(p->state==SLEEPING)
    {
      p->iotime++;
      p->lastexecuted=ticks;
    }
  }
  release(&ptable.lock);
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

int waitx(int *wtime, int *rtime)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        // cprintf("c %d",p->ctime);
        // cprintf("e %d",p->etime);
        // cprintf("r %d",p->rtime);
        // cprintf("io %d",p->iotime);
        *wtime=p->etime - p->ctime - p->iotime - p->rtime;  
        *rtime=p->rtime;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
  }
}

int 
set_priority(int new_priority,int pid)
{
  struct proc *p;
  int flag=0;
  if(new_priority<0 || new_priority>100 || pid<0)
  {
    return -1;
  }
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->pid==pid)
    {
      flag=1;
      break;
    }
  }
  
  if(flag==0)
  {
    release(&ptable.lock);
    return -1;
  }
  int old_priority=p->priority;
  p->priority = new_priority;
  release(&ptable.lock);
  if(new_priority <  old_priority) //if oldpriority is greater then we have to again schedule 
  {
    yield();
  }
  return old_priority;

}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
    #ifdef RR
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->n_run++;
      swtch(&(c->scheduler), p->context);
     
      //p->w_timeforrunning=0;
      switchkvm();
      p->lastexecuted = ticks;

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
    #endif

    #ifdef FCFS
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    struct proc * nxt=0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)//finding minimum ctimed process of all processes
    {
      if (p->state != RUNNABLE)
        continue;
      if(nxt==0)
      {
        nxt=p;
      }
      else
      {
        if (p->ctime < nxt->ctime)
        {
          nxt=p;
        }
      }
    }
    if(nxt==0)
    {
      release(&ptable.lock);
      continue;
    }
    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    c->proc = nxt;
    switchuvm(nxt);
    nxt->state = RUNNING;
    nxt->n_run++;
    swtch(&(c->scheduler), nxt->context);
    
  //  nxt->w_timeforrunning = 0;
    switchkvm();
    nxt->lastexecuted = ticks;

    // Process is done running for now.
    // It should have changed its p->state before coming back.
    c->proc = 0;  
    release(&ptable.lock);
    #endif

    #ifdef PBS
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    struct proc *nxt = 0;
    struct proc *next=0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) //finiding minimum priority
    {
      if (p->state != RUNNABLE)
        continue;
      if (nxt == 0)
      {
        nxt = p;
      }
      else
      {
        if (p->priority < nxt->priority)
        {
          nxt = p;
        }
      }
    }
    if (nxt == 0)
    {
      release(&ptable.lock);
      continue;
    }
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)//round robin for same priority things
    {
      if (p->state != RUNNABLE)
        continue;
      if (p->state==RUNNABLE && nxt->priority == p->priority)    //if the process is runnable and equal to minprioritythen we have to assign it
      {
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;
        p->n_run++;
        swtch(&(c->scheduler), p->context);
        
   //     p->w__timeforrunning = 0;
        switchkvm();
        p->lastexecuted = ticks;

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
        int flag=0;
        for(next = ptable.proc; next < &ptable.proc[NPROC]; next++)
        {
          if(next->state!=RUNNABLE)
            continue;
          if(next->state==RUNNABLE && next->priority < nxt->priority)
          {
            flag=1;
            break;
          }
        }
        if(flag==1)
        {
          break;
        }
      }
    }
    release(&ptable.lock);
    #endif

 
    #ifdef MLFQ
    acquire(&ptable.lock);//aging of proccess
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if(p->state!=RUNNABLE)
        continue;
      if(ticks - p->lastexecuted > 25)
      {
        if(p->cur_q!=0)
        {
          p->cur_q--;
          #ifdef YESPLOT
          cprintf("%d %d %d\n",ticks,p->pid,p->cur_q);
          #endif
          p->currentslice=0;
          p->lastexecuted=ticks;
        }
      }
    }
    struct proc *top=0;
    for(int i=0;i<5;i++)
    {
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      {
        if (p->state != RUNNABLE)
          continue;
        if(p->cur_q==i)
        {
          if(top==0)
          {
            top=p;
          }
          else if(p->lastexecuted < top->lastexecuted )
          {
            top=p;
          }
        }
      }
      if(top==0)
        continue;
     
      top->currentslice=0;
      while(top->state==RUNNABLE)
      {
        c->proc = top;
        switchuvm(top);
        top->state = RUNNING;
        
        swtch(&(c->scheduler), top->context);

        //p->w_timeforrunning=0;
        switchkvm();
        

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
        if(top->currentslice>=maxarr[top->cur_q])
        {
          break;
        }
      }
      if (top->currentslice >= maxarr[top->cur_q])
      {
        if (top->cur_q != 4)
        {
          //demote priority
          // if(top->cur_q==-1)
          // {
          //   if(top->state==ZOMBIE)
          //   {
          //     cprintf("ZOMBIE\n");
          //   }
          // }
          if(top->state !=ZOMBIE)
          {
          top->cur_q++;
         #ifdef YESPLOT
          cprintf("%d %d %d\n", ticks, top->pid, top->cur_q);
          #endif
          }
        }
        top->currentslice = 0;
      }
      top->n_run++;
      top->lastexecuted=ticks;
      break;
    }
    release(&ptable.lock);
    #endif


  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
char *my_strcpy(char *destination, char *source)
{
  char *start = destination;

  while (*source != '\0')
  {
    *destination = *source;
    destination++;
    source++;
  }

  *destination = '\0'; // add '\0' at the end
  return start;
}
int ps(struct procstatus *arr)
{
  struct proc *p;
  int i = 0;
  acquire(&ptable.lock);
  
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->state==UNUSED)
      continue;
    arr[i].pid=p->pid;
    arr[i].priority=p->priority;
    if(p->state==RUNNABLE)
    {
      my_strcpy(arr[i].state,"RUNNABLE");
    }
    if (p->state == RUNNING)
    {
      my_strcpy(arr[i].state, "RUNNING");
    }
    if (p->state == SLEEPING)
    {
      my_strcpy(arr[i].state, "SLEEPING");
    }
    if (p->state == ZOMBIE)
    {
      my_strcpy(arr[i].state, "ZOMBIE");
    }
    if (p->state == UNUSED)
    {
      my_strcpy(arr[i].state, "UNUSED");
    }
    if (p->state == EMBRYO)
    {
      my_strcpy(arr[i].state, "EMBRYO");
    }
    arr[i].n_run=p->n_run;
    arr[i].cur_q=p->cur_q;
    arr[i].rtime=p->rtime;
    // cprintf("NO of ticks %d",ticks);
    arr[i].w_timeforrunning=ticks - p->lastexecuted;
    arr[i].q[0]=p->q[0];
    arr[i].q[1] = p->q[1];
    arr[i].q[2] = p->q[2];
    arr[i].q[3] = p->q[3];
    arr[i].q[4] = p->q[4];
    i++;
  }
  release(&ptable.lock);
  return i;
}
