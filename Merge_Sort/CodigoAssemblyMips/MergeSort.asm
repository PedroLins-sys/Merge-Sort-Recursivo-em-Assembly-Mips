.data
	msg_input: .asciiz "Insira os valores do array (digite 0 para encerrar):\n"
	msg_output: .asciiz "Seu array ordenado:\n"
.text
main:
    #Pergunta ao usuario
	li $v0, 4
	la $a0, msg_input
	syscall