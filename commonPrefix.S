.global commonPrefix
# s1 in %rdi, s2 in %rsi, i in %rax
commonPrefix:
xorq %rax, %rax # %rax = 0 = i
.L1:
movb (%rdi,%rax), %cl # %cl = M[%rdi + %rax] = s1[i]
testb %cl, %cl # %cl & %cl, sets zero flag if s1[i] == '\0'
je .L2 # if s1[i] == '\0' jump to .L2
cmpb (%rsi,%rax), %cl # %cl - M[%rsi + %rax] = s1[i] - s2[i]
jne .L2 # if s1[i] != s2[i] jump to .L2
addq $1, %rax # %rax = %rax + 1 = i + 1
jmp .L1 # jump back to .L1 (loop test)
.L2:
ret # return %eax = i

# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }

