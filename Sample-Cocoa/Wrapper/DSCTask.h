//
//  DSCTask.h
//  Sample-Cocoa
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct dsco_task dsco_task_t;

@interface DSCTask : NSObject

@property (readonly) dsco_task_t *rawTask;

+ (nullable instancetype)currentTask;
+ (instancetype)taskWithBlock:(void(^)(void))block;

- (void)yield;
- (void)park;
- (void)unpark;

- (void)schedule;

@end

NS_ASSUME_NONNULL_END
