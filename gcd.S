.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
  # a in %edi, b in %esi
gcd:
testl %esi, %esi # %esi & %esi, sets zero flag if b == 0
jne .L1 # if b != 0 jump to .L1
movl %edi, %eax # %eax = %edi = a
ret # return %eax = a
.L1:
subq $8, %rsp # %rsp = %rsp - 8 (keep stack 16 byte aligned)
movl %edi, %eax # %eax = %edi = a
cltd # %edx:%eax = sign extend %eax = a
idivl %esi # %eax = a / b, %edx = a % b
movl %esi, %edi # %edi = %esi = b (new a)
movl %edx, %esi # %esi = %edx = a % b (new b)
call gcd # %eax = gcd(b, a % b)
addq $8, %rsp # %rsp = %rsp + 8 (undo the adjustment)
ret # return %eax

# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
