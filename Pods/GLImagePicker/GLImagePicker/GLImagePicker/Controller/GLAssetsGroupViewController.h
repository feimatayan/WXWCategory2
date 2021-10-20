//
//  GLAssetsGroupViewController.h
//  WDCommlib
//
//  Created by xiaofengzheng on 12/16/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#import <GLUIKit/GLUIKit.h>
#import "GLFetchImageController.h"

@class GLFetchImageConfig;

@interface GLAssetsGroupViewController : GLViewController


/// 最大选择数
@property (nonatomic, assign) NSInteger     maxSelectedCount;
/// 完成回调
@property (nonatomic, copy) finishPickBlock finishBlock;
/// 取消回调
@property (nonatomic, copy) cancelPickBlock cancelBlock;

/// 如果图片是gif，是否显示gif标
@property (nonatomic,assign) BOOL showGif;

@property (nonatomic, strong) GLFetchImageConfig *config;

@end
