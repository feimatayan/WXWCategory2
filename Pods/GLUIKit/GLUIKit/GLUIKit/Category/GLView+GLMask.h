//
//  GLView+GLMask.h
//  GLUIKit
//
//  Created by smallsao on 2018/11/26.
//  Copyright © 2018 weidian. All rights reserved.
//

#import "GLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLView (GLMask)


/**
 添加阴影
 */
- (void)gl_addMask;


/**
 添加阴影

 @param color 颜色
 @param width 阴影宽度
 @param opacity 透明度
 */
- (void)gl_addMask:(UIColor *)color width:(CGFloat)width opacity:(CGFloat)opacity;



/**
 添加阴影

 @param color 颜色
 @param width 阴影宽度
 @param opacity 透明度
 @param x 偏移量x
 @param y 偏移量y
 */
- (void)gl_addMask:(UIColor *)color width:(CGFloat)width opacity:(CGFloat)opacity offsetX:(CGFloat)x offsetY:(CGFloat)y;

@end

NS_ASSUME_NONNULL_END
