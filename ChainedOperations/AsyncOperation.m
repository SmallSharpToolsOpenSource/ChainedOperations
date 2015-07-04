//
//  AsyncOperation.m
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import "AsyncOperation.h"

#import "Macros.h"

typedef NS_ENUM(NSUInteger, OperationState) {
    OperationStateNone = 0,
    OperationStateReady = 1,
    OperationStateExecuting = 2,
    OperationStateCancelled = 3,
    OperationStateFinished = 4
};

#pragma mark - Class Extension
#pragma mark -

@interface AsyncOperation ()

@property (assign, nonatomic) OperationState state;

@end

@implementation AsyncOperation

- (void)executeWithCompletionBlock:(void (^)())completionBlock {
    // Override
    
    if (completionBlock) {
        completionBlock();
    }
}

#pragma mark - Base Overrides
#pragma mark -

- (void)start {
    self.state = OperationStateExecuting;
    
    [self executeWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.state != OperationStateCancelled) {
                self.state = OperationStateFinished;
            }
        });
    }];
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self.state == OperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == OperationStateCancelled || self.state == OperationStateFinished;
}

- (void)cancel {
    self.state = OperationStateCancelled;
}


#pragma mark - Private
#pragma mark -

- (void)setState:(OperationState)state {
    if (_state != state) {
        if (state == OperationStateReady) {
            [self willChangeValueForKey:@"isReady"];
            _state = state;
            [self didChangeValueForKey:@"isReady"];
        }
        if (state == OperationStateExecuting) {
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            [self didChangeValueForKey:@"isExecuting"];
        }
        if (state == OperationStateCancelled) {
            [self willChangeValueForKey:@"isCancelled"];
            _state = state;
            [self didChangeValueForKey:@"isCancelled"];
        }
        if (state == OperationStateFinished) {
            [self willChangeValueForKey:@"isFinished"];
            _state = state;
            [self didChangeValueForKey:@"isFinished"];
        }
    }
}

@end
