//
// Created by reeceran on 16/8/18.
// Copyright (c) 2016 Henson. All rights reserved.
//

#import "NSURLProtocol+WDFoundation.h"


@implementation NSURLProtocol (WDFoundation)

static NSMutableArray *wdProtocolArray;

+ (BOOL)registerClass:(Class)protocolClass protocolType:(WDURLProtocolType)protocolType {
    @synchronized (wdProtocolArray) {
        if (!wdProtocolArray) {
            wdProtocolArray = [[NSMutableArray alloc] initWithCapacity:3];
        }

        NSArray *array = [NSArray arrayWithArray:wdProtocolArray];
        for (NSDictionary *obj in array) {
            if ([obj[@"protocolType"] integerValue] == protocolType) {
                [wdProtocolArray removeObject:obj];
            }
            Class innerProtocolClass = obj[@"protocolClass"];
            [self unregisterClass:innerProtocolClass];
        }

        NSDictionary *dic = @{@"protocolType" : @(protocolType).stringValue, @"protocolClass" : protocolClass};
        [wdProtocolArray addObject:dic];

        NSComparator comparator = ^(NSDictionary *obj1, NSDictionary *obj2) {
            if ([obj1[@"protocolType"] integerValue] < [obj2[@"protocolType"] integerValue]) {
                return NSOrderedDescending;
            }

            if ([obj1[@"protocolType"] integerValue] > [obj2[@"protocolType"] integerValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        };
        NSArray *result = [wdProtocolArray sortedArrayUsingComparator:comparator];

        [result enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            Class innerProtocolClass = obj[@"protocolClass"];
            [self registerClass:innerProtocolClass];
        }];
    }

    return YES;
}

+ (void)unregisterClass:(Class)protocolClass protocolType:(WDURLProtocolType)protocolType {
    [self unregisterClass:protocolClass];
    @synchronized (wdProtocolArray) {
        NSArray *array = [NSArray arrayWithArray:wdProtocolArray];
        for (NSDictionary *obj in array) {
            if ([obj[@"protocolType"] integerValue] == protocolType) {
                [wdProtocolArray removeObject:obj];
            }
        }
    }
}


@end