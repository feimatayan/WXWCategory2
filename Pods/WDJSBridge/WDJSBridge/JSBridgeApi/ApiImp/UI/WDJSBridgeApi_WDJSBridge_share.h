//
//  WDJSBridgeApi_WDJSBridge_share.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 调用分享功能
 */
@interface WDJSBridgeApi_WDJSBridge_share : WDJSBridgeBaseApi

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *cmd;

@property (nonatomic, copy) NSString *content_ext;

@property (nonatomic, copy) NSString *scene;

@end
