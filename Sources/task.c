//
//  task.c
//  libdscoro
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#include <assert.h>

#include "task.h"

void dsco_task_yield(dsco_task_t *task) {
    dsco_task_sched(task);
}

void dsco_task_park(dsco_task_t *task) {
    task->flags.state = DSCO_TASK_STATE_WAIT;
    dsco_task_sched(task);
}

void dsco_task_unpark(dsco_task_t *task) {
    assert(task->flags.state != DSCO_TASK_STATE_DONE);
    task->flags.state = DSCO_TASK_STATE_READY;
}
