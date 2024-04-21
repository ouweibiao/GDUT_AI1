.global memorycopy

memorycopy:
 sub x1,x1,#1
 sub x0,x0,#1
lp:
 ldrb w3,[x1,#1]
 ldrb w4,[x1,#2]!
 str w3,[x0,#1]
 str w4,[x0,#2]!
	
 sub x2,x2,#2
 cmp x2,#0
 bne lp
ret
