//
//  AskViewController.m
//  Sample-Cocoa
//
//  Created by Hongyu on 10/27/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

#import "AskViewController.h"

@interface AskViewController ()
@property (weak) IBOutlet NSTextField *answerField;
@property (strong, nonatomic) DSCPromise *attachedPromise;
@end

@implementation AskViewController {
    void (^_promiseResolver)(NSString *);
}

- (DSCPromise<NSString *> *)promise {
    if (!self.attachedPromise) {
        self.attachedPromise = [DSCPromise promiseWithResolver:^(void (^resolver)(NSString *)) {
            self->_promiseResolver = resolver;
        }];
    }
    return self.attachedPromise;
}

- (IBAction)submitAnswer:(id)sender {
    if (_promiseResolver) {
        _promiseResolver(self.answerField.stringValue);
    }
    
    [self dismissController:nil];
}

@end
