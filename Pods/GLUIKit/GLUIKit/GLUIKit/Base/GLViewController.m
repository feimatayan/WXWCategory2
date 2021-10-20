//
//  GLViewController.m
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLViewController.h"
#import <UIKit/UIKit.h>
#import "GLActivityIndicatorView.h"
#import "GLUIKitUtils.h"
#import "GLView+GLFrame.h"
#import "UIView+GLFrame.h"
#import "NSString+GLString.h"


@interface GLViewController ()<CAAnimationDelegate>
@property (nonatomic, copy) dispatch_block_t fadeInOutCompleteBlock;
@end

@implementation GLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}




- (UIBarButtonItem *)glLeftItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 30);
    [leftButton addTarget:self action:@selector(glGoBack) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"GLUIKit_btn_navi_back"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    // [UIImage imageNamed:@"WDIPh_btn_navi_back"]
//    leftButton.backgroundColor = [UIColor greenColor];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftButtonItem;
}

- (void)glGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Loading Toast
#pragma mark -

const CGFloat kLoadingToastTag = 123321;
const CGFloat kLoadingToastModalTag = 123322;
const CGFloat kFadeInOutTag    = 123323;

/**************************************
 *
 * 在指定的界面显示indicator
 *
 *************************************/
- (void)showLoadingToast
{
    [self hideLoadingToast];
    
    UIView *tmp         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    // 这里保证loading的效果一直显示在最上层。
    tmp.layer.zPosition = NSIntegerMax;
    tmp.tag             = kLoadingToastTag;
    [self.view addSubview:tmp];
    
    BOOL isHidden      = [GLUIKitUtils currentNavigationController].navigationBarHidden;
    CGRect frame       = [UIApplication sharedApplication].statusBarFrame;
    CGFloat navBarMaxY = frame.size.height;
    if (NO == isHidden)
    {
        CGRect frame = [GLUIKitUtils currentNavigationController].navigationBar.frame;
        navBarMaxY += CGRectGetMaxY(frame);
    }
    
    
    CGPoint center       = CGPointMake(self.view.bounds.size.width / 2, 0);
    CGFloat viewHeight   = self.view.height;
    CGFloat windowHeight = [UIApplication sharedApplication].delegate.window.bounds.size.height;
    
    if (viewHeight == windowHeight - navBarMaxY) {
        // view 高度
        center.y = viewHeight / 2;
    }
    else {
        center.y = viewHeight / 2 - MAX((navBarMaxY - (windowHeight - viewHeight)), 0);
    }
    
    tmp.center = center;
    
    // 半透明
    UIView *semi            = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                       tmp.frame.size.width,
                                                                       tmp.frame.size.height)];
    semi.backgroundColor    = [UIColor blackColor];
    semi.alpha              = 0.6;
    semi.layer.cornerRadius = 10;
    [tmp addSubview:semi];
    
    
    CGFloat offx = (tmp.frame.size.width - 34) / 2;
    CGFloat offy = (tmp.frame.size.height - 34) / 2 - 8;
    GLActivityIndicatorView *indicator = [[GLActivityIndicatorView alloc] initWithFrame:CGRectMake(offx,
                                                                                                   offy,
                                                                                                   34,
                                                                                                   34)];
    CGFloat offsetY                    = indicator.frame.origin.y + 36;
    UILabel *loadingLabel              = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                                   offsetY,
                                                                                   semi.frame.size.width, 20)];
    loadingLabel.backgroundColor       = [UIColor clearColor];
    loadingLabel.text                  = @"正在加载";
    loadingLabel.textAlignment         = NSTextAlignmentCenter;
    loadingLabel.textColor             = [UIColor whiteColor];
    loadingLabel.font                  = [GLUIKitUtils transferToiOSFontSize:20];
    [tmp addSubview:loadingLabel];
    [tmp addSubview:indicator];
    [indicator startAnimating];
}

/**********************************************
 *
 * 隐藏indicator
 *
 **********************************************/
- (void)hideLoadingToast
{
    [[self.view viewWithTag:kLoadingToastTag] removeFromSuperview];
}


/**********************************************
 *
 * 在指定的view中显示淡入淡出的tip view
 *
 * @param tip  tip内容
 * @param duration 持续时间
 *
 **********************************************/
- (void)showFadeInOutTipView:(NSString *)tip withDuration:(CGFloat)duration
{
    UIView *toastView = [self.view viewWithTag:kFadeInOutTag];
//    if (toastView && [tip isEqualToString:_commonExclusiveString]) {
//        return ;
//    }
//    else {
//        self.commonExclusiveString = tip;
//    }
    
    if (toastView) return;
    
    toastView = [self toastWithActivityIndicator:NO tip:tip];
    toastView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 20);
    toastView.layer.zPosition = NSIntegerMax;
    toastView.tag = kFadeInOutTag;
    [self.view addSubview:toastView];
    
    
    CABasicAnimation *basic1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basic1.fromValue = [NSNumber numberWithFloat:0];
    basic1.toValue = [NSNumber numberWithFloat:1];
    basic1.duration = 0.5;
    basic1.removedOnCompletion = NO;
    basic1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basic2.fromValue = [NSNumber numberWithFloat:1];
    basic2.toValue   = [NSNumber numberWithFloat:0];
    basic2.duration  = 0.5;
    basic2.beginTime = 2.5;
    basic2.removedOnCompletion = NO;
    basic2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[basic1,basic2];
    group.delegate   = self;
    group.duration   = 3;
    group.fillMode   = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [toastView.layer addAnimation:group forKey:nil];
}

- (UIView *)toastWithActivityIndicator:(BOOL)showIndicator  tip:(NSString *)tip
{
    CGFloat marginLeft = 30, marginTop = 25;
    CGFloat titleWidth = 240 - 2 * marginLeft;
    UIFont *font  = [UIFont systemFontOfSize:15];
    CGSize size   = [tip glSizeWithFont:font constrainedToSize:CGSizeMake(titleWidth, 10000)];
    CGFloat width = MIN(size.width, titleWidth) + 2*marginLeft;
    
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 半透明
    CALayer *semiLayer = [CALayer layer];
    semiLayer.backgroundColor = [UIColor blackColor].CGColor;
    semiLayer.opacity = 0.6;
    semiLayer.cornerRadius = 10;
    [toastView.layer addSublayer:semiLayer];
    
    CGFloat offsetY = marginTop;
    
    //菊花
    if (showIndicator) {
        CGFloat indicatorWidth = 22;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.center = CGPointMake(width/2, marginTop + indicatorWidth/2);
        [toastView addSubview:indicator];
        [indicator startAnimating];
        
        offsetY += indicatorWidth + 10;
    }
    
    //Tip
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(marginLeft, offsetY, MIN(size.width, titleWidth), ceilf(size.height))];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines   = 0;
    label.text = tip;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [toastView addSubview:label];
    
    //修改frame
    offsetY += ceilf(size.height);
    offsetY += marginTop;
    semiLayer.frame = CGRectMake(0, 0, width, offsetY);
    toastView.frame = CGRectMake(0, 0, width, offsetY);
    
    return toastView;
}

/***
 *
 *  动画组完成时的回调
 *
 ***/
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isKindOfClass:[CAAnimationGroup class]]) {
        UIView *av = [self.view viewWithTag:kFadeInOutTag];
        [av removeFromSuperview];
        
        if (self.fadeInOutCompleteBlock) {
            self.fadeInOutCompleteBlock();
        }
        
        [self removeModalView];
    }
}

- (void)removeModalView
{
    [[self.view viewWithTag:kLoadingToastModalTag] removeFromSuperview];
    
}

@end
