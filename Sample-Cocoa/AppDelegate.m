//
//  AppDelegate.m
//  Sample-Cocoa
//
//  Created by Hongyu on 10/26/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import "AppDelegate.h"
#import "DSCScheduler.h"
#import "DSCTask.h"

static void runLoopObserverCb(CFRunLoopObserverRef observer,
                              CFRunLoopActivity activity, void *info)
{
    DSCScheduler *scheduler = [DSCScheduler schedulerForCurrentThread];
    [scheduler run];
}

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    CFRunLoopObserverRef ob = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting,
                                                      YES, 0, &runLoopObserverCb, NULL);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), ob, kCFRunLoopCommonModes);
}

@end
