//
//  AsyncOperation.m
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import "AsyncOperation.h"

#import "Macros.h"

#pragma mark - Class Extension
#pragma mark -

@interface AsyncOperation ()


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
    self.state = AsyncOperationStateExecuting;
    
    [self executeWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.state != AsyncOperationStateCancelled) {
                self.state = AsyncOperationStateFinished;
            }
        });
    }];
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self.state == AsyncOperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == AsyncOperationStateCancelled || self.state == AsyncOperationStateFinished;
}

- (void)cancel {
    self.state = AsyncOperationStateCancelled;
}


#pragma mark - Private
#pragma mark -

- (void)setState:(AsyncOperationState)state {
    if (_state != state) {
        if (state == AsyncOperationStateReady) {
            [self willChangeValueForKey:@"isReady"];
            _state = state;
            [self didChangeValueForKey:@"isReady"];
        }
        if (state == AsyncOperationStateExecuting) {
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            [self didChangeValueForKey:@"isExecuting"];
        }
        if (state == AsyncOperationStateCancelled) {
            [self willChangeValueForKey:@"isCancelled"];
            _state = state;
            [self didChangeValueForKey:@"isCancelled"];
        }
        if (state == AsyncOperationStateFinished) {
            [self willChangeValueForKey:@"isFinished"];
            _state = state;
            [self didChangeValueForKey:@"isFinished"];
        }
    }
}

@end
