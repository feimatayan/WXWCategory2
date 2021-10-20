//
// Created by 石恒智 on 2017/12/20.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDWebView.h"

@interface WDWKWebViewManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *schmaHandlerClasses;

+ (WDWKWebViewManager *)instance;

@end

@interface __WDWKWebView : WDWebView

- (instancetype)initWithFrame:(CGRect)frame disableMenu:(BOOL)disableMenu disablePreviw:(BOOL)disablePreview;

@end
