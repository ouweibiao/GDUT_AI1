.global memorycopy

memorycopy:
 ldp x3,x4,[x1],#16
 stp x3,x4,[x0],#16
 sub x2,x2,#16
 cmp x2,#0
 bne memorycopy

ret
