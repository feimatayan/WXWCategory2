//
//  WDTNDataProcessJSONSerialization.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/11.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNDataProcessJSONSerialization.h"
#import "WDTNUtils.h"
#import "WDTNNetwrokErrorDefine.h"

@implementation WDTNDataProcessJSONSerialization

/**
 json 解析

 @param data responseData

 @return Dictionary类型的结果
 */
- (id)processData:(id)data error:(NSError **)error {
    NSData *result = nil;
    if ([data isKindOfClass:[NSData class]]) {
        result = [WDTNUtils jsonParse:data];
    }
    
    if (result == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:WDTNError_JsonParse_failed_domain code:WDTNError_JsonParse_failed userInfo:nil];
        }
    }
    return result;
}

@end
