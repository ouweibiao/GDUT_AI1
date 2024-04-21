/* globalCalled.S */
.global strcpy1

# Start the function: strcpy1
strcpy1:
LDRB w2,[X1],#1
STR w2,[X0],#1
CMP w2,#0   //ascii code "NUL" is the last character of a string;
BNE strcpy1
RET

