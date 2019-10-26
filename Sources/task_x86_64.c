//
//  task_x86_64.c
//  libdscoro
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#ifdef __x86_64__

#include <malloc/_malloc.h>
#include <mach/mach.h>
#include <string.h>

#include "task.h"
#include "sched.h"

#define STACK_SIZE (1024 * 512)
#define STACK_ALIGN 16

// Symbol defined in `task_x86_64.s`.
extern void dsco_task_trampoline(void);

static void *stack_allocate() {
    vm_address_t addr;
    kern_return_t ret =
    vm_allocate(mach_task_self(), &addr, STACK_SIZE,
                VM_MAKE_TAG(VM_MEMORY_STACK) | VM_FLAGS_ANYWHERE);
    if (ret != ERR_SUCCESS) {
        return NULL;
    }
    
    return (void *) addr;
}

dsco_task_t *dsco_task_create(void(*proc)(void *), void *userdata) {
    void *stack = stack_allocate();
    if (!stack) {
        return NULL;
    }
    
    dsco_task_t *t = (dsco_task_t *) malloc(sizeof(dsco_task_t));
    memset(t, 0, sizeof(dsco_task_t));
    
    t->stack = stack;
    t->userdata = userdata;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
    t->ctx.rsp = t->ctx.rbp = stack + STACK_SIZE - STACK_ALIGN;
    // Reset the new stack, make the backtrace cleaner.
    *(ptrdiff_t *) t->ctx.rsp = 0;
    t->ctx.rip = &dsco_task_trampoline;
#pragma clang diagnostic pop
    t->entry_proc = proc;
    
    return t;
}

void dsco_task_destroy(dsco_task_t *task) {
    vm_deallocate(mach_task_self(), task->stack, STACK_SIZE);
    free(task);
}

#endif /* __x86_64__ */
