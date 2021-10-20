//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (WDUIKit)

@property(nonatomic, readonly) CGFloat wd_originX;
@property(nonatomic, readonly) CGFloat wd_originY;
@property(nonatomic, readonly) CGFloat wd_width;
@property(nonatomic, readonly) CGFloat wd_height;
@property(nonatomic, readonly) CGFloat wd_rightX;
@property(nonatomic, readonly) CGFloat wd_bottomY;

@property (nonatomic, readonly) CGFloat originX;
@property (nonatomic, readonly) CGFloat originY;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat rightX;
@property (nonatomic, readonly) CGFloat bottomY;

- (void)wd_setLeft:(CGFloat)left;

- (void)wd_setTop:(CGFloat)top;

- (void)wd_setWidth:(CGFloat)width;

- (void)wd_setHeight:(CGFloat)height;

- (void)wd_addBottomLineWithLineHeight:(CGFloat)lineHeight lineColor:(UIColor *)color;

@end
