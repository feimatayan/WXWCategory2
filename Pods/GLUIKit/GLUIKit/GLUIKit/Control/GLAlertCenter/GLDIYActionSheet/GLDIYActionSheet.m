//
//  GLDIYActionSheet.m
//  GLUIKit
//
//  Created by smallsao on 2021/7/22.
//

#import "GLDIYActionSheet.h"
#import "GLUIKitUtils.h"
#import "GLDIYActionSheetViewController.h"

@implementation GLDIYActionSheet

+ (void)show:(NSString *)title msg:(NSString *)msg content:(nullable UIView *)view actions:(NSArray *)actions cancel:(NSDictionary *)cancel {
    GLDIYActionSheetViewController *diyActionSheetVC = [[GLDIYActionSheetViewController alloc] init];
    diyActionSheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    diyActionSheetVC.headline = title;
    diyActionSheetVC.msg = msg;
    diyActionSheetVC.vContent = view;
    diyActionSheetVC.actions = actions;
    diyActionSheetVC.cancel = cancel;

    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    UIViewController *rootController = window.rootViewController;
    [rootController presentViewController:diyActionSheetVC animated:NO completion:nil];
}

@end
