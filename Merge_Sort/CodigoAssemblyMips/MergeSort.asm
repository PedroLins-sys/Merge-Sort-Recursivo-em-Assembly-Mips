.data
	msg_input: .asciiz "Insira os valores do array (digite 0 para encerrar):\n"
	msg_output: .asciiz "Seu array ordenado:\n"
	
	.align 2
	array: .space 400
	aux: .space 400

.text
main:
    # pergunta ao usuario
	li $v0, 4
	la $a0, msg_input
	syscall
	
	la $s0, array # aponta para o espaço alocado
	li $s1, 0 # contador de elementos, n=0
	li $t0, 0 # deslocamento do array

loop_leitura:
	# le numero do usuario
	li $v0, 5
	syscall
	move $t1, $v0 
	
	# encerra leitura
	beq	$t1, $zero, sort

	# salva valor lido no espaço alocado e incrementa o $t0 para avançar 4 bytes para o proximo inteiro
	add $t2, $s0, $t0
	sw	$t1, 0($t2)
	addi $t0, $t0, 4

	# n++
	addi $s1, $s1, 1

	j loop_leitura

sort:
	# parametros
	move $a0, array # array
	la $a1, aux # array auxiliar
	li $a2, 0 # inicio
	addi $a3, $s1, -1 # fim (n-1)

	jal merge_sort
	j imprime_array

imprime_array: 
	li $t0, 0 # deslocamento de bytes
	li $t1, 0 # iterador i

loop_imprime:
	# se i >= n
	bge $t1, $s1, fim

	add $t2, $s0, $t0 
	
	# imprimir elemento do indice i do array 
	li $v0, 1
	lw $a0, 0($t2)
	syscall

	addi $t0, $t0, 4
	addi $t1, $t1, 1

	j loop_imprime

fim:
	li $v0, 10
	syscall

merge_sort:
	# se inicio>fim
	bge	$a2, $a3, caso_base

	# abre 16 bytes de espaço
	# armazena o endereço de retorno
	# armazena inicio, final e meio 
	addi $sp, $sp, -16
	sw $ra, 0($sp)	
	sw $a2, 4($sp)
	sw $a3, 8($sp)
	sw $s2, 12($sp)

	# meio
	sub $s2, $a3, $a2 # $s2 = fim - inicio
	srl	$s2, $s2, 1 # $s2 = (fim - inicio)/2
	add $s2, $a2, $s2 # $s2 = inicio + (fim - inicio)/2

	# chamada do merge-sort a esquerda, final = meio
	move $a3, $s2 
	jal merge_sort

	# recupera o final
	lw $a3, 8($sp)

	# chamada do merge-sort a direita, inicio = meio + 1
	addi $t1, $s2, 1
	move $a2, $t1
	jal merge_sort

	# recupera o inicio
	lw $a2, 4($sp)

	# passa meio para merge
	addi $sp, $sp, -4
	sw $s2, 0($sp)

	# $a0 = array
	# $a1 = array aux
	# $a2 = inicio
	# $a3 = fim
	# 0($sp) = meio
	jal merge

	#libera espaço aonde meio estava alocado
	addi $sp, $sp, 4
	#recupera retorno
	lw $ra, 0($sp)
	sw $s2, 12($sp)

	# libera espaço armazenado da pilha
	addi $sp, $sp, 16

	caso_base:
	jr	$ra

merge:
	jr	$ra
	
