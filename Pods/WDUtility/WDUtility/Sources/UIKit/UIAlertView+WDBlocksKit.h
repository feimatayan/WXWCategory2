//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertView (WDBlocksKit)

+ (UIAlertView *)wd_showAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                         otherButtonTitles:(NSArray *)otherButtonTitles
                                   handler:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block;

+ (id)wd_alertViewWithTitle:(NSString *)title;

+ (id)wd_alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (id)wd_initWithTitle:(NSString *)title message:(NSString *)message;

- (NSInteger)wd_addButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (NSInteger)wd_setCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (void)wd_setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index;

- (void)wd_setCancelBlock:(void (^)(void))block;

@end