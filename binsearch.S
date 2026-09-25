.global binsearch
# arr in %rdi, n in %esi, target in %edx
# lo in %ecx, hi = %r8d
binsearch:
xorl %ecx,%ecx   # %ecx = 0 lo = 0
movl %esi , %r8d #r8d = %esi = hi
subl $1, %r8d    # %r8d = %r8d -1 
.L1:
cmpl %r8d, %ecx  # %ecx - %r8d = lo - hi
jg .L4           # if lo> hi jump to .L4
movl %r8d, %eax  # %eax = %r8d =  hi 
subl %ecx, %eax  # %eax = %eax - %ecx = hi - lo 
sarl $1, %eax    # %eax >>1 = %eax / 2 = (hi - lo)/2
addl %ecx, %eax  # %eax = %eax + %ecx = lo + ((hi-lo)/2) = mid
movslq %eax, %r9 # %r9 = sign extend %eax = mid (64 bit index)
movl (%rdi,%r9,4), %r10d # %r10d = M[%rdi + 4 * %r9] = arr[mid]
cmpl %edx, %r10d # %r10d - %edx = arr[mid] - target
je .L5           # if arr[mid] == target jump to .L5 (return mid)
jl .L3           # if arr[mid] < target jump to .L3
leal -1(%rax), %r8d # %r8d = %rax - 1 = mid - 1 = hi
jmp .L1          # jump back to .L1 (loop test)
.L3:
leal 1(%rax), %ecx # %ecx = %rax + 1 = mid + 1 = lo
jmp .L1          # jump back to .L1 (loop test)
.L4:
movl $-1, %eax   # %eax = -1 (target not found)
ret              # return %eax
.L5:
ret              # return %eax


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }

