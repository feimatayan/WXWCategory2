//
//  GLPinchImageScrollView.h
//  WDCommlib
//
//  Created by baoyuanyong on 15/10/15.
//  Copyright © 2015年 赵 一山. All rights reserved.
//


#import "GLScrollView.h"


@interface GLPinchableImageView : GLScrollView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic) UIViewContentMode contentMode;

@property (nonatomic) UIViewAutoresizing autoresizingMask;

/// view 唯一标识
@property (nonatomic, strong) id    viewIdentifier;


- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame pinchImage:(UIImage *)image;


- (void)showProgressView:(CGFloat)progress;

- (void)hideProgressView;




@end
