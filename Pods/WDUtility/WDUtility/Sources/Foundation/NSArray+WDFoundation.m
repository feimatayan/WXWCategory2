//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import "NSArray+WDFoundation.h"

@implementation NSArray (WDFoundation)

- (void)wd_each:(void (^)(id obj))block {
    NSParameterAssert(block != nil);

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)wd_apply:(void (^)(id obj))block {
    NSParameterAssert(block != nil);

    [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (id)wd_match:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);

    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];

    if (index == NSNotFound)
        return nil;

    return self[index];
}

- (NSArray *)wd_select:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }]];
}

- (NSArray *)wd_reject:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    return [self wd_select:^BOOL(id obj) {
        return !block(obj);
    }];
}

- (NSArray *)wd_map:(id (^)(id obj))block {
    NSParameterAssert(block != nil);

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj) ?: [NSNull null];
        [result addObject:value];
    }];

    return result;
}

- (id)wd_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block {
    NSParameterAssert(block != nil);

    __block id result = initial;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];

    return result;
}

- (BOOL)wd_any:(BOOL (^)(id obj))block {
    return [self wd_match:block] != nil;
}

- (BOOL)wd_none:(BOOL (^)(id obj))block {
    return [self wd_match:block] == nil;
}

- (BOOL)wd_all:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);

    __block BOOL result = YES;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj)) {
            result = NO;
            *stop = YES;
        }
    }];

    return result;
}

- (BOOL)wd_corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block {
    NSParameterAssert(block != nil);

    __block BOOL result = NO;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < list.count) {
            id obj2 = list[idx];
            result = block(obj, obj2);
        } else {
            result = NO;
        }
        *stop = !result;
    }];

    return result;
}

- (NSArray *)wd_reverse {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (NSArray *)wd_unique {
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![array containsObject:obj]) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (id)wd_objectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        NSString *className = NSStringFromClass([self class]);
        NSString *selectorName = NSStringFromSelector(_cmd);
        NSLog(@"*** -[%@ %@]: index (%lu) beyond bounds (%lu)", className, selectorName, (unsigned long)index, (unsigned long)self.count);
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
