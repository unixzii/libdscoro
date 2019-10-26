//
//  DSCScheduler.m
//  Sample-Cocoa
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#include <libdscoro/dscoro.h>

#import "DSCScheduler.h"
#import "DSCTask.h"

NSString * const kThreadDictKey = @"DSCScheduler";

@implementation DSCScheduler {
    dsco_sched_t *_s;
}

+ (instancetype)schedulerForCurrentThread {
    NSThread *thread = [NSThread currentThread];
    NSMutableDictionary *thDict = thread.threadDictionary;
    DSCScheduler *instance = [thDict objectForKey:kThreadDictKey];
    if (!instance) {
        instance = [[self alloc] init];
        [thDict setObject:instance forKey:kThreadDictKey];
    }
    return instance;
}

- (void)dealloc {
    dsco_sched_close(_s);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _s = dsco_sched_open();
    }
    return self;
}

- (void)addTask:(DSCTask *)task {
    dsco_task_t *t = task.rawTask;
    dsco_sched_add_task(_s, t);
}

- (void)run {
    @autoreleasepool {
        dsco_sched_run(_s);
    }
}

- (DSCTask *)currentTask {
    dsco_task_t *cur = _s->cur_task;
    if (!cur) {
        return nil;
    }
    
    return (__bridge DSCTask *) cur->userdata;
}

@end
