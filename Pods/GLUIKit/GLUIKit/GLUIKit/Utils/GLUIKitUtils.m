//
//  GLUIKitUtils.m
//  GLUIKit
//
//  Created by Kevin on 15/10/9.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLUIKitUtils.h"


@implementation GLUIKitUtils

+ (UIFont *)transferToiOSFontSize:(CGFloat)oriFontSize
{
    CGFloat sizeOffset = 1.5;
    
    if (GLUIKIT_IOS_VERSION < 7.0){
    
        sizeOffset = -0.5;
    }
    return [UIFont systemFontOfSize:oriFontSize * 0.5 + sizeOffset];
}

+ (UIBarButtonItem *)leftBarButtonItemWithTarget:(id)target
                                        selector:(SEL)selector
                                        andTitle:(NSString*)title
{
    CGRect frame = CGRectMake((GLUIKIT_IOS_VERSION < 7.0) ? 0 : 0, 0, 50, 44);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    UIImage *backgroundImage = [UIImage imageNamed:@"GLUIKit_btn_navi_back"];
    
    [button setImage:backgroundImage forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:GLUIKIT_COLOR_DISABLED_BUTTON_TEXT forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    CGRect tempF  = CGRectMake(0, 0, 70, 44);
    UIView *tempV = [[UIView alloc] initWithFrame:tempF];
    [tempV addSubview:button];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:tempV];
    
    return item;
}

+ (UIBarButtonItem *)rightBarButtonItemWithTarget:(id)target
                                        selector:(SEL)selector
                                           image:(id)image
                                        andTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(!(GLUIKIT_IOS_VERSION < 7.0) ? 0 : 40, 0, 60, 44);
    
    BOOL needResize = YES;
    UIImage *bgimg  = nil;
    if([image isKindOfClass:[UIImage class]]) {
        
        bgimg = (UIImage *)image;
    }
    else if ([image isKindOfClass:[NSString class]]){
        
        NSString *imgName = image;
        
        if (imgName.length == 0) {
            
            // use default image
            needResize = NO;
//            bgimg = [UIImage imageNamed:@"WDIPh_btn_navi_right22.png"];
        }
    }
    
    if (bgimg == nil) {
        bgimg = [UIImage imageNamed:image];
    };
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:GLUIKIT_COLOR_DISABLED_BUTTON_TEXT forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    button.tag = TAG_FOR_NAVITEM_BUTTON;
    
    if (needResize) {
        
        CGRect dstFrame   = button.frame;
        dstFrame.origin.x = 0;
        dstFrame.origin.y = 0;
        [button setImage:bgimg forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        
        CGSize size = bgimg.size;
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (title.length == 0 && bgimg) {
            
            [button setTitle:title forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, button.bounds.size.width-size.width, 0, 0);
        }
    }
    else {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}


+ (UINavigationController*)currentNavigationController {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    UINavigationController *navCtrl =  (UINavigationController *)keyWindow.rootViewController;
    
    if ([navCtrl isKindOfClass:[UINavigationController class]]) {
        return navCtrl;
    }
    else {
        return nil;
    }
}

@end
