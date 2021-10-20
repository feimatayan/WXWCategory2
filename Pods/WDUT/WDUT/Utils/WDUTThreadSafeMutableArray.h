//
// Created by shazhou on 2018/9/6.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDUTThreadSafeMutableArray : NSMutableArray

- (NSArray *)popObjectsWithRange:(NSRange)range;

- (void)refillObjectsFromArray:(NSArray *)otherArray sortUsingComparator:(NSComparator)cmptr;

- (void)addObjectsFromArray:(NSArray *)otherArray sortUsingComparator:(NSComparator)cmptr;

- (void)addObject:(id)anObject sortUsingComparator:(NSComparator)cmptr;

@end