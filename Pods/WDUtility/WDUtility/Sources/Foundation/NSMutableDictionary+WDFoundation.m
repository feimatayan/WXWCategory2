//
// Created by chunlin ran on 2018/7/20.
// Copyright (c) 2018 Henson. All rights reserved.
//

#import "NSMutableDictionary+WDFoundation.h"


@implementation NSMutableDictionary (WDFoundation)

- (id)wd_objectForKey:(id <NSCopying>)aKey {
    if (!aKey) {
        return nil;
    }

    return self[aKey];
}

- (void)wd_setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (!anObject || !aKey) {
        return;
    }
    self[aKey] = anObject;
}

@end