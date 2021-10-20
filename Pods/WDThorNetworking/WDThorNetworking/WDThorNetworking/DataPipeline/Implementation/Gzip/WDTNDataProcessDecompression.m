//
//  WDTNDataProcessDecompression.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/10.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNDataProcessDecompression.h"
#import "WDTNNetwrokErrorDefine.h"

#import <WDBJEncryptUtil/GLGzipProvider.h>


@implementation WDTNDataProcessDecompression

/**
 数据解压
 
 @param data 输入格式：NSData
 
 @return 输出格式：NSData
 */
- (id)processData:(id)data error:(NSError **)error {
    NSData *result = nil;
    if ([data isKindOfClass:[NSData class]]) {
        result = [GLGzipProvider unzip:data];
    }
    
    if (result == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:WDTNError_Decompression_failed_domain code:WDTNError_Decompression_failed userInfo:nil];
        }
    }
    return result;
}

@end
