# TRABALHO 1 - ASSEMBLY RISC-V
# Nome: Alexandre Ferreira
# Matricula: 120025175
# Montador utilizado: rars
# Versao: rars1_5.jar
# Download via: https://github.com/TheThirdOne/rars/releases/tag/v1.5

.data

msgI: .string "\nInforme um numero inteiro:"
msg1: .string "\nEscolha um numero entre 0 e 3.\n"
msg2: .string "\nNumero entre 0 e 9999.\n"
msg3: .string "\nEntrada 1.\n"
msg4: .string "\nEntrada 2.\n"
msg5: .string "\nEntrada 3.\n"
msg7: .string "\n\n"

msg_erro:	.string	"ERRO"
pular_linha:	.string	"\n"


vetor:		.word
NUM_MAX:	.word	0x0000270F	# 9999 (10)
NUM_MIN:	.word	0x00000000	# 0 (10)

incremento_unidade:	.word	0x00030000
incremento_dezena:	.word	0x00300000
incremento_centena:	.word	0x03000000
incremento_milhar:	.word	0x30000000


			
.text
	
li a7, 5	# Le um inteiro do console, que chamara uma funcao, dependendo da entrada
ecall
	
mv	s0, a0	# s0 guarda o primeiro argumento de entrada
		
beq 	x0, s0, cria_vetor		# caso a entrada seja 0, direciona para a funcao cria_vetor
		
addi	t0, x0, 1			# faz t0 = 1 e compara com a entrada
beq	t0, s0, soma_vetor		# caso a entrada seja 1, direciona para a funcao soma_vetor
		
addi	t0, x0, 2			# faz t0 = 2 e compara com a entrada
beq	t0, s0, imprime_vetor		# caso a entrada seja 2, direciona para a funcao imprime_vetor
		
addi	t0, x0, 3			# faz t0 = 3 e compara com a entrada
beq	t0, s0, imprime_vetor_condicao	# caso a entrada seja 3, direciona para a funcao imprime_vetor_condicao
		
bne	t0, s0, erro			# se s0 for diferente de 0, 1, 2 ou 3, direciona para label de erro

# funcao 0
cria_vetor :
		
	li a7, 5	# Le um inteiro do console	(paramentro num)
	ecall
	
	mv a3, a0	# a3 recebe o inteiro recebido do console
	
	jal x0, tratamento_erro
	
	fim_tratamento_erro_funcao_0:
		
	jal x0, double_dabble
	
	fim_double_dabble:
	
	redirecionar:
		beq 	x0, s0, vetor_criado		# caso a entrada seja 0, direciona para a funcao cria_vetor
		
		addi	t0, x0, 1			# faz t0 = 1 e compara com a entrada
		beq	t0, s0, soma_vetor_criado	# caso a entrada seja 1, direciona para a funcao soma_vetor
		
		addi	t0, t0, 1			# faz t0 = 2 e compara com a entrada
		beq	t0, s0, imprime_vetor_criado	# caso a entrada seja 2, direciona para a funcao imprime_vetor
		
		addi	t0, t0, 1			# faz t0 = 3 e compara com a entrada
		beq	t0, s0, imprime_vetor_condicao	# caso a entrada seja 3, direciona para a funcao imprime_vetor_condicao


	# IMPRIMIR O CONTEUDO DO VETOR
	vetor_criado:
	
	# IMPRIME MILHAR
		la t0, vetor	# Carrega o endereco de vetor
		lw t1, 0(t0)	# Carrega a palavra armazenada indice 0 (milhar)
	
		mv a0, t1	# a0 = t1
		li a7, 1	# imprime o conteudo de a0
		ecall
	
		li a7, 4
		la a0, pular_linha # Carrega o endereco da mensagem que faz o '\n'
		ecall
	
		# IMPRIME CENTENA
		lw t1, 4(t0)	# Carrega a palavra armazenada indice 1 (centena)
	
		mv a0, t1	# a0 = t1
		li a7, 1	# imprime o conteudo de a0
		ecall
	
		li a7, 4
		la a0, pular_linha # Carrega o endereco da mensagem que faz o '\n'
		ecall
	
		# IMPRIME DEZENA
		lw t1, 8(t0)	# Carrega a palavra armazenada indice 2 (dezena)
	
		mv a0, t1	# a0 = t1
		li a7, 1	# imprime o conteudo de a0
		ecall
	
		li a7, 4
		la a0, pular_linha # Carrega o endereco da mensagem que faz o '\n'
		ecall
	
		# IMPRIME UNIDADE
		lw t1, 12(t0)	# Carrega a palavra armazenada indice 3 (unidade)
	
		mv a0, t1	# a0 = t1
		li a7, 1	# imprime o conteudo de a0
		ecall

			
		jal x0, exit	# Pula para o endereco da label exit

# funcao 1
soma_vetor:

	li a7, 5	# Le um inteiro do console	(parametro num)
	ecall
	
	mv a3, a0	# a3 recebe o inteiro recebido do console
	
	li a7, 5	# Le um inteiro do console	(parametro i)
	ecall
	
	mv a4, a0	# a4 recebe o inteiro recebido do console
	
	jal x0, tratamento_erro
	
	fim_tratamento_erro_funcao_1:
	
	jal x0, double_dabble

	soma_vetor_criado:

	addi t4, x0, 1 	# t4 = 0+1 (t4 sera um comparador)	
	add a1, x0, x0	# Paramentro de saida, inicializado em 0
	
	# Verificando b0
	slli t0, a4, 31	
	srli t0, t0, 31 # b0
	
	bne t0, t4, b1
	
	la t0, vetor
	lw t1, 12(t0)
	add a1, a1, t1
	
	b1:
	slli t0, a4, 30
	srli t0, t0, 31 # b1
	
	bne t0, t4, b2
	
	la t0, vetor
	lw t1, 8(t0)
	add a1, a1, t1

	b2:
	slli t0, a4, 29
	srli t0, t0, 31 # b2

	bne t0, t4, b3
	
	la t0, vetor
	lw t1, 4(t0)
	add a1, a1, t1
	
	b3:
	
	slli t0, a4, 28
	srli t0, t0, 31	# b3

	bne t0, t4, fim_funcao_1
	
	la t0, vetor
	lw t1, 0(t0)
	add a1, a1, t1
	
	fim_funcao_1:
		
	mv a0, a1
	
	li a7, 1	# imprime a msg1
	ecall
		
	jal x0, exit	# Pula para o endereco da label exit

# funcao 2
imprime_vetor:

	li a7, 5	# Le um inteiro do console	(parametro num)
	ecall
	
	mv a3, a0	# a3 recebe o inteiro recebido do console
	
	li a7, 5	# Le um inteiro do console	(parametro ini)
	ecall
	
	mv a4, a0	# a4 recebe o inteiro recebido do console
	
	li a7, 5	# Le um inteiro do console 	(parametro fim)
	ecall
	
	mv a5, a0	# a5 recebe o inteiro recebido do console
	
	jal x0, tratamento_erro
	
	fim_tratamento_erro_funcao_2:
	
	jal x0, double_dabble
	
	imprime_vetor_criado:
		#beq a4, a5,


	
	la a0, msg4	# carrega o endereco da msg1 e armazena em a0
	li a7, 4	# imprime a msg1
	ecall
		
	jal x0, exit	# Pula para o endereco da label exit

# funcao 3	
imprime_vetor_condicao:

	li a7, 5	# Le um inteiro do console	(parametro num)
	ecall
	
	mv a3, a0	# a3 recebe o inteiro recebido do console
	
	li a7, 5	# Le um inteiro do console	(parametro cond)
	ecall
	
	mv a4, a0	# a4 recebe o inteiro recebido do console
	
	li a7, 5	# Le um inteiro do console 	(parametro x)
	ecall
	
	mv a5, a0	# a5 recebe o inteiro recebido do console
	
	jal x0, tratamento_erro
	
	fim_tratamento_erro_funcao_3:
	
	jal x0, double_dabble

	la a0, msg5	# carrega o endereco da msg1 e armazena em a0
	li a7, 4	# imprime a msg1
	ecall
		
	jal x0, exit	# Pula para o endereco da label exit

# double_dabble
double_dabble:

	addi	t0, x0, 15		# t0 = 0 + 15 condicao de saida do loop do double_dable
	add	t1, x0, x0		# t1 = 0 + 0  variavel que recebe incrEmento para condicao de saida do loop

	shift_left:
		slli t2, a3, 1		# t2 = a3 << 1
		addi t1, t1, 1		# incrementa t1 = t1 + 1
		
		jal x0, verifica_milhar
		
	verifica_milhar:
		srli t4, t2, 28			# t4 = t2 >> 28
		addi t5, x0, 5			# t5 = 0 + 5
		blt t4, t5, verifica_centena	# t4 < t5 : PC = verifica_centena ? PC = PC+4
		
		la t4, incremento_milhar	# t4 = (MEM[&incremento_milhar])
		lw t5, 0(t4)			# t5 = 0x30000000
		add t2, t2, t5			# t2 = t2 + 0x30000000
		jal x0, verifica_centena	# PC = verifica_centena
		
	verifica_centena:
		slli t3, t2, 4			# t3 = t2 << 4
		srli t4, t3, 28			# t4 = t3 >> 28
		addi t5, x0, 5			# t5 = 0 + 5
		blt  t4, t5, verifica_dezena	# t4 < t5 : PC = verifica_dezena ? PC = PC+4
		
		la t4, incremento_centena	# t4 = (MEM[&incremento_centena])
		lw t5, 0(t4)			# t5 = 0x03000000
		add t2, t2, t5			# t2 = t2 + t5
		jal x0, verifica_dezena		# PC = verifica_centena
		
	verifica_dezena:
		slli t3, t2, 8			# t3 = t2 << 8
		srli t4, t3, 28			# t4 = t3 >> 28
		addi t5, x0, 5			# t5 = 0 + 5
		blt  t4, t5, verifica_unidade	# t4 < t5 : PC = verifica_unidade ? PC = PC+4
		
		la t4, incremento_dezena		# t4 = (MEM[&incremento_dezena])
		lw t5, (t4)			# t5 = 0x00300000
		add t2, t2, t5			# t2 = t2 + t5
		jal x0, verifica_unidade	# PC = verifica_unidade
		
	verifica_unidade:
		slli t3, t2, 12			# t3 = t2 << 12
		srli t4, t3, 28			# t4 = t3 >> 28
		addi t5, x0, 5			# t5 = 0 + 5
		blt  t4, t5, ok			# t4 < t5 : PC = verifica_unidade ? PC = PC+4
		
		la t4, incremento_unidade	# t4 = (MEM[&incremento_unidade])
		lw t5, (t4)			# t5 = 0x00030000
		add t2, t2, t5			# t2 = t2 + t5
		jal x0, ok			# PC = ok
		
	ok:			
		mv a3, t2			# a1 = t2
		blt  t1, t0, shift_left		# t1 < t0 (i < 15): PC = shift_left : ? PC = PC+4
		slli t2, a3, 1			# t2 = a3 << 1 (shift_left final[16] para executar corretamente o algoritmo)
		srli a3, t2, 16			# a3 = t2 >> 16 (0x0000xxxx)
		
		
	# Salvar em vetor o numero gerado pelo algoritmo
		la t0, vetor
		
		srli t1, a3, 12			# t1 = a3 >> 12
		sw t1, 0(t0)			# salva o inteiro contido na casa dos milhares em vetor[0]
		
		slli t1, a3, 20			# t1 = a3 << 20
		srli t1, t1, 28			# t1 = t1 >> 28
		sw t1, 4(t0)			# salva o inteiro contido na casa das centenas em vetor[1]
		
		slli t1, a3, 24			# t1 = a3 << 24
		srli t1, t1, 28			# t1 = t1 >> 28
		sw t1, 8(t0)			# salva o inteiro contido na casa das dezenas em vetor[2]
		
		slli t1, a3, 28			# t1 = a3 << 28
		srli t1, t1, 28			# t1 = t1 >> 28
		sw t1, 12(t0)			# salva o inteiro contido na casa das unidades em vetor[3]
		
		jal x0, fim_double_dabble

tratamento_erro:

	# Verifica arg num (a3)
	la t0, NUM_MAX		# Verifica se o valor inserido eh maior que 9999
	lw t1, (t0)		# t1 = 9999
	bgt  a3, t1, erro 	# a3 > t1 : PC = erro ? PC = PC+4
	
	la t0, NUM_MIN		# Verifica se o valor inserido eh menor que 0
	lw t1, (t0)		# t1 = 0
	blt a3, t1, erro	# a3 < t1 : PC = erro ? PC = PC+4
	
	# Verifica qual funcao foi chamada e continua a tratar o erro caso nao haja erro no argumento num (a3)
	beq s0, x0, erro_funcao_0
	
	addi t1, x0, 1
	beq s0, t1, erro_funcao_1
	
	addi t1, x0, 2
	beq s0, t1, erro_funcao_2
	
	addi t1, x0, 3
	beq s0, t1, erro_funcao_3

	erro_funcao_0:
	
		jal x0, fim_tratamento_erro_funcao_0	# Pula para o endereco da label
		
	erro_funcao_1:
		
		# Verifica arg i (a4)
		addi t1, x0, 15		# t1 = 0+15
		bgt a4, t1, erro	# a4 > t1 : PC = erro ? PC = PC+4
		
		addi t1, x0, 0		# t1 = 0 + 0
		blt a4, t1, erro	# a4 < t1 : PC = erro ? PC = PC+4

		jal x0, fim_tratamento_erro_funcao_1	# Pula para o endereco da label
	
	erro_funcao_2:
		
		# Verifica arg ini e fim (a4 e a5, respectivamente)
		addi t1, x0, 3		# t1 = 0+3
		bgt a4, t1, erro	# a4 > t1 : PC = erro ? PC = PC+4
		bgt a5, t1, erro	# a5 > t1 : PC = erro ? PC = PC+4
		
		add t1, x0, x0		# t1 = 0+0
		blt a4, t1, erro	# a4 < t1 : PC = erro ? PC = PC+4
		blt a5, t1, erro	# a5 < t1 : PC = erro ? PC = PC+4

		jal x0, fim_tratamento_erro_funcao_2	# Pula para o endereco da label
			
	erro_funcao_3:
		
		# Verifica arg cond (a4)
		addi t1, x0, 15		# t1 = 0+15
		bgt a4, t1, erro	# a4 > t1 : PC = erro ? PC = PC+4
		
		addi t1, x0, 0		# t1 = 0 + 0
		blt a4, t1, erro	# a4 < t1 : PC = erro ? PC = PC+4

		jal x0, fim_tratamento_erro_funcao_3	# Pula para o endereco da label
		
	erro:
		la a0, msg_erro	# carrega o endereco da string msg_erro
		li a7, 4	# imprime msg_erro
		ecall
		
		jal x0, exit	# Pula para o endereco da label exit
		
exit:
	li a7, 10	# Exits the program with code 0
	ecall
	

		
		
		
		
