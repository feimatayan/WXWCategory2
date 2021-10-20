//
//  WDTNMultipartFormData.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/15.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNMultipartFormData.h"

NSString * const WDTNFromPartKey = @"name";
NSString * const WDTNFromPartFilename = @"filename";
NSString * const WDTNFromPartFileData = @"data";
NSString * const WDTNFromPartFileType = @"Content-Type";

static NSString * const FromPartKeyDefaultValue = @"data";
static NSString * const FromPartFileTypeDefaultValue = @"image/jpeg";

@implementation WDTNMultipartFormData

- (instancetype)init {
    return [self initWithURL:nil];
}

- (instancetype)initWithURL:(NSString *)strURL {
    if (self = [super init]) {
        self.url = strURL;
        _params = [[NSMutableDictionary alloc] init];
        _partArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)appendParamWithKey:(NSString *)key value:(NSString *)value {
    NSAssert(key != nil, @"url is not nil");
    NSAssert(value != nil, @"value is not nil");
    
    _params[key] = value;
}

- (void)appendParams:(NSDictionary *)params {
    NSAssert(params != nil, @"params is not nil");
    
    [_params addEntriesFromDictionary:params];
}


- (void)appendPartWithData:(NSData *)data {
    [self appendPartWithKey:nil fileName:nil data:data fileType:nil];
}

- (void)appendPartWithKey:(NSString *)key data:(NSData *)data {
    [self appendPartWithKey:key fileName:nil data:data fileType:nil];
}

- (void)appendPartWithKey:(NSString *)key data:(NSData *)data fileType:(NSString *)type {
    [self appendPartWithKey:key fileName:nil data:data fileType:type];
}

- (void)appendPartWithKey:(NSString *)key fileName:(NSString *)fileName data:(NSData *)data {
    [self appendPartWithKey:key fileName:fileName data:data fileType:nil];
}

- (void)appendPartWithKey:(NSString *)key fileName:(NSString *)fileName data:(NSData *)data fileType:(NSString *)type {
    NSAssert(data != nil, @"data is not nil");
    
    if (key == nil) {
        key = FromPartKeyDefaultValue;
    }
    if (type == nil) {
        type = FromPartFileTypeDefaultValue;
    }
    
    NSMutableDictionary *part = [NSMutableDictionary dictionary];
    part[WDTNFromPartKey] = key;
    part[WDTNFromPartFileData] = data;
    part[WDTNFromPartFilename] = fileName ?: @"";
    part[WDTNFromPartFileType] = type;
    [_partArray addObject:part];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.retFunction forKey:@"retFunction"];
    [aCoder encodeObject:self.params forKey:@"params"];
    [aCoder encodeObject:self.partArray forKey:@"partArray"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _url = [aDecoder decodeObjectForKey:@"url"];
        _retFunction = [aDecoder decodeObjectForKey:@"retFunction"];
        _params = [aDecoder decodeObjectForKey:@"params"];
        _partArray = [aDecoder decodeObjectForKey:@"partArray"];
    }
    return self;
}

@end
