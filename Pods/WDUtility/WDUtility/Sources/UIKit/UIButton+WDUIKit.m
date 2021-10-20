//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import "UIButton+WDUIKit.h"
#import <objc/runtime.h>
#import "UIColor+WDUIKit.h"
#import "UIView+WDAdditions.h"

static void *paramsKey = &paramsKey;

@implementation UIButton (WDUIKit)

@dynamic params;

+ (UIButton *)wd_buttonWithColor:(UIColor *)color
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = color;
    return button;
}

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, paramsKey);
}

- (void)setParams:(NSDictionary *)params {
    objc_setAssociatedObject(self, paramsKey, params, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)wd_centerImageAndTitle:(CGFloat)spacing {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height), 0.0);
}

- (void)wd_titleLeftAndImageRight:(CGFloat)spacing
                       titleWidth:(CGFloat)titleWidth
                       imageWidth:(CGFloat)imageWidth {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - spacing, 0, imageWidth + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
}

- (void)wd_imageLeftAndTitleRight:(CGFloat)spacing
                  imageLeftMargin:(CGFloat)imageLeftMargin
                       titleWidth:(CGFloat)titleWidth
                       imageWidth:(CGFloat)imageWidth {
    CGFloat leftMoveMargin = (self.width - titleWidth - imageWidth) / 2 - imageLeftMargin;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -leftMoveMargin + spacing, 0, leftMoveMargin - spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -leftMoveMargin, 0, leftMoveMargin);
}

- (void)wd_addBorderLine {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0];
    [self.layer setBorderWidth:0.5];
    [self.layer setBorderColor:WDColorWithRGB0X(0XBDBDBD).CGColor];
}

/// 移除所有的响应对象
- (void)wd_removeAllTargets {
    [self removeTarget:nil
                action:NULL
      forControlEvents:UIControlEventAllEvents];
}

@end
