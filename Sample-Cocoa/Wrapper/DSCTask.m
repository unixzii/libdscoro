//
//  DSCTask.m
//  Sample-Cocoa
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#include <libdscoro/dscoro.h>

#import "DSCTask.h"
#import "DSCScheduler.h"

@interface DSCTask ()

- (void)_run;

@end

static void __DSCTASK_IS_CALLING_OUT_TO_AN_BLOCK__(dsco_task_t *t) {
    DSCTask *objcTask = (__bridge DSCTask *) t->userdata;
    [objcTask _run];
    CFBridgingRelease(t->userdata);
    t->userdata = NULL;
}

@implementation DSCTask {
    dsco_task_t *_t;
    void (^_block)(void);
}

+ (instancetype)currentTask {
    return [DSCScheduler schedulerForCurrentThread].currentTask;
}

+ (instancetype)taskWithBlock:(void (^)(void))block {
    DSCTask *instance = [[self alloc] init];
    instance->_block = block;
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _t = dsco_task_create((void(*)(void *)) &__DSCTASK_IS_CALLING_OUT_TO_AN_BLOCK__,
                              (__bridge_retained void *) self);
    }
    return self;
}

- (void)yield {
    dsco_task_yield(_t);
}

- (void)park {
    dsco_task_park(_t);
}

- (void)unpark {
    dsco_task_unpark(_t);
}

- (void)schedule {
    [[DSCScheduler schedulerForCurrentThread] addTask:self];
}

- (dsco_task_t *)rawTask {
    return _t;
}

- (void)_run {
    _block();
}

@end
