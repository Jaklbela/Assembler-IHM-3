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
