//
//  DelayedOperation.h
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelayedOperation : NSOperation

@property (copy, nonatomic) NSString *operationName;
@property (assign, nonatomic) NSUInteger delay;

- (instancetype)initWithOperationName:(NSString *)operationName delay:(NSUInteger)delay NS_DESIGNATED_INITIALIZER;

@end
