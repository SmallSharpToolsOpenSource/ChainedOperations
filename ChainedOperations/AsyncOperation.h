//
//  AsyncOperation.h
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AsyncOperationState) {
    AsyncOperationStateNone = 0,
    AsyncOperationStateReady = 1,
    AsyncOperationStateExecuting = 2,
    AsyncOperationStateCancelled = 3,
    AsyncOperationStateFinished = 4
};

@interface AsyncOperation : NSOperation

@property (assign, nonatomic) AsyncOperationState state;

/// Override
- (void)executeWithCompletionBlock:(void (^)())completionBlock;

@end
