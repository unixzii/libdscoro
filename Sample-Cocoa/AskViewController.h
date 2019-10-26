//
//  AskViewController.h
//  Sample-Cocoa
//
//  Created by Hongyu on 10/27/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DSCPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface AskViewController : NSViewController

- (DSCPromise<NSString *> *)promise;

@end

NS_ASSUME_NONNULL_END
