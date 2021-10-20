//
//  GLIMSDKUtil.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/15.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

//  dispatch_async(dispatch_get_main_queue(), ^{
#define dispatch_im_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_im_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


@interface GLIMSDKUtil : NSObject

+ (NSString*)nonnullString:(NSString*)str;

+ (NSString*)stringForJsonObject:(id)object;
+ (id)jsonObjectFromString:(NSString*)str;


+ (NSString *)getCombinationTimeUrl:(NSString*)sourceUrl;

/// 检查网络是否不可达，YES 网络有问题
+ (BOOL)isNetworkNotReachable;

@end
