//
//  GLAlertViewController.h
//  GLUIKit
//
//  Created by Kevin on 15/10/14.
//  Copyright (c) 2015年 koudai. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GLViewController.h"



/***********************************
 *
 * 集成了AlertView和ActionSheet
 * 并且兼容了 < iOS8 的情况
 *
 **********************************/

typedef NS_OPTIONS(NSInteger, GLAlertViewStyle)
{
    GLAlertViewStyleAlert,
    GLAlertViewStyleActionSheet
};

typedef void(^GLAlertViewClickBlock)(NSUInteger clickedIndex);


@interface GLAlertViewController : GLViewController<UIAlertViewDelegate, UIActionSheetDelegate>

/// 是否强制使用NSAlertView，默认NO
@property (nonatomic, assign) BOOL useNSAlertView;

@property (nonatomic, copy) NSString *alertTitle;

@property (nonatomic, copy) NSString *alertMessage;

@property (nonatomic, assign) GLAlertViewStyle style;

@property (nonatomic, assign) NSUInteger alertTag;

- (id)initWithStyle:(GLAlertViewStyle)style title:(NSString *)title msg:(NSString *)msg;

- (void)show:(UIView *)iPadSourceView;
/**
 *  if is iphone,iOS8 later is present a viewController
 *
 */
- (void)show;

+ (BOOL)hasShow;

+ (NSUInteger)lastAlertTag;

- (void)addButtonWithIndex:(NSUInteger)index
                     title:(NSString *)title
                clickBlock:(GLAlertViewClickBlock)clickBlock;

/**
 *  @author Acorld, 15-01-31
 *
 *  @brief  添加取消按钮
 *
 *  @param title      取消按钮文案
 *  @param clickBlock 点击回执
 */
- (void)addCancelButtonWithTitle:(NSString *)title
                      clickBlock:(GLAlertViewClickBlock)clickBlock;



@end
