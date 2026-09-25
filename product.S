.global product
# a in %rdi, b in %rsi, result in %rdx, n in %ecx
# i in %r8
product:
xorq %r8, %r8 # %r8 = 0 = i
movl %ecx, %ecx # %rcx = %ecx = n (upper bits cleared)
.L1:
cmpq %rcx, %r8 # %r8 - %rcx = i - n
jae .L2 # if i >= n jump to .L2
movss (%rdi,%r8,4), %xmm0 # %xmm0 = M[%rdi + 4 * %r8] = a[i]
mulss (%rsi,%r8,4), %xmm0 # %xmm0 = %xmm0 * M[%rsi + 4 * %r8] = a[i] * b[i]
movss %xmm0, (%rdx,%r8,4) # M[%rdx + 4 * %r8] = %xmm0, result[i] = a[i] * b[i]
addq $1, %r8 # %r8 = %r8 + 1 = i + 1
jmp .L1 # jump back to .L1 (loop test)
.L2:
ret # return (void)

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
