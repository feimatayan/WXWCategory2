//
//  GLAlertCenter.m
//  GLUIKit
//
//  Created by smallsao on 2017/9/14.
//  Copyright © 2017年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLAlertCenter.h"

#import "GLUIKitUtils.h"
#import "LGAlertView.h"

#import "LGAlertView.h"
#import "UIView+GLFrame.h"
#import "GLDIYAlert.h"
#import "GLDIYActionSheet.h"

#import <objc/runtime.h>

@interface GLAlertCenter () <LGAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSString *aTitle;

@property (nonatomic, strong) NSString *aMsg;

@property (nonatomic, assign) GLAlertCenterStyle aStyle;

@property (nonatomic, strong) UIView *vContent;

@property (nonatomic, strong) NSMutableArray *actions;

/// 取消按钮响应事件
@property (copy) GLAlertCenterClickBlock cancelBlock;

@property (nonatomic, strong) NSString *cancelTitle;

@end

@implementation GLAlertCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _actions = [NSMutableArray array];
    }
    return self;
}

- (id)initWithStyle:(GLAlertCenterStyle)style title:(NSString *)title msg:(NSString *)msg {
    if (self = [self init]) {
        if (style == GLAlertCenterStyleActionSheet) {
            if (title && title.length == 0) {
                title = nil;
            }
            if (msg && msg.length == 0) {
                msg = nil;
            }
        }
        _aTitle = title;
        _aMsg = msg;
        _aStyle = style;
    }
    return self;
}

- (void)addButton:(nonnull NSString *)title clickBlock:(GLAlertCenterClickBlock)clickBlock {
    NSMutableDictionary *action = [NSMutableDictionary dictionary];
    [action setObject:title forKey:@"title"];
    if (clickBlock) {
        [action setObject:clickBlock forKey:@"action"];
    }
    [self.actions addObject:action];
}

- (void)addButton:(NSString *)title description:(NSString *)description clickBlock:(GLAlertCenterClickBlock)clickBlock {
    NSMutableDictionary *action = [NSMutableDictionary dictionary];
    [action setObject:title forKey:@"title"];
    if (description) {
        [action setObject:description forKey:@"description"];
    }

    if (clickBlock) {
        [action setObject:clickBlock forKey:@"action"];
    }
    [self.actions addObject:action];
}

- (void)addCancel:(NSString *)title clickBlock:(GLAlertCenterClickBlock)clickBlock {
    self.cancelBlock = clickBlock;
    self.cancelTitle = title;
}

- (void)add:(UIView *)content {
    self.vContent = content;
}

- (void)show {
    if (![[NSThread currentThread] isMainThread]) {
        GL_WEAK(self);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weak_self showAlert];
        });
    } else {
        [self showAlert];
    }
}

- (void)dealloc {
}

- (void)showAlert {
    if (self.aStyle == GLAlertCenterStyleAlert) {
        NSMutableArray *btnTitles = [[NSMutableArray alloc] init];
        for (NSDictionary *action in self.actions) {
            [btnTitles addObject:[action objectForKey:@"title"]];
        }
        [LGAlertView appearance].cancelOnTouch = NO;
        [[[LGAlertView alloc] initWithTitle:self.aTitle message:self.aMsg style:0 buttonTitles:btnTitles cancelButtonTitle:self.cancelTitle destructiveButtonTitle:nil delegate:self] showAnimated:YES completionHandler:nil];
    } else if (self.aStyle == GLAlertCenterStyleActionSheet) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:self.aTitle message:self.aMsg preferredStyle:UIAlertControllerStyleActionSheet];

        for (NSDictionary *tempAction in self.actions) {
            UIAlertAction *aa = [UIAlertAction actionWithTitle:[tempAction objectForKey:@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                GLAlertCenterClickBlock clickBlock = [tempAction objectForKey:@"action"];
                if (clickBlock) {
                    clickBlock();
                }
            }];
            [ac addAction:aa];
        }

        UIAlertAction *aa = [UIAlertAction actionWithTitle:self.cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }];
        [ac addAction:aa];

        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];

        UIViewController *rootController = window.rootViewController;
        UIViewController *showingViewController = nil;

        if ([rootController isKindOfClass:[UINavigationController class]]) {
            showingViewController = ((UINavigationController *)rootController).topViewController;
        } else {
            showingViewController = rootController;
        }

        if (GL_DEVICE_IPAD) {
            //作兼容，如果没有传值，默认window
            UIView *iPadSourceView = [[UIApplication sharedApplication].delegate window];

            UIPopoverPresentationController *ppc = [ac popoverPresentationController];
            ppc.sourceView = iPadSourceView;
            ppc.sourceRect = CGRectMake(iPadSourceView.frame.size.width / 2,
                                        iPadSourceView.frame.size.height, 0, 0);
            [showingViewController presentViewController:ac animated:YES completion:nil];
        } else {
            [showingViewController presentViewController:ac animated:YES completion:nil];
        }
    } else if (self.aStyle == GLAlertCenterStyleDIYAlert) {
        NSMutableArray *btns = [NSMutableArray arrayWithArray:self.actions];
        if (self.cancelTitle.length > 0) {
            [btns addObject:@{
                 @"title": self.cancelTitle,
                 @"action": self.cancelBlock,
            }];
        }
        [GLDIYAlert show:self.aTitle msg:self.aMsg content:self.vContent actions:btns];
    } else if (self.aStyle == GLAlertCenterStyleDIYActionSheet) {
        NSMutableArray *btns = [NSMutableArray arrayWithArray:self.actions];
        NSDictionary *cancel = nil;
        if (self.cancelTitle.length > 0) {
            cancel = @{
                @"title": self.cancelTitle,
                @"action": self.cancelBlock,
            };
        }

        [GLDIYActionSheet show:self.aTitle msg:self.aMsg content:self.vContent actions:btns cancel:cancel];
    } else {
    }
}

- (void)alertView:(nonnull LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title {
    if (index < self.actions.count) {
        GLAlertCenterClickBlock clickBlock = [[self.actions objectAtIndex:index] objectForKey:@"action"];
        if (clickBlock) {
            clickBlock();
        }
    }
}

- (void)alertViewCancelled:(nonnull LGAlertView *)alertView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
