.text
#teste add
li t1, 5
li t2, 3
add t0,t1,t1

#teste sub
sub t0,t1,t2

#teste and
and t0,t1,t2

#teste or
or t0,t1,t2 #0101 #0011 #0111

#teste slt
slt t0,t2,t1

#teste store e load
sw t1, 0(gp)
lw t0, 0(gp)

#teste beq]
li t2, 5
beq t1,t2, BeqSkip

li t0, 100

BeqSkip:
jal t3, JalSkip
li t0, 200

JalSkip:
jal ra, JalSkip

