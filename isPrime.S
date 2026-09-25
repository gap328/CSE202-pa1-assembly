.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
# n in %edi, i in %ecx
isPrime:
cmpl $2, %edi # %edi - 2 = n - 2
jl .L3 # if n < 2 jump to .L3 (not prime)
je .L2 # if n == 2 jump to .L2 (prime)
testl $1, %edi # %edi & 1 = lowest bit of n
je .L3 # if n is even jump to .L3 (not prime)
movl $3, %ecx # %ecx = 3 = i
.L1:
movl %ecx, %eax # %eax = %ecx = i
imull %ecx, %eax # %eax = %eax * %ecx = i * i
cmpl %edi, %eax # %eax - %edi = i * i - n
jg .L2 # if i * i > n jump to .L2 (prime)
movl %edi, %eax # %eax = %edi = n
cltd # %edx:%eax = sign extend %eax = n
idivl %ecx # %eax = n / i, %edx = n % i
testl %edx, %edx # %edx & %edx, sets zero flag if n % i == 0
je .L3 # if n % i == 0 jump to .L3 (not prime)
addl $2, %ecx # %ecx = %ecx + 2 = i + 2
jmp .L1 # jump back to .L1 (loop test)
.L2:
movl $1, %eax # %eax = 1 (prime)
ret # return %eax
.L3:
xorl %eax, %eax # %eax = 0 (not prime)
ret # return %eax

# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
