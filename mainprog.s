.intel_syntax noprefix				# ��������� intel
	.text						# ������ ����� ������
	.globl	my_pow					# ���������� ����� my_pow
	.type	my_pow, @function			# ����������, ��� my_pow - �������
my_pow:						# ������ my_pow
	endbr64
	push	rbp					# ������� rbp �� ����
	mov	rbp, rsp				# ��������� rsp � rbp
	movsd	QWORD PTR -8[rbp], xmm0			# �������� � ������� my_pow ���������� num
	movsd	xmm0, QWORD PTR -8[rbp]
	mulsd	xmm0, xmm0				# / ������ ������ ������������ �����
	mulsd	xmm0, QWORD PTR -8[rbp]			# ������ � ���������� num:
	mulsd	xmm0, QWORD PTR -8[rbp]			# num * num * num * num * num
	mulsd	xmm0, QWORD PTR -8[rbp]			# \ ����� ��������� �������������
	movq	rax, xmm0				# ��������� ���������� num � rax - ���������� ���������� ���������
	movq	xmm0, rax
	pop	rbp					# ������� rbp
	ret
	.size	my_pow, .-my_pow
	.globl	max					# ���������� ����� max
	.type	max, @function				# ����������, ��� max - �������
max:						# ������ max
	endbr64
	push	rbp
	mov	rbp, rsp
	movsd	QWORD PTR -8[rbp], xmm0			# �������� � ������� max ���������� fst
	movsd	QWORD PTR -16[rbp], xmm1		# �������� � ������� ���������� snd
	movsd	xmm0, QWORD PTR -8[rbp]
	comisd	xmm0, QWORD PTR -16[rbp]		# ���������� fst � snd
	jb	.L9					# ���� ������ ��� �����, ��������� � .L9
	movsd	xmm0, QWORD PTR -8[rbp]			# ��������� fst � xmm0
	jmp	.L7					# ������� � .L7
.L9:
	movsd	xmm0, QWORD PTR -16[rbp]		# ������ snd � fst
.L7:
	movq	rax, xmm0				# ���������� ���������� ���������
	movq	xmm0, rax
	pop	rbp					# ������� rbp
	ret
	.size	max, .-max
	.globl	root					# ��������� ��� root
	.type	root, @function				# ���������, ��� root - �������
root:						# ������ root
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r15					# ��������� ���������� oper
	push	r14					# ��������� ���������� tempiter
	push	r13					# ��������� ���������� iter
	sub	rsp, 8					# �������� 8 �� rsp
	movsd	QWORD PTR -32[rbp], xmm0		# �������� � ������� num
	mov	r13, QWORD PTR .LC0[rip]
	movsd	xmm0, QWORD PTR .LC1[rip]
	mov	rax, QWORD PTR -32[rbp]			# ������ num � rax
	movapd	xmm1, xmm0				# ��������� � max (double)1
	movq	xmm0, rax				# ��������� � max num
	call	max					# �������� ������� max
	movq	rax, xmm0				# ���������� ���������� ���������
	mov	r15, rax				# ��������� ���������� ��������� � oper
	jmp	.L11					# ��������� � .L11
.L14:						# ������ .L14
	movq	xmm1, r13				# ��������� iter � xmm1
	movq	xmm0, r15				# ��������� oper � xmm0
	addsd	xmm0, xmm1				# / ��������� ������� (iter + oper) / 2
	movsd	xmm1, QWORD PTR .LC2[rip]		# .
	divsd	xmm0, xmm1				# \ ������� ���������
	movq	r14, xmm0				# ��������� ���������� ��������� � tempiter
	mov	rax, r14				# ��������� tempiter � rax
	movq	xmm0, rax				# �������� tempiter � ������� my_pow
	call	my_pow					# �������� ������� my_pow
	movq	rax, xmm0				# ��������� ���������� ��������� � rax
	movq	xmm2, rax				# ��������� rax � xmm2
	comisd	xmm2, QWORD PTR -32[rbp]		# ���������� ���������� ��������� � num
	jbe	.L17					# ���� ������, ��������� � .L17
	mov	rax, r14				# ��������� tempiter � rax
	mov	r15, rax				# ��������� rax � oper
	jmp	.L11					# ��������� � .L11
.L17:
	mov	rax, r14				# ��������� tempiter � rax
	mov	r13, rax				# ��������� rax � iter
.L11:						# ������ .L11
	movq	xmm0, r15				# ��������� iter � xmm0
	movq	xmm1, r13				# ��������� oper � xmm1
	subsd	xmm0, xmm1				# �������� iter �� oper
	comisd	xmm0, QWORD PTR .LC3[rip]		# ���������� ���������� ��������� � 1�-5/2
	ja	.L14					# ���� ������, ��������� � .L14
	mov	rax, r15				# ���������� ���������� ��������� (oper)
	movq	xmm0, rax				
	add	rsp, 8					# ���������� rsp � 8
	pop	r13					# ������� iter
	pop	r14					# ������� tempiter
	pop	r15					# ������� oper
	pop	rbp					# ������� rbp
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
	.globl	main					# ��������� ��� main
	.type	main, @function				# ���������, ��� main - �������
main:						# ������ main
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r12					# ��������� ���������� answer
	sub	rsp, 24					# �������� �� rsp 24
	lea	rax, .LC4[rip]				# �������� �����
	mov	rdi, rax
	call	puts@PLT
	lea	rax, -24[rbp]
	mov	rsi, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	mov	eax, 0					# �������� eax
	call	__isoc99_scanf@PLT			# �������� num �� ����� �������
	movsd	xmm1, QWORD PTR -24[rbp]		# ������ num � xmm1
	pxor	xmm0, xmm0				# �������� 0
	comisd	xmm0, xmm1				# ���������� num � 0
	jbe	.L24					# ���� ������, ��������� � .L24
	lea	rax, .LC6[rip]				# �������� ����� � ����������� ��������� �����
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0					# �������� eax
	jmp	.L22					# ��������� � .L22
.L24:						# ������ .L24
	mov	rax, QWORD PTR -24[rbp]			# �������� num � rax
	movq	xmm0, rax				# �������� num � root
	call	root					# �������� root
	movq	rax, xmm0				# ���������� ���������� ���������
	mov	r12, rax				# ��������� ���������� ������ � answer
	mov	rax, r12				# ��������� answer � rax
	movq	xmm0, rax				# ��������� rax � xmm0
	lea	rax, .LC7[rip]				# �������� �����
	mov	rdi, rax
	mov	eax, 1					# ������ � eax 1
	call	printf@PLT				# ������� ���������
	mov	eax, 0					# �������� eax
.L22:						# ������ .L22
	mov	r12, QWORD PTR -8[rbp]			# ������ ��������� � answer
	leave
	ret