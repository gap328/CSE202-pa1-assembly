.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
xorq %rcx, %rcx # %rcx = 0 = i
movl %esi, %edx # %rdx = %esi = n (upper bits cleared)
testq %rdx, %rdx # %rdx & %rdx, sets zero flag if n == 0
je .L2 # if n == 0 jump to .L2
subq $1, %rdx # %rdx = %rdx - 1 = n - 1 = j
.L1:
cmpq %rdx, %rcx # %rcx - %rdx = i - j
jge .L2 # if i >= j jump to .L2
movq (%rdi,%rcx,8), %r8 # %r8 = M[%rdi + 8 * %rcx] = arr[i]
movq (%rdi,%rdx,8), %r9 # %r9 = M[%rdi + 8 * %rdx] = arr[j]
movq %r9, (%rdi,%rcx,8) # M[%rdi + 8 * %rcx] = %r9, arr[i] = old arr[j]
movq %r8, (%rdi,%rdx,8) # M[%rdi + 8 * %rdx] = %r8, arr[j] = old arr[i]
addq $1, %rcx # %rcx = %rcx + 1 = i + 1
subq $1, %rdx # %rdx = %rdx - 1 = j - 1
jmp .L1 # jump back to .L1 (loop test)
.L2:
ret # return (void)


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
