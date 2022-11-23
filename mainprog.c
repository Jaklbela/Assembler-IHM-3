#include <stdio.h>

double my_pow (double num) {
    return num * num * num * num * num;
}

double max(double fst, double snd) {
    return (fst >= snd)? fst : snd;
}

double root(double num) {
    double iter = 0;
    double tempiter;
    double oper = max(num, (double)1);

    while (oper - iter > 1e-5 / 2) {
        tempiter = (iter + oper) / 2;
        if (my_pow(tempiter) > num) {
            oper = tempiter;
        }
        else {
            iter = tempiter;
        }
    }
    return oper;
}

int main() {
    double answer;
    double num;

    printf("Input the number not less than 0\n");
    scanf("%lf", &num);
    if (num < 0) {
        printf("Wrong number!\n");
        return 0;
    }
    answer = root(num);
    printf("The root of the out of: %lf\n", answer);

    return 0;
}
