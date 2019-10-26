//
//  DSCPromise.h
//  Sample-Cocoa
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCPromise<ResultObject> : NSObject

+ (instancetype)promiseWithResolver:(void(^)(void(^)(ResultObject)))resolver;

- (ResultObject)await;

@end

NS_ASSUME_NONNULL_END
