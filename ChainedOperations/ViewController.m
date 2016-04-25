//
//  ViewController.m
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import "ViewController.h"

#import "Macros.h"
#import "DelayedOperation.h"
#import "CountingOperation.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text = @"Operations";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)delayingButtonTapped:(id)sender {
    [self executeDelayedOperations];
}

- (IBAction)countingButtonTapped:(id)sender {
    [self executeCountingOperations];
}

- (IBAction)blocksButtonTapped:(id)sender {
    [self executeBlocksOperations];
}

- (IBAction)singularButtonTapped:(id)sender {
    [self executeSingularOperations];
}

- (void)executeDelayedOperations {
    self.label.text = @"Delay";
    
    DelayedOperation *firstOperation = [[DelayedOperation alloc] initWithName:@"First" delay:1];
    firstOperation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"First finished";
        });
    };
    
    DelayedOperation *secondOperation = [[DelayedOperation alloc] initWithName:@"Second" delay:1];
    secondOperation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"Second finished";
        });
    };
    [secondOperation addDependency:firstOperation];
    
    DelayedOperation *thirdOperation = [[DelayedOperation alloc] initWithName:@"Third" delay:1];
    thirdOperation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"Third finished";
        });
    };
    [thirdOperation addDependency:secondOperation];
    
    [[NSOperationQueue mainQueue] addOperation:firstOperation];
    [[NSOperationQueue mainQueue] addOperation:secondOperation];
    [[NSOperationQueue mainQueue] addOperation:thirdOperation];
}

- (void)executeCountingOperations {
    self.label.text = @"Counting";

    NSMutableArray *operations = @[].mutableCopy;
    
    NSArray *amounts = @[@1, @9, @3, @7, @53, @27, @300, @700, @600, @300];
    DebugLog(@"amounts: %@", amounts);

    __block NSInteger total = 0;
    
    for (NSUInteger i=0; i<amounts.count; i++) {
        NSInteger amount = [amounts[i] integerValue];
        total += amount;
        CountingOperation *operation = [[CountingOperation alloc] initWithName:[NSString stringWithFormat:@"%li", (long)i+1] amount:amount];
        operation.completionBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (i < operations.count) {
                    CountingOperation *finishedOperation = operations[i];
                    self.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)finishedOperation.result];

                    if (finishedOperation == operations.lastObject) {
                        DebugLog(@"total: %li", (long)total);
                        DebugLog(@"result: %li", (long)finishedOperation.result);
                        MAAssert(total == finishedOperation.result, @"Result of last operation must equal total");
                    }
                }
            });
        };
        
        CountingOperation *previousOperation = operations.lastObject;
        if (previousOperation) {
            [operation addDependency:previousOperation];
        }
        
        [operations addObject:operation];
    }
    
    for (NSOperation *operation in operations) {
        [[NSOperationQueue mainQueue] addOperation:operation];
    }
}

- (void)executeBlocksOperations {
    self.label.text = @"Blocks";
    
    NSBlockOperation *firstBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        self.label.text = @"First";
    }];
    
    NSBlockOperation *secondBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        self.label.text = @"Second";
    }];
    [secondBlockOperation addDependency:firstBlockOperation];

    NSBlockOperation *thirdBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        self.label.text = @"Third";
    }];
    [thirdBlockOperation addDependency:secondBlockOperation];
    
    [[NSOperationQueue mainQueue] addOperation:firstBlockOperation];
    [[NSOperationQueue mainQueue] addOperation:secondBlockOperation];
    [[NSOperationQueue mainQueue] addOperation:thirdBlockOperation];
}

- (void)executeSingularOperations {
    self.label.text = @"Singular";
    
    NSBlockOperation *firstBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"First";
        });
    }];
    
    NSBlockOperation *secondBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"Second";
        });
    }];
    
    NSBlockOperation *thirdBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"Third";
        });
    }];

    NSOperationQueue *queue = [self singularQueue];
    [queue addOperation:firstBlockOperation];
    [queue addOperation:secondBlockOperation];
    [queue addOperation:thirdBlockOperation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        MAAssert(queue != nil, @"queue must not be nil");
    });
}

- (NSOperationQueue *)singularQueue {
    if (!self.operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
    }

    return self.operationQueue;
}

@end
