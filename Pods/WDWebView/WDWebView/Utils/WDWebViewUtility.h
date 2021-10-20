//
// Created by 石恒智 on 2017/12/25.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface WDWebViewUtility : NSObject

+ (NSString *)defaultUserAgent;

+ (UIViewController *)hostViewControllerFromView:(UIView *)view;

+ (BOOL)url:(NSURL *)url isMatchPattern:(NSString *)pattern;

+ (BOOL)openURL:(NSURL *)url responder:(UIResponder *)responder;
@end

NS_ASSUME_NONNULL_END
