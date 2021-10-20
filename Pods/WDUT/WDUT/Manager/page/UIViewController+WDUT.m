//
//  UIViewController+hook.m
//  WDUT
//
//  Created by WeiDian on 16/01/06.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+WDUT.h"
#import "WDUTManager.h"
#import "WDUTMethodSwizzle.h"
#import "WDUTMacro.h"

@implementation UIViewController (WDUT)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([WDUTConfig instance].utEnable) {
            SEL origSel_viewDidAppear = @selector(viewDidAppear:);
            SEL swizSel_viewDidAppear = @selector(wdutSwizzleViewDidAppear:);
            [WDUTMethodSwizzle swizzleInstanceMethod:origSel_viewDidAppear
                                    toInstanceMethod:swizSel_viewDidAppear
                                            forClass:[self class]];

            SEL origSel_viewDidDisappear = @selector(viewDidDisappear:);
            SEL swizSel_viewDidDisappear = @selector(wdutSwizzleViewDidDisappear:);
            [WDUTMethodSwizzle swizzleInstanceMethod:origSel_viewDidDisappear
                                    toInstanceMethod:swizSel_viewDidDisappear
                                            forClass:[self class]];
        }
    });
}

- (void)wdutSwizzleViewDidAppear:(BOOL)animated {
    WDUTLog(@"begin wdutSwizzleViewDidAppear:");

    [self wdutViewDidAppear];
    [self wdutSwizzleViewDidAppear:animated];
}

- (void)wdutSwizzleViewDidDisappear:(BOOL)animated {
    WDUTLog(@"begin wdutSwizzleViewDidDisappear:");

    [self wdutViewDidDisappear];
    [self wdutSwizzleViewDidDisappear:animated];
}

- (void)wdutViewDidAppear {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWDUTViewDidAppearNotification
                                                        object:self];
}

- (void)wdutViewDidDisappear {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWDUTViewDidDisappearNotification
                                                        object:self];
}

@end
