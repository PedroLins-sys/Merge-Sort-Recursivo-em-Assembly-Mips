.data
	msg_input: .asciiz "Insira os valores do array (digite 0 para encerrar):\n"
	msg_output: .asciiz "Seu array ordenado:\n"
	
	.align 2
	array: .space 400

.text
main:
    #pergunta ao usuario
	li $v0, 4
	la $a0, msg_input
	syscall
	
	la $s0, array #aponta para o espaço alocado
	li $s1, 0 #contador de elementos, n=0
	li $t0, 0 #deslocamento do array

loop_leitura:
	#le numero do usuario
	li $v0, 5
	syscall
	move $t1, $v0 
	
	#encerra leitura
	beq	$t1, $zero, imprime_array

	#salva valor lido no espaço alocado e incrementa o $t0 para avançar 4 bytes para o proximo inteiro
	add $t2, $s0, $t0
	sw	$t1, 0($t2)
	addi $t0, $t0, 4

	#n++
	addi $s1, $s1, 1

	j loop_leitura

imprime_array: 
	li $t0, 0 # deslocamento de bytes
	li $t1, 0 # iterador i

loop_imprime:
	# se i >= n
	bge $t1, $s1, fim

	add $t2, $s0, $t0 
	
	#imprimir elemento do indice i do array 
	li $v0, 1
	lw $a0, 0($t2)
	syscall

	addi $t0, $t0, 4
	addi $t1, $t1, 1

	j loop_imprime

fim:
	li $v0, 10
	syscall