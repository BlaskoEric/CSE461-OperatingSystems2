struct params
{
    int xleft;
    int xright;
};

program RAND_PROG {
    version RAND_VERS {
        int GET_NEXT_RANDOM (params) = 1;
    } = 1;
} = 005670557;
