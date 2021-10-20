//
//  WDIEImageCanvas.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/10.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WDIEDrawLineViewDelegate;
@class WDIEDrawLineView;
@class WDIETextLabel;

@interface WDIEImageCanvas : UIScrollView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong, readonly) WDIEDrawLineView *drawView;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (void)cleanLastLine;

/**
 开关画线功能
 */
- (void)enableDraw:(BOOL)enable;

/**
 设置画线颜色
 */
- (void)setDrawLineColor:(UIColor *)lineColor;

/**
 设置画线宽度
 @param lineWidth 默认4.0
 */
- (void)setDrawLineWidth:(CGFloat)lineWidth;

/**
 设置画线的代理
 */
- (void)setDrawLineViewDelegate:(id<WDIEDrawLineViewDelegate>)delegate;

/**
 生成画布上的图片
 */
- (UIImage *)generateImage;

/**
 恢复画布的ZoomScale
 */
- (void)resetZoomScale;


@end
