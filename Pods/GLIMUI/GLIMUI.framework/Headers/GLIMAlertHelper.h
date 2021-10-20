//
//  GLMAlertHelper.h
//  GLIMSDK
//
//  Created by Acorld on 15-4-26.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
typedef NS_OPTIONS(NSInteger, GLMAlertStyle)
{
    GLMAlertStyleViewAlert,
    GLMAlertStyleViewActionSheet
};
typedef void(^GLMAlertViewCancelBlock)();
typedef void(^GLMAlertViewClickBlock)(NSInteger clickedIndex);
@interface GLIMAlertHelper : NSObject

+ (GLIMAlertHelper *)sharedAlertHelper;
/**
 *  @author Acorld, 15-04-26
 *
 *  @brief  展示弹出框
 *
 *  param title              标题
 *  param message            内容
 *  param ifIsIpadIsNeedView 如果是ipad，必传
 *  param cancleTitle        取消按钮文案
 *  param otherButtonTitles  其他按钮
 */
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                            view:(UIView *)ifIsIpadIsNeedView
                    cancleButton:(NSString *)cancleTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              cancleButton:(NSString *)cancleTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

/**
 *  @author Acorld, 15-04-26
 *
 *  @brief  注册弹出框回执监听
 *
 *  @param cancelBlock 取消
 *  @param clickBlock  其他点击
 */
- (void)addCallBackBlockWithCancel:(GLMAlertViewCancelBlock)cancelBlock didClick:(GLMAlertViewClickBlock)clickBlock;

@end

