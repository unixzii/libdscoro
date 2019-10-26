//
//  sched.h
//  libdscoro
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#ifndef sched_h
#define sched_h

#ifdef __x86_64__
#include "ctx_x86_64.h"
#endif

#include "task.h"

struct dsco_task_list {
    struct dsco_task_list *next;
    struct dsco_task_list *prev;
    dsco_task_t *task;
};
typedef struct dsco_task_list dsco_task_list_t;

struct dsco_sched {
    dsco_ctx_t ctx;
    dsco_task_list_t *tasks_head;
    dsco_task_t *cur_task;
};
typedef struct dsco_sched dsco_sched_t;

dsco_sched_t *dsco_sched_open(void);
void dsco_sched_close(dsco_sched_t *s);
void dsco_sched_add_task(dsco_sched_t *s, dsco_task_t *task);
void dsco_sched_run(dsco_sched_t *s);

#endif /* sched_h */
