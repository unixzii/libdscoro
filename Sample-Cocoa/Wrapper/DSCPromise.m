//
//  DSCPromise.m
//  Sample-Cocoa
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import "DSCPromise.h"
#import "DSCTask.h"

@interface DSCPromise ()
@property (strong, nonatomic) id result;
@end

@implementation DSCPromise {
    DSCTask *_awaitingTask;
}

+ (instancetype)promiseWithResolver:(void (^)(void (^ _Nonnull)(id _Nonnull)))resolver {
    DSCPromise *instance = [[DSCPromise alloc] init];
    resolver(^(id result) {
        instance.result = result;
        [instance->_awaitingTask unpark];
    });
    return instance;
}

- (void)setResult:(id)result {
    _result = result;
}

- (id)await {
    if (!_result) {
        _awaitingTask = [DSCTask currentTask];
        NSAssert(_awaitingTask, @"await must be called in a coroutine!");
        [_awaitingTask park];
    }
    return _result;
}

@end
