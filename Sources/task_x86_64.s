//
//  task_x86_64.s
//  libdscoro
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

.global _dsco_task_switch
_dsco_task_switch:
    pushq %rdi
    # save the current context
    movq 24(%rdi), %rax
    leaq yielded_back(%rip), %rcx
    movq %rcx, 0(%rax)
    movq %rsp, 8(%rax)
    movq %rbp, 16(%rax)
    movq %rbx, 24(%rax)
    movq %rdi, 32(%rax)
    movq %rsi, 40(%rax)
    movq %r8, 48(%rax)
    movq %r9, 56(%rax)
    movq %r10, 64(%rax)
    movq %r11, 72(%rax)
    movq %r12, 80(%rax)
    movq %r13, 88(%rax)
    movq %r14, 96(%rax)
    movq %r15, 104(%rax)
    # prepare the new context
    movq %rdi, %rax
    movq 48(%rax), %rcx  # mov to rip later
    movq 56(%rax), %rsp
    movq 64(%rax), %rbp
    movq 72(%rax), %rbx
    movq 80(%rax), %rdi
    movq 88(%rax), %rsi
    movq 96(%rax), %r8
    movq 104(%rax), %r9
    movq 112(%rax), %r10
    movq 120(%rax), %r11
    movq 128(%rax), %r12
    movq 136(%rax), %r13
    movq 144(%rax), %r14
    movq 152(%rax), %r15
    # all is ready, let's jump
    movq %rax, %rdi
    jmpq *%rcx
yielded_back:
    popq %rdi
    xorq %rax, %rax
    ret


.global _dsco_task_trampoline
_dsco_task_trampoline:
    subq $8, %rsp
    pushq %rdi
    movq 32(%rdi), %rax
    callq *%rax
    popq %rdi
    addq $8, %rsp
    # mark the task as done
    movw $2, 46(%rdi)
    # restore the sched's context
    movq 24(%rdi), %rax
    movq 0(%rax), %rcx  # mov to rip later
    movq 8(%rax), %rsp
    movq 16(%rax), %rbp
    movq 24(%rax), %rbx
    movq 32(%rax), %rdi
    movq 40(%rax), %rsi
    movq 48(%rax), %r8
    movq 56(%rax), %r9
    movq 64(%rax), %r10
    movq 72(%rax), %r11
    movq 80(%rax), %r12
    movq 88(%rax), %r13
    movq 96(%rax), %r14
    movq 104(%rax), %r15
    jmpq *%rcx


.global _dsco_task_sched
_dsco_task_sched:
    # save the task's context
    leaq continue(%rip), %rax
    movq %rax, 48(%rdi)
    movq %rsp, 56(%rdi)
    movq %rbp, 64(%rdi)
    movq %rbx, 72(%rdi)
    movq %rdi, 80(%rdi)
    movq %rsi, 88(%rdi)
    movq %r8, 96(%rdi)
    movq %r9, 104(%rdi)
    movq %r10, 112(%rdi)
    movq %r11, 120(%rdi)
    movq %r12, 128(%rdi)
    movq %r13, 136(%rdi)
    movq %r14, 144(%rdi)
    movq %r15, 152(%rdi)
    # restore the sched's context
    movq 24(%rdi), %rax
    movq 0(%rax), %rcx  # mov to rip later
    movq 8(%rax), %rsp
    movq 16(%rax), %rbp
    movq 24(%rax), %rbx
    movq 32(%rax), %rdi
    movq 40(%rax), %rsi
    movq 48(%rax), %r8
    movq 56(%rax), %r9
    movq 64(%rax), %r10
    movq 72(%rax), %r11
    movq 80(%rax), %r12
    movq 88(%rax), %r13
    movq 96(%rax), %r14
    movq 104(%rax), %r15
    xorq %rax, %rax
    jmpq *%rcx
continue:
    ret
