.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
movswl %di, %edi # %edi = sign extend %di = a
movswl %si, %esi # %esi = sign extend %si = b
movswl %dx, %edx # %edx = sign extend %dx = c
movswl %cx, %ecx # %ecx = sign extend %cx = d
movl %edi, %eax # %eax = %edi = a = max1
movl %esi, %r8d # %r8d = %esi = b = max2
cmpl %esi, %edi # %edi - %esi = a - b
jge .L1 # if a >= b jump to .L1
movl %esi, %eax # %eax = %esi = b = max1
movl %edi, %r8d # %r8d = %edi = a = max2
.L1:
cmpl %eax, %edx # %edx - %eax = c - max1
jle .L2 # if c <= max1 jump to .L2
movl %eax, %r8d # %r8d = %eax = old max1 = max2
movl %edx, %eax # %eax = %edx = c = max1
jmp .L3 # jump to .L3
.L2:
cmpl %r8d, %edx # %edx - %r8d = c - max2
jle .L3 # if c <= max2 jump to .L3
movl %edx, %r8d # %r8d = %edx = c = max2
.L3:
cmpl %eax, %ecx # %ecx - %eax = d - max1
jle .L4 # if d <= max1 jump to .L4
movl %eax, %r8d # %r8d = %eax = old max1 = max2
jmp .L5 # jump to .L5
.L4:
cmpl %r8d, %ecx # %ecx - %r8d = d - max2
jle .L5 # if d <= max2 jump to .L5
movl %ecx, %r8d # %r8d = %ecx = d = max2
.L5:
movl %r8d, %eax # %eax = %r8d = max2
ret # return %ax

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
