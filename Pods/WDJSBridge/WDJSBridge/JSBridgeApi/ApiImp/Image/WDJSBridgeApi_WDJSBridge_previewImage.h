//
//  WDJSBridgeApi_WDJSBridge_previewImage.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 预览图片
 */
@interface WDJSBridgeApi_WDJSBridge_previewImage : WDJSBridgeBaseApi

// 图片路径数组，可以是网络图片，也可以是本地图片
@property (nonatomic, copy) NSArray *images;

@end
