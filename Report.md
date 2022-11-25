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
	.intel_syntax noprefix				# Синтаксис intel
	.text						# Начало новой секции
	.globl	my_pow					# Объявление имени my_pow
	.type	my_pow, @function			# Объявление, что my_pow - функция
my_pow:						# Секция my_pow
	endbr64
	push	rbp					# Пускаем rbp на стек
	mov	rbp, rsp				# Переносим rsp в rbp
	movsd	QWORD PTR -8[rbp], xmm0			# Передача в функцию my_pow переменной num
	movsd	xmm0, QWORD PTR -8[rbp]
	mulsd	xmm0, xmm0				# / Данная секция представляет собой
	mulsd	xmm0, QWORD PTR -8[rbp]			# строку с умножением num:
	mulsd	xmm0, QWORD PTR -8[rbp]			# num * num * num * num * num
	mulsd	xmm0, QWORD PTR -8[rbp]			# \ Здесь умножение заканчивается
	movq	rax, xmm0				# Переносим полученный num в rax - возвращаем полученный результат
	movq	xmm0, rax
	pop	rbp					# Удаляем rbp
	ret
	.size	my_pow, .-my_pow
	.globl	max					# Объявление имени max
	.type	max, @function				# Объявление, что max - функция
max:						# Секция max
	endbr64
	push	rbp
	mov	rbp, rsp
	movsd	QWORD PTR -8[rbp], xmm0			# Передача в функцию max переменной fst
	movsd	QWORD PTR -16[rbp], xmm1		# Передача в функцию переменной snd
	movsd	xmm0, QWORD PTR -8[rbp]
	comisd	xmm0, QWORD PTR -16[rbp]		# Сравниваем fst и snd
	jb	.L9					# Если больше или равно, переходим к .L9
	movsd	xmm0, QWORD PTR -8[rbp]			# Переносим fst в xmm0
	jmp	.L7					# Переход к .L7
.L9:
	movsd	xmm0, QWORD PTR -16[rbp]		# Кладем snd в fst
.L7:
	movq	rax, xmm0				# Возвращаем полученный результат
	movq	xmm0, rax
	pop	rbp					# Удаляем rbp
	ret
	.size	max, .-max
	.globl	root					# Объявляем имя root
	.type	root, @function				# Объявляем, что root - функция
root:						# Секция root
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r15					# Объявляем переменную oper
	push	r14					# Объявляем переменную tempiter
	push	r13					# Объявляем переменную iter
	sub	rsp, 8					# Вычитаем 8 из rsp
	movsd	QWORD PTR -32[rbp], xmm0		# Передаем в функцию num
	mov	r13, QWORD PTR .LC0[rip]
	movsd	xmm0, QWORD PTR .LC1[rip]
	mov	rax, QWORD PTR -32[rbp]			# Кладем num в rax
	movapd	xmm1, xmm0				# Переносим в max (double)1
	movq	xmm0, rax				# Переносим в max num
	call	max					# Вызываем функцию max
	movq	rax, xmm0				# Возвращаем полученный результат
	mov	r15, rax				# Переносим полученный результат в oper
	jmp	.L11					# Переходим в .L11
.L14:						# Секция .L14
	movq	xmm1, r13				# Переносим iter в xmm1
	movq	xmm0, r15				# Переносим oper в xmm0
	addsd	xmm0, xmm1				# / Выполняем строчку (iter + oper) / 2
	movsd	xmm1, QWORD PTR .LC2[rip]		# .
	divsd	xmm0, xmm1				# \ Строчка выполнена
	movq	r14, xmm0				# Переносим полученный результат в tempiter
	mov	rax, r14				# Переносим tempiter в rax
	movq	xmm0, rax				# Передаем tempiter в функцию my_pow
	call	my_pow					# Вызываем функцию my_pow
	movq	rax, xmm0				# Переносим полученный результат в rax
	movq	xmm2, rax				# Переносим rax в xmm2
	comisd	xmm2, QWORD PTR -32[rbp]		# Сравниваем полученный результат и num
	jbe	.L17					# Если меньше, переходим к .L17
	mov	rax, r14				# Переносим tempiter в rax
	mov	r15, rax				# Переносим rax в oper
	jmp	.L11					# Переходим к .L11
.L17:
	mov	rax, r14				# Переносим tempiter в rax
	mov	r13, rax				# Переносим rax в iter
.L11:						# Секция .L11
	movq	xmm0, r15				# Переносим iter в xmm0
	movq	xmm1, r13				# Переносим oper в xmm1
	subsd	xmm0, xmm1				# Вычитаем iter из oper
	comisd	xmm0, QWORD PTR .LC3[rip]		# Сравниваем полученный результат с 1е-5/2
	ja	.L14					# Если больше, переходим к .L14
	mov	rax, r15				# Возвращаем полученный результат (oper)
	movq	xmm0, rax				
	add	rsp, 8					# Складываем rsp и 8
	pop	r13					# Удаляем iter
	pop	r14					# Удаляем tempiter
	pop	r15					# Удаляем oper
	pop	rbp					# Удаляем rbp
	ret
	.size	root, .-root
	.section	.rodata
	.align 8
.LC4:
	.string	"Input the number not less than 0"
.LC5:
	.string	"%lf"
.LC6:
	.string	"Wrong number!"
.LC7:
	.string	"The root of the out of: %lf\n"
	.text
	.globl	main					# Объявляем имя main
	.type	main, @function				# Объявляем, что main - функция
main:						# Секция main
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r12					# Объявляем переменную answer
	sub	rsp, 24					# Вычитаем из rsp 24
	lea	rax, .LC4[rip]				# Печатаем текст
	mov	rdi, rax
	call	puts@PLT
	lea	rax, -24[rbp]
	mov	rsi, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	mov	eax, 0					# Обнуляем eax
	call	__isoc99_scanf@PLT			# Получаем num из ввода консоли
	movsd	xmm1, QWORD PTR -24[rbp]		# Кладем num в xmm1
	pxor	xmm0, xmm0				# Получаем 0
	comisd	xmm0, xmm1				# Сравниваем num и 0
	jbe	.L24					# Если больше, переходим к .L24
	lea	rax, .LC6[rip]				# Печатаем текст о неправильно введенном числе
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0					# Обнуляем eax
	jmp	.L22					# Переходим к .L22
.L24:						# Секция .L24
	mov	rax, QWORD PTR -24[rbp]			# Передаем num в rax
	movq	xmm0, rax				# Передаем num в root
	call	root					# Вызываем root
	movq	rax, xmm0				# Возвращаем полученный результат
	mov	r12, rax				# Переносим полученный корень в answer
	mov	rax, r12				# Переносим answer в rax
	movq	xmm0, rax				# Переносим rax в xmm0
	lea	rax, .LC7[rip]				# Печатаем текст
	mov	rdi, rax
	mov	eax, 1					# Кладем в eax 1
	call	printf@PLT				# Выводим результат
	mov	eax, 0					# Обнуляем eax
.L22:						# Секция .L22
	mov	r12, QWORD PTR -8[rbp]			# Кладем результат в answer
	leave
	ret
```
### Неоптимизированный код на ассемблере для сравнения с измененным
``` assembly
.file	"mainprog.c"
	.text
	.globl	my_pow
	.type	my_pow, @function
my_pow:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	-8(%rbp), %xmm0
	mulsd	-8(%rbp), %xmm0
	mulsd	-8(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	my_pow, .-my_pow
	.globl	max
	.type	max, @function
max:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	movsd	-8(%rbp), %xmm0
	comisd	-16(%rbp), %xmm0
	jb	.L9
	movsd	-8(%rbp), %xmm0
	jmp	.L7
.L9:
	movsd	-16(%rbp), %xmm0
.L7:
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	max, .-max
	.globl	root
	.type	root, @function
root:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	subq	$8, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movsd	%xmm0, -32(%rbp)
	movq	.LC0(%rip), %r13
	movsd	.LC1(%rip), %xmm0
	movq	-32(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	max
	movq	%xmm0, %rax
	movq	%rax, %r15
	jmp	.L11
.L14:
	movq	%r13, %xmm1
	movq	%r15, %xmm0
	addsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %r14
	movq	%r14, %rax
	movq	%rax, %xmm0
	call	my_pow
	movq	%xmm0, %rax
	movq	%rax, %xmm2
	comisd	-32(%rbp), %xmm2
	jbe	.L17
	movq	%r14, %rax
	movq	%rax, %r15
	jmp	.L11
.L17:
	movq	%r14, %rax
	movq	%rax, %r13
.L11:
	movq	%r15, %xmm0
	movq	%r13, %xmm1
	subsd	%xmm1, %xmm0
	comisd	.LC3(%rip), %xmm0
	ja	.L14
	movq	%r15, %rax
	movq	%rax, %xmm0
	addq	$8, %rsp
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	root, .-root
	.section	.rodata
	.align 8
.LC4:
	.string	"Input the number not less than 0"
.LC5:
	.string	"%lf"
.LC6:
	.string	"Wrong number!"
.LC7:
	.string	"The root of the out of: %lf\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	subq	$40, %rsp
	.cfi_offset 12, -24
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movsd	-32(%rbp), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L25
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L22
.L25:
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	root
	movq	%xmm0, %rax
	movq	%rax, %r12
	movq	%r12, %rax
	movq	%rax, %xmm0
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	movl	$0, %eax
.L22:
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	movq	-8(%rbp), %r12
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	0
	.align 8
.LC1:
	.long	0
	.long	1072693248
	.align 8
.LC2:
	.long	0
	.long	1073741824
	.align 8
.LC3:
	.long	-1998362383
	.long	1054144693
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
```

Заметим, что неоптимизированный файл занимает 3,56 Кб, в то время как размер нового составляет 2,46 Кб - на 1,1 Кб меньше, что означает значительное уменьшение размеров нового файла

### Тестовые прогоны


| Входные данные  | mainprog.c      | mainprog.s      |
|-----------------|:---------------:|:---------------:|
| 10       | 1,584897     | 1,584897      |
| 12345    | 6,581096  | 6,581096 |
| 456 | 3,402462 | 3,402462 |
| -108 | Wrong number! | Wrong number! |

Подтверждающие тесты скриншоты находятся в репозитории в файле Tests.png: https://github.com/Jaklbela/Assembler-IHM-3/blob/main/Tests.png
