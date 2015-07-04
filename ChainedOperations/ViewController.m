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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text = @"Operations";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)delayButtonTapped:(id)sender {
    [self executeDelayedOperations];
}

- (IBAction)countingButtonTapped:(id)sender {
    [self executeCountingOperations];
}

- (void)executeDelayedOperations {
    self.label.text = @"Delay";
    
    DelayedOperation *firstOperation = [[DelayedOperation alloc] initWithOperationName:@"First" delay:1];
    firstOperation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"First finished";
        });
    };
    
    DelayedOperation *secondOperation = [[DelayedOperation alloc] initWithOperationName:@"Second" delay:1];
    secondOperation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"Second finished";
        });
    };
    [secondOperation addDependency:firstOperation];
    
    DelayedOperation *thirdOperation = [[DelayedOperation alloc] initWithOperationName:@"Third" delay:1];
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
        CountingOperation *operation = [[CountingOperation alloc] initWithOperationName:[NSString stringWithFormat:@"%li", (long)i+1] amount:amount];
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

@end
