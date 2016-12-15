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

#define kIsReady        @"isReady"
#define kIsExecuting    @"isExecuting"
#define kIsCancelled    @"isCancelled"
#define kIsFinished     @"isFinished"

- (void)setState:(AsyncOperationState)state {
    if (_state != state) {
        if (state == AsyncOperationStateReady) {
            [self willChangeValueForKey:kIsReady];
            _state = state;
            [self didChangeValueForKey:kIsReady];
        }
        else if (state == AsyncOperationStateExecuting) {
            [self willChangeValueForKey:kIsExecuting];
            _state = state;
            [self didChangeValueForKey:kIsExecuting];
        }
        else if (state == AsyncOperationStateCancelled) {
            [self willChangeValueForKey:kIsCancelled];
            _state = state;
            [self didChangeValueForKey:kIsCancelled];
        }
        else if (state == AsyncOperationStateFinished) {
            [self willChangeValueForKey:kIsFinished];
            _state = state;
            [self didChangeValueForKey:kIsFinished];
        }
    }
}

@end
