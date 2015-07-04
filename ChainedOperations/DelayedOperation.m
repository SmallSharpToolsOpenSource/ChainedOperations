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

typedef NS_ENUM(NSUInteger, DelayedOperationState) {
    DelayedOperationStateNone = 0,
    DelayedOperationStateReady = 1,
    DelayedOperationStateExecuting = 2,
    DelayedOperationStateCancelled = 3,
    DelayedOperationStateFinished = 4
};

#pragma mark - Class Extension
#pragma mark -

@interface DelayedOperation ()

@property (assign, nonatomic) DelayedOperationState state;

@end

@implementation DelayedOperation

#pragma mark - Initialization
#pragma mark -

- (instancetype)initWithOperationName:(NSString *)operationName delay:(NSUInteger)delay {
    self = [super init];
    if (self) {
        self.operationName = operationName;
        self.delay = delay > 0 ? delay : kDefaultDelay;
        self.state = DelayedOperationStateReady;
    }
    return self;
}

#pragma mark - Base Overrides
#pragma mark -

- (void)start {
    self.state = DelayedOperationStateExecuting;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (self.state != DelayedOperationStateCancelled) {
            self.state = DelayedOperationStateFinished;
        }
    });
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self.state == DelayedOperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == DelayedOperationStateCancelled || self.state == DelayedOperationStateFinished;
}

- (void)cancel {
    self.state = DelayedOperationStateCancelled;
}

#pragma mark - Private
#pragma mark -

- (void)setState:(DelayedOperationState)state {
    if (_state != state) {
        if (state == DelayedOperationStateReady) {
            [self willChangeValueForKey:@"isReady"];
            _state = state;
            DebugLog(@"ready (%@)", self.operationName);
            [self didChangeValueForKey:@"isReady"];
        }
        if (state == DelayedOperationStateExecuting) {
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            DebugLog(@"executing (%@)", self.operationName);
            [self didChangeValueForKey:@"isExecuting"];
        }
        if (state == DelayedOperationStateCancelled) {
            [self willChangeValueForKey:@"isCancelled"];
            _state = state;
            DebugLog(@"cancelled (%@)", self.operationName);
            [self didChangeValueForKey:@"isCancelled"];
        }
        if (state == DelayedOperationStateFinished) {
            [self willChangeValueForKey:@"isFinished"];
            _state = state;
            DebugLog(@"finished (%@)", self.operationName);
            [self didChangeValueForKey:@"isFinished"];
        }
    }
}

@end
