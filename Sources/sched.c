//
//  sched.c
//  libdscoro
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#include <malloc/_malloc.h>
#include <string.h>

#include "sched.h"

static void free_task_list_node(dsco_task_list_t *node) {
    dsco_task_destroy(node->task);
    free(node);
}

dsco_sched_t *dsco_sched_open() {
    dsco_sched_t *s = (dsco_sched_t *) malloc(sizeof(dsco_sched_t));
    memset(s, 0, sizeof(dsco_sched_t));
    return s;
}

void dsco_sched_close(dsco_sched_t *s) {
    // TODO: handling the remaining tasks in the list.
    free(s);
}

void dsco_sched_add_task(dsco_sched_t *s, dsco_task_t *task) {
    dsco_task_list_t *node = (dsco_task_list_t *) malloc(sizeof(*node));
    node->next = s->tasks_head;
    if (s->tasks_head) {
        s->tasks_head->prev = node;
    }
    node->prev = NULL;
    node->task = task;
    s->tasks_head = node;
    
    // Bind the sched object.
    task->sched = s;
}

void dsco_sched_run(dsco_sched_t *s) {
    while (1) {
        char has_tasks = 0;
        dsco_task_list_t *cur = s->tasks_head;
        while (cur) {
            dsco_task_t *t = cur->task;
            if (t->flags.state == DSCO_TASK_STATE_READY) {
                has_tasks = 1;
                s->cur_task = t;
                dsco_task_switch(t);
                s->cur_task = NULL;
            } else if (t->flags.state == DSCO_TASK_STATE_DONE) {
                dsco_task_list_t *cur_tmp = cur;
                if (cur->prev) {
                    cur->prev->next = cur->next;
                    if (cur->next) {
                        cur->next->prev = cur->prev;
                    }
                } else {
                    s->tasks_head = cur->next;
                    if (s->tasks_head) {
                        s->tasks_head->prev = NULL;
                    }
                }
                cur = cur->next;
                free_task_list_node(cur_tmp);
                continue;
            }
            
            cur = cur->next;
        }
        
        if (!has_tasks) {
            // No tasks available in this schedule cycle, return the control
            // to the caller.
            break;
        }
    }
}
