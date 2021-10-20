//
//  WDTNDataProcessDecryption.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/10.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNDataProcessDecryption.h"
#import "WDTNNetwrokErrorDefine.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>


@implementation WDTNDataProcessDecryption

/**
 解密
 
 @param data 输入格式：NSData
 
 @return 输出格式：NSData
 */
- (id)processData:(id)data error:(NSError **)error {
    NSData *result = nil;
    if ([data isKindOfClass:[NSData class]]) {
        NSData *pass = [[GLAESPassphrase sharedManager] aesPassphraseByID:_passKeyId];
        result = [GLAESProvider AESDecrypt:data withPassphrase:pass];
    }
    
    if (result == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:WDTNError_Decryption_failed_domain code:WDTNError_Decryption_failed userInfo:nil];
        }
    }
    return result;
}

@end
