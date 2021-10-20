//
//  GLActivityIndicatorView.m
//  GLUIKit
//
//  Created by Kevin on 15/10/15.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLActivityIndicatorView.h"



@interface GLActivityIndicatorView()

@property (nonatomic, weak) UIView *rotateView;

@end

@implementation GLActivityIndicatorView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_resumeAnimation:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_resumeAnimation:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        UIImage *loadingIcon = [UIImage imageNamed:@"GLUIKit_common_activitor_loading_icon_white"];
        UIView *fixedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 15, self.bounds.size.height - 19)];
        fixedView.layer.contents = (id) loadingIcon.CGImage;
        fixedView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        [self addSubview:fixedView];
        
        UIImage *outterCycle = [UIImage imageNamed:@"GLUIKit_common_activitor_outter_cycle_white"];
        UIView *animationView = [[UIView alloc] initWithFrame:self.bounds];
        animationView.layer.contents = (id) outterCycle.CGImage;
        _rotateView = animationView;
        [self addSubview:animationView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(GLActivityIndicatorStyle) style
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_resumeAnimation:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_resumeAnimation:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        
        
        
        _indicatorStyle = style;
        

        UIView *animationView = nil;
        
        if (style & GLActivityIndicatorStyleBlack) {
            animationView = [self _blackStyleView];
        }
        else if (style & GLActivityIndicatorStyleWhite) {
            animationView = [self _whiteStyleView];
        }

        _rotateView = animationView;
        if (nil != animationView ) {
            [self addSubview:animationView];
        }
    }
    
    return self;
}

- (UIView *)_blackStyleView
{
    CGFloat offsetWidth  = 15;
    CGFloat offsetHeight = 19;
    
    if (_indicatorStyle & GLActivityIndicatorStyleSmall) {
        offsetWidth  = 9;
        offsetHeight = 11;
    }
    
    UIImage *loadingIcon = [UIImage imageNamed:@"GLUIKit_common_activitor_loading_icon"];
    UIView *fixedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 self.bounds.size.width - offsetWidth,
                                                                 self.bounds.size.height - offsetHeight)];
    fixedView.layer.contents = (id) loadingIcon.CGImage;
    fixedView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self addSubview:fixedView];
    
    UIImage *outterCycle = [UIImage imageNamed:@"GLUIKit_common_activitor_outter_cycle"];
    UIView *animationView = [[UIView alloc] initWithFrame:self.bounds];
    animationView.layer.contents = (id) outterCycle.CGImage;
    return animationView;
}

- (UIView *)_whiteStyleView
{
    CGFloat offsetWidth  = 15;
    CGFloat offsetHeight = 19;
    
    if (_indicatorStyle & GLActivityIndicatorStyleSmall) {
        offsetWidth  = 9;
        offsetHeight = 11;
    }
    
    UIImage *loadingIcon = [UIImage imageNamed:@"GLUIKit_common_activitor_loading_icon_white"];
    UIView *fixedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 self.bounds.size.width - offsetWidth,
                                                                 self.bounds.size.height - offsetHeight)];
    fixedView.layer.contents = (id) loadingIcon.CGImage;
    fixedView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self addSubview:fixedView];
    
    UIImage *outterCycle = [UIImage imageNamed:@"GLUIKit_common_activitor_outter_cycle_white"];
    UIView *animationView = [[UIView alloc] initWithFrame:self.bounds];
    animationView.layer.contents = (id) outterCycle.CGImage;
    return animationView;
}

- (void)layoutSubviews
{
    
}

- (void)_resumeAnimation:(NSNotification *)aNotify
{
    CAAnimation *animation = [_rotateView.layer animationForKey:@"rotationAnimation"];
    if (animation == nil) {
        [self startAnimating];
    } else {
        [_rotateView.layer removeAnimationForKey:@"rotationAnimation"];
    }
    
}

- (void)startAnimating
{
    [self _startRotationOnView:_rotateView rotation:1 duration:1.7f repeat:10000];
}

- (void)_startRotationOnView:(UIView *)view
                    rotation:(NSInteger)rotation
                    duration:(CGFloat)duration
                      repeat:(CGFloat)repeat
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation             = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue   = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue     = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotation];
    rotationAnimation.duration    = duration;
    rotationAnimation.cumulative  = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating
{
    [self _stopRotationAnimation];
}

- (void)_stopRotationAnimation
{
    
    [_rotateView.layer removeAnimationForKey:@"rotationAnimation"];
}


@end
