.global memorycopy

memorycopy:
	sub x1,x1,#1
	sub x0,x0,#1
lp:
	ldrb w3,[x1,#1]
	ldrb w4,[x1,#2]
	ldrb w5,[x1,#3]
	ldrb w6,[x1,#4]!
	
	str w3,[x0,#1]
	str w4,[x0,#2]
	str w5,[x0,#3]
	str w6,[x0,#4]!
	
	sub x2,x2,#4
	cmp x2,#0
	bne lp
ret
