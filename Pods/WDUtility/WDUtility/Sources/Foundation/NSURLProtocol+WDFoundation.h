//
// Created by reeceran on 16/8/18.
// Copyright (c) 2016 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WDURLProtocolType) {
    WDURLProtocolTypeHybrid = 1,
    WDURLProtocolTypeImageCenter = 2,
    WDURLProtocolTypeDNS = 3,
    WDURLProtocolTypeDNSHttps = 4,
    WDURLProtocolTypeNone = 10
};


@interface NSURLProtocol (WDFoundation)

+ (BOOL)registerClass:(Class)protocolClass protocolType:(WDURLProtocolType)protocolType;

+ (void)unregisterClass:(Class)protocolClass protocolType:(WDURLProtocolType)protocolType;

@end
