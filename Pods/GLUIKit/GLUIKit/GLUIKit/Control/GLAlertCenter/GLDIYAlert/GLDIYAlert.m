//
//  GLDIYAlert.m
//  GLUIKit
//
//  Created by smallsao on 2021/7/20.
//

#import "GLDIYAlert.h"
#import "GLUIKitUtils.h"
#import "GLDIYAlertViewController.h"

@interface GLDIYAlert ()

@end

@implementation GLDIYAlert

+ (void)show:(NSString *)title msg:(NSString *)msg content:(nullable UIView *)view actions:(NSArray *)actions {
    GLDIYAlertViewController *diyAlertVC = [[GLDIYAlertViewController alloc] init];
    diyAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    diyAlertVC.headline = title;
    diyAlertVC.msg = msg;
    diyAlertVC.vContent = view;
    diyAlertVC.actions = actions;
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    UIViewController *rootController = window.rootViewController;
    [rootController presentViewController:diyAlertVC animated:NO completion:nil];
}

@end
