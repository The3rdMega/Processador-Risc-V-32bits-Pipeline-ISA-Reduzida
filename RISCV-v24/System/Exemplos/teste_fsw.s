.data
DADO: .float 1.5, 0.5, 0

.text
la t0,DADO
flw f24,0(t0)
flw f25,4(t0)
fdiv.s f26,f24,f25
nop
nop
nop
nop
nop
fsw f26,8(t0)
nop
nop
nop
nop
nop
FIM: j FIM



