#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        printf(1, "Invalidarguments\n");
    }
    else
    {
        if(set_priority(atoi(argv[1]),atoi(argv[2]))<0)
        {
            printf(1,"Invalid options\n");
        }
    }
    exit();
    
}