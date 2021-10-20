//
//  WDTNAFResponseSerialization.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/11.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNAFResponseSerialization.h"
#import <AFNetworking/AFNetworking.h>

@interface WDTNAFResponseSerialization ()<AFURLResponseSerialization>

@end

@implementation WDTNAFResponseSerialization

/**
 直接返回 data,由我们业务来进行解析
 */
- (nullable id)responseObjectForResponse:(nullable NSURLResponse *)response
                                    data:(nullable NSData *)data
                                   error:(NSError * _Nullable __autoreleasing *)error{
    return data;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return NO;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    WDTNAFResponseSerialization *serializer = [[[self class] allocWithZone:zone] init];
    return serializer;
}

@end
