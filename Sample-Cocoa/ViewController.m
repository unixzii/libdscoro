//
//  ViewController.m
//  Sample-Cocoa
//
//  Created by Hongyu on 10/27/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import "ViewController.h"
#import "AskViewController.h"
#import "DSCTask.h"
#import "DSCPromise.h"

@interface DSCPromise (Timer)

+ (instancetype)timeoutAfter:(NSTimeInterval)timeout;

@end

@implementation DSCPromise (Timer)

+ (instancetype)timeoutAfter:(NSTimeInterval)timeout {
    return [DSCPromise promiseWithResolver:^(void (^resolver)(id)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            resolver(nil);
        });
    }];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)askAQuestion:(id)sender {
    [[DSCTask taskWithBlock:^{
        AskViewController *vc = [[AskViewController alloc]
                                 initWithNibName:@"AskViewController" bundle:nil];
        [self presentViewControllerAsSheet:vc];
        
        NSString *answer = vc.promise.await;
        NSLog(@"fake processing: %@", answer);
        [[DSCPromise timeoutAfter:3] await];
        NSLog(@"finished processing: %@", answer);
    }] schedule];
}

@end
