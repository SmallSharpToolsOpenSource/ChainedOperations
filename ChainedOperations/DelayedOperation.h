//
//  DelayedOperation.h
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncOperation.h"

@interface DelayedOperation : AsyncOperation

@property (assign, nonatomic) NSUInteger delay;

- (instancetype)initWithName:(NSString *)name delay:(NSUInteger)delay NS_DESIGNATED_INITIALIZER;

@end
