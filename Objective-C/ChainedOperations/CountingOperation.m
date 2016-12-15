//
//  CountingOperation.m
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import "CountingOperation.h"

#import "Macros.h"

#pragma mark - Class Extension
#pragma mark -

@interface CountingOperation ()

@property (readwrite, assign, nonatomic) NSInteger amount;
@property (readwrite, assign, nonatomic) NSInteger result;

@end

@implementation CountingOperation

#pragma mark - Initialization
#pragma mark -

- (instancetype)init {
    @throw nil;
}

- (instancetype)initWithName:(NSString *)name amount:(NSInteger)amount {
    self = [super init];
    if (self) {
        self.name = name;
        self.amount = amount > 0 ? amount : 1;
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (self.state != AsyncOperationStateCancelled) {
            NSInteger dependencyResult = 0;
            if (self.dependencies.count) {
                NSOperation *operation = self.dependencies.firstObject;
                if ([operation isKindOfClass:[CountingOperation class]]) {
                    CountingOperation *countingOperation = (CountingOperation *)operation;
                    dependencyResult = countingOperation.result;
                }
            }
            
            self.result = dependencyResult + self.amount;
            completionBlock();
        }
    });
}

@end
