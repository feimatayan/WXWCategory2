//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (WDUIKit)

@property(nonatomic, copy) NSDictionary *params;

+ (UIButton *)wd_buttonWithColor:(UIColor *)color
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor;

- (void)wd_centerImageAndTitle:(CGFloat)spacing;
- (void)wd_titleLeftAndImageRight:(CGFloat)spacing
                       titleWidth:(CGFloat)titleWidth
                       imageWidth:(CGFloat)imageWidth;
- (void)wd_imageLeftAndTitleRight:(CGFloat)spacing
                  imageLeftMargin:(CGFloat)imageLeftMargin
                       titleWidth:(CGFloat)titleWidth
                       imageWidth:(CGFloat)imageWidth;
- (void)wd_addBorderLine;

/// 移除所有的响应对象
- (void)wd_removeAllTargets;

@end
