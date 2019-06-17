#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char buf[512];

int
main(int argc, char *argv[])
{
  int fd0, fd1, fd2, i;

  if(argc <= 2){
    printf(1, "Need 2 Arguments!\n");
    exit();
  }

    if((fd0 = open(argv[1], O_RDONLY)) < 0)
    {
        printf(1, "cp: cannot open %s\n", argv[1]);
        exit();
    }
    if((fd1 = open(argv[2], O_CREATE|O_RDWR)) < 0)
    {
        printf(1, "cp: cannot open %s\n", argv[2]);
        exit();
    }

    if(argc > 3)
    {
        if((fd2 = open(argv[3], O_CREATE|O_RDWR)) < 0)
        {
            printf(1, "cp: cannot open %s\n", argv[3]);
            exit();
        }
    }
    
    while (( i = read ( fd0, buf, sizeof(buf))) > 0 ) 
    { 
        write(fd1, buf, i);
        if(argc > 3)
            write(fd2,buf,i);
    }
    
    close(fd0);
    close(fd1);
    if(argc > 3)
        close(fd2);
  
  exit();
}
