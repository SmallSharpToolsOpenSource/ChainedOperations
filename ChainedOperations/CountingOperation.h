//
//  CountingOperation.h
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncOperation.h"

@interface CountingOperation : AsyncOperation

@property (readonly, nonatomic) NSInteger amount;
@property (readonly, nonatomic) NSInteger result;

- (instancetype)initWithName:(NSString *)name amount:(NSInteger)amount NS_DESIGNATED_INITIALIZER;

@end
