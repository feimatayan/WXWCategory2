//
//  GLFetchImageController.h
//  WDCommlib
//
//  Created by xiaofengzheng on 12/16/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLFetchImageAsset.h"

@class GLFetchImageConfig;

/// 完成回调 array obj GLFetchImageAsset
typedef void(^finishPickBlock)(NSArray <GLFetchImageAsset *>*);
/// 取消回调
typedef void(^cancelPickBlock)(void);



@interface GLFetchImageController : UINavigationController

/**
如果不设置 则使用默认配置
 */
@property (nonatomic, strong) GLFetchImageConfig *config;

/**
 *  初始化一个实例
 *
 *  @param maxCount 最多可选得图片数
 *
 *  @return 实例对象
 */
- (id)initWithMaxSelectedCount:(NSInteger)maxCount
                   finishBlock:(finishPickBlock)finishBlock
                   cancelBlock:(cancelPickBlock)cancelBlock;

/**
 *  初始化一个实例
 *
 *  @param maxCount 最多可选得图片数, showgif 是否显示gif
 *
 *  @return 实例对象
 */
- (id)initWithMaxSelectedCount:(NSInteger)maxCount
                       showGif:(BOOL)showGif
                   finishBlock:(finishPickBlock)finishBlock
                   cancelBlock:(cancelPickBlock)cancelBlock;
@end
