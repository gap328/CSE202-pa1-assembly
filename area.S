.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
movl %edi, %eax  # %eax = %edi = a
addl %esi, %eax  # %eax = %eax + %esi = a + b
addl %edx, %eax  # %eax = %eax + %edx = a + b + c
movl %eax, %ecx  # %ecx = %eax = a + b + c
shrl $31, %ecx   # %ecx = %ecx >> 31 = sign bit (1 if negative)
addl %ecx, %eax  # %eax = %eax + %ecx (round toward 0)
sarl $1, %eax    # %eax = %eax >> 1 = (a + b + c) / 2 = p
movl %eax, %r8d  # %r8d = %eax = p
movl %eax, %ecx  # %ecx = %eax = p
subl %edi, %ecx  # %ecx = %ecx - %edi = p - a
imull %ecx, %r8d # %r8d = %r8d * %ecx = p * (p - a)
movl %eax, %ecx  # %ecx = %eax = p
subl %esi, %ecx  # %ecx = %ecx - %esi = p - b
imull %ecx, %r8d # %r8d = %r8d * %ecx = p * (p - a) * (p - b)
movl %eax, %ecx  # %ecx = %eax = p
subl %edx, %ecx  # %ecx = %ecx - %edx = p - c
imull %ecx, %r8d # %r8d = %r8d * %ecx = p * (p - a) * (p - b) * (p - c)
movl %r8d, %edi  # %edi = %r8d = argument for sqrt
call sqrt        # %eax = sqrt(%edi)
ret              # return %eax
    
# n in %edi, n saved in %ebx
sqrt:
cmpl $2, %edi    # %edi - 2 = n - 2
jge .L1          # if n >= 2 jump to .L1
movl %edi, %eax  # %eax = %edi = n
ret              # return %eax = n
.L1:
pushq %rbx       # save caller's %rbx on the stack
movl %edi, %ebx  # %ebx = %edi = n
sarl $2, %edi    # %edi = %edi >> 2 = n >> 2
call sqrt        # %eax = sqrt(n >> 2)
shll $1, %eax    # %eax = %eax << 1 = sqrt(n >> 2) << 1 = small
leal 1(%rax), %ecx # %ecx = %rax + 1 = small + 1 = large
movl %ecx, %edx  # %edx = %ecx = large
imull %ecx, %edx # %edx = %edx * %ecx = large * large
cmpl %ebx, %edx  # %edx - %ebx = large * large - n
jg .L2           # if large * large > n jump to .L2 (return small)
movl %ecx, %eax  # %eax = %ecx = large
.L2:
popq %rbx        # restore caller's %rbx from the stack
ret              # return %eax

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
