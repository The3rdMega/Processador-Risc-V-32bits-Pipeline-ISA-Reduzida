la gp,A

# Para rodar no Rars inicializar:
# gp com 0x1001_0000
# sp com 0x1001_03FC

.data
A: .word 196, 140 

.text
	lw t0,0(gp)		#t2=1
	lw t1,4(gp)		#t3=2
	addi sp,sp -8		#salva t0 e t1 na pilha
	sw t0,0(sp)
	sw t1,4(sp)
	mv a0,t0		#argumentos 
	mv a1,t1
	jal MDC
	sw a0,0(gp)		#substitui pelo resultado de PROC
	lw t0,0(sp)		#recupera t0 e t1 da pilha
	lw t1,4(sp)
	addi sp,sp,8
FIM: 	addi a1,a1,1	#contador
	j FIM		#fim

MDC:  	beq a0,a1,FIM2
	slt t0,a0,a1
	beq t0,zero,PULA
	# bge a0,a1,PULA
	sub a1,a1,a0
	j MDC
PULA: 	sub a0,a0,a1
	j MDC
FIM2:   ret	

