//
//  WDTNDataProcessEncryption.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/10.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNDataProcessProtocol.h"

/**
 加密。
 输入类型：NSData,
 输出类型：NSData
 */
@interface WDTNDataProcessEncryption : NSObject <WDTNDataProcessProtocol>
/// 加密密钥map的key值;
@property (nonatomic, copy) NSString *passKeyId;
@end
