.text
.global tart1
tart1:
	mov x0,#0
	ldr x1,=msg
	mov x2,len
	mov x8,64
	svc #0

	mov x0,123
	mov x8,93
	svc #0

.data
msg:
	.ascii "Hello World!\n"
len=.-msg
