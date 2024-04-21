.global memorycopy

memorycopy:
  ldrb w3,[x1],#1
  str w3,[x0],#1
  sub x2,x2,#1
  cmp x2,#0
  bne memorycopy

ret
