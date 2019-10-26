//
//  task.h
//  libdscoro
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#ifndef task_h
#define task_h

#include <sys/types.h>

#ifdef __x86_64__
#include "ctx_x86_64.h"
#endif

#define DSCO_TASK_STATE_READY 0
#define DSCO_TASK_STATE_WAIT 1
#define DSCO_TASK_STATE_DONE 2

struct dsco_sched;
typedef struct dsco_sched dsco_sched_t;

struct dsco_task {
    void *stack;
    size_t stack_size;
    void *userdata;
    dsco_sched_t *sched;
    void *entry_proc;
    struct {
        int32_t padding0;
        short padding1;
        short state;
    } flags;
    dsco_ctx_t ctx;
};
typedef struct dsco_task dsco_task_t;

dsco_task_t *dsco_task_create(void(*proc)(void *), void *userdata);
void dsco_task_destroy(dsco_task_t *task);

/*
 Task controls.
 */
void dsco_task_yield(dsco_task_t *task);
void dsco_task_park(dsco_task_t *task);
void dsco_task_unpark(dsco_task_t *task);

/*
 Below interface functions are exposed for the library internal usage, and
 should not be called by clients.
 */
void dsco_task_switch(dsco_task_t *task);
void dsco_task_sched(dsco_task_t *task);

#endif /* task_h */
