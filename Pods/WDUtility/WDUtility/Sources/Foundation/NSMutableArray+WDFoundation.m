//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import "NSMutableArray+WDFoundation.h"

@implementation NSMutableArray (WDFoundation)

- (void)wd_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (self.count == 0 || self.count <= index) {
        [self addObject:anObject];
        [self exceptionLogWithIndex:index];
        return;
    }
    
    [self insertObject:anObject atIndex:index];
}

- (void)wd_removeObjectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        [self exceptionLogWithIndex:index];
        return;
    }
    
    [self removeObjectAtIndex:index];
}

- (void)wd_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (self.count <= index) {
        [self exceptionLogWithIndex:index];
        return;
    }
    
    [self replaceObjectAtIndex:index withObject:anObject];
}

- (void)exceptionLogWithIndex:(NSUInteger)index {
    NSString *className = NSStringFromClass([self class]);
    NSString *selectorName = NSStringFromSelector(_cmd);
    NSLog(@"*** -[%@ %@]: index (%lu) beyond bounds (%lu)", className, selectorName, (unsigned long)index, (unsigned long)self.count);
}

@end