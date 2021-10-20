//
//  WDTNDataProcessEncryption.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/10.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNDataProcessEncryption.h"
#import "WDTNNetwrokErrorDefine.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>


@implementation WDTNDataProcessEncryption

/**
 加密
 
 @param data 输入格式：NSData
 
 @return 输出格式：NSData
 */
- (id)processData:(id)data error:(NSError **)error {
    NSData *result = nil;
    if ([data isKindOfClass:[NSData class]]) {
        result = [GLAESProvider AESEncrypt:data withPassphraseID:_passKeyId];
        if (nil == result) {
            // 加密失败
            NSString *keyid = [[GLAESPassphrase sharedManager] defaultAesPassphraseIDForCommon];
            result = [GLAESProvider AESEncrypt:data withPassphraseID:keyid];
        }
    }
    
    if (result == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:WDTNError_Encryption_failed_domain code:WDTNError_Encryption_failed userInfo:nil];
        }
    }
    return result;
}

@end
