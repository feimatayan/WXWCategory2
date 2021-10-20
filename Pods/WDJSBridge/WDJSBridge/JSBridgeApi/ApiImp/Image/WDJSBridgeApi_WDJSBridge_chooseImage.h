//
//  WDJSBridgeApi_WDJSBridge_chooseImage.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 选择图片
 */
@interface WDJSBridgeApi_WDJSBridge_chooseImage : WDJSBridgeBaseApi

// type：0相册选择，1拍照，（可选，默认相册选择）
@property (nonatomic, copy) NSString *type;

// 图片宽度限制，（可选，默认无限制）
@property (nonatomic, copy) NSString *max_width;

// 图片压缩质量，（可选，默认不压缩）
@property (nonatomic, copy) NSString *quality;

// 选择图片的个数，（可选，默认最多9张，type=0相册选择时生效）
@property (nonatomic, copy) NSString *count;

@end
