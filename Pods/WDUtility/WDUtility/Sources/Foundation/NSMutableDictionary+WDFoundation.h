//
// Created by chunlin ran on 2018/7/20.
// Copyright (c) 2018 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (WDFoundation)

- (id)wd_objectForKey:(id <NSCopying>)aKey;

- (void)wd_setObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end