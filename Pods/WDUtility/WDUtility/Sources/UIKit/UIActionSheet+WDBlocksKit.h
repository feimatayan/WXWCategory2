//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIActionSheet (WDBlocksKit) <UIActionSheetDelegate>

+ (UIActionSheet *)wd_showActionSheetViewWithTitle:(NSString *)title
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                 otherButtonTitles:(NSArray *)otherButtonTitles
                                           handler:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block;

+ (id)wd_actionSheetWithTitle:(NSString *)title;

- (id)wd_initWithTitle:(NSString *)title;

- (NSInteger)wd_addButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (NSInteger)wd_setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (NSInteger)wd_setCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (void)wd_setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index;

@end