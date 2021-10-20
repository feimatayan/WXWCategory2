//
//  WDJSBridgeLoadingView.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeLoadingView.h"
#import "WDJSBridgeBundleUtil.h"

@interface WDJSBridgeLoadingView ()

@property (nonatomic, strong) UIImageView *indicator;
@property (nonatomic, strong) UIImageView *rotateImageView;
@property (nonatomic, strong) UILabel * loadingLabel;
@property (nonatomic, copy)  NSString *loadingText;

@end

@implementation WDJSBridgeLoadingView

#pragma mark - Getter & Setter

- (void)setLoadingText:(NSString *)loadingText
{
	_loadingText = loadingText;
	self.loadingLabel.text = loadingText;
}


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		UIImage *indicatorImage = [WDJSBridgeBundleUtil imageFromBundleWithName:@"WDJSBridge_activitor_loading_icon_white"];
		_indicator = [[UIImageView alloc] initWithImage:indicatorImage];
		
		UIImage *rotateImage = [WDJSBridgeBundleUtil imageFromBundleWithName:@"WDJSBridge_activitor_outter_cycle_white"];
		_rotateImageView = [[UIImageView alloc] initWithImage:rotateImage];
		
		_loadingLabel = [UILabel new];
		_loadingLabel.font = [UIFont systemFontOfSize:11.5];
		_loadingLabel.textColor = [UIColor whiteColor];
		_loadingLabel.textAlignment = NSTextAlignmentCenter;
		
		[self addSubview:_indicator];
		[self addSubview:_rotateImageView];
		[self addSubview:_loadingLabel];
		
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

#pragma mark - Layout

- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGFloat w = self.bounds.size.width;
	CGFloat h = self.bounds.size.height;
	
	CGFloat offset = 0;
	if (self.loadingText) {
		offset = 8;
	}
	
	self.indicator.frame = (CGRect){0,0,19,16};
	self.rotateImageView.frame = (CGRect){0,0,34,34};
	self.rotateImageView.center = (CGPoint){w*0.5,h*0.5-offset};
	self.indicator.center = self.rotateImageView.center;
	
	CGFloat labelTop = self.rotateImageView.frame.origin.y + self.rotateImageView.frame.size.height + 2;
	self.loadingLabel.frame = (CGRect){0,labelTop,w,20};
}

- (void) drawRect:(CGRect)rect {
	// Drawing code
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
	[[UIColor colorWithWhite:0 alpha:0.6] set];
	[path fill];
}

#pragma mark - Private

- (void) startLoading {
	CABasicAnimation *ani = [CABasicAnimation animation];
	ani.keyPath = @"transform.rotation.z";
	ani.fromValue = 0;
	ani.toValue = @(M_PI*2);
	ani.duration = 1.7;
	ani.repeatCount = NSIntegerMax;
	[self.rotateImageView.layer addAnimation:ani forKey:@"rotationAnimation"];
}

- (void) stopLoading {
	if ([self.rotateImageView.layer animationForKey:@"rotationAnimation"]) {
		[self.rotateImageView.layer removeAnimationForKey:@"rotationAnimation"];
	}
}

#pragma mark - Public

static NSInteger kLoaddingViewTagId = 176670;

+ (void)showInView:(UIView *)view withText:(NSString *)text{
	
	WDJSBridgeLoadingView *exsistsLoading = [view viewWithTag:kLoaddingViewTagId];
	if (exsistsLoading) {
		[exsistsLoading stopLoading];
		[exsistsLoading removeFromSuperview];
	}
	
	CGFloat w = 100;
	CGFloat h = 100;
	
	CGFloat left = (view.frame.size.width - w)/2;
	left = (CGFloat)(ceilf((CGFloat)left));
	
	CGFloat top = (view.frame.size.height - h)/2;
	top = (CGFloat)(ceilf((CGFloat)top));
	
	WDJSBridgeLoadingView *loading = [[WDJSBridgeLoadingView alloc] initWithFrame:(CGRect){left,top,w,h}];
	loading.loadingText = text;
	[view addSubview:loading];
	[loading startLoading];
	loading.hidden = YES;
	loading.tag = kLoaddingViewTagId;

	[UIView transitionWithView:view duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		loading.hidden = NO;
	} completion:nil];
}


+ (void) hideInView:(UIView *)view {
	
	WDJSBridgeLoadingView *loadingView = [view viewWithTag:kLoaddingViewTagId];
	if (loadingView) {
		[UIView transitionWithView:view duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			loadingView.hidden = YES;
		} completion:^(BOOL finished) {
			[loadingView stopLoading];
			[loadingView removeFromSuperview];
		}];
	}
}


@end
