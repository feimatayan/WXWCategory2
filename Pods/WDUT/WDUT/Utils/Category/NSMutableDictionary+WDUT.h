//
//  NSMutableDictionary+WDUT.h
//  WDUT
//
//  Created by WeiDian on 16/01/06.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (WDUT)

- (void)wdutRemoveObjectForKey:(id)aKey;

- (void)wdutSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (NSMutableDictionary *)wdFilterNullValue;

@end
