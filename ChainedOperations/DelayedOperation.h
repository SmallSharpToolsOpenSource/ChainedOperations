//
//  DelayedOperation.h
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

@import Foundation;

#import "AsyncOperation.h"

@interface DelayedOperation : AsyncOperation

@property (assign, nonatomic) NSUInteger delay;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name delay:(NSUInteger)delay NS_DESIGNATED_INITIALIZER;

@end
