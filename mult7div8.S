
.global mult7div8 # make mult7div8 visible to prog1.c
# c in %dil, overflow pointer in %rsi
mult7div8:
movsbl %dil, %ecx # %ecx = sign extend %dil = c
movl %ecx, %eax # %eax = %ecx = c
shll $3, %eax # %eax = %eax << 3 = c * 8
subl %ecx, %eax # %eax = %eax - %ecx = c * 8 - c = c * 7
movsbl %al, %edx # %edx = sign extend %al = (char)(c * 7)
cmpl %eax, %edx # %edx - %eax = (char)(c * 7) - c * 7
setne (%rsi) # M[%rsi] = *overflow = 1 if they differ, 0 if equal
testl %edx, %edx # %edx & %edx, sets sign flag of product
jns .L1 # if product >= 0 jump to .L1
addl $7, %edx # %edx = %edx + 7 = product + 7 (round toward 0)
.L1:
sarl $3, %edx # %edx = %edx >> 3 = product / 8
movl %edx, %eax # %eax = %edx = product / 8
ret # return %eax
 
 
# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
