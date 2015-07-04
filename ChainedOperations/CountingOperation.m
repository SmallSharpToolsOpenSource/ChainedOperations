//
//  CountingOperation.m
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import "CountingOperation.h"

#import "Macros.h"

typedef NS_ENUM(NSUInteger, CountingOperationState) {
    CountingOperationStateNone = 0,
    CountingOperationStateReady = 1,
    CountingOperationStateExecuting = 2,
    CountingOperationStateCancelled = 3,
    CountingOperationStateFinished = 4
};

#pragma mark - Class Extension
#pragma mark -

@interface CountingOperation ()

@property (assign, nonatomic) CountingOperationState state;
@property (readwrite, assign, nonatomic) NSInteger amount;
@property (readwrite, assign, nonatomic) NSInteger result;

@end

@implementation CountingOperation

#pragma mark - Initialization
#pragma mark -

- (instancetype)initWithOperationName:(NSString *)operationName amount:(NSInteger)amount {
    self = [super init];
    if (self) {
        self.operationName = operationName;
        self.amount = amount > 0 ? amount : 1;
        self.state = CountingOperationStateReady;
    }
    return self;
}

#pragma mark - Base Overrides
#pragma mark -

- (void)start {
    self.state = CountingOperationStateExecuting;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (self.state != CountingOperationStateCancelled) {
            NSInteger dependencyResult = 0;
            if (self.dependencies.count) {
                NSOperation *operation = self.dependencies.firstObject;
                if ([operation isKindOfClass:[CountingOperation class]]) {
                    CountingOperation *countingOperation = (CountingOperation *)operation;
                    dependencyResult = countingOperation.result;
                }
            }
            
            self.result = dependencyResult + self.amount;
            
            self.state = CountingOperationStateFinished;
        }
    });
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self.state == CountingOperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == CountingOperationStateCancelled || self.state == CountingOperationStateFinished;
}

- (void)cancel {
    self.state = CountingOperationStateCancelled;
}

#pragma mark - Private
#pragma mark -

- (void)setState:(CountingOperationState)state {
    if (_state != state) {
        if (state == CountingOperationStateReady) {
            [self willChangeValueForKey:@"isReady"];
            _state = state;
            DebugLog(@"ready (%@)", self.operationName);
            [self didChangeValueForKey:@"isReady"];
        }
        if (state == CountingOperationStateExecuting) {
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            DebugLog(@"executing (%@)", self.operationName);
            [self didChangeValueForKey:@"isExecuting"];
        }
        if (state == CountingOperationStateCancelled) {
            [self willChangeValueForKey:@"isCancelled"];
            _state = state;
            DebugLog(@"cancelled (%@)", self.operationName);
            [self didChangeValueForKey:@"isCancelled"];
        }
        if (state == CountingOperationStateFinished) {
            [self willChangeValueForKey:@"isFinished"];
            _state = state;
            DebugLog(@"finished (%@)", self.operationName);
            [self didChangeValueForKey:@"isFinished"];
        }
    }
}

@end
