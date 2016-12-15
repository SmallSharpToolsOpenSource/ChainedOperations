//
//  DelayedOperation.m
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import "DelayedOperation.h"

#import "Macros.h"

#define kDefaultDelay 5

#pragma mark - Class Extension
#pragma mark -

@interface DelayedOperation ()

@end

@implementation DelayedOperation

#pragma mark - Initialization
#pragma mark -

- (instancetype)init {
    @throw nil;
}

- (instancetype)initWithName:(NSString *)name delay:(NSUInteger)delay {
    self = [super init];
    if (self) {
        self.name = name;
        self.delay = delay > 0 ? delay : kDefaultDelay;
        self.state = AsyncOperationStateReady;
        self.qualityOfService = NSQualityOfServiceUserInitiated;
    }
    return self;
}

#pragma mark - Base Overrides
#pragma mark -

- (void)executeWithCompletionBlock:(void (^)())completionBlock {
    if (!completionBlock) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (self.state != AsyncOperationStateCancelled) {
            completionBlock();
        }
    });
}

@end
