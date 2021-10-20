//
//  GLActivityIndicatorView.h
//  GLUIKit
//
//  Created by Kevin on 15/10/15.
//  Copyright (c) 2015年 koudai. All rights reserved.
//



#import "GLView.h"


// BIT MASK Style setting
// 头俩个是黑主体还是白主体，最后一个bitmask代表是否是小图
// WDActivityIndicatorStyleBlack | WDActivityIndicatorStyleSmall = 黑色背景小图
// WDActivityIndicatorStyleBlack  = 黑色背景默认大图
typedef NS_OPTIONS(NSInteger, GLActivityIndicatorStyle)
{
    GLActivityIndicatorStyleWhite = 0x001,
    GLActivityIndicatorStyleBlack = 1 << 1,
    GLActivityIndicatorStyleSmall = 2 << 2
};


@interface GLActivityIndicatorView : GLView

@property (nonatomic, assign) GLActivityIndicatorStyle indicatorStyle;

- (instancetype)initWithFrame:(CGRect)frame style:(GLActivityIndicatorStyle) style;

- (void)startAnimating;

- (void)stopAnimating;

@end
