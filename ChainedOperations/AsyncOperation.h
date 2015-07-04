//
//  AsyncOperation.h
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncOperation : NSOperation

/// Override
- (void)executeWithCompletionBlock:(void (^)())completionBlock;

@end
