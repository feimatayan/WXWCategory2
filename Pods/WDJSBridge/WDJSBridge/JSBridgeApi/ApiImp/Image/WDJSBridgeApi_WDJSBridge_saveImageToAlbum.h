//
//  WDJSBridgeApi_WDJSBridge_saveImageToAlbum.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/27.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 保存图片到相册
 */
@interface WDJSBridgeApi_WDJSBridge_saveImageToAlbum : WDJSBridgeBaseApi

// 图片的网络路径（必须）
@property (nonatomic, copy) NSString *url;

@end
