//
// Created by 石恒智 on 2018/6/4.
// Copyright (c) 2018 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString const* kWDJSBridgeDefaultURLPattern;

@interface WDJSBridgeURLWhiteListEngine : NSObject

+ (BOOL)isURLTrusted:(NSURL *)url withURLPattern:(nullable NSString *)urlPattern;
@end
