//
//  WDTNNetwrokErrorDefine.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/30.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef WDTNNetwrokErrorDefine_h
#define WDTNNetwrokErrorDefine_h

// 网络库的错误码范围：[7980000,7990000)

// 请求时错误
static const NSInteger WDTNError_URL_illegal              = 7980100;
static const NSInteger WDTNError_Compression_failed       = 7980101;
static const NSInteger WDTNError_Encryption_failed        = 7980102;

// 响应时错误
static const NSInteger WDTNError_HttpStatusCode_illegal   = 7980200;

static const NSInteger WDTNError_Decryption_failed        = 7980300;
static const NSInteger WDTNError_Decompression_failed     = 7980301;
static const NSInteger WDTNError_JsonParse_failed         = 7980302;

// 错误说明
static NSString *const WDTNError_URL_illegal_domain = @"url创建失败";
static NSString *const WDTNError_Compression_failed_domain = @"压缩失败";
static NSString *const WDTNError_Encryption_failed_domain = @"加密失败";

static NSString *const WDTNError_Decryption_failed_domain = @"解密失败";
static NSString *const WDTNError_Decompression_failed_domain = @"解压失败";
static NSString *const WDTNError_JsonParse_failed_domain = @"response json解析失败";

#endif /* WDTNNetwrokErrorDefine_h */
