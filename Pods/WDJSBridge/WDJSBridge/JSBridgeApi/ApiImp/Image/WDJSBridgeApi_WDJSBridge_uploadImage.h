//
// Created by 石恒智 on 2018/12/9.
// Copyright (c) 2018 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDJSBridgeBaseApi.h"

@interface WDJSBridgeApiUploadImageCompressDO : NSObject
@property(nonatomic, assign) NSInteger size;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@end

@interface WDJSBridgeApiUploadImageControlDO : NSObject
@property(nonatomic, copy) NSString *scope;
@property(nonatomic, copy) NSString *fileType;
@property(nonatomic, assign) BOOL unadjust;
@property(nonatomic, assign) BOOL isPrivate;
@end

@interface WDJSBridgeApiUploadImagedataDO : NSObject
@property(nonatomic, copy) NSString *base64DataString;
@property(nonatomic, strong) NSArray<NSString *> *localPathUrlArray;
@end

@interface WDJSBridgeApi_WDJSBridge_uploadImage : WDJSBridgeBaseApi
@end