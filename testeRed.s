.text
#teste add
li t0, 5			#WORKING
li t1, 3
add t2,t0,t0	#t0 = 10	#WORKING

#teste sub
sub s0,t0,t1	#t0 = 2		#WORKING

#teste and
and s1,t0,t1	#t0 = 1		#WORKING

#teste or
or a0,t0,t1 	#t0 = 7		#WORKING

#teste slt
slt a1,t1,t0	#t0 = 1		#WORKING

#teste store e load
sw t0, 0(gp)			#WORKING
sw t1, 4(gp)			#WORKING

lw a2, 4(gp)	#t0 = 3		#WORKING
lw a3, 0(gp)	#t0 = 5		#WORKING
#teste beq
li t1, 5
beq t0,t1, BeqSkip 	#400030 -> 400038	#WORKING
			#t0 != 100 (h64)
li a4, 100

BeqSkip:	
#teste jal
jal t6, JalSkip		#400038 -> 400040	#WORKING
li a5, 200

JalSkip:
jal ra, JalrTest	#400040 -> 400044	#WORKING
JalrTest:
jalr t6, 8(ra)		#400044 -> 40004c	#t0 = 5
li a6, 100


jal ra, end		#40004c -> 400050	#t0 = 5
end:
jalr t6, 0(ra)		#400050 -> 400050	#t0 = 5
