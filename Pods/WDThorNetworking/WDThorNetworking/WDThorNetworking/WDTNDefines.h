//
//  WDTNDefines.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#ifndef WDTNDefines_h
#define WDTNDefines_h

#import <Foundation/Foundation.h>

#define WDTHOR_SDK_VERSION          @"1.4.3.3"
#define WDTHOR_NETWORKING_VERSION   @"2.0"

typedef void (^WDTNRequestSuccessBlock)(NSDictionary *result, NSURLResponse *response); ///< 请求成功时回调
typedef void (^WDTNRequestFailureBlock)(NSError *error, NSURLResponse *response); ///< 请求失败时回调

typedef void (^WDTNReqResSuccessBlock)(NSDictionary *result, NSURLResponse *response, NSURLRequest *request); ///< 请求成功时回调，new
typedef void (^WDTNReqResFailureBlock)(NSError *error, NSURLResponse *response, NSURLRequest *request); ///< 请求失败时回调，new

FOUNDATION_EXPORT NSString * const WDTNRequestConfigForHTTP;

FOUNDATION_EXPORT NSString * const WDTNRequestConfigForProxy;

FOUNDATION_EXPORT NSString * const WDTNRequestConfigForCommon;

FOUNDATION_EXPORT NSString * const WDTNRequestConfigForUpgrade;

FOUNDATION_EXPORT NSString * const WDTNRequestConfigForThor;

FOUNDATION_EXPORT NSString * const WDTNRequestConfigForThorPre;

FOUNDATION_EXPORT NSString * const WDTNRequestConfigForThorTest;

extern dispatch_queue_t wdtn_create_default_queue(const char * label, long identifier);

#endif /* WDTNDefines */
