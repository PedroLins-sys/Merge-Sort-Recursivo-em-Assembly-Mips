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
	la $a0, array # array
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

	li $v0, 11
	li $a0, 32
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
	#recupera o final
	lw $a3, 8($sp)

	# passa meio para merge
	addi $sp, $sp, -4
	sw $s2, 0($sp)

	# $a0 = array
	# $a1 = array aux
	# $a2 = inicio
	# $a3 = fim
	# 0($sp) = meio
	jal merge

	# libera espaço aonde meio estava alocado
	addi $sp, $sp, 4
	# recupera retorno
	lw $ra, 0($sp)
	# recupera meio
	lw $s2, 12($sp)
	# libera espaço armazenado da pilha
	addi $sp, $sp, 16

	caso_base:
	jr	$ra

merge:
	move $t0, $a2 # $t0 = inicio = i
	
	move $t1, $a2 # $t1 = inicio = k
	
	lw $t2, 0($sp) # $t2 = meio
	addi $t3, $t2, 1 # $t3 = meio + 1 = j

	move $t4, $a0
	move $t5, $a0
	move $t6, $a1

	sll	$t7, $t0, 2
	add $t4, $t4, $t7 # array[i] (endereco)

	sll	$t7, $t3, 2
	add $t5, $t5, $t7 # array[j] (endereco)
	
	sll	$t7, $t1, 2
	add $t6, $t6, $t7 # aux[k] (endereco)

	while1:
	bgt $t0, $t2, while2 # se i > meio ou j > fim  
	bgt $t3, $a3, while2 # encerra o loop
	
	lw $t7, 0($t4) # array[i] (valor)
	lw $t8, 0($t5) # array[j] (valor)
	
	bgt $t7, $t8, else1 
	
	sw $t7, 0($t6) # aux[k] = array[i]
	addi $t4, $t4, 4 # avança o endenreço para o proximo valor
	addi $t0, $t0, 1 # incrementa i 

	j skip_else1 
	
	else1:
	sw $t8, 0($t6) # aux[k] = array[j]
	addi $t5, $t5, 4 # array[j++]
	addi $t3, $t3, 1 # incrementa j

	skip_else1:

	addi $t6, $t6, 4 # aux[k++]

	j while1

	# $t0 = i
	# $t1 = k
	# $t2 = meio
	# $t3 = j
	# $t4 = array[i] (endereco)
	# $t5 = array[j] (endereco)
	# $t6 = aux[k] (endereco)
	# $t7 = array[i] (valor)
	# $t8 = array[j] (valor)

	while2:
	bgt $t0, $t2, saida3

	lw $t7, 0($t4)
	sw $t7, 0($t6) # aux[k] = array[i] 

	addi $t1, $t1, 1 # k++
	addi $t6, $t6, 4 # avança 4 bytes no enderecamento

	addi $t0, $t0, 1 # i++
	addi $t4, $t4, 4 # avança 4 bytes no enderecamento
	
	j while2
	saida3:

    while3:
	bgt $t3, $a3, saida4

	lw $t8, 0($t5)
	sw $t8, 0($t6) # aux[k] = array[j] 

	addi $t1, $t1, 1 # k++
	addi $t6, $t6, 4 # avança 4 bytes no enderecamento

	addi $t3, $t3, 1 # j++
	addi $t5, $t5, 4 # avança 4 bytes no enderecamento

	j while3
	saida4:

	move $t0, $a2 # t0 = i = inicio
	sll $t1, $t0, 2 # $t1 = inicio * 4
	
	move $t4, $a0
	add $t4, $t4, $t1 # $t4 = array[i] (endereco)

	move $t5, $a1
	add $t5, $t5, $t1 # $t5 = aux[i] (endereco)

	for:
	bgt $t0, $a3, saida5

	lw $t3, 0($t5) # $t3 = aux[i] (valor)
	sw $t3, 0($t4) # array[i] = aux[i]

	addi $t4, $t4, 4 # array[i++]
	addi $t5, $t5, 4 # aux[i++]

	addi $t0, $t0, 1 # i++

	j for
	saida5:
	jr	$ra
	
