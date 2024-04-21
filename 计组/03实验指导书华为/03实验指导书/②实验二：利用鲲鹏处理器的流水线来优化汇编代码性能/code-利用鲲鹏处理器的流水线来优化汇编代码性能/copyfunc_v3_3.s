.global memorycopy

memorycopy:
 sub x1,x1,#16
 sub x0,x0,#16
lp:
 ldp x3,x4,[x1,#16]
 ldp x5,x6,[x1,#32]
 ldp x7,x8,[x1,#48]
 ldp x9,x10,[x1,#64]!
 
 stp x3,x4,[x0,#16]
 stp x5,x6,[x0,#32]
 stp x7,x8,[x0,#48]
 stp x9,x10,[x0,#64]!
	
 sub x2,x2,#64
 cmp x2,#0
 bne lp

ret
