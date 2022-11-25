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