//
//  Macros.h
//  ChainedOperations
//
//  Created by Brennan Stehling on 7/4/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

#ifndef ChainedOperations_Macros_h
#define ChainedOperations_Macros_h

// Make sure NDEBUG is defined on Release
#ifndef NDEBUG
#define DebugLog(message, ...) NSLog(@"%s: " message, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define DebugLog(message, ...)
#endif

#ifndef NS_BLOCK_ASSERTIONS

// Credit: http://sstools.co/maassert
#define MAAssert(expression, ...) \
do { \
if(!(expression)) { \
NSLog(@"Assertion failure: %s in %s on line %s:%d. %@", #expression, __func__, __FILE__, __LINE__, [NSString stringWithFormat: @"" __VA_ARGS__]); \
abort(); \
} \
} while(0)

#else

#define MAAssert(expression, ...)

#endif

#endif
