//
//  DSCScheduler.h
//  Sample-Cocoa
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSCTask;

@interface DSCScheduler : NSObject

@property (readonly) DSCTask *currentTask;

+ (instancetype)schedulerForCurrentThread;

- (void)addTask:(DSCTask *)task;

- (void)run;

@end

NS_ASSUME_NONNULL_END
