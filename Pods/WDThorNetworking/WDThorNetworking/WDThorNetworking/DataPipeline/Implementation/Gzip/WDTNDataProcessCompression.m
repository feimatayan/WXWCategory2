//
//  WDTNDataProcessCompression.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNDataProcessCompression.h"
#import "WDTNNetwrokErrorDefine.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>


@implementation WDTNDataProcessCompression

/**
 数据压缩

 @param data 输入格式：NSData

 @return 输出格式：NSData
 */
- (id)processData:(id)data error:(NSError **)error {
    NSData *result = nil;
    if ([data isKindOfClass:[NSData class]]) {
        result = [GLGzipProvider zip:data];
    }
    
    if (result == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:WDTNError_Compression_failed_domain code:WDTNError_Compression_failed userInfo:nil];
        }
    }
    return result;
}

@end
