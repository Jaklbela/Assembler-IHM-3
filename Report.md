# Отчет по ИДЗ №3
## Жмурина Ксения Игоревна, БПИ218, Вариант 26

## 6 баллов

### Код на C
```c
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
```

### Компиляция программы с оптимизацией
```sh
gcc -masm=intel \
    -fno-asynchronous-unwind-tables \
    -fno-jump-tables \
    -fno-stack-protector \
    -fno-exceptions \
    ./mainprog.c \
    -S -o ./mainprog.s
```


### Оптимизированный код на ассемблере с комментариями и максимальным использованием регистров
``` assembly

```
### Неоптимизированный код на ассемблере для сравнения с измененным
``` assembly

```

Заметим, что

### Тестовые прогоны


| Входные данные  | mainprog.c      | mainprog.s      |
|-----------------|:---------------:|:---------------:|
| 10       | 1,584897     | 1,584897      |
| 12345    | 6,581096  | 6,581096 |
| 456 | 3,402462 | 3,402462 |
| -108 | Wrong number! | Wrong number! |

Подтверждающие тесты скриншоты находятся в репозитории в файле Tests.png: https://github.com/Jaklbela/Assembler-IHM-3/blob/main/Tests.png
