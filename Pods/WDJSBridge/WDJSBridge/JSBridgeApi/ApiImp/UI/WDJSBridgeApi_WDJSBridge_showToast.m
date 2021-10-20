//
//  WDJSBridgeApi_WDJSBridge_showToast.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#define TAG_LoadingView 176671
#define kToastDurationLong  2.0
#define kToastDurationShort 1.0

#import "WDJSBridgeApi_WDJSBridge_showToast.h"
#import "WDJSBridgeApiUtils.h"

@implementation WDJSBridgeApi_WDJSBridge_showToast

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	if(!self.content || self.content.length <= 0) {
		callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"提示内容为空"});
		return;
	}
	
	UIView *webView = [WDJSBridgeApiUtils jsbridge_topViewController].view;
	if(!webView) {
		callback(WDJSBridgeHandlerResponseCodeFailure, nil);
		return;
	}
	
	UIView *toastView = [webView viewWithTag:TAG_LoadingView];
	if(toastView) {
		[toastView removeFromSuperview];
	}
	NSString *tip = self.content == nil ? @"" : self.content;
	toastView = [self toastViewWithTip:tip];
	toastView.center = CGPointMake(webView.frame.size.width/2, webView.frame.size.height/2 - 20);
	[webView addSubview:toastView];
	
	NSTimeInterval time = kToastDurationLong;
	if(self.duration && self.duration.length > 0) {
		if([self.duration integerValue] > 0)
		{
			time = kToastDurationLong;
		} else {
			time = kToastDurationShort;
		}
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[UIView transitionWithView:webView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			toastView.hidden = YES;
		} completion:^(BOOL finished) {
			[toastView removeFromSuperview];
		}];
	});
	
	callback(WDJSBridgeHandlerResponseCodeSuccess, nil);
}

- (UIView *)toastViewWithTip:(NSString *)tip
{
	CGFloat marginLeft = 30, marginTop = 25;
	CGFloat titleWidth = 240 - 2*marginLeft;
	UIFont *font = [UIFont systemFontOfSize:15];
	CGSize size = [tip boundingRectWithSize:CGSizeMake(titleWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin
								 attributes:@{NSFontAttributeName : font} context:nil].size;
	CGFloat width = MIN(size.width, titleWidth) + 2*marginLeft;
	
	UIView *toastView = [[UIView alloc] initWithFrame:CGRectZero];
	
	// 半透明
	CALayer *semiLayer = [CALayer layer];
	semiLayer.backgroundColor = [UIColor blackColor].CGColor;
	semiLayer.opacity = 0.6;
	semiLayer.cornerRadius = 10;
	[toastView.layer addSublayer:semiLayer];
	
	CGFloat offsetY = marginTop;
	
	//Tip
	UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(marginLeft, offsetY, MIN(size.width, titleWidth), ceilf(size.height))];
	label.backgroundColor = [UIColor clearColor];
	label.numberOfLines = 0;
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
	
	toastView.tag = TAG_LoadingView;
	toastView.layer.zPosition = NSIntegerMax;
	
	return toastView;
}


@end
