.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
xorq %rax, %rax # %rax = 0 = total
.L1:
testq %rdi, %rdi # %rdi & %rdi, sets zero flag if head == NULL
je .L2 # if head == NULL jump to .L2
addq 8(%rdi), %rax # %rax = %rax + M[%rdi + 8] = total + head->value
movq 16(%rdi), %rdi # %rdi = M[%rdi + 16] = head->next
jmp .L1 # jump back to .L1 (loop test)
.L2:
ret # return %rax = total
# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
