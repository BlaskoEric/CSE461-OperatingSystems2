#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>

void read_command (char cmd[], char *par[])
{
    char line[1024];
    int count = 0, i = 0, j = 0;
    char *array[100], *pch;

    //Read line
    for(;;)
    {
        int ch = fgetc(stdin);
        line[count++] = (char) ch;
        if (ch == '\n') 
            break;
    }

    //return if command is 1 or less char
    if(count <= 1)
        return;

    //create tokens
    pch = strtok(line, " \n");

    //parse the line into words using tokens
    while( pch != NULL)
    {
        array[i++] = strdup(pch);
        pch = strtok(NULL, " \n");
    }

    //first word is the command
    strcpy (cmd, array[0]);

    //other are parameters
    for(int j = 0; j < i; j++)
        par[j] = array[j];
    par[i] = NULL;
}

//Function to clear screen at start and to print input prompt
void type_prompt()
{
    static int start = 1;

    //only done of first start
    if (start)
    {
        start = 0;
        printf ("\033[2J");             //clear screen
        printf ("\033[H");              //move cursor to home
        printf("What is Thy Bidding, My Master?\n");
    }
    
    printf("$");
}

//Main prog. Runs shell by creating child through fork to execute command
int main()
{
    char cmd[100];
    char command[100];
    char *parameters[20];
    char *envp[] = {(char *)"PATH=/bin", 0 };
    
    //repeat till break
    while(1) 
    {
        //clear and display prompt
        type_prompt();

        //read input from terminal
        read_command ( command, parameters );
        
        //parent - waits for child
        if(fork() != 0 )
            wait(NULL);

        //child - executes command
        else 
        {
            //copy /bin/ to cmd 
            strcpy(cmd, "/bin/");

            //concatenate command to end of cmd 
            strcat(cmd, command);

            //execute cmd with parameters
            if(execve(cmd, parameters, envp) <= 1 )
            {
                //if not a valid command and command was not exit
                if(strcmp(command,"exit") != 0)
                {
                    printf("I find your lack of command disturbing...\n");
                    break;
                }
                //if command was exit
                else
                    printf("You have failed me for the last time...\n");
            }
        }
        //compare if command was exit. break loop
        if(strcmp(command,"exit") == 0)
            break;
    }
    return 0; 
}
