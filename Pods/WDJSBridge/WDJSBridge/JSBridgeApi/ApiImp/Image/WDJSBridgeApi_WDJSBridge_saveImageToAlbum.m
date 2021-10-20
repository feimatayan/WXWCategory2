//
//  WDJSBridgeApi_WDJSBridge_saveImageToAlbum.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/27.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_saveImageToAlbum.h"

@interface WDJSBridgeApi_WDJSBridge_saveImageToAlbum ()

@property (nonatomic, assign) WDJSBridgeHandlerCallback theCallback;

@end

@implementation WDJSBridgeApi_WDJSBridge_saveImageToAlbum

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {

	// 暂未实现
	callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"暂未实现",kWDJSBridgeErrCodeKey:@(WDJSBridgeErrorNotYetRealized)});
//	if (!_url || _url.length <= 0) {
//		callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": @"-1"});
//		return;
//	}
//
//	NSURL *imageURL = [NSURL URLWithString:_url];
//	if (!imageURL) {
//		callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": @"-1"});
//		return;
//	}
//
//	__weak typeof (self) weak_self = self;
//	dispatch_async(dispatch_get_global_queue(0, 0), ^{
//		NSData *data = [NSData dataWithContentsOfURL:imageURL];
//		if (data) {
//			UIImage *image = [UIImage imageWithData:data];
//			if (image) {
//				weak_self.theCallback = callback;
//				UIImageWriteToSavedPhotosAlbum(image, weak_self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//			} else {
//				callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": @"-1"});
//			}
//		} else {
//			callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": @"-1"});
//		}
//	});
//
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	if (error) {
		if(self.theCallback) {
			self.theCallback(WDJSBridgeHandlerResponseCodeFailure, nil);
		}
	} else {
		if(self.theCallback) {
			self.theCallback(WDJSBridgeHandlerResponseCodeSuccess, @{@"result": @"0"});
		}
	}
}

@end
