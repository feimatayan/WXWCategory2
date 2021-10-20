//
//  GLPinchImageScrollView.m
//  WDCommlib
//
//  Created by baoyuanyong on 15/10/15.
//  Copyright © 2015年 赵 一山. All rights reserved.
//

#define kLoadingTag         6666

#import "GLPinchableImageView.h"
#import "GLProgressHUD.h"

@interface GLPinchableImageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *mImageView;

@end

@implementation GLPinchableImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.delegate = self;
        [self setMinimumZoomScale:1.0];
        [self setMaximumZoomScale:3.0];
        [self setZoomScale:1.0];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self setContentSize:frame.size];
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        
        _mImageView = [[UIImageView alloc] initWithFrame:frame];
        _mImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_mImageView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame pinchImage:(UIImage *)image;
{
    if ((self = [self initWithFrame:frame]))
    {
        _mImageView.image = image;
    }
    
    return self;
}

- (void)setImage:(UIImage *)image
{
    self.zoomScale = 1;
    self.mImageView.image = image;
}

- (UIImage *)image
{
    return self.mImageView.image;
}

- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask
{
    self.mImageView.autoresizingMask = autoresizingMask;
}

- (UIViewAutoresizing)autoresizingMask
{
    return self.mImageView.autoresizingMask;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    self.mImageView.contentMode = contentMode;
}

- (UIViewContentMode)contentMode
{
    return self.mImageView.contentMode;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mImageView;
}


- (void)showProgressView:(CGFloat)progress
{
    if (![NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showProgressView:progress];
        });
        return;
    }
    GLProgressHUD *hud = (GLProgressHUD *)[self viewWithTag:kLoadingTag];
    if (!hud || hud.mode != GLProgressHUDModeText) {
        if (hud) {
            [hud removeFromSuperview];
            hud = nil;
        }
        hud      = [[GLProgressHUD alloc] initWithView:self];
        hud.tag  = kLoadingTag;
        hud.mode = GLProgressHUDModeText;
        hud.labelFont = [UIFont systemFontOfSize:15];
        hud.removeFromSuperViewOnHide = YES;
        [self addSubview:hud];
    } else {
        hud.mode = GLProgressHUDModeText;
        [hud.superview bringSubviewToFront:hud];
    }
    // 显示
    if (progress < 1.0) {
        hud.labelText = [NSString stringWithFormat:@"iCloud照片同步中(%zd%%)...",(NSInteger)(progress * 100)];
        [hud show:YES];
    } else {
        [hud hide:YES];
    }
}


- (void)hideProgressView
{
    if (![NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgressView];
        });
        return;
    }
    
    GLProgressHUD *hud = (GLProgressHUD *)[self viewWithTag:kLoadingTag];
    if (hud && hud.mode == GLProgressHUDModeText) {
        [hud hide:YES];
    }
}

@end
