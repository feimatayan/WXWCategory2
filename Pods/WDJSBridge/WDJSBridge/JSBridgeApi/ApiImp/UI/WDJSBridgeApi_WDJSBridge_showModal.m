//
//  WDJSBridgeApi_WDJSBridge_showModal.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_showModal.h"
#import "WDJSBridgeApiUtils.h"

@implementation WDJSBridgeApi_WDJSBridge_showModal

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {

	// 暂未实现
	callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"暂未实现",kWDJSBridgeErrCodeKey:@(WDJSBridgeErrorNotYetRealized)});
//	if([WDJSBridgeApiUtils jsbridge_isNullStr:_title] && [WDJSBridgeApiUtils jsbridge_isNullStr:_content]) {
//		callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey:  @"title与content不能同时为空"});
//		return;
//	}
//
//	if([WDJSBridgeApiUtils jsbridge_isNullStr:_cancelText] && [WDJSBridgeApiUtils jsbridge_isNullStr:_confirmText]) {
//			callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey:  @"cancelText与confirmText不能同时为空"});
//		return;
//	}
//
//	__block UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:_title message:_content preferredStyle:UIAlertControllerStyleAlert];
//
//	if(![WDJSBridgeApiUtils jsbridge_isNullStr:_cancelText]) {
//		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:_cancelText style:UIAlertActionStyleCancel handler:nil];
//		[alertCtrl addAction:cancelAction];
//	}
//
//	if(![WDJSBridgeApiUtils jsbridge_isNullStr:_confirmText]) {
//		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:_confirmText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//			[alertCtrl dismissViewControllerAnimated:YES completion:nil];
//			alertCtrl = nil;
//		}];
//		[alertCtrl addAction:confirmAction];
//	}
//
//	UIViewController *topVC = [WDJSBridgeApiUtils jsbridge_topViewController];
//	[topVC presentViewController:alertCtrl animated:YES completion:nil];
//
//	callback(WDJSBridgeHandlerResponseCodeSuccess, nil);
}

@end
