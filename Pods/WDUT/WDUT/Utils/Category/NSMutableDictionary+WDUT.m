//
//  NSMutableDictionary+WDUT.m
//  WDUT
//
//  Created by WeiDian on 16/01/06.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import "NSMutableDictionary+WDUT.h"

@implementation NSMutableDictionary (WDUT)

- (void)wdutRemoveObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }

    [self removeObjectForKey:aKey];
}

- (void)wdutSetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (nil == aKey) {
        return;
    }
    
    if (!anObject) {
        [self setObject:@"" forKey:aKey];
        return;
    }

    [self setObject:anObject forKey:aKey];
}

- (NSMutableDictionary *)wdFilterNullValue {
    if (self.count == 0) {
        return self;
    }
    NSMutableDictionary *args = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]] || (![@"" isEqualToString:obj] && ![@"null" isEqualToString:obj])) {
            args[key] = obj;
        }
    }];

    return args;
}

@end
