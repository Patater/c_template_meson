#include "lib/lib.h"

int test_addition(void)
{
    int sum;

    sum = add(2, 3);

    if (sum != 5)
    {
        return 1;
    }

    return 0;
}

int main(int argc, char *argv[])
{
    int ret;

    (void)argc;
    (void)argv;

    ret = test_addition();
    if (ret)
    {
        return ret;
    }

    return 0;
}
