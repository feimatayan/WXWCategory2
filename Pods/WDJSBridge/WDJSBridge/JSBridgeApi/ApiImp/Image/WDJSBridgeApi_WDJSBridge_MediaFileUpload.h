//
// Created by 石恒智 on 2018/12/9.
// Copyright (c) 2018 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDJSBridgeBaseApi.h"

@interface WDJSBridgeApiMediaFileUploadCompressDO : NSObject
@property(nonatomic, assign) NSInteger size;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@end

@interface WDJSBridgeApiMediaFileUploadControlDO : NSObject
@property(nonatomic, copy) NSString *scope;
@property(nonatomic, copy) NSString *fileType;
@property(nonatomic, assign) BOOL unadjust;
@property(nonatomic, assign) BOOL isPrivate;
@end

@interface WDJSBridgeApiMediaFileUploadChooseDO : NSObject
@property(nonatomic, assign) NSInteger isCamera;
@property(nonatomic, assign) NSInteger limit;
@property(nonatomic, assign) NSUInteger ratio;
@end

@interface WDJSBridgeApiMediaFileUploadDataDO : NSObject
@property(nonatomic, copy) NSString *base64DataString;
@end

@interface WDJSBridgeApi_WDJSBridge_MediaFileUpload : WDJSBridgeBaseApi
@end
