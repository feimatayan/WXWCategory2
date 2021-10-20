//
//  WDJSBridgeApi_WDJSBridge_callSMS.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_callSMS.h"
#import <MessageUI/MessageUI.h>
#import "WDJSBridgeApiUtils.h"
#import "WDJSBridgeLogger.h"

@interface WDJSBridgeApi_WDJSBridge_callSMS () <MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) NSObject *strongSelf;
@property (nonatomic, copy) WDJSBridgeHandlerCallback callBackBlock;
@end

@implementation WDJSBridgeApi_WDJSBridge_callSMS

- (void)dealloc{
    WDJSBridgeLog(@"dealloc");
}
- (void)callApiWithContextInfo:(NSDictionary<NSString *, id> *)info callback:(WDJSBridgeHandlerCallback)callback {

//    if (!self.phoneNumbers || self.phoneNumbers.length <= 0) {
//        callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"invalid phone numbers"});
//        return;
//    }

    NSArray *numbers = [self.phoneNumbers componentsSeparatedByString:@";"];
    _callBackBlock = callback;
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.recipients = numbers;
        picker.body = self.content;
        picker.messageComposeDelegate = self;
        self.strongSelf = self;
        UIViewController *topVC = [WDJSBridgeApiUtils jsbridge_topViewController];
        if (topVC) {
            [topVC presentViewController:picker animated:YES completion:nil];

        } else {
            callback(WDJSBridgeHandlerResponseCodeFailure, nil);
        }

    } else {
        callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"can not send text"});
    }

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {

    switch (result) {
        case MessageComposeResultCancelled: {
            WDJSBridgeLog(@"message cancelled");
            break;
        }
        case MessageComposeResultSent: {
            WDJSBridgeLog(@"message Sent");
            break;
        }
        case MessageComposeResultFailed: {
            WDJSBridgeLog(@"message Failed");
            break;
        }
    }

    // Close the Mail Interface
    WDJSBridgeHandlerCallback localCallBackBlock = [_callBackBlock copy];
    _callBackBlock = nil;
    self.strongSelf = nil;
    [controller dismissViewControllerAnimated:YES completion:^{
        WDJSBridgeHandlerCallback callBackBlock = localCallBackBlock;
        if(callBackBlock){
            callBackBlock(WDJSBridgeHandlerResponseCodeSuccess, nil);
        }
    }];


}

@end
