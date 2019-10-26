//
//  Tests.m
//  Tests
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import <XCTest/XCTest.h>

#include <stdio.h>
#include <libdscoro/dscoro.h>

void test_proc(dsco_task_t *task_self) {
    printf("%s\n", __PRETTY_FUNCTION__);
    for (int i = 0; i < 10; i++) {
        printf("iteration %d\n", i);
        dsco_task_sched(task_self);
    }
    return;
}

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    
}

- (void)tearDown {
    
}

- (void)testExample {
    dsco_sched_t *s = dsco_sched_open();
    dsco_task_t *task = dsco_task_create(test_proc, NULL);
    dsco_sched_add_task(s, task);
    dsco_sched_run(s);
}

- (void)testPerformanceExample {
    
}

@end
