//
//  UIView+GLFrame.h
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GLFrame)

@property (assign) CGFloat x;
@property (assign) CGFloat y;
@property (assign) CGFloat width;
@property (assign) CGFloat height;

/// 在父视图坐标系中，矩形框最远点的横坐标值
@property (assign,readonly) CGFloat maxX;

///在父视图坐标系中，矩形框最远点的纵坐标值
@property (assign,readonly) CGFloat maxY;

@property (assign) CGSize  size;

@property (assign) CGPoint orgin;


+ (CGFloat)viewHeight;

+ (CGFloat)viewWidth;

/**
 *  all subview call “removeFromSuperview”
 *  所有的subview都会从self中移除
 */
- (void)safeRemoveAllSubviews;

/**
 *  按照逆序，对所有的subview遍历
 *
 */
- (void)safeEnumerateSubviewsUsingBlock:(void (NS_NOESCAPE ^)(UIView* subview, BOOL *stop))block;

@end
